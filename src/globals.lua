floor, ceil, abs = math.floor, math.ceil, math.abs
insert, remove, = table.insert, table.remove

position = {
  x = 0,
  y = 0,
  z = 0,
  d = 0,
  b = nil
}

counters = {
  steps = 0,
  turns = 0
}

if require then
  component = require('component')
  computer = require('computer')
end

local function add_component(name)
  name = component.list(name)()
  if name then
    return component.proxy(name)
  end
end

robot = add_component('robot')
modem = add_component('modem')
tunnel = add_component('tunnel')
geolyzer = add_component('geolyzer')
crafting = add_component('crafting')
generator = add_component('generator')
chunkloader = add_component('chunkloader')
i_c = add_component('inventory_controller')

local clist = computer.getDeviceInfo()
for i, j in pairs(clist) do
  if j.description == 'Solar panel' then
    solar_panel = true
    break
  end
end

i_size = robot.inventorySize()