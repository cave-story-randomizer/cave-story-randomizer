local C = Class:extend()

function C:init()
  self.settings = {}
  if lf.getInfo('settings.txt') == nil then
    self:setDefaults()
  end
  self.settings = lf.load('settings.txt')()
end

function C:setDefaults()
  self.settings.csdirectory = nil
  self.settings.puppy = false
  self.settings.obj = "objBestEnd"
  self:update()
end

function C:update()
  lf.write('settings.txt', self:serialize())
end

function C:serialize()
  local line = "return {\r\n  "

  line = line .. ("csdirectory = [[%s]],\r\n  "):format(self.settings.csdirectory or "")
  line = line .. ("puppy = %s,\r\n  "):format(self.settings.puppy)
  line = line .. ("obj = %q,\r\n  "):format(self.settings.obj or "")
  line = line .. ("mychar = %q,\r\n  "):format(self.settings.mychar or "")
  
  line = line .. "\r\n}"
  return line
end

function C:getSettings()
  return self.settings
end

return C