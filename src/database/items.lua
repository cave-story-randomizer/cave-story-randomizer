function item(t) 
  return t
end

function weapon(t)
  return item(t)
end

function inventory(t)
  return item(t)
end

function lifeCapsule(health)
  return item({
    name = "Life Capsule",
    script = ("<MSG<TUR<GIT1006Got a =Life Capsule=!<ML+%04d\n\rMax health increased by %s!<WAI0025<NOD<END"):format(health, health)
  })
end

function missiles()
  return weapon({
    name = "Missile Expansion",
    script = "<EVE0030",
    attributes = {"weaponSN", "missileLauncher"}
  })
end

local data = {
  -------------
  -- WEAPONS --
  -------------
  polarStar = weapon({
    name = "Polar Star",
    script = "<EVE0002",
    attributes = {"weaponBoss", "weaponSN"}
  }),
  spur = weapon({
    name = "Spur",
    script = "<EVE0002",
    attributes = {"weaponBoss", "weaponSN", "polarStar"}
  }),
  missileLauncher = missiles(),
  superMissileLauncher = weapon({
    name = "Super Missile Launcher",
    script = "<EVE0033",
    attributes = {"weaponSN", "missileLauncher"}
  }),
  fireball = weapon({
    name = "Fireball",
    script = "<EVE0004",
    attributes = {"weaponBoss"}
  }),
  snake = weapon({
    name = "Snake",
    script = "<EVE0005",
    attributes = {"weaponBoss"}
  }),
  bubbler = weapon({
    name = "Bubbler",
    script = "<EVE0007",
    attributes = {"weaponBoss", "weaponSN"} -- have fun grinding to lv3 to get out of the first cave :)
  }),
  machineGun = weapon({
    name = "Machine Gun",
    script = "<EVE0008",
    attributes = {"weaponBoss", "flight"}
  }),
  blade = weapon({
    name = "Blade",
    script = "<EVE0009",
    attributes = {"weaponBoss", "weaponSN"}
  }),
  nemesis = weapon({
    name = "Nemesis",
    script = "<EVE0010",
    attributes = {"weaponBoss", "weaponSN"}
  }),

  ---------------
  -- INVENTORY --
  ---------------
  mapSystem = {
    name = "Map System",
    script = "<EVE0052"
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
    script = "<EVE0087"
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
    script = "<EVE0085"
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
    script = "<EVE0065"
  },
  turbocharge = {
    name = "Turbocharge",
    script = "<EVE0070"
  },
  clinicKey = {
    name = "Clinic Key",
    script = "<EVE0067"
  },
  armsBarrier = {
    name = "Arms Barrier",
    script = "<EVE0069"
  },
  cureAll = {
    name = "Cure-All",
    script = "<EVE0066"
  },
  booster1 = {
    name = "Booster 0.8",
    script = "<EVE0068",
    attributes = {"flight"}
  },
  booster2 = {
    name = "Booster 2.0",
    script = "<EVE0073",
    attributes = {"flight", "booster1"}
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
    script = "<EVE0086"
  },
  whimsicalStar = {
    name = "Whimsical Star",
    script = "<EVE0088"
  },
  nikumaru = {
    name = "Nikumaru Counter",
    script = "<EVE0072"
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
  little = {
    name = "Little Man",
    script = "<EVE0082"
  },
  ironBond = {
    name = "Iron Bond",
    script = "<EVE0089"
  },

  -------------------
  -- LIFE CAPSULES --
  -------------------
  capsule3A = lifeCapsule(3), -- First Cave
  capsule3B = lifeCapsule(3), -- Yamashita Farm
  capsule3C = lifeCapsule(3), -- Egg Corridor (Basil)
  capsule4A = lifeCapsule(4), -- Egg Corridor (Cthulhu)
  capsule5A = lifeCapsule(5), -- Grasstown
  capsule5B = lifeCapsule(5), -- Execution Chamber
  capsule5C = lifeCapsule(5), -- Sand Zone (Upper)
  capsule5D = lifeCapsule(5), -- Sand Zone (Lower)
  capsule5E = lifeCapsule(5), -- Labyrinth
  capsule5F = lifeCapsule(5), -- Plantation (West)
  capsule4B = lifeCapsule(4), -- Plantation (Puppy)
  capsule5G = lifeCapsule(5), -- Sacred Grounds

  --------------
  -- MISSILES --
  --------------
  missileA = missiles(), -- Grasstown
  missileB = missiles(), -- Grasstown Hut
  missileC = missiles(), -- Egg Corridor?
  missileD = missiles(), -- Egg Observation Room?
  missileHell = weapon({
    name = "Missile Expansion",
    script = "<EVE0035",
    attributes = {"weaponSN", "missileLauncher"}
  })
}

for k, t in pairs(data) do
  t.key = k
end

return data
