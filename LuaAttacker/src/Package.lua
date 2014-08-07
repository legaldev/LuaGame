local Package = class("Package", function()
    return {}
end)
local struct = require("struct")
local events = require("EventDef")
function Package:ctor()
    self.msgType = {}
--
--    self.MSG_CS_LOGIN = 0x1001
--    self.MSG_SC_CONFIRM = 0x2001
--    
--    self.MSG_CS_MOVETO = 0x1002
--    self.MSG_SC_MOVETO = 0x2002
--    
--    self.MSG_CS_CHAT = 0x1003
--    self.MSG_SC_CHAT = 0x2003
--    
--    self.MSG_SC_ADDUSER = 0x2004
--    self.MSG_SC_DELUSER = 0x2005
end

function Package.packToPython(msg)
    return struct.pack("<Is", msg:len()+1, msg)
end

function Package.packCSLogin(name, password)
    return struct.pack("<HIsIs", events.MSG_CS_LOGIN, name:len()+1, name, 
        password:len()+1, password)
end

function Package.packCSMoveTo(x, y)
    return struct.pack("<Hii", events.MSG_CS_MOVETO, x, y)
end

function Package.packCSChat(text)
    return struct.pack("<HIs", events.MSG_CS_CHAT, text:len()+1, text)
end

function Package.unpackPython(msg)
    return string.sub(msg,5)--struct.unpack("<Is", msg)--
end

function Package.unpackMsgType(msg)
    return struct.unpack("<Hs", msg)
end

function Package.unpackMsg(msg)
    local tag = Package.unpackMsgType(msg)
    if tag == events.MSG_SC_CONFIRM then
        return struct.unpack("<Hii", msg)
        
    elseif tag == events.MSG_SC_MOVETO then
        return struct.unpack("<Hiii", msg)
        
    elseif tag == events.MSG_SC_CHAT then
        return struct.unpack("<HiIs", msg)
        
    elseif tag == events.MSG_SC_ADDUSER then
        return struct.unpack("<HiIsii", msg)
        
    elseif tag == events.MSG_SC_DELUSER then
        return struct.unpack("<Hi", msg)
    end
    return nil
end


return Package