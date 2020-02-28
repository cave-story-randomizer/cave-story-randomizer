return { style = 'dialog',
  { style = 'dialogHead', text = 'Settings' },
  { style = 'dialogBody', padding = 24,
    { flow = 'x', minheight = 260,
      {
        { type = 'label', text = 'Seed', minheight = 32 },
        {
          { type = 'radio', group = 'seed', text = 'Use random seed', value = true, id = 'seedrandom', minheight = 27 },
          { flow = 'y', { type = 'radio', group = 'seed', text = 'Use custom seed', id = 'seedselect', minheight = 27 }, {{ type = 'text', id = 'customseed', width = 200, minheight = 32}, flow = 'x', { type = 'label', id = 'seedcount' }} }
        },
        { type = 'label', text = 'Randomization Options', minheight = 32 },
        { type = 'check', value = false, id = 'puppy', text = "Puppysanity", minheight = 27 },
        { height = 64 },
      },
      {
        { type = 'label', text = 'Objective', minheight = 32 },
        { type = 'radio', group = 'objective', text = 'Bad ending', id = 'bad', minheight = 27 },
        { type = 'radio', group = 'objective', text = 'Normal ending', id = 'norm', minheight = 27 },
        { type = 'radio', group = 'objective', text = 'Best ending', id = 'best', value = true, minheight = 27 },
        { type = 'radio', group = 'objective', text = 'All bosses', id = 'boss', minheight = 27 },
      },
    },
    {
      flow = 'x',
      { type = 'text', id = 'sharecode', width = 350 },
      { type = 'button', style = 'dialogButton', text = "Import Sharecode", id = 'importshare', width = 180 }
    }
  },
  { style = 'dialogFoot',
    {},
    { style = 'dialogButton', id = 'closeButton', text = 'Close' }
  }
}