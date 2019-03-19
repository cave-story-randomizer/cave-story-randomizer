local Region = require 'database.region'
local Location = require 'database.location'

local function has(items, attribute)
  for item in ipairs(items) do
    if _.contains(item.attributes, attribute) then return true end
  end
end

local function count(items, attribute)
  local c = 0
  for item in ipairs(items) do
    if _.contains(item.attributes, attribute) then c = c + 1 end
  end
  return c
end

local firstCave = Region:extend()
function firstCave:new(worldGraph)
  firstCave.super.new(self, worldGraph, "firstCave")
  self.locations = {
    firstCapsule = Location("First Cave Life Capsule", "Cave", "0401", self),
    gunsmithChest = Location("Hermit Gunsmith Chest", "Pole", "0402", self),
    gunsmith = Location("Tetsuzou", "Pole", "0303", self)
  }

  self.locations.gunsmith.requirements = function(items)
    return self.world.regions.mimigaVillage:canAccess(items) and has(items, "flight") and has(items, "polarStar") and has(items, "eventCore")
  end
end

local mimigaVillage = Region:extend()
function mimigaVillage:new(worldGraph)
  mimigaVillage.super.new(self, worldGraph, "mimigaVillage")
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

  self.requirements = function(items)
    if self.world.regions.firstCave:canAccess(items) and has(items, "weaponSN") then return true end
    return false
  end

  self.locations.assembly.requirements = function(items) return has(items, "juice") end
  self.locations.mrLittle.requirements = function(items)
    return self.world.regions.outerWall:canAccess(items) and has(items, "flight") and has(items, "locket")
  end
  self.locations.grave.requirements = function(items) return has(items, "locket") end
  self.locations.mushroomChest.requirements = function(items)
    return has(items, "flight") and has(items, "locket") and has(items, "eventCurly")
  end
  self.locations.maPignon.requirements = function(items)
    -- stupid mushroom is invincible to the blade and machinegun for some reason
    if has(items, "flight") and has(items, "locket") and has(items, "mushroomBadge") then
      if has(items, "polarStar") or has(items, "fireball") or has(items, "bubbler")
      or has(items, "machineGun") or has(items, "snake") or has(items, "nemesis") then
        return true
      end
    end
    return false
  end

  self.locations.mrLittle:setItem(self.world.items:getByKey("mrLittle"))
end

local arthur = Region:extend()
function arthur:new(worldGraph)
  arthur.super.new(self, worldGraph, "arthur")
  self.locations = {
    risenBooster = Location("Professor Booster", "Pens1", "0652", self)
  }

  self.requirements = function(items)
    if self.world.regions.mimigaVillage:canAccess(items) and has(items, "arthursKey") then return true end
    return false
  end

  self.locations.risenBooster.requirements = function(items) return has(items, "eventCore") end
end

local eggCorridor1 = Region:extend()
function eggCorridor1:new(worldGraph)
  eggCorridor1.super.new(self, worldGraph, "eggCorridor1")
  self.locations = {
    basil = Location("Basil Spot", "Eggs", "0403", self),
    cthulhu = Location("Cthulhu's Abode", "Eggs", "0404", self),
    eggItem = Location("Egg Chest", "Egg6", "0201", self),
    observationChest = Location("Egg Observation Room Chest", "EggR", "0301", self),
    eventSue = Location("Saved Sue", nil, nil, self)
  }

  self.requirements = function(items) return self.world.regions.arthur:canAccess(items) end

  self.locations.eventSue.requirements = function(items) return has(items, "idCard") and has(items, "weaponBoss") end
  self.locations.eventSue:setItem(self.world.items:getByKey("eventSue"))
end

local grasstownWest = Region:extend()
function grasstownWest:new(worldGraph)
  grasstownWest.super.new(self, worldGraph, "grasstownWest")
  self.locations = {
    keySpot = Location("West Grasstown Floor", "Weed", "0700", self),
    jellyCapsule = Location("West Grasstown Ceiling", "Weed", "0701", self),
    santa = Location("Santa", "Santa", "0501", self),
    charcoal = Location("Santa's Fireplace", "Santa", "0302", self),
    chaco = Location("Chaco's Bed, where you two Had A Nap", "Chako", "0211", self),
    kulala = Location("Kulala Chest", "Weed", "0702", self)
  }

  self.requirements = function(items)
    if self.world.regions.arthur:canAccess(items) then return true end
    return false
  end

  self.locations.santa.requirements = function(items) return has(items, "santaKey") end
  self.locations.charcoal.requirements = function(items) return has(items, "santaKey") and has(items, "juice") end
  self.locations.chaco.requirements = function(items) return has(items, "santaKey") end
  self.locations.kulala.requirements = function(items) return has(items, "santaKey") and has(items, "weapon") end
end

local grasstownEast = Region:extend()
function grasstownEast:new(worldGraph)
  grasstownEast.super.new(self, worldGraph, "grasstownEast")
  self.locations = {
    kazuma1 = Location("Kazuma (Rusty Key)", "Weed", "0800", self),
    kazuma2 = Location("Kazuma (Gum Key)", "Weed", "0801", self),
    execution = Location("Execution Chamber", "WeedD", "0305", self),
    outsideHut = Location("Grasstown East Chest", "Weed", "0303", self),
    hutChest = Location("Grasstown Hut", "WeedB", "0301", self),
    gumChest = Location("Gum Chest", "Frog", "0300", self),
    malco = Location("MALCO", "Malco", "0350", self),
    eventFans = Location("Activated Grasstown Fans", nil, nil, self),
    eventKazuma = Location("Saved Kazuma", nil, nil, self)
  }

  self.requirements = function(items)
    if self.world.regions.grasstownWest:canAccess(items) then
      if has(items, "flight") or has(items, "juice") then return true end
    end
    if self.world.regions.plantation:canAccess(items) and has(items, "eventKazuma") and has(items, "weaponSN") then return true end
    return false
  end

  self.locations.kazuma2.requirements = function(items) return has(items, "eventFans") end
  self.locations.execution.requirements = function(items) return has(items, "weaponSN") end
  self.locations.hutChest.requirements = function(items) return has(items, "eventFans") or has(items, "flight") end
  self.locations.gumChest.requirements = function(items)
    if has(items, "gumKey") and has(items, "weaponBoss") then
      if has(items, "eventFans") or has(items, "flight") then return true end
    end
    return false
  end
  self.locations.malco.requirements = function(items) return has(items, "eventFans") and has(items, "juice") and has(items, "charcoal") and has(items, "gum") end
  
  self.locations.eventFans.requirements = function(items) return has(items, "rustyKey") and has(items, "weaponBoss") end
  self.locations.eventFans:setItem(self.world.items:getByKey("eventFans"))

  self.locations.eventKazuma.requirements = function(items) return has(items, "bomb") end
  self.locations.eventKazuma:setItem(self.world.items:getByKey("eventKazuma"))
end

local upperSandZone = Region:extend()
function upperSandZone:new(worldGraph)
  upperSandZone.super.new(self, worldGraph, "upperSandZone")
  self.locations = {
    curly = Location("Curly Boss", "Curly", "0518", self),
    panties = Location("Curly's Closet", "CurlyS", "0421", self),
    curlyPup = Location("Puppy (Curly)", "CurlyS", "0401", self),
    sandCapsule = Location("Polish Spot", "Sand", "0502", self),
    eventOmega = Location("Defeated Omega", nil, nil, self)
  }

  self.requirements = function(items)
    if self.world.regions.arthur:canAccess(items) and has(items, "weaponSN") then return true end
    return false
  end

  self.locations.curly.requirements = function(items) return has(items, "polarStar") end
  
  self.locations.eventOmega.requirements = function(items) return has(items, "weaponBoss") end
  self.locations.eventOmega:setItem(self.world.items:getByKey("eventOmega"))
end

local lowerSandZone = Region:extend()
function lowerSandZone:new(worldGraph)
  lowerSandZone.super.new(self, worldGraph, "lowerSandZone")
  self.locations = {
    chestPup = Location("Puppy (Chest)", "Sand", "0421", self),
    darkPup = Location("Puppy (Dark)", "Dark", "0401", self),
    runPup = Location("Puppy (Run)", "Sand", "0422", self),
    sleepyPup = Location("Puppy (Sleep)", "Sand", "0421", self),
    pawCapsule = Location("Pawprint Spot", "Sand", "0503", self),
    jenka = Location("Jenka", "Jenka2", "0221", self),
    king = Location("King", "Gard", "0602", self),
    eventToroko = Location("Defeated Toroko+", nil, nil, self)
  }

  self.requirements = function(items)
    if self.world.regions.upperSandZone:canAccess(items) and has(items, "eventOmega") then return true end
    return false
  end

  self.locations.jenka.requirements = function(items) return count(items, "puppy") == 5 end
  self.locations.king.requirements = function(items) return has(items, "eventToroko") end

  self.locations.eventToroko.requirements = function(items)
    return count(items, "puppy") == 5 and has(items, "weaponBoss")
  end
  self.locations.eventToroko:setItem(self.world.items:getByKey("eventToroko"))
end

local labyrinthW = Region:extend()
function labyrinthW:new(worldGraph)
  labyrinthW.super.new(self, worldGraph, "labyrinthW")
  self.locations = {
    mazeCapsule = Location("Labyrinth Life Capsule", "MazeI", "0301", self),
    turboChaba = Location("Chaba Chest (Machine Gun)", "MazeA", "0502", self),
    snakeChaba = Location("Chaba Chest (Fireball)", "MazeA", "0512", self),
    whimChaba = Location("Chaba Chest (Spur)", "MazeA", "0522", self),
    campChest = Location("Camp Chest", "MazeO", "0401", self),
    physician = Location("Dr. Gero", "MazeO", "0305", self),
    puuBlack = Location("Puu Black Boss", "MazeD", "0401", self)
  }

  self.requirements = function(items)
    if self.world.regions.lowerSandZone:canAccess(items) and has(items, "eventToroko") then return true end
    if self.world.regions.labyrinthB:canAccess(items) and has(items, "flight") then return true end
    return false
  end

  self.locations.mazeCapsule.requirements = function(items) return has(items, "weapon") end
  self.locations.turboChaba.requirements = function(items) return has(items, "machineGun") end
  self.locations.snakeChaba.requirements = function(items) return has(items, "fireball") end
  self.locations.whimChaba.requirements = function(items) return count(items, "polarStar") == 2 end
  self.locations.campChest.requirements = function(items) return has(items, "flight") end
  self.locations.puuBlack.requirements = function(items) return has(items, "clinicKey") and has(items, "weaponBoss") end
end

local labyrinthB = Region:extend()
function labyrinthB:new(worldGraph)
  labyrinthB.super.new(self, worldGraph, "labyrinthB")
  self.locations = {
    fallenBooster = Location("Booster Chest", "MazeB", "0502", self)
  }

  self.requirements = function(items)
    if self.world.regions.arthur:canAccess(items) then return true end
    if self.world.regions.labyrinthW:canAccess(items) then return true end
    return false
  end
end

local boulder = Region:extend()
function boulder:new(worldGraph)
  boulder.super.new(self, worldGraph, "boulder")
  self.locations = { --include core locations since core access reqs are identical to boulder chamber
    boulderChest = Location("Boulder Chest", "MazeS", "0202", self),
    coreSpot = Location("Robot's Arm", "Almond", "0243", self),
    curlyCorpse = Location("Drowned Curly", "Almond", "1111", self),
    eventCore = Location("Defeated Core", nil, nil, self)
  }

  self.requirements = function(items)
    if has(items, "cureAll") and has(items, "weaponBoss") then
      if self.world.regions.labyrinthW:canAccess(items) then return true end
      if self.world.regions.labyrinthB:canAccess(items) and has(items, "flight") then return true end
    end
    return false
  end

  self.locations.eventCore:setItem(self.world.items:getByKey("eventCore"))
end

local labyrinthM = Region:extend()
function labyrinthM:new(worldGraph)
  labyrinthM.super.new(self, worldGraph, "labyrinthM")
  
  self.requirements = function(items)
    if self.world.regions.boulder:canAccess(items) then return true end
    if self.world.regions.labyrinthW:canAccess(items) and has(items, "flight") then return true end
    return false
  end
end

local waterway = Region:extend()
function waterway:new(worldGraph)
  waterway.super.new(self, worldGraph, "waterway")

  self.locations = {
    ironhead = Location("Ironhead Boss", "Pool", "0412", self),
    eventCurly = Location("Saved Curly", nil, nil, self)
  }

  self.requirements = function(items) return self.world.regions.labyrinthM:canAccess(items) and has(items, "airTank") and has(items, "weaponBoss") end

  self.locations.eventCurly.requirements = function(items) return has(items, "eventCore") and has(items, "towRope") end
  self.locations.eventCurly:setItem(self.world.items:getByKey("eventCurly"))
end

local eggCorridor2 = Region:extend()
function eggCorridor2:new(worldGraph)
  eggCorridor2.super.new(self, worldGraph, "eggCorridor2")

  self.locations = {
    dragonChest = Location("Dragon Chest", "Eggs2", "0321", self),
    sisters = Location("Sisters Boss", "EggR2", "0303", self)
  }

  self.requirements = function(items)
    if has(items, "eventCore") and self.world.regions.arthur:canAccess(items) then return true end
    if has(items, "eventKazuma") and self.world.regions.outerWall:canAccess(items) then return true end
    return false
  end

  self.locations.dragonChest.requirements = function(items) return has(items, "weapon") end
  self.locations.sisters.requirements = function(items) return has(items, "weaponBoss") end
end

local outerWall = Region:extend()
function outerWall:new(worldGraph)
  outerWall.super.new(self, worldGraph, "outerWall")

  self.locations = {
    clock = Location("Clock Room", "Clock", "0300", self),
    littleHouse = Location("Little House", "Little", "0204", self)
  }

  self.requirements = function(items)
    if has(items, "eventKazuma") and has(items, "flight") and self.world.regions.eggCorridor2:canAccess(items) then return true end
    if has(items, "teleportKey") and self.world.regions.plantation:canAccess(items) then return true end
    return false
  end

  self.locations.littleHouse.requirements = function(items) return has(items, "flight") end
end

local plantation = Region:extend()
function plantation:new(worldGraph)
  plantation.super.new(self, worldGraph, "plantation")

  self.locations = {
    kanpachi = Location("Kanpachi's Bucket", "Cent", "0268", self),
    jail1 = Location("Jail no. 1", "Jail1", "0301", self),
    momorin = Location("Chivalry Sakamoto's Wife", "Momo", "0201", self),
    sprinkler = Location("Broken Sprinkler", "Cent", "0417", self),
    megane = Location("Megane", "lounge", "0204", self),
    itoh = Location("Itoh", "Itoh", "0405", self),
    plantCeiling = Location("Plantation Platforming Spot", "Cent", "0501", self),
    plantPup = Location("Plantation Puppy", "Cent", "0452", self),
    curlyShroom = Location("Jammed it into Curly's Mouth", "Cent", "0324", self),
    eventRocket = Location("Built Rocket", nil, nil, self)
  }

  self.requirements = function(items)
    if has(items, "teleportKey") and self.world.regions.arthur:canAccess(items) then return true end
    if self.world.regions.outerWall:canAccess(items) then return true end
    return false
  end

  self.locations.jail1.requirements = function(items) return has(items, "letter") end
  self.locations.momorin.requirements = function(items) return has(items, "letter") and has(items, "booster") end
  self.locations.sprinkler.requirements = function(items) return has(items, "mask") end
  self.locations.megane.requirements = function(items) return has(items, "brokenSprinkler") and has(items, "mask") end
  self.locations.itoh.requirements = function(items) return has(items, "letter") end
  self.locations.plantCeiling.requirements = function(items) return has(items, "flight") end
  self.locations.plantPup.requirements = function(items) return has(items, "eventRocket") end
  self.locations.curlyShroom.requirements = function(items) return has(items, "eventCurly") and has(items, "maPignon") end

  self.locations.eventRocket.requirements = function(items)
    return has(items, "letter") and has(items, "booster") and has(items, "controller") and has(items, "sprinkler")
  end
  self.locations.eventRocket:setItem(self.world.items:getByKey("eventRocket"))
end

local lastCave = Region:extend()
function lastCave:new(worldGraph)
  lastCave.super.new(self, worldGraph, "lastCave")

  self.locations = {
    redDemon = Location("Red Demon Boss", "Priso2", "0300", self)
  }

  self.requirements = function(items) return has(items, "eventRocket") and has(items, "weaponBoss") end
end

local endgame = Region:extend()
function endgame:new(worldGraph)
  endgame.super.new(self, worldGraph, "endgame")

  self.locations = {
    hellB1 = Location("Hell B1 Spot", "Hell1", "0401", self),
    hellB3 = Location("Hell B3 Chest", "Hell3", "0400", self)
  }

  self.requirements = function(items)
    return has(items, "eventSue") and has(items, "ironBond") and self.world.regions.lastCave:canAccess(items)
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
  for region in ipairs(self.regions) do
    locations = _.union(locations, region:getLocations())
  end
  return locations
end

function worldGraph:getLocationsByRegion(...)
  local locations = {}
  for region in ipairs(self.regions) do
    if _.contains({...}, region.name) then locations = _.union(locations, region:getLocations()) end
  end
  return locations
end

function worldGraph:getEmptyLocations()
  local locations = {}
  for region in ipairs(self.regions) do
    locations = _.union(locations, region:getEmptyLocations())
  end
  return locations
end

function worldGraph:getFilledLocations()
  local locations = {}
  for region in ipairs(self.regions) do
    locations = _.union(locations, region:getFilledLocations())
  end
  return locations
end

function worldGraph:writeItems(tscFiles)
  for region in ipairs(self.regions) do region:writeItems(tscFiles) end
end

function worldGraph:collect(preCollectedItems)
  local collected = preCollectedItems or {}
  local availableLocations = self:getFilledLocations()

  local foundItems

  repeat
    local accessible = {}
    for location in ipairs(availableLocations) do
      if location:canAccess(collected) then table.insert(accessible, location) end
    end
    
    availableLocations = _.difference(availableLocations, accessible)

    foundItems = #accesible
    for location in ipairs(accessible) do
      table.insert(collected, location.item)
    end
  until foundItems == 0

  return collected
end

return worldGraph