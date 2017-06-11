local vector = require "vector"
local ball = {}
local sign = math.sign or function(x) return x < 0 and -1 or x > 0 and 1 or 0 end
local initial_speed_y
local speed_increase
local speedpowerup = 10
local scaleX, scaleY
local ball_img = love.graphics.newImage('ball_gray.png')

function ball.load(height, width, platform, levels)
  ball.speed    = vector(0, 0)
  ball.radius  = width * 0.02
  ball.collision_counter = 0
  ball.stuck_on_platform = true
  ball.follow_platform(platform)
  initial_speed_y = levels.ball_speed_y[levels.current_level]
  speed_increase  = levels.ball_increase[levels.current_level]
  scaleX, scaleY = getImageScaleForNewDimensions(ball_img, 2*ball.radius, 2*ball.radius)
end

function ball.update(dt, platform)
  ball.position = ball.position + ball.speed * dt
  if ball.stuck_on_platform then
    ball.follow_platform(platform)
  end
end

function ball.draw()
  love.graphics.draw(ball_img,
       ball.position.x - ball.radius,
       ball.position.y - ball.radius,
       0,
       scaleX,
       scaleY)
end

function ball.follow_platform(platform)
  local x = platform.position.x + platform.width / 2
  local y = platform.position.y + platform.height / 2
  local platform_center = vector(x, y)
  ball.position = platform_center
end

function ball.launch_from_platform()
   if ball.stuck_on_platform then
      ball.stuck_on_platform = false
      math.randomseed(os.time())
      ball.speed = vector(math.random(-150, 150), initial_speed_y)
   end
end

function ball.block_rebound(shift_ball)
  ball.normal_rebound(shift_ball)
  ball.increase_collision_counter()
  ball.increase_speed_after_collision()
end

function ball.platform_rebound(shift_ball, platform)
  ball.bounce_from_sphere(shift_ball, platform)
  ball.increase_collision_counter()
  ball.increase_speed_after_collision()
end

function ball.wall_rebound(shift_ball)
   ball.normal_rebound(shift_ball)
   ball.min_angle_rebound()
   ball.increase_collision_counter()
   ball.increase_speed_after_collision()
end

function ball.determine_actual_shift(shift_ball)
  local actual_shift = vector(0, 0)
  local min_shift = math.min(math.abs(shift_ball.x), math.abs(shift_ball.y))  

  if math.abs(shift_ball.x) == min_shift then
    actual_shift.x = shift_ball.x
  else
    actual_shift.y = shift_ball.y
  end
  
  return actual_shift
end

function ball.normal_rebound(shift_ball)
  local actual_shift = ball.determine_actual_shift(shift_ball)

  ball.position = ball.position + actual_shift

  if actual_shift.x ~= 0 then
    ball.speed.x = -ball.speed.x
  end

  if actual_shift.y ~= 0 then
    ball.speed.y = -ball.speed.y
  end
end

function ball.bounce_from_sphere(shift_ball, platform)
  local actual_shift = ball.determine_actual_shift(shift_ball)
  ball.position = ball.position + actual_shift

  if actual_shift.x ~= 0 then
    ball.speed.x = -ball.speed.x
  end

  if actual_shift.y ~= 0 then
    local sphere_radius = 200
    local ball_center = ball.position
    local platform_center = platform.position + vector(platform.width / 2, platform.height / 2 )
    local separation = (ball_center - platform_center)
    local normal_direction = vector(separation.x / sphere_radius, -1)
    local v_norm = ball.speed:projectOn(normal_direction)
    local v_tan = ball.speed - v_norm
    local reverse_v_norm = v_norm * (-1)
    ball.speed = reverse_v_norm + v_tan
  end
end

function ball.min_angle_rebound()
  local min_horizontal_rebound_angle = math.rad(20)
  local vx, vy = ball.speed:unpack()
  local new_vx, new_vy = vx, vy
  rebound_angle = math.abs(math.atan(vy / vx))
  if rebound_angle < min_horizontal_rebound_angle then
    new_vx = sign(vx) * ball.speed:len() * math.cos(min_horizontal_rebound_angle)
    new_vy = sign( vy ) * ball.speed:len() * math.sin(min_horizontal_rebound_angle)
  end
  ball.speed = vector(new_vx, new_vy)
end

function ball.increase_collision_counter()
  ball.collision_counter = ball.collision_counter + 1
end

function ball.increase_speed_after_collision()
  local each_n_collisions = 10
  if ball.collision_counter ~= 0 and 
    ball.collision_counter % each_n_collisions == 0 then
    ball.speed = ball.speed + ball.speed:normalized() * speed_increase
  end
end

function ball.disablepower(id)
  if (id == 3) then
    print("desativando Speedup ball")
    ball.speed = ball.speed - ball.speed:normalized() * speed_increase
  else
    print("desativando Speeddown ball")
    ball.speed = ball.speed + ball.speed:normalized() * speed_increase
  end
end

function ball.enablepower(id)
  if (id == 3) then
    print("ativando Speedup ball")
    ball.speed = ball.speed + ball.speed:normalized() * speed_increase
  else
    print("ativando Speeddown ball")
    ball.speed = ball.speed - ball.speed:normalized() * speed_increase
  end
end

-- criei essa funcao pra qnd o jogo acaba e recomeca pq n achei o que vc faz qnd a bola morre
function ball.reposition(height, width)
  ball.position.x = height / 2
  ball.position.y = width - 100
end

function getImageScaleForNewDimensions(image, newWidth, newHeight)
    local currentWidth, currentHeight = image:getDimensions()
    return (newWidth / currentWidth), (newHeight / currentHeight)
end

return ball