require "Tilemap"
require "Player"
tileMap = Tilemap:create()
love.keyboard.keysPressed = {}
love.keyboard.keysReleased = {}
gameOver = false
progress = 0
score = 0
windowWidth = 800
gameSpeed = 200
highScore = 0


-- performs initialization of all objects and data needed by program
function love.load()
    tileMap:setGravity(6)
    gameOver = false
    gameSpeed = 200
    score = 0
    progress = 0
    love.window.setMode(windowWidth, 600, {resizable = false, vsync = false, minwidth = 400, minheight = 300})
    -- makes upscaling look pixel-y instead of blurry
    love.graphics.setDefaultFilter("nearest", "nearest")
    gameOverImage = love.graphics.newImage("graphics/game_over.png")
    music = love.audio.newSource("audio/music.mp3", "stream")
    music:setLooping(true)
    music:setVolume(0.1)
    music:play()
    runningSound = love.audio.newSource("audio/running.wav", "static")
    runningSound:setLooping(true)
    runningSound:play()
    jumpingSound = love.audio.newSource("audio/jump.wav", "static")

    font = love.graphics.newFont("graphics/pcsenior.ttf", 15)
    love.graphics.setFont(font)

end

-- called every frame, with dt passed in as delta in time since last frame
function love.update(dt)
    if -progress == tileMapWidth * 32 - windowWidth then
      tileMap = Tilemap:create()
      progress = 0
      gameSpeed = gameSpeed + 50
      tileMap:setSpeed(gameSpeed)
    end
    if gameOver == false then
        tileMap:update(dt)
    else
      love.audio.stop()
    end
    --if math.floor(tileMap.resX) + 5 > tileMap.TilemapWidth then

    --tileMap =  nextTilemap
    --end
    -- reset all keys pressed and released this frame
    love.keyboard.keysPressed = {}
    love.keyboard.keysReleased = {}

end

-- called each frame, used to render to the screen
function love.draw()
    if gameOver then
      if score > highScore then
        highScore = score
      end
        love.graphics.draw(gameOverImage, 300, 250)
        love.graphics.print("Your score: " .. score, 300, 400)
        love.graphics.print("Highscore: " .. highScore, 300, 440)
        love.graphics.print("Press r to run again", 270, 500)
    else
        love.graphics.clear(108, 140, 255, 255)
        love.graphics.translate(math.floor(-tileMap.camX + 0.5), math.floor(-tileMap.camY + 0.5))
        -- renders our map object onto the screen
        progress = math.floor(-tileMap.camX + 0.5)
        score = score + 1
        tileMap:render()
        love.graphics.print(score, 650 +math.floor(tileMap.camX + 0.5), 10)
    end

end

function love.keyboard.wasPressed(key)
    if (love.keyboard.keysPressed[key]) then
        return true
    else
        return false
    end
end
-- global key released function
function love.keyboard.wasReleased(key)
    if (love.keyboard.keysReleased[key]) then
        return true
    else
        return false
    end
end
-- called whenever a key is pressed
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
    if key == "r" then
      if gameOver then
        tileMap = Tilemap:create()

        love.load()
      end
    end

    love.keyboard.keysPressed[key] = true
end




-- called whenever a key is released
function love.keyreleased(key)
    love.keyboard.keysReleased[key] = true
end
