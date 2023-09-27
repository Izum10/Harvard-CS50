--[[
    State when player is walking with a pot on
]]

PlayerPotWalk = Class{__includes = EntityWalkState}


function PlayerPotWalk:init(player, dungeon)
    self.entity = player
    self.dungeon = dungeon
end

function PlayerPotWalk:enter(params)
    self.pot = params.object
end

--[[
    Determining state with pot on top
]]
function PlayerPotWalk:update(dt)

    if love.keyboard.isDown('left') then
        self.entity.direction = 'left'
        self.entity:changeAnimation('pot-walk-left')
    elseif love.keyboard.isDown('right') then
        self.entity.direction = 'right'
        self.entity:changeAnimation('pot-walk-right')
    elseif love.keyboard.isDown('up') then
        self.entity.direction = 'up'
        self.entity:changeAnimation('pot-walk-up')
    elseif love.keyboard.isDown('down') then
        self.entity.direction = 'down'
        self.entity:changeAnimation('pot-walk-down')
    else
        self.entity:changeStateWithParams('pot-idle', {
            object = self.pot
        })
    end

    self.pot.x = self.entity.x
    self.pot.y = self.entity.y - self.pot.height + POT_PLAYER_HEAD_YOFFSET

    EntityWalkState.update(self, dt)
end

--[[
    Render entity walk and pot on top
]]
function PlayerPotWalk:render()
    self.pot:render(0, 0)
    EntityWalkState.render(self)
end