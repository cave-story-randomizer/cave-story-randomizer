local C = Class:extend()

function C:new(worldGraph, name)
  self.locations = {}
  self.world = worldGraph
  self.name = name
end

function C:canAccess(items)
  return self.requirements == nil or self.requirements(items)
end

function C:getLocation(key)
  return self.locations[key]
end

function C:getLocations()
  return self.locations
end

function C:getEmptyLocations()
  return _.filter(self.locations, function(k,v) return not v:hasItem() end)
end

function C:getFilledLocations()
  return _.filter(self.locations, function(k,v) return v:hasItem() end)
end

function C:writeItems(tscFiles)
  for location in ipairs(self.locations) do location:writeItem(tscFiles) end
end

return C