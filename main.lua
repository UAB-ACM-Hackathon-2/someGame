function love.load()
	initializeWindow()
	
	player = {
		width = 32,
		height = 32,
		gridX = 0,
		gridY = 0
	}
	
	enemy = {
		width = 32,
		height = 32,
		gridX = 128,
		gridY = 128,
		speed = 8
	}
	
	goal = {
		width = 32,
		height = 32,
		gridX = 480,
		gridY = 480
	}
	
	state = 'notstarted'
end

function love.update(dt)
	if state ~= 'play' then
		return
	end
	
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
    
    if enemy.gridY < 0 then
        enemy.gridY = 0
    elseif (enemy.gridY + 32) > screenHeight then
        enemy.gridY = screenHeight - 32
    end
    
    if enemy.gridX < 0 then
    	enemy.gridX = 0
    elseif (enemy.gridX + 32) > screenWidth then
    	enemy.gridX = screenWidth - 32
    end
    
    if (player.gridX + player.width > enemy.gridX) and (player.gridX < enemy.gridX + enemy.width) and 
    (player.gridY + player.height > enemy.gridY) and (player.gridY < enemy.gridY + enemy.height) then
    	state = 'lose'
    end
    
    if (player.gridX == goal.gridX) and (player.gridY == goal.gridY) then
    	state = 'win'
    end
    
	distX =  player.gridX - enemy.gridX
	distY =  player.gridY - enemy.gridY
	
	distance = math.sqrt(distX * distX + distY * distY)
	
	velocityX = distX/distance * enemy.speed
	velocityY = distY/distance * enemy.speed
	
	enemy.gridX = enemy.gridX + velocityX * dt
	enemy.gridY = enemy.gridY + velocityY * dt
	
	enemy.speed = enemy.speed + (enemy.speed * dt)/2
end

function love.draw()
	love.graphics.rectangle("fill", player.gridX, player.gridY, 32, 32)
	love.graphics.rectangle("fill", enemy.gridX, enemy.gridY, 32, 32)
	love.graphics.rectangle("fill", goal.gridX, goal.gridY, 32, 32)
	
	if state == 'notstarted' then
		stopScreen()
		width = love.graphics.getWidth()
		love.graphics.printf("Press ENTER to start playing!", 0, (screenHeight / 2) - 50, width, "center")
		love.graphics.printf("Use the arrow keys for movement and avoid the other entity!", 0, (screenHeight / 2) - 30, width, "center")
		love.graphics.printf("To pause the game, press P. To quit, press Q or ESC.", 0, (screenHeight / 2) - 10, width, "center")
	end
	
	if state == 'pause' then
		stopScreen()
		width = love.graphics.getWidth()
		love.graphics.printf("PAUSED", 0, (screenHeight / 2) - 50, width, "center")
	end
	
	if state == 'win' then
		stopScreen()
		width = love.graphics.getWidth()
		love.graphics.printf("YOU WIN", 0, (screenHeight / 2) - 50, width, "center")
	end
	
	if status == 'lose' then
		stopScreen()
		width = love.graphics.getWidth()
		love.graphics.printf("GAME OVER", 0, (screenHeight / 2) - 50, width, "center")
	end
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
	
	if key == 'return' then
		if state == 'notstarted' then
			state = 'play'
		end
	end
	
	if key == 'q' or key == 'escape' then
		love.event.quit()
	end
	
	if key == 'p' then
		if state == 'play' then
			state = 'pause'
		elseif state == 'pause' then
			state = 'play'
		end
	end
end

function initializeWindow()
	screenWidth = 800
	screenHeight = 600
	
	love.window.setTitle('The Game')
    love.window.setMode(screenWidth, screenHeight)
end

function stopScreen()
	love.graphics.setColor(0, 0, 0, 100)
	love.graphics.rectangle('fill', 0, 0, screenWidth, screenHeight)
	love.graphics.setColor(255,255,255)
	love.graphics.setFont(love.graphics.newFont(18))
end
