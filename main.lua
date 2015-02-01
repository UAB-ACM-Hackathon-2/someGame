local map, mapX, mapY
local tileDisplayWidth, tileDisplayHeight
local zoomX, zoomY
local tilesetImage, tileSize, tilesetSprite
local tileQuads = {}

function love.load()
	mapSetup()
	mapView()
	tilesetSetup()
	
end

function love.update(dt)
	if love.keyboard.isDown('up') then
		moveMap(0, -0.2 * tileSize * dt)
	end
	
	if love.keyboard.isDown('down') then
		moveMap(0, 0.2 * tileSize * dt)
	end
	
	if love.keyboard.isDown('left') then
		moveMap(-0.2 * tileSize * dt, 0)
	end
	
	if love.keyboard.isDown('right') then
		moveMap(0.2 * tileSize * dt, 0)
	end
end

function love.draw()
	love.graphics.draw(tilesetBatch, math.floor(-zoomX * (mapX % 1) * tileSize), math.floor(-zoomY * (mapY % 1) * tileSize), 0, zoomX, zoomY)
end

function love.keypressed(key)
	if key == 'up' then
		moveMap(0, -1)
	end
	
	if key == 'down' then
		moveMap(0, 1)
	end
	
	if key == 'left' then
		moveMap(-1, 0)
	end
	
	if key == 'right' then
		moveMap(1, 0)
	end
end

function mapSetup()
	mapWidth = 60
	mapHeight = 40
	
	map = {}
	for x = 1, mapWidth do
		map[x] = {}
		for y = 1,mapHeight do
			map[x][y] = love.math.random(0, 1)
		end
	end
end

function mapView()
	mapX = 1
	mapY = 1
	tilesDisplayWidth = 26
	tilesDisplayHeight = 20
	zoomX = 1
	zoomY = 1
end

function tilesetSetup()
	tilesetImage = love.graphics.newImage("tileset.png")
	tileSize = 32
	
	tileQuads[0] = love.graphics.newQuad(0 * tileSize, 20 * tileSize, tileSize, tileSize, tilesetImage:getWidth(), tilesetImage:getHeight())
	tileQuads[1] = love.graphics.newQuad(1 * tileSize, 20 * tileSize, tileSize, tileSize, tilesetImage:getWidth(), tilesetImage:getHeight())
	
	tilesetBatch = love.graphics.newSpriteBatch(tilesetImage, tilesDisplayWidth * tilesDisplayHeight)
	updateTilesetBatch()
end

function updateTilesetBatch()
	tilesetBatch:bind()
	tilesetBatch:clear()
	
	for x = 0, tilesDisplayWidth - 1 do
		for y = 0, tilesDisplayHeight - 1 do
			tilesetBatch:add(tileQuads[map[x + math.floor(mapX)][y + math.floor(mapY)]], x * tileSize, y * tileSize)
		end
	end
	
	tilesetBatch:unbind()
end

function moveMap(dx, dy)
	oldMapX = mapX
	oldMapY = mapY
	mapX = math.max(math.min(mapX + dx, mapWidth - tilesDisplayWidth), 1)
	mapY = math.max(math.min(mapY + dy, mapHeight - tilesDisplayHeight), 1)
	
	if math.floor(mapX) ~= math.floor(oldMapX) or math.floor(oldMapY) ~= math.floor(oldMapY) then
		updateTilesetBatch()
	end
end
