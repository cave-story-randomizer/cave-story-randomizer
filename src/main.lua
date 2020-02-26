require 'lib.strict'

VERSION = '0.8C'

Class   = require 'lib.classic'
_       = require 'lib.moses'

lf = love.filesystem
lg = love.graphics
ld = love.data

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

local function recursivelyDelete( item )
  if lf.getInfo( item , "directory" ) then
      for _, child in ipairs( lf.getDirectoryItems( item )) do
          recursivelyDelete( item .. '/' .. child )
          lf.remove( item .. '/' .. child )
      end
  elseif lf.getInfo( item ) then
      lf.remove( item )
  end
  lf.remove( item )
end

function love.directorydropped(path)
  local success = Randomizer:_mountDirectory(path)
  --Randomizer:_unmountDirectory(path)
  if success then
    recursivelyDelete('csdata') -- completely clear the folder, in case of user error :)
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
