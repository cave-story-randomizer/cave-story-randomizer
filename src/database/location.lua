local C = Class:extend()

function C:new(name, map, event, region)
  self.name = name
  self.map = map
  self.event = event
  self.region = region
end

function C:fill(item, items)
  local old = self.item
  self:setItem(item)
  if self:canAccess(items) then return true end
  self:setItem(old)
  return false
end

function C:canAccess(items)
  if not self.region:canAccess(items) then return false end
  return self.requirements == nil or self:requirements(items)
end

function C:hasItem()
  return self.item ~= nil
end

function C:setItem(item)
  self.item = item
end

function C:writeItem(tscFiles, item)
  item = item or self.item
  if self.map == nil or self.event == nil or item.script == nil then return end
  tscFiles[self.map .. '.tsc']:placeItemAtLocation(item.script, self.event)
end

return C