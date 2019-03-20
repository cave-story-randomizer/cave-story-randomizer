local function lifeCapsule3()
  return {
    name = "Life Capsule",
    script = "<EVE0012",
    attributes = {"nonProgressive"}
  }
end
local function lifeCapsule4()
  return {
    name = "Life Capsule",
    script = "<EVE0013",
    attributes = {"nonProgressive"}
  }
end
local function lifeCapsule5()
  return {
    name = "Life Capsule",
    script = "<EVE0014",
    attributes = {"nonProgressive"}
  }
end

local function missiles()
  return {
    name = "Missile Expansion",
    script = "<EVE0030",
    attributes = {"missileLauncher", "nonProgressive"}
  }
end

local function event(n)
  return {
    name = "Event: " .. n,
    attributes = {"event"},
    placed = true
  }
end

local function _itemData()
  local data = {
    -------------
    -- WEAPONS --
    -------------
    polarStar1 = {
      name = "Polar Star",
      script = "<EVE0002",
      attributes = {"weaponBoss", "weaponSN", "polarStar"}
    },
    polarStar2 = {
      name = "Polar Star",
      script = "<EVE0002",
      attributes = {"weaponBoss", "weaponSN", "polarStar"}
    },
    missileLauncher = {
      name = "Missile Launcher",
      script = "<EVE0030",
      attributes = {"weaponSN", "nonProgressive"}
    },
    superMissileLauncher = {
      name = "Super Missile Launcher",
      script = "<EVE0033",
      attributes = {"weaponSN", "missileLauncher", "nonProgressive"}
    },
    fireball = {
      name = "Fireball",
      script = "<EVE0004",
      attributes = {"weaponBoss"}
    },
    snake = {
      name = "Snake",
      script = "<EVE0005",
      attributes = {"weaponBoss", "nonProgressive"}
    },
    bubbler = {
      name = "Bubbler",
      script = "<EVE0007",
      attributes = {"weaponBoss", "weaponSN", "nonProgressive"}
    },
    machineGun = {
      name = "Machine Gun",
      script = "<EVE0008",
      attributes = {"weaponBoss", "flight"}
    },
    blade = {
      name = "Blade",
      script = "<EVE0009",
      attributes = {"weaponBoss", "weaponSN"}
    },
    nemesis = {
      name = "Nemesis",
      script = "<EVE0010",
      attributes = {"weaponBoss", "weaponSN", "nonProgressive"}
    },

    ---------------
    -- INVENTORY --
    ---------------
    mapSystem = {
      name = "Map System",
      script = "<EVE0052",
      attributes = {"nonProgressive"}
    },
    locket = {
      name = "Silver Locket",
      script = "<EVE0054"
    },
    arthurKey = {
      name = "Arthur's Key",
      script = "<EVE0051"
    },
    idCard = {
      name = "ID Card",
      script = "<EVE0057"
    },
    santaKey = {
      name = "Santa's Key",
      script = "<EVE0053"
    },
    lipstick = {
      name = "Chaco's Lipstick",
      script = "<EVE0087",
      attributes = {"nonProgressive"}
    },
    juice = {
      name = "Jellyfish Juice",
      script = "<EVE0058"
    },
    charcoal = {
      name = "Charcoal",
      script = "<EVE0062"
    },
    rustyKey = {
      name = "Rusty Key",
      script = "<EVE0039"
    },
    gumKey = {
      name = "Gum Key",
      script = "<EVE0060"
    },
    gumBase = {
      name = "Gum Base",
      script = "<EVE0061"
    },
    bomb = {
      name = "Bomb",
      script = "<EVE0063"
    },
    panties = {
      name = "Curly's Panties",
      script = "<EVE0085",
      attributes = {"nonProgressive"}
    },
    puppy1 = {
      name = "Hajime",
      script = "<EVE0064",
      attributes = {"puppy"}
    },
    puppy2 = {
      name = "Kakeru",
      script = "<EVE0064",
      attributes = {"puppy"}
    },
    puppy3 = {
      name = "Mick",
      script = "<EVE0064",
      attributes = {"puppy"}
    },
    puppy4 = {
      name = "Nene",
      script = "<EVE0064",
      attributes = {"puppy"}
    },
    puppy5 = {
      name = "Shinobu",
      script = "<EVE0064",
      attributes = {"puppy"}
    },
    lifepot = {
      name = "Life Pot",
      script = "<EVE0065",
      attributes = {"nonProgressive"}
    },
    turbocharge = {
      name = "Turbocharge",
      script = "<EVE0070",
      attributes = {"nonProgressive"}
    },
    clinicKey = {
      name = "Clinic Key",
      script = "<EVE0067"
    },
    armsBarrier = {
      name = "Arms Barrier",
      script = "<EVE0069",
      attributes = {"nonProgressive"}
    },
    cureAll = {
      name = "Cure-All",
      script = "<EVE0066"
    },
    booster1 = {
      name = "Booster",
      script = "<EVE0068",
      attributes = {"flight", "booster"}
    },
    booster2 = {
      name = "Booster",
      script = "<EVE0068",
      attributes = {"flight", "booster"}
    },
    towRope = {
      name = "Tow Rope",
      script = "<EVE0080"
    },
    airTank = {
      name = "Curly's Air Tank",
      script = "<EVE0071"
    },
    alienMedal = {
      name = "Alien Medal",
      script = "<EVE0086",
      attributes = {"nonProgressive"}
    },
    whimsicalStar = {
      name = "Whimsical Star",
      script = "<EVE0088",
      attributes = {"nonProgressive"}
    },
    nikumaru = {
      name = "Nikumaru Counter",
      script = "<EVE0072",
      attributes = {"nonProgressive"}
    },
    teleportKey = {
      name = "Teleporter Room Key",
      script = "<EVE0075"
    },
    letter = {
      name = "Sue's Letter",
      script = "<EVE0076"
    },
    mask = {
      name = "Mimiga Mask",
      script = "<EVE0074"
    },
    brokenSprinkler = {
      name = "Broken Sprinkler",
      script = "<EVE0078"
    },
    newSprinkler = {
      name = "Sprinkler",
      script = "<EVE0079"
    },
    controller = {
      name = "Controller",
      script = "<EVE0077"
    },
    mushroomBadge = {
      name = "Mushroom Badge",
      script = "<EVE0083"
    },
    maPignon = {
      name = "Ma Pignon",
      script = "<EVE0084"
    },
    mrLittle = {
      name = "Little Man",
      script = "<EVE0082",
      attributes = {"event"},
      placed = true
    },
    ironBond = {
      name = "Iron Bond",
      script = "<EVE0089"
    },
    clayMedal = {
      name = "Clay Figure Medal",
      script = "<EVE0081",
      attributes = {"nonProgressive"}
    },

    -------------------
    -- LIFE CAPSULES --
    -------------------
    capsule3A = lifeCapsule3(), -- First Cave
    capsule3B = lifeCapsule3(), -- Yamashita Farm
    capsule3C = lifeCapsule3(), -- Egg Corridor (Basil)
    capsule4A = lifeCapsule4(), -- Egg Corridor (Cthulhu)
    capsule5A = lifeCapsule5(), -- Grasstown
    capsule5B = lifeCapsule5(), -- Execution Chamber
    capsule5C = lifeCapsule5(), -- Sand Zone (Upper)
    capsule5D = lifeCapsule5(), -- Sand Zone (Lower)
    capsule5E = lifeCapsule5(), -- Labyrinth
    capsule5F = lifeCapsule5(), -- Plantation (West)
    capsule4B = lifeCapsule4(), -- Plantation (Puppy)
    capsule5G = lifeCapsule5(), -- Sacred Grounds

    --------------
    -- MISSILES --
    --------------
    missileA = missiles(), -- Grasstown
    missileB = missiles(), -- Grasstown Hut
    missileC = missiles(), -- Egg Corridor?
    missileD = missiles(), -- Egg Observation Room?
    missileHell = {
      name = "Missile Expansion",
      script = "<EVE0035",
      attributes = {"missileLauncher", "nonProgressive"}
    },

    ------------
    -- EVENTS --
    ------------
    eventSue = event("Saved Sue"),
    eventFans = event("Activated Fans"),
    eventKazuma = event("Saved Kazuma"),
    eventOmega = event("Defeated Omega"),
    eventToroko = event("Defeated Toroko+"),
    eventCore = event("Defeated the Core"),
    eventCurly = event("Saved Curly"),
    eventRocket = event("Built Rocket")
  }

  local array = {}
  for k, t in pairs(data) do
    t.key = k
    t.placed = t.placed or false
    t.attributes = t.attributes or {}
    table.insert(t.attributes, k)
    table.insert(array, t)
  end

  return array
end

local C = Class:extend()

function C:new()
  self.itemData = _itemData()
end

function C:getByKey(key)
  return _.filter(self.itemData, function(k,v) return v.key == key end)[1]
end

function C:_getItems(filterFn)
  return _.filter(self.itemData, filterFn)
end

function C:getItems()
  return self:_getItems(function(k,v) return true end)
end

function C:getItemsByAttribute(attribute)
  return self:_getItems(function(k,v) return _.contains(v.attributes, attribute) end)
end

function C:getEvents()
  return self:getItemsByAttribute("event")
end

function C:getOptionalItems()
  return self:getItemsByAttribute("nonProgressive")
end

function C:getMandatoryItems()
  return self:_getItems(function(k,v)
    return not (_.contains(v.attributes, "event") or _.contains(v.attributes, "nonProgressive") or _.contains(v.attributes, "puppy"))
  end)
end

function C:getMandatory()
  return self:_getItems(function(k,v) return not _.contains(v.attributes, "nonProgressive") end)
end

function C:getUnplacedItems()
  return self:_getItems(function(k,v) return not v.placed end)
end

function C:unplacedString()
  local s = "\r\nUnplaced items:"
  for k,v in pairs(self:getUnplacedItems()) do s = s .. "\r\n" .. v.name end
  return s
end
  
return C
