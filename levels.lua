local levels = {}

function levels.load()
  levels.current_level = 1
  levels.sequence = {}
  levels.sequence[1] = {
    { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    { 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1 },
    { 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1 },
    { 1, 1, 1, 0, 1, 1, 0, 0, 0, 1, 0 },
    { 1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 0 },
    { 1, 0, 1, 0, 1, 1, 1, 0, 0, 1, 0 },
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
  }
end

function levels.switch_to_next_level(blocks)
  if blocks.no_more_blocks then
    if levels.current_level < #levels.sequence then  
      levels.current_level = levels.current_level + 1
      bricks.construct_level(levels.sequence[levels.current_level]) 
      ball.reposition()                                                
    else
      levels.gamefinished = true                     
    end
  end
end

return levels