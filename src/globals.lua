floor, ceil, abs, sqrt = math.floor, math.ceil, math.abs, math.sqrt
insert, remove, unpack, concat = table.insert, table.remove, unpack, concat
format = string.format
inf = math.huge

position = {
  x = 0,
  y = 0,
  z = 0,
  d = 0,
  b = nil
}

counters = {
  steps = 1,
  turns = 0
}

sides = {0, 3, 1}

if require then
  component = require('component')
  computer = require('computer')
end

robot = add_component('robot')
modem = add_component('modem')
tunnel = add_component('tunnel')
eeprom = add_component('eeprom')
geolyzer = add_component('geolyzer')
crafting = add_component('crafting')
generator = add_component('generator')
navigation = add_component('navigation')
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

function arr2a_arr(tbl)
  for k, v in pairs(tbl) do
    tbl[v] = true
  end
end

