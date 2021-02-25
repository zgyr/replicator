energy = {}

energy.calibrate = function()
  local l = computer.energy()
  local sides = {0, 1, 3}
  local isides = {1, 0, 2}
  for i = 1, #sides do
    if not robot.detect(sides[i]) then
      move.step(sides[i])
      energy.step = ceil(l - computer.energy())
      move.step(isides[i])
      return true
    end
  end
end

energy.level = function()
  return computer.energy() / computer.maxEnergy()
end

energy.refuel = function(force)
  if force then
    for address in component.list('generator') do
      for slot = 1, i_size do
        robot.select(slot)
        component.invoke(address, 'insert')
      end
    end
  else
    if generator then
      generator.insert()
    end
  end
end

