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
      ("Got a =Life Capsule=!<WAI0160<NOD\n\r Max health increased by %d!"):format(t.hp),
      "Got a =Life Capsule=!<WAI0160<NOD", -- erase the extra wait for most things.
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
  }),
  lYamashitaFarm = lifeCapsule({
    hp = 3,
    map = "Plant",
  }),
  lEggCorridorA = lifeCapsule({
    hp = 3,
    map = "Eggs",
  }),
  -- !!!! Can't randomize this one until I do some label-aware shit !!!!
  -- Egg Corridor: Go through Cthulhu's Abode and out the top door. +4 HP.
  -- lEggCorridorB = lifeCapsule({
  --   hp = 4,
  --   map = "Plant",
  -- }),

  -- Bushlands: Just past where you found Santa's Key, go east to a set of two
  -- horizontal rows of star blocks, jump on them and to the left.  +5 HP.

  -- Bushlands: In the Execution Chamber, the tall building with the skull on it
  -- to the right of Kazuma's shack.  +5 HP.

  -- Sand Zone: East of Curly's House and past the Sun Stones, it's in the top of
  -- the first thick pillar made up of star blocks.  Try not to blow up all the star
  -- blocks when fighting the Polishes to create a path and reach it.  +5 HP.

  -- Sand Zone: At the end of the hidden path behind a pawpad block on the far
  -- right wall between the Sun Stones and Jenka's house, behind a line of star
  -- blocks.  Found next to a chest containing one of Jenka's dogs.  +5 HP.

  -- Labyrinth: Nestled next to the left wall of the first room of the labyrinth
  -- when you're sent there, a ways up into the room.  +5 HP.

  -- Plantation: Sitting on a platform hanging from the far upper-left ceiling.
  -- +4 HP.

  -- Plantation: Talk to the puppy that appears on the left platform just under
  -- the red skull signs on the top right section of the Plantation after Momorin's
  -- finished the rocket.  +5 HP.

  -- Sanctuary: Bonus life capsule.  Found in plain sight as you make your
  -- initial descent.  +5 HP.

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


<KEY<DNP0420<MSG<GIT1035<IT+0035
Found Curly's Panties.<NOD<END

-- TODO:

#0401
<PRI<FL+0102<SOU0022<DNP0401<CLR<CMU0016
<MSG<GIT1006Got a =Life Capsule=!<WAI0160<NOD<RMU<ML+0004
Max health increased by 4!<NOD<END

]]
