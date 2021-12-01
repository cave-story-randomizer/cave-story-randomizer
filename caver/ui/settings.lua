return { style = 'dialog',
  { style = 'dialogHead', text = 'Settings' },
  { style = 'dialogBody', padding = 24,
    { flow = 'x', minheight = 260,
      {
        { type = 'label', text = 'Seed', minheight = 32 },
        {
          { type = 'radio', group = 'seed', text = 'Use random seed', value = true, id = 'seedrandom', minheight = 27 },
          { flow = 'y', { type = 'radio', group = 'seed', text = 'Use custom seed', id = 'seedselect', minheight = 27 }, 
            {
              flow = 'x',
              { type = 'text', id = 'customseed', width = 200, minheight = 32},
              { type = 'label', id = 'seedcount' }
            }
          }
        },
        { type = 'label', text = 'Randomization Options', minheight = 32 },
        { type = 'check', value = false, id = 'puppy', text = "Puppies outside Sand Zone", minheight = 27 },
        { type = 'check', value = true, id = 'completable', text = "Guarantee access to all locations", minheight = 54},
        { flow = 'x', height = 32,
          { type = 'check', value = false, id = 'seqbreak', text = "Sequence breaks", minheight = 32, width =  170},
          { type = 'button', style = 'dialogButton', text = "Modify", id = 'seqButton', width = 70, align = 'center' },
          { width = false }
        },
      },
      {
        { type = 'label', text = 'Objective', minheight = 32 },
        { type = 'stepper', id = 'objective', align = 'center', width = 200,
          { text = "Bad ending", value = "objBadEnd" },
          { text = "Normal ending", value = "objNormalEnd" },
          { text = "Best ending", value = "objBestEnd" },
          { text = "All bosses", value = "objAllBosses" },
          { text = "100%", value = "obj100Percent" }
        },
        { type = 'label', text = 'Spawn Location', minheight = 32 },
        { type = 'stepper', id = 'spawn', align = 'middle left', height = 48, width = 200,
          { text = "  Start\r\n  Point", value = "Start Point", icon = "assets/icon/StartPoint2.png" },
          { text = "  Arthur's\r\n  House", value = "Arthur's House", icon = "assets/icon/Arthur2.png" },
          { text = "  Camp", value = "Camp", icon = "assets/icon/Camp.png" }
        },
        { type = 'button', style = 'dialogButton', text = "Personal Settings", id = 'musicButton', width = 200, height = 48, align = 'center' },
        { type = 'check', value = false, id = 'noFallingBlocks', text = "No Falling Blocks in Hell", minheight = 32 },
      },
    },
    {
      flow = 'x',
      { type = 'text', id = 'sharecode', width = 350 },
      { type = 'button', style = 'dialogButton', text = "Import Sharecode", id = 'importshare', width = 180, align = 'center' }
    }
  },
  { style = 'dialogFoot',
    {},
    { style = 'dialogButton', id = 'randoButton', text = 'Random Settings',  width = 120 },
    { style = 'dialogButton', id = 'closeButton', text = 'Close' }
  }
}