local game = {}
local multiplier       = 1.0
local best_score       = 0
local destroyed_blocks = 0
local heart_image      = love.graphics.newImage('heart.png')

function game.load()
    game.life           = 3
    multiplier          = 1.0
    destroyed_blocks    = 0
    game.current_points = 0
end

function game.draw_hud()
  position_x = 10
  position_y = 15
  love.graphics.printf("Vidas", position_x, position_y - 3, 40, "center")
  position_x = position_x + 45
  for i = 1, game.life, 1 do
    love.graphics.draw(heart_image,
                     position_x,
                     position_y,
                     0)  
    position_x = position_x + 10
  end

  position_x = 150
  love.graphics.printf("Pontos: "..tostring(game.current_points), position_x, position_y - 3, 200, "center")
  love.graphics.printf("x "..tostring(multiplier), position_x, position_y + 15, 200,"center")
end

function game.check_life_lost(ball, height)
  if ball.position.y > height then
    ball.stuck_on_platform = true
    game.life = game.life - 1
    multiplier = 1.0
    destroyed_blocks = 0

    if game.life == 0 then
        if best_score < game.current_points  then
            best_score = game.current_points 
        end
        return false
    end
    
    return true
  end
end

function game.block_destroy()
    game.current_points = game.current_points + 25 * multiplier
    destroyed_blocks = destroyed_blocks + 1
    if destroyed_blocks % 10 == 0 and multiplier < 4 then
        multiplier = multiplier + 1
    end
end

return game