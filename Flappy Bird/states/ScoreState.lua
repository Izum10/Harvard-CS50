--[[
    
    A simple state used to display the player's score before they
    transition back into the play state. Transitioned to from the
    PlayState when they collide with a Pipe.
]]

ScoreState = Class{__includes = BaseState}


local Bronze_award = love.graphics.newImage('b_trophy.png') 
local Silver_award = love.graphics.newImage('s_trophy.png')
local Gold_award = love.graphics.newImage('g_trophy.png')

--[[
    When we enter the score state, we expect to receive the score
    from the play state so we know what to render to the State.
]]
function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play')
    end
end

function ScoreState:render()
    -- simply render the score to the middle of the screen
   love.graphics.setFont(flappyFont)

if self.score >-2 and self.score < 5 then
    love.graphics.draw(Bronze_award, VIRTUAL_WIDTH/2, VIRTUAL_HEIGHT/2, 0, 1, 1, Bronze_award:getWidth()/2, Bronze_award:getHeight()/2)
    love.graphics.printf('Congrats You Reached Bronze', 0, 64, VIRTUAL_WIDTH, 'center') -- bronze
elseif self.score >-5 and self.score < 10 then
    love.graphics.draw(Silver_award, VIRTUAL_WIDTH/2, VIRTUAL_HEIGHT/2, 0, 1, 1, Silver_award:getWidth()/2, Silver_award:getHeight()/2)
    love.graphics.printf('Congrats You Reached Silver', 0, 64, VIRTUAL_WIDTH, 'center') -- silver
elseif self.score >-10 then
    love.graphics.draw(Gold_award, VIRTUAL_WIDTH/2, VIRTUAL_HEIGHT/2, 0, 1, 1, Gold_award:getWidth()/2, Gold_award:getHeight()/2)
love.graphics.printf('Congrats you Reached Gold', 0, 64, VIRTUAL_WIDTH, 'center') -- gold
else
    love.graphics.printf('Oof! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')
end

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')
    
    love.graphics.setFont(mediumFont)
    love.graphics.printf('Press Enter to Play Again!', 0, 160, VIRTUAL_WIDTH, 'center')
end