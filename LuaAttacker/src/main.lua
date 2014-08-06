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
    

    
    local strcut = require("struct")
    local pack = struct.pack('<HHss', 1, 1, "user", "123456")
    local unpack1, unpack2, unpack3, unpack4 = struct.unpack('<HHss', pack)
    print(unpack1, unpack2, unpack3, unpack4)
    
    local data1 = "user".."12  3456"
    local data2 = "12  3456"
    local p = struct.pack('<IsI', data1:len(), data1, 12)
    local i, s, i2 = struct.unpack('<IsI', p)
    print('datallen '..i..' int '..i2)
 
    -- test socket
--    local socket = require("socket")
--    print(socket._VERSION)
--    local sock = assert(socket.connect('127.0.0.1', 2000))
--    sock:settimeout(0)
-- 
--    while true do
--        local recvt, sendt, status = socket.select({sock}, nil, 1)
--        if #recvt > 0 then
--            local response, receive_status = sock:receive()
--            local i = struct.unpack('<I', response)
--            local data = string.sub(response,5)
--            print(i, data)
--            break
--        end
--    end 
-- 
--    while true do 
--        local recvt, sendt, status = socket.select(nil, {sock}, 1)
--       
--        if #sendt > 0 then
--            sock:send(p)
--            break
--        end
--    end
--    
--    while true do
--        local recvt, sendt, status = socket.select({sock}, nil, 1)
--        if #recvt > 0 then
--            local response, receive_status = sock:receive()
--            local i = struct.unpack('<I', response)
--            local data = string.sub(response,5)
--            print(i, data)
--            break
--        end
--    end
    
--    while #recvt > 0 do
--        local response, receive_status = sock:receive()
--        print(response)
--        do break end
--        if receive_status ~= "closed" then
--            if response then
--                print(response)
--                recvt, sendt, status = socket.select({sock}, nil, 1)
--            end
--        else
--            print(rBuf)
--            break
--        end
--    end
        --local chunk, status, partial = sock:receive()
        --print(chunk, status, partial, os.clock())
--    until status == nil
--    sock:close()
--    print('closed', os.clock())
    --do return end
    
    
    
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
