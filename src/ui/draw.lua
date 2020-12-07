local Luigi   = require 'lib.luigi.layout'

local background

local C = Class:extend()

local layout = Luigi(require 'ui.main')
local settings = Luigi(require 'ui.settings')
local sequence = Luigi(require 'ui.sequence')
local music = Luigi(require 'ui.music')

local style = require 'ui.style'
local theme = require 'lib.luigi.theme.dark'

layout:setStyle(style)
settings:setStyle(style)
sequence:setStyle(style)
music:setStyle(style)

layout:setTheme(theme)
settings:setTheme(theme)
sequence:setTheme(theme)
music:setTheme(theme)

function C:setup()
  self:loadPuppy(Settings.settings.puppy)
  self:loadObjective(Settings.settings.obj)
  self:loadMyChar(Settings.settings.mychar)
  self:loadSpawn(Settings.settings.spawn)
  self:loadSeqSettings(Settings.settings.seqbreaks, Settings.settings.dboosts)
  self:loadMusicSettings(Settings.settings.musicShuffle, Settings.settings.musicBeta, Settings.settings.musicFlavor)
  self:loadNoFallingBlocks(Settings.settings.noFallingBlocks)

  background = lg.newImage('assets/background.png')
  self:draw()
  layout:show()
end

settings.randoButton:onPress(function()
  local function fifty() return love.math.random(2) == 2 end
  Screen:loadPuppy(fifty())
  Screen:loadObjective(love.math.random(4)-1)
  settings.seedselect.value = false
  settings.seedrandom.value = true
  Screen:loadMyChar(love.math.random(9))
  Screen:loadSpawn(love.math.random(3)-1)
  Screen:loadSeqSettings(fifty(), {
  cthulhu = fifty(),
  chaco = fifty(),
  paxChaco = fifty(),
  flightlessHut = fifty(),
  camp = fifty(),
  sisters = fifty(),
  plantation = fifty(),
  rocket = fifty()
  })
  Screen:loadMusicSettings(fifty(), fifty(), love.math.random(3))
  Screen:loadNoFallingBlocks(fifty())
end)

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
  elseif obj == "obj100Percent" or obj == 4 then
    settings.objective.index = 5
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
  if type(mychar) == "number" then
    settings.mychar.index = mychar
  elseif mychar == "assets/myChar/Quote.bmp" then
    settings.mychar.index = 1
  elseif mychar == "assets/myChar/Curly.bmp" then
    settings.mychar.index = 2
  elseif mychar == "assets/myChar/Sue.bmp" then
    settings.mychar.index = 3
  elseif mychar == "assets/myChar/Toroko.bmp" then
    settings.mychar.index = 4
  elseif mychar == "assets/myChar/King.bmp" then
    settings.mychar.index = 5
  elseif mychar == "assets/myChar/Chaco.bmp" then
    settings.mychar.index = 6
  elseif mychar == "assets/myChar/Kanpachi.bmp" then
    settings.mychar.index = 7
  elseif mychar == "assets/myChar/Misery.bmp" then
    settings.mychar.index = 8
  elseif mychar == "assets/myChar/Frog.bmp" then
    settings.mychar.index = 9
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

function C:loadSeqSettings(breaks, seq)
  if breaks ~= nil then settings.seqbreak.value = breaks end
  if breaks or breaks == nil then
    sequence.cthulhu.value = seq.cthulhu
    sequence.chaco.value = seq.chaco
    sequence.paxChaco.value = seq.paxChaco
    sequence.flightlessHut.value = seq.flightlessHut
    sequence.camp.value = seq.camp
    sequence.sisters.value = seq.sisters
    sequence.plantation.value = seq.plantation
    sequence.rocket.value = seq.rocket
  end
end

function C:loadMusicSettings(shuffle, beta, flavor)
  settings.music.value = shuffle
  music.beta.value = beta
  if flavor == "Shuffle" or flavor == 1 then 
    music.shuffle.value = true
    music.random.value = false
    music.chaos.value = false
  end
  if flavor == "Random" or flavor == 2 then 
    music.shuffle.value = false
    music.random.value = true 
    music.chaos.value = false
  end
  if flavor == "Chaos" or flavor == 3 then 
    music.shuffle.value = false
    music.random.value = false
    music.chaos.value = true
  end
end

function C:loadNoFallingBlocks(noFallingBlocks)
  settings.noFallingBlocks.value = noFallingBlocks
end

layout.version.text = 'Cave Story Randomizer v' .. VERSION
layout.author.text  = 'by duncathan'
layout.twitter.text = '(@duncathan_salt)'

layout.linktext.text = 'Join our Discord server!'
layout.footerlink:onEnter(function()
  layout.linktext.color = {0.8,0.8,0.8} -- #CCCCCC
  layout.linkicon.icon = 'assets/icon/linkgrey.png'
end)
layout.footerlink:onLeave(function()
  layout.linktext.color = {1,1,1} -- #FFFFFF
  layout.linkicon.icon = 'assets/icon/link.png'
end)
layout.footerlink:onPress(function()
  love.system.openURL("https://discord.gg/7zUdPEn")
end)

layout.footershru.text = 'Original randomizer by @shruuu'

music.panel.text = [[Shuffle: remap every song to a new song. For example, all instances of Mischievous Robot become Pulse. Songs may remap to themselves.

Random: remap every cue to a new song. For example, entering the Egg Corridor by any means plays Meltdown 2.

Chaos: remap every <CMU to a new song. For example, teleporting to the Egg Corridor plays Charge, but entering Egg Corridor from Cthulhu's Abode plays Run!

Beta music: include Wind Fortress, Halloween 2, People of the Root, Pier Walk, and Snoopy Cake in the potential songs. Only compatible with the included Doukutsu.exe - no other platforms.]]

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

    Randomizer.shuffleMusic = settings.music.value
    Randomizer.music.betaEnabled = music.beta.value
    if music.shuffle.value then Randomizer.music.flavor = "Shuffle" end
    if music.random.value then Randomizer.music.flavor = "Random" end
    if music.chaos.value then Randomizer.music.flavor = "Chaos" end

    Randomizer.worldGraph.noFallingBlocks = settings.noFallingBlocks.value

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

settings.musicButton:onPress(function()
  music:show()
  settings:hide()
end)

sequence.allOn:onPress(function()
  Screen:loadSeqSettings(nil, _.map(Settings.settings.dboosts, function(k,v) return true end))
end)

sequence.allOff:onPress(function()
  Screen:loadSeqSettings(nil, _.map(Settings.settings.dboosts, function(k,v) return false end))
end)

sequence.close:onPress(function()
  sequence:hide()
  settings:show()
end)

music.close:onPress(function()
  music:hide()
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
  local success, seed, sharesettings, seq = pcall(function()
    local packed = love.data.decode("data", "base64", settings.sharecode.value)
    local seed, settings, seq = love.data.unpack("<s1I2B", packed)
    assert(#seed == 20)
    return seed, settings, seq
  end)

  if success then 
    settings.importshare.text = "Sharecode Imported"
    Screen:loadPuppy(bit.band(sharesettings, 1) ~= 0) -- settings & 0b000000001
    Screen:loadObjective(bit.brshift(bit.band(sharesettings, 14), 1)) -- (settings & 0b000001110) >> 1
    Screen:loadSpawn(bit.brshift(bit.band(sharesettings, 112), 4)) -- (settings & 0b001110000) >> 4
    Screen:loadSeed(seed:gsub("^%s*(.-)%s*$", "%1")) -- trim any leading or trailing whitespace
    Screen:loadSeqSettings(bit.band(sharesettings, 128) ~= 0, { -- (settings & 0b010000000)
      cthulhu = bit.band(seq, 1) ~= 0,
      chaco = bit.band(seq, 2) ~= 0,
      paxChaco = bit.band(seq, 4) ~= 0,
      flightlessHut = bit.band(seq, 8) ~= 0,
      camp = bit.band(seq, 16) ~= 0,
      sisters = bit.band(seq, 32) ~= 0,
      plantation = bit.band(seq, 64) ~= 0,
      rocket = bit.band(seq, 128) ~= 0
    })
    Screen:loadNoFallingBlocks(bit.band(sharesettings, 256) ~= 0) -- (settings & 0b100000000)
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