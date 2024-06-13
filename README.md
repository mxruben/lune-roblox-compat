# lune-roblox-compat
Compatibility layer for the Roblox API and Lune standard libraries. This library facilitates creating cross platform code for the two platforms. It tries to be consistent with Lune's standard libraries, although some functions may be missing and others may be ported over from Roblox.

# Usage
Using this library isn't as straightforward as other libraries. Please read this whole section as it contains import details.

On Roblox, lune-roblox-compat can be installed with [wally](https://wally.run/package/mxruben/compat) by adding `compat = "mxruben/compat@x.x.x"` (replace the x's with version numbers). On Lune you just have to clone the repo.

When used in a cross-platform project (why would you use this otherwise?), you need a little boilerplate code to detect the platform before you can require the module. Something like this should work fine.
```lua
local compat
-- Check the interpreter version for Lune.
if string.sub(_VERSION, 1, 4) == "Lune" then
    compat = require("path/to/compat")
-- Check for roblox globals.
elseif game and UserSettings then
    compat = require(path.to.compat)
else
    error("Incompatible platform!")
end
```

When importing this library into a Roblox codebase, it'll raise type errors in your editor. The code should still execute without problems, but you won't get code completion for everything. There are a couple of ways to work around this. The easiest way is that if you have Lune installed, run `lune setup` in your project root to setup the type definitions. Lune's type definitions have also been bundled with this library, so if you don't have Lune installed you can add the following to your `settings.json` in Visual Studio Code (replace the version in the path with the version installed):
```json
{
  "luau-lsp.require.mode": "relativeToFile",
  "luau-lsp.require.directoryAliases": {
    "@lune/": "./Packages/_Index/mxruben_compat@0.1.0/compat/typedefs"
  }
}
```
Keep in mind that if you use this library as a dependency in your library, Roblox users will have to add this to their repos as well. In the future, when Visual Studio Code gets its crap together and allows per folder settings, this won't be a problem.

# Platform Differences
- When using the `net.urlEncode` function, Roblox percent-encodes periods, while Lune does not. This shouldn't be an issue because periods are valid URL characters.

# Testing
If you plan to contribute to or modify this project, make sure to test both platforms! They have subtle differences. To test for Lune, run `lune run ./runtests.luau`. For Roblox, start a rojo server with `rojo serve test.project.json`, connect to Roblox Studio in a published place with HTTP requests enabled in the game settings, and then click run in studio.
