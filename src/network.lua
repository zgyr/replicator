local network = {}

network.port = 1

network.report = function(message)
  message = '{x=' .. position.x ..
            ',y=' .. position.y ..
            ',z=' .. position.z ..
            ',d=' .. position.d ..
            'msg="' .. message .. '"}'
  if modem then
    modem.broadcast(network.port, message)
  end
  if tunnel then
    tunnel.send(message)
  end
  computer.beep(880, 0.1)
end

return network