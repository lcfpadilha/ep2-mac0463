local platform    = require 'platform'
local ball        = require 'ball'
local blocks      = require 'blocks'
local walls       = require 'walls'
local levels      = require 'levels'
local collisions  = require 'collisions'
local width
local height
local bla = ""
local gamestate = "menu"

function love.load()
  -- width, height, flags = 320, 526, {}
  -- success = love.window.setMode(width, height, flags)
  width, height, flags = love.window.getMode()
  
  platform.load(height, width)
  blocks.load(height, width)
  ball.load(height, width)
  walls.load(height, width)
  levels.load()
  blocks.construct_level(levels.sequence[1])  
  walls.construct_walls()
  levels.play_audio()
  love.graphics.setBackgroundColor(57, 179, 198)
end
 
function love.update(dt)
  if gamestate == "menu" then               -- nada para atualizar
  elseif gamestate == "game" then
    ball.update(dt, platform)
    platform.update(dt)
    collisions.resolve_collisions(ball, blocks, walls, platform)
    blocks.update(dt)
    switch_to_next_level(blocks)
    if ball.position.y > height then
      ball.stuck_on_platform = true
    end
  elseif gamestate == "gamepaused" then     -- nada para atualizar
  elseif gamestate == "gamefinished" then
  end

end
 
function love.draw()
  if gamestate == "menu" then
    love.graphics.printf("Menu. Clique para continuar.",
          (width/2)-100, height/2, 200, "center")
  elseif gamestate == "game" then
    platform.draw()
    ball.draw()
    blocks.draw()
    walls.draw()
  elseif gamestate == "gamepaused" then
    platform.draw()
    ball.draw()
    blocks.draw()
    walls.draw()
    love.graphics.printf(tostring(bla).." "..tostring(height), 
      (width/2)-100, height/2, 200, "center")
  elseif gamestate == "gamefinished" then
    love.graphics.printf("Parabéns!\n" ..
           "Você finalizou o jogo! Clique para recomeçar!",
        (width/2)-100, height/2, 200, "center")
  end

end

function love.keyreleased(key, code)    -- comandos para pc para usar de ref pra cel
  if gamestate == "menu" then
    if key == "return" then
      gamestate = "game"
    elseif key == 'escape' then
      love.event.quit()
    end
  elseif gamestate == "game" then
    if key == 'space' or key == ' ' then
      ball.launch_from_platform()
    elseif key == 'menu' or key == 'return' then
      gamestate = "gamepaused"
    end
  elseif gamestate == "gamepaused" then
    if key == "return" then
      gamestate = "game"
    elseif key == 'escape' then
      love.event.quit()
    end
  elseif gamestate == "gamefinished" then
    if key == "return" then
      levels.current_level = 1

      blocks.construct_level(levels.sequence[1])
      ball.reposition(height, width)
      levels.load()
      gamestate = "game"
    elseif key == 'escape' then
      love.event.quit()
    end
  end

end

function love.touchpressed(id, x, y, dx, dy, pressure)
  ball.launch_from_platform()
  -- TODO comandos do keyrelease para android
end

-- funcao originalmente do levels.lua
function switch_to_next_level(blocks)
  if blocks.no_more_blocks then
    if levels.current_level < #levels.sequence then  
      levels.current_level = levels.current_level + 1
      blocks.construct_level(levels.sequence[levels.current_level]) 
      ball.load(height, width)                                               
    else
      --levels.gamefinished = true
      gamestate = "gamefinished"                     
    end
  end
end