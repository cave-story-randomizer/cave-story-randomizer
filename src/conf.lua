if io then
  io.stdout:setvbuf("no")
end

local seed = os.time()
math.randomseed(seed)

function love.conf(t)
  t.window = {
    title = "Cave Story Randomizer",
    -- icon = 'icon.png',
    width = 640,
    height = 480,
    resizable = false,
  }
  t.version = '11.1'
  t.console = false
  t.identity = 'CaveStoryRandomizer'
  t.accelerometerjoystick = false
  t.gammacorrect = false

  t.releases = {
    -- This is the name of the zip archive which contains your game.
    title = 'Cave Story Randomizer',
    -- This is the name of your game's executable.
    package = 'Cave Story Randomizer',
    loveVersion = '11.1',
    version = nil,
    author = 'shru',
    email = nil,
    description = nil,
    homepage = 'https://shru.itch.io/cave-story-randomizer',
    -- MacOS needs this.
    identifier = 'CaveStoryRandomizer',
    excludeFileList = {
    },
    compile = false,
    releaseDirectory = 'releases',
  }
end
