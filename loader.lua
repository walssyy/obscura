-- loader.lua

-- 1. Configuration
local script_key = script_key -- Ensure this is defined above the loader
local HttpService = game:GetService("HttpService")
local RbxAnalytics = game:GetService("RbxAnalyticsService")

-- Use your active Ngrok URL
local TargetAuthGateway = "https://snowy-railway-rearrange.ngrok-free.dev/auth"

-- 2. Prepare Payload
local PlayerHWID = RbxAnalytics:GetClientId()
local PayloadData = {
    key = script_key,
    hwid = PlayerHWID
}

print("Obscura: Attempting to connect to Gateway...")

-- 3. Perform Handshake
local Success, ServerResponse = pcall(function()
    return HttpService:PostAsync(
        TargetAuthGateway, 
        HttpService:JSONEncode(PayloadData), 
        Enum.HttpContentType.ApplicationJson
    )
end)

-- 4. Process Response
if Success and ServerResponse then
    print("Obscura: Handshake Successful!")
    
    -- Check if the server returned an error string instead of code
    if string.sub(ServerResponse, 1, 5) == "error" then
        warn("Obscura System: Server Rejected Key -> " .. ServerResponse)
    else
        -- Attempt to execute the returned code
        local Executable, RuntimeErrors = loadstring(ServerResponse)
        if Executable then
            print("Obscura: Executing payload...")
            assert(Executable)()
        else
            warn("Obscura System: Failed to parse script -> " .. tostring(RuntimeErrors))
        end
    end
else
    -- If Success is false, print the error to F9 console
    warn("Obscura System: Connection failed! Error: " .. tostring(ServerResponse))
end
