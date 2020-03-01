local Luigi   = require 'lib.luigi.layout'

local background

local C = Class:extend()

local layout = Luigi(require 'ui.main')
local settings = Luigi(require 'ui.settings')
local sequence = Luigi(require 'ui.sequence')

local style = require 'ui.style'
local theme = require 'lib.luigi.theme.dark'

layout:setStyle(style)
settings:setStyle(style)
sequence:setStyle(style)

layout:setTheme(theme)
settings:setTheme(theme)
sequence:setTheme(theme)

function C:setup()
  self:loadPuppy(Settings.settings.puppy)
  self:loadObjective(Settings.settings.obj)
  self:loadMyChar(Settings.settings.mychar)
  self:loadSpawn(Settings.settings.spawn)
  self:loadSeqSettings(Settings.settings.dboosts)

  background = lg.newImage('assets/background.png')
  self:draw()
  layout:show()
end

function C:loadPuppy(puppy)
  settings.puppy.value = puppy
end

function C:loadObjective(obj)
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
end

function C:loadSeed(seed)
  if seed ~= nil then
    settings.customseed.value = seed or ""
    settings.seedselect.value = true
    settings.seedrandom.value = false
  end
end

function C:loadMyChar(mychar)
  if mychar == "assets/myChar/Quote.bmp" then
    settings.mychar.index = 1
  elseif mychar == "assets/myChar/Curly.bmp" then
    settings.mychar.index = 2
  elseif mychar == "assets/myChar/Sue.bmp" then
    settings.mychar.index = 3
  elseif mychar == "assets/myChar/Toroko.bmp" then
    settings.mychar.index = 4
  elseif mychar == "assets/myChar/King.bmp" then
    settings.mychar.index = 5
  elseif mychar == "assets/myChar/Kanpachi.bmp" then
    settings.mychar.index = 6
  elseif mychar == "assets/myChar/Frog.bmp" then
    settings.mychar.index = 7
  end
  settings.mychar.value = "override"
end

function C:loadSpawn(spawn)
  if spawn == "Start Point" or spawn == 0 then
    settings.spawn.index = 1
  elseif spawn == "Arthur's House" or spawn == 1 then
    settings.spawn.index = 2
  elseif spawn == "Camp" or spawn == 2 then
    settings.spawn.index = 3
  end
  settings.spawn.value = "override"
end

function C:loadSeqSettings(seq)
  sequence.cthulhu.value = seq.cthulhu
  sequence.chaco.value = seq.chaco
  sequence.paxChaco.value = seq.paxChaco
  sequence.flightlessHut.value = seq.flightlessHut
  sequence.camp.value = seq.camp
  sequence.sisters.value = seq.sisters
  sequence.plantation.value = seq.plantation
  sequence.rocket.value = seq.rocket
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
    Randomizer.mychar = settings.mychar.value
    Randomizer.worldGraph.spawn = settings.spawn.value

    Randomizer.worldGraph.seqbreak = settings.seqbreak.value
    Randomizer.worldGraph.dboosts.cthulhu.enabled = sequence.cthulhu.value
    Randomizer.worldGraph.dboosts.chaco.enabled = sequence.chaco.value
    Randomizer.worldGraph.dboosts.paxChaco.enabled = sequence.paxChaco.value
    Randomizer.worldGraph.dboosts.flightlessHut.enabled = sequence.flightlessHut.value
    Randomizer.worldGraph.dboosts.camp.enabled = sequence.camp.value
    Randomizer.worldGraph.dboosts.sisters.enabled = sequence.sisters.value
    Randomizer.worldGraph.dboosts.plantation.enabled = sequence.plantation.value
    Randomizer.worldGraph.dboosts.rocket.enabled = sequence.rocket.value

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

settings.seqButton:onPress(function()
  sequence:show()
  settings:hide()
end)

sequence.allOn:onPress(function()
  Screen:loadSeqSettings(_.map(Settings.settings.dboosts, function(k,v) return true end))
end)

sequence.allOff:onPress(function()
  Screen:loadSeqSettings(_.map(Settings.settings.dboosts, function(k,v) return false end))
end)

sequence.close:onPress(function()
  sequence:hide()
  settings:show()
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
    Screen:loadPuppy(bit.band(sharesettings, 4) ~= 0) -- settings & (0b00000001 << 2)
    Screen:loadObjective(bit.band(sharesettings, 3)) -- settings & 0b00000011
    Screen:loadSpawn(bit.brshift(bit.band(sharesettings, 24), 3)) -- (settings & 0b00011000) >> 3
    Screen:loadSeed(seed:gsub("^%s*(.-)%s*$", "%1")) -- trim any leading or trailing whitespace
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