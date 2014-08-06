local struct = require("struct")

local Package = class("Package", function()
    return {}
end)

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


function Package:packCSLogin(name, icon)
    return struct.pack("<HIsi", self.MSG_CS_LOGIN, name:len()+1, icon)
end

function Package:packCSMoveTo(x, y)
    return struct.pack("<Hii", self.MSG_CS_MOVETO, x, y)
end

function Package:packCSChat(text)
    return struct.pack("<HIs", self.MSG_CS_CHAT, text:len()+1, text)
end

function Package:unpackMsgType(msg)
    return strcut.unpack("<H", msg)
end

function Package.unpackServerMsg(msg)
    local tag = self:unpackMsgType(msg)
    
    if tag == self.MSG_SC_CONFIRM then
        return strcut.unpack("<Hii", msg)
        
    elseif tag == self.MSG_SC_MOVETO then
        return struct.unpack("<Hiii")
        
    elseif tag == self.MSG_SC_CHAT then
        return struct.unpack("<HiIs")
        
    elseif tag == self.MSG_SC_ADDUSER then
        return struct.unpack("<HiIsii")
        
    elseif tag == self.MSG_SC_DELUSER then
        return struct.unpack("<Hi")
    end
    return nil
end


return Package