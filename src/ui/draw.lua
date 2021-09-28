local Luigi   = require 'lib.luigi.layout'

local background

local C = Class:extend()

local layout = Luigi(require 'ui.main')
local settings = Luigi(require 'ui.settings')
local sequence = Luigi(require 'ui.sequence')
local music = Luigi(require 'ui.music')

local style = require 'ui.style'
local theme = require 'lib.luigi.theme.dark'

local utf8 = require("utf8")

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
  self:loadMusicSettings(Settings.settings.musicShuffle, Settings.settings.musicFlavor, Settings.settings.musicVanilla, Settings.settings.musicBeta, Settings.settings.musicKero)
  self:loadNoFallingBlocks(Settings.settings.noFallingBlocks)
  self:loadCompleteableLogic(Settings.settings.completableLogic)

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
  --Screen:loadMyChar(love.math.random(9))
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
  --Screen:loadMusicSettings(fifty(), love.math.random(3), fifty())
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
  local mc = music.mychar
  if type(mychar) == "number" then
    mc.index = mychar
  elseif mychar == "assets/myChar/Quote.bmp" then
    mc.index = 1
  elseif mychar == "assets/myChar/Curly.bmp" then
    mc.index = 2
  elseif mychar == "assets/myChar/Sue.bmp" then
    mc.index = 3
  elseif mychar == "assets/myChar/Toroko.bmp" then
    mc.index = 4
  elseif mychar == "assets/myChar/King.bmp" then
    mc.index = 5
  elseif mychar == "assets/myChar/Chaco.bmp" then
    mc.index = 6
  elseif mychar == "assets/myChar/Kanpachi.bmp" then
    mc.index = 7
  elseif mychar == "assets/myChar/Misery.bmp" then
    mc.index = 8
  elseif mychar == "assets/myChar/Frog.bmp" then
    mc.index = 9
  end
  mc.value = "override"
end

function C.numToMyChar(num)
  local mychars = {
    "assets/myChar/Quote.bmp",
    "assets/myChar/Curly.bmp",
    "assets/myChar/Sue.bmp",
    "assets/myChar/Toroko.bmp",
    "assets/myChar/King.bmp",
    "assets/myChar/Chaco.bmp",
    "assets/myChar/Kanpachi.bmp",
    "assets/myChar/Misery.bmp",
    "assets/myChar/Frog.bmp",
  }
  return mychars[num]
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

function C:loadMusicSettings(shuffle, flavor, cs, beta, kero)
  music.music.value = shuffle
  music.cavestory.value = cs
  music.beta.value = beta
  music.kero.value = kero
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

function C:loadCompleteableLogic(completableLogic)
  settings.completable.value = not completableLogic
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

layout.go:onPress(function()
  Randomizer:new()

  if Randomizer:ready() then
    if settings.seedselect.value and settings.customseed.value ~= "" then
      Randomizer.customseed = settings.customseed.value:gsub("^%s*(.-)%s*$", "%1") -- trim any leading/trailing whitespace
    end

    Randomizer.obj = settings.objective.value
    Randomizer.puppy = settings.puppy.value
    if music.mychar.value == "random" then
      Randomizer.mychar = Screen.numToMyChar(love.math.random(9))
    else
      Randomizer.mychar = music.mychar.value
    end
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

    Randomizer.shuffleMusic = music.music.value
    Randomizer.music.vanillaEnabled = music.cavestory.value
    Randomizer.music.betaEnabled = music.beta.value
    Randomizer.music.keroEnabled = music.kero.value
    if music.shuffle.value then Randomizer.music.flavor = "Shuffle" end
    if music.random.value then Randomizer.music.flavor = "Random" end
    if music.chaos.value then Randomizer.music.flavor = "Chaos" end

    Randomizer.worldGraph.noFallingBlocks = settings.noFallingBlocks.value
    Randomizer.completableLogic = not settings.completable.value

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
    local str = settings.customseed.value:sub(1, 20)
    local length, invalidPos = utf8.len(str)
    if not length then -- produced invalid sequence, need to adjust
      str = str:sub(1, invalidPos - 1)
    end
    settings.customseed.value = str
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
    Screen:loadCompleteableLogic(bit.band(sharesettings, 512) ~= 0) -- (settings & 0b1000000000)
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
