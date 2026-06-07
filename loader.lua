-- loader.lua (Simple version)
local SCRIPT_URL = "https://raw.githubusercontent.com/YOUR_GITHUB_USER/YOUR_REPO/main/premium_source.lua"

local success, response = pcall(function()
    return game:HttpGet(SCRIPT_URL)
end)

if success and response then
    loadstring(response)()
    print("✅ Obscura Loaded Successfully!")
else
    warn("❌ Failed to load script: " .. tostring(response))
end
