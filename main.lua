function love.load()
  -- WINDOW SETUP
  love.window.setTitle("Block Buster")
  height = love.graphics.getHeight()
  width = love.graphics.getWidth()

  -- PLAYER SETUP
  player = {}
  function player.load()
    player.width = 70
    player.height = 20
    player.x = width/2 - player.width/2
    player.y = height - player.height
    player.speed = 400
    player.lives = 5
    player.points = 0
  end
  player.load()

  -- BLOCKS
  blocks = {}
  blocks.draw = {}

  -- LOAD BLOCKS
  function blocks.load()
    column = 0; row = 1
    while 5 >= row do
      block = {}
      block.width = width/10 - 5
      block.height = 20
      block.x = column * (block.width + 5)
      block.y = row * (block.height + 5)
      table.insert(blocks.draw, block)
      column = column + 1
      if column == 10 then column = 0; row = row + 1 end
    end
  end
  blocks.load()

  -- BALL
  ball = {}
  function ball.load()
    ball.radius = 5
    ball.x = width/2
    ball.y = player.y - 200
    ball.speed = 200
    ball.direction = "d"
    ball.cooldown = 200
  end
  ball.load()

  -- CHECK TOP FOR BOUNCE
  function topbounce()
    if ball.direction == "ull" then ball.direction = "dll"
    elseif ball.direction == "ul" then ball.direction = "dl"
    elseif ball.direction == "uul" then ball.direction = "ddl"
    elseif ball.direction == "u" then ball.direction = "d"
    elseif ball.direction == "uur" then ball.direction = "ddr"
    elseif ball.direction == "ur" then ball.direction = "dr"
    elseif ball.direction == "urr" then ball.direction = "drr"
    end
  end

end


------ UPDATE ------

function love.update(dt)
  if ball.cooldown > 0 then ball.cooldown = ball.cooldown - 1 end

  -- Player movement
  if love.keyboard.isDown("right") and player.x <= (width - player.width) then
    player.x = player.x + (dt * player.speed)
  elseif love.keyboard.isDown("left") and player.x >= 0 then
    player.x = player.x - (dt * player.speed)
  elseif love.keyboard.isDown("r") then
    ball.load()
  end

  -- Hitbox for player
  if ball.y >= player.y and ball.y <= height and ball.x >= player.x and
    ball.x <= (player.x + player.width) then
    if ball.x >= player.x and ball.x < (player.x + 10) then
      ball.direction = "ull"
    elseif ball.x >= (player.x + 10) and ball.x < (player.x + 20) then
      ball.direction = "ul"
    elseif ball.x >= (player.x + 20) and ball.x < (player.x + 30) then
      ball.direction = "uul"
    elseif ball.x >= (player.x + 30) and ball.x < (player.x + 40) then
      ball.direction = "u"
    elseif ball.x >= (player.x + 40) and ball.x < (player.x + 50) then
      ball.direction = "uur"
    elseif ball.x >= (player.x + 50) and ball.x < (player.x + 60) then
      ball.direction = "ur"
    elseif ball.x >= (player.x + 60) and ball.x < (player.x + 70) then
      ball.direction = "urr"
    end  
  end


  -- Hitbox for blocks
  for i,v in ipairs(blocks.draw) do
    if ball.y <= (v.y + v.height) and ball.y >= v.y then
      if ball.x <= (v.x + v.width) and ball.x >= v.x then
        topbounce()
        table.remove(blocks.draw, i)
        player.points = player.points + 1
      end
    end
  end

  -- Bounces ball off walls
  if (ball.x <= 0) or (ball.x >= width) then
    if ball.direction == "uur" then ball.direction = "uul"
    elseif ball.direction == "ur" then ball.direction = "ul"
    elseif ball.direction == "urr" then ball.direction = "ull"
    elseif ball.direction == "drr" then ball.direction = "dll"
    elseif ball.direction == "dr" then ball.direction = "dl"
    elseif ball.direction == "ddr" then ball.direction = "ddl"
    elseif ball.direction == "ddl" then ball.direction = "ddr"
    elseif ball.direction == "dl" then ball.direction = "dr"
    elseif ball.direction == "dll" then ball.direction = "drr"
    elseif ball.direction == "ull" then ball.direction = "urr"
    elseif ball.direction == "ul" then ball.direction = "ur"
    elseif ball.direction == "uul" then ball.direction = "uur"
    end
  end

  -- Bounce ball off ceiling
  if ball.y <= 0 then topbounce() end

  -- Move ball
  if ball.cooldown == 0 then
    if ball.direction == "u" then
      ball.y = ball.y - 2 * (dt * ball.speed)
    elseif ball.direction == "uur" then
      ball.y = ball.y - 2 * (dt * ball.speed)
      ball.x = ball.x + 1 * (dt * ball.speed)
    elseif ball.direction == "ur" then
      ball.y = ball.y - 2 * (dt * ball.speed)
      ball.x = ball.x + 2 * (dt * ball.speed)
    elseif ball.direction == "urr" then
      ball.y = ball.y - 1 * (dt * ball.speed)
      ball.x = ball.x + 2 * (dt * ball.speed)
    elseif ball.direction == "drr" then
      ball.y = ball.y + 1 * (dt * ball.speed)
      ball.x = ball.x + 2 * (dt * ball.speed)
    elseif ball.direction == "dr" then
      ball.y = ball.y + 2 * (dt * ball.speed)
      ball.x = ball.x + 2 * (dt * ball.speed)
    elseif ball.direction == "ddr" then
      ball.y = ball.y + 2 * (dt * ball.speed)
      ball.x = ball.x + 1 * (dt * ball.speed)
    elseif ball.direction == "d" then
      ball.y = ball.y + 2 * (dt * ball.speed)
    elseif ball.direction == "ddl" then
      ball.y = ball.y + 2 * (dt * ball.speed)
      ball.x = ball.x - 1 * (dt * ball.speed)
    elseif ball.direction == "dl" then
      ball.y = ball.y + 2 * (dt * ball.speed)
      ball.x = ball.x - 2 * (dt * ball.speed)
    elseif ball.direction == "dll" then
      ball.y = ball.y + 1 * (dt * ball.speed)
      ball.x = ball.x - 2 * (dt * ball.speed)
    elseif ball.direction == "ull" then
      ball.y = ball.y - 1 * (dt * ball.speed)
      ball.x = ball.x - 2 * (dt * ball.speed)
    elseif ball.direction == "ul" then
      ball.y = ball.y - 2 * (dt * ball.speed)
      ball.x = ball.x - 2 * (dt * ball.speed)
    elseif ball.direction == "uul" then
      ball.y = ball.y - 2 * (dt * ball.speed)
      ball.x = ball.x - 1 * (dt * ball.speed)
    end
  end

  if ball.y >= height then
    player.lives = player.lives - 1; ball.load()
  end

  if player.lives < 0 then
    love.graphics.print("GAME OVER", width/2, height/2)
    love.load()
  end

end



------ DRAW ------

function love.draw()
  -- Cooldown
  if ball.cooldown > 0 then
    love.graphics.print("Get ready!", width/2, height/2)
  end

  -- Points/Lives
  love.graphics.print("Lives: " .. player.lives, 10, height/3)
  love.graphics.print("Points: " .. player.points, 10, height/3 + 20)
  -- Draw player
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle("fill", player.x, player.y, player.width, player.height - 10)

  -- Draw blocks
  love.graphics.setColor(255, 0, 0)
  iter = 0
  for _,v in pairs(blocks.draw) do
    love.graphics.rectangle("fill", v.x, v.y, v.width, v.height)
  end

  -- Draw ball
  love.graphics.setColor(255, 255, 255)
  love.graphics.circle("fill", ball.x, ball.y, ball.radius)
end