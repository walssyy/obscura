-- loader.lua
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- YOUR KEY GOES HERE
local script_key = "" 

-- REPLACE THIS URL EVERY TIME YOU RESTART NGROK
local NGROK_URL = "https://a1b2-c3d4.ngrok-free.dev/auth"

local response = request({
    Url = NGROK_URL,
    Method = "POST",
    Headers = { ["Content-Type"] = "application/json" },
    Body = HttpService:JSONEncode({
        key = script_key,
        hwid = game:GetService("RbxAnalyticsService"):GetClientId()
    })
})

if response.StatusCode == 401 then
    -- Server sent a KICK_PLAYER signal
    local message = string.gsub(response.Body, "KICK_PLAYER: ", "")
    Players.LocalPlayer:Kick(message)
    
elseif response.StatusCode == 200 then
    -- Server sent the cheat code
    loadstring(response.Body)()
    print("✅ Obscura: Authorized!")
    
else
    warn("Obscura Gateway: Connection Error " .. response.StatusCode)
end
