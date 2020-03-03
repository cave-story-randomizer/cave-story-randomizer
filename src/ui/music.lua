return { style = 'dialog',
  { style = 'dialogHead', text = 'Music Settings' },
  { style = 'dialogBody', padding = 24, flow = 'x',
    {
      { type = 'label', text = 'Type of randomization' },
      { type = 'radio', group = 'music', text = 'Shuffle', id = 'shuffle', minheight = 27 },
      { type = 'radio', group = 'music', text = 'Random', id = 'random', minheight = 27 },
      { type = 'radio', group = 'music', text = 'Chaos', id = 'chaos', minheight = 27 },
      { type = 'label', text = 'Other settings' },
      { type = 'check', id = 'beta', value = false, text = 'Enable beta music', minheight = 27 },
    },
    {
      {
        align = 'top center',
        wrap = true,
        id = 'panel',
        width = 275,
        scroll = true
      },
      { height = 10 },
      { type = 'label', text = '[scroll for more]', align = 'center', width = 275, minheight = 27 }
    }
  },
  { style = 'dialogFoot',
    {},
    { style = 'dialogButton', id = 'close', text = 'Close' }
  }
}