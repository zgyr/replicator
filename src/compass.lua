compass = {}

compass.save = function()
  local payload = {position.x, position.y, position.z, position.d}
  if position.b then
    insert(payload, position.b)
  end
  for i = 1, #payload do
    if i ~= 4 then
      payload[i] = payload[i] + 0x8000
    end
    payload[i] = string.format('%x', payload[i])
  end
  eeprom.setLabel(concat(payload, ' '))
end

compass.load = function()
  local raw = eeprom.getLabel()
  local payload = {}
  for n in raw:gmatch('%x+') do
    insert(payload, tonumber(n, 16))
  end
  position.x = payload[1] - 0x8000
  position.y = payload[2] - 0x8000
  position.z = payload[3] - 0x8000
  position.d = payload[4]
  position.b = payload[5]
end

compass.calibrate = function()
  position.d = nil
  if navigation then
    local x, y, z = navigation.getPosition()
    position.x, position.y, position.z = ceil(x), ceil(y), ceil(z)
    position.d = navigation.getFacing()
  elseif geolyzer then
    local directions = {2, 1, 3, 0}
    for d = 1, #directions do
      if robot.detect(3) or robot.place(3) then
        local A = geolyzer.scan(-1, -1, 0, 3, 3, 1)
        robot.swing(3)
        local B = geolyzer.scan(-1, -1, 0, 3, 3, 1)
        for n = 2, 8, 2 do
          if ceil(B[n]) - ceil(A[n]) < 0 then
            position.d = directions[n/2]
            break
          end
        end
      else
        robot.turn(true)
      end
    end
  end
  if not position.d then
    error('compass error', 0)
  end
end

compass.greed = function()
  while #scan.points.x ~= 0 do
    local n_delta, c_delta, current = inf, inf
    local x, y, z, d = position.x, position.y, position.z, position.d
    for index = 1, #scan.points.x do
      n_delta = abs(x-scan.points.x[index]) +
                abs(y-scan.points.y[index]) +
                abs(z-scan.points.z[index]) -
                position.b + scan.points.y[index]
      if (scan.points.x[index] > x and d ~= 3) or
         (scan.points.x[index] < x and d ~= 1) or
         (scan.points.z[index] > z and d ~= 0) or
         (scan.points.z[index] < z and d ~= 2) then
        n_delta = n_delta + 1
      end
      if n_delta < c_delta then
        c_delta, current = n_delta, index
      end
    end
    if scan.points.x[current] == x and
       scan.points.y[current] == y and
       scan.points.z[current] == z then
    else
      local yc = scan.points.y[current]
      if yc > y then
        yc = yc-1
      elseif yc+1 < y then
        yc = yc+1
      end
      move.to(scan.points.x[current], yc, scan.points.x[current])
    end
  end
end

