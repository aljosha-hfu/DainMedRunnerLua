Player = {}
Player.__index = Player

local jumpHeight = 700

texture = love.graphics.newImage("graphics/char_tiles.png")
currentFrame = love.graphics.newQuad(0, 32, 32, 32, texture:getDimensions())
lengthOfCurrentFrame = 1
jumpAnimation = false

function Player:create(tileMap)
    local this = {
        x = 0,
        y = 0,
        width = 32,
        height = 32,
        tileMap = tileMap,
        state = "walking",
        playerSpeed = 200,
        playerHeight = 0
    }

    -- position on top of tileMap tiles
    this.x = love.graphics.getWidth() / 2
    this.y = tileMap.tileHeight * ((tileMap.tilemapHeight - 2) / 2) - this.height


    currentFrame = getNextFrame()

    -- behavior tileMap we can call based on player state
    this.behaviors = {
        ["walking"] = function(dt)
            -- check if player should jump
            if jump then
                jumpAnimation = true
                this.playerHeight = -jumpHeight
                this.state = "jumping"
                love.audio.pause(runningSound)
                jumpingSound:play()
                jump = false
            end
            this:checkCollision()
            -- check if there's a tile directly beneath us
            if
                not this.tileMap:collides(this.tileMap:tileAt(this.x, this.y + this.height)) and
                    not this.tileMap:collides(this.tileMap:tileAt(this.x + this.width - 1, this.y + this.height))
             then
                -- if so, reset velocity and position and change state
                this.state = "jumping"
            end
        end,
        ["jumping"] = function(dt)
            -- apply tileMap's gravity before y velocity
            this.playerHeight = this.playerHeight + this.tileMap.gravity

            -- check if there's a tile directly beneath us
            if
                this.tileMap:collides(this.tileMap:tileAt(this.x, this.y + this.height)) or
                    this.tileMap:collides(this.tileMap:tileAt(this.x + this.width - 1, this.y + this.height))
             then
                -- if so, reset velocity and position and change state
                -- play running sound
                this.playerHeight = 0
                this.state = "walking"
                this.y = this.y - (this.y % this.tileMap.tileHeight)
                runningSound:play()
            end
            this:checkCollision()
        end
    }
    setmetatable(this, self)
    return this
end



function getNextFrame()
  -- all walking animation assets
  local walkingFrames = {
    love.graphics.newQuad(0, 32, 32, 32, texture:getDimensions()),
    love.graphics.newQuad(32, 32, 32, 32, texture:getDimensions()),
    love.graphics.newQuad(64, 32, 32, 32, texture:getDimensions()),
    love.graphics.newQuad(96, 32, 32, 32, texture:getDimensions()),
    love.graphics.newQuad(128, 32, 32, 32, texture:getDimensions()),
    love.graphics.newQuad(160, 32, 32, 32, texture:getDimensions()),
    love.graphics.newQuad(192, 32, 32, 32, texture:getDimensions()),
    love.graphics.newQuad(224, 32, 32, 32, texture:getDimensions()),
    love.graphics.newQuad(256, 32, 32, 32, texture:getDimensions()),
    love.graphics.newQuad(288, 32, 32, 32, texture:getDimensions()),
    love.graphics.newQuad(320, 32, 32, 32, texture:getDimensions())
  }

-- jump
  if jumpAnimation then
    -- set to -200 to display this frame longer than usual
    lengthOfCurrentFrame = -200
    lastFrameDisplayed = 12
    jumpAnimation = false
    -- return jump asset
    return love.graphics.newQuad(0, 0, 32, 32, texture:getDimensions())
  end
  if lengthOfCurrentFrame == -100 then
    -- return fall asset
    lengthOfCurrentFrame = lengthOfCurrentFrame + 1
    return love.graphics.newQuad(32, 0, 32, 32, texture:getDimensions())
  end

if lengthOfCurrentFrame == 15 then
  -- returns a new alking asset every 15 frames
  lengthOfCurrentFrame = 1
  if lastFrameDisplayed > 10 then
    lastFrameDisplayed = 1
    return walkingFrames[1]
  else
    lastFrameDisplayed = lastFrameDisplayed + 1
    return walkingFrames[lastFrameDisplayed]
  end
else
  lengthOfCurrentFrame = lengthOfCurrentFrame + 1
  return currentFrame
end

end


function Player:update(dt)
    self.behaviors[self.state](dt)
    currentFrame = getNextFrame()
    self.x = self.x + self.playerSpeed * dt
    self.y = self.y + self.playerHeight * dt
end

function Player:checkCollision()
    self.tileMap:collides(self.tileMap:tileAt(self.x + self.width, self.y))
    self.tileMap:collides(self.tileMap:tileAt(self.x + self.width, self.y + self.height - 1))
end

function Player:render()
    -- draw player in center
    love.graphics.draw(texture, currentFrame, math.floor(self.x), math.floor(self.y), 0, scaleX, 1, 0, 0)
end

function Player:setSpeed(speed)
    -- function to set the speed of the player (same as map speed)
    self.playerSpeed = speed
end
