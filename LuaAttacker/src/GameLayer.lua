require("Cocos2d")

local GameLayer = class("GameLayer", function()
    return cc.Layer:create()
end)

function GameLayer:ctor()
    self._pathFinder = nil
    self._hero = nil
end

function GameLayer:init(mapFile)
    
    -- add map
    local tiledMap = cc.TMXTiledMap:create(mapFile)
    local obstacleLayer = tiledMap:getLayer("obstacle");
    print(obstacleLayer)
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

end


return GameLayer