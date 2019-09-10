local Terebi  = require 'lib.terebi'
local Luigi   = require 'lib.luigi.layout'

local background
local font
local screen
local status

local C = Class:extend()

local layout = Luigi(require 'layout')
layout:setStyle(require 'style')

function C:setup()
  Terebi.initializeLoveDefaults()
  screen = Terebi.newScreen(320, 240, 2)
  background = lg.newImage('assets/background.png')
  font = lg.newFont('assets/monogram_extended.ttf', 16)
  font:setFilter('nearest', 'nearest', 1)
  status = "Drag and drop your Cave Story folder here."
end

local function _print(text, x, y, align)
  align = align or 'center'
  lg.setFont(font)
  local limit = 320 - (x * 2)
  lg.setColor(0, 0, 0)
  lg.printf(text, x + 1, y + 1, limit, align)
  lg.setColor(1, 1, 1)
  lg.printf(text, x, y, limit, align)
end

local function _draw()
  lg.draw(background, 0, 0)
  _print('Cave Story Randomizer [Open Mode] v' .. VERSION, 0, 10)
  _print('by shru and duncathan', 0, 22)
  _print('(@shruuu and @duncathan_salt)', 0, 34)
  _print(status, 10, 65)
  _print('Original randomizer:\r\nshru.itch.io/cave-story-randomizer', 10, 200, 'left')
end

function C:draw()
  screen:draw(_draw)
  layout:show()
end

function C:setStatus(text)
  status = text
end

return C