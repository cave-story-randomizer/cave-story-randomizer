require 'lib.strict'

Class   = require 'lib.classic'
_       = require 'lib.moses'
Serpent = require 'lib.serpent'
Terebi  = require 'lib.terebi'

lf = love.filesystem
lg = love.graphics

local LOG_LEVEL = 3
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
  -- Mount.
  local mountPath = 'mounted-data'
  assert(lf.mount(path, mountPath))
  local dirStage = '/' .. mountPath
  do
    local items = lf.getDirectoryItems(dirStage)
    local containsData = _.contains(items, 'data')
    if containsData then
      dirStage = dirStage .. '/data'
    end
  end
  do
    local items = lf.getDirectoryItems(dirStage)
    local containsStage = _.contains(items, 'Stage')
    if containsStage then
      dirStage = dirStage .. '/Stage'
    else
      status = "Could not find \"data\" subfolder.\n\nMaybe try dropping your Cave Story \"data\" folder in directly?"
      return
    end
  end

  -- Offer tribute to RNGesus.
  local seed = tostring(os.time())
  math.randomseed(seed)
  logNotice(('Offering seed "%s" to RNGesus'):format(seed))

  -- Create TscFile objects.
  local tscFiles = {}
  for _, filename in ipairs(TSC_FILES) do
    local path = dirStage .. '/' .. filename
    local TscFile = require 'tsc_file'
    tscFiles[filename] = TscFile(path)
  end

  -- Create ItemDeck.
  local ItemDeck = require 'item_deck'
  local itemDeck = ItemDeck()

  -- Place random weapon in either First Cave or Hermit Gunsmith.
  local firstArea = _.sample({'Cave.tsc', 'Pole.tsc'})
  tscFiles[firstArea]:replaceItem(itemDeck:getWeapon())

  -- Replace all items.
  for _, tscFile in pairs(tscFiles) do
    while tscFile:hasUnreplacedItems() do
      tscFile:replaceItem(itemDeck:getAny())
    end
  end

  local sourcePath = lf.getSourceBaseDirectory()

  -- Create /data/Stage if it doesn't already exist.
  local command = ('mkdir "%s"'):format(sourcePath .. '/data/Stage')
  os.execute(command) -- HERE BE DRAGONS!!!

  -- Write modified files.
  for filename, tscFile in pairs(tscFiles) do
    local path = sourcePath .. '/data/Stage/' .. filename
    tscFile:writeTo(path)
  end

  -- Unmount.
  assert(lf.unmount(path))
  print("\n")

  -- Update status
  status = [[Randomized data successfully created!

Next overwrite the files in your copy of Cave Story with the versions in the newly created "data" folder. Don't forget to save a backup of the originals!

Then play and have a fun!]]
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
  _print('Cave Story Randomizer v0.1.0', 0, 10)
  _print('by shru', 0, 22)
  _print(status, 10, 65)
  _print('shru.itch.io', 10, 220, 'left')
  _print('@shruuu', 10, 220, 'right')
end

function love.draw()
  screen:draw(_draw)
end
