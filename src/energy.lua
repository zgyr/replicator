local energy = {}

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

energy.charge = function(isAllow2Move)
  energy.refuel()
  if inventory.get_charger() then
    network.report('charging')
    sleep(30)
  elseif isAllow2Move then
    local time = os.date('*t')
    if solar and geolyzer and geolyzer.isSunVisible() and
    (time.hour > 4 and time.hour < 17) then
      while not geolyzer.canSeeSky() do
        step(1)
      end
      network.report('charging')
      while energy.level() < 0.99 and geolyzer.isSunVisible() do
        time = os.date('*t')
        if time.hour >= 5 and time.hour < 19 then
          sleep(60)
        else
          break
        end
      end
    end
  end
end

return energy
