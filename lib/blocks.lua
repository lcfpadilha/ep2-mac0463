local vector = require 'lib/vector'
local blocks    = {}
local scaleX, scaleY
local points_text = {}
local points_img = {}
local block_img = {}
block_img[1] = love.graphics.newImage('images/block_yellow_rectangle.png')
block_img[2] = love.graphics.newImage('images/block_red_rectangle.png')
block_img[3] = love.graphics.newImage('images/block_black_rectangle.png')
points_img[1] = love.graphics.newImage('images/25.png')
points_img[2] = love.graphics.newImage('images/50.png')
points_img[3] = love.graphics.newImage('images/75.png')
points_img[4] = love.graphics.newImage('images/100.png')

function blocks.load(height, width)
  blocks.rows = 7          
  blocks.columns = 5
  blocks.top_left_position_x = width * 0.08
  blocks.top_left_position_y = height * 0.12
  blocks.block_width = (0.97 * width) / 6
  blocks.block_height = (height/2 - 100) / 7
  blocks.horizontal_distance = 0
  blocks.vertical_distance = 0
  blocks.current_level_blocks = {}
  scaleX, scaleY = getImageScaleForNewDimensions(block_img[1], blocks.block_width, blocks.block_height)
end

function blocks.new_block(position_x, position_y, life)
  return ({ life = life,
            position_x = position_x,
            position_y = position_y,
            width =  blocks.block_width,          
            height = blocks.block_height })
end

function blocks.new_points_text(pos, deadtime, mult, v_y)
  return ({ position = pos,
            multiplier = mult,
            speed = v_y,
            deadtime = deadtime})
end

function blocks.draw_block(single_block)
  love.graphics.draw(block_img[single_block.life],
                     single_block.position_x,
                     single_block.position_y,
                     0,
                     scaleX,
                     scaleY)   
end

function blocks.construct_level(level_blocks_arrangement, level_blocks_life)
  blocks.no_more_blocks = false
  blocks.current_level_blocks = {}
  for row_index, row in ipairs(level_blocks_arrangement) do
    for col_index, blocklife in ipairs(row) do
      if blocklife ~= 0 then
        local new_block_position_x = blocks.top_left_position_x +
             (col_index - 1) *
             (blocks.block_width + blocks.horizontal_distance)
        local new_block_position_y = blocks.top_left_position_y +
             (row_index - 1) *
             (blocks.block_height + blocks.vertical_distance)
        local new_block = blocks.new_block(new_block_position_x, new_block_position_y, blocklife)
        
        table.insert (blocks.current_level_blocks, new_block)
       end
    end
  end
end

function blocks.draw()
  for _, block in pairs(blocks.current_level_blocks) do
    blocks.draw_block(block)
  end
  if #points_text > 0 then
    for i, ptext in pairs(points_text) do
      love.graphics.draw(points_img[ptext.multiplier], ptext.position.x, ptext.position.y)
    end
  end
end

function blocks.update(dt)
  if #blocks.current_level_blocks == 0 then
    blocks.no_more_blocks = true
  else
    for _, block in pairs(blocks.current_level_blocks) do
      blocks.update_block(block)
    end
  end
  if #points_text > 0 then
    for i, ptext in pairs(points_text) do
      if (ptext.deadtime < love.timer.getTime()) then
        table.remove(points_text, i)
      else
        ptext.position = ptext.position + (dt*ptext.speed)
      end
    end
  end
end

function blocks.update_block(single_block)
end

function blocks.block_hit_by_ball(i, block, multiplier)
  block.life = block.life - 1
  if block.life == 0 then
    local new_points_text = blocks.new_points_text( vector(block.position_x, block.position_y), 
                                                    love.timer.getTime() + 2, 
                                                    multiplier, 
                                                    -1*(vector(0, 100)))

    table.insert(points_text, new_points_text)
    table.remove(blocks.current_level_blocks, i)    
  end            
end

function getImageScaleForNewDimensions(image, newWidth, newHeight)
    local currentWidth, currentHeight = image:getDimensions()
    return (newWidth / currentWidth), (newHeight / currentHeight)
end

return blocks