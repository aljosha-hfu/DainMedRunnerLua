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
showCredits = false


-- performs initialization of all objects and data needed by program
function love.load()
    love.window.setTitle("Simple endless runner HFU")
    tileMap:setGravity(6)
    gameOver = false
    gameSpeed = 200
    tileMap:setSpeed(gameSpeed)
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
    waterSound = love.audio.newSource("audio/water.wav", "static")
    deathSound = love.audio.newSource("audio/death.wav", "static")

    font = love.graphics.newFont("graphics/pcsenior.ttf", 15)
    love.graphics.setFont(font)

end

-- called every frame, with dt passed in as delta in time since last frame
function love.update(dt)
    if -progress == tileMapWidth * 32 - windowWidth then
      tileMap = Tilemap:create()
      progress = 0
      gameSpeed = gameSpeed + 25
      tileMap:setSpeed(gameSpeed)
    end
    if gameOver == false then
        tileMap:update(dt)
    else
      runningSound:stop()
      music:stop()
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
    if gameOver and showCredits == false then
      if score > highScore then
        highScore = score
      end
        --love.graphics.draw(gameOverImage, 300, 250)
        font = love.graphics.newFont("graphics/pcsenior.ttf", 50)
        love.graphics.setFont(font)
        love.graphics.printf("GAMEOVER", 0, 250, 800, "center")
        font = love.graphics.newFont("graphics/pcsenior.ttf", 15)
        love.graphics.setFont(font)
        love.graphics.printf("Your score: " .. score, 0, 400, 800, "center")
        love.graphics.printf("Highscore: " .. highScore, 0, 420, 800, "center")
        love.graphics.printf("Press r to run again", 0, 500, 800, "center")
        font = love.graphics.newFont("graphics/pcsenior.ttf", 10)
        love.graphics.setFont(font)
        love.graphics.printf("Press c to show credits", 0, 480, 800, "center")
    else if showCredits then
        font = love.graphics.newFont("graphics/pcsenior.ttf", 50)
        love.graphics.setFont(font)
        love.graphics.printf("CREDITS", 0, 50, 800, "center")
        font = love.graphics.newFont("graphics/pcsenior.ttf", 30)
        love.graphics.setFont(font)
        love.graphics.printf("Music and sound effects:", 0, 200, 800, "center")
        love.graphics.printf("Font:", 0, 380, 800, "center")
        font = love.graphics.newFont("graphics/pcsenior.ttf", 15)
        love.graphics.setFont(font)
        love.graphics.printf("moonlight-beach by kevin macleod from filmmusic.io", 0, 240, 800, "center")
        love.graphics.printf("running in grass by EvanSki", 0, 260, 800, "center")
        love.graphics.printf("Jump to grass by 14FPanskaBubik_Lukas", 0, 280, 800, "center")
        love.graphics.printf("Water splash by nilbul", 0, 300, 800, "center")
        love.graphics.printf("Shatter by Q.K.", 0, 320, 800, "center")
        love.graphics.printf("pcsenior by zone38.net", 0, 420, 800, "center")
        love.graphics.printf("Press r to run again", 0, 500, 800, "center")
        font = love.graphics.newFont("graphics/pcsenior.ttf", 10)
        love.graphics.setFont(font)
        love.graphics.printf("a simple game by", 0, 120, 800, "center")
        love.graphics.printf("Aljosha Vieth, Leandro Knecht & Umberto Falkenhagen @ Furtwangen University", 0, 140, 800, "center")

        font = love.graphics.newFont("graphics/pcsenior.ttf", 10)
        love.graphics.setFont(font)
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
    if key == "c" then
      if gameOver then
        showCredits = true
      end
    end
    love.keyboard.keysPressed[key] = true

end

-- called whenever a key is released
function love.keyreleased(key)
    love.keyboard.keysReleased[key] = true
end
