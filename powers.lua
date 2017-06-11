local vector = require 'vector'
local probability
local powers = {}
powers.gravity        = 100
powers.power_height   = 10
powers.power_width    = 10
powers.current_powers = {}
powers.lifetime = {5, 5, 5, 5} --vida util de cada powerup
powers.deadline_powers= {-1, -1, -1, -1} -- deadline

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
  love.graphics.circle( "fill", 
                        single_power.position.x, 
                        single_power.position.y, 
                        single_power.width, 
                        100)
end

function powers.hit_power(index, power, platform, ball)
  --faça a coisa baseada no power.my_type
  print(power.my_type)
  powers.enablepower(power.my_type, platform, ball)
  powers.deadline_powers[power.my_type] = love.timer.getTime() + powers.lifetime[power.my_type]
  table.remove(powers.current_powers, index)
end

function powers.enablepower(id, platform, ball)
  print("Ativando " .. id)
  if (id == 1) then
    platform.enablepower(id) -- platform speedup
  elseif (id == 2) then
    platform.enablepower(id) -- platform speeddown
  elseif (id == 3) then
    ball.enablepower(id)     -- ball speedup
  else
    ball.enablepower(id)     -- ball speeddown
  end
end

function powers.disablepower(id, platform, ball)
  print("desativando " .. id)
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
  return ({ 
            position   = vector(position_x, position_y),
            height     = powers.power_height,
            width      = powers.power_width,
            my_type    = type
          })
end

function powers.can_create(block)
  math.randomseed(os.time())
  x = math.random()
  if x <= probability then
    -- Melhorar a escolha do type e da probability (talvez usar uma probabilidade mais baixa)
    local new_power = powers.new_power(block.position_x, block.position_y, math.random(1, 4))
    table.insert (powers.current_powers, new_power)
  end
end

return powers