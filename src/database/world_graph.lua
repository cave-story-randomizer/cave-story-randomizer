local Region = require 'database.region'
local Location = require 'database.location'

function _has(items, attribute)
  return _count(items, attribute, 1)
end

function _count(items, attribute, num)
  return #_.filter(items, function(k,v) return _.contains(v.attributes, attribute) end) >= num
end

local firstCave = Region:extend()
function firstCave:new(worldGraph)
  firstCave.super.new(self, worldGraph, "First Cave")
  self.locations = {
    firstCapsule = Location("First Cave Life Capsule", "Cave", "0401", self),
    gunsmithChest = Location("Hermit Gunsmith Chest", "Pole", "0202", self),
    gunsmith = Location("Tetsuzou", "Pole", "0303", self)
  }

  self.locations.gunsmith.requirements = function(self, items)
    return _has(items, "flight") and _has(items, "polarStar") and _has(items, "eventCore") and self.region.world.regions.mimigaVillage:canAccess(items)
  end
end

local mimigaVillage = Region:extend()
function mimigaVillage:new(worldGraph)
  mimigaVillage.super.new(self, worldGraph, "Mimiga Village")
  self.locations = {
    yamashita = Location("Yamashita Farm", "Plant", "0401", self),
    reservoir = Location("Reservoir", "Pool", "0301", self),
    mapChest = Location("Mimiga Village Chest", "Mimi", "0202", self),
    assembly = Location("Assembly Hall Fireplace", "Comu", "0303", self),
    mrLittle = Location("Mr. Little (Graveyard)", "Cemet", "0202", self),
    grave = Location("Arthur's Grave", "Cemet", "0301", self),
    mushroomChest = Location("Storage? Chest", "Mapi", "0202", self),
    maPignon = Location("Ma Pignon Boss", "Mapi", "0501", self)
  }

  self.requirements = function(self, items)
    return _has(items, "weaponSN")
  end

  self.locations.assembly.requirements = function(self, items) return _has(items, "juice") end
  self.locations.mrLittle.requirements = function(self, items)
    return _has(items, "locket") and self.region.world.regions.outerWall.locations.littleHouse:canAccess(items)
  end
  self.locations.grave.requirements = function(self, items) return _has(items, "locket") end
  self.locations.mushroomChest.requirements = function(self, items)
    return _has(items, "flight") and _has(items, "locket") and _has(items, "eventCurly")
  end
  self.locations.maPignon.requirements = function(self, items)
    -- stupid mushroom is invincible to the blade and machinegun for some reason
    if _has(items, "flight") and _has(items, "locket") and _has(items, "mushroomBadge") then
      if _has(items, "polarStar") or _has(items, "fireball") or _has(items, "bubbler")
      or _has(items, "machineGun") or _has(items, "snake") or _has(items, "nemesis") then
        return true
      end
    end
    return false
  end

  self.locations.mrLittle:setItem(self.world.items:getByKey("mrLittle"))
end

local arthur = Region:extend()
function arthur:new(worldGraph)
  arthur.super.new(self, worldGraph, "Arthur's House")
  self.locations = {
    risenBooster = Location("Professor Booster", "Pens1", "0652", self)
  }

  self.requirements = function(self, items)
    if _has(items, "arthurKey") and _has(items, "weaponSN") then return true end
    return false
  end

  self.locations.risenBooster.requirements = function(self, items) return _has(items, "eventCore") end
end

local eggCorridor1 = Region:extend()
function eggCorridor1:new(worldGraph)
  eggCorridor1.super.new(self, worldGraph, "Egg Corridor")
  self.locations = {
    basil = Location("Basil Spot", "Eggs", "0403", self),
    cthulhu = Location("Cthulhu's Abode", "Eggs", "0404", self),
    eggItem = Location("Egg Chest", "Egg6", "0201", self),
    observationChest = Location("Egg Observation Room Chest", "EggR", "0301", self),
    eventSue = Location("Saved Sue", nil, nil, self)
  }

  self.requirements = function(self, items) return self.world.regions.arthur:canAccess(items) end

  self.locations.eventSue.requirements = function(self, items) return _has(items, "idCard") and _has(items, "weaponBoss") end
  self.locations.eventSue:setItem(self.world.items:getByKey("eventSue"))
end

local grasstownWest = Region:extend()
function grasstownWest:new(worldGraph)
  grasstownWest.super.new(self, worldGraph, "Grasstown (West)")
  self.locations = {
    keySpot = Location("West Grasstown Floor", "Weed", "0700", self),
    jellyCapsule = Location("West Grasstown Ceiling", "Weed", "0701", self),
    santa = Location("Santa", "Santa", "0501", self),
    charcoal = Location("Santa's Fireplace", "Santa", "0302", self),
    chaco = Location("Chaco's Bed, where you two Had A Nap", "Chako", "0211", self),
    kulala = Location("Kulala Chest", "Weed", "0702", self)
  }

  self.requirements = function(self, items)
    return self.world.regions.arthur:canAccess(items)
  end

  self.locations.santa.requirements = function(self, items) return _has(items, "santaKey") end
  self.locations.charcoal.requirements = function(self, items) return _has(items, "santaKey") and _has(items, "juice") end
  self.locations.chaco.requirements = function(self, items) return _has(items, "santaKey") end
  self.locations.kulala.requirements = function(self, items) return _has(items, "santaKey") and _has(items, "weapon") end
end

local grasstownEast = Region:extend()
function grasstownEast:new(worldGraph)
  grasstownEast.super.new(self, worldGraph, "Grasstown (East)")
  self.locations = {
    kazuma1 = Location("Kazuma Crack", "Weed", "0800", self),
    kazuma2 = Location("Kazuma Chest", "Weed", "0801", self),
    execution = Location("Execution Chamber", "WeedD", "0305", self),
    outsideHut = Location("Grasstown East Chest", "Weed", "0303", self),
    hutChest = Location("Grasstown Hut", "WeedB", "0301", self),
    gumChest = Location("Gum Chest", "Frog", "0300", self),
    malco = Location("MALCO", "Malco", "0350", self),
    eventFans = Location("Activated Grasstown Fans", nil, nil, self),
    eventKazuma = Location("Saved Kazuma", nil, nil, self)
  }

  self.requirements = function(self, items)
    if not self.world.regions.arthur:canAccess(items) then return false end
    if _has(items, "flight") or _has(items, "juice") then
      if self.world.regions.grasstownWest:canAccess(items) then return true end
    end
    if _has(items, "eventKazuma") and _has(items, "weaponSN") and self.world.regions.plantation:canAccess(items) then return true end
    return false
  end

  self.locations.kazuma2.requirements = function(self, items) return _has(items, "eventFans") end
  self.locations.execution.requirements = function(self, items) return _has(items, "weaponSN") end
  self.locations.hutChest.requirements = function(self, items) return _has(items, "eventFans") or _has(items, "flight") end
  self.locations.gumChest.requirements = function(self, items)
    if _has(items, "gumKey") and _has(items, "weaponBoss") then
      if _has(items, "eventFans") or _has(items, "flight") then return true end
    end
    return false
  end
  self.locations.malco.requirements = function(self, items) return _has(items, "eventFans") and _has(items, "juice") and _has(items, "charcoal") and _has(items, "gum") end
  
  self.locations.eventFans.requirements = function(self, items) return _has(items, "rustyKey") and _has(items, "weaponBoss") end
  self.locations.eventFans:setItem(self.world.items:getByKey("eventFans"))

  self.locations.eventKazuma.requirements = function(self, items) return _has(items, "bomb") end
  self.locations.eventKazuma:setItem(self.world.items:getByKey("eventKazuma"))
end

local upperSandZone = Region:extend()
function upperSandZone:new(worldGraph)
  upperSandZone.super.new(self, worldGraph, "Sand Zone (Upper)")
  self.locations = {
    curly = Location("Curly Boss", "Curly", "0518", self),
    panties = Location("Curly's Closet", "CurlyS", "0421", self),
    curlyPup = Location("Puppy (Curly)", "CurlyS", "0401", self),
    sandCapsule = Location("Polish Spot", "Sand", "0502", self),
    eventOmega = Location("Defeated Omega", nil, nil, self)
  }

  self.requirements = function(self, items)
    return self.world.regions.arthur:canAccess(items)
  end

  self.locations.curly.requirements = function(self, items) return _has(items, "polarStar") end
  
  self.locations.eventOmega.requirements = function(self, items) return _has(items, "weaponBoss") end
  self.locations.eventOmega:setItem(self.world.items:getByKey("eventOmega"))
end

local lowerSandZone = Region:extend()
function lowerSandZone:new(worldGraph)
  lowerSandZone.super.new(self, worldGraph, "Sand Zone (Lower)")
  self.locations = {
    chestPup = Location("Puppy (Chest)", "Sand", "0423", self),
    darkPup = Location("Puppy (Dark)", "Dark", "0401", self),
    runPup = Location("Puppy (Run)", "Sand", "0422", self),
    sleepyPup = Location("Puppy (Sleep)", "Sand", "0421", self),
    pawCapsule = Location("Pawprint Spot", "Sand", "0503", self),
    jenka = Location("Jenka", "Jenka2", "0221", self),
    king = Location("King", "Gard", "0602", self),
    eventToroko = Location("Defeated Toroko+", nil, nil, self)
  }

  self.requirements = function(self, items)
    return _has(items, "eventOmega") and self.world.regions.upperSandZone:canAccess(items)
  end

  self.locations.jenka.requirements = function(self, items) return _count(items, "puppy", 5) end
  self.locations.king.requirements = function(self, items) return _has(items, "eventToroko") end

  self.locations.eventToroko.requirements = function(self, items)
    return _count(items, "puppy", 5) and _has(items, "weaponBoss")
  end
  self.locations.eventToroko:setItem(self.world.items:getByKey("eventToroko"))
end

local labyrinthW = Region:extend()
function labyrinthW:new(worldGraph)
  labyrinthW.super.new(self, worldGraph, "Labyrinth (West)")
  self.locations = {
    mazeCapsule = Location("Labyrinth Life Capsule", "MazeI", "0301", self),
    turboChaba = Location("Chaba Chest (Machine Gun)", "MazeA", "0502", self),
    snakeChaba = Location("Chaba Chest (Fireball)", "MazeA", "0512", self),
    whimChaba = Location("Chaba Chest (Spur)", "MazeA", "0522", self),
    campChest = Location("Camp Chest", "MazeO", "0401", self),
    physician = Location("Dr. Gero", "MazeO", "0305", self),
    puuBlack = Location("Puu Black Boss", "MazeD", "0201", self)
  }

  self.requirements = function(self, items)
    if not self.world.regions.arthur:canAccess(items) then return false end
    if _has(items, "eventToroko") and self.world.regions.lowerSandZone:canAccess(items) then return true end
    if _has(items, "flight") and self.world.regions.labyrinthB:canAccess(items) then return true end
    return false
  end

  self.locations.mazeCapsule.requirements = function(self, items) return _has(items, "weapon") end
  self.locations.turboChaba.requirements = function(self, items) return _has(items, "machineGun") end
  self.locations.snakeChaba.requirements = function(self, items) return _has(items, "fireball") end
  self.locations.whimChaba.requirements = function(self, items) return _count(items, "polarStar", 2) end
  self.locations.campChest.requirements = function(self, items) return _has(items, "flight") end
  self.locations.puuBlack.requirements = function(self, items) return _has(items, "clinicKey") and _has(items, "weaponBoss") end
end

local labyrinthB = Region:extend()
function labyrinthB:new(worldGraph)
  labyrinthB.super.new(self, worldGraph, "Labyrinth B")
  self.locations = {
    fallenBooster = Location("Booster Chest", "MazeB", "0502", self)
  }

  self.requirements = function(self, items)
    return self.world.regions.arthur:canAccess(items)
  end
end

local boulder = Region:extend()
function boulder:new(worldGraph)
  boulder.super.new(self, worldGraph, "Labyrinth (East)")
  self.locations = { --include core locations since core access reqs are identical to boulder chamber
    boulderChest = Location("Boulder Chest", "MazeS", "0202", self),
    coreSpot = Location("Robot's Arm", "Almond", "0243", self),
    curlyCorpse = Location("Drowned Curly", "Almond", "1111", self),
    eventCore = Location("Defeated Core", nil, nil, self)
  }

  self.requirements = function(self, items)
    if not self.world.regions.arthur:canAccess(items) then return false end
    if _has(items, "cureAll") and _has(items, "weaponBoss") then
      if self.world.regions.labyrinthW:canAccess(items) then return true end
    end
    return false
  end

  self.locations.eventCore:setItem(self.world.items:getByKey("eventCore"))
end

local labyrinthM = Region:extend()
function labyrinthM:new(worldGraph)
  labyrinthM.super.new(self, worldGraph, "labyrinthM")
  
  self.requirements = function(self, items)
    if not self.world.regions.arthur:canAccess(items) then return false end
    if self.world.regions.boulder:canAccess(items) then return true end
    if _has(items, "flight") and self.world.regions.labyrinthW:canAccess(items) then return true end
    return false
  end
end

local waterway = Region:extend()
function waterway:new(worldGraph)
  waterway.super.new(self, worldGraph, "Waterway")

  self.locations = {
    ironhead = Location("Ironhead Boss", "Pool", "0412", self),
    eventCurly = Location("Saved Curly", nil, nil, self)
  }

  self.requirements = function(self, items)
    if not self.world.regions.arthur:canAccess(items) then return false end
    if _has(items, "airTank") and _has(items, "weaponBoss") and self.world.regions.labyrinthM:canAccess(items) then return true end
    return false
  end

  self.locations.eventCurly.requirements = function(self, items) return _has(items, "eventCore") and _has(items, "towRope") end
  self.locations.eventCurly:setItem(self.world.items:getByKey("eventCurly"))
end

local eggCorridor2 = Region:extend()
function eggCorridor2:new(worldGraph)
  eggCorridor2.super.new(self, worldGraph, "Egg Corridor?")

  self.locations = {
    dragonChest = Location("Dragon Chest", "Eggs2", "0321", self),
    sisters = Location("Sisters Boss", "EggR2", "0303", self)
  }

  self.requirements = function(self, items)
    if not self.world.regions.arthur:canAccess(items) then return false end
    if _has(items, "eventCore") then return true end
    if _has(items, "eventKazuma") and self.world.regions.outerWall:canAccess(items) then return true end
    return false
  end

  self.locations.dragonChest.requirements = function(self, items) return _has(items, "weapon") end
  self.locations.sisters.requirements = function(self, items) return _has(items, "weaponBoss") end
end

local outerWall = Region:extend()
function outerWall:new(worldGraph)
  outerWall.super.new(self, worldGraph, "Outer Wall")

  self.locations = {
    clock = Location("Clock Room", "Clock", "0300", self),
    littleHouse = Location("Little House", "Little", "0204", self)
  }

  self.requirements = function(self, items)
    if not self.world.regions.arthur:canAccess(items) then return false end
    if _has(items, "eventKazuma") and _has(items, "flight") and _has(items, "eventCore") then return true end
    if _has(items, "teleportKey") and self.world.regions.plantation:canAccess(items) then return true end
    return false
  end

  self.locations.littleHouse.requirements = function(self, items) return _has(items, "flight") end
end

local plantation = Region:extend()
function plantation:new(worldGraph)
  plantation.super.new(self, worldGraph, "Plantation")

  self.locations = {
    kanpachi = Location("Kanpachi's Bucket", "Cent", "0268", self),
    jail1 = Location("Jail no. 1", "Jail1", "0301", self),
    momorin = Location("Chivalry Sakamoto's Wife", "Momo", "0201", self),
    sprinkler = Location("Broken Sprinkler", "Cent", "0417", self),
    megane = Location("Megane", "Lounge", "0204", self),
    itoh = Location("Itoh", "Itoh", "0405", self),
    plantCeiling = Location("Plantation Platforming Spot", "Cent", "0501", self),
    plantPup = Location("Plantation Puppy", "Cent", "0452", self),
    curlyShroom = Location("Jammed it into Curly's Mouth", "Cent", "0324", self),
    eventRocket = Location("Built Rocket", nil, nil, self)
  }

  self.requirements = function(self, items)
    if not self.world.regions.arthur:canAccess(items) then return false end
    if _has(items, "teleportKey") then return true end
    if self.world.regions.outerWall:canAccess(items) then return true end
    return false
  end

  self.locations.jail1.requirements = function(self, items) return _has(items, "letter") end
  self.locations.momorin.requirements = function(self, items) return _has(items, "letter") and _has(items, "booster") end
  self.locations.sprinkler.requirements = function(self, items) return _has(items, "mask") end
  self.locations.megane.requirements = function(self, items) return _has(items, "brokenSprinkler") and _has(items, "mask") end
  self.locations.itoh.requirements = function(self, items) return _has(items, "letter") end
  self.locations.plantCeiling.requirements = function(self, items) return _has(items, "flight") end
  self.locations.plantPup.requirements = function(self, items) return _has(items, "eventRocket") end
  self.locations.curlyShroom.requirements = function(self, items) return _has(items, "eventCurly") and _has(items, "maPignon") end

  self.locations.eventRocket.requirements = function(self, items)
    return _has(items, "letter") and _has(items, "booster") and _has(items, "controller") and _has(items, "sprinkler")
  end
  self.locations.eventRocket:setItem(self.world.items:getByKey("eventRocket"))
end

local lastCave = Region:extend()
function lastCave:new(worldGraph)
  lastCave.super.new(self, worldGraph, "Last Cave")

  self.locations = {
    redDemon = Location("Red Demon Boss", "Priso2", "0300", self)
  }

  self.requirements = function(self, items) return _has(items, "eventRocket") and _has(items, "weaponBoss") and _count(items, booster, 2) end
end

local endgame = Region:extend()
function endgame:new(worldGraph)
  endgame.super.new(self, worldGraph, "Sacred Grounds")

  self.locations = {
    hellB1 = Location("Hell B1 Spot", "Hell1", "0401", self),
    hellB3 = Location("Hell B3 Chest", "Hell3", "0400", self)
  }

  self.requirements = function(self, items)
    return _has(items, "eventSue") and _has(items, "ironBond") and self.world.regions.lastCave:canAccess(items)
  end
end

local worldGraph = Class:extend()

function worldGraph:new(items)
  self.items = items

  self.regions = {
    firstCave = firstCave(self),
    mimigaVillage = mimigaVillage(self),
    arthur = arthur(self),
    eggCorridor1 = eggCorridor1(self),
    grasstownWest = grasstownWest(self),
    grasstownEast = grasstownEast(self),
    upperSandZone = upperSandZone(self),
    lowerSandZone = lowerSandZone(self),
    labyrinthW = labyrinthW(self),
    labyrinthB = labyrinthB(self),
    boulder = boulder(self),
    labyrinthM = labyrinthM(self),
    waterway = waterway(self),
    eggCorridor2 = eggCorridor2(self),
    outerWall = outerWall(self),
    plantation = plantation(self),
    lastCave = lastCave(self),
    endgame = endgame(self)
  }
end

function worldGraph:getLocations()
  local locations = {}
  for key, region in pairs(self.regions) do
    for k, location in pairs(region:getLocations()) do
      table.insert(locations, location)
    end
  end
  return locations
end

function worldGraph:getPuppySpots()
  return {
    self.regions.upperSandZone.locations.curly,
    self.regions.upperSandZone.locations.curlyPup,
    self.regions.upperSandZone.locations.panties,
    self.regions.upperSandZone.locations.sandCapsule,
    self.regions.lowerSandZone.locations.chestPup,
    self.regions.lowerSandZone.locations.darkPup,
    self.regions.lowerSandZone.locations.runPup,
    self.regions.lowerSandZone.locations.sleepyPup,
    self.regions.lowerSandZone.locations.pawCapsule
  }
end

function worldGraph:getFirstCaveSpots()
  return {
    self.regions.firstCave.locations.firstCapsule,
    self.regions.firstCave.locations.gunsmithChest
  }
end

function worldGraph:getHellSpots()
  return self.locationsArray(self.regions.endgame:getLocations())
end

function worldGraph:getEmptyLocations()
  local locations = {}
  for key, region in pairs(self.regions) do
    for k, location in pairs(region:getEmptyLocations()) do
      table.insert(locations, location)
    end
  end
  return locations
end

function worldGraph:emptyString()
  local s = "\r\nEmpty locations:"
  for key, region in pairs(self.regions) do
    for k, l in pairs(region:getEmptyLocations()) do
      s = s .. "\r\n" .. l.name
    end
  end
  return s
end

function worldGraph:getFilledLocations()
  local locations = {}
  for key, region in pairs(self.regions) do
    for k, location in pairs(region:getFilledLocations()) do
      table.insert(locations, location)
    end
  end
  return locations
end

function worldGraph:writeItems(tscFiles)
  for key, region in pairs(self.regions) do region:writeItems(tscFiles) end
end

function worldGraph:collect(preCollectedItems)
  local collected = _.clone(preCollectedItems) or {}
  local availableLocations = self:getFilledLocations()

  local foundItems = 0
  repeat
    local accessible, _i = {}, {}
    for i, location in ipairs(availableLocations) do
      if location:canAccess(collected) then
        table.insert(accessible, location)
        table.insert(_i, i)
      end
    end
    for i, v in ipairs(_i) do table.remove(availableLocations, i) end

    foundItems = #accessible
    for i, location in ipairs(accessible) do
      table.insert(collected, location.item)
    end
  until foundItems == 0

  --[[local s = "Collected items: "
  for k,v in ipairs(collected) do s = s .. v.name .. ", " end
  logDebug(s)]]
  return collected
end

function worldGraph.locationsArray(locations)
  local array = {}
  for k, v in pairs(locations) do
    table.insert(array, v)
  end
  return array
end

function worldGraph:logLocations()
  for k,r in pairs(self.regions) do
    if next(r.locations) then
      logSpoiler("")
      logSpoiler("Region: " .. r.name)
      for k2,l in pairs(r.locations) do
        if l.item ~= nil and not _has({l.item}, "event") then
          logSpoiler("\t " .. l.name .. ": " .. l.item.name)
        end
      end
    end
  end
end

return worldGraph