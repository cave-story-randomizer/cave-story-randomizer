local Items = require 'database.items'
local TscFile  = require 'tsc_file'
local WorldGraph = require 'database.world_graph'

local C = Class:extend()

local TSC_FILES = {}
do
  for key, location in ipairs(WorldGraph(Items()):getLocations()) do
    if location.map ~= nil and location.event ~= nil then
      local filename = location.map
      if not _.contains(TSC_FILES, filename) then
        table.insert(TSC_FILES, filename)
      end
    end
  end
end

function C:new()
  self._isCaveStoryPlus = false
  self.itemDeck = Items()
  self.worldGraph = WorldGraph(self.itemDeck)
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
  self:_shuffleItems(tscFiles)
  self:_writeModifiedData(tscFiles)
  self:_writePlaintext(tscFiles)
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
    local path = dirStage .. '/' .. filename .. '.tsc'
    tscFiles[filename] = TscFile(path)
    tscFiles[filename].mapName = filename
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
    local path = sourcePath .. '/data/Plaintext/' .. filename .. '.txt'
    tscFile:writePlaintextTo(path)
  end
end

function C:_shuffleItems(tscFiles)
  local l, i = #self.worldGraph:getLocations(), #self.itemDeck:getItems()
  assert(l == i, ("Locations: %d\r\nItems: %d"):format(l, i))
 
  -- first fill puppies
  self:_fastFillItems(self.itemDeck:getItemsByAttribute("puppy"), _.shuffle(self.worldGraph:getPuppySpots()))

  local mandatory = _.compact(_.shuffle(self.itemDeck:getMandatoryItems()))
  local optional = _.compact(_.shuffle(self.itemDeck:getOptionalItems()))
  
  -- next fill hell chests, which cannot have mandatory items
  self:_fastFillItems(optional, _.shuffle(self.worldGraph:getHellSpots()))

  self:_fillItems(mandatory, _.shuffle(_.reverse(self.worldGraph:getEmptyLocations())))
  self:_fastFillItems(optional, _.shuffle(self.worldGraph:getEmptyLocations()))

  assert(#self.worldGraph:getEmptyLocations() == 0, self.worldGraph:emptyString() .. "\r\n" .. self.itemDeck:unplacedString())
  self.worldGraph:writeItems(tscFiles)
end

function C:_fillItems(items, locations)
  assert(#items > 0, ("No items provided! Trying to fill %s locations."):format(#locations))
  assert(#items <= #locations, string.format("Trying to fill more items than there are locations! Items: %d Locations: %d", #items, #locations))

  local itemsLeft = _.clone(items)
  for key, item in ipairs(items) do
    local assumed = self.worldGraph:collect(_.remove(itemsLeft, item))

    local fillable = _.filter(locations, function(k,v) return not v:hasItem() and v:canAccess(assumed) end)
    local empty = _.filter(locations, function(k,v) return not v:hasItem() end)
    assert(#fillable > 0, "No available locations!")
    assert(item ~= nil, "No item found!")
    fillable[1]:setItem(item)
  end
end

function C:_fastFillItems(items, locations)
  assert(#items > 0, ("No items provided! Attempting to fast fill %s locations."):format(#locations))

  for key, location in ipairs(locations) do
    local item = _.pop(items)
    if item == nil then break end -- no items left to place, but there are still locations open
    location:setItem(item)
  end
end

function C:_writeModifiedData(tscFiles)
  local basePath = self:_getWritePathStage()
  for filename, tscFile in pairs(tscFiles) do
    local path = basePath .. '/' .. filename .. '.tsc'
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
