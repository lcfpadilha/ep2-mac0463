local vector   = require 'vector'
local platform = {}

function platform.load(height, width) 
  platform.position = vector(width / 2, height - 50)
  platform.speed    = vector(width / 3, 0)
  platform.width    = width / 10
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
  love.graphics.rectangle( 'line',
          platform.position.x,
          platform.position.y,
          platform.width,
          platform.height )
end

function platform.rebound(shift_platform_x)
  platform.position.x = platform.position.x + shift_platform_x
end

return platform