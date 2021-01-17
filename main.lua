require 'Tilemap'
tileMap = Tilemap:create()




-- performs initialization of all objects and data needed by program
function love.load()

  love.window.setMode(800, 600, {resizable=true, vsync=false, minwidth=400, minheight=300})
  -- makes upscaling look pixel-y instead of blurry
  love.graphics.setDefaultFilter('nearest', 'nearest')
end

-- called every frame, with dt passed in as delta in time since last frame
function love.update(dt)
  tileMap:update(dt)

end

-- called each frame, used to render to the screen
function love.draw()
  -- love.graphics.scale(0.1, 0.1)
  -- clear screen using Mario background blue
  love.graphics.clear(108, 140, 255, 255)
  love.graphics.translate(math.floor(-tileMap.camX + 0.5), math.floor(-tileMap.camY + 0.5))
  -- renders our map object onto the screen
  tileMap:render()
end


-- called whenever a key is pressed
function love.keypressed(key)
  if key == 'escape' then
      love.event.quit()
  end
end
