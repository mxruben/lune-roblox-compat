# lune-roblox-compat
Compatibility layer for the Roblox API and Lune standard libraries. This library facilitates creating cross platform code for the two platforms. It tries to be consistent with Lune's standard libraries, although some functions may be missing and others may be ported over from Roblox.

# Usage
When used in a cross-platform project (why would you use this otherwise?), you need a little boilerplate code to detect the platform before you can require the module. Something like this should work fine.
```lua
local compat
-- Check the interpreter version for lune.
if string.sub(_VERSION, 1, 4) == "Lune" then
    compat = require("path/to/compat")
-- Check for roblox globals.
elseif game and UserSettings then
    compat = require(path.to.compat)
else
    error("Incompatible platform!")
end
```

# Platform Differences
- When using the `net.urlEncode` function, Roblox percent-encodes periods, while Lune does not. This shouldn't be an issue because periods are valid URL characters.

# Testing
If you plan to contribute to or modify this project, make sure to test both platforms! They have subtle differences. To test for Lune, run `lune run ./runtests.luau`. For Roblox, start a rojo server with `rojo serve test.project.json`, connect to Roblox Studio in a published place with HTTP requests enabled in the game settings, and then click run in studio.
