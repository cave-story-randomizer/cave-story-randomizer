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
        text = 'Randomize!',
        width = 100,
        height = 32,
      },
      {
        type = 'button',
        style = 'button',
        id = 'sharecode',
        text = "Copy Sharecode",
        width = 100,
        height = 32,
      },
      { width = false }
    },
    {
      flow = 'x',
      height = 120,
      { width = 20 },
      {
        {
          type = 'panel',
          id = 'footershru',
          height = 32,
          style = 'transpanel',
          align = 'top left'
        },
        { flow = 'x', 
          type = 'panel',
          id = 'footerlink',
          height = 32,
          style = 'transpanel',
          align = 'top left',
          { id = 'linktext', width = 310, icon = 'assets/icon/discord.png' },
          { id = 'linkicon', icon = 'assets/icon/link.png'}
        },
      }
    }
  }
}