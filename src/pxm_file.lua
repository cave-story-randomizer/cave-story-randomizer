local function readLittleEndian(file, bytes)
  local string = file:read(2)
  local bytes = string:byte()
  -- print(string, type(bytes), bytes)
  return bytes
end

-- https://gist.github.com/fdeitylink/3fded36e9187fe838eb18a412c712800
-- -=~ PXM File Data ~=-
--   maps must be minimum of 21x16
local function readPXM(filename)
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
