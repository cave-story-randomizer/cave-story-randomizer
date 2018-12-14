io.stdout:setvbuf("no")

require 'lib.strict'

Class   = require 'lib.classic'
_       = require 'lib.moses'
Serpent = require 'lib.serpent'

lf = love.filesystem

local LOG_LEVEL = 5
local function _log(level, prefix, text, ...)
  if LOG_LEVEL >= level then
    print(prefix .. text, ...)
  end
end
function logError(...)   _log(1, 'ERROR: ',   ...) end
function logWarning(...) _log(2, 'WARNING: ', ...) end
function logNotice(...)  _log(3, 'NOTICE: ',  ...) end
function logInfo(...)    _log(4, 'INFO: ',    ...) end
function logDebug(...)   _log(5, 'DEBUG: ',   ...) end

local ITEM_DATA = {
  -- Weapons
  wPolar = {
    name = "Polar Star",
    map = "Pole",
    getText = "Got the =Polar Star=!",
    command = "<AM+0002:0000",
    displayCmd = "<GIT0002",
  },
  -- Items
  iPanties = {
    name = "Curly's Panties",
    map = "CurlyS",
    -- getText = "Found =Curly's Underwear=.",
    getText = "Found =Curly's Panties=.",
    command = "<IT+0035",
    displayCmd = "<GIT1035",
  },
}

local TSC_FILES = {
  'Pole.tsc',
}

-- function love.load()
--   -- readPXM('Pole.pxm')
--   -- readTSC('Pole.tsc', 'Testing.tsc')
--   -- writeTSC('Testing.tsc')
--   -- readTSC('TestingEncoded.tsc', 'TestingDecoded.tsc')
-- end

function love.directorydropped(path)
  -- Mount
  assert(lf.mount(path, 'data'))
  local items = lf.getDirectoryItems('/data')
  local containsStage = _.contains(items, 'Stage')
  assert(containsStage)
  local dirStage = '/data/Stage'

  local tscFiles = {}
  for _, filename in ipairs(TSC_FILES) do
    local path = dirStage .. '/' .. filename
    local TscFile = require 'tsc_file'
    tscFiles[filename] = TscFile(path)

    -- decoded = stringReplace(decoded, ITEM_DATA.wPolar.command, ITEM_DATA.iPanties.command)
    -- decoded = stringReplace(decoded, ITEM_DATA.wPolar.getText, ITEM_DATA.iPanties.getText)
    -- decoded = stringReplace(decoded, ITEM_DATA.wPolar.displayCmd, ITEM_DATA.iPanties.displayCmd)
  end

  tscFiles['Pole.tsc']:writeTo('Testing.tsc')

  -- Unmount
  assert(lf.unmount(path))
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.push('quit')
  end
end

-- #0200
-- <KEY<FLJ1640:0201<FL+1640<SOU0022<CNP0200:0021:0000
-- <MSGOpened the chest.<NOD<GIT0002<AM+0002:0000<CLR
-- <CMU0010Got the =Polar Star=!<WAI0160<NOD<GIT0000<CLO<RMU
-- <MSG
-- From somewhere, a transmission...<FAO0004<NOD<TRA0018:0501:0002:0000

-- #0420
-- <KEY<DNP0420<MSG<GIT1035<IT+0035
-- Found Curly's Panties.<NOD<END
