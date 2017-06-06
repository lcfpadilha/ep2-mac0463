local walls = {}
local vector = require 'vector'
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
  local r, g, b, a = love.graphics.getColor()
  love.graphics.setColor(228, 47, 12)
  love.graphics.rectangle('fill',
                           single_wall.position.x,
                           single_wall.position.y,
                           single_wall.width,
                           single_wall.height) 
love.graphics.setColor(r, g, b, a) 
end

function walls.draw()
  for _, wall in pairs(walls.current_level_walls) do
    walls.draw_wall(wall)
  end
end

return walls