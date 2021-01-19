require 'Animation'

Player = {}
Player.__index = Player

local JUMP_VELOCITY = 670

function Player:create(tileMap)
    local this = {
        x = 0,
        y = 0,
        width = 32,
        height = 32,
        -- reference to tileMap for checking tiles
        tileMap = tileMap,
        texture = love.graphics.newImage('graphics/char_tiles.png'),

        -- current animation frame
        currentFrame = nil,

        -- current animation being updated
        animation = nil,

        -- used to determine behavior and animations
        state = 'walking',

        -- x and y velocity
        dx = 200,
        dy = 0
    }

    -- position on top of tileMap tiles
    this.x = love.graphics.getWidth() /2
    this.y = tileMap.tileHeight * ((tileMap.TilemapHeight - 2) / 2) - this.height

    -- initialize all player animations
    this.animations = {
        ['walking'] = Animation:create({
            texture = this.texture,
            frames = {
                love.graphics.newQuad(0, 32, 32, 32, this.texture:getDimensions()),
                love.graphics.newQuad(32, 32, 32, 32, this.texture:getDimensions()),
                love.graphics.newQuad(64, 32, 32, 32, this.texture:getDimensions()),
                love.graphics.newQuad(96, 32, 32, 32, this.texture:getDimensions()),
                love.graphics.newQuad(128, 32, 32, 32, this.texture:getDimensions()),
                love.graphics.newQuad(160, 32, 32, 32, this.texture:getDimensions()),
                love.graphics.newQuad(192, 32, 32, 32, this.texture:getDimensions()),
                love.graphics.newQuad(224, 32, 32, 32, this.texture:getDimensions()),
                love.graphics.newQuad(256, 32, 32, 32, this.texture:getDimensions()),
                love.graphics.newQuad(288, 32, 32, 32, this.texture:getDimensions()),
                love.graphics.newQuad(320, 32, 32, 32, this.texture:getDimensions()),
            }
        }),
        ['jumping'] = Animation:create({
            texture = this.texture,
            frames = {
                love.graphics.newQuad(0, 0, 32, 32, this.texture:getDimensions()),
            },
        })
    }

    -- initialize animation and current frame we should render
    this.animation = this.animations['walking']
    this.currentFrame = this.animation:getCurrentFrame()

    -- behavior tileMap we can call based on player state
    this.behaviors = {
        ['walking'] = function(dt)
            -- keep track of input to switch movement while walking, or reset
            if love.keyboard.wasPressed('space') then
                this.dy = -JUMP_VELOCITY
                this.state = 'jumping'
                this.animation = this.animations['jumping']
                love.audio.pause(runningSound)
                jumpingSound:play()
            end

            this:checkCollision()
            -- check if there's a tile directly beneath us
            if not this.tileMap:collides(this.tileMap:tileAt(this.x, this.y + this.height)) and
                not this.tileMap:collides(this.tileMap:tileAt(this.x + this.width - 1, this.y + this.height)) then
                -- if so, reset velocity and position and change state
                this.state = 'jumping'
                this.animation = this.animations['jumping']
            end
        end,
        ['jumping'] = function(dt)
            if love.keyboard.isDown('left') then
                this.direction = 'left'
                this.dx = -WALKING_SPEED
            elseif love.keyboard.isDown('right') then
                this.direction = 'right'
                this.dx = WALKING_SPEED
            end

            -- apply tileMap's gravity before y velocity
            this.dy = this.dy + this.tileMap.gravity

            -- check if there's a tile directly beneath us
            if this.tileMap:collides(this.tileMap:tileAt(this.x, this.y + this.height)) or
                this.tileMap:collides(this.tileMap:tileAt(this.x + this.width - 1, this.y + this.height)) then
                -- if so, reset velocity and position and change state
                this.dy = 0
                this.state = 'walking'
                this.animation = this.animations['walking']
                this.y = this.y - (this.y % this.tileMap.tileHeight)
                runningSound:play()
            end
            this:checkCollision()
        end
    }

    setmetatable(this, self)
    return this
end

function Player:update(dt)
    self.behaviors[self.state](dt)
    self.animation:update(dt)
    self.currentFrame = self.animation:getCurrentFrame()
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Player:checkCollision()
  self.tileMap:collides(self.tileMap:tileAt(self.x + self.width, self.y))
      self.tileMap:collides(self.tileMap:tileAt(self.x + self.width, self.y + self.height - 1))
end


function Player:render()
    -- draw sprite with scale factor and offsets
    love.graphics.draw(self.texture, self.currentFrame, math.floor(self.x),
        math.floor(self.y), 0, scaleX, 1, 0, 0)
end

function Player:setSpeed(speed)
  self.dx = speed
end
