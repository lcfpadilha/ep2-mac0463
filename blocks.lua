local blocks    = {}
local block_img = love.graphics.newImage('block_red_rectangle.png')
local scaleX, scaleY

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
  scaleX, scaleY = getImageScaleForNewDimensions(block_img, blocks.block_width, blocks.block_height)
end

function blocks.new_block(position_x, position_y, width, height)
  return ({ position_x = position_x,
            position_y = position_y,
            width = width or blocks.block_width,          
            height = height or blocks.block_height })
end

function blocks.draw_block(single_block)
  love.graphics.draw(block_img,
                     single_block.position_x,
                     single_block.position_y,
                     0,
                     scaleX,
                     scaleY)   
end

function blocks.construct_level(level_blocks_arrangement)
  blocks.no_more_blocks = false
  for row_index, row in ipairs(level_blocks_arrangement) do
    for col_index, blocktype in ipairs(row) do
      if blocktype ~= 0 then
        local new_block_position_x = blocks.top_left_position_x +
             (col_index - 1) *
             (blocks.block_width + blocks.horizontal_distance)
        local new_block_position_y = blocks.top_left_position_y +
             (row_index - 1) *
             (blocks.block_height + blocks.vertical_distance)
        local new_block = blocks.new_block( new_block_position_x,
                                              new_block_position_y)

        table.insert (blocks.current_level_blocks, new_block)
       end
    end
  end
end

function blocks.draw()
  for _, block in pairs(blocks.current_level_blocks) do
    blocks.draw_block(block)
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
end

function blocks.update_block(single_block)
end

function blocks.block_hit_by_ball(i, block, shift_ball_x, shift_ball_y)
   table.remove(blocks.current_level_blocks, i)                
end

function getImageScaleForNewDimensions(image, newWidth, newHeight)
    local currentWidth, currentHeight = image:getDimensions()
    return (newWidth / currentWidth), (newHeight / currentHeight)
end

return blocks