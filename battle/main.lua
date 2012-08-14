require '../common/list'

char = { name='LJ', hp=100, maxHp=100, ap=10, maxAp=20, attack = { name="Downhill Strike", cost=12, timer=3 }}

attackQueue = linkedList:new()
enemies = { }

function r_print(t, indent)
    indent = indent or 0
    if type(t) == 'table' then
        for k,v in pairs(t) do
            if type(v) == '_table' then
                print( ('  '):rep(indent) .. k .. ' (') 
                r_print(v, indent+1)
                print( ('  '):rep(indent) .. ')') 
            else 
               print( ('  '):rep(indent) .. k .. ' = ' .. tostring(v))
            end
        end
    end
end

function love.load()
    charFont = love.graphics.newFont( 12 )
    attackFont = love.graphics.newFont( 12 )
end

function love.draw()
    love.graphics.push()
    -- love.graphics.scale(2, 2)
    love.graphics.print("Hello, LÖVE", 0, 10)
    drawPlayer(char, 10, 250)
    drawAttacks(50, 200)
    love.graphics.pop()
end

function drawAttacks(x, y)
    local h = attackFont:getHeight() + 4
    -- love.graphics.setFont(attackFont)
    for atk in attackQueue:iter() do
        local maxW = attackFont:getWidth(atk.attack.name) + 10
        local w = maxW*atk.timer/atk.attack.timer
        
        love.graphics.setColor(16, 96, 255)
        love.graphics.rectangle('fill', x, y, w, h/2)
        love.graphics.setColor(10, 58, 153)
        love.graphics.rectangle('fill', x, y+h/2, w, h/2)
        love.graphics.setColor(158, 187, 247)
        love.graphics.rectangle('line', x, y, maxW+1, h+1)
        love.graphics.print(atk.attack.name, x + 5, y + h - 2)
        x = x + maxW + 3
    end
end

function drawPlayer(char, x, y)
    
    local hpX = x - 3
    local hpY = y + 12
    local hpMaxW = 200
    local hpW = hpMaxW*char.hp/char.maxHp
    local apX = x - 3
    local apY = y + 27
    local apMaxW = 200
    local apW = apMaxW*char.ap/char.maxAp
    
    white = {255, 255, 255}
    love.graphics.setColor(unpack(white))
    love.graphics.print(char.name, x, y);
    
    love.graphics.setColor(16, 96, 255)
    love.graphics.rectangle('fill', hpX, hpY, hpW, 5)
    love.graphics.setColor(10, 58, 153)
    love.graphics.rectangle('fill', hpX, hpY+5, hpW, 5)
    love.graphics.setColor(158, 187, 247)
    love.graphics.rectangle('line', hpX, hpY, hpMaxW+1, 11)
    
    love.graphics.setColor(255, 221, 0)
    love.graphics.rectangle('fill', apX, apY, apW, 5)
    love.graphics.setColor(173, 150, 0)
    love.graphics.rectangle('fill', apX, apY+5, apW, 5)
    love.graphics.setColor(158, 187, 247)
    love.graphics.rectangle('line', apX, apY, apMaxW+1, 11)
end

function love.update(dt)
    char.ap = math.min(char.ap + 10*dt, char.maxAp)
    
    if attackQueue.first then
        local attack = attackQueue.first.value
        attack.timer = attack.timer - dt
        if attack.timer <= 0 then
            local atk = attackQueue:popFirst()
            print(atk.attack.name)
        end
    end
end

function love.keypressed(key, unicode)
    if  key == 'escape' then
        love.event.push('q')
    elseif key == 'z' then
        if char.ap > char.attack.cost then
            char.ap = char.ap - char.attack.cost
            attackQueue:pushLast( {attack = char.attack, timer=char.attack.timer} )
        end
    end
end