-- loader.lua
-- Ensure script_key is defined before running this
if not script_key then
    warn("Obscura System: script_key not defined!")
    return
end

print("Obscura: Attempting to connect to Gateway...")

-- Use the executor's 'request' function to bypass client-side blocks
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

if response.StatusCode == 200 then
    -- Check if the server returned an error string or the actual script
    if string.find(response.Body, "error(") then
        warn("Obscura System: " .. response.Body)
    else
        print("✅ Obscura: Authorized!")
        print("✅ Premium script loaded successfully!")
        loadstring(response.Body)()
    end
else
    warn("Obscura System: Connection failed! Status Code: " .. response.StatusCode)
end
