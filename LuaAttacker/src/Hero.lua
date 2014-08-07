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
    
    -- struct
    local mypack = require("Package")
    local events = require("EventDef")
    local strcut = require("struct")
    local name = "hero"
    local icon = 1 
    local msg = struct.pack("<HIsi", events.MSG_CS_LOGIN, name:len()+1, name, icon)
    print(string.format("msg: %q", msg))
    
    -- socket
--    self._tcp = require("TCPClient").new()
--    assert(self._tcp:connectTo('127.0.0.1', 2000))

    
--    local count = 0
--    local mount = 100
    
--    function update(dt)
--        self._tcp:process()
--        local response = self._tcp:recv()
--        if response then
--            print(string.format("receive: %q", response))
--            local event = require("Event")
--            local oneevent = event.create(mypack.unpackMsg(response)) 
--            print(oneevent.uid, oneevent.result)
--            local msgType = mypack.unpackMsgType(response)
--            if msgType == events.MSG_SC_CONFIRM then
--                local msgT, uid, result = mypack.unpackMsg(response)
--                print('uid=', uid, 'result=', result) 
--            elseif msgType == events.MSG_SC_MOVETO then
--                local msgT, uid, x, y = mypack.unpackMsg(response)
--                print('uid=', uid, 'x=', x, 'y=', y) 
--            elseif msgType == events.MSG_SC_CHAT then
--                local msgT, uid, textlen, text = mypack.unpackMsg(response)
--                print('uid=', uid, 'text=', text)
--            elseif msgType == events.MSG_SC_ADDUSER then
--                local msgT, uid, namelen, name, x, y = mypack.unpackMsg(response)
--                print('uid=', uid, 'name=', name, 'x=', x, 'y=', y)
--            elseif msgType == events.MSG_SC_DELUSER then
--                local msgT, uid = mypack.unpackMsg(response)
--                print('uid=', uid)
--            end
--        end 
--        
--        if count > mount then
--            --local msg = mypack.packCSChat("hello i am client")
--            local msg = mypack.packCSLogin("hero", "123456")
--            self._tcp:send(msg)
--            print(string.format("send: %q", msg))
--            count = 0
--        else
--            count = count + 1
--        end
--        
--    end
--    self:scheduleUpdateWithPriorityLua(update, 0)
    
    
    
--    self._sock = assert(require("socket").connect('127.0.0.1', 2000))
--    self._sock:settimeout(0)
--    local data1 = "user".."12  3456"
--    local data2 = "12  3456"
--    local p = struct.pack('<Is', data1:len()+1, data1)
--    while true do
--        local recvt, sendt, status = socket.select({self._sock}, nil, 1)
--        if #recvt > 0 then
--            local response, receive_status = self._sock:receive()
--            local i = strcut.unpack('<I', response)
--            local data = string.sub(response,5)
--            print(i, data)
--            break
--        end
--    end 
--    
--    
--    local count = 0
--    local mount = 100
--    function update(dt)
--        -- send
--        local recvt, sendt, status = socket.select(nil, {self._sock}, 0.001)
--        if #sendt > 0 and count > mount then
--            --p = mypack:packCSLogin("hero", "123456")
--            --p = mypack:packCSMoveTo(1,2)
--            p=mypack.packCSChat("hello i am client")
--            self._sock:send(p)
--            print(string.format("send: %q", p))
--            count = 0
--        else
--            count = count + 1 
--        end
--        
--        -- recv
--        local recvt, sendt, status = socket.select({self._sock}, nil, 0.001)
--        if #recvt > 0 then
--            local response, receive_status = self._sock:receive()
--            if response then
--                print(string.format("receive: %q", response))
--                local msgType = mypack.unpackServerMsg(response)
--                local msgType = mypack.unpackMsgType(mypack.unpackPython(response))
--                if msgType == events.MSG_SC_CONFIRM then
--                    local msgT, uid, result = mypack.unpackServerMsg(response)
--                    print('uid=', uid, 'result=', result) 
--                elseif msgType == events.MSG_SC_MOVETO then
--                    local msgT, uid, x, y = mypack.unpackServerMsg(response)
--                    print('uid=', uid, 'x=', x, 'y=', y) 
--                elseif msgType == events.MSG_SC_CHAT then
--                    local msgT, uid, textlen, text = mypack.unpackServerMsg(response)
--                    print('uid=', uid, 'text=', text)
--                elseif msgType == events.MSG_SC_ADDUSER then
--                    local msgT, uid, namelen, name, x, y = mypack.unpackServerMsg(response)
--                    print('uid=', uid, 'name=', name, 'x=', x, 'y=', y)
--                elseif msgType == events.MSG_SC_DELUSER then
--                    local msgT, uid = mypack.unpackServerMsg(response)
--                    print('uid=', uid)
--                end
----                local i = struct.unpack('<Is', response)
----                local data = string.sub(response,5)
----                print(string.format("%q", data))
----                print('receive: %q', i, data)
--            end
--        end
--    end
--    self:scheduleUpdateWithPriorityLua(update, 0)
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