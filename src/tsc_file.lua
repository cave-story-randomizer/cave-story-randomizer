local C = Class:extend()

-- local MODE_READ_BINARY = 'rb'
local MODE_WRITE_BINARY = 'wb'

function C:new(path)
  logInfo('reading TSC: ' .. path)

  local file = lf.newFile(path)
  assert(file:open('r'))

  local contents, size = file:read()
  self._text = self:_codec(contents, 'decode')

  assert(file:close())
  assert(file:release())
end

function C:writeTo(path)
  local encoded = self:_codec(self._text, 'encode')

  local tmpFile, err = io.open(path, MODE_WRITE_BINARY)
  assert(err == nil, err)
  tmpFile:write(encoded)
  tmpFile:flush()
  tmpFile:close()
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

local function stringReplace(text, needle, replacement)
  local i = text:find(needle, 1, true)
  if i == nil then
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

return C
