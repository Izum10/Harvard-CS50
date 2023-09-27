--[[
    GD50
    Legend of Zelda
    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Projectile = Class{}

function Projectile:init(def, startX, startY, endX, endY, direction)

    -- string identifying this object type
    self.type = def.type

    self.texture = def.texture
    self.frame = def.frame or 1

    self.defaultState = def.defaultState
    self.state = self.defaultState
    self.states = def.states

    -- dimensions
    self.width = def.width
    self.height = def.height

    -- start and end X & Y positions
    self.endX = math.floor(endX)
    self.endY = math.floor(endY)
    self.x = startX
    self.y = startY

    self.hasReachedEnd = false
    self.hasCollided = false

    -- Render offsets set to 0 by default
    self.xOffset = 0
    self.yOffset = 0

    -- determine the projectile moving speed based on direction
    self.dx, self.dy = 0, 0

    if direction == 'up' then
        self.dy = -PROJECTILE_SPEED
    elseif direction == 'down' then
        self.dy = PROJECTILE_SPEED
    elseif direction == 'left' then
        self.dx = -PROJECTILE_SPEED
    elseif direction == 'right' then
        self.dx = PROJECTILE_SPEED
    end

end

function Projectile:update(dt)

    if self:isRendered() then
        self.x = self.x + (self.dx * dt)
        self.y = self.y + (self.dy * dt)
        
        if math.abs(math.floor(self.x) - self.endX) < 5 and math.abs(math.floor(self.y) - self.endY) < 5 then
            self.hasReachedEnd = true
            gSounds['wall-crash']:play()
        end
        
    end

end

function Projectile:render()
    if self:isRendered() then
        love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.states[self.state].frame or self.frame],
            self.x + self.xOffset , self.y + self.yOffset)
    end
end

--[[
    Set projectile as collided with an object
]]
function Projectile:markCollided()
    self.hasCollided = true
end

--[[
    Function to check if projectile should be rendered or not
]]
function Projectile:isRendered()
    return not(self.hasCollided or self.hasReachedEnd)
end