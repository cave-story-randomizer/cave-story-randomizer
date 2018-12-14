io.stdout:setvbuf("no")

require 'lib.strict'

local _       = require 'lib.moses'
local Serpent = require 'lib.serpent'

local lf = love.filesystem

local MODE_READ_BINARY = 'rb'
local MODE_WRITE_BINARY = 'wb'

function readLittleEndian(file, bytes)
  local string = file:read(2)
  local bytes = string:byte()
  -- print(string, type(bytes), bytes)
  return bytes
end

-- https://gist.github.com/fdeitylink/3fded36e9187fe838eb18a412c712800
-- -=~ PXM File Data ~=-
--   maps must be minimum of 21x16
function readPXM(filename)
  print('reading PXM: ' .. filename)
  local file = assert(io.open(filename, MODE_READ_BINARY))
  -- First three bytes are PXM, then 0x10.
  assert(file:read(3) == "PXM")
  assert(file:read(1):byte() == 0x10)

  -- Then 0x_map_length - 2 bytes
  -- Then 0x_map_height - 2 bytes
  local length = readLittleEndian(file, 2)
  local height = readLittleEndian(file, 2)
  print('length:', length)
  print('height:', height)

  -- Then 0x_map_tile_from_tileset for the rest of the file (numbered from 0, and going left to right, top to bottom) - 1 byte
  local tiles = {}
  for x = 1, length do
    tiles[x] = {}
  end
  for y = 1, height do
    for x = 1, length do
      tiles[x][y] = file:read(1):byte()
    end
  end
  -- Print result
  local XXX = 3
  for y = 1, height do
    local line = ""
    for x = 1, length do
      local tile = tiles[x][y]
      local len = string.len(tile)
      line = line .. string.rep(' ', XXX - len) .. tile
    end
    print(line)
  end
end

local ITEM_DATA = {
  -- Weapons
  wPolar = {
    name = "Polar Star",
    map = "Pole",
    getText = "Got the =Polar Star=!",
    command = "<AM+0002:0000",
    displayCmd = "<GIT0002",
  },
  -- Items
  iPanties = {
    name = "Curly's Panties",
    map = "CurlyS",
    -- getText = "Found =Curly's Underwear=.",
    getText = "Found =Curly's Panties=.",
    command = "<IT+0035",
    displayCmd = "<GIT1035",
  },
}

function stringReplace(text, needle, replacement)
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

function readTSC(filename, decodedFilename)
  print('reading TSC: ' .. filename)
  local file = assert(io.open(filename, MODE_READ_BINARY))
  local filesize = file:seek("end")
  local encodingCharPosition = math.floor(filesize / 2)
  file:seek("set", encodingCharPosition)
  local encodingChar = file:read(1):byte()
  print("  filesize", filesize)
  print("  encoding char:", encodingChar)
  print("  encoding char position:", encodingCharPosition)

  -- Decode
  local chars, len = {}, 0
  file:seek("set")
  for pos = 0, filesize - 1 do
    local byte = file:read(1):byte()
    if pos ~= encodingCharPosition then
      -- print(pos, encodingCharPosition)
      byte = (byte - encodingChar) % 256
      -- byte = byte - encodingChar
    end
    len = len + 1
    chars[len] = string.char(byte)
  end
  local decoded = table.concat(chars)

  local t = {}
  decoded:gsub(".",function(c) table.insert(t,c) end)
  -- for i, c in ipairs(t) do
  local near = 10
  for i = 1270 - near, 1270 + near do
    local c = t[i]
    print (i, c, chars[i])
    -- print(string.byte(chars[i]) == string.byte(c), string.byte(chars[i]), string.byte(c))
  end

  -- -- Replace
  -- decoded = stringReplace(decoded, ITEM_DATA.wPolar.command, ITEM_DATA.iPanties.command)
  -- decoded = stringReplace(decoded, ITEM_DATA.wPolar.getText, ITEM_DATA.iPanties.getText)
  -- decoded = stringReplace(decoded, ITEM_DATA.wPolar.displayCmd, ITEM_DATA.iPanties.displayCmd)

  -- Write
  -- return decoded
  local tmpFile, err = io.open(decodedFilename, MODE_WRITE_BINARY)
  assert(err == nil, err)
  tmpFile:write(decoded)
  tmpFile:flush()
  tmpFile:close()
end

function writeTSC(filename)
  print('writing TSC: ' .. filename)
  local file = assert(io.open(filename, MODE_READ_BINARY))
  local filesize = file:seek("end")
  local encodingCharPosition = math.floor(filesize / 2)
  file:seek("set", encodingCharPosition)
  local encodingChar = file:read(1):byte()
  file:seek("set", encodingCharPosition)
  print(file:read(1))
  -- local encodingChar = 32
  print("  filesize", filesize)
  print("  encoding char:", encodingChar)
  print("  encoding char position:", encodingCharPosition)

  -- Encode
  local chars, len = {}, 0
  file:seek("set")
  for pos = 0, filesize - 1 do
    local byte = file:read(1):byte()
    if pos ~= encodingCharPosition then
      byte = (byte + encodingChar) % 255
    end
    len = len + 1
    chars[len] = string.char(byte)
  end
  local decoded = table.concat(chars)

  -- Write
  local tmpFile, err = io.open('TestingEncoded.tsc', MODE_WRITE_BINARY)
  assert(err == nil, err)
  tmpFile:write(decoded)
  tmpFile:flush()
  tmpFile:close()
end

function love.load()
  -- readPXM('Pole.pxm')
  -- readTSC('Pole.tsc', 'Testing.tsc')
  -- writeTSC('Testing.tsc')
  -- readTSC('TestingEncoded.tsc', 'TestingDecoded.tsc')
end

function love.directorydropped(path)
  local success = lf.mount(path, 'data')
  assert(success)

  local items = lf.getDirectoryItems('/data')
  local containsStage = _.contains(items, 'Stage')
  assert(containsStage)
  local dirStage = '/data/Stage'

  -- local items = lf.getDirectoryItems(dirStage)
  -- print(Serpent.block(items))
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.push('quit')
  end
end

-- #0200
-- <KEY<FLJ1640:0201<FL+1640<SOU0022<CNP0200:0021:0000
-- <MSGOpened the chest.<NOD<GIT0002<AM+0002:0000<CLR
-- <CMU0010Got the =Polar Star=!<WAI0160<NOD<GIT0000<CLO<RMU
-- <MSG
-- From somewhere, a transmission...<FAO0004<NOD<TRA0018:0501:0002:0000

-- #0420
-- <KEY<DNP0420<MSG<GIT1035<IT+0035
-- Found Curly's Panties.<NOD<END
