-- loader.lua (Put this inside your public GitHub repository)

-- 1. Verify that the user actually set their license key before executing
if not script_key or type(script_key) ~= "string" then
    error("Obscura System: [Execution Denied] 'script_key' must be defined as a string above the loader line.")
    return
end

local HttpService = game:GetService("HttpService")
local RbxAnalytics = game:GetService("RbxAnalyticsService")

-- 2. Fetch the user's current execution device hardware footprint
local PlayerHWID = RbxAnalytics:GetClientId()

-- ⚠️ CONFIGURATION: Replace with your Discord bot VPS public IP address
local TargetAuthGateway = "https://snowy-railway-rearrange.ngrok-free.dev/auth"

local PayloadData = {
    key = script_key,
    hwid = PlayerHWID
}

-- 🌐 3. Perform the secure handshake check with your bot's live database
local Success, ServerResponse = pcall(function()
    return HttpService:PostAsync(
        TargetAuthGateway, 
        HttpService:JSONEncode(PayloadData), 
        Enum.HttpContentType.ApplicationJson
    )
end)

if Success and ServerResponse then
    -- 4. If the key is valid and not blacklisted, run the code returned by the server
    local Executable, RuntimeErrors = loadstring(ServerResponse)
    if Executable then
        assert(Executable)()
    else
        error("Obscura System: [Internal Stream Error] Failed to parse script data -> " .. tostring(RuntimeErrors))
    end
else
    error("Obscura System: [Access Revoked] Verification failed. Invalid or blacklisted license key.")
end
