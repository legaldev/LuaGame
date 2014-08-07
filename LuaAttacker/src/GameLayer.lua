require("Cocos2d")

local GameLayer = class("GameLayer", function()
    return cc.Layer:create()
end)

function GameLayer:ctor()
    self._pathFinder = nil
    self._hero = nil
    self._otherheros = {}
end

function GameLayer:init(mapFile)
    
    -- add map
    local tiledMap = cc.TMXTiledMap:create(mapFile)
    local obstacleLayer = tiledMap:getLayer("obstacle");
    tiledMap:setPosition(0, 0)
    self:addChild(tiledMap)
    
    -- add hero
    self._hero = require("Hero").new()
    self:addChild(self._hero)

    
    -- set path finder
    self._pathFinder = require("PathFinder").new()
    self._pathFinder:init(obstacleLayer)
    local tt = obstacleLayer:getPositionAt(cc.p(1, 0))
    
    -- set user touch
    self.touchListener = cc.EventListenerTouchOneByOne:create()
    self.touchListener:setSwallowTouches(true)
    
    local function onTouchBegan(touch, event)
        print(touch:getLocation().x, touch:getLocation().y)
        local startPos = {x=self._hero:getPositionX(), y=self._hero:getPositionY()}
        local endPos = {x=touch:getLocation().x, y=touch:getLocation().y}
        local path = self._pathFinder:findPath(startPos, endPos)
        if path then
            self._hero:MoveByPath(path, 300)
        end
        return true
    end
    
    self.touchListener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchListener, self)
    
    -- socket
    self._tcp = require("TCPClient").new()
    assert(self._tcp:connectTo('127.0.0.1', 2000))

    local count = 0
    local mount = 100
    
    -- login
    self._isLogin = false;
    
    function update(dt)
        self._tcp:process()
        local response = self._tcp:recv()
        if response then
            print(string.format("receive: %q", response))
            local oneevent = require("Event").unpack(response)
            local events = require("EventDef")
            local msgType = oneevent.type
            if msgType == events.MSG_SC_CONFIRM then
                self:SCConfirmEvent(oneevent)
            elseif msgType == events.MSG_SC_MOVETO then
                self:SCMoveToEvent(oneevent)
            elseif msgType == events.MSG_SC_CHAT then
                self:SCChatEvent(oneevent)
            elseif msgType == events.MSG_SC_ADDUSER then
                self:SCAdduserEvent(oneevent)
            elseif msgType == events.MSG_SC_DELUSER then
                self:SCDeleteEvent(oneevent)
            end
        end 
        
        if count > mount then
            --local msg = mypack.packCSChat("hello i am client")
            --local msg = mypack.packCSLogin("hero", "123456")
            --p = mypack.packCSLogin("hero", "123456")
            local event = require("Event").new()
            local eventdef = require("EventDef")
            event.name = 'he\nro'
            event.password = '123456'
            event.type = eventdef.MSG_CS_LOGIN
            --local msg = mypack.packCSMoveTo(1, 2, 3, 4)
            --local msg = mypack.packCSChat("hello i am client")
            local msg = event:pack()
            self._tcp:send(msg)
            print(string.format("send: %q", msg))
            count = 0
        else
            count = count + 1
        end
        
    end
    self:scheduleUpdateWithPriorityLua(update, 0)

end

function GameLayer:SCConfirmEvent(oneevent)
    print('uid=', oneevent.uid, 'result=', oneevent.result)
    print('login succeed')
    self._isLogin = true
    self._uid = oneevent.uid 
end

function GameLayer:SCMoveToEvent(oneevent)
    print('uid=', oneevent.uid, 'fromx=', oneevent.fromx, 'fromy=', oneevent.fromy,
        'tox=', oneevent.tox, 'toy=', oneevent.toy) 
end

function GameLayer:SCChatEvent(oneevent)
    print('uid=', oneevent.uid, 'text=', oneevent.text)
end

function GameLayer:SCAdduserEvent(oneevent)
    print('uid=', oneevent.uid, 'name=', oneevent.name, 'x=', oneevent.x, 'y=', oneevent.y)
end

function GameLayer:SCDeleteEvent(oneevent)
    print('uid=', oneevent.uid)
end  

return GameLayer