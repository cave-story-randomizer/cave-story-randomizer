local C = Class:extend()

function C:new(name, map, event, region, hints)
  self.name = name
  self.map = map
  self.event = event
  self.region = region
  self.hintList = hints or {}
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
  if self.requirements == nil then return true end
  return self.requirements(self, items)
end

function C:hasItem()
  return self.item ~= nil
end

function C:setItem(item)
  item.placed = true
  item.location_name = self.name
  self.item = item
end

function C:writeItem(tscFiles, item)
  item = item or self.item
  if item == nil then
    logError("No item at " .. self.name)
    return
  end
  if self.map == nil or self.event == nil or item.script == nil then return end
  tscFiles[self.map]:placeItemAtLocation(item, self)
end

function C:getHint()
  return _.append(self.region.hintList, self.hintList), self.item.hints
end

function C:getPrebuiltHint()
  return nil
end

return C