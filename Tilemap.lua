Tilemap = {}
Tilemap.__index = Tilemap

TILE_GRASS= 1
TILE_EMPTY = 5

local moveSpeed = 30

function Tilemap:create()
    local this = {
        spritesheet = love.graphics.newImage('graphics/tiles.png'),
        tileWidth = 32,
        tileHeight = 32,
        TilemapWidth = 150,
        TilemapHeight = 32,
        tiles = {},

        camX = 0,
        camY = -3
    }

    -- generate a quad (individual frame/sprite) for each tile
    this.tileSprites = generateQuads(this.spritesheet, 32, 32)

    -- more OO boilerplate so we have access to class functions
    setmetatable(this, self)

    -- first, fill Tilemap with empty tiles
    for y = 1, this.TilemapHeight do
        for x = 1, this.TilemapWidth do
            this:setTile(x, y, TILE_EMPTY)
        end
    end

    -- fill bottom half of Tilemap with tiles
    for y = this.TilemapHeight / 2, this.TilemapHeight do
        for x = 1, this.TilemapWidth do
            this:setTile(x, y, TILE_GRASS)
        end
    end

    return this
end

-- returns an integer value for the tile at a given x-y coordinate
function Tilemap:getTile(x, y)
    return self.tiles[(y - 1) * self.TilemapWidth + x]
end

-- sets a tile at a given x-y coordinate to an integer value
function Tilemap:setTile(x, y, tile)
    self.tiles[(y - 1) * self.TilemapWidth + x] = tile
end

function Tilemap:update(dt)
    self.camX = self.camX + dt * scrollSpeed
end

-- renders our Tilemap to the screen, to be called by main's render
function Tilemap:render()
    for y = 1, self.TilemapHeight do
        for x = 1, self.TilemapWidth do
            love.graphics.draw(self.spritesheet, self.tileSprites[self:getTile(x, y)],
                (x - 1) * self.tileWidth, (y - 1) * self.tileHeight)
        end
    end
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
                love.graphics.newQuad(x * tilewidth, y * tileheight, tilewidth,
                tileheight, atlas:getDimensions())
            sheetCounter = sheetCounter + 1
        end
    end

    return quads
end

function Tilemap:update(dt)
    self.camX = self.camX + dt * moveSpeed
end
