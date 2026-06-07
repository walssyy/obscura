-- loader.lua (The Authentication Version)
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- YOUR KEY GOES HERE
local script_key = "YOUR_KEY_HERE" 

-- Update this to your current Ngrok URL every time you restart Ngrok
local NGROK_URL = "https://snowy-railway-rearrange.ngrok-free.dev/"

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
    -- Server rejected the key/HWID
    local message = string.gsub(response.Body, "KICK_PLAYER: ", "")
    Players.LocalPlayer:Kick(message)
    
elseif response.StatusCode == 200 then
    -- Server accepted and sent the script
    loadstring(response.Body)()
    print("✅ Obscura: Authorized!")
else
    warn("Obscura Gateway: Connection Error " .. response.StatusCode)
end
