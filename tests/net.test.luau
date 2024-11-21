--!strict
local net
local roblox
if string.sub(_VERSION, 1, 4) == "Lune" then
    net = require("../lib/net")
    roblox = false
elseif game and UserSettings then
    net = require(script.Parent.Parent.lib.net)
    roblox = true
else
    error("Incompatible platform!")
end

local function assertEqual(actual: any, expected: any, message: string?)
    assert(actual == expected, message or string.format("Expected %s but got %s", tostring(expected), tostring(actual)))
end

local function assertNotEqual(actual: any, expected: any, message: string?)
    assert(actual ~= expected, message or string.format("Expected %s but got %s", tostring(expected), tostring(actual)))
end

local tests = {
    {
        name = "json encode and decode",
        test = function()
            local json = net.jsonEncode({name = "bob"})
            assertEqual(json, [[{"name":"bob"}]])
        end
    },
    {
        name = "url encode",
        test = function()
            local url = net.urlEncode("http://google.com")
            -- Roblox percent-encodes periods, but Lune does not.
            -- This shouldn't cause issues though.
            if roblox then
                assertEqual(url, "http%3A%2F%2Fgoogle%2Ecom")
            else
                assertEqual(url, "http%3A%2F%2Fgoogle.com")
            end
        end
    },
    {
        name = "http request get",
        test = function()
            local response = net.request({
                url = "https://dummyjson.com/products/1",
                method = "GET"
            })
            assert(response, "Failed to get request")
            assert(response.body, "Response contains no body")
        end
    },
    {
        name = "http request post",
        test = function()
            local response = net.request({
                url = "https://dummyjson.com/products/add",
                method = "POST",
                headers = {["Content-Type"] = "application/json"},
                body = net.jsonEncode({
                    title = "Massive Car"
                })
            })
            assert(response, "Failed to post request")
            assert(response.body, "Response contains no body")
        end
    },
    {
        name = "uuid generate",
        test = function()
            local uuid = net.uuidGenerate()
            print(`\t\t{uuid}`)
            assertEqual('{', uuid:sub(1, 1), "Failed to append front curly brace")
            assertEqual('}', uuid:sub(#uuid), "Failed to append end curly brace")

            assertEqual(#uuid, 38, "Incorrect bracketed uuid length")

            uuid = net.uuidGenerate(false)
            print(`\t\t{uuid}`)
            assertNotEqual('{', uuid:sub(1, 1), "Falsely appended front curly brace")
            assertNotEqual('}', uuid:sub(#uuid), "Falsely appended end curly brace")

            assertEqual(#uuid, 36, "Incorrect uuid length")

            local allowed = {
                ['0'] = 0, ['1'] = 0, ['2'] = 0, ['3'] = 0, ['4'] = 0, ['5'] = 0,
                ['6'] = 0, ['7'] = 0, ['8'] = 0, ['9'] = 0, a = 0, b = 0, c = 0,
                d = 0, e = 0, f = 0
            }

            local dashes = {
                [9] = 0, [14] = 0, [19] = 0, [24] = 0
            }

            for i = 1, 36 do
                if dashes[i] then
                    assert(uuid:sub(i, i), '-')
                else
                    assert(allowed[uuid:sub(i, i)], `Invalid uuid character in uuid '{uuid}' at index '{i}'`)
                end
            end

            assertEqual(uuid:sub(15, 15), '4', "Version character is not set to 4")

            local char20val = tonumber(uuid:sub(20, 20), 16)
            assert(char20val <= 11 and char20val >= 8, "20th character must be a hex value between 8 and b")
        end
    }
}

return tests
