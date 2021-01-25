require "Tilemap"
require "Player"

highScore = 0
windowWidth = 800
gameOver = false
showCredits = false
jump = false
lastFrameDisplayed = 1
tileMap = nil



-- called at start
function love.load()
    love.window.setTitle("Simple endless runner HFU")
    love.window.setMode(windowWidth, 600, {resizable = false, vsync = false})
    love.graphics.setDefaultFilter("nearest", "nearest")
    initializeAssets()
    reset()
end

-- called every frame, with dt passed in as delta in time since last frame
function love.update(dt)
    if -progress == tilemapWidth * 32 - windowWidth then
        tileMap = Tilemap:create()
        progress = 0
        gameSpeed = gameSpeed + 25
        tileMap:setSpeed(gameSpeed)
    end

    if gameOver then
        runningSound:stop()
        music:stop()
    else
        tileMap:update(dt)
    end
end

-- called each frame, draw content to screen
function love.draw()
    if gameOver then
        if score > highScore then
            highScore = score
        end
        if showCredits then
            drawCreditsScreen()
        else
            drawGameOverScreen()
        end
    else
        move()
    end
end

-- called whenever a key is pressed
function love.keypressed(key)
    if key == "space" then
        jump = true
    end
    if key == "escape" then
        love.event.quit()
    end
    if key == "r" and gameOver then
        showCredits = false
        reset()
    end
    if key == "c" and gameOver then
        showCredits = true
    end
end

function reset()
    tileMap = Tilemap:create()
    tileMap:setGravity(6)
    gameOver = false
    gameSpeed = 200
    jump = false
    tileMap:setSpeed(gameSpeed)
    score = 0
    progress = 0
    music:play()
    runningSound:play()
    love.graphics.setFont(normalFont)
end

function initializeAssets()
    music = love.audio.newSource("audio/music.mp3", "stream")
    music:setLooping(true)
    music:setVolume(0.1)

    runningSound = love.audio.newSource("audio/running.wav", "static")
    runningSound:setLooping(true)

    jumpingSound = love.audio.newSource("audio/jump.wav", "static")
    waterSound = love.audio.newSource("audio/water.wav", "static")
    deathSound = love.audio.newSource("audio/death.wav", "static")

    normalFont = love.graphics.newFont("graphics/pcsenior.ttf", 15)
    smallFont = love.graphics.newFont("graphics/pcsenior.ttf", 10)
    titleFont = love.graphics.newFont("graphics/pcsenior.ttf", 50)
    subtitleFont = love.graphics.newFont("graphics/pcsenior.ttf", 30)
end

function move()
    love.graphics.translate(math.floor(-tileMap.camX + 0.5), math.floor(-tileMap.camY + 0.5))
    progress = math.floor(-tileMap.camX + 0.5)
    score = score + 1
    tileMap:render()
    -- print the score to different coordinate each time, so the score text
    -- moves at the same speed as map and player to look fixed
    love.graphics.print(score, 650 + math.floor(tileMap.camX + 0.5), 10)
end

function drawGameOverScreen()
    love.graphics.setFont(titleFont)
    love.graphics.printf("GAMEOVER", 0, 250, 800, "center")
    love.graphics.setFont(normalFont)
    love.graphics.printf("Your score: " .. score, 0, 400, 800, "center")
    love.graphics.printf("Highscore: " .. highScore, 0, 420, 800, "center")
    love.graphics.printf("Press r to run again", 0, 500, 800, "center")
    love.graphics.setFont(smallFont)
    love.graphics.printf("Press c to show credits", 0, 480, 800, "center")
end

function drawCreditsScreen()
    love.graphics.setFont(titleFont)
    love.graphics.printf("CREDITS", 0, 50, 800, "center")
    love.graphics.setFont(subtitleFont)
    love.graphics.printf("Music and sound effects:", 0, 200, 800, "center")
    love.graphics.printf("Font:", 0, 380, 800, "center")
    love.graphics.setFont(normalFont)
    love.graphics.printf("moonlight-beach by kevin macleod from filmmusic.io", 0, 240, 800, "center")
    love.graphics.printf("running in grass by EvanSki", 0, 260, 800, "center")
    love.graphics.printf("Jump to grass by 14FPanskaBubik_Lukas", 0, 280, 800, "center")
    love.graphics.printf("Water splash by nilbul", 0, 300, 800, "center")
    love.graphics.printf("Shatter by Q.K.", 0, 320, 800, "center")
    love.graphics.printf("pcsenior by zone38.net", 0, 420, 800, "center")
    love.graphics.printf("Press r to run again", 0, 500, 800, "center")
    love.graphics.setFont(smallFont)
    love.graphics.printf("a simple game by", 0, 120, 800, "center")
    love.graphics.printf(
        "Aljosha Vieth, Leandro Knecht & Umberto Falkenhagen @ Furtwangen University",
        0,
        140,
        800,
        "center"
    )
end
