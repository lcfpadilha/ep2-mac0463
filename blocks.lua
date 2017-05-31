local blocks = {}

function blocks.load()
  blocks.rows = 8              
  blocks.columns = 11
  blocks.top_left_position_x = 70
  blocks.top_left_position_y = 50
  blocks.block_width = 50
  blocks.block_height = 30
  blocks.horizontal_distance = 10
  blocks.vertical_distance = 15
  blocks.current_level_blocks = {}
end

function blocks.new_block(position_x, position_y, width, height)
  return ({ position_x = position_x,
            position_y = position_y,
            width = width or blocks.block_width,          
            height = height or blocks.block_height })
end

function blocks.draw_block(single_block)
  love.graphics.rectangle('line',
                           single_block.position_x,
                           single_block.position_y,
                           single_block.width,
                           single_block.height)   
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

return blocks