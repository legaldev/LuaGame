local EventDef = class("EventDef", function()
    return {}
end)

EventDef.MSG_CS_LOGIN = 0x1001
EventDef.MSG_SC_CONFIRM = 0x2001

EventDef.MSG_CS_MOVETO = 0x1002
EventDef.MSG_SC_MOVETO = 0x2002

EventDef.MSG_CS_CHAT = 0x1003
EventDef.MSG_SC_CHAT = 0x2003

EventDef.MSG_SC_ADDUSER = 0x2004
EventDef.MSG_SC_DELUSER = 0x2005


return EventDef