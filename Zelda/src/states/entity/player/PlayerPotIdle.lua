--[[
    Idle state with pot on player
]]

PlayerPotIdle = Class{__includes=EntityIdleState}


function PlayerPotIdle:init(player)
    self.entity = player
end

function PlayerPotIdle:enter(params)

    self.pot = params.object
end

function PlayerPotIdle:update(dt)

    self.entity:changeAnimation('pot-idle-' .. self.entity.direction)

    self.pot.x = self.entity.x
    self.pot.y = self.entity.y - self.pot.height + POT_PLAYER_HEAD_YOFFSET

    EntityIdleState.update(self, dt)

    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeStateWithParams('pot-walking', {
            object = self.pot
        })
    

    else if love.keyboard.wasPressed('w') then
        self.entity:changeStateWithParams('pot-throw', {
            object = self.pot
        })
        end
    end
end

--[[
    Render entity idle and the pot on top
]]
function PlayerPotIdle:render()
    self.pot:render(0, 0)
    EntityIdleState.render(self)
end