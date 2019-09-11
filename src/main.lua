require 'lib.strict'

VERSION = '0.8B'

Class   = require 'lib.classic'
_       = require 'lib.moses'

lf = love.filesystem
lg = love.graphics

U = require 'util'

require 'log'

local Randomizer = require 'randomizer'
local Screen = require 'draw'

function love.load()
  Screen:setup()
end

function love.directorydropped(path)
  local randomizer = Randomizer()
  Screen:setStatus(randomizer:randomize(path))
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.push('quit')
  end
end

function love.draw()
  Screen:draw()
end
