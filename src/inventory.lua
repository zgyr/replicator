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

