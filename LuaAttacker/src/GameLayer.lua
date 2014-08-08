require("Cocos2d")
local scheduler = cc.Director:getInstance():getScheduler()
local GameLayer = class("GameLayer", function()
    return cc.Layer:create()
end)

GameLayer._hero = nil
GameLayer._heros = {}
GameLayer._heroSpeed = 300
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
    self._heros = {}
    self._hero = require("Hero").new()
    self._hero:setPosition(0, 0)
    self:addChild(self._hero)
    --table.insert(self._heros, hero)

    -- set path finder
    self._pathFinder = require("PathFinder").new()
    self._pathFinder:init(obstacleLayer)
    local tt = obstacleLayer:getPositionAt(cc.p(1, 0))
    
    -- set user touch
    self.touchListener = cc.EventListenerTouchOneByOne:create()
    self.touchListener:setSwallowTouches(true)
    
    -- socket
    local eventdef = require("EventDef")local eventdef = require("EventDef")
    self._tcp = require("TCPClient").new()
    self._tcp:connectTo('127.0.0.1', 2000)

    local count = 0
    local mount = 100
    
    local function onTouchBegan(touch, event)
--        local sendEvent = require("Event").new()
--        sendEvent.type = eventdef.MSG_CS_MOVETO
--        sendEvent.fromx, sendEvent.fromy = self._hero:getPosition()
--        sendEvent.tox, sendEvent.toy = touch:getLocation().x, touch:getLocation().y
--        print("move to ", sendEvent.tox, sendEvent.toy)
--        local msg = sendEvent:pack()
--        self._tcp:send(msg)
--        print(string.format("send: %q", msg))
        local startPos = cc.p(self._hero:getPositionX(), self._hero:getPositionY())
        local endPos = cc.p(touch:getLocation().x, touch:getLocation().y)
        self._hero:Move(startPos, endPos, self._heroSpeed)
--        local path = self._pathFinder:findPath(startPos, endPos)
--        if path then
--            self._hero:MoveByPath(path, GameLayer._heroSpeed)
--        end
        
        return true
    end
    
    self.touchListener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchListener, self)
    
    
    -- login
    self._isLogin = false;
    local event = require("Event").new()
    event.name = 'netease0'
    event.password = '163'
    event.type = eventdef.MSG_CS_LOGIN
    local msg = event:pack()
    self._tcp:send(msg)
    
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
    end
    self:scheduleUpdateWithPriorityLua(update, 0)
    
    -- inform server current pos
    function informPos()
        local sendEvent = require("Event").new()
        sendEvent.type = eventdef.MSG_CS_MOVETO
        sendEvent.fromx, sendEvent.fromy = self._hero:getPosition()
        sendEvent.tox, sendEvent.toy = sendEvent.fromx, sendEvent.fromy
        local msg = sendEvent:pack()
        self._tcp:send(msg)
        print(string.format("send: %q", msg))
    end
    scheduler:scheduleScriptFunc(informPos, 0.2, false)
    
end

function GameLayer:SCConfirmEvent(oneevent)
    if oneevent.result > 0 then
        print('login succeed uid=', oneevent.uid, 'result=', oneevent.result)
    else
        print('login failed uid=', oneevent.uid, 'result=', oneevent.result)
    end
    self._isLogin = true
    self._hero.uid = oneevent.uid
end

function GameLayer:SCMoveToEvent(oneevent)
    print('server move to uid=', oneevent.uid, 'fromx=', oneevent.fromx, 'fromy=', oneevent.fromy,
        'tox=', oneevent.tox, 'toy=', oneevent.toy) 
    if self._heros[oneevent.uid] then
        local hero = self._heros[oneevent.uid]
        local startp = cc.p(hero:getPositionX(), hero:getPositionY())--cc.p(oneevent.fromx, oneevent.fromy)
        local endp = cc.p(oneevent.tox, oneevent.toy)
        hero:Move(startp, endp, self._heroSpeed)
    end
end

function GameLayer:SCChatEvent(oneevent)
    print('uid=', oneevent.uid, 'text=', oneevent.text)
end

function GameLayer:SCAdduserEvent(oneevent)
    print('add useruid=', oneevent.uid, 'name=', oneevent.name, 'x=', oneevent.x, 'y=', oneevent.y)
    
    if oneevent.uid ~= self._hero.uid then
        local hero = require("Hero").new()
        hero:setPosition(oneevent.x, oneevent.y)
        self._heros[oneevent.uid] = hero
        self:addChild(hero)
    end
end

function GameLayer:SCDeleteEvent(oneevent)
    print('remove uid=', oneevent.uid)
    local hero = self._heros[oneevent.uid]
    self:removeChild(hero, true)
    self._heros[oneevent.uid] = nil
end  


return GameLayer