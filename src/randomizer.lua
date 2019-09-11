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

local csdirectory

local function mkdir(path)
    local mkdir_str
    if package.config:sub(1,1) == '\\' then -- Windows
      mkdir_str = 'mkdir "%s"'
    else -- *nix
      mkdir_str = "mkdir -p '%s'"
    end
    os.execute(mkdir_str:format(path)) -- HERE BE DRAGONS!!!	
end

function C:new()
  self._isCaveStoryPlus = false
  self.itemDeck = Items()
  self.worldGraph = WorldGraph(self.itemDeck)
end

function C:setPath(path)
  csdirectory = path
end

function C:randomize()
  resetLog()
  logNotice('=== Cave Story Randomizer v' .. VERSION .. ' ===')
  local success, dirStage = self:_mountDirectory(csdirectory)
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
  self:_unmountDirectory(csdirectory)
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
  local seed = io.open(lf.getSourceBaseDirectory() .. "/seed.txt")
  if seed == nil then
    logNotice('Seed from file doesnt exists, generate a new') 
    seed = tostring(os.time())
  else
    logNotice('Gathering the seed from file "seed.txt"')
    seed = seed:read('*n')
  end
  if seed == nil then
    logWarning('Seed from file is invalid, generate a new') 
    seed = tostring(os.time())
  elseif string.len(seed) < 10 then
    logWarning('Seed is too short, generate a new')
    seed = tostring(os.time())
  end
  love.math.setRandomSeed(seed)
  logNotice(('Offering seed "%s" to RNGesus' ):format(seed))
end

function C:_createTscFiles(dirStage)
  local tscFiles = {}
  for _, filename in ipairs(TSC_FILES) do
    local path = dirStage .. '/' .. filename .. ".tsc"
    tscFiles[filename] = TscFile(path)
    tscFiles[filename].mapName = filename
  end
  return tscFiles
end

function C:_writePlaintext(tscFiles)
  local sourcePath = lf.getSourceBaseDirectory()

  -- Create /data/Plaintext if it doesn't already exist.
  mkdir(sourcePath .. '/data/Plaintext')

  -- Write modified files.
  for filename, tscFile in pairs(tscFiles) do
    local path = sourcePath .. '/data/Plaintext/' .. filename .. '.txt'
    tscFile:writePlaintextTo(path)
  end
end

function C:_shuffleItems(tscFiles)
  -- first fill puppies
  self:_fastFillItems(self.itemDeck:getItemsByAttribute("puppy"), _.shuffle(self.worldGraph:getPuppySpots()))
  -- then fill one of the first cave spots with a weapon that can break blocks
  _.shuffle(self.worldGraph:getFirstCaveSpots())[1]:setItem(_.shuffle(self.itemDeck:getItemsByAttribute("weaponSN"))[1])

  local mandatory = _.compact(_.shuffle(self.itemDeck:getMandatoryItems(true)))
  local optional = _.compact(_.shuffle(self.itemDeck:getOptionalItems(true)))
  
  -- next fill hell chests, which cannot have mandatory items
  self:_fastFillItems(optional, _.shuffle(self.worldGraph:getHellSpots()))

  self:_fillItems(mandatory, _.shuffle(_.reverse(self.worldGraph:getEmptyLocations())))
  self:_fastFillItems(optional, _.shuffle(self.worldGraph:getEmptyLocations()))

  --assert(#self.worldGraph:getEmptyLocations() == 0, self.worldGraph:emptyString() .. "\r\n" .. self.itemDeck:unplacedString())
  self.worldGraph:writeItems(tscFiles)
  self.worldGraph:logLocations()
end

function C:_fillItems(items, locations)
  assert(#items > 0, ("No items provided! Trying to fill %s locations."):format(#locations))
  assert(#items <= #locations, string.format("Trying to fill more items than there are locations! Items: %d Locations: %d", #items, #locations))

  local itemsLeft = _.clone(items)
  repeat
    local item = _.pop(itemsLeft)
    local assumed = self.worldGraph:collect(itemsLeft)
    
    local fillable = _.filter(locations, function(k,v) return not v:hasItem() and v:canAccess(assumed) end)
    if #fillable > 0 then
      logDebug(("Placing %s at %s"):format(item.name, fillable[1].name))
      fillable[1]:setItem(item)
    else
      logError(("No available locations for %s! Items left: %d"):format(item.name, #itemsLeft))
    end
  until #itemsLeft == 0
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
    mkdir(self._writePathStage)
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
