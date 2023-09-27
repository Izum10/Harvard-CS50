Map = Class{}
UpdateLock = false
Map.Tetromino = {}

function Map:init()
	score = 0
	-- initialise map's grid to a blank grid
	self.grid = {}
	for x=1,SCREEN_WIDTH_BLOCKS do
		self.grid[x] = {}
		for y=1,SCREEN_HEIGHT_BLOCKS do
			self.grid[x][y] = 0
		end
	end

	Map.Tetromino.newTetromino = function()
	local Tetromino_type = math.random(1, #positions)
		self.Current_Tetromino = Tetrominoes(positions[Tetromino_type], 4, 0, colours[Tetromino_type])
		self:DeleteLines()
		for i,Block in ipairs(self.Current_Tetromino:getBlocks()) do
			if self.grid[Block.x / BLOCK_SIZE][Block.y / BLOCK_SIZE] ~= 0 then
				Game_Over = true
			end
		end	
	end

	self.Tetromino.newTetromino()

	Map.Tetromino.erase = function()
		for i,Block in ipairs(self.Current_Tetromino:getBlocks()) do
			self.grid[Block.x / BLOCK_SIZE][Block.y / BLOCK_SIZE] = 0
		end
	end

	Map.Tetromino.stamp = function()
		for i,Block in ipairs(self.Current_Tetromino:getBlocks()) do
			self.grid[Block.x / BLOCK_SIZE][Block.y / BLOCK_SIZE] = 
			{self.Current_Tetromino.id,colour = self.Current_Tetromino.colour}
		end	
	end

	Map.Tetromino.collides = function()
		for i,Block in ipairs(self.Current_Tetromino:getBlocks()) do
			if self.grid[Block.x / BLOCK_SIZE][Block.y / BLOCK_SIZE] ~= 0 then
				return true
			end
		end
	end

	Map.Tetromino.EdgeCollides = function()
		for i,Block in ipairs(self.Current_Tetromino:getBlocks()) do
			if Block.y / BLOCK_SIZE > SCREEN_HEIGHT_BLOCKS 
				or Block.y / BLOCK_SIZE < 0 
				or Block.x / BLOCK_SIZE - 1 < 0
				or Block.x /BLOCK_SIZE  > SCREEN_WIDTH_BLOCKS then
					return true
			end
		end
	end

	Map.Tetromino.BaseCollides = function()
		for i,Block in ipairs(self.Current_Tetromino:getBlocks()) do
			if Block.y / BLOCK_SIZE > SCREEN_HEIGHT_BLOCKS then
				return true
			end
		end
	end

	Map.Tetromino.move = function(x,y)
		if not (Game_Over) and not(UpdateLock) then
			UpdateLock = true

			self.Tetromino.erase()

			self.Current_Tetromino:move(x,y)

			if self.Tetromino.EdgeCollides() or self.Tetromino.collides() then
				self.Current_Tetromino:move(-x,-y)
				self.Tetromino.stamp()
			end

			self.Tetromino.stamp()

			if self.Tetromino.BaseCollides() then
				self.Tetromino.newTetromino()
			end

			UpdateLock = false
		end
	end

	Map.Tetromino.rotate = function(x)
		if not (Game_Over) and not(UpdateLock) then
			UpdateLock = true

			self.Tetromino.erase()

			self.Current_Tetromino:rotate(x)

			if self.Tetromino.EdgeCollides() or self.Tetromino.collides() then
				self.Current_Tetromino:rotate(-x)
			end

			self.Tetromino.stamp()

			UpdateLock = false
		end
	end
	Map.Audio = {}

	Map.Audio[1] = love.audio.newSource("Music/Original.ogg", "stream") 
	Map.Audio[2] = love.audio.newSource("Music/Violin And Guitar.ogg", "stream")
	Map.Audio[3] = love.audio.newSource("Music/Piano.ogg", "stream")
	Map.Audio[4] = love.audio.newSource("Music/Guitar.ogg", "stream")
	Map.Audio[5] = love.audio.newSource("Music/harder and H A R D E R.ogg", "stream")
	Map.Audio[6] = love.audio.newSource("Music/Rock.ogg", "stream")
	Map.Audio[7] = love.audio.newSource("Music/Metal.ogg", "stream")
	Map.Audio[8] = love.audio.newSource("Music/Acapella.ogg", "stream")


	Map.Audio.CurrentIndex = 1
	Map.Audio.Current = Map.Audio[Map.Audio.CurrentIndex]
	Map.Audio[Map.Audio.CurrentIndex]:play()

	Map.Audio.playMusic = function()
		if not Map.Audio[Map.Audio.CurrentIndex]:isPlaying() then
			Map.Audio.CurrentIndex = Map.Audio.CurrentIndex +  math.floor(score / 10)
			if Map.Audio.CurrentIndex > 8 then Map.Audio.CurrentIndex = math.random(5,8) end
			Map.Audio[Map.Audio.CurrentIndex]:play()
		end
	end
end


function Map:render()
	for x=1,SCREEN_WIDTH_BLOCKS do
		for y=1,SCREEN_HEIGHT_BLOCKS do
			if self.grid[x][y] ~= 0 then
				love.graphics.setColor(self.grid[x][y].colour)
				love.graphics.setLineWidth(1)
				love.graphics.rectangle('fill',x * BLOCK_SIZE - BLOCK_SIZE,
										y * BLOCK_SIZE - BLOCK_SIZE,
										BLOCK_SIZE,
										BLOCK_SIZE)

				love.graphics.setColor(self.grid[x][y].colour[1]/2,
										self.grid[x][y].colour[2]/2,
										self.grid[x][y].colour[3]/2,
										self.grid[x][y].colour[4]/2)
				love.graphics.setLineWidth(BLOCK_SIZE/10)
				love.graphics.rectangle('line',
										(x)*BLOCK_SIZE - BLOCK_SIZE,
										(y)*BLOCK_SIZE - BLOCK_SIZE,
										BLOCK_SIZE-2,
										BLOCK_SIZE-2)
			end
				love.graphics.setColor(0.5,0.5,0.5,1)
				love.graphics.setLineWidth(BLOCK_SIZE/100)
				love.graphics.rectangle('line',
										(x)*BLOCK_SIZE - BLOCK_SIZE,
										(y)*BLOCK_SIZE - BLOCK_SIZE,
										BLOCK_SIZE-2,
										BLOCK_SIZE-2)
				love.graphics.setFont(ScoreFont)
				love.graphics.print(score)
		end
	end
	if Game_Over then
		love.graphics.setFont(EndFont)
		love.graphics.print("The End :(")
	end 

end

function Map:update()
	if not (Game_Over) and not(UpdateLock) then
		UpdateLock = true
		
		self.Tetromino.erase()

		--Move
		self.Current_Tetromino:move(0,1)

		-- Colision detection
		-- needs to be after erase to  prevent it from smashing itself
		if self.Tetromino.collides() then
			for i,Blocks in ipairs(self.Current_Tetromino:getBlocks()) do
				self.grid[Blocks.x / BLOCK_SIZE][Blocks.y / BLOCK_SIZE-1]=
				{self.Current_Tetromino.id, colour = self.Current_Tetromino.colour}
			end	
			self.Tetromino.newTetromino()
		end

		self.Tetromino.stamp()

		if self.Tetromino.BaseCollides() then
			self.Tetromino.newTetromino()
		end

		UpdateLock = false
	end
end

function Map:debug()
	Debug = true
	for x=1,SCREEN_WIDTH_BLOCKS do
		for y=1,SCREEN_HEIGHT_BLOCKS do
			if self.grid[x][y] ~= 0 then
				print(x, y, self.grid[x][y][1])
			end
		end
	end
end

function Map:stopAll()
	Game_Over = true
end

function Map:LineIsFull(y)
	for x=1, SCREEN_WIDTH_BLOCKS do
		if self.grid[x][y] == 0 then
			return false
		end
	end
	return true
end

function Map:DeleteLines()
	for i=1,SCREEN_HEIGHT_BLOCKS do
		if self:LineIsFull(i) then
			score = score+1
			for i2 = i, 1, -1 do
				for x = 1, SCREEN_WIDTH_BLOCKS do
					if i2 - 1 > 0 then
						self.grid[x][i2] = self.grid[x][i2-1]
					end
				end
			end
		end
	end
end