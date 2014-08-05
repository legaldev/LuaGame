local PathFinder = class("PathFinder",function()
    return {}
end)

function PathFinder:ctor()
    self.layer = nil
    self.tileSize = nil
    self.layerSize = nil
    self.dir = { {x=-1, y=0}, {x=1, y=0}, {x=0, y=-1}, {x=0, y=1} }
end

function PathFinder:init(mapObstacleLayer)
    self.layer = mapObstacleLayer;
    self.tileSize = mapObstacleLayer:getMapTileSize()
    self.layerSize = mapObstacleLayer:getLayerSize()   
    -- build a table about obstacle obj
    
end

-- A* method to find path
function PathFinder:findPath(startPos, endPos)
    local startTile = self:GetTileCoordinate(startPos)
    local endTile = self:GetTileCoordinate(endPos)
    
    startTile.parent = nil;
    startTile.G = 0;
    local close = {startTile}
    local succeed = false
    local open = {}
    
    local deadLoop = 0
    
    while true do
        if deadLoop > 500 then
            print "find path loop over 200 times."
            succeed = false
            break
        end
        
        -- check end
        if close[#close].x == endTile.x and close[#close].y == endTile.y then
            print "find path succeed"
            succeed = true
            break
        end
        
        -- add open tile
        for i=1, #self.dir do
            local newTile = {x=0, y=0}
            newTile.x = close[#close].x+self.dir[i].x 
            newTile.y = close[#close].y+self.dir[i].y
            
            if  newTile.x >= 0 and 
                newTile.x < self.layerSize.width and
                newTile.y >= 0 and
                newTile.y < self.layerSize.height and
                not self:findTileInTable(newTile, close) and
                self.layer:getTileGIDAt(cc.p(newTile.x, newTile.y)) == 0 then
               
                -- calc F = H + G, G = now - start, H = end - now
                newTile.G = math.abs(newTile.x - startTile.x) + math.abs(newTile.y - startTile.y) +
                    close[#close].G;
                newTile.H = math.abs(newTile.x - endTile.x) + math.abs(newTile.y - endTile.y)
                -- if not in open, add it, else update G
                local openTile = self:findTileInTable(newTile, open)
                if not openTile then
                    newTile.parent = close[#close]
                    newTile.F = newTile.G + newTile.H
                    table.insert(open, newTile)
                else
                    if(newTile.G < openTile.G) then
                        openTile.parent = close[#close]
                        openTile.G = newTile.G
                        openTile.F = openTile.G + openTile.H
                    end
                end                
            end             
        end     -- add open tile
        
        -- find next tile
        local nextTile = nil
        local minF = math.huge
        local deleteK = nil
        for k, tile in pairs(open) do
            if tile.F <= minF then
                minF = tile.F
                nextTile = tile
                deleteK = k
            end
        end
        table.remove(open, deleteK)
        table.insert(close, nextTile)     
        deadLoop = deadLoop + 1   
    end
    
    -- find path
    if succeed then
        local path = {}
        local child = close[#close]
        while child do
            local pos = {}
            pos.x = child.x * self.tileSize.width
            pos.y = (self.layerSize.height-1-child.y) * self.tileSize.height
            table.insert(path, 1, pos)
            child = child.parent
        end
        return path
    end
    return nil
end

function PathFinder:GetTileCoordinate(scenePos)
    tileCoord = {}
    tileCoord.x = math.floor(scenePos.x / self.tileSize.width)
    tileCoord.x = math.max(0, math.min(self.layerSize.width-1, tileCoord.x))
    tileCoord.y = math.floor(scenePos.y / self.tileSize.height)
    tileCoord.y = self.layerSize.height-1 - math.max(0, math.min(self.layerSize.height-1, tileCoord.y))
    return tileCoord
end

function PathFinder:findTileInTable(tile, tileTable)
    for k, v in pairs(tileTable) do
        if tile.x == v.x and tile.y == v.y then
            return v
        end
    end
    return nil
end

return PathFinder