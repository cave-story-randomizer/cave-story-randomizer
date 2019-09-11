local Luigi   = require 'lib.luigi.layout'

local background

local C = Class:extend()

local layout = Luigi(require 'ui.main')
--local settings = Luigi(require 'ui.settings')
layout:setStyle(require 'ui.style')
--settings:setStyle(require 'ui.style')

function C:setup()
  background = lg.newImage('assets/background.png')
end

layout.version.text = 'Cave Story Randomizer [Open Mode] v' .. VERSION
layout.author.text  = 'by shru and duncathan'
layout.twitter.text = '(@shruuu and @duncathan_salt)'

layout.footer.text = 'Original randomizer:\r\nshru.itch.io/cave-story-randomizer'

layout.go:onPress(function()
  C:setStatus(Randomizer:randomize())
  Randomizer:new()
end)

function C:draw()
  lg.draw(background, 0, 0)
  layout:show()
end

function C:setStatus(text)
  layout.status.text = text
end

return C