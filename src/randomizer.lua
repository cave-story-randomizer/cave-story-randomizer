local ItemDeck = require 'item_deck'
local TscFile  = require 'tsc_file'
local WorldGraph = require 'database.locations'

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

function C:new()
  self._isCaveStoryPlus = false
end

function C:randomize(path)
  resetLog()
  logNotice('=== Cave Story Randomizer v' .. VERSION .. ' ===')
  local success, dirStage = self:_mountDirectory(path)
  if not success then
    return "Could not find \"data\" subfolder.\n\nMaybe try dropping your Cave Story \"data\" folder in directly?"
  end
  self:_seedRngesus()
  local tscFiles = self:_createTscFiles(dirStage)
  -- self:_writePlaintext(tscFiles)
  local canNotBreakBlocks = self:_shuffleItems(tscFiles)
  self:_writeModifiedData(tscFiles)
  self:_writePlaintext(tscFiles)
  if canNotBreakBlocks then
    self:_copyModifiedFirstCave()
  end
  self:_writeLog()
  self:_unmountDirectory(path)
  return self:_getStatusMessage()
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

  -- For Cave Story+
  local items = lf.getDirectoryItems(dirStage)
  local containsBase = _.contains(items, 'base')
  if containsBase then
    dirStage = dirStage .. '/base'
    self._isCaveStoryPlus = true
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

function C:_writePlaintext(tscFiles)
  local sourcePath = lf.getSourceBaseDirectory()

  -- Create /data/Plaintext if it doesn't already exist.
  local command = ('mkdir "%s"'):format(sourcePath .. '/data/Plaintext')
  os.execute(command) -- HERE BE DRAGONS!!!

  -- Write modified files.
  for filename, tscFile in pairs(tscFiles) do
    local path = sourcePath .. '/data/Plaintext/' .. filename
    tscFile:writePlaintextTo(path)
  end
end

function C:_shuffleItems(tscFiles)
  local itemDeck = ItemDeck()
  local worldGraph = WorldGraph()

  -- first, place puppies in the sand zone
  for i=1, 5 do
    local puppy = itemDeck:getAnyByAttributes({"puppy"})
    local puppySpot = worldGraph:getAnyByRegion({"lowerSandZone", "upperSandZone"})

    placeItem(puppySpot, puppy)
  end

  -- next, place weapon at hermit gunsmith and random item in first cave
  placeItem(worldGraph:get("gunsmithChest"), itemDeck:getAnyByAttributes({"weaponSN"}))
  placeItem(worldGraph:get("firstCapsule"), itemDeck:getAny())

  -- for now, just implementing a forward fill - will do a better fill later
  while itemDeck:remaining() > 0 do
    local location = worldGraph:getAnyAccessible(itemDeck:getPlacedItems())  
    local item = itemDeck:getAny()

    tscFiles[location.map]:placeItem(location.event, item.script)
  end
end

function C:_writeModifiedData(tscFiles)
  local basePath = self:_getWritePathStage()
  for filename, tscFile in pairs(tscFiles) do
    local path = basePath .. '/' .. filename
    tscFile:writeTo(path)
  end
end

function C:_copyModifiedFirstCave()
  local cavePxmPath = self:_getWritePathStage() .. '/Cave.pxm'
  local data = lf.read('database/Cave.pxm')
  assert(data)
  U.writeFile(cavePxmPath, data)
end

function C:_writeLog()
  local path = self:_getWritePath() .. '/log.txt'
  local data = getLogText()
  U.writeFile(path, data)
  print("\n")
end

function C:_getWritePath()
  return select(1, self:_getWritePaths())
end

function C:_getWritePathStage()
  return select(2, self:_getWritePaths())
end

function C:_getWritePaths()
  if self._writePath == nil then
    local sourcePath = lf.getSourceBaseDirectory()
    self._writePath = sourcePath .. '/data'
    self._writePathStage = (self._isCaveStoryPlus)
      and (self._writePath .. '/base/Stage')
      or  (self._writePath .. '/Stage')
    -- Create /data(/base)/Stage if it doesn't already exist.
    local command = ('mkdir "%s"'):format(self._writePathStage)
    os.execute(command) -- HERE BE DRAGONS!!!
  end
  return self._writePath, self._writePathStage
end

function C:_unmountDirectory(path)
  assert(lf.unmount(path))
end

function C:_getStatusMessage()
  local warnings, errors = countLogWarningsAndErrors()
  local line1
  if warnings == 0 and errors == 0 then
    line1 = "Randomized data successfully created!"
  elseif warnings ~= 0 and errors == 0 then
    line1 = ("Randomized data was created with %d warning(s)."):format(warnings)
  else
    return ("Encountered %d error(s) and %d warning(s) when randomizing data!"):format(errors, warnings)
  end
  local line2 = "Next overwrite the files in your copy of Cave Story with the versions in the newly created \"data\" folder. Don't forget to save a backup of the originals!"
  local line3 = "Then play and have a fun!"
  local status = ("%s\n\n%s\n\n%s"):format(line1, line2, line3)
  return status
end

return C
