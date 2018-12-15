function weapon(t)
  assert(t.name and t.map and t.id and t.ammo)
  return {
    name = t.name,
    map = t.map,
    getText = ("Got the =%s=!<WAI0160<NOD"):format(t.name),
    command = ("<AM+00%s:%s"):format(t.id, t.ammo),
    displayCmd = ("<GIT00%s"):format(t.id),
    music = "<CMU0010",
    kind = "weapon",
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
    },
    command = ("<ML+000%d"):format(t.hp),
    displayCmd = "<GIT1006",
    music = "<CMU0016",
    erase = ("Max health increased by %d!<NOD"):format(t.hp),
  }
end

return {
  -------------------
  -- WEAPONS --
  -------------------
  wPolarStar = weapon({
    name = "Polar Star",
    map = "Pole",
    id = "02",
    ammo = "0000",
  }),
  wBubbler = weapon({
    name = "Bubbler",
    map = "Comu",
    id = "07",
    ammo = "0100",
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
    label = "0400"
  }),

  -----------
  -- ITEMS --
  -----------
  iPanties = {
    name = "Curly's Panties",
    map = "CurlyS",
    getText = {
      "Found =Curly's Panties=.",
      "Found =Curly's Underwear=.",
    },
    command = "<IT+0035",
    displayCmd = "<GIT1035",
  },
}

--[[

<KEY<FLJ1640:0201<FL+1640<SOU0022<CNP0200:0021:0000
<MSGOpened the chest.<NOD<GIT0002<AM+0002:0000<CLR
<CMU0010Got the =Polar Star=!<WAI0160<NOD<GIT0000<CLO<RMU

#0301
<KEY<GIT1008<MSGDo you want to use the
=Jellyfish Juice=?<YNJ0000<CLO<GIT0000
<IT-0008<ANP0300:0010:0000<WAI0030<FLJ0442:0302<FL+0442
<MSGYou find something in the
ashes...<NOD<CLR<GIT0007<AM+0007:0100
<CMU0010Got the =Bubbler=!<WAI0160<NOD<CLO<RMU<DNP0300<END

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

-- TODO:

#0401
<PRI<FL+0102<SOU0022<DNP0401<CLR<CMU0016
<MSG<GIT1006Got a =Life Capsule=!<WAI0160<NOD<RMU<ML+0004
Max health increased by 4!<NOD<END

]]
