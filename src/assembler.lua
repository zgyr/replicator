assembler = {}

workbench = {
  1, 2, 3,
  5, 6, 7,
  9, 10, 11
}

local fragments = {
  'redstone',
  'coal',
  'dye',
  'diamond',
  'emerald'
}

arr2a_arr(fragments)

assembler.clear = function()
  inventory.sort()
  local c = 0
  for slot = 1, 9 do
    if robot.count(workbench[slot]) == 0 then
      c = c + 1
    end
  end
  return c == 9
end

assembler.block = function()
  for i = 1, #fragments do
    assembler.clear()
    for slot = 4, i_size do
      if slot == 4 or slot == 8 or slot > 11 then
        local item = i_c.getStackInInternalSlot(slot)
        if item and item.name:gsub('%g+', '') == fragments[i] then
          robot.select(slot)
          for s = 1, 9 do
            robot.transferTo(workbench[s], 1)
          end
        end
      end
      if robot.space(11) == 0 then
        crafting.craft()
        assembler.clear()
      end
    end
    crafting.craft()
  end
end

assembler.clay_block = function()
  local mini_w = {1, 2, 5, 6}
  assembler.clear()
  for slot = 4, i_size do
    if slot == 4 or slot == 8 or slot > 11 then
      local item = i_c.getStackInInternalSlot(slot)
      if item and item.name:gsub('%g+', '') == 'clay' then
        robot.select(slot)
        for s = 1, 4 do
          robot.transferTo(mini_w[s], 1)
        end
      end
    end
  end
  crafting.craft()
end

