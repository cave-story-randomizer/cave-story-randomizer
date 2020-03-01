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
    }
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

  local line = "return {\r\n  "

  line = line .. ("csdirectory = [[%s]],\r\n  "):format(self.settings.csdirectory or "")
  line = line .. ("puppy = %s,\r\n  "):format(self.settings.puppy)
  line = line .. ("obj = %q,\r\n  "):format(self.settings.obj or "")
  line = line .. ("mychar = %q,\r\n  "):format(self.settings.mychar or "")
  line = line .. ("spawn = %q,\r\n  "):format(self.settings.spawn or "")
  local dboost = dboosts()
  line = line .. ("seqbreaks = %s,\r\n  "):format(self.settings.seqbreaks)
  line = line .. ("dboosts = %s,\r\n  "):format(dboost)
  
  return line .. "\r\n}"
end

function C:getSettings()
  return self.settings
end

return C