local song = Class:extend()
function song:new(name, id, jingle, game)
  self.name = name
  self.id = id
  self.jingle = jingle or false
  self.game = game or "vanilla"
end

local songs = {
  xxxx = song("XXXX", "0000", true),
  mischievousRobot = song("Mischievous Robot", "0001"),
  safety = song("Safety", "0002"),
  gameOver = song("Game Over", "0003", true),
  gravity = song("Gravity", "0004"),
  onToGrasstown = song("On to Grasstown", "0005"),
  meltdown = song("Meltdown 2", "0006"),
  eyesOfFlame = song("Eyes of Flame", "0007"),
  gestation = song("Gestation", "0008"),
  mimigaTown = song("Mimiga Town", "0009"),
  getItem = song("Get Item!", "0010", true),
  balrogsTheme = song("Balrog's Theme", "0011"),
  cemetary = song("Cemetary", "0012"),
  plant = song("Plant", "0013"),
  pulse = song("Pulse", "0014"),
  victory = song("Victory!", "0015", true),
  getLifeCapsule = song("Get Life Capsule!", "0016", true),
  tyrant = song("Tyrant", "0017"),
  run = song("Run!", "0018"),
  jenka1 = song("Jenka 1", "0019"),
  labyrinthFight = song("Labyrinth Fight", "0020"),
  access = song("Access", "0021"),
  oppression = song("Oppression", "0022"),
  geothermal = song("Geothermal", "0023"),
  caveStory = song("Cave Story", "0024"),
  moonsong = song("Moonsong", "0025"),
  herosEnd = song("Hero's End", "0026"),
  scorchingBack = song("Scorching Back", "0027"),
  quiet = song("Quiet", "0028"),
  finalCave = song("Final Cave", "0029"),
  balcony = song("Balcony", "0030"),
  charge = song("Charge", "0031"),
  lastBattle = song("Last Battle", "0032"),
  theWayBackHome = song("The Way Back Home", "0033"),
  zombie = song("Zombie", "0034"),
  breakDown = song("Break Down", "0035"),
  runningHell = song("Running Hell", "0036"),
  jenka2 = song("Jenka 2", "0037"),
  livingWaterway = song("Living Waterway", "0038"),
  sealChamber = song("Seal Chamber", "0039"),
  torokosTheme = song("Toroko's Theme", "0040"),
  white = song('"White"', "0041"),
  windFortress = song("Wind Fortress", "0042", false, "beta"),
  halloween2 = song("Halloween 2", "0043", false, true),
  peopleOfTheRoot = song("People of the Root", "0044", false, "beta"),
  pierWalk = song("Pier Walk", "0045", false, "beta"),
  snoopyCake = song("Snoopy Cake", "0046", false, "beta"),
  dataSlots = song("Data Slots", "0047", false, "kero"),
  catAndFrog = song("Cat & Frog Corp.", "0048", false, "kero"),
  --itsMyBlaster = song("It's My Blaster!", "0049", false, "kero"),
  shoppingCart = song("Shopping Cart", "0050", false, "kero"),
  prothallium = song("Prothallium", "0051", false, "kero"),
  hardCording = song("Hard Cording", "0052", false, "kero"),
  newItem = song("New Item!", "0053", false, "kero"), --kind of jingle, kind of not?
  checkinOut = song("Check'IN Out", "0054", false, "kero"),
  sukima = song("SUKIMA", "0055", false, "kero"),
  relaxation = song("Relaxation", "0056", false, "kero"),
  chemistry = song("Chemistry", "0057", false, "kero"),
  --arrival = song("Arrival", "0058", false, "kero"),
  freezeDraft = song("Freeze Draft", "0059", false, "kero"),
  magicNumber = song("Magic Number", "0060", false, "kero"),
  --timeTable = song("Time Table", "0061", false, "kero"),
  --number1119 = song("Number 1119", "0061", false, "kero"),
  trainStation = song("Train Station", "0062", false, "kero"),
  --totoStation = song("ToTo Station", "0063", false, "kero"),
  kaishaMan = song("Kaisha Man", "0064", false, "kero"),
  zombeat = song("Zombeat", "0065", false, "kero"),
  --oyasumiSong = song("Oyasumi Song", "0066", false, "kero"),
  --changeSpec = song("Change Spec", "0067", false, "kero"),
  --curtainRise = song("Curtain Rise", "0068", false, "kero"),
  --creditsOfKero = song("Credits of Kero", "0069", false, "kero"),
  --myPreciousDays = song("My Precious Days", "0070", false, "kero"),
  --excuseMe = song("Excuse Me...", "0071", false, "kero"),
}

local cue = Class:extend()
function cue:new(map, events, default)
  self.map = map
  self.events = events
  self.songid = default
  self.default = default
end

local cues = {
  cue("0", {"0100"}, "0033"),
  cue("0", {"0200"}, "0001"),
  cue("Pens1", {"0090", "0091", "0092", "0093", "0094", "0099"}, "0002"),
  cue("Pens1", {"0095", "0098"}, "0014"),
  cue("Eggs", {"0090", "0091", "0092", "0093", "0094", "0095", "0099", "0503"}, "0001"),
  cue("Eggs", {"0600"}, "0004"),
  cue("EggX", {"0095"}, "0014"),
  cue("EggR", {"0090", "0091", "0092", "0093", "0094"}, "0008"),
  cue("Weed", {"0090", "0091", "0092", "0093", "0094", "0098", "0099", "0600"}, "0005"),
  cue("Santa", {"0090", "0091", "0092", "0093", "0094"}, "0002"),
  cue("Santa", {"0099"}, "0028"),
  cue("Chako", {"0090", "0091", "0092", "0093", "0094"}, "0002"),
  cue("Chako", {"0099"}, "0028"),
  cue("MazeI", {"0090", "0091", "0092", "0093", "0094", "0400", "0601"}, "0019"),
  cue("Sand", {"0090", "0091", "0092", "0093", "0094", "0099", "0210", "0601"}, "0006"),
  cue("Sand", {"0202"}, "0007"),
  cue("Mimi", {"0090", "0091", "0092", "0093", "0094", "0302"}, "0009"),
  cue("Mimi", {"0095", "0096", "0097", "0098", "0099"}, "0028"),
  cue("Cave", {"0090", "0091", "0092", "0093", "0094"}, "0008"),
  cue("Start", {"0090", "0091", "0092", "0093", "0094"}, "0008"),
  cue("Barr", {"0090", "0091", "0092", "0093", "0094", "0402", "1001"}, "0008"),
  cue("Barr", {"1000"}, "0011"),
  cue("Barr", {"1000"}, "0004"),
  cue("Pool", {"0090", "0091", "0092", "0093", "0094"}, "0009"),
  cue("Pool", {"0095", "0096", "0097", "0098", "0099", "0410"}, "0028"),
  cue("Cemet", {"0090", "0091", "0092", "0093", "0094"}, "0012"),
  cue("Plant", {"0090", "0091", "0092", "0093", "0094"}, "0013"),
  cue("Plant", {"0095", "0096", "0097", "0098", "0099"}, "0028"),
  cue("Shelt", {"0090", "0091", "0092", "0093", "0094", "0099"}, "0008"),
  cue("Comu", {"0090", "0091", "0092", "0093", "0094"}, "0009"),
  cue("Comu", {"0095", "0096", "0097", "0098", "0099"}, "0028"),
  cue("Cthu", {"0090", "0091", "0092", "0093", "0094"}, "0008"),
  cue("Malco", {"0090", "0091", "0092", "0093", "0094", "0203"}, "0008"),
  cue("Malco", {"0200", "0204"}, "0004"),
  cue("Malco", {"0200"}, "0011"),
  cue("Frog", {"0090", "0091", "0092", "0093", "0094", "1000"}, "0008"),
  cue("Frog", {"0202"}, "0011"),
  cue("Frog", {"0202"}, "0007"),
  cue("Curly", {"0090", "0091", "0092", "0093", "0094"}, "0002"),
  cue("Curly", {"0300"}, "0004"),
  cue("WeedB", {"0302"}, "0004"),
  cue("Stream", {"0090", "0091", "0092", "0093", "0094"}, "0018"),
  cue("Jenka1", {"0090", "0091", "0092", "0093", "0094"}, "0019"),
  cue("Gard", {"0502"}, "0017"),
  cue("Gard", {"0502"}, "0018"),
  cue("Gard", {"0502"}, "0004"),
  cue("Jenka2", {"0090", "0091", "0092", "0093", "0095", "0200"}, "0019"),
  cue("Jenka2", {"0094"}, "0011"),
  cue("SandE", {"0090", "0091", "0092", "0093", "0094", "0600"}, "0006"),
  cue("SandE", {"0600"}, "0011"),
  cue("MazeH", {"0090", "0091", "0092", "0093", "0094"}, "0019"),
  cue("MazeW", {"0090", "0091", "0092", "0093", "0094", "1000"}, "0037"),
  cue("MazeW", {"0302"}, "0007"),
  cue("MazeO", {"0090", "0091", "0092", "0093", "0094"}, "0002"),
  cue("MazeD", {"0400"}, "0004"),
  cue("MazeA", {"0090", "0091", "0092", "0093", "0094", "0301"}, "0008"),
  cue("MazeB", {"0090", "0091", "0092", "0093", "0094", "0099"}, "0008"),
  cue("MazeS", {"0090", "0091", "0092", "0093", "0094", "0310", "0600"}, "0008"),
  cue("MazeS", {"0321"}, "0011"),
  cue("MazeS", {"0321"}, "0004"),
  cue("MazeM", {"0090", "0091", "0092", "0093", "0094", "0301"}, "0020"),
  cue("Drain", {"0090", "0091", "0092", "0093", "0094", "0150"}, "0008"),
  cue("Drain", {"0095", "0096", "0097"}, "0023"),
  cue("Almond", {"0090", "0091", "0092", "0093", "0094", "0361"}, "0023"),
  cue("Almond", {"0452", "0500"}, "0022"),
  cue("River", {"0090", "0091", "0092", "0093", "0094", "0095"}, "0038"),
  cue("Eggs2", {"0090", "0091", "0092", "0093", "0094", "0099"}, "0027"),
  cue("Cthu2", {"0090", "0091", "0092", "0093", "0094"}, "0008"),
  cue("EggR2", {"0090", "0091", "0092", "0093", "0094", "1000"}, "0008"),
  cue("EggR2", {"0304"}, "0004"),
  cue("EggX2", {"0090", "0091", "0092", "0093", "0095"}, "0014"),
  cue("Oside", {"0090", "0091", "0092", "0093", "0094"}, "0025"),
  cue("Oside", {"0402"}, "0026"),
  cue("Itoh", {"0090", "0091", "0092", "0093", "0094", "0095"}, "0008"),
  cue("Cent", {"0090", "0091", "0092", "0093", "0094"}, "0024"),
  cue("Jail1", {"0090", "0091", "0092", "0093", "0094", "0220"}, "0008"),
  cue("Momo", {"0090", "0091", "0092", "0093", "0094", "0280", "0281"}, "0002"),
  cue("Lounge", {"0090", "0091", "0092", "0093", "0094"}, "0002"),
  cue("Jail2", {"0090", "0091", "0092", "0093", "0094", "0099"}, "0008"),
  cue("Blcny1", {"0090", "0091", "0092", "0093", "0094"}, "0030"),
  cue("Priso1", {"0090", "0091", "0092", "0093", "0094"}, "0029"),
  cue("Ring1", {"0090", "0091", "0092", "0093", "0094", "0097", "0098", "0402"}, "0030"),
  cue("Ring1", {"0502", "0503"}, "0007"),
  cue("Ring1", {"0099"}, "0018"),
  cue("Ring2", {"0090", "0091", "0092", "0093", "0094", "0098", "0420"}, "0030"),
  cue("Ring2", {"0502"}, "0007"),
  cue("Ring2", {"0410"}, "0031"),
  cue("Ring2", {"0099"}, "0018"),
  cue("Prefa1", {"0090", "0091", "0092", "0093", "0094"}, "0030"),
  cue("Priso2", {"0090", "0091", "0092", "0093", "0094", "0250"}, "0029"),
  cue("Priso2", {"0241"}, "0004"),
  cue("Ring3", {"0502"}, "0034"),
  cue("Ring3", {"0502"}, "0032"),
  cue("Ring3", {"0600"}, "0018"),
  cue("Little", {"0090", "0091", "0092", "0093", "0094"}, "0002"),
  cue("Blcny2", {"0090", "0091", "0092", "0093", "0094", "0310"}, "0018"),
  cue("Blcny2", {"0400"}, "0035"),
  cue("Pixel", {"0090", "0091", "0092", "0093", "0094", "0253"}, "0014"),
  cue("Hell1", {"0090", "0091", "0092", "0094", "0096"}, "0036"),
  cue("Hell2", {"0090", "0091", "0092", "0093", "0094"}, "0036"),
  cue("Hell3", {"0090", "0091", "0092", "0093", "0094"}, "0036"),
  cue("Hell3", {"0300"}, "0007"),
  cue("Mapi", {"0420"}, "0004"),
  cue("Statue", {"0100"}, "0024"),
  cue("Ballo1", {"0095"}, "0039"),
  cue("Ballo1", {"0500"}, "0004"),
  cue("Ballo1", {"0900"}, "0007"),
  cue("Ballo1", {"1000"}, "0032"),
  cue("Pole", {"0090", "0091", "0092", "0093", "0094", "0095"}, "0008"),
  cue("Ballo2", {"0500"}, "0034")
}

local music = Class:extend()
function music:new()
  self.vanillaEnabled = true
  self.betaEnabled = false
  self.keroEnabled = false
  self.songs = songs
  self.cues = cues
  self.flavor = "Shuffle"
end

local _isValid =  function(key, song, self, canRemap)
  if song.jingle then return false end
  if song.game == "vanilla" and (canRemap or self.vanillaEnabled) then return true end
  if song.game == "beta" and self.betaEnabled then return true end
  if song.game == "kero" and self.keroEnabled then return true end
  return false
end

function music:getShuffledSongs()
  return _.shuffle(_.filter(self.songs, _isValid, self))
end

function music:getCues()
  return self.cues
end

function music:shuffleMusic(tscFiles)
  if self.flavor == "Shuffle" then self:_shuffle(tscFiles) end
  if self.flavor == "Random" then self:_random(tscFiles) end
  if self.flavor == "Chaos" then self:_chaos(tscFiles) end
end

-- SHUFFLE songs: every cue with a given song becomes the same, new song
function music:_shuffle(tscFiles)
  local shuffled = self:getShuffledSongs()

  local idmap = _.map(self.songs, function (k,v)
    -- don't remap any invalid songs
    if not _isValid(k,v,self,true) then return v.id, v.id end
    if #shuffled == 0 then shuffled = self:getShuffledSongs() end
    return v.id, _.pop(shuffled).id
  end)

  for k,cue in pairs(self.cues) do
    cue.songid = idmap[cue.songid]
  end
  self:writeCues(tscFiles)
end

-- RANDOMIZE songs: any cue can play any song
function music:_random(tscFiles)
  for k,cue in pairs(self.cues) do
    cue.songid = self:getShuffledSongs()[1].id
  end
  self:writeCues(tscFiles)
end

-- CHAOTICALLY RANDOMIZE songs: nearly any <CMU can play any song
function music:_chaos(tscFiles)
  for k,cue in pairs(self.cues) do
    for k,event in ipairs(cue.events) do
      tscFiles[cue.map]:placeSongAtCue(self:getShuffledSongs()[1].id, event, cue.map, cue.default)
    end
  end
end

function music:writeCues(tscFiles)
  for k,cue in pairs(self.cues) do
    for k,event in ipairs(cue.events) do
      tscFiles[cue.map]:placeSongAtCue(cue.songid, event, cue.map, cue.default)
    end
  end
end

return music
