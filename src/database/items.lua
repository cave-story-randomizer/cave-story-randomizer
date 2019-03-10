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
    script = "<SOU0022<MSG<TUR<GIT0002<AM+0002:0000\n\rGot the =Polar Star=!<WAI0025<NOD<END",
    attributes = {"weaponBoss", "weaponSN"}
  }),
  spur = weapon({
    name = "Spur",
    script = "",
    attributes = {"weaponBoss", "weaponSN", "polarStar"}
  }),
  missileLauncher = missiles(),
  superMissileLauncher = weapon({
    name = "Super Missile Launcher",
    script = "",
    attributes = {"weaponSN", "missileLauncher"}
  }),
  fireball = weapon({
    name = "Fireball",
    script = "",
    attributes = {"weaponBoss"}
  }),
  snake = weapon({
    name = "Snake",
    script = "",
    attributes = {"weaponBoss", "fireball"} -- fireball -> snake is progressive much like polar star -> spur
  }),
  bubbler = weapon({
    name = "Bubbler",
    script = "",
    attributes = {"weaponBoss", "weaponSN"} -- have fun grinding to lv3 to get out of the first cave :)
  }),
  machineGun = weapon({
    name = "Machine Gun",
    script = "",
    attributes = {"weaponBoss", "flight"}
  }),
  blade = weapon({
    name = "Blade",
    script = "",
    attributes = {"weaponBoss", "weaponSN"}
  }),
  nemesis = weapon({
    name = "Nemesis",
    script = "",
    attributes = {"weaponBoss", "weaponSN"}
  }),

  ---------------
  -- INVENTORY --
  ---------------
  mapSystem = {
    name = "Map System",
    script = ""
  },
  locket = {
    name = "Silver Locket",
    script = ""
  },
  arthurKey = {
    name = "Arthur's Key",
    script = ""
  },
  idCard = {
    name = "ID Card",
    script = ""
  },
  santaKey = {
    name = "Santa's Key",
    script = ""
  },
  lipstick = {
    name = "Chaco's Lipstick",
    script = ""
  },
  juice = {
    name = "Jellyfish Juice",
    script = ""
  },
  charcoal = {
    name = "Charcoal",
    script = ""
  },
  rustyKey = {
    name = "Rusty Key",
    script = ""
  },
  gumKey = {
    name = "Gum Key",
    script = ""
  },
  gumBase = {
    name = "Gum Base",
    script = ""
  },
  bomb = {
    name = "Bomb",
    script = ""
  },
  panties = {
    name = "Curly's Panties",
    script = ""
  },
  puppy1 = {
    name = "Hajime",
    script = "",
    attributes = {"puppy"}
  },
  puppy2 = {
    name = "Kakeru",
    script = "",
    attributes = {"puppy"}
  },
  puppy3 = {
    name = "Mick",
    script = "",
    attributes = {"puppy"}
  },
  puppy4 = {
    name = "Nene",
    script = "",
    attributes = {"puppy"}
  },
  puppy5 = {
    name = "Shinobu",
    script = "",
    attributes = {"puppy"}
  },
  lifepot = {
    name = "Life Pot",
    script = ""
  },
  turbocharge = {
    name = "Turbocharge",
    script = ""
  },
  clinicKey = {
    name = "Clinic Key",
    script = ""
  },
  armsBarrier = {
    name = "Arms Barrier",
    script = ""
  },
  cureAll = {
    name = "Cure-All",
    script = ""
  },
  booster1 = {
    name = "Booster 0.8",
    script = "",
    attributes = {"flight"}
  },
  booster2 = {
    name = "Booster 2.0",
    script = "",
    attributes = {"flight", "booster1"}
  },
  towRope = {
    name = "Tow Rope",
    script = ""
  },
  airTank = {
    name = "Curly's Air Tank",
    script = ""
  },
  alienMedal = {
    name = "Alien Medal",
    script = ""
  },
  whimsicalStar = {
    name = "Whimsical Star",
    script = ""
  },
  nikumaru = {
    name = "Nikumaru Counter",
    script = ""
  },
  teleportKey = {
    name = "Teleporter Room Key",
    script = ""
  },
  letter = {
    name = "Sue's Letter",
    script = ""
  },
  mask = {
    name = "Mimiga Mask",
    script = ""
  },
  brokenSprinkler = {
    name = "Broken Sprinkler",
    script = ""
  },
  newSprinkler = {
    name = "Sprinkler",
    script = ""
  },
  controller = {
    name = "Controller",
    script = ""
  },
  mushroomBadge = {
    name = "Mushroom Badge",
    script = ""
  },
  maPignon = {
    name = "Ma Pignon",
    script = ""
  },
  little = {
    name = "Little Man",
    script = ""
  },
  ironBond = {
    name = "Iron Bond",
    script = ""
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
    script = "",
    attributes = {"weaponSN", "missileLauncher"}
  })
}

for k, t in pairs(data) do
  t.key = k
end

return data
