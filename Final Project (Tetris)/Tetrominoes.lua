Tetrominoes = Class{}

Tetrominoes.i = 1
function Tetrominoes:init(Blocks, x, y, colour)
	self.Blocks = Blocks
	self.Current_Block_index =  1
	self.Current_Blocks = Blocks[self.Current_Block_index]
	self.x = x
	self.y = y
	self.id = os.time()
	self.colour = colour
	for i,block in ipairs(self.Current_Blocks) do
		block.parent = self.id
		block.x = (self.x + block.xOffset) * BLOCK_SIZE
		block.y = (self.y + block.yOffset) * BLOCK_SIZE
	end
	if Debug then
		print(debug.traceback())
		print(Tetrominoes.i, os.time())
		print("\n\n\n")
	end
	Tetrominoes.i = Tetrominoes.i + 1
end

function Tetrominoes:move(x, y)
	self.y = self.y + y
	self.x = self.x + x
	for i,block in ipairs(self.Current_Blocks) do
		block.x = (self.x + block.xOffset) * BLOCK_SIZE
		block.y = (self.y + block.yOffset) * BLOCK_SIZE
	end
end

function Tetrominoes:render()
	for i,block in ipairs(self.Current_Blocks) do
		block:render()
	end
end

function Tetrominoes:rotate(x)
	local Old_Index = self.Current_Block_index

	self.Current_Block_index = self.Current_Block_index + x

	-- Just fixing edge cases
	if self.Current_Block_index > #self.Blocks then
		self.Current_Block_index = 1
	end
	if self.Current_Block_index == 0 then
		self.Current_Block_index = 1
	end

	self.Current_Blocks = self.Blocks[self.Current_Block_index]
	for i,block in ipairs(self.Current_Blocks) do
		block.x = (self.x + block.xOffset) * BLOCK_SIZE
		block.y = (self.y + block.yOffset) * BLOCK_SIZE
	end
end

function Tetrominoes:getBlocks()
	return self.Current_Blocks
end