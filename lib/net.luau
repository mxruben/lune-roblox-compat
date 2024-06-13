--!strict

local net = {}

export type HttpMethod = "GET" | "POST" | "PUT" | "DELETE" | "HEAD" | "OPTIONS" | "PATCH"

export type FetchParams = {
    url: string,
    method: HttpMethod?,
    headers: {[string]: string | {string}}?,
    body: string?
}

export type FetchResponse = {
    ok: boolean,
	statusCode: number,
	statusMessage: string,
	headers: {[string]: string | {string}},
	body: string,
}

-- Lune
if string.sub(_VERSION, 1, 4) == "Lune" then
    local luneNet = require("@lune/net")

    net.jsonEncode = luneNet.jsonEncode
    net.jsonDecode = luneNet.jsonDecode
    net.urlEncode = luneNet.urlEncode
    net.request = luneNet.request :: (config: any) -> FetchResponse

-- Roblox
elseif game and UserSettings then
    local HttpService = game:GetService("HttpService")

    function net.jsonEncode(value: any): string
        return HttpService:JSONEncode(value)
    end

    function net.jsonDecode(encoded: string): any
        return HttpService:JSONDecode(encoded)
    end

    function net.urlEncode(s: string): string
        return HttpService:UrlEncode(s)
    end

    function net.request(config: FetchParams): FetchResponse
        local rbxConfig = {
            Url = config.url,
            Method = config.method,
            Headers = config.headers,
            Body = config.body
        }

        local rbxResponse = HttpService:RequestAsync(rbxConfig)

        return {
            ok = rbxResponse.Success,
            statusCode = rbxResponse.StatusCode,
            statusMessage = rbxResponse.StatusMessage,
            headers = rbxResponse.Headers,
            body = rbxResponse.Body
        }
    end
else
    error("Incompatible platform!")
end

return net
