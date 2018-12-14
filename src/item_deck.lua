local C = Class:extend()

local ITEM_DATA = require 'database.items'

function C:new()
  self._left = {}
  self._indexMap = {}
  for k, v in pairs(ITEM_DATA) do
    local item = _.clone(v)
    table.insert(self._left, item)
    self._indexMap[item] = #self._left
  end
end

local function _filterAny(item) return true end
local function _filterWeapon(item) return item.kind == "weapon" end

function C:getAny()
  return self:_getItem(_filterAny)
end

function C:getWeapon()
  return self:_getItem(_filterWeapon)
end

function C:_getItem(filterFn)
  -- Filter down to only applicable items.
  local applicable = {}
  for _, item in ipairs(self._left) do
    if filterFn(item) then
      table.insert(applicable, item)
    end
  end
  assert(#applicable >= 1, 'No applicable items!')

  -- Select an item.
  local selected = _.sample(applicable)
  local index = self._indexMap[selected]
  table.remove(self._left, index)
  self._indexMap[selected] = nil

  return selected
end

return C
