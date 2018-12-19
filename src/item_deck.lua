local C = Class:extend()

local ITEM_DATA = require 'database.items'

function C:new()
  self._left = {}
  for k, v in pairs(ITEM_DATA) do
    local item = _.clone(v)
    table.insert(self._left, item)
  end
end

local function _filterAny(item) return true end
local function _filterAnyExceptMissiles(item) return item.kind ~= "missiles" end
local function _filterWeapon(item) return item.kind == "weapon" end

function C:getAny()
  return self:_getItem(_filterAny)
end

function C:getAnyExceptMissiles()
  return self:_getItem(_filterAnyExceptMissiles)
end

function C:getWeapon()
  return self:_getItem(_filterWeapon)
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
  table.remove(self._left, index)

  return selected
end

return C
