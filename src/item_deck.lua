local C = Class:extend()

local ITEM_DATA = require 'database.items'

function C:new()
  self._left = {}
  for k, v in pairs(ITEM_DATA) do
    local item = _.clone(v)
    table.insert(self._left, item)
  end
  self._placed = {}
end

local function _filterAny(item) return true end

function C:getAny()
  return self:_getItem(_filterAny)
end

function C:getAnyByAttribute(attribute)
  function _filterAnyByAttribute(item, attribute)
    for k, v in pairs(item.attributes) do
      if v == attribute then return true
    end
    return false
  end
  return self:_getItem(_filterAnyByAttribute)
end

function C:placeAny()
  return self:place(self:getAny())
end

function C:placeAnyByAttribute(attributes)
  return self:place(self:getAnyByAttribute(attributes))
end

function C:_getItem(filterFn)
  -- Filter down to only applicable items.
  local applicable = {}
  local indexMap = {}
  for index, item in ipairs(self._left) do
    if filterFn(item) then
      table.insert(applicable, item)
      indexMap[item] = index
    end
  end
  assert(#applicable >= 1, 'No applicable items!')

  -- Select an item.
  local selected = _.sample(applicable)
  local index = indexMap[selected]

  return selected, index
end

function C:place(item, index)
  table.remove(self._left, index)
  table.insert(self._placed, item)
  return item
end

function C:getPlacedItems(item)
  local placed = {table.unpack(self._placed)} -- clone the table
  if(item) then table.insert(placed, item) end
  return placed
end

return C
