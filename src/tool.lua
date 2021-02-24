tool = {}

tool.wear = 0

tool.wear_step = 0

local durability = 0
local steps = 0

tool.check = function()
  local c_d = robot.durability()
  local c_s = (durability - c_d) / (counters.steps - steps)
  tool.wear_step = (tool.wear_step + c_s) / 2
  durability = c_d
  steps = counters.steps
  tool.wear = tool.wear_step / c_D
end

