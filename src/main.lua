require 'lib.strict'

VERSION = '0.8C'

Class   = require 'lib.classic'
_       = require 'lib.moses'

lf = love.filesystem
lg = love.graphics

U = require 'util'

require 'log'

local random = require 'randomizer'
local settings = require 'settings'
Randomizer = random()
Screen = require 'ui.draw'
Settings = settings()

local csdirectory

function love.load()
  Screen:setup()
  Settings:init()
  if Settings.settings.csdirectory ~= "" then
    Screen:setStatus("Cave Story folder found!")
    Randomizer:setPath(Settings.settings.csdirectory)
  else
    Screen:setStatus("Drag and drop your Cave Story folder here.")
  end
  Screen:draw()
end

local function recursiveWrite(path, name)
  local filesTable = lf.getDirectoryItems(path)
  lf.createDirectory(name)
  for i,v in ipairs(filesTable) do
    local file = path..'/'..v
    if lf.getInfo(file, 'file') ~= nil then
      local n
      lf.write(name..'/'..v, lf.read(file))
    elseif lf.getInfo(file, 'directory') ~= nil then
      recursiveWrite(file, name..'/'..v)
    end
  end
end

function love.directorydropped(path)
  local success = Randomizer:_mountDirectory(path)
  --Randomizer:_unmountDirectory(path)
  if success then
    recursiveWrite('mounted-data', 'csdata')
    Settings.settings.csdirectory = 'csdata'
    Settings:update()
    Randomizer:setPath('csdata')
    Screen:setStatus("Cave Story folder updated!")
  else
    Screen:setStatus("Could not find \"data\" subfolder.\n\nMaybe try dropping your Cave Story \"data\" folder in directly?")
  end
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.push('quit')
  end
end

function love.draw()
  Screen:draw()
end
