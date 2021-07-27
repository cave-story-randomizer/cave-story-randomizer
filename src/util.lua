local U = {}

-- https://www.lua.org/manual/5.1/manual.html#5.7
-- w+: Update mode, all previous data is erased;
-- b:  Binary mode, forces Windows to save with Unix endings.
MODE_WRITE_ERASE_EXISTING = 'w+b'

function U.writeFile(path, data)
  logDebug('writing file: ' .. path)

  local file, err = io.open(path, MODE_WRITE_ERASE_EXISTING)
  assert(err == nil, err)
  file:write(data)
  file:flush()
  file:close()
end

function U.eraseFile(path)
  logDebug('erasing file: ' .. path)

  local file, err = io.open(path, 'r')
  if file ~= nil then
    io.close(file)
    os.remove(path)
  end
end

return U
