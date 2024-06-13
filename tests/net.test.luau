--!strict
local net
local roblox
if string.sub(_VERSION, 1, 4) == "Lune" then
    net = require("../lib/net")
    roblox = false
else
    net = require(script.Parent.Parent.lib.net)
    roblox = true
end


local function assertEqual(actual, expected, message: string?)
    assert(actual == expected, message or string.format("Expected %s but got %s", tostring(expected), tostring(actual)))
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
    }
}

return tests
