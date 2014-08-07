local Package = class("Package", function()
    return {}
end)
local struct = require("struct")
local events = require("EventDef")

-- pack
function Package.packToPython(msg)
    return struct.pack("<Is", msg:len()+1, msg)
end

function Package.packCSLogin(name, password)
    return struct.pack("<HIsIs", events.MSG_CS_LOGIN, name:len()+1, name, 
        password:len()+1, password)
end

function Package.packCSMoveTo(fromx, fromy, tox, toy)
    return struct.pack("<Hiiii", events.MSG_CS_MOVETO, fromx, fromy, tox, toy)
end

function Package.packCSChat(text)
    return struct.pack("<HIs", events.MSG_CS_CHAT, text:len()+1, text)
end

function Package.packEventToMsg(event)
    if event.type == events.MSG_CS_LOGIN then
        return Package.packCSLogin(event.name, event.password)
    elseif event.type == events.MSG_CS_MOVETO then
        return Package.packCSMoveTo(event.fromx, event.formy, event.tox, event.toy)
    elseif event.type == events.MSG_CS_CHAT then
        return Package.packCSChat(event.text)
    end
    return nil
end

-- unpack
function Package.unpackPython(msg)
    return string.sub(msg,5)--struct.unpack("<Is", msg)--
end

function Package.unpackMsgType(msg)
    return struct.unpack("<Hs", msg)
end

function Package.unpackMsg(msg)
    local tag = Package.unpackMsgType(msg)
    if tag == events.MSG_SC_CONFIRM then
        return struct.unpack("<Hii", msg)       -- uid, result
        
    elseif tag == events.MSG_SC_MOVETO then
        return struct.unpack("<Hiiiii", msg)    -- uid, fromx, fromy, tox, toy
        
    elseif tag == events.MSG_SC_CHAT then
        return struct.unpack("<HiIs", msg)      -- uid, text
        
    elseif tag == events.MSG_SC_ADDUSER then
        return struct.unpack("<HiIsii", msg)    -- uid, name, x, y
        
    elseif tag == events.MSG_SC_DELUSER then
        return struct.unpack("<Hi", msg)        -- uid
    end
    return nil
end

function Package.unpackMsgToEvent(msg)
    return require("Event").createFromUnpack(Package.unpackMsg(msg))
end

return Package