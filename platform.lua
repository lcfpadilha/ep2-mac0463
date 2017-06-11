local vector         = require 'vector'
local platform       = {}
local speeddiff      = 100
local platform_image = love.graphics.newImage('platform.png')

function platform.load(height, width) 
  platform.position = vector(width / 2, 0.95*height)
  platform.speed    = vector(width / 1.5, 0)
  platform.width    = width / 5
  platform.height   = 0.02 * height
end

function platform.update(dt)
  local touches = love.touch.getTouches()

  for i, id in ipairs(touches) do
    local x, y = love.touch.getPosition(id)
    if x > platform.position.x then
      platform.position = platform.position + (platform.speed * dt)
    elseif x < platform.position.x then
      platform.position = platform.position - (platform.speed * dt)
    end
  end

  if love.keyboard.isDown("right") then
    platform.position = platform.position + (platform.speed * dt)
  end
  if love.keyboard.isDown("left") then
    platform.position = platform.position - (platform.speed * dt)
  end
end

function platform.draw()
  love.graphics.draw(platform_image,
          platform.position.x,
          platform.position.y )
end

function platform.disablepower(id)
  if (id == 1) then
    print("desativando Speedup platform ")
    platform.speed = platform.speed - platform.speed:normalized() * speeddiff
  else
    print("desativando Speeddown platform ")
    platform.speed = platform.speed + platform.speed:normalized() * speeddiff
  end
end

function platform.enablepower(id)
  if (id == 1) then
    print("ativando Speedup platform ")
    platform.speed = platform.speed + platform.speed:normalized() * speeddiff

  else
    print("ativando Speeddown platform")
    platform.speed = platform.speed - platform.speed:normalized() * speeddiff
  end
end

function platform.rebound(shift_platform)
  platform.position.x = platform.position.x + shift_platform.x
end

return platform