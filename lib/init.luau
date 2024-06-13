--!strict
local compat = {}

function compat.isLune(): boolean
    return string.sub(_VERSION, 1, 4) == "Lune"
end

function compat.isRoblox(): boolean
    -- Check for a couple roblox globals.
    if game and UserSettings then
        return true
    end
    return false
end

if compat.isLune() then
    compat.net = require("net")
elseif compat.isRoblox() then
    compat.net = require(script.net)
else
    error("Incompatible platform!")
end

return compat
