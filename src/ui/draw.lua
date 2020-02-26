local Luigi   = require 'lib.luigi.layout'

local background

local C = Class:extend()

local layout = Luigi(require 'ui.main')
local settings = Luigi(require 'ui.settings')
layout:setStyle(require 'ui.style')
settings:setStyle(require 'ui.style')
layout:setTheme(require 'lib.luigi.theme.dark')
settings:setTheme(require 'lib.luigi.theme.dark')

function C:setup()
  background = lg.newImage('assets/background.png')
  self:draw()
  layout:show()
end

layout.version.text = 'Cave Story Randomizer [Open Mode] v' .. VERSION
layout.author.text  = 'by shru and duncathan'
layout.twitter.text = '(@shruuu and @duncathan_salt)'

layout.footer.text = 'Original randomizer:\r\nshru.itch.io/cave-story-randomizer'

layout.go:onPress(function()
  if Randomizer:ready() then
    if settings.seedselect.value and settings.customseed.value ~= "" then
      Randomizer.customseed = settings.customseed.value
    end

    --if settings.bad.value then
    --  Randomizer.game = "gameBadEnd"
    if settings.norm.value then
      Randomizer.game = "gameNormalEnd"
    elseif settings.boss.value then
      Randomizer.game = "gameAllBosses"
    else
      Randomizer.game = "gameBestEnd"
    end

    Randomizer.puppy = settings.puppy.value
    C:setStatus(Randomizer:randomize())
    Randomizer:new()
  else
    C:setStatus("No Cave Story folder found!\r\nDrag and drop your Cave Story folder here.")
  end
end)

layout.settings:onPress(function()
  settings:show()
  layout:hide()
end)

settings.closeButton:onPress(function()
  settings:hide()
  layout:show()
end)

function C:draw()
  lg.draw(background, 0, 0)
  --layout:show()
end

function C:setStatus(text)
  layout.status.text = text
end

return C