-- roblox_sender.lua
-- Roblox Script for Sending Real-Time Account & Bot Stats to Your Dashboard
-- ใส่สคริปต์นี้ใน Executor / Auto-execute ของตัวเกมเพื่อส่งข้อมูลอัตโนมัติ

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- URL เซิร์ฟเวอร์ Dashboard ของคุณ (รันบนเครื่องของคุณที่พอร์ต 3000)
local DASHBOARD_URL = "http://localhost:3000/api/update"

local function getPlayerData()
    -- [[ แก้ไขจุดนี้ให้ตรงกับตัวแปร / Leaderstats ในเกมที่คุณเล่น ]]
    local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
    
    local currentCash = 166.17
    local currentRate = 9.64
    local currentSpeed = 3.62
    local currentSpeedLv = 9
    local currentHouseLv = 10
    local currentSlots = "17/17"

    -- ตัวอย่างการดึงค่าจริงจาก leaderstats (หากเกมมี):
    -- if leaderstats then
    --     if leaderstats:FindFirstChild("Cash") then currentCash = leaderstats.Cash.Value / 1e12 end
    --     if leaderstats:FindFirstChild("Speed") then currentSpeed = leaderstats.Speed.Value / 1e9 end
    -- end

    local payload = {
        name = LocalPlayer.Name,
        cash = currentCash,
        rate = currentRate,
        speed = currentSpeed,
        speedLv = currentSpeedLv,
        houseLv = currentHouseLv,
        houseSlots = currentSlots,
        petCount = 17,
        pets = {"🐲", "🦅", "🐺"},
        subCount = 4,
        subRate = 2.27,
        eggs = {"🟣", "🔥", "🪽"}
    }

    return payload
end

local function sendStats()
    local success, data = pcall(getPlayerData)
    if not success then return end

    local jsonBody = HttpService:JSONEncode(data)
    
    -- ใช้ request / http_request ตามที่ executor รองรับ
    local requestFunc = (syn and syn.request) or (http and http.request) or http_request or request
    if requestFunc then
        pcall(function()
            requestFunc({
                Url = DASHBOARD_URL,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = jsonBody
            })
        end)
    end
end

-- ลูปส่งข้อมูลทุกๆ 5 วินาที
task.spawn(function()
    print("⚡ Farm Tracker Sender Started for " .. LocalPlayer.Name)
    while task.wait(5) do
        sendStats()
    end
end)
