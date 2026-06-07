-- loader.lua
-- Ensure script_key is defined in your execution string before running this
if not script_key then
    warn("Obscura System: script_key is not defined! Define it before running the loader.")
    return
end

print("Obscura: Attempting to connect to Gateway...")

-- Use the executor's 'request' function to bypass standard Roblox HTTP restrictions
local response = request({
    Url = "https://your-ngrok-url-here.ngrok-free.dev/auth", -- REPLACE THIS WITH YOUR ACTUAL NGROK URL
    Method = "POST",
    Headers = {
        ["Content-Type"] = "application/json"
    },
    Body = game:GetService("HttpService"):JSONEncode({
        key = script_key,
        hwid = game:GetService("RbxAnalyticsService"):GetClientId()
    })
})

-- Validate the connection
if response.StatusCode == 200 then
    -- Check if the response is an error message from your server
    if string.find(response.Body, "error(") then
        warn("Obscura Gateway: " .. response.Body)
    else
        -- If successful, the server returns the actual script content
        print("✅ Obscura: Authorized!")
        print("✅ Premium script loaded successfully!")
        
        -- Execute the downloaded code safely
        local success, err = pcall(function()
            loadstring(response.Body)()
        end)
        
        if not success then
            warn("Obscura: Failed to execute script: " .. tostring(err))
        end
    end
else
    warn("Obscura Gateway: Connection failed with status code: " .. response.StatusCode)
end
