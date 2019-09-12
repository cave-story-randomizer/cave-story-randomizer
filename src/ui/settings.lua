return { style = 'dialog',
  { style = 'dialogHead', text = 'Settings' },
  { style = 'dialogBody', padding = 24,
    { type = 'label', text = 'Seed' },
    {
      { type = 'radio', group = 'seed', text = 'Use random seed', value = true },
      { flow = 'y', { type = 'radio', group = 'seed', text = 'Use custom seed', id = 'seedselect'}, { type = 'text', id = 'customseed', width = 150 }, {height = false} }
    },
  },
  { style = 'dialogFoot',
    {},
    { style = 'dialogButton', id = 'closeButton', text = 'Close' }
  }
}