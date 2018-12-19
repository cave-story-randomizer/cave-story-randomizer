local ItemDeck = require 'item_deck'
local TscFile  = require 'tsc_file'

local C = Class:extend()

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

function C:randomize(path)
  local success, dirStage = self:_mountDirectory(path)
  if not success then
    return "Could not find \"data\" subfolder.\n\nMaybe try dropping your Cave Story \"data\" folder in directly?"
  end
  self:_seedRngesus()
  local tscFiles = self:_createTscFiles(dirStage)
  self:_shuffleItems(tscFiles)
  self:_writeModifiedData(tscFiles)
  self:_unmountDirectory(path)
  return [[Randomized data successfully created!

Next overwrite the files in your copy of Cave Story with the versions in the newly created "data" folder. Don't forget to save a backup of the originals!

Then play and have a fun!]]
end

function C:_mountDirectory(path)
  local mountPath = 'mounted-data'
  assert(lf.mount(path, mountPath))
  local dirStage = '/' .. mountPath

  local items = lf.getDirectoryItems(dirStage)
  local containsData = _.contains(items, 'data')
  if containsData then
    dirStage = dirStage .. '/data'
  end

  local items = lf.getDirectoryItems(dirStage)
  local containsStage = _.contains(items, 'Stage')
  if containsStage then
    dirStage = dirStage .. '/Stage'
  else
    return false, ''
  end

  return true, dirStage
end

function C:_seedRngesus()
  local seed = tostring(os.time())
  math.randomseed(seed)
  logNotice(('Offering seed "%s" to RNGesus'):format(seed))
end

function C:_createTscFiles(dirStage)
  local tscFiles = {}
  for _, filename in ipairs(TSC_FILES) do
    local path = dirStage .. '/' .. filename
    tscFiles[filename] = TscFile(path)
  end
  return tscFiles
end

function C:_shuffleItems(tscFiles)
  local itemDeck = ItemDeck()

  -- Place random weapon in either First Cave or Hermit Gunsmith.
  local firstArea, firstItemKey = unpack(_.sample({
    {'Cave.tsc', 'lFirstCave'},
    {'Pole.tsc', 'wPolarStar'},
  }))
  tscFiles[firstArea]:replaceSpecificItem(firstItemKey, itemDeck:getWeapon())

  -- Replace all weapon trades with random weapons
  tscFiles['Curly.tsc']:replaceSpecificItem('wMachineGun', itemDeck:getWeapon())
  tscFiles['MazeA.tsc']:replaceSpecificItem('wSnake', itemDeck:getWeapon())
  tscFiles['Pole.tsc']:replaceSpecificItem('wSpur', itemDeck:getWeapon())
  tscFiles['Little.tsc']:replaceSpecificItem('wNemesis', itemDeck:getWeapon())

  -- Replace the rest of the items.
  for _, tscFile in pairs(tscFiles) do
    while tscFile:hasUnreplacedItems() do
      tscFile:replaceItem(itemDeck:getAny())
    end
  end
end

function C:_writeModifiedData(tscFiles)
  local sourcePath = lf.getSourceBaseDirectory()

  -- Create /data/Stage if it doesn't already exist.
  local command = ('mkdir "%s"'):format(sourcePath .. '/data/Stage')
  os.execute(command) -- HERE BE DRAGONS!!!

  -- Write modified files.
  for filename, tscFile in pairs(tscFiles) do
    local path = sourcePath .. '/data/Stage/' .. filename
    tscFile:writeTo(path)
  end
end

function C:_unmountDirectory(path)
  assert(lf.unmount(path))
  print("\n")
end

return C
