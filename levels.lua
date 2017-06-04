local levels = {}

function levels.load()
  levels.current_level = 1
  levels.sequence      = {}
  levels.audio_source  = {}
  levels.backgrounds   = {}
  levels.sequence[1] = {
    { 1, 1, 1, 1, 1 },
    { 1, 1, 1, 1, 1 },
    { 1, 1, 1, 1, 1 },
    { 1, 1, 1, 1, 1 },
    { 1, 1, 1, 1, 1 },
    { 1, 1, 1, 1, 1 },
    { 1, 1, 1, 1, 1 }
  }
  levels.audio_source[1] = love.audio.newSource("iron-man-01.mp3", "static")
end

function levels.update()
  if levels.audio_source[levels.current_level] then
    love.audio.rewind(levels.audio_source[levels.current_level])
  end
end

function levels.play_audio()
  love.audio.play(levels.audio_source[levels.current_level])
end

return levels