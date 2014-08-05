
require "Cocos2d"

-- cclog
local cclog = function(...)
    print(string.format(...))
end

-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    cclog("----------------------------------------")
    cclog("LUA ERROR: " .. tostring(msg) .. "\n")
    cclog(debug.traceback())
    cclog("----------------------------------------")
    return msg
end

local function main()
    collectgarbage("collect")
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)
    
    cc.FileUtils:getInstance():addSearchPath("src")
    cc.FileUtils:getInstance():addSearchPath("res")
    cc.Director:getInstance():getOpenGLView():setDesignResolutionSize(960, 640, 0)
    
    --create scene 
--    local scene = require("GameScene")
--    local gameScene = scene.create()
--    gameScene:playBgMusic()
--    

--    local scene = cc.Scene:create()
--    local tiledMap = cc.TMXTiledMap:create("6.tmx")
--    tiledMap:setPosition(0, 0)
--    local layer = cc.Layer:create() 
--    layer:addChild(tiledMap)
--    scene:addChild(layer)
--    
--    local obj = tiledMap:getLayer("bg");
--    print(obj)
--    local id = obj:getTileGIDAt(cc.p(0,0))
--    print(id)
--    local size = obj:getMapTileSize()
--    print("maptilesize:",size.width, size.height)
--    size = obj:getLayerSize()
--    print("layersize:",size.width, size.height)
--    
--    size = tiledMap:getMapSize()
--    print("mapsize:",size.width, size.height)
--    size = tiledMap:getTileSize()
--    print("tilesize:",size.width, size.height)
--    local pos = obj:getPositionAt(cc.p(1,0))
--    print(pos.x, pos.y)
--    local group = tiledMap:getObjectGroup("property")
--    local point = group:getObject("zeropoint")
--    local x = point.x
--    local y = point.y
    --tiledMap:setPosition(-x, -y)
    local scene = require("GameScene")
    local gameScene = scene.createScene("6.tmx")
    --local layer = require("GameLayer").new()    
    --gameScene:addChild(layer)
    
--    local cache = cc.SpriteFrameCache:getInstance()
--    cache:addSpriteFrames("hero.plist")
--    local animFrames = {}
--    for i = 0, 3 do 
--        local frame = cache:getSpriteFrame(string.format("%02d.png", i) )
--        animFrames[i] = frame
--    end
--    local animation = cc.Animation:createWithSpriteFrames(animFrames, 0.1)
--    local animate = cc.Animate:create(animation);
--    --local hero = cc.Sprite:create()
--    local hero = cc.Sprite:create("dog.png")
--    hero:setPosition(62,48)
--    --hero:runAction(cc.RepeatForever:create(animate))
--    layer:addChild(hero)
    
    if cc.Director:getInstance():getRunningScene() then
        cc.Director:getInstance():replaceScene(gameScene)
    else
        cc.Director:getInstance():runWithScene(gameScene)
    end
end


local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    error(msg)
end
