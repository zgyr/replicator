local move = {}
--[[
local update_pos = {
  [0] = function() position.y = position.y - 1 end,
  [1] = function() position.y = position.y + 1 end,
  [3] = function()
    if position.d == 0 then
      position.z = position.z + 1
    elseif position.d == 1 then
      position.x = position.x - 1
    elseif position.d == 2 then
      position.z = position.z - 1
    else
      position.x = position.x + 1
    end
  end,
}
]]
move.step = function(side)
  local result, obstacle = robot.swing(side)
  if not result and obstacle ~= 'air' and robot.detect(side) then
    -- stub
  else
    while robot.swing(side) do end
  end
  if robot.move(side) then
    counters.steps = counters.steps + 1
    -- update_pos[side]()
    if side == 0 then
      position.y = position.y - 1
    elseif side == 1 then
      position.y = position.y + 1
    elseif side == 3 then
      if position.d == 0 then
        position.z = position.z + 1
      elseif position.d == 1 then
        position.x = position.x - 1
      elseif position.d == 2 then
        position.z = position.z - 1
      else
        position.x = position.x + 1
      end
    end
    --
  end
end

move.turn = function(side)
  side = side or false
  if robot.turn(side) then
    counters.turns = counters.turns + 1
    if side then
      position.d = (position.d + 1) % 4
    else
      position.d = (position.d - 1) % 4
    end
  end
end

move.smart_turn = function(side)
  while position.d ~= side do
    move.turn((side - position.d) % 4 == 1)
  end
end

move.to = function(x, y, z, d)
  if position.b and y < position.b then
    y = position.b
  end
  while position.x ~= x and position.y ~= y and position.z ~= z do
    for i = 1, abs(position.y - y) do
      if position.y < y then
        move.step(1)
      elseif position.y > y then
        move.step(0)
      end
    end
    if position.x < x then
      move.smart_turn(3)
    elseif position.x > x then
      move.smart_turn(1)
    end
    for i = 1, abs(position.x - x) do
      move.step(3)
    end
    if position.z < z then
      move.smart_turn(0)
    elseif position.z > z then
      move.smart_turn(2)
    end
    for i = 1, abs(position.z - z) do
      move.step(3)
    end
  end
  if d then
    move.smart_turn(d)
  end
end

return move
