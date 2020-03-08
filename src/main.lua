require 'lib.strict'

VERSION = '2.0-RC2'
CSVERSION = 1

Class   = require 'lib.classic'
_       = require 'lib.moses'

lf = love.filesystem
lg = love.graphics
ld = love.data

U = require 'util'

require 'log'
require 'lib.bit'

local random = require 'randomizer'
local settings = require 'settings'
Settings = settings()
Randomizer = random()
Screen = require 'ui.draw'

local csdirectory

function love.load(args)
  Settings:init()

  if _.contains(args, "--daily") then
    love.window.close()
    U.writeFile("daily.txt", generateDaily())
    love.event.quit()
    return
  end
  Screen:setup()

  if Settings.settings.csdirectory == "csdata" then
    Screen:setStatus("Cave story folder found!")
    Randomizer:setPath(Settings.settings.csdirectory)
  else
    Screen:setStatus("Drag and drop your Cave Story folder here.")
  end
  Screen:draw()
end

local function recursiveWrite(path, name)
  local filesTable = lf.getDirectoryItems(path)
  lf.createDirectory(name)
  for i,v in ipairs(filesTable) do
    local file = path..'/'..v
    if lf.getInfo(file, 'file') ~= nil then
      local n
      lf.write(name..'/'..v, lf.read(file))
    elseif lf.getInfo(file, 'directory') ~= nil then
      recursiveWrite(file, name..'/'..v)
    end
  end
end

local function recursivelyDelete( item )
  if lf.getInfo( item , "directory" ) then
      for _, child in ipairs( lf.getDirectoryItems( item )) do
          recursivelyDelete( item .. '/' .. child )
          lf.remove( item .. '/' .. child )
      end
  elseif lf.getInfo( item ) then
      lf.remove( item )
  end
  lf.remove( item )
end

function love.directorydropped(path)
  local success, dirStage = Randomizer:_mountDirectory(path)
  local csversion = lf.read(dirStage .. '/_version.txt') or "0"
  csversion = tonumber(csversion)
  --Randomizer:_unmountDirectory(path)
  if success then
    if csversion >= CSVERSION then
      recursivelyDelete('csdata') -- completely clear the folder, in case of user error :)
      recursiveWrite('mounted-data', 'csdata')

      Settings.settings.csdirectory = 'csdata'
      Settings.settings.csversion = csversion
      Settings:update()
      Randomizer:setPath('csdata')
      Screen:setStatus("Cave Story folder updated!")
    else
      Screen:setStatus("Invalid Cave Story folder!\n\nMake sure you're using an up to date version of the randomizer's included Cave Story folder.")
    end
  else
    Screen:setStatus("Could not find \"data\" subfolder.\n\nMaybe try dropping your Cave Story \"data\" folder in directly?")
  end
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.push('quit')
  end
end

function love.draw()
  Screen:draw()
end

function generateDaily()
  local json = [[{"embeds": [{"title": "**Daily Challenge: %s**","color": 11323851,"fields": [{"name": "Seed","value": "%s","inline": true},{"name": "Version","value": "%s","inline": true},{"name": "Settings","value": "**Objective**: %s\n**Spawn**: %s\n**Puppysanity**: %s\n**Sequence breaks**: %s\n"},{"name": "Title Screen Code","value": "<%s> <%s> <%s> <%s> <%s> (%s/%s/%s/%s/%s)"},{"name": "<:rando:558942498668675072> Sharecode","value": "`%s`"}]}]}]]
  
  local date = os.date("%B %d, %Y")

  local function pick(t) return t[love.math.random(#t)] end
  local objective = pick({{name = "Bad Ending", val = "objBadEnd"}, {name = "Normal Ending", val = "objNormalEnd"}, {name = "Best Ending", val = "objBestEnd"}, {name = "All Bosses", val = "objAllBosses"}, {name = "100%", val = "obj100Percent"}})
  local spawn = pick({"Start Point", "Arthur's House", "Camp"})
  local puppies = pick({{name = "Enabled", val = true}, {name = "Disabled", val = false}})
  local sequence = pick({{name = "All", val = true}, {name = "None", val = false}})

  Randomizer.obj = objective.val
  Randomizer.worldGraph.spawn = spawn
  Randomizer.puppy = puppies.val
  Randomizer.worldGraph.seqbreak = sequence.val

  local seed = Randomizer:_seedRngesus()
  Randomizer:_updateSharecode(seed)
  Randomizer:_shuffleItems()

  local itemdata = {
    {emoji = ":arthurkey:685845258843455501", name = "Arthur's Key"},
    {emoji = ":mapsystem:685848232374567076", name = "Map System"},
    {emoji = ":santakey:685848232428830790", name = "Santa's Key"},
    {emoji = ":silverlocket:685848232584413185", name = "Silver Locket"},
    {emoji = ":beastfang:685848232428830720", name = "Beast Fang"},
    {emoji = ":lifecapsule:685848233393913946", name = "Life Capsule"},
    {emoji = ":idcard:685848232295006208", name = "ID Card"},
    {emoji = ":jellyfishjuice:685848232290680879", name = "Jellyfish Juice"},
    {emoji = ":rustykey:685848232554791045", name = "Rusty Key"},
    {emoji = ":gumkey:685848232173240381", name = "Gum Key"},
    {emoji = ":gumbase:685848232336818195", name = "Gum Base"},
    {emoji = ":charcoal:685848232987066409", name = "Charcoal"},
    {emoji = ":explosive:685848232328560712", name = "Explosive"},
    {emoji = ":puppyitem:685848232554791003", name = "Puppy"},
    {emoji = ":lifepot:685848231875575868", name = "Life Pot"},
    {emoji = ":cureall:685848232315715596", name = "Cure-All"},
    {emoji = ":clinickey:685848232315715589", name = "Clinic Key"},
    {emoji = ":booster08:685848232332492802", name = "Booster 0.8"},
    {emoji = ":armsbarrier:685848232252932127", name = "Arms Barrier"},
    {emoji = ":turbocharge:685848232756248614", name = "Turbocharge"},
    {emoji = ":airtank:685848232311521353", name = "Curly's Air Tank"},
    {emoji = ":nikumaru:685848232504590342", name = "Nikumaru Counter"},
    {emoji = ":booster20:685848232299069511", name = "Booster 2.0"},
    {emoji = ":mimigamask:685848232592539695", name = "Mimiga Mask"},
    {emoji = ":teleportkey:685848232655716423", name = "Teleporter Room Key"},
    {emoji = ":suesletter:685848232554659898", name = "Sue's Letter"},
    {emoji = ":controller:685848232294613036", name = "Controller"},
    {emoji = ":brokensprinkler:685848232290680898", name = "Broken Sprinkler"},
    {emoji = ":sprinkler:685848232588476438", name = "Sprinkler"},
    {emoji = ":towrope:685848232403927093", name = "Tow Rope"},
    {emoji = ":clayfiguremedal:685848232160526375", name = "Clay Figure Medal"},
    {emoji = ":mrlittle:685848232521367630", name = "Mr. Little"},
    {emoji = ":mushroombadge:685848232445870111", name = "Mushroom Badge"},
    {emoji = ":mapignon:685848232122777673", name = "Ma Pignon"},
    {emoji = ":panties:685848232508915752", name = "Curly's Panties"},
    {emoji = ":alienmedal:685848232076640298", name = "Alien Medal"},
    {emoji = ":lipstick:685848232370372609", name = "Chaco's Lipstick"},
    {emoji = ":whimsicalstar:685848232458190853", name = "Whimsical Star"},
    {emoji = ":ironbond:685848232341143625", name = "Iron Bond"}
  }
  local hash = Randomizer:_generateHash()
  local h = {itemdata[hash[1]], itemdata[hash[2]], itemdata[hash[3]], itemdata[hash[4]], itemdata[hash[5]]}

  return json:format(date, seed, VERSION, objective.name, spawn, puppies.name, sequence.name, h[1].emoji, h[2].emoji, h[3].emoji, h[4].emoji, h[5].emoji, h[1].name, h[2].name, h[3].name, h[4].name, h[5].name, Randomizer.sharecode)
end