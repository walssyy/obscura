-- loader.lua
-- Make sure 'script_key' is defined in your execution environment before running this!

local URL = "https://snowy-railway-rearrange.ngrok-free.dev/auth"

print("Obscura: Attempting to connect to Gateway...")

local success, response = pcall(function()
    return request({
        Url = URL,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = game:GetService("HttpService"):JSONEncode({
            key = script_key,
            hwid = game:GetService("RbxAnalyticsService"):GetClientId()
        })
    })
end)

if not success then
    warn("Obscura: Request failed (Network error or blocked function): " .. tostring(response))
    return
end

if response.StatusCode == 200 then
    -- Check if server sent an error string
    if string.find(response.Body, "error(") then
        warn("Obscura Gateway: " .. response.Body)
    else
        print("✅ Obscura: Authorized!")
        -- Execute the code received from your server
        local loadSuccess, err = pcall(function()
            loadstring(response.Body)()
        end)
        
        if not loadSuccess then
            warn("Obscura: Failed to execute script: " .. tostring(err))
        end
    end
else
    warn("Obscura Gateway: Connection failed! Status Code: " .. response.StatusCode)
end
