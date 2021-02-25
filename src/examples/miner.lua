dofile('/globals.lua')
dofile('/move.lua')
dofile('/energy.lua')
dofile('/inventory.lua')
dofile('/scan.lua')
dofile('/tool.lua')
dofile('/compass.lua')
dofile('/assembler.lua')

local function init()
  compass.load()
  network.report('init')
  if not position.d then
    compass.calibrate()
  end
  if not position.b then
    scan.bedrock()
  end
  if not i_c then
    error('inventory controller error', 0)
  elseif not geolyzer then
    error('geolyzer error', 0)
  elseif not robot.detect(0) then
    error('block error', 0)
  elseif not robot.durability() then
    error('tool error', 0)
  end
  if chunkloader then
    chunkloader.setActive(true)
  end
  if modem then
    modem.setWakeMessage('')
    modem.setStrength(400)
  end
  if tunnel then
    tunnel.setWakeMessage('')
  end
  for slot = 1, i_size do
    if robot.count(slot) == 0 then
      robot.select(slot)
      break
    end
  end
  tool.check()
  energy.calibrate()
  energy.refuel()
end

local function home()
  local l_pos = unpack(position)
  local side
  to(0, -2, 0)
  to(0, 0, 0)
  inventory.drop_tails()
  while true do
    side = inventory.get_container(26, inf)
    if side then
      break
    else
      network.report('container needed')
      sleep(10)
    end
  end
  assembler.clay_block()
  assembler.block()
  for slot = 1, i_size do
    robot.select(slot)
    local a, b = robot.drop(side)
    if not a and b == 'inventory full' then
      while not robot.drop(side) do
        report(b)
        sleep(20)
      end
    end
  end
end

local function main()

end
