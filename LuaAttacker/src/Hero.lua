local Hero = class("Hero", function()
    return cc.Sprite:create()
end)

function Hero:ctor()
    self:init()
end

function Hero:init()
    local cache = cc.SpriteFrameCache:getInstance()
    cache:addSpriteFrames("hero.plist")
    local animFrames = {}
    for i = 0, 3 do 
        local frame = cache:getSpriteFrame(string.format("%02d.png", i) )
        animFrames[i] = frame
    end
    local animation = cc.Animation:createWithSpriteFrames(animFrames, 0.1)
    local animate = cc.Animate:create(animation);

    self:setPosition(62,48)
    self:runAction(cc.RepeatForever:create(animate))
end

function Hero:MoveByPath(path, speed)
    local curpos = {x=0, y=0}
    curpos.x, curpos.y = self:getPosition()
    local newpos = {x=path[1].x, y=path[1].y}
    local time = math.sqrt( math.pow(newpos.y - curpos.y,2) + 
                            math.pow(newpos.x - curpos.x, 2)) / speed
    local  pMove = cc.MoveTo:create(time, cc.p(newpos.x, newpos.y))
    local  pSequence = cc.Sequence:create(pMove)
    for i=1, #path-1 do
        curpos = path[i]
        newpos = path[i+1]
        time = math.sqrt(math.pow(newpos.y - curpos.y,2) + 
                         math.pow(newpos.x - curpos.x, 2)) / speed
        --time = 
        pMove = cc.MoveTo:create(time, cc.p(newpos.x, newpos.y))
        pSequence = cc.Sequence:create(pSequence, pMove)
    end
    self:runAction(pSequence)
end

return Hero