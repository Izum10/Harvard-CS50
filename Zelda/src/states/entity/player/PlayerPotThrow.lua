--[[
    State when player throws the pot
]]

PlayerPotThrow = Class{__includes=BaseState}

function PlayerPotThrow:init(player, dungeon)
    self.player = player
    self.dungeon = dungeon

    -- render offset for spaced character sprite
    self.player.offsetY = 5
    self.player.offsetX = 0

end

--[[
    Upon entering, change player animation to idle
]]
function PlayerPotThrow:enter(params)
    local direction = self.player.direction

    local pot = params.object
    self.player:changeAnimation('idle-'..direction)

    local nextX, nextY = pot.x , pot.y
    local xOffset, yOffset = 0, 0

    -- Determining where the next X/Y position of the pot will be after throw
    if direction == 'up' then
         nextY = math.max(nextY - (TILE_SIZE * 4), TOP_WALL_POSITION - TILE_SIZE)
    elseif direction == 'down' then
        nextY = math.min(nextY + (TILE_SIZE * 4), BOTTOM_WALL_POSITION)
    elseif direction == 'right' then
        nextX = math.min(nextX + (TILE_SIZE * 4), RIGHT_WALL_POSITION)
        xOffset = 1
        yOffset = 5
    elseif direction == 'left' then
        nextX = math.max(nextX - (TILE_SIZE * 4), LEFT_WALL_POSITION)
        xOffset = 1
        yOffset = 5
    end

    -- Setting X & Y offset for projectile render
    self.projectile = Projectile(GAME_OBJECT_DEFS['pot'], pot.x, pot.y, nextX, nextY, direction)
    self.projectile.xOffset = xOffset
    self.projectile.yOffset = yOffset
end

function PlayerPotThrow:update(dt)

    if self.projectile:isRendered() then
        self.projectile:update(dt)

        for k, entity in pairs(self.dungeon.currentRoom.entities) do
            if entity:collides(self.projectile) and not entity.dead then
                entity:damage(1)
                gSounds['hit-enemy']:play()
                self.projectile:markCollided()
                
                -- Random chance to generate heart
                if entity.dead and math.random(HEART_SPAWN_CHANCE) == 1 then
                    SpawnHeart(entity, self.dungeon.currentRoom.objects)
                end
                break
            end
        end
    else
        self.player:changeState('idle')
    end
end

function PlayerPotThrow:render()

    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))
    self.projectile:render()
end