local vector     = require 'vector'
local collisions = {}

function collisions.resolve_collisions(ball, blocks, walls, platform)
  collisions.ball_platform_collision (ball, platform)
  collisions.ball_walls_collision (ball, walls)
  collisions.ball_blocks_collision (ball, blocks)
  collisions.platform_walls_collision (platform, walls)
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

  overlap, shift_ball_x, shift_ball_y = collisions.check_rectangles_overlap(a, b)

  if overlap then  
    ball.platform_rebound(vector(shift_ball_x, shift_ball_y), platform)             
  end      
end

function collisions.platform_walls_collision(platform, walls)
  local a = { x = platform.position.x,                 
              y = platform.position.y,
              width = platform.width,
              height = platform.height }

  for i, wall in pairs( walls.current_level_walls ) do
    local b = { x = wall.position_x,       
                y = wall.position_y,
                width  = wall.width,
                height = wall.height }

    overlap, shift_platform_x, shift_platform_y = collisions.check_rectangles_overlap(b, a)

    if overlap then  
      platform.rebound(shift_platform_x)              
    end  
  end  
end

function collisions.ball_walls_collision(ball, walls)
  local a = { x = ball.position.x - ball.radius,                 
              y = ball.position.y - ball.radius,
              width = 2 * ball.radius,
              height = 2 * ball.radius }

  for i, wall in pairs( walls.current_level_walls ) do
    local b = { x = wall.position_x,       
                y = wall.position_y,
                width  = wall.width,
                height = wall.height }

    overlap, shift_ball_x, shift_ball_y = collisions.check_rectangles_overlap(b, a)

    if overlap then  
      ball.wall_rebound(vector(shift_ball_x, shift_ball_y))              
    end  
  end  
end

function collisions.ball_blocks_collision(ball, blocks)
  local a = { x = ball.position.x - ball.radius,                 
              y = ball.position.y - ball.radius,
              width = 2 * ball.radius,
              height = 2 * ball.radius }

  for i, block in pairs( blocks.current_level_blocks ) do
    local b = { x = block.position_x,       
                y = block.position_y,
                width =  block.width,
                height = block.height }

    overlap, shift_ball_x, shift_ball_y = collisions.check_rectangles_overlap(a,b)

    if overlap then  
      ball.block_rebound(vector(shift_ball_x, shift_ball_y))
      blocks.block_hit_by_ball(i, brick, shift_ball_x, shift_ball_y)               
    end   
  end  
end

function collisions.check_rectangles_overlap(a, b)
   local overlap = false
   local shift_b_x, shift_b_y = 0, 0
   if not (a.x + a.width < b.x  or b.x + b.width < a.x  or a.y + a.height < b.y or b.y + b.height < a.y) then
    overlap = true
    if (a.x + a.width / 2) < (b.x + b.width / 2) then
      shift_b_x = ( a.x + a.width ) - b.x                 
    else 
      shift_b_x = a.x - (b.x + b.width)                 
    end
    if (a.y + a.height / 2) < (b.y + b.height / 2) then
      shift_b_y = (a.y + a.height) - b.y                
    else
      shift_b_y = a.y - (b.y + b.height)               
    end      
   end
   return overlap, shift_b_x, shift_b_y                     
end

return collisions