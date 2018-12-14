require 'lib.strict'

Class   = require 'lib.classic'
_       = require 'lib.moses'
Serpent = require 'lib.serpent'

lf = love.filesystem

local LOG_LEVEL = 4
local function _log(level, prefix, text, ...)
  if LOG_LEVEL >= level then
    print(prefix .. text, ...)
  end
end
function logError(...)   _log(1, 'ERROR: ',   ...) end
function logWarning(...) _log(2, 'WARNING: ', ...) end
function logNotice(...)  _log(3, 'NOTICE: ',  ...) end
function logInfo(...)    _log(4, 'INFO: ',    ...) end
function logDebug(...)   _log(5, 'DEBUG: ',   ...) end

local TSC_FILES = {}
do
  local ITEM_DATA = require 'database.items'
  for k, v in pairs(ITEM_DATA) do
    local filename = v.map .. '.tsc'
    if _.contains(TSC_FILES, filename) == false then
      table.insert(TSC_FILES, filename)
    end
  end
end

-- function love.load()
--   -- readPXM('Pole.pxm')
--   -- readTSC('Pole.tsc', 'Testing.tsc')
--   -- writeTSC('Testing.tsc')
--   -- readTSC('TestingEncoded.tsc', 'TestingDecoded.tsc')
-- end

function love.directorydropped(path)
  -- Mount.
  local mountPath = 'mounted-data'
  assert(lf.mount(path, mountPath))
  local items = lf.getDirectoryItems('/' .. mountPath)
  local containsStage = _.contains(items, 'Stage')
  assert(containsStage)
  local dirStage = '/' .. mountPath .. '/Stage'

  local tscFiles = {}
  for _, filename in ipairs(TSC_FILES) do
    local path = dirStage .. '/' .. filename
    local TscFile = require 'tsc_file'
    tscFiles[filename] = TscFile(path)
  end

  -- Create ItemDeck.
  local ItemDeck = require 'item_deck'
  local itemDeck = ItemDeck()

  -- Place random weapon in Hermit Gunsmith.
  tscFiles['Pole.tsc']:replaceItem(itemDeck:getWeapon())

  -- Replace all items.
  for _, tscFile in pairs(tscFiles) do
    while tscFile:hasUnreplacedItems() do
      tscFile:replaceItem(itemDeck:getAny())
    end
  end

  -- Write modified files.
  for filename, tscFile in pairs(tscFiles) do
    local path = '/data/Stage/' .. filename
    tscFile:writeTo(path)
  end

  -- Unmount.
  assert(lf.unmount(path))
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.push('quit')
  end
end
