Tilemap = {}
Tilemap.__index = Tilemap

TILE_GRASS_TOP = 2
TILE_GRASS_BOTTOM = 13

TILE_GAP_TOP_LEFT = 1
TILE_GAP_TOP_RIGHT = 3
TILE_GAP_BOTTOM_LEFT = 12
TILE_GAP_BOTTOM_RIGHT = 14

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

local moveSpeed = 100

function Tilemap:create()
    local this = {
        spritesheet = love.graphics.newImage('graphics/tiles.png'),
        tileWidth = 32,
        tileHeight = 32,
        TilemapWidth = 128,
        TilemapHeight = 32,
        tiles = {},

        camX = 0,
        camY = -3,
        resX = 0
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
    local gap = true

    while x < this.TilemapWidth do
      if x < this.TilemapWidth - 3  then

        --spawning gaps
        if love.math.random(5) == 1 and gap == true then
          this:setTile(x, this.TilemapHeight/2, TILE_EMPTY)
          this:setTile(x+1, this.TilemapHeight/2, TILE_EMPTY)
          this:setTile(x-1, this.TilemapHeight/2, TILE_GAP_TOP_RIGHT)
          this:setTile(x+2, this.TilemapHeight/2, TILE_GAP_TOP_LEFT)
          for y=this.TilemapHeight/2 +1, this.TilemapHeight do
            this:setTile(x, y, TILE_EMPTY)
            this:setTile(x+1, y, TILE_EMPTY)
            this:setTile(x-1, y, TILE_GAP_BOTTOM_RIGHT)
            this:setTile(x+2, y, TILE_GAP_BOTTOM_LEFT)
          end
          x = x + 3
          gap = false
        else
          gap = true
          x = x + 2
        end

        --spawning obstacles
        local randomobstacle = love.math.random(2)
        if randomobstacle == 1 then
          local obstaclecounter = 1
          this:setTile(x, this.TilemapHeight/2 -1, TILE_OBSTACLE1)
          this:setTile(x + 1, this.TilemapHeight/2 -1, TILE_OBSTACLE1)
          obstaclecounter = obstaclecounter + 1
          if love.math.random(2) == 1 then
            this:setTile(x, this.TilemapHeight/2 -1, TILE_OBSTACLE1)
            this:setTile(x + 1, this.TilemapHeight/2 -1, TILE_OBSTACLE2)
            this:setTile(x + 2, this.TilemapHeight/2 -1, TILE_OBSTACLE1)
            obstaclecounter = obstaclecounter + 2
            if love.math.random(2) == 1 then
              this:setTile(x, this.TilemapHeight/2 -1, TILE_OBSTACLE1)
              this:setTile(x + 1, this.TilemapHeight/2 -1, TILE_OBSTACLE2)
              this:setTile(x + 2, this.TilemapHeight/2 -1, TILE_OBSTACLE2)
              this:setTile(x + 3, this.TilemapHeight/2 -1, TILE_OBSTACLE1)
              this:setTile(x + 1, this.TilemapHeight/2 -4, TILE_PLATFORM_LEFT)
              this:setTile(x + 2, this.TilemapHeight/2 -4, TILE_PLATFORM_RIGHT)
              obstaclecounter = obstaclecounter + 1
              if love.math.random(2) == 1 then
                this:setTile(x, this.TilemapHeight/2 -1, TILE_OBSTACLE1)
                this:setTile(x + 1, this.TilemapHeight/2 -1, TILE_OBSTACLE2)
                this:setTile(x + 2, this.TilemapHeight/2 -1, TILE_OBSTACLE2)
                this:setTile(x + 3, this.TilemapHeight/2 -1, TILE_OBSTACLE2)
                this:setTile(x + 4, this.TilemapHeight/2 -1, TILE_OBSTACLE1)
                this:setTile(x+ 1, this.TilemapHeight/2 -4, TILE_EMPTY)
                this:setTile(x + 2, this.TilemapHeight/2 -4, TILE_PLATFORM_LEFT)
                this:setTile(x + 3, this.TilemapHeight/2 -4, TILE_PLATFORM_RIGHT)
                obstaclecounter = obstaclecounter + 1
                if love.math.random(2) == 1 then
                  this:setTile(x, this.TilemapHeight/2 -1, TILE_OBSTACLE1)
                  this:setTile(x + 1, this.TilemapHeight/2 -1, TILE_OBSTACLE2)
                  this:setTile(x + 2, this.TilemapHeight/2 -1, TILE_OBSTACLE2)
                  this:setTile(x + 3, this.TilemapHeight/2 -1, TILE_OBSTACLE2)
                  this:setTile(x + 4, this.TilemapHeight/2 -1, TILE_OBSTACLE2)
                  this:setTile(x + 5, this.TilemapHeight/2 -1, TILE_OBSTACLE1)
                  this:setTile(x + 2, this.TilemapHeight/2 -4, TILE_PLATFORM_LEFT)
                  this:setTile(x + 3, this.TilemapHeight/2 -4, TILE_PLATFORM_MIDDLE)
                  this:setTile(x + 4, this.TilemapHeight/2 -4, TILE_PLATFORM_RIGHT)
                  obstaclecounter = obstaclecounter + 1
                end
              end
            end
          end
          x = x + obstaclecounter + 1

        elseif randomobstacle == 2 then
          this:setTile(x, this.TilemapHeight/2 -1, TILE_OBSTACLE3)
          x = x + 2
        end

        --spawning trees
        if love.math.random(5) == 1 then
          local treeStart = math.random(8, this.TilemapHeight/ 2 - 2)
          this:setTile(x, treeStart, TILE_TREE_CROWN_LEFT)
          this:setTile(x + 1, treeStart, TILE_TREE_CROWN_RIGHT)

          this:setTile(x, this.TilemapHeight/2 -1, TILE_TREE_ROOT_LEFT)
          this:setTile(x+1, this.TilemapHeight/2 -1, TILE_TREE_ROOT_RIGHT)

          for i = treeStart + 1, this.TilemapHeight/2-2 do
            this:setTile(x, i, TILE_TREE_STEM_LEFT)
            this:setTile(x+1, i, TILE_TREE_STEM_RIGHT)
          end
          x = x + 2
        end

        --spawning varieties of house1
        if love.math.random(5) == 1 then
          local houseStart = math.random(3, this.TilemapHeight / 2 - 3)
          this:setTile(x, houseStart, TILE_HOUSE1_LEFT_ROOF)
          this:setTile(x+1, houseStart, TILE_HOUSE1_MIDDLE_ROOF)
          this:setTile(x+2, houseStart, TILE_HOUSE1_RIGHT_ROOF)

          this:setTile(x, this.TilemapHeight/2 -1, TILE_HOUSE1_LEFT_BOTTOM)
          this:setTile(x+1, this.TilemapHeight/2 -1, TILE_HOUSE1_MIDDLE_BOTTOM)
          this:setTile(x+2, this.TilemapHeight/2 -1, TILE_HOUSE1_RIGHT_BOTTOM)

          for i=houseStart+1 , this.TilemapHeight/2-2 do
            if math.random(2) == 1 then
              this:setTile(x, i, TILE_HOUSE2_LEFT_MIDDLE)
            else
              this:setTile(x, i, TILE_HOUSE1_LEFT_MIDDLE)
            end

            if math.random(2) == 1 then
              this:setTile(x+1, i, TILE_HOUSE2_MIDDLE_MIDDLE)
            else
              this:setTile(x+1, i, TILE_HOUSE1_MIDDLE_MIDDLE)
            end

            if math.random(2) == 1 then
              this:setTile(x+2, i, TILE_HOUSE2_RIGHT_MIDDLE)
            else
              this:setTile(x+2, i, TILE_HOUSE1_RIGHT_MIDDLE)
            end
          end
          x = x + 4
        end

        --spawning varieties of house2
        if love.math.random(5) == 1 then
          local houseStart = math.random(3, this.TilemapHeight / 2 - 3)
          this:setTile(x, houseStart, TILE_HOUSE2_LEFT_ROOF)
          this:setTile(x+1, houseStart, TILE_HOUSE2_MIDDLE_ROOF)
          this:setTile(x+2, houseStart, TILE_HOUSE2_RIGHT_ROOF)

          this:setTile(x, this.TilemapHeight/2 -1, TILE_HOUSE2_LEFT_BOTTOM)
          this:setTile(x+1, this.TilemapHeight/2 -1, TILE_HOUSE2_MIDDLE_BOTTOM)
          this:setTile(x+2, this.TilemapHeight/2 -1, TILE_HOUSE2_RIGHT_BOTTOM)

          for i=houseStart+1 , this.TilemapHeight/2-2 do
            if math.random(2) == 1 then
              this:setTile(x, i, TILE_HOUSE2_LEFT_MIDDLE)
            else
              this:setTile(x, i, TILE_HOUSE1_LEFT_MIDDLE)
            end

            if math.random(2) == 1 then
              this:setTile(x+1, i, TILE_HOUSE2_MIDDLE_MIDDLE)
            else
              this:setTile(x+1, i, TILE_HOUSE1_MIDDLE_MIDDLE)
            end

            if math.random(2) == 1 then
              this:setTile(x+2, i, TILE_HOUSE2_RIGHT_MIDDLE)
            else
              this:setTile(x+2, i, TILE_HOUSE1_RIGHT_MIDDLE)
            end

          end
          x = x + 4
        end

      end
      x = x + 1
    end


  return this
end

function Tilemap:generateBackground()
  --TODO try to seperate genration of background and foreground
end
-- returns an integer value for the tile at a given x-y coordinate
function Tilemap:getTile(x, y)
    return self.tiles[(y - 1) * self.TilemapWidth + x]
end

-- sets a tile at a given x-y coordinate to an integer value
function Tilemap:setTile(x, y, tile)
    self.tiles[(y - 1) * self.TilemapWidth + x] = tile
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
  self.resX = self.camX
    self.camX = self.camX + dt * moveSpeed
end

--[[function Tilemap:attachnext(currentmap, tileMap)
  local oldlength = currentmap.TilemapWidth
  local newlength = currentmap.TilemapWidth + tileMap.TilemapWidth
  currentmap.TilemapWidth = currentmap.TilemapWidth + tileMap.TilemapWidth
  for x=oldlength, newlength do
    for y=1, currentmap.TilemapHeight do
      currentmap:setTile(x, y, tileMap:getTile(x-oldlength, y))
    end
  end
end ]]
