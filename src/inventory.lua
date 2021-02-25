inventory = {}

local tails = {
  'cobblestone',
  'gravel',
  'dirt',
  'stained_hardened_clay',
  'sand',
  'sandstone',
  'mossy_cobblestone',
  'planks',
  'fence',
  'torch',
  'grass',
  'granite',
  'diorite',
  'andesite',
  'marble',
  'limestone',
  'stone',
  'end_stone',
  'hardened_clay',
  'nether_brick',
  'nether_brick_fence',
  'nether_brick_stairs',
  'netherrack',
  'soul_sand'
}

arr2a_arr(tails)

inventory.get_fullness = function()
  local counter = 0
  for slot = 1, i_size do
    if robot.count(slot) ~= 0 then
      counter = counter + 1
    end
  end
  return counter
end

inventory.find = function(side, name, meta)
  if not i_c then return end
  local size, item = i_size
  if side = 2 then
    size = i_c.getInventorySize(side)
  end
  for slot = 1, size do
    if side == 2 then
      item = i_c.getStackInInternalSlot(slot)
    else
      item = i_c.getStackInSlot(side, slot)
    end
    if item and item.name == name and (not meta or item.damage == meta) then
      return slot
    end
  end
end

inventory.drop_tails = function()
  if not i_c then return end
  local d_side = 0
  for i = 1, #sides do
    local _, d = robot.detect(sides[i])
    if d == 'air' or d == 'entity' then
      d_side = d
      break
    end
  end
  for slot = 1, i_size do
    local item = i_c.getStackInInternalSlot(slot)
    if item and tails[item.name:gsub('%g+:', '')] then
      robot.select(slot)
      robot.drop(d_side)
    end
  end
end

inventory.sort = function()
  for slot = i_size, 1, -1 do
    if robot.count(slot) == 0 or robot.space(slot) > 0 then
      for n_slot = 1, slot-1 do
        if robot.count(n_slot) > 0 then
          robot.select(n_slot)
          if robot.count(slot) == 0 or robot.compareTo(slot, true) then
            robot.transferTo(slot)
          end
        end
        if robot.space(slot) == 0 then
          break
        end
      end
    end
  end
  robot.select(1)
end

inventory.get_container = function(min, max)
  local sides = {1, 0, 3, 3, 3, 3}
  for side = 1, #sides do
    size = i_c.getInventorySize(sides[3])
    if size and size >= min and size <= max then
      return sides[side]
    end
    move.turn()
  end
end

inventory.get_charger = function()
  local sides = {1, 0, 3, 3, 3, 3}
  for side = 1, #sides do
    local name = i_c.getInventoryName(sides[side])
    if name == 'tile.oc.charger' or name == 'opencomputers:charger' then
      return sides[side]
    end
  end
end

