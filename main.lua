local platform   = require 'platform'
local ball       = require 'ball'
local blocks     = require 'blocks'
local walls      = require 'walls'
local levels     = require 'levels'
local collisions = require 'collisions'

function love.load()
  platform.load()
  ball.load()
  blocks.load()
  walls.load()
  levels.load()
  blocks.construct_level(levels.sequence[1])  
  walls.construct_walls()
end
 
function love.update(dt)
  ball.update(dt, platform)
  platform.update(dt)
  collisions.resolve_collisions(ball, blocks, walls, platform)
  blocks.update(dt)
  levels.switch_to_next_level(blocks)
end
 
function love.draw()
  platform.draw()
  ball.draw()
  blocks.draw()
  walls.draw()
  if levels.gamefinished then
      love.graphics.printf("Congratulations!\n" ..
             "You have finished the game!",
          300, 250, 200, "center")
   end
end

function love.keyreleased(key, code)
  if key == 'space' or key == ' ' then
    ball.launch_from_platform()
  end
end

function love.quit()
  print("Thanks for playing! Come back soon!")
end