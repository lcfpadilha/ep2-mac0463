local vector            = require 'vector'
local collisions        = {}
local power_probability

function collisions.resolve_collisions(ball, blocks, walls, platform, game, powers)
  collisions.ball_platform_collision (ball, platform)
  collisions.ball_walls_collision (ball, walls)
  collisions.ball_blocks_collision (ball, blocks, game, powers)
  collisions.platform_walls_collision (platform, walls)
  collisions.platform_powers_collision (platform, powers, ball, game)
end

function collisions.check_rectangles_overlap(a, b)
  local overlap = false
  
  local shift_b = vector(0, 0)
  if not(a.x + a.width  < b.x or b.x + b.width  < a.x  or 
         a.y + a.height < b.y or b.y + b.height < a.y) then
    overlap = true
    if (a.x + a.width / 2) < (b.x + b.width / 2) then
      shift_b.x = (a.x + a.width) - b.x
    else 
      shift_b.x = a.x - (b.x + b.width)
    end
    if (a.y + a.height / 2) < (b.y + b.height / 2) then
      shift_b.y = (a.y + a.height) - b.y
    else
      shift_b.y = a.y - (b.y + b.height)
    end      
  end
  return overlap, shift_b
end

function collisions.ball_platform_collision(ball, platform)
  local a = { x = platform.position.x,                 
              y = platform.position.y,
              width = platform.width,
              height = platform.height }
  local b = { x = ball.position.x - ball.radius,       
              y = ball.position.y - ball.radius,
              width = 2 * ball.radius,
              height = 2 * ball.radius }

  overlap, shift_ball = collisions.check_rectangles_overlap(a, b)

  if overlap then  
    if ball.stuck_on_platform ~= true then
      collision_sound = love.audio.newSource("button-4.wav", "stream")
      love.audio.play(collision_sound)
    end
    ball.platform_rebound(shift_ball, platform)             
  end      
end

function collisions.ball_walls_collision(ball, walls)
  local overlap, shift_ball
  local b = { x = ball.position.x - ball.radius,                 
              y = ball.position.y - ball.radius,
              width = 2 * ball.radius,
              height = 2 * ball.radius }

  for i, wall in pairs( walls.current_level_walls ) do
    local a = { x = wall.position.x,       
                y = wall.position.y,
                width  = wall.width,
                height = wall.height }

    overlap, shift_ball = collisions.check_rectangles_overlap(a, b)

    if overlap then
      ball.wall_rebound(shift_ball)
    end  
  end  
end

function collisions.platform_walls_collision(platform, walls)
  local overlap, shift_platform
  
  local b = { x = platform.position.x,                 
              y = platform.position.y,
              width = platform.width,
              height = platform.height }

  for i, wall in pairs(walls.current_level_walls) do
    local a = { x = wall.position.x,       
                y = wall.position.y,
                width  = wall.width,
                height = wall.height }

    overlap, shift_platform = collisions.check_rectangles_overlap(a, b)

    if overlap then  
      platform.rebound(shift_platform)              
    end  
  end  
end

function collisions.ball_blocks_collision(ball, blocks, game, powers)
  local b = { x = ball.position.x - ball.radius,                 
              y = ball.position.y - ball.radius,
              width = 2 * ball.radius,
              height = 2 * ball.radius }

  for i, block in pairs( blocks.current_level_blocks ) do
    local a = { x = block.position_x,       
                y = block.position_y,
                width =  block.width,
                height = block.height }

    overlap, shift_ball = collisions.check_rectangles_overlap(a,b)

    if overlap then  
      collision_sound = love.audio.newSource("button-10.wav", "stream")
      love.audio.play(collision_sound)
      ball.block_rebound(shift_ball)
      blocks.block_hit_by_ball(i, block)
      if block.life == 0 then
        game.block_destroy(block)
        powers.can_create(block)
      end
    end   
  end  
end

function collisions.platform_powers_collision(platform, powers, ball, game)
  local overlap, shift_platform
  
  local b = { x = platform.position.x,                 
              y = platform.position.y,
              width = platform.width,
              height = platform.height }

  for i, power in pairs(powers.current_powers) do
    local a = { x = power.position.x,       
                y = power.position.y,
                width  = 2 * power.radius,
                height = 2 * power.radius }

    overlap = collisions.check_rectangles_overlap(a, b)

    if overlap then  
      powers.hit_power(i, power, platform, ball, game)          
    end  
  end  
end

return collisions