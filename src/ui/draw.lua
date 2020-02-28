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
  self:loadSettings(Settings.settings.puppy, Settings.settings.obj)

  background = lg.newImage('assets/background.png')
  self:draw()
  layout:show()
end

function C:loadSettings(puppy, obj, seed)
  settings.puppy.value = puppy

  if obj == "objBadEnd" or obj == 1 then
    settings.bad.value = true
    settings.norm.value = false
    settings.boss.value = false
    settings.best.value = false
  elseif obj == "objNormalEnd" or obj == 2 then
    settings.bad.value = false
    settings.norm.value = true
    settings.boss.value = false
    settings.best.value = false
  elseif obj == "objAllBosses" or obj == 3 then
    settings.bad.value = false
    settings.norm.value = false
    settings.boss.value = true
    settings.best.value = false
  else
    settings.bad.value = false
    settings.norm.value = false
    settings.boss.value = false
    settings.best.value = true
  end

  settings.customseed.value = seed or ""
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

    if settings.bad.value then
      Randomizer.obj = "objBadEnd"
    elseif settings.norm.value then
      Randomizer.obj = "objNormalEnd"
    elseif settings.boss.value then
      Randomizer.obj = "objAllBosses"
    else
      Randomizer.obj = "objBestEnd"
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

settings.customseed:onChange(function()
  if #settings.customseed.value > 20 then
    settings.customseed.value = settings.customseed.value:sub(1, 20)
  end
  settings.seedcount.text = ("%s/20"):format(#settings.customseed.value)
end)

function C:draw()
  lg.draw(background, 0, 0)
  --layout:show()
end

function C:setStatus(text)
  layout.status.text = text
end

return C