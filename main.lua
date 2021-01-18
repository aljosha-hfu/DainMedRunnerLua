require "Tilemap"
require "Player"
tileMap = Tilemap:create()
love.keyboard.keysPressed = {}
love.keyboard.keysReleased = {}
gameOver = false


-- performs initialization of all objects and data needed by program
function love.load()
    love.window.setMode(800, 600, {resizable = false, vsync = false, minwidth = 400, minheight = 300})
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
    --love.audio.pause(runningSound)
end

-- called every frame, with dt passed in as delta in time since last frame
function love.update(dt)
    --local nextTilemap = Tilemap:create()
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
    love.graphics.setBackgroundColor( 72/255, 240/255, 179/255)
    -- love.graphics.scale(0.1, 0.1)
    if gameOver then
        love.graphics.draw(gameOverImage, 300, 250, 0, 2, 2)
    else
        love.graphics.clear(108, 140, 255, 255)
        love.graphics.translate(math.floor(-tileMap.camX + 0.5), math.floor(-tileMap.camY + 0.5))
        -- renders our map object onto the screen
        tileMap:render()
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
    love.keyboard.keysPressed[key] = true
end
-- called whenever a key is released
function love.keyreleased(key)
    love.keyboard.keysReleased[key] = true
end
