require 'lib.strict'

VERSION = '2.0-RC2'
CSVERSION = 1

Class   = require 'lib.classic'
_       = require 'lib.moses'

lf = love.filesystem
lg = love.graphics
ld = love.data

U = require 'util'

require 'log'
require 'lib.bit'

local random = require 'randomizer'
local settings = require 'settings'
Settings = settings()
Randomizer = random()
Screen = require 'ui.draw'

local csdirectory

function love.load(args)
  Settings:init()

  if true then
    love.window.close()
    U.writeFile("daily.txt", Randomizer:generateDaily())
    love.event.quit()
    return
  end
  Screen:setup()

  if Settings.settings.csdirectory == "csdata" then
    Screen:setStatus("Cave story folder found!")
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
  local success, dirStage = Randomizer:_mountDirectory(path)
  local csversion = lf.read(dirStage .. '/_version.txt') or "0"
  csversion = tonumber(csversion)
  --Randomizer:_unmountDirectory(path)
  if success then
    if csversion >= CSVERSION then
      recursivelyDelete('csdata') -- completely clear the folder, in case of user error :)
      recursiveWrite('mounted-data', 'csdata')

      Settings.settings.csdirectory = 'csdata'
      Settings.settings.csversion = csversion
      Settings:update()
      Randomizer:setPath('csdata')
      Screen:setStatus("Cave Story folder updated!")
    else
      Screen:setStatus("Invalid Cave Story folder!\n\nMake sure you're using an up to date version of the randomizer's included Cave Story folder.")
    end
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
