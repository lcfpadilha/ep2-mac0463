local vector   = require 'vector'
local platform = {}

function platform.load() 
  platform.position = vector(500, 550)
  platform.speed    = vector(300, 0)
  platform.width    = 80
  platform.height   = 10
end

function platform.update(dt)
  if love.keyboard.isDown("right") then
    platform.position = platform.position + (platform.speed * dt)
  end
  if love.keyboard.isDown("left") then
    platform.position = platform.position - (platform.speed * dt)
  end
end

function platform.draw()
  love.graphics.rectangle( 'line',
          platform.position.x,
          platform.position.y,
          platform.width,
          platform.height )
end

function platform.rebound(shift_platform)
  local min_shift = math.min(math.abs(shift_platform.x), math.abs(shift_platform.y))

  if math.abs(shift_platform.x) == min_shift then
    shift_platform.y = 0
  else
    shift_platform.x = 0
  end

  platform.position = platform.position + shift_platform
end

return platform