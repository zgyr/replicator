scan = {}

local quads = {
  xx = {-7, -7, 1, 1},
  zz = {-7, 1, -7, 1}
}

local q_dist = {}

local function fill_q_dist()
  for x = -33, 33 do
    for y = -33, 33 do
      for z = -32, 32 do
        local quad = x^2 + y^2 + z^2
        q_dist[quad] = sqrt(quad)
      end
    end
  end
end

local function magic(R, H, D)
  return 2112 * (R - H) / D
end

local function compare_hardness(current, target, distance)
  local result = magic(current, target, distance)
  return current ~= 0 and result > -128 and result < 127 and
         (result % 1 > 0.9998 or result % 1 < 0.0002)
end

scan.points = {x = {}, y = {}, z = {}}

scan.xz_x16 = function(min, max, y_offset)
  y_offset = y_offset or -1
  for q = 1, 4 do
    local xx, zz = quads.xx[q], quads.zz[q]
    local raw, index = geolyzer.scan(xx, zz, y_offset, 8, 8, 1), 1
    for z = zz, zz+1 do
      for x = xx, xx+1 do
        if raw[index] >= min and raw[index] <= max then
          insert(scan.points.x, position.x + x)
          insert(scan.points.y, position.y + y_offset)
          insert(scan.points.z, position.z + z)
        end
        index = index + 1
      end
    end
  end
end

scan.bedrock = function()
  if #q_dist == 0 then
    fill_q_dist()
  end
  for y = -1, -32 do
    local result = geolyzer.scan(-32, 0, y, 64, 1, 1)
    local c = 0
    for i = 1, #result do
      if compare_hardness(result[i], -1, q_dist[(i-33)^2 + y^2]) then
        c = c + 1
      end
    end
    if c > 8 then
      position.b = position.y + y
      return position.b
    end
  end
end

scan.xray = function(hardness, size)
  size = size or 32
  if #q_dist == 0 then
    fill_q_dist()
  end
  local blocks, result
  for x = -size, size do
    for z = -size, size do
      blocks = geolyzer.scan(x, z, -32, 1, 1, 32)
      for y_o = 1, 64 do
        if compare_hardness(
          blocks[y_o],
          hardness,
          q_dist[x^2 + (y_o-32)^2 + z^2]
        ) then
          insert(scan.points.x, position.x + x)
          insert(scan.points.y, position.y + y_o)
          insert(scan.points.z, position.z + z)
        end
      end
    end
  end
end

