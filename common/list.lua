linkedList = {}

function linkedList:new(l)
    l = l or { first=nil, last=nil }
    setmetatable(l, self)
    self.__index = self
    return l
end

function linkedList:iter()
    local i = self.first
    return function()
        if i then 
            local value = i.value
            i = i.next
            return value 
        end
    end 
end

function linkedList:pushFirst (v)
    local oldFirst = self.first
    self.first = { value=v, next=oldFirst, prev=nil }
    if oldFirst then oldFirst.prev = self.first end
    if self.last == nil then self.last = self.first  end
end

function linkedList:pushLast (v)
    local oldLast = self.last
    self.last = { value=v, next=nil, prev=oldLast }
    if oldLast then oldLast.next = self.last end
    if self.first == nil then self.first = self.last end
end

function linkedList:popFirst()
    local first = self.first
    self.first = first.next
    if self.last == first then self.last = nil end
    return first.value
end

function linkedList:popLast()
    local last = self.last
    self.last = last.prev
    if self.first == last then self.first = nil end
    return last.value
end


return linkedList