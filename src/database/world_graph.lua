local Region = require 'database.region'
local Location = require 'database.location'

function _has(items, attribute)
  return _count(items, attribute, 1)
end

function _num(items, attribute)
  return #_.filter(items, function(k,v) return _.contains(v.attributes or {}, attribute) end)
end

function _count(items, attribute, num)
  return _num(items, attribute) >= num
end

function _hp(items, hp)
  return 3 + (_num(items, "hp3") * 3) + (_num(items, "hp4") * 4) + (_num(items, "hp5") * 5)
end

local firstCave = Region:extend()
function firstCave:new(worldGraph)
  firstCave.super.new(self, worldGraph, "First Cave", {"in First Cave"})
  self.locations = {
    firstCapsule = Location("First Cave Life Capsule", "Cave", "0401", self),
    gunsmithChest = Location("Hermit Gunsmith Chest", "Pole", "0202", self, {"at someone's house", "with Tetsuzou"}),
    gunsmith = Location("Tetsuzou", "Pole", "0303", self, {"at someone's house", "with Tetsuzou"}),
    objective = Location("Game Settings", "Start", "0201", self)
  }

  self.requirements = function(self, items)
    if self.world:StartPoint() then
      return true
    elseif self.world:Arthur() or self.world:Camp() then
      return _has(items, "flight") and _has(items, "weaponSN") and self.world.regions.mimigaVillage:canAccess(items)
    end
  end

  self.locations.gunsmith.requirements = function(self, items)
    return _has(items, "flight") and _has(items, "polarStar") and _has(items, "eventCore") and self.region.world.regions.mimigaVillage:canAccess(items)
  end
end

local mimigaVillage = Region:extend()
function mimigaVillage:new(worldGraph)
  mimigaVillage.super.new(self, worldGraph, "Mimiga Village", {"in Mimiga Village"})
  self.locations = {
    yamashita = Location("Yamashita Farm", "Plant", "0401", self, {"underwater", "in a garden"}),
    reservoir = Location("Reservoir", "Pool", "0301", self, {"underwater"}),
    mapChest = Location("Mimiga Village Chest", "Mimi", "0202", self),
    assembly = Location("Assembly Hall Fireplace", "Comu", "0303", self, {"in a fireplace"}),
    mrLittle = Location("Mr. Little (Graveyard)", "Cemet", "0202", self, {"in the Graveyard", "with a very little man, hiding in the grass"}),
    grave = Location("Arthur's Grave", "Cemet", "0301", self, {"with a fallen hero..", "in the Graveyard"}),
    mushroomChest = Location("Storage? Chest", "Mapi", "0202", self, {"in the Graveyard"}),
    maPignon = Location("Ma Pignon Boss", "Mapi", "0501", self, {"behind a boss", "behind Ma Pignon", "in the Graveyard"})
  }

  self.requirements = function(self, items)
    if self.world:StartPoint() then
      return _has(items, "weaponSN")
    elseif self.world:Camp() or self.world:Arthur() then
      return _has(items, "arthurKey") and self.world.regions.arthur:canAccess(items) or self.world.regions.waterway:canAccess(items)
    end
  end

  self.locations.assembly.requirements = function(self, items) return _has(items, "juice") end
  self.locations.mrLittle.requirements = function(self, items) return _has(items, "locket") end
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

  --self.locations.mrLittle:setItem(self.world.items:getByKey("mrLittle"))
end

local arthur = Region:extend()
function arthur:new(worldGraph)
  arthur.super.new(self, worldGraph, "Arthur's House", {"in Mimiga Village", "at Arthur's House", "at someone's house"})
  self.locations = {
    risenBooster = Location("Professor Booster", "Pens1", "0652", self)
  }

  self.requirements = function(self, items)
    if self.world:StartPoint() then
      return _has(items, "arthurKey") and _has(items, "weaponSN") and self.world.regions.mimigaVillage:canAccess(items)
    elseif self.world:Camp() then
      return self.world.regions.labyrinthB:canAccess(items)
    elseif self.world:Arthur() then
      return true
    end
  end

  self.locations.risenBooster.requirements = function(self, items) return _has(items, "eventCore") end
end

local eggCorridor1 = Region:extend()
function eggCorridor1:new(worldGraph)
  eggCorridor1.super.new(self, worldGraph, "Egg Corridor", {"in the Egg Corridor", "in the normal Egg Corridor"})
  self.locations = {
    basil = Location("Basil Spot", "Eggs", "0403", self),
    cthulhu = Location("Cthulhu's Abode", "Eggs", "0404", self),
    eggItem = Location("Egg Chest", "Egg6", "0201", self, {"in an egg"}),
    observationChest = Location("Egg Observation Room Chest", "EggR", "0301", self, {"in the Egg Observation Room"}),
    eventSue = Location("Saved Sue", nil, nil, self)
  }

  self.requirements = function(self, items) return self.world.regions.arthur:canAccess(items) end

  self.locations.cthulhu.requirements = function(self, items) return _has(items, "weaponSN") or _has(items, "flight") or self.region.world:_dboost(items, 'cthulhu') end
  self.locations.eventSue.requirements = function(self, items) return _has(items, "idCard") and _has(items, "weaponBoss") end
  self.locations.eventSue:setItem(self.world.items:getByKey("eventSue"))
end

local grasstownWest = Region:extend()
function grasstownWest:new(worldGraph)
  grasstownWest.super.new(self, worldGraph, "Grasstown (West)", {"in Grasstown", "in West Grasstown"})
  self.locations = {
    keySpot = Location("West Grasstown Floor", "Weed", "0700", self),
    jellyCapsule = Location("West Grasstown Ceiling", "Weed", "0701", self),
    santa = Location("Santa", "Santa", "0501", self, {"at Santa's House", "at someone's house"}),
    charcoal = Location("Santa's Fireplace", "Santa", "0302", self, {"at Santa's House", "at someone's house", "in a fireplace"}),
    chaco = Location("Chaco's Bed, where you two Had A Nap", "Chako", "0211", self, {"at Chaco's House", "in Chaco's bed", "at someone's house"}),
    kulala = Location("Kulala Chest", "Weed", "0702", self, {"in a sticky situation"})
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
  grasstownEast.super.new(self, worldGraph, "Grasstown (East)", {"in Grasstown", "in East Grasstown"})
  self.locations = {
    kazuma1 = Location("Kazuma Crack", "Weed", "0800", self, {"with Kazuma", "at the Shelter"}),
    kazuma2 = Location("Kazuma Chest", "Weed", "0801", self, {"at the Shelter"}),
    execution = Location("Execution Chamber", "WeedD", "0305", self),
    outsideHut = Location("Grasstown East Chest", "Weed", "0303", self, {"at Grasstown Hut"}),
    hutChest = Location("Grasstown Hut", "WeedB", "0301", self, {"at Grasstown Hut"}),
    gumChest = Location("Gum Chest", "Frog", "0300", self, {"behind a boss", "behind Balfrog"}),
    malco = Location("MALCO", "Malco", "0350", self, {"with MALCO", "behind a boss", "behind Balrog 2"}),
    eventFans = Location("Activated Grasstown Fans", nil, nil, self),
    eventKazuma = Location("Saved Kazuma", nil, nil, self)
  }

  self.requirements = function(self, items)
    if not self.world.regions.arthur:canAccess(items) then return false end
    if _has(items, "flight") or _has(items, "juice") or (self.world:_dboost(items, 'chaco') and _has(items, "weapon")) or self.world:_dboost(items, 'paxChaco') then
      if self.world.regions.grasstownWest:canAccess(items) then return true end
    end
    if _has(items, "eventKazuma") and _has(items, "weaponSN") and self.world.regions.plantation:canAccess(items) then return true end
    return false
  end

  self.locations.kazuma2.requirements = function(self, items) return _has(items, "rustyKey") end
  self.locations.execution.requirements = function(self, items) return _has(items, "weaponSN") end
  self.locations.hutChest.requirements = function(self, items) return _has(items, "eventFans") or _has(items, "flight") or self.region.world:_dboost(items, 'flightlessHut') end
  self.locations.gumChest.requirements = function(self, items)
    if _has(items, "gumKey") and _has(items, "weaponBoss") then
      if _has(items, "eventFans") or _has(items, "flight") then return true end
    end
    return false
  end
  self.locations.malco.requirements = function(self, items) return _has(items, "eventFans") and _has(items, "juice") and _has(items, "charcoal") and _has(items, "gumBase") end
  self.locations.malco.getPrebuiltHint = function(self) return ("BUT ALL I KNOW HOW TO DO IS MAKE %s..."):format(self.item.hints[love.math.random(#self.item.hints)]:upper()) end

  self.locations.eventFans.requirements = function(self, items) return _has(items, "rustyKey") and _has(items, "weaponBoss") end
  self.locations.eventFans:setItem(self.world.items:getByKey("eventFans"))

  self.locations.eventKazuma.requirements = function(self, items) return _has(items, "bomb") end
  self.locations.eventKazuma:setItem(self.world.items:getByKey("eventKazuma"))
end

local upperSandZone = Region:extend()
function upperSandZone:new(worldGraph)
  upperSandZone.super.new(self, worldGraph, "Sand Zone (Upper)", {"in the Sand Zone", "in Upper Sand Zone"})
  self.locations = {
    curly = Location("Curly Boss", "Curly", "0518", self, {"in the Sand Zone Residence", "with Curly", "at someone's house"}),
    panties = Location("Curly's Closet", "CurlyS", "0421", self, {"in the Sand Zone Residence", "at someone's house"}),
    curlyPup = Location("Puppy (Curly)", "CurlyS", "0401", self, {"in the Sand Zone Residence", "at someone's house", "where a puppy once was"}),
    sandCapsule = Location("Polish Spot", "Sand", "0502", self),
    eventOmega = Location("Defeated Omega", nil, nil, self)
  }

  self.requirements = function(self, items)
    return self.world.regions.arthur:canAccess(items) and _has(items, "weaponSN")
  end

  self.locations.curly.requirements = function(self, items) return _has(items, "polarStar") end
  
  self.locations.panties.requirements = function(self, items) return _has(items, "weaponBoss") end
  self.locations.curlyPup.requirements = function(self, items) return _has(items, "weaponBoss") end
  
  self.locations.eventOmega.requirements = function(self, items) return _has(items, "weaponBoss") end
  self.locations.eventOmega:setItem(self.world.items:getByKey("eventOmega"))
end

local lowerSandZone = Region:extend()
function lowerSandZone:new(worldGraph)
  lowerSandZone.super.new(self, worldGraph, "Sand Zone (Lower)", {"in the Sand Zone", "in Lower Sand Zone"})
  self.locations = {
    chestPup = Location("Puppy (Chest)", "Sand", "0423", self, {"where a puppy once was"}),
    darkPup = Location("Puppy (Dark)", "Dark", "0401", self, {"where a puppy once was"}),
    runPup = Location("Puppy (Run)", "Sand", "0422", self, {"where a puppy once was", "with a puppy"}),
    sleepyPup = Location("Puppy (Sleep)", "Sand", "0421", self, {"where a puppy once was", "at the far end of Sand Zone"}),
    pawCapsule = Location("Pawprint Spot", "Sand", "0503", self),
    jenka = Location("Jenka", "Jenka2", "0221", self, {"with Jenka", "at someone's house", "where a puppy once was"}),
    king = Location("King", "Gard", "0602", self, {"with a fallen hero..", "in a garden", "behind a boss", "behind Toroko+"}),
    eventToroko = Location("Defeated Toroko+", nil, nil, self)
  }

  self.requirements = function(self, items)
    if self.world:StartPoint() or self.world:Arthur() then
      return _has(items, "eventOmega") and self.world.regions.upperSandZone:canAccess(items)
    elseif self.world:Camp() then
      return self.world.regions.labyrinthW:canAccess(items)
    end
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
  labyrinthW.super.new(self, worldGraph, "Labyrinth (West)", {"in the Labyrinth", "in West Labyrinth"})
  self.locations = {
    mazeCapsule = Location("Labyrinth Life Capsule", "MazeI", "0301", self),
    turboChaba = Location("Chaba Chest (Machine Gun)", "MazeA", "0502", self, {"with Chaba", "in Chaba's Machine Gun chest"}),
    snakeChaba = Location("Chaba Chest (Fireball)", "MazeA", "0512", self, {"with Chaba", "in Chaba's Fireball chest"}),
    whimChaba = Location("Chaba Chest (Spur)", "MazeA", "0522", self, {"with Chaba", "in Chaba's Spur chest"}),
    campChest = Location("Camp Chest", "MazeO", "0401", self, {"in the Camp"}),
    physician = Location("Dr. Gero", "MazeO", "0305", self, {"in the Camp"}),
    puuBlack = Location("Puu Black Boss", "MazeD", "0201", self)
  }

  self.requirements = function(self, items)
    if self.world:StartPoint() or self.world:Arthur() then
      if not self.world.regions.arthur:canAccess(items) then return false end
      if _has(items, "eventToroko") and self.world.regions.lowerSandZone:canAccess(items) then return true end
      if _has(items, "flight") and _has(items, "weaponBoss") and self.world.regions.labyrinthB:canAccess(items) then return true end
      return false
    elseif self.world:Camp() then
      return true
    end
  end

  self.locations.mazeCapsule.requirements = function(self, items) return _has(items, "weapon") end
  self.locations.turboChaba.requirements = function(self, items) return _has(items, "machineGun") end
  self.locations.snakeChaba.requirements = function(self, items) return _has(items, "fireball") end
  self.locations.whimChaba.requirements = function(self, items) return _count(items, "polarStar", 2) end
  self.locations.campChest.requirements = function(self, items) return _has(items, "flight") or self.region.world:Camp() or self.region.world:_dboost(items, 'camp') end
  self.locations.puuBlack.requirements = function(self, items) return _has(items, "clinicKey") and _has(items, "weaponBoss") end

end

local labyrinthB = Region:extend()
function labyrinthB:new(worldGraph)
  labyrinthB.super.new(self, worldGraph, "Labyrinth B", {"in the Labyrinth"})
  self.locations = {
    fallenBooster = Location("Booster Chest", "MazeB", "0502", self)
  }

  self.requirements = function(self, items)
    if self.world:StartPoint() or self.world:Arthur() then
      return self.world.regions.arthur:canAccess(items)
    elseif self.world:Camp() then
      return self.world.regions.labyrinthW:canAccess(items) and _has(items, "weaponBoss")
    end
  end
end

local boulder = Region:extend()
function boulder:new(worldGraph)
  boulder.super.new(self, worldGraph, "Labyrinth (East)", {"in the Labyrinth", "in East Labyrinth", "behind a boss"})
  self.locations = { --include core locations since core access reqs are identical to boulder chamber
    boulderChest = Location("Boulder Chest", "MazeS", "0202", self, {"behind Balrog 3"}),
    coreSpot = Location("Robot's Arm", "Almond", "0243", self, {"underwater", "behind the Core"}),
    curlyCorpse = Location("Drowned Curly", "Almond", "1111", self, {"with Curly", "underwater", "behind the Core"}),
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
  waterway.super.new(self, worldGraph, "Waterway", {"in the Waterway", "underwater", "behind a boss", "behind Ironhead"})

  self.locations = {
    ironhead = Location("Ironhead Boss", "Pool", "0412", self),
    eventCurly = Location("Saved Curly", nil, nil, self)
  }

  self.requirements = function(self, items)
    if _has(items, "airTank") and _has(items, "weaponBoss") and self.world.regions.labyrinthM:canAccess(items) then return true end
    return false
  end

  self.locations.eventCurly.requirements = function(self, items) return _has(items, "eventCore") and _has(items, "towRope") end
  self.locations.eventCurly:setItem(self.world.items:getByKey("eventCurly"))
end

local eggCorridor2 = Region:extend()
function eggCorridor2:new(worldGraph)
  eggCorridor2.super.new(self, worldGraph, "Egg Corridor?", {"in the Egg Corridor", "in ruined Egg Corridor"})

  self.locations = {
    dragonChest = Location("Dragon Chest", "Eggs2", "0321", self),
    sisters = Location("Sisters Boss", "EggR2", "0303", self, {"behind a boss", "in the Egg Observation Room", "behind the Sisters"})
  }

  self.requirements = function(self, items)
    if not self.world.regions.arthur:canAccess(items) then return false end
    if _has(items, "eventCore") then return true end
    if _has(items, "eventKazuma") and self.world.regions.outerWall:canAccess(items) then return true end
    return false
  end

  self.locations.dragonChest.requirements = function(self, items) return _has(items, "weaponSN") or _has(items, "eventCore") end
  self.locations.sisters.requirements = function(self, items) return _has(items, "weaponBoss") or (self.region.world:_dboost(items, 'sisters') and _has(items, "flight")) end
end

local outerWall = Region:extend()
function outerWall:new(worldGraph)
  outerWall.super.new(self, worldGraph, "Outer Wall", {"outside", "along the Outer Wall"})

  self.locations = {
    clock = Location("Clock Room", "Clock", "0300", self),
    littleHouse = Location("Little House", "Little", "0204", self, {"with Mr. Little", "at someone's house"})
  }

  self.requirements = function(self, items)
    if not self.world.regions.arthur:canAccess(items) and (_has(items, "weapon") or _hp(items) >= 9 or _has(items, "flight")) then return false end
    if _has(items, "eventKazuma") and _has(items, "flight") and _has(items, "eventCore") then return true end
    if _has(items, "teleportKey") and self.world.regions.plantation:canAccess(items) then return true end
    return false
  end

  self.locations.littleHouse.requirements = function(self, items) return _has(items, "flight") and _has(items, "blade") and _has(items, "mrLittle") end
  self.locations.littleHouse.getPrebuiltHint = function(self) return ("He was exploring the island with %s..."):format(self.item.hints[love.math.random(#self.item.hints)]) end
end

local plantation = Region:extend()
function plantation:new(worldGraph)
  plantation.super.new(self, worldGraph, "Plantation", {"in the Plantation", "in a garden"})

  self.locations = {
    kanpachi = Location("Kanpachi's Bucket", "Cent", "0268", self, {"with Kanpachi", "underwater"}),
    jail1 = Location("Jail no. 1", "Jail1", "0301", self, {"with Mahin"}),
    momorin = Location("Chivalry Sakamoto's Wife", "Momo", "0201", self, {"with Momorin", "at someone's house"}),
    sprinkler = Location("Broken Sprinkler", "Cent", "0417", self, {"for Mimiga only"}),
    megane = Location("Megane", "Lounge", "0204", self, {"for Mimiga only"}),
    itoh = Location("Itoh", "Itoh", "0405", self, {"with Itoh"}),
    plantCeiling = Location("Plantation Platforming Spot", "Cent", "0501", self),
    plantPup = Location("Plantation Puppy", "Cent", "0452", self, {"with a puppy"}),
    curlyShroom = Location("Jammed it into Curly's Mouth", "Cent", "0324", self, {"with Curly"}),
    eventRocket = Location("Built Rocket", nil, nil, self)
  }

  self.requirements = function(self, items)
    if not self.world.regions.arthur:canAccess(items) then return false end
    if _has(items, "teleportKey") then return true end
    if self.world.regions.outerWall:canAccess(items) then return true end
    if _has(items, "eventKazuma") and _has(items, "weaponSN") then return true end
    return false
  end

  self.locations.jail1.requirements = function(self, items) return _has(items, "teleportKey") end
  self.locations.momorin.requirements = function(self, items) return _has(items, "letter") and _has(items, "booster") end
  self.locations.sprinkler.requirements = function(self, items) return _has(items, "mask") end
  self.locations.megane.requirements = function(self, items) return _has(items, "brokenSprinkler") and _has(items, "mask") end
  self.locations.itoh.requirements = function(self, items) return _has(items, "letter") end
  self.locations.plantCeiling.requirements = function(self, items) return _has(items, "flight") or self.region.world:_dboost(items, 'plantation') end
  self.locations.plantPup.requirements = function(self, items) return _has(items, "eventRocket") end
  self.locations.curlyShroom.requirements = function(self, items) return _has(items, "eventCurly") and _has(items, "maPignon") end

  self.locations.eventRocket.requirements = function(self, items)
    return _has(items, "letter") and _has(items, "booster") and _has(items, "controller") and _has(items, "newSprinkler")
  end
  self.locations.eventRocket:setItem(self.world.items:getByKey("eventRocket"))
end

local lastCave = Region:extend()
function lastCave:new(worldGraph)
  lastCave.super.new(self, worldGraph, "Last Cave", {"behind a boss", "in Last Cave", "behind the Red Demon"})

  self.locations = {
    redDemon = Location("Red Demon Boss", "Priso2", "0300", self)
  }

  self.requirements = function(self, items) return _has(items, "weaponBoss") and _count(items, "booster", 2) and (_has(items, "eventRocket") or (self.world:_dboost(items, 'rocket') and _has(items, "machineGun") and self.world.regions.plantation:canAccess(items))) end
end

local endgame = Region:extend()
function endgame:new(worldGraph)
  endgame.super.new(self, worldGraph, "Sacred Grounds", {"in Hell"})

  self.locations = {
    hellB1 = Location("Hell B1 Spot", "Hell1", "0401", self),
    hellB3 = Location("Hell B3 Chest", "Hell3", "0400", self)
  }

  self.requirements = function(self, items)
    return _has(items, "eventSue") and _has(items, "ironBond") and self.world.regions.lastCave:canAccess(items)
  end
end

local hintRegion = Region:extend()
function hintRegion:new(worldGraph)
  hintRegion.super.new(self, worldGraph, "Hints")

  self.locations = {
    cthulhuEgg = Location("Cthulhu (his Abode)", "Cthu", "0200", self),
    cthulhuWeed1 = Location("Cthulhu (West Grasstown)", "Weed", "0201", self),
    cthulhuWeed2 = Location("Cthulhu (East Grasstown)", "Weed", "0205", self),
    cthulhuPlant = Location("Cthulhu (Plantation)", "Cent", "0310", self),
    bluebotEgg = Location("Blue Robot (Egg Corridor)", "Eggs", "0200", self),
    bluebotEgg2 = Location("Blue Robot (Egg Corridor?)", "Eggs2", "0210", self),
    bluebotMaze = Location("Blue Robot (Labyrinth I #1)", "MazeI", "0500", self),
    bluebotMaze2 = Location("Blue Robot (Labyrinth I #2)", "MazeI", "0502", self),
    mrsLittle = Location("Mrs. Little", "Little", "0212", self),
    malco = Location("MALCO", "Malco", "0306", self)
  }

  -- they'll appear as filled so they get left out of the regular hints
  self.locations.mrsLittle.item = {}
  self.locations.malco.item = {}
end

local worldGraph = Class:extend()

function worldGraph:new(items)
  self.items = items
  self.order = 0
  self.spawn = ""

  self.seqbreak = false
  self.dboosts = {
    cthulhu = {hp = 3, enabled = true},
    chaco = {hp = 5, enabled = true},
    paxChaco = {hp = 10, enabled = true},
    flightlessHut = {hp = 3, enabled = true},
    -- revChaco = {hp = 3, enabled = true},
    -- paxRevChaco = {hp = 8, enabled = true},
    camp = {hp = 9, enabled = true},
    sisters = {hp = 0, enabled = true},
    plantation = {hp = 15, enabled = true},
    rocket = {hp = 3, enabled = true},
  }

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

  self.hintregion = hintRegion(self)

  self.noFallingBlocks = false
end

function worldGraph:_dboost(items, key)
  return self.seqbreak and self.dboosts[key].enabled and _hp(items) > self.dboosts[key].hp
end

function worldGraph:StartPoint() return self.spawn == "Start Point" end
function worldGraph:Arthur() return self.spawn == "Arthur's House" end
function worldGraph:Camp() return self.spawn == "Camp" end

function worldGraph:getSpawnScript()
  if self:StartPoint() then return "<FL+6200<EVE0091" end
  local earlyGameFlags = "<FL+0301<FL+0302<FL+1641<FL+1642<FL+0320<FL+0321"
  if self:Arthur() then return "<FL+6201" .. earlyGameFlags .. "<TRA0001:0094:0008:0004" end
  if self:Camp() then return "<FL+6202" .. earlyGameFlags .. "<TRA0040:0094:0014:0009" end
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

function worldGraph:getObjectiveSpot()
  return {self.regions.firstCave.locations.objective}
end

function worldGraph:getMALCO()
  return {self.regions.grasstownEast.locations.malco}
end

function worldGraph:getCamp()
  return {self.regions.labyrinthW.locations.physician, self.regions.labyrinthW.locations.campChest}
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

function worldGraph:getFilledLocations(realOnly)
  local locations = {}
  for key, region in pairs(self.regions) do
    for k, location in pairs(region:getFilledLocations()) do
      if not realOnly or not (_.find(location.item.attributes,"abstract") or _.find(location.item.attributes,"mrLittle")) then table.insert(locations, location) end
    end
  end
  return locations
end

function worldGraph:getHintLocations()
  return self.hintregion:getEmptyLocations()
end

function worldGraph:getHintableLocations(obj)
  local locations = {}
  for k, location in pairs(_.shuffle(self:getFilledLocations(true))) do
    if (obj == "objBadEnd" and location.item.name == "Rusty Key") or (obj ~= "objBadEnd" and location.item.name == "ID Card") then 
      table.insert(locations, 1, location) -- put that item on the top to guarantee a hint for it
    elseif (self:Camp() or self:Arthur()) and location.item.name == "Arthur's Key" then
      table.insert(locations, 1, location)
    elseif location:getPrebuiltHint() ~= nil then
      -- do nothing
    else
      table.insert(locations, location)
    end
  end
  return _.slice(locations, 1, #self:getHintLocations())
end

function worldGraph:writeItems(tscFiles)
  for key, region in pairs(self.regions) do region:writeItems(tscFiles) end
  self.hintregion:writeItems(tscFiles)
end

function worldGraph:collect(preCollectedItems)
  local collected = _.clone(preCollectedItems) or {}
  local availableLocations = self:getFilledLocations()

  local foundItems = 0
  repeat
    foundItems = 0
    -- Collect accessible items and remove those locations from the table
    -- (to prevent double-collecting, which is bad for Polar Star/Booster)
    local j, n = 1, #availableLocations
    for i = 1, n do
      local location = availableLocations[i]
      if location:canAccess(collected) then
        table.insert(collected, location.item)
        foundItems = foundItems + 1
        availableLocations[i] = nil
      else
        if j ~= i then
          availableLocations[j] = availableLocations[i]
          availableLocations[i] = nil
        end
        j = j + 1
      end
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
  local array = {}
  for k,v in pairs(self.regions) do
    table.insert(array, v)
  end
  table.insert(array, self.hintregion)
  local function sort(a,b)
    return a.order < b.order
  end

  for k,r in ipairs(_.sort(array,sort)) do
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