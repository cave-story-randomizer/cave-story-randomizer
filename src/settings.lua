local C = Class:extend()

function C:init()
  self.settings = {}
  if lf.getInfo('settings.txt') == nil then
    self.settings = self:getDefaults()
  else
    self.settings = lf.load('settings.txt')()
    -- add any missing entries if new settings have been added
    for k,v in pairs(self:getDefaults()) do
      self.settings[k] = self.settings[k] or v
    end
  end
  -- check for out of date CS folder
  if self.settings.csversion < CSVERSION then
    self.settings.csdirectory = nil
  end
  self:update()
end

function C:getDefaults()
  return {
    csdirectory = "",
    puppy = false,
    obj = "objBestEnd",
    mychar = "assets/myChar/Quote.bmp",
    spawn = "Start Point",
    seqbreaks = false,
    dboosts = {
      cthulhu = true,
      chaco = true,
      paxChaco = true,
      flightlessHut = true,
      camp = true,
      sisters = true,
      plantation = true,
      rocket = true
    },
    musicShuffle = false,
    musicVanilla = true,
    musicBeta = false,
    musicKero = false,
    musicFlavor = "Shuffle",
    noFallingBlocks = false,
    completableLogic = false,
    csversion = 0
  }
end

function C:update()
  lf.write('settings.txt', self:serialize())
end

function C:serialize()
  local function dboosts()
    local line = "{"
    for k,v in pairs(self.settings.dboosts) do
      line = line .. ("%s = %s,"):format(k,v)
    end
    return line .. "}"
  end

  local line = "return {\r\n"
  local tab = "  "
  line = line .. tab .. ("csdirectory = %q,\r\n"):format(self.settings.csdirectory or "")
  line = line .. tab .. ("puppy = %s,\r\n"):format(self.settings.puppy)
  line = line .. tab .. ("obj = %q,\r\n"):format(self.settings.obj or "")
  line = line .. tab .. ("mychar = %q,\r\n"):format(self.settings.mychar or "")
  line = line .. tab .. ("spawn = %q,\r\n"):format(self.settings.spawn or "")
  local dboost = dboosts()
  line = line .. tab .. ("seqbreaks = %s,\r\n"):format(self.settings.seqbreaks)
  line = line .. tab .. ("dboosts = %s,\r\n"):format(dboost)
  line = line .. tab .. ("musicShuffle = %s,\r\n"):format(self.settings.musicShuffle)
  line = line .. tab .. ("musicVanilla = %s,\r\n"):format(self.settings.musicVanilla)
  line = line .. tab .. ("musicBeta = %s,\r\n"):format(self.settings.musicBeta)
  line = line .. tab .. ("musicKero = %s,\r\n"):format(self.settings.musicKero)
  line = line .. tab .. ("musicFlavor = %q,\r\n"):format(self.settings.musicFlavor)
  line = line .. tab .. ("noFallingBlocks = %s,\r\n"):format(self.settings.noFallingBlocks)
  line = line .. tab .. ("completableLogic = %s,\r\n"):format(self.settings.completableLogic)
  line = line .. tab .. ("csversion = %s,\r\n"):format(self.settings.csversion)
  
  return line .. "}"
end

function C:getSettings()
  return self.settings
end

return C