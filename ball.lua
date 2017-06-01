local vector = require "vector"
local ball = {}
local sign = math.sign or function(x) return x < 0 and -1 or x > 0 and 1 or 0 end
local initial_speed_y

function ball.load(height, width)
  ball.position = vector(200, 500)
  ball.speed    = vector(0, 0)
  ball.radius  = 0.005 * width
  ball.collision_counter = 0
  ball.stuck_on_platform = true
  initial_speed_y = height / 2.5
end

function ball.update(dt, platform)
  ball.position = ball.position + ball.speed * dt
  if ball.stuck_on_platform then
    ball.follow_platform(platform)
  end
end

function ball.draw()
  love.graphics.circle( 'line',
       ball.position.x,
       ball.position.y,
       ball.radius,
       segments_in_circle )
end

function ball.follow_platform(platform)
  local x = platform.position.x + platform.width / 2
  local y = platform.position.y + platform.height / 2
  local platform_center = vector (x, y)
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
  ball.normal_rebound( shift_ball )
  ball.increase_collision_counter()
  ball.increase_speed_after_collision()
end

function ball.platform_rebound(shift_ball, platform)
  ball.bounce_from_sphere( shift_ball, platform )
  ball.increase_collision_counter()
  ball.increase_speed_after_collision()
end

function ball.wall_rebound( shift_ball )
   ball.normal_rebound( shift_ball )
   ball.min_angle_rebound()
   ball.increase_collision_counter()
   ball.increase_speed_after_collision()
end

function ball.normal_rebound(shift_ball)
  local min_shift = math.min(math.abs(shift_ball.x), math.abs(shift_ball.y))

  if math.abs(shift_ball.x) == min_shift then
    shift_ball.y = 0
  else
    shift_ball.x = 0
  end

  ball.position = ball.position + shift_ball

  if shift_ball.x ~= 0 then
    ball.speed.x = -ball.speed.x
  end

  if shift_ball.y ~= 0 then
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
  local speed_increase = 20
  local each_n_collisions = 10
  if ball.collision_counter ~= 0 and 
    ball.collision_counter % each_n_collisions == 0 then
    ball.speed = ball.speed + ball.speed:normalized() * speed_increase
  end
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

function ball.reposition()
  ball.position.x = 200
  ball.position.y = 500 
end

return ball