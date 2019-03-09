function weapon(t)
  assert(t.name and t.map and t.id)
  local ammo = t.ammo or "0000"
  local names = t.name
  if type(names) == 'string' then
    names = {names}
  end
  local getText = {}
  for _, name in ipairs(names) do
    table.insert(getText, ("Got the =%s=!<WAI0160<NOD"):format(name))
    table.insert(getText, ("Got the =%s=.<WAI0160<NOD"):format(name)) -- Blade
    table.insert(getText, ("=%s= complete!<WAI0160<NOD"):format(name)) -- Snake
    table.insert(getText, ("=Polar Star= became the =%s=!"):format(name)) -- Spur
    -- Cave Story+
    table.insert(getText, ("Obtained the %s!<WAI0160<NOD"):format(name))
    table.insert(getText, ("Obtained the %s.<WAI0160<NOD"):format(name))
    table.insert(getText, ("%s is completed!<WAI0160<NOD"):format(name)) -- Snake
    table.insert(getText, ("The Polar Star is now the %s!"):format(name)) -- Spur
  end
  return {
    name = names[1],
    map = t.map,
    getText = getText,
    command = ("<AM+00%s:%s"):format(t.id, ammo),
    displayCmd = ("<GIT00%s"):format(t.id),
    music = "<CMU0010",
    kind = "weapon",
    replaceBefore = t.replaceBefore,
    label = t.label,
  }
end

function equipment(t)
  assert(t.name and t.map and t.id and t.equipMask)
  return {
    name = t.name,
    map = t.map,
    getText = {
      ("Got the =%s=!<WAI0160<NOD"):format(t.name),
      ("Got the =%s=!<WAI0160"):format(t.name), -- Whimsical Star
      -- Cave Story+
      ("Obtained the %s.<WAI0160<NOD"):format(t.name),
      ("Obtained the %s.<WAI0160"):format(t.name), -- Whimsical Star
    },
    command = {
      ("<IT+00%s<EQ+%s"):format(t.id, t.equipMask), -- Replacement
      ("<IT+00%s"):format(t.id, t.equipMask), -- Needle
    },
    displayCmd = ("<GIT10%s"):format(t.id),
    music = "<CMU0010",
    replaceBefore = {
      -- Just erase <EQ+, since it's not always placed right after <IT+
      -- We will add it again with command.
      [("<EQ+%s"):format(t.equipMask)] = "",
    },
    label = t.label,
  }
end

function item(t)
  assert(t.name and t.map and t.id)
  local names = t.name
  if type(names) == 'string' then
    names = {names}
  end
  local getText = {}
  for _, name in ipairs(names) do
    table.insert(getText, ("Got =%s=!<WAI0160<NOD"):format(name)) -- Replacement
    table.insert(getText, ("Got a =%s=!<WAI0160<NOD"):format(name)) -- Life Pot
    table.insert(getText, ("Found =%s=.<NOD"):format(name)) -- Curly's Panties
    table.insert(getText, ("Got the =%s=.<WAI0160<NOD"):format(name)) -- Clay Figure Medal
    table.insert(getText, ".....") -- Chako's Rouge
    -- Cave Story+
    table.insert(getText, ("Found %s.<NOD"):format(name)) -- Curly's Panties
    table.insert(getText, ("Obtained a %s.<WAI0160<NOD"):format(name)) -- Life Po
    table.insert(getText, ("Obtained the %s.<WAI0160<NOD"):format(name)) -- Clay Figure Medal
  end
  return {
    name = names[1],
    map = t.map,
    getText = getText,
    command = ("<IT+00%s"):format(t.id),
    displayCmd = ("<GIT10%s"):format(t.id),
    music = t.music or "<CMU0010",
    replaceBefore = t.replaceBefore,
    label = t.label,
  }
end

function lifeCapsule(t)
  assert(t.hp and t.map)
  return {
    name = ("Life Capsule (+%d)"):format(t.hp),
    map = t.map,
    getText = {
      -- Replacement string. Does not literally appear in game.
      ("Got a =Life Capsule=!<WAI0160<NOD\n\r Max health increased by %d!"):format(t.hp),
      "Got a =Life Capsule=!<WAI0160<NOD", -- erase the extra wait for most things.
      "Got a =Life Capsule=!<NOD", -- Hell1 capsule does not have waiting period for some reason.
      -- Cave Story+
      ("Obtained a Life Capsule.<WAI0160<NOD\n\r Max health increased by %d!"):format(t.hp),
      "Obtained a Life Capsule.<WAI0160<NOD", -- erase the extra wait for most things.
      "Obtained a Life Capsule.<NOD", -- Hell1 capsule does not have waiting period for some reason.
    },
    command = ("<ML+000%d"):format(t.hp),
    displayCmd = "<GIT1006",
    music = t.music or "<CMU0016",
    replaceBefore = {
      [("Max health increased by %d!<NOD"):format(t.hp)] = "",
      [("Max life increased by %d.<NOD"):format(t.hp)] = "", -- Cave Story+
    },
    label = t.label,
  }
end

function missiles(t)
  assert(t.map)
  return {
    name = "Missiles",
    map = t.map,
    getText = {
      "", -- Doesn't have getText in untouched map script.
      "*MISSILE_TEXT*",
    },
    command = "<EVE0030",
    displayCmd = {
      "", -- Doesn't use GIT in untouched map script.
      "<GIT0006",
    },
    music = {
      "", -- Doesn't use Music in untouched map script.
      "<CMU0010",
    },
    replaceBefore = {
      ["<EVE0030"] = "<CMU0010<GIT0006*MISSILE_TEXT*<RMU<EVE0030<END",
    },
    kind = "missiles",
    label = t.label,
  }
end

local data = {
  -------------
  -- WEAPONS --
  -------------
  wPolarStar = weapon({
    name = "Polar Star",
    map = "Pole",
    label = "0200",
    id = "02",
  }),
  wFireball = weapon({
    name = "Fireball",
    map = "Santa",
    label = "0500",
    id = "03",
  }),
  wBubbline = weapon({
    name = {
      "Bubbline",
      "Bubbler",
    },
    map = "Comu",
    label = "0301",
    id = "07",
    ammo = "0100",
  }),
  wMachineGun = weapon({
    name = "Machine Gun",
    map = "Curly",
    label = "0415",
    id = "04",
    ammo = "0100",
    replaceBefore = {
      ["<TAM0002:"] = "<AM-0002<AM+",
    },
  }),
  wBlade = weapon({
    name = "Blade",
    map = "Gard",
    label = "0601",
    id = "09",
  }),
  wSnake = weapon({
    name = "Snake",
    map = "MazeA",
    label = "0401",
    id = "01",
    replaceBefore = {
      ["<TAM0002:"] = "<AM-0002<AM+",
    },
  }),
  wSpur = weapon({
    name = "Spur",
    map = "Pole",
    label = "0302",
    id = "13",
    replaceBefore = {
      ["<TAM0002:"] = "<AM-0002<AM+",
    },
  }),
  wNemesis = weapon({
    name = "Nemesis",
    map = "Little",
    label = "0200",
    id = "12",
    replaceBefore = {
      ["<TAM0009:"] = "<AM-0009<AM+",
    },
  }),

  ---------------
  -- EQUIPMENT --
  ---------------
  eMapSystem = equipment({
    name = "Map System",
    map = "Mimi",
    label = "0200",
    id = "02",
    equipMask = "0002",
  }),
  eTurbocharge = equipment({
    name = "Turbocharge",
    map = "MazeA",
    label = "0402",
    id = "20",
    equipMask = "0008",
  }),
  eWhimsicalStar = equipment({
    name = "Whimsical Star",
    map = "MazeA",
    label = "0404",
    id = "38",
    equipMask = "0128",
  }),
  eArmsBarrier = equipment({
    name = "Arms Barrier",
    map = "MazeO",
    label = "0400",
    id = "19",
    equipMask = "0004",
  }),

  -----------
  -- ITEMS --
  -----------
  iChakosRouge = item({
    name = {
      "Chaco's Lipstick",
      "Chako's Rouge", -- Probably doesn't matter, since no text?
    },
    map = "Chako",
    label = "0211",
    id = "37",
    music = "",
    replaceBefore = {
      -- Display Item.
      [".....<IT+0037<NOD"] = "<GIT1037.....<IT+0037",
    },
  }),
  iPanties = item({
    name = {
      "Curly's Panties",
      "Curly's Underwear",
    },
    map = "CurlyS",
    label = "0420",
    id = "35",
    music = "",
  }),
  iLifePot = item({
    name = "Life Pot",
    map = "Cent",
    label = "0450",
    id = "15",
    replaceBefore = {
      -- Delete check for Life Pot so that 2nd item is always given.
      ["<ITJ0015:0451"] = "",
    },

  }),
  iAlienMedal = item({
    name = "Alien Medal",
    map = "Stream",
    id = "36",
    label = "1011",
    replaceBefore = {
      ["<IT+0036"] = "<CMU0010<GIT1036Got =Alien Medal=!<WAI0160<NOD<RMU<IT+0036",
    }
  }),
  iClayFigureMedal = item({
    name = {
      "Clay Figure Medal",
      "Medal of the Red Ogre",
    },
    map = "Priso2",
    label = "0251",
    id = "31",
    replaceBefore = {
      -- Remove achievement trigger which appears in Cave Story+.
      ["<ACH0041"] = "",
    }
  }),



  -------------------
  -- LIFE CAPSULES --
  -------------------
  lFirstCave = lifeCapsule({
    hp = 3,
    map = "Cave",
    label = "0400"
  }),
  lYamashitaFarm = lifeCapsule({
    hp = 3,
    map = "Plant",
    label = "0400"
  }),
  lEggCorridorA = lifeCapsule({
    hp = 3,
    map = "Eggs",
    label = "0400"
  }),
  lEggCorridorB = lifeCapsule({
    hp = 4,
    map = "Eggs",
    label = "0401"
  }),
  lGrasstown = lifeCapsule({
    hp = 5,
    map = "Weed",
    label = "0305"
  }),
  lGrasstownExecution = lifeCapsule({
    hp = 5,
    map = "WeedD",
    label = "0304"
  }),
  lSandZoneA = lifeCapsule({
    hp = 5,
    map = "Sand",
    label = "0500"
  }),
  lSandZoneB = lifeCapsule({
    hp = 5,
    map = "Sand",
    label = "0501"
  }),
  lLabyrinth = lifeCapsule({
    hp = 5,
    map = "MazeI",
    label = "0300"
  }),
  lPlantationA = lifeCapsule({
    hp = 5,
    map = "Cent",
    label = "0450"
  }),
  lPlantationB = lifeCapsule({
    hp = 4,
    map = "Cent",
    label = "0500"
  }),
  lHell = lifeCapsule({
    hp = 5,
    map = "Hell1",
    music = "",
    label = "0400"
  }),

  --------------
  -- MISSILES --
  --------------
  mEggObservation = missiles({
    map = "EggR",
    label = "0300",
  }),
  mGrasslands = missiles({
    map = "Weed",
    label = "0302",
  }),
  mGrasslandsHut = missiles({
    map = "WeedB",
    label = "0300",
  }),
  mEggCorridorRuined = missiles({
    map = "Eggs2",
    label = "0320",
  }),
  mEggObservationRuined = missiles({
    map = "EggR2",
    label = "0302",
  }),
  mSuperMissileLauncher = {
    name = "Super Missile Launcher",
    map = "MazeS",
    label = {"0200", "0201"},
    getText = {
      "Got the =Super Missile Launcher=!<WAI0160<NOD", -- Gameplay text
      "Your Missiles have been powered up!<WAI0160<NOD", -- Actual text
      -- Cave Story+
      "Missiles are powered up!<WAI0160<NOD", -- Actual text
    },
    -- <AM+0005:0005 - Give the missile launcher and 5 ammo, just in case we don't have it yet.
    --                 We need to give ammo because the missiles fire infinitely when max ammo is 0.
    -- <FL+0202      - Sets the flag which tells the regular Missiles script that we have the Super Missiles.
    command = "<AM+0005:0005<TAM0005:0010:0000<FL+0202",
    displayCmd = "<GIT0010",
    music = "<CMU0010",
    replaceBefore = {
      ["<FL+0202"] = "", -- Flag will be set as part of command instead.
      ["<FLJ0201:0201"] = "<EVE0201", -- Skip check which ensures you already have the missiles.
      ["<TAM0005:0010:0000"] = "<AM+0005:0005<TAM0005:0010:0000<FL+0202",
    },
  }
  -- !!!! Uses a unique script... will have to be crafty... !!!!
  -- [Sanctuary] Bonus expansion.  Just before you fight the Heavy Press at the
  -- far west end of Blood-Stained Sanctuary B3, just past the pillar with 3 Deletes
  -- covering it, in the room filled with flying Butes and with a hanging platform
  -- with an arrow Bute on either side.  Above this platform is a single Star Block
  -- concealing a chest containing this massive expansion of 24 Missiles.
}

function an_item(t) 
  return t
end

function arms(t)
  return an_item(t)
end

function inventory(t)
  return an_item(t)
end

function life_capsule(health)
  return an_item({
    name = "Life Capsule",
    script = ("<MSG<TUR<GIT1006Got a =Life Capsule=!<ML+%04d\n\rMax health increased by %s!<WAI0025<NOD<END"):format(health, health)
  })
end

function missile_expansion()
  return an_item({
    name = "Missile Expansion",
    script = "<EVE0030"
  })
end

local data2 = {
  -------------
  -- WEAPONS --
  -------------
  polarStar = arms({
    name = "Polar Star",
    script = "<SOU0022<MSG<TUR<GIT0002<AM+0002:0000\n\rGot the =Polar Star=!<WAI0025<NOD<END",
    attributes = {"weaponBoss", "weaponSN"}
  }),
  spur = arms({
    name = "Spur",
    script = "",
    attributes = {"weaponBoss", "weaponSN", "polarStar"}
  }),
  missileLauncher = arms({
    name = "Missile Launcher",
    script = "<EVE0030",
    attributes = {"weaponSN"} -- i ain't gonna force someone to kill the core with only missiles or something
  }),
  superMissileLauncher = arms({
    name = "Super Missile Launcher",
    script = "",
    attributes = {"weaponSN", "missileLauncher"}
  }),
  fireball = arms({
    name = "Fireball",
    script = "",
    attributes = {"weaponBoss"}
  }),
  snake = arms({
    name = "Snake",
    script = "",
    attributes = {"weaponBoss", "fireball"} -- fireball -> snake is progressive much like polar star -> spur
  }),
  bubbler = arms({
    name = "Bubbler",
    script = "",
    attributes = {"weaponBoss", "weaponSN"} -- have fun grinding to lv3 to get out of the first cave :)
  }),
  machineGun = arms({
    name = "Machine Gun",
    script = "",
    attributes = {"weaponBoss", "flight"}
  }),
  blade = arms({
    name = "Blade",
    script = "",
    attributes = {"weaponBoss", "weaponSN"}
  }),
  nemesis = arms({
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
    script = ""
  },
  puppy2 = {
    name = "Kakeru",
    script = ""
  },
  puppy3 = {
    name = "Mick",
    script = ""
  },
  puppy4 = {
    name = "Nene",
    script = ""
  },
  puppy5 = {
    name = "Shinobu",
    script = ""
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
  capsule3A = life_capsule(3), -- First Cave
  capsule3B = life_capsule(3), -- Yamashita Farm
  capsule3C = life_capsule(3), -- Egg Corridor (Basil)
  capsule4A = life_capsule(4), -- Egg Corridor (Cthulhu)
  capsule5A = life_capsule(5), -- Grasstown
  capsule5B = life_capsule(5), -- Execution Chamber
  capsule5C = life_capsule(5), -- Sand Zone (Upper)
  capsule5D = life_capsule(5), -- Sand Zone (Lower)
  capsule5E = life_capsule(5), -- Labyrinth
  capsule5F = life_capsule(5), -- Plantation (West)
  capsule4B = life_capsule(4), -- Plantation (Puppy)
  capsule5G = life_capsule(5), -- Sacred Grounds

  --------------
  -- MISSILES --
  --------------

}

for k, t in pairs(data) do
  t.key = k
end

return data
