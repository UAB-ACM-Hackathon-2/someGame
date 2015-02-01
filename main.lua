local map, mapX, mapY
local tileDisplayWidth, tileDisplayHeight
local zoomX, zoomY
local tilesetImage, tileSize
local tileQuads = {}

function love.load()
	initializeWindow()
	mapSetup()
	mapView()
	tilesetSetup()
	
	player = {
		gridX = 256,
		gridY = 256,
		actX = 200,
		actY = 200,
		speed = 10
	}
end

function love.update(dt)
	player.actY = player.actY - ((player.actY - player.gridY) * player.speed * dt)
	player.actX	= player.actX - ((player.actX - player.gridX) * player.speed *  dt)

	if player.gridY < 0 then
        player.gridY = 0
    elseif (player.gridY + 32) > screenHeight then
        player.gridY = screenHeight - 32
    end
    
    if player.gridX < 0 then
    	player.gridX = 0
    elseif (player.gridX + 32) > screenWidth then
    	player.gridX = screenWidth - 32
    end
end

function love.draw()
	love.graphics.draw(tilesetBatch, math.floor(-zoomX * (mapX % 1) * tileSize), math.floor(-zoomY * (mapY % 1) * tileSize), 0, zoomX, zoomY)
	love.graphics.rectangle("fill", player.actX, player.actY, 32, 32)
end

function love.keypressed(key)
	if key == 'up' then
		player.gridY = player.gridY - 32
	end
	
	if key == 'down' then
		player.gridY = player.gridY + 32
	end
	
	if key == 'left' then
		player.gridX = player.gridX - 32
	end
	
	if key == 'right' then
		player.gridX = player.gridX + 32
	end
end

function initializeWindow()
	screenWidth = 800
	screenHeight = 600
	
	love.window.setTitle('The RPG')
    love.window.setMode(screenWidth, screenHeight)
end

function mapSetup()
	mapWidth = 60
	mapHeight = 60
	
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
	tilesetImage = love.graphics.newImage("tileset2.png")
	tileSize = 32
	
	tileQuads[0] = love.graphics.newQuad(0 * tileSize, 0 * tileSize, tileSize, tileSize, tilesetImage:getWidth(), tilesetImage:getHeight())
	tileQuads[1] = love.graphics.newQuad(1 * tileSize, 5 * tileSize, tileSize, tileSize, tilesetImage:getWidth(), tilesetImage:getHeight())
	
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
