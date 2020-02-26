return { style = 'dialog',
  { style = 'dialogHead', text = 'Settings' },
  { style = 'dialogBody', padding = 24, flow = 'x',
    {
      { type = 'label', text = 'Seed' },
      {
        { type = 'radio', group = 'seed', text = 'Use random seed', value = true },
        { flow = 'y', { type = 'radio', group = 'seed', text = 'Use custom seed', id = 'seedselect'}, { type = 'text', id = 'customseed', width = 150 }, {height = false} }
      },
      { type = 'label', text = 'Randomization Options' },
      { type = 'check', value = false, id = 'puppy', text = "Puppysanity"},
      { height = false },
    },
    {
      { type = 'label', text = 'Objective' },
      { type = 'radio', group = 'objective', text = 'Bad ending' },
      { type = 'radio', group = 'objective', text = 'Normal ending' },
      { type = 'radio', group = 'objective', text = 'Best ending', value = true },
      { type = 'radio', group = 'objective', text = 'All bosses' },
    },
  },
  { style = 'dialogFoot',
    {},
    { style = 'dialogButton', id = 'closeButton', text = 'Close' }
  }
}