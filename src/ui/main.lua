return { id = 'window',
  { flow = 'y',
    {
      type = 'panel',
      id = 'header',
      height = 100,
      style = 'transpanel',
      align = 'top center',
      { height = 10 },
      { id = 'version', text = "" },
      { id = 'author', text = ""  },
      { id = 'twitter', text = "" },
      { height = 10 }
    },
    {
      type = 'panel',
      id = 'status',
      height = 260,
      style = 'transpanel',
      align = 'top center',
      margin = 24,
      wrap = true,
    },
    { 
      flow = 'x',
      height = '40',
      { width = false },
      {
        type = 'button',
        style = 'button',
        id = 'settings',
        text = 'Settings',
        width = 100,
        height = 32,
      },
      {
        type = 'button',
        style = 'button',
        id = 'go',
        text = 'Randomize',
        width = 100,
        height = 32,
      },
      { width = false }
    },
    {
      flow = 'x',
      { width = 20 },
      {
        type = 'panel',
        id = 'footer',
        height = 80,
        style = 'transpanel',
        align = 'centre left',
      }
    }
  }
}