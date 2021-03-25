local Items = require 'database.items'
local TscFile  = require 'tsc_file'
local WorldGraph = require 'database.world_graph'
local Music = require 'database.music'

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
  for key, cue in pairs(Music():getCues()) do
    local filename = cue.map
    if not _.contains(TSC_FILES, filename) then
      table.insert(TSC_FILES, filename)
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
  self.music = Music()

  self.customseed = nil
  self.puppy = false
  self.obj = ""
  self.sharecode = ""
  self.mychar = ""
  self.shuffleMusic = false
end

function C:setPath(path)
  csdirectory = path
end

function C:ready()
  return csdirectory ~= nil
end

function C:randomize()
  resetLog()
  logNotice('=== Cave Story Randomizer v' .. VERSION .. ' ===')
  local success, dirStage = self:_mountDirectory(csdirectory)
  if not success then
    return "Could not find \"data\" subfolder.\n\nMaybe try dropping your Cave Story \"data\" folder in directly?"
  end
  
  self:_logSettings()

  local seed = self:_seedRngesus(self.obj) -- append obj string in order to shuffle differently depending on the objective
  self:_updateSharecode(seed)

  local tscFiles = self:_createTscFiles(dirStage)

  self:_shuffleItems(tscFiles)
  self:_generateHash()
  if self.shuffleMusic then self.music:shuffleMusic(tscFiles) end

  self:_writeModifiedData(tscFiles)
  self:_writePlaintext(tscFiles)
  self:_writeLog()
  self:_copyMyChar()
  self:_unmountDirectory(csdirectory)

  self:_updateSettings()

  return self:_getStatusMessage(seed, self.sharecode)
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

function C:_seedRngesus(suffix)
  local seedstring = self.customseed or tostring(os.time())
  local seed = ld.encode('string', 'hex', ld.hash('sha256', seedstring  .. suffix))
  local s1 = tonumber(seed:sub(-8,  -1), 16) -- first 32 bits (from right)
  local s2 = tonumber(seed:sub(-16, -9), 16) -- next 32 bits

  love.math.setRandomSeed(s1, s2)
  
  logNotice(('Offering seed "%s" to RNGesus' ):format(seedstring))
  return seedstring
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

function C:getObjective()
  return {self.itemDeck:getByKey(self.obj)}
end

function C:_shuffleItems(tscFiles)
  local obj = self:getObjective()[1]
  obj.name = obj.name .. (", %s"):format(self.worldGraph.spawn)
  obj.script = obj.script .. self.worldGraph:getSpawnScript()
  if self.worldGraph.seqbreak and self.worldGraph.dboosts.rocket.enabled then obj.script = "<FL+6400" .. obj.script end
  if self.worldGraph.noFallingBlocks then obj.script = "<FL+1351" .. obj.script end
  -- place the objective scripts in Start Point
  self:_fastFillItems({obj}, self.worldGraph:getObjectiveSpot())

  if self.worldGraph:StartPoint() then
    -- first, fill one of the first cave spots with a weapon that can break blocks
    _.shuffle(self.worldGraph:getFirstCaveSpots())[1]:setItem(_.shuffle(self.itemDeck:getItemsByAttribute("weaponSN"))[1])
  elseif self.worldGraph:Camp() then
    -- give Dr. Gero a strong weapon... you'll need it
    self.worldGraph:getCamp()[1]:setItem(_.shuffle(self.itemDeck:getItemsByAttribute("weaponStrong"))[1])
    -- and some HP once you fight your way past the first few enemies
    self.worldGraph:getCamp()[2]:setItem(self.itemDeck:getByKey("capsule5G"))
  end

  -- place the bomb on MALCO for bad end
  if self.obj == "objBadEnd" then
    self.worldGraph:getMALCO()[1]:setItem(self.itemDeck:getByKey("bomb"))
  end

  local mandatory = _.compact(_.shuffle(self.itemDeck:getMandatoryItems(true)))
  local optional = _.compact(_.shuffle(self.itemDeck:getOptionalItems(true)))
  local puppies = _.compact(_.shuffle(self.itemDeck:getItemsByAttribute("puppy")))

  if not self.puppy then
    -- then fill puppies, for normal gameplay
    self:_fastFillItems(puppies, _.shuffle(self.worldGraph:getPuppySpots()))
  else
    -- for puppysanity, shuffle puppies in with the mandatory items
    mandatory = _.shuffle(_.append(mandatory, puppies))
    puppies = {}
  end
  
  -- next fill hell chests, which cannot have mandatory items
  self:_fastFillItems(optional, _.shuffle(self.worldGraph:getHellSpots()))

  -- add map system AFTER filling hell chests so that it gets placed somewhere accessible in every objective
  optional = _.append(optional, self.itemDeck:getByKey("mapSystem"))

  -- place mandatory items with assume fill
  self:_fillItems(mandatory, _.shuffle(_.reverse(self.worldGraph:getEmptyLocations())))

  -- place optional items with a simple random fill
  local opt = #optional
  local loc = #self.worldGraph:getEmptyLocations()
  if opt > loc then
    logWarning(("Trying to fill more optional items than there are locations! Items: %d Locations: %d"):format(opt, loc))
  end
  self:_fastFillItems(optional, _.shuffle(self.worldGraph:getEmptyLocations()))
  self:_generateHints()

  if tscFiles ~= nil then
    self.worldGraph:writeItems(tscFiles)
    self.worldGraph:logLocations()
  end
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

function C:_generateHints()
  local toHint = _.shuffle(self.worldGraph:getHintableLocations(self.obj))
  for k, hintLocation in ipairs(_.shuffle(self.worldGraph:getHintLocations())) do
    hintLocation.item = self.worldGraph.items:createHint(_.pop(toHint))
  end
  self.worldGraph.hintregion.locations.mrsLittle.item = self.worldGraph.items:prebuiltHint(self.worldGraph.regions.outerWall.locations.littleHouse)
  self.worldGraph.hintregion.locations.malco.item = self.worldGraph.items:prebuiltHint(self.worldGraph.regions.grasstownEast.locations.malco)
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

function C:_copyMyChar()
  local path = self:_getWritePath() .. '/MyChar.bmp'
  local data = lf.read(self.mychar)
  U.writeFile(path, data)
end

function C:_generateHash()
  local path = self:_getWritePath() .. '/hash.txt'
  local h = {love.math.random(39), love.math.random(39), love.math.random(39), love.math.random(39), love.math.random(39)}
  U.writeFile(path, ("%04d,%04d,%04d,%04d,%04d"):format(h[1], h[2], h[3], h[4], h[5]))
  return h
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
  end
  -- Create /data(/base)/Stage if it doesn't already exist.
  mkdir(self._writePathStage)
  return self._writePath, self._writePathStage
end

function C:_unmountDirectory(path)
  assert(lf.unmount(path))
end

function C:_logSettings()
  -- these random calls are a hacky way to make sure that
  -- randomization changes between seeds if settings change
  local obj = "Best Ending"
  if self.obj == "objBadEnd" then
    obj = "Bad Ending"
  elseif self.obj == "objNormalEnd" then
    obj = "Normal Ending"
  elseif self.obj == "objAllBosses" then
    obj = "All Bosses"
  end

  local spawn = (", %s"):format(self.worldGraph.spawn)

  local puppy = self.puppy and ", Puppysanity" or ""
  logNotice(("Game settings: %s"):format(obj .. spawn .. puppy))
end

function C:_updateSettings()
  Settings.settings.puppy = self.puppy
  Settings.settings.obj = self.obj
  Settings.settings.mychar = self.mychar
  Settings.settings.spawn = self.worldGraph.spawn
  Settings.settings.seqbreaks = self.worldGraph.seqbreak
  Settings.settings.dboosts = _.map(self.worldGraph.dboosts, function(k,v) return v.enabled end)
  Settings.settings.musicShuffle = self.shuffleMusic
  Settings.settings.musicBeta = self.music.betaEnabled
  Settings.settings.musicFlavor = self.music.flavor
  Settings.settings.noFallingBlocks = self.worldGraph.noFallingBlocks
  Settings:update()
end

function C:_updateSharecode(seed)
  local settings = 0 -- 0b00000000
  -- P: single bit used for puppysanity
  -- O: three bits used for objective
  -- S: three bits used for spawn location
  -- B: single bit used for sequence breaks
  -- F: single bit used for falling blocks in Hell
  -- 0bFBSSSOOOP

  -- bitshift intervals
  local obj = 1
  local pup = 0
  local spn = 4
  local brk = 7
  local nfb = 8

  if self.obj == "objBadEnd" then
    settings = bit.bor(settings, bit.blshift(1, obj))
  elseif self.obj == "objNormalEnd" then
    settings = bit.bor(settings, bit.blshift(2, obj))
  elseif self.obj == "objAllBosses" then
    settings = bit.bor(settings, bit.blshift(3, obj))
  elseif self.obj == "obj100Percent" then
    settings = bit.bor(settings, bit.blshift(4, obj))
  end
  if self.puppy then settings = bit.bor(settings, bit.blshift(1, pup)) end

  if self.worldGraph:StartPoint() then
    settings = bit.bor(settings, bit.blshift(0, spn))
  elseif self.worldGraph:Arthur() then
    settings = bit.bor(settings, bit.blshift(1, spn))
  elseif self.worldGraph:Camp() then
    settings = bit.bor(settings, bit.blshift(2, spn))
  end

  local seq = 0
  if self.worldGraph.seqbreak then
    settings = bit.bor(settings, bit.blshift(1, brk)) 
    if self.worldGraph.dboosts.cthulhu.enabled then seq = bit.bor(seq, 1) end
    if self.worldGraph.dboosts.chaco.enabled then seq = bit.bor(seq, 2) end
    if self.worldGraph.dboosts.paxChaco.enabled then seq = bit.bor(seq, 4) end
    if self.worldGraph.dboosts.flightlessHut.enabled then seq = bit.bor(seq, 8) end
    if self.worldGraph.dboosts.camp.enabled then seq = bit.bor(seq, 16) end
    if self.worldGraph.dboosts.sisters.enabled then seq = bit.bor(seq, 32) end
    if self.worldGraph.dboosts.plantation.enabled then seq = bit.bor(seq, 64) end
    if self.worldGraph.dboosts.rocket.enabled then seq = bit.bor(seq, 128) end
  end

  if self.worldGraph.noFallingBlocks then
    settings = bit.bor(settings, bit.blshift(1, nfb))
  end

  if #seed < 20 then
    seed = seed .. (" "):rep(20-#seed)
  end

  local packed = love.data.pack("data", "<s1I2B", seed, settings, seq)
  self.sharecode = love.data.encode("string", "base64", packed)

  logNotice(("Sharecode: %s"):format(self.sharecode))
end

function C:_getStatusMessage(seed, sharecode)
  local warnings, errors = countLogWarningsAndErrors()
  local line1
  if warnings == 0 and errors == 0 then
    line1 = ("Randomized data successfully created!\nSeed: %s\nSharecode: %s"):format(seed, sharecode)
  elseif warnings ~= 0 and errors == 0 then
    line1 = ("Randomized data was created with %d warning(s)."):format(warnings)
  else
    return ("Encountered %d error(s) and %d warning(s) when randomizing data!"):format(errors, warnings)
  end
  local line2 = "Next overwrite the files in your copy of Cave Story with the versions in the newly created \"data\" folder. Don't forget to save a backup of the originals!"
  local line3 = "Then play and have a fun!"
  local status = ("%s\n%s\n%s"):format(line1, line2, line3)
  return status
end

return C
