local Luigi   = require 'lib.luigi.layout'

local background

local C = Class:extend()

local layout = Luigi(require 'layout')
layout:setStyle(require 'style')

function C:setup()
  background = lg.newImage('assets/background.png')
  self:setStatus("Drag and drop your Cave Story folder here.")
end

layout.version.text = 'Cave Story Randomizer [Open Mode] v' .. VERSION
layout.author.text  = 'by shru and duncathan'
layout.twitter.text = '(@shruuu and @duncathan_salt)'

layout.footer.text = 'Original randomizer:\r\nshru.itch.io/cave-story-randomizer'

function C:draw()
  lg.draw(background, 0, 0)
  layout:show()
end

function C:setStatus(text)
  layout.status.text = text
end

return C