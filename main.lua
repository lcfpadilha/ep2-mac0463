local platform   = require 'platform'
local ball       = require 'ball'
local blocks     = require 'blocks'
local walls      = require 'walls'
local levels     = require 'levels'
local collisions = require 'collisions'
local width
local height

function love.load()
  success = love.window.setFullscreen(true)
  width, height, flags = love.window.getMode()

  platform.load(height, width)
  ball.load(height, width)
  blocks.load(height, width)
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
  if ball.position.y > height then
    ball.stuck_on_platform = true
  end
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

function love.touchpressed(id, x, y, dx, dy, pressure)
  ball.launch_from_platform()
end