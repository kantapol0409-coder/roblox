-- ==============================================================================
-- 🚀 COMPLETE ROBLOX UI HUB & AUTOMATION TEMPLATE
-- Developed with Rayfield UI Framework (Luau)
-- ==============================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- 1. โหลด Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 2. สร้างหน้าต่างหลัก (Main Window)
local Window = Rayfield:CreateWindow({
    Name = "⚡ STEAL AN EGG | CUSTOM HUB",
    LoadingTitle = "กำลังโหลดระบบและโมดูล...",
    LoadingSubtitle = "by Developer Template v3.0",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "EggHubConfigs",
        FileName = "UserConfig"
    },
    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = true
    },
    KeySystem = false
})

-- ==============================================================================
-- 📁 การสร้างหมวดหมู่แท็บ (TABS)
-- ==============================================================================
local MainTab = Window:CreateTab("🎯 ระบบหลัก (Main)", 4483362458)
local UtilityTab = Window:CreateTab("🛠️ เครื่องมือเสริม (Utilities)", 4483362458)
local VisualTab = Window:CreateTab("👁️ แสดงผล & ฟาร์ม (Visuals)", 4483362458)
local SyncTab = Window:CreateTab("📊 เชื่อมต่อ Dashboard", 4483362458)
local SettingsTab = Window:CreateTab("⚙️ ตั้งค่า (Settings)", 4483362458)

-- ==============================================================================
-- 🎯 TAB 1: ระบบหลัก (MAIN FEATURES)
-- ==============================================================================
local State = {
    AutoFarm = false,
    SelectedArea = "Cherry Blossom",
    MinRarity = "Legendary",
    TargetSpeed = 16,
    InfiniteJump = false,
    AntiAFK = true,
    DashboardSync = false
}

MainTab:CreateSection("ระบบเก็บไอเทม / ไข่อัตโนมัติ")

MainTab:CreateToggle({
    Name = "🚀 เปิดระบบฟาร์มอัตโนมัติ (Auto Farm / Steal)",
    CurrentValue = false,
    Flag = "Toggle_AutoFarm",
    Callback = function(Value)
        State.AutoFarm = Value
        if State.AutoFarm then
            Rayfield:Notify({
                Title = "สถานะระบบ",
                Content = "เริ่มระบบฟาร์มในโซน " .. State.SelectedArea,
                Duration = 3,
                Image = 4483362458
            })
            
            -- เธรดทำงานเบื้องหลัง
            task.spawn(function()
                while State.AutoFarm do
                    -- ตัวอย่าง Logic ตรวจสอบและค้นหาเป้าหมาย
                    print(string.format("[AutoFarm] กำลังสแกนหาไข่ระดับ %s ในโซน %s...", State.MinRarity, State.SelectedArea))
                    task.wait(1.5)
                end
            end)
        else
            Rayfield:Notify({
                Title = "สถานะระบบ",
                Content = "หยุดการทำงานเรียบร้อย",
                Duration = 2,
                Image = 4483362458
            })
        end
    end,
})

MainTab:CreateDropdown({
    Name = "📍 เลือกโซนเป้าหมาย (Target Area)",
    Options = {"Prehistoric", "Cosmic", "Cherry Blossom", "Lava Volcano", "Candy Land"},
    CurrentOption = {"Cherry Blossom"},
    Flag = "Dropdown_Area",
    Callback = function(Option)
        State.SelectedArea = Option[1]
    end,
})

MainTab:CreateDropdown({
    Name = "⭐ ระดับความหายากขั้นต่ำ (Min Rarity)",
    Options = {"Common", "Rare", "Epic", "Legendary", "Mythic", "Secret"},
    CurrentOption = {"Legendary"},
    Flag = "Dropdown_Rarity",
    Callback = function(Option)
        State.MinRarity = Option[1]
    end,
})

MainTab:CreateSlider({
    Name = "👟 ปรับความเร็วตัวละคร (Player Speed)",
    Range = {16, 500},
    Increment = 5,
    Suffix = " Speed",
    CurrentValue = 16,
    Flag = "Slider_Speed",
    Callback = function(Value)
        State.TargetSpeed = Value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    end,
})

-- ==============================================================================
-- 🛠️ TAB 2: เครื่องมือเสริม (UTILITIES)
-- ==============================================================================
UtilityTab:CreateSection("ตัวช่วยการเล่นและการเคลื่อนที่")

UtilityTab:CreateToggle({
    Name = "🦘 กระโดดกลางอากาศได้ไม่จำกัด (Infinite Jump)",
    CurrentValue = false,
    Flag = "Toggle_InfJump",
    Callback = function(Value)
        State.InfiniteJump = Value
    end,
})

-- ดักจับการกดปุ่ม Jump
UserInputService.JumpRequest:Connect(function()
    if State.InfiniteJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

UtilityTab:CreateToggle({
    Name = "🛡️ กันหลุดจากการ AFK เกิน 20 นาที (Anti-AFK)",
    CurrentValue = true,
    Flag = "Toggle_AntiAFK",
    Callback = function(Value)
        State.AntiAFK = Value
    end,
})

-- Anti-AFK Virtual Click
LocalPlayer.Idled:Connect(function()
    if State.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
        print("[Anti-AFK] ป้องกันการตัดการเชื่อมต่อสำเร็จ")
    end
end)

UtilityTab:CreateButton({
    Name = "🔄 ย้ายเซิร์ฟเวอร์ใหม่ (Server Hop)",
    Callback = function()
        Rayfield:Notify({ Title = "กำลังค้นหาเซิร์ฟเวอร์...", Content = "กรุณารอสักครู่", Duration = 3 })
        local PlaceId = game.PlaceId
        local JobId = game.JobId
        TeleportService:Teleport(PlaceId, LocalPlayer)
    end,
})

UtilityTab:CreateButton({
    Name = "🔁 เข้าเซิร์ฟเวอร์เดิมใหม่ (Rejoin Game)",
    Callback = function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end,
})

-- ==============================================================================
-- 📊 TAB 3: เชื่อมต่อ REAL-TIME DASHBOARD
-- ==============================================================================
SyncTab:CreateSection("ส่งข้อมูลสถิติไปยัง Web Dashboard")

SyncTab:CreateToggle({
    Name = "🌐 ส่งข้อมูลสดไปที่ Dashboard (Port 3000)",
    CurrentValue = false,
    Flag = "Toggle_Sync",
    Callback = function(Value)
        State.DashboardSync = Value
        if State.DashboardSync then
            task.spawn(function()
                while State.DashboardSync do
                    pcall(function()
                        local payload = {
                            name = LocalPlayer.Name,
                            cash = 272.64,
                            rate = 12.81,
                            speed = State.TargetSpeed / 100,
                            speedLv = 9,
                            houseLv = 10,
                            houseSlots = "17/17",
                            pets = {"🐉", "🦅", "🐺"},
                            eggs = {"🟣", "🔥", "🪽"}
                        }
                        local json = HttpService:JSONEncode(payload)
                        local req = (syn and syn.request) or (http and http.request) or http_request or request
                        if req then
                            req({
                                Url = "http://localhost:3000/api/update",
                                Method = "POST",
                                Headers = {["Content-Type"] = "application/json"},
                                Body = json
                            })
                        end
                    end)
                    task.wait(5)
                end
            end)
        end
    end,
})

-- ==============================================================================
-- ⚙️ TAB 4: การตั้งค่า (SETTINGS)
-- ==============================================================================
SettingsTab:CreateKeybind({
    Name = "⌨️ ปุ่มลัดเปิด/ปิดหน้าต่าง (Toggle UI Key)",
    CurrentKeybind = "RightControl",
    HoldToInteract = false,
    Flag = "Keybind_UI",
    Callback = function(Keybind)
        -- Rayfield จัดการเปิด/ปิดให้อัตโนมัติ
    end,
})

SettingsTab:CreateButton({
    Name = "❌ ปิดการทำงานและลบหน้าต่าง (Destroy UI)",
    Callback = function()
        Rayfield:Destroy()
    end,
})

-- แจ้งเตือนเมื่อโหลดสำเร็จ
Rayfield:Notify({
    Title = "พร้อมใช้งาน!",
    Content = "กดปุ่ม [Right Control] เพื่อเปิด/ปิดหน้าต่างเมนู",
    Duration = 5,
    Image = 4483362458
})

print("⚡ [EggHub] ตัว Hub โหลดและพร้อมทำงานสมบูรณ์แล้ว!")
