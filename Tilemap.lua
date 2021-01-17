Tilemap = {}
Tilemap.__index = Tilemap

TILE_GRASS_TOP = 2
TILE_GRASS_BOTTOM = 10
TILE_EMPTY = 17

--tiles for the first house
TILE_HOUSE1_LEFT_ROOF = 25
TILE_HOUSE1_MIDDLE_ROOF = 26
TILE_HOUSE1_RIGHT_ROOF = 27

TILE_HOUSE1_LEFT_MIDDLE = 33
TILE_HOUSE1_MIDDLE_MIDDLE = 34
TILE_HOUSE1_RIGHT_MIDDLE = 35

TILE_HOUSE1_LEFT_BOTTOM = 41
TILE_HOUSE1_MIDDLE_BOTTOM = 42
TILE_HOUSE1_RIGHT_BOTTOM = 43

--tiles for the second house
TILE_HOUSE2_LEFT_ROOF = 28
TILE_HOUSE2_MIDDLE_ROOF = 29
TILE_HOUSE2_RIGHT_ROOF = 30

TILE_HOUSE2_LEFT_MIDDLE = 36
TILE_HOUSE2_MIDDLE_MIDDLE = 37
TILE_HOUSE2_RIGHT_MIDDLE = 38

TILE_HOUSE2_LEFT_BOTTOM = 44
TILE_HOUSE2_MIDDLE_BOTTOM = 45
TILE_HOUSE2_RIGHT_BOTTOM = 46


local moveSpeed = 30

function Tilemap:create()
    local this = {
        spritesheet = love.graphics.newImage('graphics/tiles_old.png'),
        tileWidth = 32,
        tileHeight = 32,
        TilemapWidth = 32,
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

    -- fill line at half of tilemapheight with grass
    for x = 1, this.TilemapWidth do
        this:setTile(x, this.TilemapHeight/2, TILE_GRASS_TOP)
    end

    --fill anything below that line with dirt
    for y=this.TilemapHeight/2 + 1, this.TilemapHeight do
      for x=1, this.TilemapWidth do
        this:setTile(x, y, TILE_GRASS_BOTTOM)
      end
    end

    local x = 1
    while x < this.TilemapWidth do
      if x < this.TilemapWidth - 3 then
        if math.random(20) == 1 then
          local houseStart = math.random(this.TilemapHeight / 2 - 3)
          this:setTile(x, houseStart, TILE_HOUSE1_LEFT_ROOF)
          this:setTile(x+1, houseStart, TILE_HOUSE1_MIDDLE_ROOF)
          this:setTile(x+2, houseStart, TILE_HOUSE1_RIGHT_ROOF)

          this:setTile(x, this.TilemapHeight/2 -1, TILE_HOUSE1_LEFT_BOTTOM)
          this:setTile(x+1, this.TilemapHeight/2 -1, TILE_HOUSE1_MIDDLE_BOTTOM)
          this:setTile(x+2, this.TilemapHeight/2 -1, TILE_HOUSE1_RIGHT_BOTTOM)

          for i=houseStart+1 , this.TilemapHeight/2-2 do
            this:setTile(x, i, TILE_HOUSE1_LEFT_MIDDLE)
            this:setTile(x+1, i, TILE_HOUSE1_MIDDLE_MIDDLE)
            this:setTile(x+2, i, TILE_HOUSE1_RIGHT_MIDDLE)
          end
          x = x + 3
        elseif math.random(20) == 1 then
          local houseStart = math.random(this.TilemapHeight / 2 - 3)
          this:setTile(x, houseStart, TILE_HOUSE2_LEFT_ROOF)
          this:setTile(x+1, houseStart, TILE_HOUSE2_MIDDLE_ROOF)
          this:setTile(x+2, houseStart, TILE_HOUSE2_RIGHT_ROOF)

          this:setTile(x, this.TilemapHeight/2 -1, TILE_HOUSE2_LEFT_BOTTOM)
          this:setTile(x+1, this.TilemapHeight/2 -1, TILE_HOUSE2_MIDDLE_BOTTOM)
          this:setTile(x+2, this.TilemapHeight/2 -1, TILE_HOUSE2_RIGHT_BOTTOM)

          for i=houseStart+1 , this.TilemapHeight/2-2 do
            this:setTile(x, i, TILE_HOUSE2_LEFT_MIDDLE)
            this:setTile(x+1, i, TILE_HOUSE2_MIDDLE_MIDDLE)
            this:setTile(x+2, i, TILE_HOUSE2_RIGHT_MIDDLE)
          end
          x = x + 3
        elseif math.random(10) == 1 then
          for y=this.TilemapHeight/2, this.TilemapHeight do
            this:setTile(x, y, TILE_EMPTY)
            this:setTile(x+1, y, TILE_EMPTY)
          end
          x = x + 2
        elseif math.random(10) == 1 then

        else
          x = x + 1
        end
      else
        x = x+1
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
