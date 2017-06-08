local vector = require 'vector'
local powers = {}
powers.gravity      = 100
powers.power_height = 10
powers.power_width  = 10
powers.current_powers = {}

function powers.update(dt, height)
  for i, power in pairs(powers.current_powers) do
    power.position = power.position + (dt * vector(0, powers.gravity))
    if power.position.y > height then
      table.remove(powers.current_powers, i)
    end
  end
end

function powers.draw()
  for _, power in pairs(powers.current_powers) do
    powers.draw_power(power)
  end
end

function powers.draw_power(single_power)
  love.graphics.circle( "fill", 
                        single_power.position.x, 
                        single_power.position.y, 
                        single_power.width, 
                        100)
end

function powers.hit_power(index, power)
  --faça a coisa baseada no power.my_type
  print(power.my_type)
  table.remove(powers.current_powers, index)
end

function powers.new_power(position_x, position_y, type)
  return ({ 
            position   = vector(position_x, position_y),
            height     = powers.power_height,
            width      = powers.power_width,
            my_type    = type
          })
end

function powers.can_create(probability, block)
  math.randomseed(os.time())
  x = math.random()
  if x <= probability then
    -- Melhorar a escolha do type e da probability (talvez usar uma probabilidade mais baixa)
    local new_power = powers.new_power(block.position_x, block.position_y, 1)
    table.insert (powers.current_powers, new_power)
  end
end

return powers