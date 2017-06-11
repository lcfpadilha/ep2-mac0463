local levels = {}
local max_levels
local pause_sound = love.audio.newSource("pause.wav", "static")
local speed_y_values        = { 250, 300, 375, 450 }
local speed_increase_values = { 20, 30, 40, 60 }
local power_up_values       = { 0.15, 0.1, 0.05, 0.05 }
local block_probl = {
  { 0.50, 0.75, 0.90, 1.00 },
  { 0.40, 0.65, 0.85, 1.00 },
  { 0.30, 0.60, 0.80, 1.00 },
  { 0.20, 0.40, 0.70, 1.00 }
}

function levels.load()
  levels.current_level = 1
  levels.sequence      = {}
  levels.audio_source  = {}
  levels.backgrounds   = {}
  levels.power_up_prob = {}
  levels.ball_speed_y  = {}
  levels.ball_increase = {}
  create_all_levels()
end

function levels.reset()
  if levels.audio_source[levels.current_level]:isPlaying() == true then
    love.audio.stop(levels.audio_source[levels.current_level])
  end
  levels.current_level = 1
end

function levels.update()
  if levels.audio_source[levels.current_level]:isPlaying() == false then
    love.audio.play(levels.audio_source[levels.current_level])
  end
end

function levels.play_audio()
  love.audio.play(levels.audio_source[levels.current_level])
end

function levels.pause_audio()
  if levels.audio_source[levels.current_level]:isPlaying() == true then
    love.audio.pause(levels.audio_source[levels.current_level])
    love.audio.play(pause_sound)
  end
end

function levels.unpause()
  love.audio.play(pause_sound)
end

function levels.draw_level(width, height)
  love.graphics.printf("Level "..tostring(levels.current_level).."\nPressione quando estiver preparado!", 
      (width/2)-100, height/2, 200, "center")
end

function levels.change_level()
  levels.current_level = levels.current_level + 1
  love.audio.stop(levels.audio_source[levels.current_level - 1])
end

function levels.create_new_level()
  levels.current_level = levels.current_level + 1
  love.audio.stop(levels.audio_source[levels.current_level - 1])
  create_random_level(levels.current_level)
end

function create_all_levels()
  levels.sequence[1] = {
    { 1, 2, 1, 2, 1 },
    { 0, 2, 0, 2, 0 },
    { 0, 2, 2, 2, 0 },
    { 0, 0, 0, 0, 0 },
    { 0, 0, 0, 0, 0 },
    { 0, 0, 0, 0, 0 },
    { 0, 0, 0, 0, 0 }
  }
  levels.audio_source[1]  = love.audio.newSource("iron-man-01.mp3", "static")
  levels.ball_speed_y[1]  = 250
  levels.ball_increase[1] = 20
  levels.power_up_prob[1] = 0.15

  levels.sequence[2] = {
    { 3, 0, 0, 0, 3 },
    { 3, 0, 0, 0, 3 },
    { 0, 1, 2, 1, 0 },
    { 0, 1, 2, 1, 0 },
    { 0, 1, 2, 1, 0 },
    { 0, 1, 0, 1, 0 },
    { 0, 1, 1, 1, 0 }
  }
  levels.audio_source[2]  = love.audio.newSource("iron-man-01.mp3", "static")
  levels.ball_speed_y[2]  = 250
  levels.ball_increase[2] = 20
  levels.power_up_prob[2] = 0.15
end

function create_random_level(index)
  grid = {}
  
  if index < 4 then
    difficulty = 1
  elseif index < 6 then
    difficulty = 2
  elseif index < 10 then
    difficulty = 3
  else
    difficulty = 4
  end

  for i = 1, 7 do
    grid[i] = {}
    for j = 1, 5 do
      rand = math.random()
      if block_probl[difficulty][1] > rand then
        grid[i][j] = 0
      elseif block_probl[difficulty][2] > rand then
        grid[i][j] = 1
      elseif block_probl[difficulty][3] > rand then
        grid[i][j] = 2
      else
        grid[i][j] = 3
      end
    end
  end
  levels.sequence[index] = grid
  if difficulty == 4 then
    levels.audio_source[index] = love.audio.newSource("caution-path-01.mp3", "static")
  else
    levels.audio_source[index]  = love.audio.newSource("iron-man-01.mp3", "static")
  end
  levels.ball_speed_y[index]  = speed_y_values[difficulty]
  levels.ball_increase[index] = speed_increase_values[difficulty]
  levels.power_up_prob[index] = power_up_values[difficulty]
end

return levels