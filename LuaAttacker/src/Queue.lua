local Queue = class("Queue", function()
    return {}
end)

function Queue:ctor()
    self.first = 0
    self.last = -1
end

function Queue:pushfirst(value)
    local first = self.first - 1
    self.first = first
    self[first] = value
end


function Queue:pushlast(value)
    local last = self.last + 1
    self.last = last
    self[last] = value
end

function Queue:popfirst()
    local first = self.first
    if first > self.last then return nil end
    local value = self[first]
    self[first] = nil
    self.first = first + 1
    return value
end

function Queue:poplast()
    local last = self.last
    if self.first > last then return nil end
    local value = self[last]
    self[last] = nil
    self.last = last - 1
    return value
end

function Queue:isempty()
    return self.last < self.first
end

return Queue