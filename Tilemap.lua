Tilemap = {}
Tilemap.__index = Tilemap

tileMapWidth = 256

TILE_GRASS_TOP = 2
TILE_GRASS_BOTTOM = 13

TILE_GAP_TOP_LEFT = 1
TILE_GAP_TOP_RIGHT = 3
TILE_GAP_BOTTOM_LEFT = 12
TILE_GAP_BOTTOM_RIGHT = 14

TILE_GAP_WATER_TOP = 24
TILE_GAP_WATER_BOTTOM = 23

TILE_EMPTY = 78

--tiles for the first house
TILE_HOUSE1_LEFT_ROOF = 34
TILE_HOUSE1_MIDDLE_ROOF = 35
TILE_HOUSE1_RIGHT_ROOF = 36

TILE_HOUSE1_LEFT_MIDDLE = 45
TILE_HOUSE1_MIDDLE_MIDDLE = 46
TILE_HOUSE1_RIGHT_MIDDLE = 47

TILE_HOUSE1_LEFT_BOTTOM = 56
TILE_HOUSE1_MIDDLE_BOTTOM = 57
TILE_HOUSE1_RIGHT_BOTTOM = 58

--tiles for the second house
TILE_HOUSE2_LEFT_ROOF = 37
TILE_HOUSE2_MIDDLE_ROOF = 38
TILE_HOUSE2_RIGHT_ROOF = 39

TILE_HOUSE2_LEFT_MIDDLE = 48
TILE_HOUSE2_MIDDLE_MIDDLE = 49
TILE_HOUSE2_RIGHT_MIDDLE = 50

TILE_HOUSE2_LEFT_BOTTOM = 59
TILE_HOUSE2_MIDDLE_BOTTOM = 60
TILE_HOUSE2_RIGHT_BOTTOM = 61

--tiles for trees
TILE_TREE_ROOT_LEFT = 67
TILE_TREE_ROOT_RIGHT = 68
TILE_TREE_STEM_LEFT = 69
TILE_TREE_STEM_RIGHT = 70
TILE_TREE_CROWN_LEFT = 71
TILE_TREE_CROWN_RIGHT = 72

--tiles for obstacles
TILE_OBSTACLE1 = 25
TILE_OBSTACLE2 = 26
TILE_OBSTACLE3 = 27
TILE_PLATFORM_LEFT = 6
TILE_PLATFORM_MIDDLE = 7
TILE_PLATFORM_RIGHT = 8
TILE_PLATFORM_SINGLE = 9

-- inital map speed (changed by main.lua in case new map is generated)
local moveSpeed = 200

function Tilemap:create()
    local this = {
        spritesheet = love.graphics.newImage("graphics/tiles.png"),
        tileWidth = 32,
        tileHeight = 32,
        TilemapWidth = tileMapWidth,
        TilemapHeight = 32,
        tiles = {},
        gravity = 6,
        camX = 0,
        camY = 0,
        progress = 0
    }

    -- create a player
    this.player = Player:create(this)

    -- generate a quad (individual frame/sprite) for each tile
    this.tileSprites = generateQuads(this.spritesheet, this.tileWidth, this.tileHeight)

    --access to class functions
    setmetatable(this, self)

    -- first, fill Tilemap with empty tiles
    for y = 1, this.TilemapHeight do
        for x = 1, this.TilemapWidth do
            this:setTile(x, y, TILE_EMPTY)
        end
    end

    -- fill line at half of tilemapheight with grass
    for x = 1, this.TilemapWidth do
        this:setTile(x, this.TilemapHeight / 2, TILE_GRASS_TOP)
    end

    --fill anything below that line with dirt
    for y = this.TilemapHeight / 2 + 1, this.TilemapHeight do
        for x = 1, this.TilemapWidth do
            this:setTile(x, y, TILE_GRASS_BOTTOM)
        end
    end

    local x = 25 -- 25 * 32 = 800 = screen width (generate no obstacles or background structures in the first and last screen)
    local gap = true
    local gappercentage = love.math.random(2, 10)
    obstaclepercentage = love.math.random(2, 10)

    while x < this.TilemapWidth do
        if x < this.TilemapWidth - 30 then
            --spawning gaps
            if love.math.random(100 / gappercentage) == 1 and gap == true then
                this:setTile(x, this.TilemapHeight / 2, TILE_EMPTY)
                this:setTile(x + 1, this.TilemapHeight / 2, TILE_EMPTY)
                this:setTile(x + 2, this.TilemapHeight / 2, TILE_EMPTY)
                this:setTile(x - 1, this.TilemapHeight / 2, TILE_GAP_TOP_RIGHT)
                this:setTile(x + 3, this.TilemapHeight / 2, TILE_GAP_TOP_LEFT)
                for y = this.TilemapHeight / 2, this.TilemapHeight do
                    if y == this.TilemapHeight / 2 + 1 then
                        this:setTile(x, y, TILE_GAP_WATER_TOP)
                        this:setTile(x + 1, y, TILE_GAP_WATER_TOP)
                        this:setTile(x + 2, y, TILE_GAP_WATER_TOP)
                        this:setTile(x - 1, y, TILE_GAP_BOTTOM_RIGHT)
                        this:setTile(x + 3, y, TILE_GAP_BOTTOM_LEFT)
                    end
                    if y > this.TilemapHeight / 2 + 1 then
                        this:setTile(x, y, TILE_GAP_WATER_BOTTOM)
                        this:setTile(x + 1, y, TILE_GAP_WATER_BOTTOM)
                        this:setTile(x + 2, y, TILE_GAP_WATER_BOTTOM)
                        this:setTile(x - 1, y, TILE_GAP_BOTTOM_RIGHT)
                        this:setTile(x + 3, y, TILE_GAP_BOTTOM_LEFT)
                    end
                end
                x = x + 6
                gap = false
            else
                gap = true
                x = x + 2
            end

            --spawning  different obstacles
            if love.math.random(100 / obstaclepercentage) == 1 then
                local obstaclecounter = 1
                this:setTile(x, this.TilemapHeight / 2 - 1, TILE_OBSTACLE1)
                this:setTile(x + 1, this.TilemapHeight / 2 - 1, TILE_OBSTACLE2)
                this:setTile(x + 2, this.TilemapHeight / 2 - 1, TILE_OBSTACLE1)
                this:setTile(x + 1, this.TilemapHeight / 2 - love.math.random(3, 4), TILE_PLATFORM_SINGLE)
                x = x + 8
            end

            if love.math.random(100 / obstaclepercentage) == 1 then
                this:setTile(x, this.TilemapHeight / 2 - 1, TILE_OBSTACLE1)
                this:setTile(x + 1, this.TilemapHeight / 2 - 1, TILE_OBSTACLE2)
                this:setTile(x + 2, this.TilemapHeight / 2 - 1, TILE_OBSTACLE2)
                this:setTile(x + 3, this.TilemapHeight / 2 - 1, TILE_OBSTACLE1)
                local randomheight = love.math.random(3, 4)
                this:setTile(x + 1, this.TilemapHeight / 2 - randomheight, TILE_PLATFORM_LEFT)
                this:setTile(x + 2, this.TilemapHeight / 2 - randomheight, TILE_PLATFORM_RIGHT)
                x = x + 9
            end

            if love.math.random(100 / obstaclepercentage) == 1 then
                this:setTile(x, this.TilemapHeight / 2 - 1, TILE_OBSTACLE1)
                this:setTile(x + 1, this.TilemapHeight / 2 - 1, TILE_OBSTACLE2)
                this:setTile(x + 2, this.TilemapHeight / 2 - 1, TILE_OBSTACLE2)
                this:setTile(x + 3, this.TilemapHeight / 2 - 1, TILE_OBSTACLE2)
                this:setTile(x + 4, this.TilemapHeight / 2 - 1, TILE_OBSTACLE1)
                local randomheight = love.math.random(3, 5)
                this:setTile(x + 1, this.TilemapHeight / 2 - randomheight, TILE_PLATFORM_LEFT)
                this:setTile(x + 2, this.TilemapHeight / 2 - randomheight, TILE_PLATFORM_MIDDLE)
                this:setTile(x + 3, this.TilemapHeight / 2 - randomheight, TILE_PLATFORM_RIGHT)
                x = x + 10
            end

            if love.math.random(100 / obstaclepercentage) == 1 then
                this:setTile(x, this.TilemapHeight / 2 - 1, TILE_OBSTACLE1)
                this:setTile(x + 1, this.TilemapHeight / 2 - 1, TILE_OBSTACLE2)
                this:setTile(x + 2, this.TilemapHeight / 2 - 1, TILE_OBSTACLE2)
                this:setTile(x + 3, this.TilemapHeight / 2 - 1, TILE_OBSTACLE2)
                local randomheight = love.math.random(3, 5)
                this:setTile(x + 1, this.TilemapHeight / 2 - randomheight, TILE_PLATFORM_LEFT)
                this:setTile(x + 2, this.TilemapHeight / 2 - randomheight, TILE_PLATFORM_RIGHT)

                this:setTile(x + 4, this.TilemapHeight / 2 - 1, TILE_OBSTACLE2)
                this:setTile(x + 5, this.TilemapHeight / 2 - 1, TILE_OBSTACLE2)
                this:setTile(x + 6, this.TilemapHeight / 2 - 1, TILE_OBSTACLE2)
                this:setTile(x + 7, this.TilemapHeight / 2 - 1, TILE_OBSTACLE2)
                this:setTile(x + 8, this.TilemapHeight / 2 - 1, TILE_OBSTACLE1)
                randomheight = love.math.random(3, 6)
                this:setTile(x + 6, this.TilemapHeight / 2 - randomheight, TILE_PLATFORM_LEFT)
                this:setTile(x + 7, this.TilemapHeight / 2 - randomheight, TILE_PLATFORM_RIGHT)
                x = x + 14
            end

            if love.math.random(100 / obstaclepercentage) == 1 then
                this:setTile(x, this.TilemapHeight / 2 - 1, TILE_OBSTACLE3)
                x = x + 2
            end

            --spawning trees
            if love.math.random(5) == 1 then
                local treeStart = math.random(8, this.TilemapHeight / 2 - 2)
                this:setTile(x, treeStart, TILE_TREE_CROWN_LEFT)
                this:setTile(x + 1, treeStart, TILE_TREE_CROWN_RIGHT)

                this:setTile(x, this.TilemapHeight / 2 - 1, TILE_TREE_ROOT_LEFT)
                this:setTile(x + 1, this.TilemapHeight / 2 - 1, TILE_TREE_ROOT_RIGHT)

                for i = treeStart + 1, this.TilemapHeight / 2 - 2 do
                    this:setTile(x, i, TILE_TREE_STEM_LEFT)
                    this:setTile(x + 1, i, TILE_TREE_STEM_RIGHT)
                end
                x = x + 2
            end

            --spawning varieties of houses
            if love.math.random(5) == 1 then
                local houseStart = math.random(3, this.TilemapHeight / 2 - 3)
                if love.math.random(2) == 1 then
                    this:setTile(x, houseStart, TILE_HOUSE1_LEFT_ROOF)
                    this:setTile(x + 1, houseStart, TILE_HOUSE1_MIDDLE_ROOF)
                    this:setTile(x + 2, houseStart, TILE_HOUSE1_RIGHT_ROOF)
                else
                    this:setTile(x, houseStart, TILE_HOUSE2_LEFT_ROOF)
                    this:setTile(x + 1, houseStart, TILE_HOUSE2_MIDDLE_ROOF)
                    this:setTile(x + 2, houseStart, TILE_HOUSE2_RIGHT_ROOF)
                end

                if love.math.random(2) == 1 then
                    this:setTile(x, this.TilemapHeight / 2 - 1, TILE_HOUSE1_LEFT_BOTTOM)
                else
                    this:setTile(x, this.TilemapHeight / 2 - 1, TILE_HOUSE2_LEFT_BOTTOM)
                end

                if love.math.random(2) == 1 then
                    this:setTile(x + 1, this.TilemapHeight / 2 - 1, TILE_HOUSE1_MIDDLE_BOTTOM)
                else
                    this:setTile(x + 1, this.TilemapHeight / 2 - 1, TILE_HOUSE2_MIDDLE_BOTTOM)
                end

                if love.math.random(2) == 1 then
                    this:setTile(x + 2, this.TilemapHeight / 2 - 1, TILE_HOUSE1_RIGHT_BOTTOM)
                else
                    this:setTile(x + 2, this.TilemapHeight / 2 - 1, TILE_HOUSE2_RIGHT_BOTTOM)
                end

                for i = houseStart + 1, this.TilemapHeight / 2 - 2 do
                    if love.math.random(2) == 1 then
                        this:setTile(x, i, TILE_HOUSE1_LEFT_MIDDLE)
                    else
                        this:setTile(x, i, TILE_HOUSE2_LEFT_MIDDLE)
                    end

                    if love.math.random(2) == 1 then
                        this:setTile(x + 1, i, TILE_HOUSE1_MIDDLE_MIDDLE)
                    else
                        this:setTile(x + 1, i, TILE_HOUSE2_MIDDLE_MIDDLE)
                    end

                    if love.math.random(2) == 1 then
                        this:setTile(x + 2, i, TILE_HOUSE1_RIGHT_MIDDLE)
                    else
                        this:setTile(x + 2, i, TILE_HOUSE2_RIGHT_MIDDLE)
                    end
                end
                x = x + 4
            end
        end
        x = x + 1
    end

    return this
end

-- returns an integer value for the tile at a given x-y coordinate
function Tilemap:getTile(x, y)
    return self.tiles[(y - 1) * self.TilemapWidth + x]
end

-- sets a tile at a given x-y coordinate
function Tilemap:setTile(x, y, tile)
    self.tiles[(y - 1) * self.TilemapWidth + x] = tile
end

-- renders Tilemap to screen
function Tilemap:render()
    for y = 1, self.TilemapHeight do
        for x = 1, self.TilemapWidth do
            love.graphics.draw(
                self.spritesheet,
                self.tileSprites[self:getTile(x, y)],
                (x - 1) * self.tileWidth,
                (y - 1) * self.tileHeight
            )
        end
    end
    self.player:render()
end

-- takes a texture, width, and height of tiles and splits it into quads
-- that can be individually drawn
function generateQuads(atlas, tilewidth, tileheight)
    local sheetWidth = atlas:getWidth() / tilewidth
    local sheetHeight = atlas:getHeight() / tileheight

    local sheetCounter = 1
    local quads = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            -- this quad represents a square cutout of our atlas that we can
            -- individually draw instead of the whole atlas
            quads[sheetCounter] =
                love.graphics.newQuad(x * tilewidth, y * tileheight, tilewidth, tileheight, atlas:getDimensions())
            sheetCounter = sheetCounter + 1
        end
    end

    return quads
end

-- gets the tile type at a given pixel coordinate
function Tilemap:tileAt(x, y)
    return self:getTile(math.floor(x / self.tileWidth) + 1, math.floor(y / self.tileHeight) + 1)
end

function Tilemap:update(dt)
    self.player:update(dt)
    self.camX = self.camX + dt * moveSpeed
    self.progress = self.progress + moveSpeed
    progress = self.progress
end

-- check if specific tile is colidable
function Tilemap:collides(tile)
    -- water tiles (end the game, play water sound)
    if tile == TILE_GAP_WATER_TOP or tile == TILE_GAP_WATER_BOTTOM then
        waterSound:play()
        gameOver = true
        return true
    end

    -- obstacle tiles (end the game, play death sound)
    local obstacles = {
        TILE_OBSTACLE1,
        TILE_OBSTACLE2,
        TILE_OBSTACLE3
    }

    -- all objects we can "walk" on
    local collidables = {
        TILE_GRASS_TOP,
        TILE_GAP_TOP_LEFT,
        TILE_GAP_TOP_RIGHT,
        TILE_PLATFORM_LEFT,
        TILE_PLATFORM_MIDDLE,
        TILE_PLATFORM_RIGHT,
        TILE_PLATFORM_SINGLE,
        TILE_OBSTACLE1,
        TILE_OBSTACLE2,
        TILE_OBSTACLE3,
        TILE_GAP_BOTTOM_LEFT,
        TILE_GAP_BOTTOM_RIGHT
    }

    -- game over when hitting obstacle
    for _, v in ipairs(obstacles) do
        if tile == v then
            deathSound:play()
            gameOver = true
            return true
        end
    end

    -- we can walk
    for _, v in ipairs(collidables) do
        if tile == v then
            return true
        end
    end

    return false
end

-- sets the speed of map AND player
function Tilemap:setSpeed(speed)
    self.player:setSpeed(speed)
    moveSpeed = speed
end

-- sets the gravity (should be increased over time to support jumping behavior)
function Tilemap:setGravity(gravity)
    self.gravity = gravity
end
