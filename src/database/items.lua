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
    -- Just erase <EQ+, since it's not always placed right after <IT+
    -- We will add it again with command.
    erase = ("<EQ+%s"):format(t.equipMask),
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
    erase = {
      ("Max health increased by %d!<NOD"):format(t.hp),
      ("Max life increased by %d.<NOD"):format(t.hp), -- Cave Story+
    },
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
  }
end

local data = {
  -------------
  -- WEAPONS --
  -------------
  wPolarStar = weapon({
    name = "Polar Star",
    map = "Pole",
    id = "02",
  }),
  wFireball = weapon({
    name = "Fireball",
    map = "Santa",
    id = "03",
  }),
  wBubbline = weapon({
    name = {
      "Bubbline",
      "Bubbler",
    },
    map = "Comu",
    id = "07",
    ammo = "0100",
  }),
  wMachineGun = weapon({
    name = "Machine Gun",
    map = "Curly",
    id = "04",
    ammo = "0100",
    replaceBefore = {
      ["<TAM0002:"] = "<AM-0002<AM+",
    },
    label = "0415",
  }),
  wBlade = weapon({
    name = "Blade",
    map = "Gard",
    id = "09",
    label = "0601",
  }),
  wSnake = weapon({
    name = "Snake",
    map = "MazeA",
    id = "01",
    replaceBefore = {
      ["<TAM0002:"] = "<AM-0002<AM+",
    },
    label = "0401",
  }),
  wSpur = weapon({
    name = "Spur",
    map = "Pole",
    id = "13",
    replaceBefore = {
      ["<TAM0002:"] = "<AM-0002<AM+",
    },
    label = "0302",
  }),
  wNemesis = weapon({
    name = "Nemesis",
    map = "Little",
    id = "12",
    replaceBefore = {
      ["<TAM0009:"] = "<AM-0009<AM+",
    },
    label = "0200",
  }),

  ---------------
  -- EQUIPMENT --
  ---------------
  eMapSystem = equipment({
    name = "Map System",
    map = "Mimi",
    id = "02",
    equipMask = "0002",
    label = "0200",
  }),
  eTurbocharge = equipment({
    name = "Turbocharge",
    map = "MazeA",
    id = "20",
    equipMask = "0008",
    label = "0402",
  }),
  eWhimsicalStar = equipment({
    name = "Whimsical Star",
    map = "MazeA",
    id = "38",
    equipMask = "0128",
    label = "0404",
  }),
  eArmsBarrier = equipment({
    name = "Arms Barrier",
    map = "MazeO",
    id = "19",
    equipMask = "0004",
    label = "0400",
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
    id = "37",
    music = "",
    label = "0211",
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
    id = "35",
    music = "",
  }),
  iLifePot = item({
    name = "a Life Pot",
    map = "Cent",
    id = "15",
    label = "0450",
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
    id = "31",
    label = "0251",
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
    label = "????"
  }),
  lYamashitaFarm = lifeCapsule({
    hp = 3,
    map = "Plant",
    label = "????"
  }),
  lEggCorridorA = lifeCapsule({
    hp = 3,
    map = "Eggs",
    label = "????"
  }),
  -- !!!! Can't randomize this one until I do some label-aware shit !!!!
  -- [Egg Corridor] Go through Cthulhu's Abode and out the top door. +4 HP.
  -- lEggCorridorB = lifeCapsule({
  --   hp = 4,
  --   map = "Eggs",
  --   label = "0401"
  -- }),
  lGrasstown = lifeCapsule({
    hp = 5,
    map = "Weed",
    label = "????"
  }),
  lGrasstownExecution = lifeCapsule({
    hp = 5,
    map = "WeedD",
    label = "????"
  }),
  lSandZoneA = lifeCapsule({
    hp = 5,
    map = "Sand",
    label = "0500"
  }),
  -- !!!! Can't randomize this one until I do some label-aware shit !!!!
  -- [Sand Zone] At the end of the hidden path behind a pawpad block on the far right. +5 HP.
  -- lSandZoneB = lifeCapsule({
  --   hp = 4,
  --   map = "Sand",
  --   label = "0501"
  -- }),
  lLabyrinth = lifeCapsule({
    hp = 5,
    map = "MazeI",
    label = "????"
  }),
  lPlantationA = lifeCapsule({
    hp = 5,
    map = "Cent",
    label = "0450"
  }),
  -- !!!! Can't randomize this one until I do some label-aware shit !!!!
  -- [Plantation] Sitting on a platform hanging from the far upper-left ceiling. +4 HP.
  -- lPlantationB = lifeCapsule({
  --   hp = 4,
  --   map = "Cent",
  --   label = "0500"
  -- }),
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
  }),
  mGrasslands = missiles({
    map = "Weed",
  }),
  mGrasslandsHut = missiles({
    map = "WeedB",
  }),
  mEggCorridorRuined = missiles({
    map = "Eggs2",
  }),
  mEggObservationRuined = missiles({
    map = "EggR2",
    label = "0302",
  }),
  mSuperMissileLauncher = {
    name = "Super Missile Launcher",
    map = "MazeS",
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
      ["<FLJ0201:0201"] = "<EVE0201", -- Skip check which ensures you already have the missiles.
      ["<TAM0005:0010:0000"] = "<AM+0005:0005<TAM0005:0010:0000<FL+0202",
    },
    erase = "<FL+0202",
    label = "0201", -- Also 0200...
  }
  -- !!!! Uses a unique script... will have to be crafty... !!!!
  -- [Sanctuary] Bonus expansion.  Just before you fight the Heavy Press at the
  -- far west end of Blood-Stained Sanctuary B3, just past the pillar with 3 Deletes
  -- covering it, in the room filled with flying Butes and with a hanging platform
  -- with an arrow Bute on either side.  Above this platform is a single Star Block
  -- concealing a chest containing this massive expansion of 24 Misisles.
}

for k, t in pairs(data) do
  t.key = k
end

return data

--[[

-- Weapons

<KEY<FLJ1640:0201<FL+1640<SOU0022<CNP0200:0021:0000
<MSGOpened the chest.<NOD<GIT0002<AM+0002:0000<CLR
<CMU0010Got the =Polar Star=!<WAI0160<NOD<GIT0000<CLO<RMU

#0500
...
Here, you can have this.<NOD<GIT0003<AM+0003:0000<CLR
<CMU0010Got the =Fireball=!<WAI0160<NOD<RMU<GIT0000<CLRYou're looking for someone?<NOD

#0301
<KEY<GIT1008<MSGDo you want to use the
=Jellyfish Juice=?<YNJ0000<CLO<GIT0000
<IT-0008<ANP0300:0010:0000<WAI0030<FLJ0442:0302<FL+0442
<MSGYou find something in the
ashes...<NOD<CLR<GIT0007<AM+0007:0100
<CMU0010Got the =Bubbler=!<WAI0160<NOD<CLO<RMU<DNP0300<END

#0415
<KEY<MSG<FAC0019Oh, wow.<NOD<CLRThat Polar Star of yours
is in awful shape.<NOD
Do you want to trade
it for my machine gun?<YNJ0420<FL+0563<FAC0000<CLR
<TAM0002:0004:0100<GIT0002Handed over the =Polar Star=.<NOD<CLR
<CMU0010<GIT0004Got the =Machine Gun=!<WAI0160<NOD<RMU<CLO
<FAO0004<TRA0029:0090:0012:0009

#0601
<KEY<FL-0621<DNP0505<AM+0009:0000
<MSG<GIT0009<CMU0010
Got the =Blade=.<WAI0160<NOD<RMU<END

#0400
<KEY<FLJ0721:0410<MSGHey there.<NOD<CLRThis is the Labyrinth Shop!<NOD
But, sad to say, we got
burgled a while back,<NOD
and there's nothing to sell
right now.<NOD
Sorry 'bout that...<NOD<CLO<AMJ0002:0401<AMJ0013:0404<EVE0402
#0401
<KEY<MSGHm?<NOD<CLRHey, you've got something
pretty spiffy there.<NOD<CLRA Polar Star and a Fireball,
unless I miss my guess.<NOD<CLRCan I take a quick look at them?<YNJ0403<CLO
<AM-0003
<WAI0020<MSG<GIT0002Handed over the Polar Star.<NOD
<GIT0003Handed over the Fireball.<NOD<GIT0000<CLR
<SOU0044Hoho!<NOD<CLR<FL+0721<GIT0001<CLR
<TAM0002:0001:0000<CMU0010=Snake= complete!<WAI0160<NOD<RMU<END
#0402
<KEY<FL+0721<MSG*sigh*<NOD<CLRHere. How about this?<NOD<CLR<GIT1020<CLR
<CMU0010<IT+0020<EQ+0008Got the =Turbocharge=!<WAI0160<NOD<RMU<GIT0000<CLRYou can have it for free.<NOD
I don't see any money on you,
anyway.<NOD<END
#0403
<KEY<MSG<CLRYou're missing out!<NOD<END
#0404
<KEY<FL+0721<MSG*sigh*<NOD<CLRHere. How about this?<NOD<CLR<GIT1038<CLR
<CMU0010<IT+0038Got the =Whimsical Star=!<WAI0160<EQ+0128<FL+0722<NOD<RMU<GIT0000<CLRJust a decoration, I'm afraid,<NOD
but you've already got the
strongest weapon, so what
else can I do?<NOD<END

#0302
...
You can keep this gun.<NOD<CMU0000<FAO0001
After I finish it, of course.<NOD<CLO
<WAI0150<FAI0001
<FLA<WAI0050<TAM0002:0013:0000<FL+1644<FL+0303<MSG
<CMU0010<MSG<GIT0013
=Polar Star= became the =Spur=!<SMC<DNP0210<WAI0160<NOD<CMU0008<END

#0200
...
if that isn't a fine-
looking blade you've got
there.<NOD
Care to trade it for my fabulous
gun?<YNJ0201<FL+1372<CLR
<TAM0009:0012:0000<GIT0009Gave him the =Blade=.<NOD<CLR
<CMU0010<GIT0012Got the =Nemesis=!<WAI0160<NOD<RMU<END
#0201
<PRI<MSGReally? Too bad.<NOD<END



-- Equipment

#0200
<PRI<FLJ0322:0201<FL+0322<SOU0022<CNP0200:0021:0000
<MSGOpened the chest.<NOD<GIT1002<IT+0002<EQ+0002<CLR
<CMU0010Got the =Map System=!<WAI0160<NOD<RMU<EVE0201

#0400
<KEY<FLJ0705:0001<FL+0705<SOU0022<CNP0400:0021:0000
<MSGOpened the treasure chest.<NOD<GIT1019<IT+0019<EQ+0004<CLR
<CMU0010Got the =Arms Barrier=!<WAI0160<NOD<RMU<END



-- Items

-- Chako's Rouge
#0211
<KEY<MSG
Do you want to rest?<YNJ0000<FAO0004<CMU0000<WAI0020<CLR.....<IT+0037<NOD<CLO
<MNP0300:0012:0006:0000<ANP0300:0010:0000
<WAI0050
<LI+1000<SOU0020<MYD0002<MSG
Health restored.<NOD<CLO<RMU<FAI0004<END



-- Life Capsules

<PRI<SOU0022<DNP0400<CMU0016
<MSG<GIT1006Got a =Life Capsule=!<WAI0160<NOD<RMU<ML+0003
Max health increased by 3!<NOD<END

#0400
<PRI<FL+0101<SOU0022<DNP0400<CMU0016
<MSG<GIT1006Got a =Life Capsule=!<WAI0160<NOD<RMU<ML+0003
Max health increased by 3!<NOD<END

#0305
<PRI<DNP0305<SOU0022<CMU0016
<MSG<GIT1006Got a =Life Capsule=!<WAI0160<NOD<RMU<ML+0005
Max health increased by 5!<NOD<END

#0304
<PRI<DNP0304<SOU0022<CMU0016
<MSG<GIT1006Got a =Life Capsule=!<WAI0160<NOD<RMU<ML+0005
Max health increased by 5!<NOD<END

#0300
<PRI<SOU0022<DNP0300<CMU0016
<MSG<GIT1006Got a =Life Capsule=!<WAI0160<NOD<RMU<ML+0005
Max health increased by 5!<NOD<END

#0450
<PRI<FLJ1040:0451<FL+1040<MSGLong time no arf!<NOD<CLRI was told to bring this
to you...<NOD<CLR<SOU0022<CMU0016<GIT1006Got a =Life Capsule=!<WAI0160<NOD<RMU<ML+0005
Max health increased by 5!<NOD<GIT0000<ITJ0015:0451<CLROh, she said to give you
this, too...<NOD<CLR
<CMU0010<GIT1015<IT+0015<GIT1015Got a =Life Pot=!<WAI0160<NOD<GIT0000<RMU<EVE0451
<END

#0500
<PRI<SOU0022<DNP0500<CMU0016
<MSG<GIT1006Got a =Life Capsule=!<WAI0160<NOD<RMU<ML+0004
Max health increased by 4!<NOD<END

#0400
<PRI<SOU0022<DNP0400
<MSG<GIT1006Got a =Life Capsule=!<NOD<ML+0005
Max health increased by 5!<NOD<END

<KEY<DNP0420<MSG<GIT1035<IT+0035
Found Curly's Panties.<NOD<END

<CMU0010<GIT1015<IT+0015<GIT1015Got a =Life Pot=!<WAI0160<NOD<GIT0000<RMU<EVE0451
<END

-- TODO:

#0401
<PRI<FL+0102<SOU0022<DNP0401<CLR<CMU0016
<MSG<GIT1006Got a =Life Capsule=!<WAI0160<NOD<RMU<ML+0004
Max health increased by 4!<NOD<END

-- Missiles

#0300
<PRI<FLJ0200:0001<FL+0200
<SOU0022<CNP0300:0021:0000
<MSGOpened the treasure chest.<NOD<CLR<EVE0030

#0302
<PRI<FLJ0218:0001<FL+0218
<SOU0022<CNP0302:0021:0000
<MSGOpened the treasure chest.<NOD<EVE0030

 #0200
<PRI<FLJ0201:0201<MSGA charm has been placed on it.
It won't open...<NOD<END
#0201
<FLJ0766:0001<FL+0766<FL-0765<FL+0202
<SOU0022<CNP0200:0021:0000
<MSGOpened the treasure chest.<NOD<CLR<TAM0005:0010:0000
<CMU0010<GIT0010Your Missiles have been powered up!<WAI0160<NOD<RMU<END

]]
