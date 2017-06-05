local levels = {}
local max_levels

function levels.load()
  levels.current_level = 1
  levels.sequence      = {}
  levels.audio_source  = {}
  levels.backgrounds   = {}
  create_all_levels()
end

function levels.update()
  if levels.audio_source[levels.current_level]:isPlaying() == false then
    love.audio.play(levels.audio_source[levels.current_level])
  end
end

function levels.play_audio()
  love.audio.play(levels.audio_source[levels.current_level])
end

function levels.draw_level(width, height)
  love.graphics.printf("Level "..tostring(levels.current_level).."\nPressione quando estiver preparado!", 
      (width/2)-100, height/2, 200, "center")
end

function levels.change_level()
  levels.current_level = levels.current_level + 1
  love.audio.stop(levels.audio_source[levels.current_level - 1])
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