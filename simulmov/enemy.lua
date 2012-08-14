enemy = {}
player = {}

function enemy:new(x, y)
    l = { 
        x = x or 0, 
        y = y or 0, 
        dir = math.random()*2*math.pi, 
        speed = math.random(50)+100 -- base speed, 200 pixels per second
    } 
    setmetatable(l, self)
    self.__index = self
    return l
end

function enemy:update(dt)
    local dx, dy

    dx = math.cos(self.dir)*self.speed*dt
    dy = math.sin(self.dir)*self.speed*dt


    self.x = self.x + dx
    self.y = self.y + dy

    if math.random() > 0.99 then
        self.dir = math.random()*math.pi*2
    end
end

function player:new(x, y)
    u = enemy:new(x,y)
    u.sx = 0
    u.sy = 0
    u.speed = 10 -- in pixels per second
    setmetatable(u, self)
    self.__index = self
    return u
end

function player:update(dt)

    dx = self.sx*self.speed*dt
    dy = self.sy*self.speed*dt

    self.x = self.x + dx
    self.y = self.y + dy
end