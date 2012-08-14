require 'enemy'
require '../common/list'

local delta, timesum, timecount

local updating = 0

local enemies = linkedList:new()
local me = player:new()

local colors = {
    me = { 255, 255, 255 },
    enemy = { 255, 0, 0}
}

local enemyFont = love.graphics.newFont(8)
local debugFont = love.graphics.newFont(11)

function love.load()
    local w, h, f, v, fsaa

    w, h, f, v, fsaa = love.graphics.getMode()


    delta = 0
    timesum = 0
    timecount = 0

    me.x = w/2
    me.y = h/2

    love.graphics.setPoint(5, "smooth")

    for i=1,100 do
        enemies:pushLast(enemy:new(math.random(w), math.random(h)))
    end
end



function love.draw()
    love.graphics.setFont(enemyFont)
    love.graphics.setColor(unpack(colors.enemy))
    for e in enemies:iter() do
        love.graphics.point(e.x, e.y)
        -- love.graphics.print(string.format("(%3d,%3d)", e.x, e.y), e.x, e.y)
    end

    
    local s
    if updating > 0 then
        s = "updating"
    else
        s = "paused"
    end

    love.graphics.setColor(unpack(colors.me))
    love.graphics.point(me.x, me.y)

    love.graphics.setFont(debugFont)

    pos = string.format("p:{%3d,%d} s:{%d,%d}", me.x, me.y, me.sx, me.sy)
    love.graphics.print(string.format("fps = %d\n%s\n%s", delta, s, pos), 0, 0)
    

end

function love.update(dt)
    timesum = timesum + dt
    timecount = timecount + 1

    if timesum > 0.5 then
        delta = math.floor(timecount/timesum)
        timecount = 0
        timesum = 0
    end

    if updating > 0 then
        me:update(dt)

        for e in enemies:iter() do
            e:update(dt)
        end
    end
end

keypress_callback = {
    w = function() 
        updating = updating + 1
        me.sy = me.sy - me.speed
    end,
    a = function()
        updating = updating + 1
        me.sx = me.sx - me.speed
    end,
    d = function()
        updating = updating + 1
        me.sx = me.sx + me.speed
    end,
    s = function()
        updating = updating + 1
        me.sy = me.sy + me.speed
    end

}

keyrelease_callback = {
    w = function()
        updating = updating - 1
        me.sy = me.sy + me.speed        
    end,
    a = function()
        updating = updating - 1
        me.sx = me.sx + me.speed
    end,
    d = function()
        updating = updating - 1
        me.sx = me.sx - me.speed
    end,
    s = function()
        updating = updating - 1
        me.sy = me.sy - me.speed
    end
}

function love.keypressed(key, unicode)
    if keypress_callback[key] then
        keypress_callback[key]()
    end
end

function love.keyreleased(key)
    if keyrelease_callback[key] then
        keyrelease_callback[key]()
    end
end