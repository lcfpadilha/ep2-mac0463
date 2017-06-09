local platform    = require 'platform'
local ball        = require 'ball'
local blocks      = require 'blocks'
local walls       = require 'walls'
local levels      = require 'levels'
local collisions  = require 'collisions'
local game        = require 'game'
local powers      = require 'powers'
local gamestate   = "game"
local width
local height

function love.load()
  width, height, flags = 320, 526, {}
  success = love.window.setMode(width, height, flags)
  -- width, height, flags = love.window.getMode()
  
  levels.load()
  platform.load(height, width)
  blocks.load(height, width)
  ball.load(height, width, platform, levels)
  blocks.construct_level(levels.sequence[1])  
  powers.set_probability(levels.power_up_prob[1])
  walls.load(height, width)
  game.load()
  walls.construct_walls()
  levels.play_audio()

  love.graphics.setBackgroundColor(57, 179, 198)
end
 
function love.update(dt)
  if gamestate == "menu" then
    levels.update()
  elseif gamestate == "game" then
    levels.update()
    ball.update(dt, platform)
    platform.update(dt)
    collisions.resolve_collisions(ball, blocks, walls, platform, game, powers)
    blocks.update(dt)
    powers.update(dt, height)
    if game.check_life_lost(ball, height) == false then
      gamestate = "gameover"
    end
    switch_to_next_level(blocks)
  elseif gamestate == "gamechangelevel" then
    levels.update()
  elseif gamestate == "gamepaused" then
    levels.update()
  elseif gamestate == "gamefinished" then
    levels.update()
  elseif gamestate == "gameover" then
    levels.update()
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
    powers.draw()
    game.draw_hud()
  elseif gamestate == "gamepaused" then
    platform.draw()
    ball.draw()
    blocks.draw()
    walls.draw()
    powers.draw()
    game.draw_hud()
    love.graphics.printf("Jogo pausado!", 
      (width/2)-100, height/2, 200, "center")
  elseif gamestate == "gamechangelevel" then
    platform.draw()
    ball.draw()
    blocks.draw()
    walls.draw()
    powers.draw()
    game.draw_hud()
    levels.draw_level(width, height)
  elseif gamestate == "gamefinished" then
    love.graphics.printf("Parabéns!\n" ..
           "Você finalizou o jogo! Clique para recomeçar!",
        (width/2)-100, height/2, 200, "center")
    elseif gamestate == "gameover" then
    love.graphics.printf("Você perdeu o jogo!\n" ..
           "Clique para recomeçar!",
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
    elseif key == 'menu' or key == 'return' or key == "space" then
      gamestate = "gamepaused"
    end
  elseif gamestate == "gamepaused" then
    if key == "menu" or key == 'return' then
      gamestate = "game"
    elseif key == 'escape' then
      love.event.quit()
    end
  elseif gamestate == "gamechangelevel" then
    if key == "space" then
      gamestate = "game"
      ball.load(height, width, platform, levels)
    end
  elseif gamestate == "gamefinished" or gamestate == "gameover" then
    if key == 'return' then
      game.load()
      platform.load(height, width)
      blocks.load(height, width)
      ball.load(height, width, platform, levels)
      levels.current_level = 1
      blocks.construct_level(levels.sequence[1])
      levels.load()
      gamestate = "game"
    elseif key == 'escape' then
      love.event.quit()
    end
  end
end

function love.touchpressed(id, x, y, dx, dy, pressure)
  if gamestate == "menu" then
    gamestate = "game"
  elseif gamestate == "game" then
    ball.launch_from_platform()
  elseif gamestate == "gamepaused" then
    gamestate = "game"
  elseif gamestate == "gamechangelevel" then
    gamestate = "game"
    ball.load(height, width, platform, levels)
  elseif gamestate == "gamefinished" or gamestate == "gameover" then
    width, height, flags = 320, 526, {}
    game.load()
    platform.load(height, width)
    blocks.load(height, width)
    ball.load(height, width, platform, levels)
    levels.current_level = 1
    blocks.construct_level(levels.sequence[1])
    powers.set_probability(levels.power_up_prob[1])
    levels.load()
    gamestate = "game"
  end  
  -- TODO comandos do keyrelease para android
end

-- funcao originalmente do levels.lua
function switch_to_next_level(blocks)
  if blocks.no_more_blocks then
    if levels.current_level < #levels.sequence then  
      levels.change_level()
      blocks.construct_level(levels.sequence[levels.current_level]) 
      powers.set_probability(levels.power_up_prob[levels.current_level])
      gamestate = "gamechangelevel"                                               
    else
      --levels.gamefinished = true
      gamestate = "gamefinished"                     
    end
  end
end