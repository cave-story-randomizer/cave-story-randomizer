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
    settings.objective.index = 1
  elseif obj == "objNormalEnd" or obj == 2 then
    settings.objective.index = 2
  elseif obj == "objAllBosses" or obj == 3 then
    settings.objective.index = 4
  else
    settings.objective.index = 3
  end
  settings.objective.value = "override"

  if seed ~= nil then
    settings.customseed.value = seed or ""
    settings.seedselect.value = true
    settings.seedrandom.value = false
  end
end

layout.version.text = 'Cave Story Randomizer [Open Mode] v' .. VERSION
layout.author.text  = 'by shru and duncathan'
layout.twitter.text = '(@shruuu and @duncathan_salt)'

layout.footer.text = 'Original randomizer:\r\nshru.itch.io/cave-story-randomizer'

layout.go:onPress(function()
  Randomizer:new()

  if Randomizer:ready() then
    if settings.seedselect.value and settings.customseed.value ~= "" then
      Randomizer.customseed = settings.customseed.value:gsub("^%s*(.-)%s*$", "%1") -- trim any leading/trailing whitespace
    end

    Randomizer.obj = settings.objective.value

    Randomizer.puppy = settings.puppy.value
    C:setStatus(Randomizer:randomize())

    layout.sharecode.text = "Copy Sharecode"
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
  settings.sharecode.value = ""
end)

layout.sharecode:onPress(function()
  if Randomizer.sharecode ~= "" then
    love.system.setClipboardText(Randomizer.sharecode)
    layout.sharecode.text = "Copied!"
  end
end)

settings.customseed:onChange(function()
  if #settings.customseed.value > 20 then
    settings.customseed.value = settings.customseed.value:sub(1, 20)
  end
  settings.seedcount.text = ("%s/20"):format(#settings.customseed.value)
end)

settings.importshare:onPress(function()
  local success, seed, sharesettings = pcall(function()
    local packed = love.data.decode("data", "base64", settings.sharecode.value)
    local seed, settings = love.data.unpack("sB", packed)
    return seed, settings
  end)

  if success then 
    settings.importshare.text = "Sharecode Imported"
    local pup = bit.band(sharesettings, 4) ~= 0
    local obj = bit.band(sharesettings, 3)
    seed = seed:gsub("^%s*(.-)%s*$", "%1") -- trim any leading or trailing whitespace
    Screen:loadSettings(pup, obj, seed)
  else
    settings.importshare.text = "Invalid Sharecode!"
  end
end)

settings.sharecode:onChange(function()
  settings.importshare.text = "Import Sharecode"
end)

function C:draw()
  lg.draw(background, 0, 0)
  --layout:show()
end

function C:setStatus(text)
  layout.status.text = text
end

return C