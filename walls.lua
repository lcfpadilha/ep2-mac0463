local walls = {}
local vector = require 'vector'
local wall_img = love.graphics.newImage('wall.png')

function walls.load(height, width)
  walls.wall_thickness = 0.025 * width
  walls.wall_thickness_top = 0.1 * height
  walls.right_border_x_pos = width - walls.wall_thickness
  walls.current_level_walls = {}
end

function walls.new_wall(position, width, height)
  return ({ position = position, width = width, height = height })
end

function walls.construct_walls()
  local left_wall = walls.new_wall(vector(0,0), walls.wall_thickness, love.graphics.getHeight())
  local right_wall = walls.new_wall(vector(walls.right_border_x_pos, 0), walls.wall_thickness, love.graphics.getHeight())
  local top_wall = walls.new_wall(vector(0,0), love.graphics.getWidth(), walls.wall_thickness_top)

  walls.current_level_walls["left"] = left_wall
  walls.current_level_walls["right"] = right_wall
  walls.current_level_walls["top"] = top_wall
end

function walls.draw_wall(single_wall)
  wall_img:setWrap('repeat','repeat')
  quad = love.graphics.newQuad( single_wall.position.x, 
                                single_wall.position.y, 
                                single_wall.width, 
                                single_wall.height, 
                                50, 
                                30)
  love.graphics.draw( wall_img, quad, single_wall.position.x, single_wall.position.y )
end

function walls.draw()
  for _, wall in pairs(walls.current_level_walls) do
    walls.draw_wall(wall)
  end
end

return walls