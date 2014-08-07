local Package = class("Package", function()
    return {}
end)
local struct = require("struct")
function Package:ctor()
    self.msgType = {}

    self.MSG_CS_LOGIN = 0x1001
    self.MSG_SC_CONFIRM = 0x2001
    
    self.MSG_CS_MOVETO = 0x1002
    self.MSG_SC_MOVETO = 0x2002
    
    self.MSG_CS_CHAT = 0x1003
    self.MSG_SC_CHAT = 0x2003
    
    self.MSG_SC_ADDUSER = 0x2004
    self.MSG_SC_DELUSER = 0x2005
end

function Package:packToPython(msg)
    return struct.pack("<Is", msg:len()+1, msg)
end

function Package:packCSLogin(name, password)
    return self:packToPython(
        struct.pack("<HIsIs", self.MSG_CS_LOGIN, name:len()+1, name, 
        password:len()+1, password))
end

function Package:packCSMoveTo(x, y)
    return self:packToPython(
            struct.pack("<Hii", self.MSG_CS_MOVETO, x, y))
end

function Package:packCSChat(text)
    return self:packToPython(
            struct.pack("<HIs", self.MSG_CS_CHAT, text:len()+1, text))
end

function Package:unpackPython(msg)
    return string.sub(msg,5)--struct.unpack("<Is", msg)--
end

function Package:unpackMsgType(msg)
    return struct.unpack("<Hs", msg)
end

function Package:unpackServerMsg(msg)
    msg = self:unpackPython(msg)
    local tag = self:unpackMsgType(msg)
    
    if tag == self.MSG_SC_CONFIRM then
        return struct.unpack("<Hii", msg)
        
    elseif tag == self.MSG_SC_MOVETO then
        return struct.unpack("<Hiii", msg)
        
    elseif tag == self.MSG_SC_CHAT then
        return struct.unpack("<HiIs", msg)
        
    elseif tag == self.MSG_SC_ADDUSER then
        return struct.unpack("<HiIsii", msg)
        
    elseif tag == self.MSG_SC_DELUSER then
        return struct.unpack("<Hi", msg)
    end
    return nil
end


return Package