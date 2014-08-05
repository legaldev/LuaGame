local GameScene = class("GameScene", function()
    return cc.Scene:create()
end)

function GameScene.createScene(mapFile)
    local scene = GameScene.new()
    local layer = require("GameLayer").new()
    layer:init(mapFile)
    scene:addChild(layer)
    return scene
end

return GameScene