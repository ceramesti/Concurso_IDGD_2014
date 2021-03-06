enemy = {}
function enemy.load()
	enemy.height = 40
	enemy.width = 30
	enemy.speed = 100
	enemy.timer = 0
	enemy.timerLimit = love.math.random(2,4)
	enemy.amount = love.math.random(2,5)
	enemy.side = love.math.random(1,4)
	enemy.type = 1
	enemy.easy = 1
	enemy.medium = 2
	enemy.hard = 3
	enemy.totalTime = 0
	enemy.distance = 40
	enemy.lastSide = 0
	enemy.spawnRepetitions = 0
	enemy.shootTime=50
	enemy.tpTime=100
	enemy.stopGenerate = false
	enemy.alien=love.graphics.newImage("img/alien.png")
	enemy.teleportfx=love.graphics.newImage("img/teleport.png")
	enemy.teleportani=newAnimation(enemy.teleportfx,30,40,.5,0)

	enemy.ghostF = love.graphics.newImage("img/ghost-front.png")
	enemy.ghostAFront = newAnimation(enemy.ghostF,30,40,.3,0)
	enemy.ghostB = love.graphics.newImage("img/ghost-back.png")
	enemy.ghostABack = newAnimation(enemy.ghostB,30,40,.3,0)
	enemy.ghostL = love.graphics.newImage("img/ghost-left.png")
	enemy.ghostALeft = newAnimation(enemy.ghostL,30,40,.3,0)
	enemy.ghostR = love.graphics.newImage("img/ghost-right.png")
	enemy.ghostARight = newAnimation(enemy.ghostR,30,40,.3,0)

	enemy.indianF = love.graphics.newImage("img/indian/front.png")
	enemy.indianAFront = newAnimation(enemy.indianF,30,40,.3,0)
	enemy.indianB = love.graphics.newImage("img/indian/back.png")
	enemy.indianABack = newAnimation(enemy.indianB,30,40,.3,0)
	enemy.indianL = love.graphics.newImage("img/indian/left.png")
	enemy.indianALeft = newAnimation(enemy.indianL,30,40,.3,0)
	enemy.indianR = love.graphics.newImage("img/indian/right.png")
	enemy.indianARight = newAnimation(enemy.indianR,30,40,.3,0)
end

function enemy.spawn (x , y, enemType, speed)
	if enemType == enemy.easy then 
		table.insert(enemy, {x = x, y = y, hp = 1, enemType = enemType, enemy.height, enemy.width, speed=speed, flag=false})
	end 
	if enemType == enemy.medium then 
		table.insert(enemy, {x = x, y = y, hp = 3, enemType = enemType, enemy.height, enemy.width, speed=speed  - 50, flag=false})
	end
	if enemType == enemy.hard then 
		table.insert(enemy, {x = x, y = y, hp = 2, enemType = enemType, enemy.height, enemy.width, speed=speed  - 50, flag=false, indivTime=0, pastX=-48,pastY=-48})
	end

end 

function enemy.generate(dt)
	if not enemy.stopGenerate then 
		enemy.timer = enemy.timer + dt
		enemy.totalTime = enemy.totalTime + dt
		
		if enemy.timer > enemy.timerLimit then 
			for i = 1, enemy.amount do
				if enemy.side == 1 then 
					if enemy.lastSide == 1 then 
						enemy.spawnRepetitions = enemy.spawnRepetitions + 1
						enemy.spawn(0-enemy.width,screenHeight / 2 + 30 * enemy.spawnRepetitions, enemy.type, enemy.speed)
					else 
						enemy.spawnRepetitions = 0
						enemy.spawn(0-enemy.width,screenHeight / 2, enemy.type, enemy.speed)
					end 
					enemy.lastSide = 1 
				elseif enemy.side == 2 then 
					if enemy.lastSide == 2 then 
						enemy.spawnRepetitions = enemy.spawnRepetitions + 1
						enemy.spawn(screenWidth /2 + 30 * enemy.spawnRepetitions- enemy.width, -enemy.height, enemy.type, enemy.speed)
					else 
						enemy.spawnRepetitions = 0
						enemy.spawn(screenWidth /2 - enemy.width, 0-enemy.height, enemy.type, enemy.speed)
					end 
					enemy.lastSide = 2 
				elseif enemy.side == 3 then 
					if enemy.lastSide == 3 then 
						enemy.spawnRepetitions = enemy.spawnRepetitions + 1
						enemy.spawn( screenWidth, screenHeight / 2  + 30 * enemy.spawnRepetitions - enemy.height, enemy.type, enemy.speed)
					else 
						enemy.spawnRepetitions = 0
						enemy.spawn(screenWidth, screenHeight / 2 - enemy.height, enemy.type, enemy.speed)
					end 
					enemy.lastSide = 3 
				elseif enemy.side == 4 then
					if enemy.lastSide == 4 then 
						enemy.spawnRepetitions = enemy.spawnRepetitions + 1
						enemy.spawn ( screenWidth /2 + 30 * enemy.spawnRepetitions,  screenHeight, enemy.type, enemy.speed)
					else 
						enemy.spawn ( screenWidth /2 , screenHeight, enemy.type, enemy.speed)
						enemy.spawnRepetitions = 0
					end 
					enemy.lastSide = 4 
				end

				enemy.side = love.math.random(1,4)
				
			
			end 
			enemy.amount = love.math.random(2,4)
			enemy.timerLimit = love.math.random(2,4)
			enemy.timer = 0
			----aumento de dificultad
			if enemy.totalTime > 25 then 
				enemy.type = love.math.random(1,2)
			end 

			if enemy.totalTime > 50 then 
				enemy.type = love.math.random(1,3)
				if enemy.type==3 then enemy.amount = 1 end
			end 
		end
	end  
	if enemy.totalTime >  map.timeForNextLevel then 
		enemy.stopGenerate = true
		map.newMapTransition()
	else 
		enemy.stopGenerate = false
	end  
end

function enemy.AI(dt)
	for i, v in ipairs (enemy) do
		if v.enemType == 3 then
			if v.indivTime > enemy.tpTime then 
				v.pastX = v.x 
				v.pastY = v.y
				v.x = love.math.random(love.window.getWidth())
				v.y = love.math.random(love.window.getHeight())
				v.indivTime=0
			end
			if (v.indivTime-2>enemy.shootTime and v.indivTime-2<enemy.shootTime+2) or (v.indivTime/2-2>enemy.shootTime and v.indivTime/2-2<enemy.shootTime+2)==0 then
				if v.x<love.window.getWidth() and v.x > 0 and v.y < love.window.getHeight() and v.y > 0 then
					enemBullet.spawn(v.x,v.y,math.atan2(player.y-(v.y+enemy.height/2),player.x-(v.x+enemy.width/2)))
				end
			end
			v.indivTime=v.indivTime+50*dt
		elseif v.x > player.x then 
			v.x = v.x - v.speed * dt 
		elseif v.x < player.x then 
			v.x = v.x + v.speed * dt 
		end 
		if v.enemType == 3 then
		elseif v.y > player.y then 
			v.y = v.y - v.speed * dt 
		elseif v.y < player.y then 
			v.y = v.y + v.speed * dt
		end
	end  
end  

function enemy.overlapping() 
	for i,v in ipairs(enemy) do
		v.speed=enemy.speed
		v.flag = false
	end
	for i, v in ipairs (enemy) do 
		for j, k in ipairs(enemy) do 
			if v ~= k then 
				if ((v.x < k.x and k.x<v.x+enemy.width) and (v.y < k.y and k.y<v.y+enemy.height)) or 
			((v.x < k.x+enemy.width and k.x+enemy.width<v.x+enemy.width) and (v.y < k.y+enemy.height and k.y+enemy.height<v.y+enemy.height)) or 
			((v.x < k.x+enemy.width and k.x+enemy.width<v.x+enemy.width) and (v.y < k.y and k.y<v.y+enemy.height)) or 
			((v.x < k.x and k.x<v.x+enemy.width) and (v.y < k.y+enemy.height and k.y+enemy.height<v.y+enemy.height)) then  
					--v.x = k.x + enemy.width/2
					--v.y = k.y + enemy.width/2
					--k.x = v.x - enemy.width
					--k.y = v.y - enemy.width
					if not v.flag and not k.flag then
						v.speed=v.speed/100
						k.flag = true
					end
				end
			end 
		end 
	end 
end 

function drawIndivEnemy(self)
	love.graphics.setColor(255,255,255)
	if self.enemType == enemy.easy	then 
		if self.y > player.y then
			if self.x>player.x then
				if self.x-player.x > self.y-player.y then
					enemy.ghostALeft:draw(self.x,self.y)
				else
				    enemy.ghostABack:draw(self.x,self.y)
				end
			else
			   	if player.x-self.x > self.y-player.y then
					enemy.ghostARight:draw(self.x,self.y)
				else
				    enemy.ghostABack:draw(self.x,self.y)
				end
			end
		else
		    if self.x>player.x then
				if self.x-player.x > player.y-self.y then
					enemy.ghostALeft:draw(self.x,self.y)
				else
				    enemy.ghostAFront:draw(self.x,self.y)
				end
			else
			   	if player.x-self.x > player.y-self.y then
					enemy.ghostARight:draw(self.x,self.y)
				else
				    enemy.ghostAFront:draw(self.x,self.y)
				end
			end
		end
	elseif self.enemType == enemy.medium then
		if self.y > player.y then
			if self.x>player.x then
				if self.x-player.x > self.y-player.y then
					enemy.indianALeft:draw(self.x,self.y)
				else
				    enemy.indianABack:draw(self.x,self.y)
				end
			else
			   	if player.x-self.x > self.y-player.y then
					enemy.indianARight:draw(self.x,self.y)
				else
				    enemy.indianABack:draw(self.x,self.y)
				end
			end
		else
		    if self.x>player.x then
				if self.x-player.x > player.y-self.y then
					enemy.indianALeft:draw(self.x,self.y)
				else
				    enemy.indianAFront:draw(self.x,self.y)
				end
			else
			   	if player.x-self.x > player.y-self.y then
					enemy.indianARight:draw(self.x,self.y)
				else
				    enemy.indianAFront:draw(self.x,self.y)
				end
			end
		end
	elseif self.enemType == enemy.hard then
		love.graphics.draw(enemy.alien,self.x,self.y)
		enemy.teleportani:draw(self.pastX, self.pastY)
	end 
end

function ENEMY_UPDATE(dt)
	enemy.generate(dt)
	enemy.AI(dt)
	enemy.overlapping()
	enemy.teleportani:update(dt)

	enemy.ghostARight:update(dt)
	enemy.ghostALeft:update(dt)
	enemy.ghostABack:update(dt)
	enemy.ghostAFront:update(dt)

	enemy.indianARight:update(dt)
	enemy.indianALeft:update(dt)
	enemy.indianABack:update(dt)
	enemy.indianAFront:update(dt)
end 

function ENEMY_DRAW()
	enemy.draw()
end