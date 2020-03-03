local C = Class:extend()

function C:new(worldGraph, name, hints)
  self.locations = {}
  self.world = worldGraph
  self.name = name
  self.order = worldGraph.order
  worldGraph.order = worldGraph.order + 1
  self.hintList = hints or {}
end

function C:canAccess(items)
  if self.requirements == nil then return true end
  return self.requirements(self, items)
end

function C:getLocation(key)
  return self.locations[key]
end

function C:getLocations(filterFn)
  filterFn = filterFn or function(k,v) return true end
  return _.filter(self.locations, filterFn)
end

function C:getEmptyLocations()
  return self:getLocations(function(k,v) return not v:hasItem() end)
end

function C:getFilledLocations()
  return self:getLocations(function(k,v) return v:hasItem() end)
end

function C:writeItems(tscFiles)
  for key, location in pairs(self.locations) do location:writeItem(tscFiles) end
end

return C