return { style = 'dialog',
  { style = 'dialogHead', text = 'Sequence Break Settings'},
  { style = 'dialogBody', padding = 24,
    { type = 'check', value = true, id = 'cthulhu', text = "Cthulhu's Abode (requires 3HP)", minheight = 27 },
    { type = 'check', value = true, id = 'chaco', text = "Chaco Skip (requires 5HP)", minheight = 27 },
    { type = 'check', value = true, id = 'paxChaco', text = "Chaco Skip without a weapon (requires 10HP)", minheight = 27 },
    { type = 'check', value = true, id = 'flightlessHut', text = "Flightless Grasstown Hut (requires 3HP)", minheight = 27 },
    { type = 'check', value = true, id = 'camp', text = "Flightless Camp Chest (requires 9HP)", minheight = 27 },
    { type = 'check', value = true, id = 'sisters', text = "Sisters Skip (requires flight)", minheight = 27 },
    { type = 'check', value = true, id = 'plantation', text = "Flightless Plantation Chest (requires 15HP)", minheight = 27 },
    { type = 'check', value = true, id = 'rocket', text = "Rocket Skip (requires 3HP, Machine Gun, and Booster 2.0)", minheight = 27 },
  },
  { style = 'dialogFoot',
    {},
    { style = 'dialogButton', id = 'allOn', text = 'All On' },
    { style = 'dialogButton', id = 'allOff', text = 'All Off' },
    { style = 'dialogButton', id = 'close', text = 'Close' }
  }
}