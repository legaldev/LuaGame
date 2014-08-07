local Event = class("Event", function()
    return {}
end)
Event.type = nil
Event.name = nil
Event.namelen = nil
Event.password = nil
Event.uid = nil
Event.fromx = nil
Event.fromy = nil
Event.tox = nil
Event.toy = nil
Event.text = nil
Event.textlen = nil
function Event:ctor()
    Event.type = nil
    Event.name = nil
    Event.namelen = nil
    Event.password = nil
    Event.uid = nil
    Event.fromx = nil
    Event.fromy = nil
    Event.tox = nil
    Event.toy = nil
    Event.text = nil
    Event.textlen = nil
end

function Event.createFromUnpack(eventType, ...)
    local eventDef = require("EventDef")
    local event = Event.new()
    event.type = eventType
    if eventType == eventDef.MSG_SC_CONFIRM then
        event.uid, event.result = ...
    elseif eventType == eventDef.MSG_SC_MOVETO then
        event.uid, event.fromx, event.fromy, event.tox, event.toy = ...
    elseif eventType == eventDef.MSG_SC_CHAT then
        event.uid, event.textlen, event.text = ...
    elseif eventType == eventDef.MSG_SC_ADDUSER then
        event.uid, event.namelen, event.name, event.x, event.y = ...
    elseif eventType == eventDef.MSG_SC_DELUSER then
        event.uid = ...
    else
        return nil
    end
    return event
end

function Event.pack(self)
    return require("Package").packEventToMsg(self)
end

function Event.unpack(msg)
    return require("Package").unpackMsgToEvent(msg)
end

return Event