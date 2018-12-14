local C = Class:extend()

-- https://www.lua.org/manual/5.1/manual.html#5.7
-- w+: Update mode, all previous data is erased;
-- b:  Binary mode, forces Windows to save with Unix endings.
MODE_WRITE_ERASE_EXISTING = 'w+b'

local ITEM_DATA = require 'database.items'

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

local function _stringReplace(text, needle, replacement)
  local i = text:find(needle, 1, true)
  if i == nil then
    logWarning(('Unable to replace "%s" with "%s"'):format(needle, replacement))
    return text
  end
  local len = needle:len()
  local j = i + len - 1
  assert((i % 1 == 0) and (i > 0) and (i <= j), tostring(i))
  assert((j % 1 == 0), tostring(j))
  local a = text:sub(1, i - 1)
  local b = text:sub(j + 1)
  return a .. replacement .. b
end

function C:replaceItem(replacement)
  assert(self:hasUnreplacedItems())
  local original = table.remove(self._unreplaced)
  self._text = _stringReplace(self._text, original.command, replacement.command)
  self._text = _stringReplace(self._text, original.getText, replacement.getText)
  self._text = _stringReplace(self._text, original.displayCmd, replacement.displayCmd)

  local template = "[%s] %s -> %s"
  logNotice(template:format(self._mapName, original.name, replacement.name))
end

function C:writeTo(path)
  local encoded = self:_codec(self._text, 'encode')

  local filepath = lf.getSourceBaseDirectory() .. path
  logInfo('writing TSC to: ' .. filepath)

  local file, err = io.open(filepath, MODE_WRITE_ERASE_EXISTING)
  assert(err == nil, err)
  file:write(encoded)
  file:flush()
  file:close()
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
