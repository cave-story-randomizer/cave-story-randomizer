local C = Class:extend()

local ITEM_DATA = require 'database.items'

local OPTIONAL_REPLACES = {
  'Max health increased by ',
  'Max life increased by ',
  '<ACH0041', -- Cave Story+ only, trigger achievement.
}

function C:new(path)
  logInfo('reading TSC: ' .. path)

  local file = lf.newFile(path)
  assert(file:open('r'))

  local contents, size = file:read()
  self._text = self:_codec(contents, 'decode')

  assert(file:close())
  assert(file:release())

  -- Determine set of items which can be replaced later.
  self._unreplaced = {}
  self._mapName = path:match("^.+/(.+)$")
  for k, v in pairs(ITEM_DATA) do repeat
    if (v.map .. '.tsc') ~= self._mapName then
      break -- continue
    end
    local item = _.clone(v)
    table.insert(self._unreplaced, item)
  until true end
  self._unreplaced = _.shuffle(self._unreplaced)
end

function C:hasUnreplacedItems()
  return #self._unreplaced >= 1
end

function C:replaceItem(replacement)
  assert(self:hasUnreplacedItems())
  local key = self._unreplaced[#self._unreplaced].key
  self:replaceSpecificItem(key, replacement)
end

function C:replaceSpecificItem(originalKey, replacement)
  -- Fetch item with key matching originalKey.
  local original
  for index, item in ipairs(self._unreplaced) do
    if item.key == originalKey then
      original = item
      table.remove(self._unreplaced, index)
      break
    end
  end
  assert(original, 'No unreplaced item with key: ' .. originalKey)

  -- Log change
  local template = "[%s] %s -> %s"
  logNotice(template:format(self._mapName, original.name, replacement.name))

  -- Replace before.
  if original.replaceBefore then
    for needle, replacement in pairs(original.replaceBefore) do
      local wasChanged
      self._text, wasChanged = self:_stringReplace(self._text, needle, replacement, original.label)

      -- Log error if replace was not optional.
      if wasChanged == false then
        local wasOptional = false
        for _, pattern in ipairs(OPTIONAL_REPLACES) do
          if needle:find(pattern, 1, true) then
            wasOptional = true
            break
          end
        end
        if wasOptional == false then
          local template = 'Unable to replace [%s] "%s" with "%s".'
          logError(template:format(original.map, needle, replacement))
        end
      end
    end
  end

  -- Replace attributes.
  self:_replaceAttribute(original, replacement, 'command')
  self:_replaceAttribute(original, replacement, 'getText')
  self:_replaceAttribute(original, replacement, 'displayCmd')
  self:_replaceAttribute(original, replacement, 'music')
end

function C:_replaceAttribute(original, replacement, attribute)
  local originalTexts = original[attribute]
  if originalTexts == nil or originalTexts == '' then
    return
  elseif type(originalTexts) == 'string' then
    originalTexts = {originalTexts}
  end

  local replaceText = replacement[attribute] or ''
  if type(replaceText) == 'table' then
    replaceText = replaceText[1]
  end
  -- Fix: After collecting Curly's Panties or Chako's Rouge, music would go silent.
  if attribute == 'music' and replaceText == '' then
    replaceText = "<CMU0010"
  end

  -- Loop through each possible original value until we successfully replace one.
  for _, originalText in ipairs(originalTexts) do repeat
    if originalText == "" then
      break -- continue
    end
    local changed
    self._text, changed = self:_stringReplace(self._text, originalText, replaceText, original.label)
    if changed then
      return
    end
  until true end

  local logMethod = (attribute == 'command') and logError or logWarning
  local template = 'Unable to replace original "%s" for [%s] %s.'
  logMethod(template:format(attribute, original.map, original.name))
end

function C:_stringReplace(text, needle, replacement, label)
  local pStart, pEnd = self:_getLabelPositionRange(label)
  local i = text:find(needle, pStart, true)
  if i == nil then
    -- logWarning(('Unable to replace "%s" with "%s"'):format(needle, replacement))
    return text, false
  elseif i > pEnd then
    -- This is totally normal and can be ignored.
    -- logDebug(('Found "%s", but was outside of label.'):format(needle, replacement))
    return text, false
  end
  local len = needle:len()
  local j = i + len - 1
  assert((i % 1 == 0) and (i > 0) and (i <= j), tostring(i))
  assert((j % 1 == 0), tostring(j))
  local a = text:sub(1, i - 1)
  local b = text:sub(j + 1)
  return a .. replacement .. b, true
end

function C:_getLabelPositionRange(label)
  local labelStart, labelEnd

  -- Recursive shit for when label is a table...
  if type(label) == 'table' then
    labelStart, labelEnd = math.huge, 0
    for _, _label in ipairs(label) do
      local _start, _end = self:_getLabelPositionRange(_label)
      labelStart = math.min(labelStart, _start)
      labelEnd   = math.max(labelEnd,   _end)
    end
    return labelStart, labelEnd
  end

  assert(type(label) == 'string')
  assert(#label == 4)
  assert(tonumber(label) >= 1)
  assert(tonumber(label) <= 9999)

  local i = 1
  local labelPattern = "#%d%d%d%d\r\n"
  while true do
    local j = self._text:find(labelPattern, i)
    if j == nil then
      break
    end
    i = j + 1

    if labelStart then
      labelEnd = j - 1
      break
    end

    local _label = self._text:sub(j + 1, j + 4)
    if label == _label then
      labelStart = j
    end
  end

  if labelStart == nil then
    logError("Could not find label: " .. label)
    labelStart = 1
  end

  if labelEnd == nil then
    labelEnd = #self._text
  end

  return labelStart, labelEnd
end

function C:writePlaintextTo(path)
  logInfo('writing Plaintext TSC to: ' .. path)
  U.writeFile(path, self._text)
end

function C:writeTo(path)
  logInfo('writing TSC to: ' .. path)
  local encoded = self:_codec(self._text, 'encode')
  U.writeFile(path, encoded)
end

function C:_codec(text, mode)
  -- Create array of chars.
  local chars = {}
  text:gsub(".", function(c) table.insert(chars, c) end)

  -- Determine encoding char value
  local encodingCharPosition = math.floor(#chars / 2) + 1
  local encodingChar = chars[encodingCharPosition]:byte()
  if mode == 'decode' then
    encodingChar = encodingChar * -1
  elseif mode == 'encode' then
    -- OK!
  else
    error('Unknown codec mode: ' .. tostring(mode))
  end

  logDebug("  filesize", #chars)
  logDebug("  encoding char:", encodingChar)
  logDebug("  encoding char position:", encodingCharPosition)

  -- Encode or decode.
  for pos, char in ipairs(chars) do
    if pos ~= encodingCharPosition then
      local byte = (char:byte() + encodingChar) % 256
      chars[pos] = string.char(byte)
    end
  end
  local decoded = table.concat(chars)

  -- local t = {}
  -- decoded:gsub(".",function(c) table.insert(t,c) end)
  -- local near = 7
  -- for i = encodingCharPosition - near, encodingCharPosition + near do
  --   local c = t[i]
  --   logDebug(i, c, c:byte())
  -- end

  return decoded
end

return C
