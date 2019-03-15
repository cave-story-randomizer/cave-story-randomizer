require 'lib.strict'

VERSION = '0.8'

Class   = require 'lib.classic'
_       = require 'lib.moses'
Serpent = require 'lib.serpent'
Terebi  = require 'lib.terebi'

lf = love.filesystem
lg = love.graphics

U = require 'util'

local LOG_LEVEL, _logCounts, _logLines = 3, nil, nil
local function _log(level, prefix, text, ...)
  if LOG_LEVEL >= level then
    local text = prefix .. text
    print(text, ...)
    table.insert(_logLines, text)
  end
  _logCounts[level] = _logCounts[level] + 1
end
function logError(...)   _log(1, 'ERROR: ',   ...) end
function logWarning(...) _log(2, 'WARNING: ', ...) end
function logNotice(...)  _log(3, 'NOTICE: ',  ...) end
function logInfo(...)    _log(4, 'INFO: ',    ...) end
function logDebug(...)   _log(5, 'DEBUG: ',   ...) end
function countLogWarningsAndErrors()
  return _logCounts[2], _logCounts[1]
end
function getLogText()
  return table.concat(_logLines, "\n\r")
end
function resetLog()
  _logCounts = {0, 0, 0, 0, 0}
  _logLines = {}
end
resetLog()

local Randomizer = require 'randomizer'
local background
local font
local screen
local status

function love.load()
  Terebi.initializeLoveDefaults()
  screen = Terebi.newScreen(320, 240, 2)
  background = lg.newImage('assets/background.png')
  font = lg.newFont('assets/monogram_extended.ttf', 16)
  font:setFilter('nearest', 'nearest', 1)
  status = "Drag and drop your Cave Story folder here."
end

function love.directorydropped(path)
  local randomizer = Randomizer()
  status = randomizer:randomize(path)
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.push('quit')
  end
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
  _print(status, 10, 65)
  _print('shru.itch.io', 10, 220, 'left')
  _print('@shruuu', 10, 220, 'right')
end

function love.draw()
  screen:draw(_draw)
end
