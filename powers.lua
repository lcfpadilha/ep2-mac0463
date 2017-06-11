local vector = require 'vector'
local probability
local powers = {}
local power_up_img = love.graphics.newImage('power_up.png')
local power_down_img = love.graphics.newImage('power_down.png')
local power_life_img = love.graphics.newImage('power_life.png')
powers.gravity        = 100
powers.power_radius   = 10
powers.current_powers = {}
powers.lifetime = {5, 5, 5, 5} --vida util de cada powerup
powers.deadline_powers= {-1, -1, -1, -1} -- deadline
powers.images = { power_up_img, power_down_img, power_down_img, power_up_img, power_life_img  }

function powers.update(dt, height, platform, ball)
  for i, power in pairs(powers.current_powers) do
    power.position = power.position + (dt * vector(0, powers.gravity))
    if power.position.y > height then
      table.remove(powers.current_powers, i)
    end
  end
  for j, deadline in pairs(powers.deadline_powers) do
    -- se um powerup chega ao fim
    if deadline ~= -1 and deadline < love.timer.getTime() then
      powers.disablepower(j, platform, ball)
      powers.deadline_powers[j] = -1
    end
  end
end

function powers.draw()
  for _, power in pairs(powers.current_powers) do
    powers.draw_power(power)
  end
end

function powers.set_probability(new_prob)
  probability = new_prob
end

function powers.draw_power(single_power)
  love.graphics.draw(powers.images[single_power.my_type], single_power.position.x, single_power.position.y)
end

function powers.hit_power(index, power, platform, ball, game)
  powers.enablepower(power.my_type, platform, ball, game)
  if (power.my_type ~= 5) then
    powers.deadline_powers[power.my_type] = love.timer.getTime() + powers.lifetime[power.my_type]
  end
  table.remove(powers.current_powers, index)
end

function powers.enablepower(id, platform, ball, game)
  if (id == 1) then
    platform.enablepower(id) -- platform speedup
  elseif (id == 2) then
    platform.enablepower(id) -- platform speeddown
  elseif (id == 3) then
    ball.enablepower(id)     -- ball speedup
  elseif (id == 4) then
    ball.enablepower(id)     -- ball speeddown
  else
    game.add_life()
  end
end

function powers.disablepower(id, platform, ball)
    if (id == 1) then
    platform.disablepower(id) -- platform speedup
  elseif (id == 2) then
    platform.disablepower(id) -- platform speeddown
  elseif (id == 3) then
    ball.disablepower(id)     -- ball speedup
  else
    ball.disablepower(id)     -- ball speeddown
  end
end

function powers.new_power(position_x, position_y, type)
  print(type)
  return ({ 
            position   = vector(position_x, position_y),
            radius     = powers.power_radius,
            my_type    = type
          })
end

function powers.can_create(block)
  x = math.random()
  if x <= probability then
    local new_power = powers.new_power(block.position_x, block.position_y, math.random(1,5))
    table.insert (powers.current_powers, new_power)
  end
end

return powers