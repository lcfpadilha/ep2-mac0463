local levels = {}
local max_levels
local heart_image = love.graphics.newImage('heart.png')
function levels.load()
  levels.current_level = 1
  levels.sequence      = {}
  levels.audio_source  = {}
  levels.backgrounds   = {}
  levels.life          = 2
  create_all_levels()
end

function levels.update()
  if levels.audio_source[levels.current_level]:isPlaying() then
    love.audio.rewind(levels.audio_source[levels.current_level])
  end
end

function levels.play_audio()
  love.audio.play(levels.audio_source[levels.current_level])
end

function levels.draw_life()
  position_x = 10
  position_y = 20
  love.graphics.printf("Vidas", position_x, position_y - 3, 40, "center")
  position_x = position_x + 45
  for i = 1, levels.life, 1 do
    love.graphics.draw(heart_image,
                     position_x,
                     position_y,
                     0)  
    position_x = position_x + 10
  end
end

function levels.draw_level(width, height)
  love.graphics.printf("Level "..tostring(levels.current_level).."\nPressione quando estiver preparado!", 
      (width/2)-100, height/2, 200, "center")
end

function levels.check_life_lost(ball, height)
  if ball.position.y > height then
    ball.stuck_on_platform = true
    levels.life = levels.life - 1

    return levels.life > 0
  end
end
function create_all_levels()
  levels.sequence[1] = {
    { 1, 1, 1, 1, 1 },
    { 0, 1, 0, 1, 0 },
    { 0, 1, 0, 1, 0 },
    { 0, 0, 0, 0, 0 },
    { 0, 0, 0, 0, 0 },
    { 0, 0, 0, 0, 0 },
    { 0, 0, 0, 0, 0 }
  }
  levels.audio_source[1] = love.audio.newSource("iron-man-01.mp3", "static")

  levels.sequence[2] = {
    { 1, 1, 1, 1, 1 },
    { 1, 0, 0, 0, 1 },
    { 0, 1, 0, 1, 0 },
    { 0, 1, 0, 1, 0 },
    { 0, 1, 1, 1, 0 },
    { 0, 1, 0, 1, 0 },
    { 0, 1, 1, 1, 0 }
  }
  levels.audio_source[2] = love.audio.newSource("iron-man-01.mp3", "static")
end

return levels