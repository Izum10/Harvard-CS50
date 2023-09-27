--[[
    Player state when attempting to lifting the pot
]]

PlayerPotLiftState = Class{__includes = BaseState}

function PlayerPotLiftState:init(player, dungeon)
    self.player = player
    self.dungeon = dungeon
end


function PlayerPotLiftState:update(dt)
    
    local collidingPot = nil
    self.player:changeAnimation('pot-pick-' .. self.player.direction)

    for k, object in pairs(self.dungeon.currentRoom.objects) do
        if self.player:collides(object) and object.solid then
            collidingPot = object
            table.remove(self.dungeon.currentRoom.objects, k)
            break
        end
    end

    if collidingPot then
        self.player.currentAnimation.timesPlayed = 0
        self.player:changeStateWithParams('pot-idle', {
            object = collidingPot
        })
    end

    if self.player.currentAnimation.timesPlayed > 0 then
        self.player.currentAnimation.timesPlayed = 0
        self.player:changeState('idle')
    end
end

function PlayerPotLiftState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))
end