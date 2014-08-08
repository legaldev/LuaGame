local Utilities = class("Utilitise", function()
    return {}
end)

local math = require("math")

function Utilities.distance(p1, p2)
    return math.sqrt( math.pow(p1.y - p2.y, 2) + math.pow(p1.x - p2.x, 2))
end

return Utilities