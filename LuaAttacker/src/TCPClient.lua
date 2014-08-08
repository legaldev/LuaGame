local TCPClient = class("TCPClient",function()
    return require("socket")
end)

local NET_STATE = {
    NET_STATE_STOP = 0, 
    NET_STATE_CONNECTING = 1, 
    NET_STATE_ESTABLISHED = 2
}

function TCPClient:ctor()
    self._sock = nil
    self._status = NET_STATE.NET_STATE_STOP
    self._count = 0
    self._checkInterval = 30
    self._sendQueue = require("Queue").new()
    self._recvQueue = require("Queue").new()
end


function TCPClient:connectTo(addr, port)
    self._sock = self.connect('127.0.0.1', 2000)
    if self._sock == nil then
        self._status = NET_STATE.NET_STATE_STOP
        return false
    end
    self._sock:settimeout(0.00001)
    self._status = NET_STATE.NET_STATE_ESTABLISHED
    return true
end

local package = require("Package").new()

function TCPClient:send(msg)
    if not msg then return end
    msg = package.packToPython(msg)
    self._sendQueue:pushlast(msg)
end

function TCPClient:recv()
    local msg = self._recvQueue:popfirst()
    if msg == nil then return nil end
    return package.unpackPython(msg)
end

function TCPClient:process()
    if self._status == NET_STATE.NET_STATE_STOP then
        return
    end
    local socket = require("socket")
    
    -- if something to send, select to send
    if not self._sendQueue:isempty()then
        local empty = self._sendQueue:isempty()
        local recvt, sendt, status = socket.select(nil, {self._sock}, 0.01)
        if #sendt > 0 then
            --p = mypack:packCSLogin("hero", "123456")
            --p = mypack:packCSMoveTo(1,2)
            --p = package.packCSChat("hello i am client")
            local msg = self._sendQueue:popfirst()
            self._sock:send(msg)
            print(string.format("send: %q", msg))
        end     
    end
    
    -- select to recv
    local recvt, sendt, status = socket.select({self._sock}, nil, 0.01)
    if #recvt > 0 then
        local recvBuf = {}
        repeat
            local response, receive_status = self._sock:receive(1)
            if receive_status == "timeout" then break end
            if receive_status == "close" then 
                self._status = NET_STATE.NET_STATE_STOP
                break 
            end
            table.insert(recvBuf, response)
        until exp
        if #recvBuf > 0 then
            local msg = table.concat(recvBuf)
            self._recvQueue:pushlast(msg)
        end
    end
    
end

return TCPClient