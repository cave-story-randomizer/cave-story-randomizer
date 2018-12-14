return {
  -- Weapons
  -- wXXX = {
  --   name = "",
  --   map = "",
  --   getText = "",
  --   command = "",
  --   displayCmd = "",
  --   kind = "weapon",
  -- },
  wBubbler = {
    name = "Bubbler",
    map = "Comu",
    getText = "Got the =Bubbler=!",
    command = "<AM+0007:0100",
    displayCmd = "<GIT0007",
    kind = "weapon",
  },
  wPolar = {
    name = "Polar Star",
    map = "Pole",
    getText = "Got the =Polar Star=!",
    command = "<AM+0002:0000",
    displayCmd = "<GIT0002",
    kind = "weapon",
  },
  -- Items
  iPanties = {
    name = "Curly's Panties",
    map = "CurlyS",
    getText = "Found =Curly's Underwear=.",
    -- getText = "Found =Curly's Panties=.", -- Grrr
    command = "<IT+0035",
    displayCmd = "<GIT1035",
    kind = "item",
  },
}

-- #0200
-- <KEY<FLJ1640:0201<FL+1640<SOU0022<CNP0200:0021:0000
-- <MSGOpened the chest.<NOD<GIT0002<AM+0002:0000<CLR
-- <CMU0010Got the =Polar Star=!<WAI0160<NOD<GIT0000<CLO<RMU
-- <MSG
-- From somewhere, a transmission...<FAO0004<NOD<TRA0018:0501:0002:0000

-- #0420
-- <KEY<DNP0420<MSG<GIT1035<IT+0035
-- Found Curly's Panties.<NOD<END
