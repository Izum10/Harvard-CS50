LevelUpState = Class{__includes = BaseState}

function LevelUpState:init(pokemon)

	ohp = pokemon.HP
	oat = pokemon.attack
	ode = pokemon.defense
	osp = pokemon.speed

	pokemon:levelUp()

	nhp = pokemon.HP
	nat = pokemon.attack
	nde = pokemon.defense
	nsp = pokemon.speed

	msg = "Congratulation! Level Up\n"
	msg = msg .. "HP ".. ohp .. " + " .. (nhp - ohp) .. " = " .. nhp .. "\n"
	msg = msg .. "Attack: " .. oat .. " + " .. (nat - oat) ..  " = " .. nat .. "\n"
	msg = msg .. "Defense " .. ode .. " + " .. (nde - ode) .. " = " .. nde .. "\n"
	msg = msg .. "Speed: " .. osp .. " + " .. (nsp - osp) .. " = " .. nsp

	self.textbox = Textbox(0, VIRTUAL_HEIGHT - 64, VIRTUAL_WIDTH, 64, msg, gFonts['small'])

	self.onclose = onclose or function() end

	self.canInput = canInput

	if self.canInput == nil then self.canInput = true end
end

function LevelUpState:update(dt)
	if self.canInput then
		self.textbox:update(dt)

		if self.textbox:isClosed() then
			gStateStack:pop()
			gStateStack:pop()
			gSounds['victory-music']:stop()
		end
	end
end

function LevelUpState:render()
	self.textbox:render()
end

