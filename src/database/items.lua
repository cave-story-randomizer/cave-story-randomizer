local function lifeCapsule3()
  return {
    name = "Life Capsule",
    script = "<EVE0012",
    attributes = {"nonProgressive", "hp3", "helpful"},
    hints = {"a Life Capsule", "a little HP"}
  }
end
local function lifeCapsule4()
  return {
    name = "Life Capsule",
    script = "<EVE0013",
    attributes = {"nonProgressive", "hp4", "helpful"},
    hints = {"a Life Capsule", "some decent HP"}
  }
end
local function lifeCapsule5()
  return {
    name = "Life Capsule",
    script = "<EVE0014",
    attributes = {"nonProgressive", "hp5", "helpful"},
    hints = {"a Life Capsule", "a lot of HP"}
  }
end

local function missiles()
  return {
    name = "Missile Expansion",
    script = "<EVE0030",
    attributes = {"weapon", "missileLauncher", "nonProgressive", "helpful"},
  }
end

local function event(n)
  return {
    name = "Event: " .. n,
    attributes = {"event", "abstract"},
    placed = true
  }
end

local function objective(n, eve)
  return {
    name = n,
    attributes = {"objective", "abstract"},
    placed = true,
    script = eve
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
      attributes = {"weapon", "weaponBoss", "weaponSN", "polarStar", "mandatory"},
      hints = {"the gunsmith's pride"}
    },
    polarStar2 = {
      name = "Polar Star",
      script = "<EVE0002",
      attributes = {"weapon", "weaponBoss", "weaponSN", "polarStar", "mandatory"},
      hints = {"the gunsmith's pride"}
    },
    missileLauncher = {
      name = "Missile Launcher",
      script = "<EVE0030",
      attributes = {"weapon", "weaponSN", "nonProgressive", "helpful"},
    },
    superMissileLauncher = {
      name = "Super Missile Launcher",
      script = "<EVE0033",
      attributes = {"weapon", "weaponSN", "missileLauncher", "nonProgressive", "helpful"},
    },
    fireball = {
      name = "Fireball",
      script = "<EVE0004",
      attributes = {"weapon", "weaponBoss", "mandatory"},
      hints = {"the Fireball"}
    },
    snake = {
      name = "Snake",
      script = "<EVE0005",
      attributes = {"weapon", "weaponBoss", "nonProgressive", "weaponStrong", "helpful"},
      hints = {"the Snake"}
    },
    bubbler = {
      name = "Bubbler",
      script = "<EVE0007",
      attributes = {"weapon", "weaponBoss", "nonProgressive", "helpful"},
      hints = {"the Bubbler"}
    },
    machineGun = {
      name = "Machine Gun",
      script = "<EVE0008",
      attributes = {"weapon", "weaponBoss", "weaponSN", "flight", "mandatory", "weaponStrong"},
      hints = {"the Machine Gun"}
    },
    blade = {
      name = "Blade",
      script = "<EVE0009",
      attributes = {"weapon", "weaponBoss", "weaponSN", "mandatory", "weaponStrong"},
      hints = {"the Blade"}
    },
    nemesis = {
      name = "Nemesis",
      script = "<EVE0010",
      attributes = {"weapon", "weaponBoss", "weaponSN", "nonProgressive", "weaponStrong", "helpful"},
      hints = {"the Nemesis"}
    },

    ---------------
    -- INVENTORY --
    ---------------
    mapSystem = {
      name = "Map System",
      script = "<EVE0052",
      attributes = {"nonProgressive", "map"},
      hints = {"a map", "an electronic device"}
    },
    locket = {
      name = "Silver Locket",
      script = "<EVE0054",
      attributes = {"mandatory"},
      hints = {"some fishy jewelry", "a Mimiga's item"}
    },
    arthurKey = {
      name = "Arthur's Key",
      script = "<EVE0051",
      attributes = {"mandatory"},
      hints = {"Arthur's Key", "a key", "a Mimiga's item"}
    },
    idCard = {
      name = "ID Card",
      script = "<EVE0057",
      attributes = {"mandatory"},
      hints = {"the ID Card", "an electronic device"}
    },
    santaKey = {
      name = "Santa's Key",
      script = "<EVE0053",
      attributes = {"mandatory"},
      hints = {"Santa's Key", "a key", "a Mimiga's item"}
    },
    lipstick = {
      name = "Chaco's Lipstick",
      script = "<EVE0087",
      attributes = {"nonProgressive", "useless"},
      hints = {"some lipstick", "a Mimiga's item", "a lewd item"}
    },
    juice = {
      name = "Jellyfish Juice",
      script = "<EVE0058",
      attributes = {"mandatory"},
      hints = {"some juice", "a bomb ingredient"}
    },
    charcoal = {
      name = "Charcoal",
      script = "<EVE0062",
      attributes = {"mandatory"},
      hints = {"some charcoal", "a bomb ingredient"}
    },
    rustyKey = {
      name = "Rusty Key",
      script = "<EVE0059",
      attributes = {"mandatory"},
      hints = {"the Rusty Key", "a key"}
    },
    gumKey = {
      name = "Gum Key",
      script = "<EVE0060",
      attributes = {"mandatory"},
      hints = {"the Gum Key", "a key"}
    },
    gumBase = {
      name = "Gum Base",
      script = "<EVE0061",
      attributes = {"mandatory"},
      hints = {"some gum", "a bomb ingredient"}
    },
    bomb = {
      name = "Bomb",
      script = "<EVE0063",
      attributes = {"mandatory"},
      hints = {"a bomb"}
    },
    panties = {
      name = "Curly's Panties",
      script = "<EVE0085",
      attributes = {"nonProgressive", "useless"},
      hints = {"a pair of panties", "a lewd item"}
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
      attributes = {"nonProgressive", "helpful"},
      hints = {"a Life Pot", "some medicine"}
    },
    turbocharge = {
      name = "Turbocharge",
      script = "<EVE0070",
      attributes = {"nonProgressive", "helpful"},
      hints = {"the Turbocharge"}
    },
    clinicKey = {
      name = "Clinic Key",
      script = "<EVE0067",
      attributes = {"mandatory"},
      hints = {"the Clinic Key", "a key"}
    },
    armsBarrier = {
      name = "Arms Barrier",
      script = "<EVE0069",
      attributes = {"nonProgressive", "helpful"},
      hints = {"the Arms Barrier"}
    },
    cureAll = {
      name = "Cure-All",
      script = "<EVE0066",
      attributes = {"mandatory"},
      hints = {"the Cure-All", "some medicine"}
    },
    booster1 = {
      name = "Booster",
      script = "<EVE0068",
      attributes = {"flight", "booster", "mandatory"},
      hints = {"a Booster", "a rocket component"}
    },
    booster2 = {
      name = "Booster",
      script = "<EVE0068",
      attributes = {"flight", "booster", "mandatory"},
      hints = {"a Booster", "a rocket component"}
    },
    towRope = {
      name = "Tow Rope",
      script = "<EVE0080",
      attributes = {"mandatory"},
      hints = {"the Tow Rope"}
    },
    airTank = {
      name = "Curly's Air Tank",
      script = "<EVE0071",
      attributes = {"mandatory"},
      hints = {"an air tank"}
    },
    alienMedal = {
      name = "Alien Medal",
      script = "<EVE0086",
      attributes = {"nonProgressive", "useless"},
      hints = {"the Alien Medal", "a badge of victory"}
    },
    whimsicalStar = {
      name = "Whimsical Star",
      script = "<EVE0088",
      attributes = {"nonProgressive", "helpful"},
      hints = {"the Whimsical Star"}
    },
    nikumaru = {
      name = "Nikumaru Counter",
      script = "<EVE0072",
      attributes = {"nonProgressive"},
      hints = {"the Nikumaru Counter"}
    },
    teleportKey = {
      name = "Teleporter Room Key",
      script = "<EVE0075",
      attributes = {"mandatory"},
      hints = {"the Teleporter Room Key", "a key"}
    },
    letter = {
      name = "Sue's Letter",
      script = "<EVE0076",
      attributes = {"mandatory"},
      hints = {"Sue's Letter", "a Mimiga's item"}
    },
    mask = {
      name = "Mimiga Mask",
      script = "<EVE0074",
      attributes = {"mandatory"},
      hints = {"the Mimiga Mask"}
    },
    brokenSprinkler = {
      name = "Broken Sprinkler",
      script = "<EVE0078",
      attributes = {"mandatory"},
      hints = {"the Broken Sprinkler", "a sprinkler"}
    },
    newSprinkler = {
      name = "Sprinkler",
      script = "<EVE0079",
      attributes = {"mandatory"},
      hints = {"the Sprinkler", "a sprinkler", "a rocket component"}
    },
    controller = {
      name = "Controller",
      script = "<EVE0077",
      attributes = {"mandatory"},
      hints = {"the Controller", "a rocket component", "an electronic device"}
    },
    mushroomBadge = {
      name = "Mushroom Badge",
      script = "<EVE0083",
      attributes = {"mandatory"},
      hints = {"the Mushroom Badge", "a badge of victory"}
    },
    maPignon = {
      name = "Ma Pignon",
      script = "<EVE0084",
      attributes = {"mandatory"},
      hints = {"Ma Pignon", "a living being"}
    },
    mrLittle = {
      name = "Little Man",
      script = "<EVE0082",
      attributes = {"mandatory"},
      hints = {"Mr Little", "a living being"}
      --placed = true
    },
    ironBond = {
      name = "Iron Bond",
      script = "<EVE0089",
      attributes = {"mandatory"},
      hints = {"the Iron Bond"}
    },
    clayMedal = {
      name = "Clay Figure Medal",
      script = "<EVE0081",
      attributes = {"nonProgressive", "useless"},
      hints = {"the Clay Figure Medal", "a badge of victory"}
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
    missileD = {           -- Egg Observation Room? (arbitrarily making this a backup Super Missile chest)
      name = "Missile Expansion (Super Missile alt)",
      script = "<EVE0038",
      attributes = {"weapon", "missileLauncher", "nonProgressive", "helpful"}
    }, 
    missileHell = {
      name = "Missile Expansion",
      script = "<EVE0035",
      attributes = {"weapon", "missileLauncher", "nonProgressive", "helpful"}
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
    eventRocket = event("Built Rocket"),

    ----------------
    -- GAME MODES --
    ----------------
    objBadEnd = objective("Bad Ending", "<FL+6003"),
    objNormalEnd = objective("Normal Ending", "<FL+6000"),
    objBestEnd = objective("Best Ending", "<FL+6001"),
    objAllBosses = objective("All Bosses", "<FL+6002<IT+0005"),
    obj100Percent = objective("100%", "<FL+6004<IT+0005")
  }

  local function initializeHints(item)
    local hintArray = {
      --mandatory = {"a required item"},
      puppy = {"a puppy", "a living being"},
      --helpful = {"a helpful item"},
      --useless = {"a useless item"},
      weapon = {"a weapon"},
      --weaponSN = {"a weapon that breaks blocks"},
      --weaponStrong = {"a strong weapon"},
      flight = {"a method of flight", "flight"},
      missileLauncher = {"a Missile upgrade"}
    }
  
    item.hints = item.hints or {} -- initialize item's hints array if not already
  
    -- loop through item's attributes and add any matching hints from the hintArray table
    for k,v in ipairs(item.attributes) do
      for k2,v2 in ipairs(hintArray[v] or {}) do
        table.insert(item.hints, v2)
      end
    end
  end

  local array = {}
  for k, t in pairs(data) do
    t.key = k
    t.placed = t.placed or false
    t.attributes = t.attributes or {}
    table.insert(t.attributes, k)
    table.insert(array, t)

    initializeHints(t)
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

function C:getItemsByAttribute(attribute, onlyUnplaced)
  onlyUnplaced = onlyUnplaced or false
  return self:_getItems(function(k,v) return _.contains(v.attributes, attribute) and not (onlyUnplaced and v.placed) end)
end

function C:getEvents()
  return self:getItemsByAttribute("event")
end

function C:getOptionalItems(onlyUnplaced)
  return self:getItemsByAttribute("nonProgressive", onlyUnplaced)
end

function C:getMandatoryItems(onlyUnplaced)
  return self:getItemsByAttribute("mandatory", onlyUnplaced)
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

local function _hint(message, l, ending)
  ending = ending or "<END"
  local MSGBOXLIMIT = 35
  local PATTERN = " [^ ]*$"
  local line1, line2, line3 = "", "", ""

  local split = 1
  line1 = message:sub(split, split+MSGBOXLIMIT)

  if line1:find(PATTERN) and #message > MSGBOXLIMIT then
    line1 = line1:sub(1, line1:find(PATTERN))
    split = line1:find(PATTERN)+split
    if split ~= MSGBOXLIMIT then line2 = "\r\n" end
    line2 = line2 .. message:sub(split, split+MSGBOXLIMIT)

    if line2:find(PATTERN) and #message > MSGBOXLIMIT*2 then
      line2 = line2:sub(1, line2:find(PATTERN))
      split = line2:find(PATTERN)+split-2
      if split ~= MSGBOXLIMIT then line3 = "\r\n" end
      line3 = line3 .. message:sub(split, split+MSGBOXLIMIT)
    end
  end

  local s = "<PRI<MSG<TUR" .. line1 .. line2 .. line3 .. "<NOD" .. ending

  return {
    name = ("%q [%s] [%s]"):format(message, l.item.name, l.name),
    atrributes = {"hint", "abstract"},
    placed = true,
    script = s
  }
end

function C:createHint(l, ending)
  local function pick(t) return t[love.math.random(#t)] end

  local location, item = l:getHint()
  local starts = {"I hear that ", "Rumour has it, ", "They say "}
  local mids = {" can be found ", " is ", " is hidden "}
  local message = (pick(starts) or "") .. (pick(item) or "") .. (pick(mids) or "") .. (pick(location) or "") .. "."

  return _hint(message, l, ending)
end

function C:prebuiltHint(l, ending)
  return _hint(l:getPrebuiltHint(), l, ending)
end
  
return C
