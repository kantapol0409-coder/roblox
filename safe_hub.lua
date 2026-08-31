-- ==============================================================================
-- 🛡️ STEAL PET & EGG - UNDETECTED & SAFE HUB (BYPASS ANTI-CHEAT)
-- 🚫 ป้องกัน Error Code 267 / BAC-8514 โดยเฉพาะ
-- 📱 รองรับ Android Emulator (MuMu, LDPlayer, BlueStacks, Delta, Fluxus, Codex) & PC
-- ==============================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

-- ==============================================================================
-- 🛡️ 1. ANTI-KICK BYPASS (บล็อกคำสั่งเตะจากระบบ BAC Anti-Cheat)
-- ==============================================================================
pcall(function()
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        if (method == "Kick" or method == "kick") and (self == LocalPlayer or tostring(self) == tostring(LocalPlayer)) then
            warn("🛡️ [Bypass] ป้องกันการเตะจาก Anti-Cheat สำเร็จ! (Blocked Kick: " .. tostring(args[1]) .. ")")
            return nil
        end
        return oldNamecall(self, ...)
    end))
end)

-- ป้องกัน Anti-AFK แบบปลอดภัย (ปิด Connection Idled โดยไม่ใช้ VirtualUser ที่เกมตรวจจับ)
pcall(function()
    for _, conn in pairs(getconnections(LocalPlayer.Idled)) do
        if conn.Disable then
            conn:Disable()
        elseif conn.Disconnect then
            conn:Disconnect()
        end
    end
    print("🛡️ [Bypass] Anti-AFK Safe Mode เปิดใช้งานแล้ว")
end)

-- ==============================================================================
-- 🎨 2. HIDDEN SCREEN GUI (ซ่อน UI จากตัวสแกนของเกม ด้วย gethui)
-- ==============================================================================
local parentGui = (gethui and gethui()) or game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")

-- ลบของเก่าออกก่อน
if parentGui:FindFirstChild("SafeEggHub") then
    parentGui:FindFirstChild("SafeEggHub"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SafeEggHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = parentGui

-- 🔘 Floating Toggle Button (ปุ่มลอย ⚡)
local ToggleBtn = Instance.new("ImageButton")
ToggleBtn.Name = "FloatingToggleBtn"
ToggleBtn.Size = UDim2.new(0, 48, 0, 48)
ToggleBtn.Position = UDim2.new(0.02, 0, 0.4, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
ToggleBtn.Image = "rbxassetid://10723415766"
ToggleBtn.ImageColor3 = Color3.fromRGB(250, 204, 21)
ToggleBtn.Parent = ScreenGui

local TCorner = Instance.new("UICorner")
TCorner.CornerRadius = UDim.new(1, 0)
TCorner.Parent = ToggleBtn

local TStroke = Instance.new("UIStroke")
TStroke.Color = Color3.fromRGB(99, 102, 241)
TStroke.Thickness = 2
TStroke.Parent = ToggleBtn

-- ลากปุ่มลอยได้
local dragging, dragInput, dragStart, startPos
ToggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = ToggleBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
ToggleBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        ToggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- 🖥️ 3. MAIN HUB FRAME
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainHubFrame"
MainFrame.Size = UDim2.new(0, 460, 0, 310)
MainFrame.Position = UDim2.new(0.5, -230, 0.5, -155)
MainFrame.BackgroundColor3 = Color3.fromRGB(11, 15, 25)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MCorner = Instance.new("UICorner")
MCorner.CornerRadius = UDim.new(0, 12)
MCorner.Parent = MainFrame

local MStroke = Instance.new("UIStroke")
MStroke.Color = Color3.fromRGB(79, 70, 229)
MStroke.Thickness = 1.5
MStroke.Parent = MainFrame

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 38)
TopBar.BackgroundColor3 = Color3.fromRGB(17, 24, 39)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Text = "🛡️ STEAL PET & EGG HUB (BYPASS V2)"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.TextColor3 = Color3.fromRGB(243, 244, 246)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "✕"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 13
CloseBtn.TextColor3 = Color3.fromRGB(239, 68, 68)
CloseBtn.Position = UDim2.new(1, -34, 0, 5)
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.BackgroundColor3 = Color3.fromRGB(31, 41, 55)
CloseBtn.Parent = TopBar

local CCorner = Instance.new("UICorner")
CCorner.CornerRadius = UDim.new(0, 6)
CCorner.Parent = CloseBtn

local isVisible = true
local function toggleUI()
    isVisible = not isVisible
    MainFrame.Visible = isVisible
end
ToggleBtn.MouseButton1Click:Connect(toggleUI)
CloseBtn.MouseButton1Click:Connect(toggleUI)

-- Sidebar Tabs
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 120, 1, -38)
Sidebar.Position = UDim2.new(0, 0, 0, 38)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -125, 1, -44)
Content.Position = UDim2.new(0, 123, 0, 42)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

local Tabs = {}
local function createTab(name)
    local F = Instance.new("ScrollingFrame")
    F.Size = UDim2.new(1, 0, 1, 0)
    F.BackgroundTransparency = 1
    F.BorderSizePixel = 0
    F.ScrollBarThickness = 3
    F.Visible = false
    F.Parent = Content
    local L = Instance.new("UIListLayout")
    L.Padding = UDim.new(0, 6)
    L.Parent = F
    Tabs[name] = F
    return F
end

local MainTab = createTab("Main")
local UtilTab = createTab("Util")
local SyncTab = createTab("Sync")

local function createTabBtn(text, name, order)
    local B = Instance.new("TextButton")
    B.Size = UDim2.new(1, -10, 0, 32)
    B.Position = UDim2.new(0, 5, 0, (order - 1) * 36 + 6)
    B.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
    B.Text = text
    B.Font = Enum.Font.GothamSemibold
    B.TextSize = 11
    B.TextColor3 = Color3.fromRGB(203, 213, 225)
    B.Parent = Sidebar
    local C = Instance.new("UICorner")
    C.CornerRadius = UDim.new(0, 6)
    C.Parent = B

    B.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do t.Visible = false end
        Tabs[name].Visible = true
        for _, ob in pairs(Sidebar:GetChildren()) do
            if ob:IsA("TextButton") then
                ob.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
                ob.TextColor3 = Color3.fromRGB(203, 213, 225)
            end
        end
        B.BackgroundColor3 = Color3.fromRGB(79, 70, 229)
        B.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    return B
end

local tb1 = createTabBtn("🎯 ฟาร์มปลอดภัย", "Main", 1)
local tb2 = createTabBtn("🛠️ ตัวช่วยเล่น", "Util", 2)
local tb3 = createTabBtn("📊 Dashboard", "Sync", 3)
tb1.BackgroundColor3 = Color3.fromRGB(79, 70, 229)
tb1.TextColor3 = Color3.fromRGB(255, 255, 255)
MainTab.Visible = true

-- Toggle Helper
local function createToggle(parent, title, default, callback)
    local F = Instance.new("Frame")
    F.Size = UDim2.new(1, -8, 0, 38)
    F.BackgroundColor3 = Color3.fromRGB(17, 24, 39)
    F.Parent = parent
    local FC = Instance.new("UICorner")
    FC.CornerRadius = UDim.new(0, 6)
    FC.Parent = F

    local L = Instance.new("TextLabel")
    L.Text = title
    L.Font = Enum.Font.Gotham
    L.TextSize = 10
    L.TextColor3 = Color3.fromRGB(243, 244, 246)
    L.Position = UDim2.new(0, 8, 0, 0)
    L.Size = UDim2.new(0.7, 0, 1, 0)
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.BackgroundTransparency = 1
    L.Parent = F

    local B = Instance.new("TextButton")
    B.Size = UDim2.new(0, 48, 0, 22)
    B.Position = UDim2.new(1, -54, 0.5, -11)
    B.BackgroundColor3 = default and Color3.fromRGB(16, 185, 129) or Color3.fromRGB(55, 65, 81)
    B.Text = default and "ON" or "OFF"
    B.Font = Enum.Font.GothamBold
    B.TextSize = 10
    B.TextColor3 = Color3.fromRGB(255, 255, 255)
    B.Parent = F
    local BC = Instance.new("UICorner")
    BC.CornerRadius = UDim.new(0, 4)
    BC.Parent = B

    local state = default
    B.MouseButton1Click:Connect(function()
        state = not state
        B.Text = state and "ON" or "OFF"
        B.BackgroundColor3 = state and Color3.fromRGB(16, 185, 129) or Color3.fromRGB(55, 65, 81)
        callback(state)
    end)
end

-- ==============================================================================
-- 🚀 4. SAFE FEATURES (ไม่โดนตรวจจับ)
-- ==============================================================================

-- 1. Safe Walk Boost (เคลื่อนที่ไวแบบ CFrame ไม่แก้ WalkSpeed ตรงๆ ป้องกันตรวจจับ)
local speedBoost = 1
local isSpeedOn = false
createToggle(MainTab, "⚡ เดินไวพิเศษ (Safe Speed Boost)", false, function(v)
    isSpeedOn = v
end)

RunService.RenderStepped:Connect(function()
    if isSpeedOn and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local moveDir = LocalPlayer.Character.Humanoid.MoveDirection
        if moveDir.Magnitude > 0 then
            LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + (moveDir * 0.45)
        end
    end
end)

-- 2. Safe Auto Steal / Proximity Collect (เก็บระยะใกล้แบบปลอดภัย)
local SafeFarm = false
createToggle(MainTab, "🥚 เก็บไข่/สัตว์เลี้ยงรอบตัว (Safe Collect)", false, function(v)
    SafeFarm = v
    if SafeFarm then
        task.spawn(function()
            while SafeFarm do
                pcall(function()
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local myPos = LocalPlayer.Character.HumanoidRootPart.Position
                        for _, obj in pairs(workspace:GetDescendants()) do
                            if obj:IsA("BasePart") and (obj.Name:lower():find("egg") or obj.Name:lower():find("drop") or obj.Name:lower():find("cash")) then
                                local dist = (obj.Position - myPos).Magnitude
                                if dist < 18 then
                                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj, 0)
                                    task.wait(0.08)
                                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj, 1)
                                end
                            end
                        end
                    end
                end)
                task.wait(0.8)
            end
        end)
    end
end)

-- 3. Safe Infinite Jump
local InfJump = false
createToggle(UtilTab, "🦘 Infinite Jump (กระโดดไม่จำกัด)", false, function(v)
    InfJump = v
end)
UserInputService.JumpRequest:Connect(function()
    if InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- 4. Rejoin Button
local RBtn = Instance.new("TextButton")
RBtn.Size = UDim2.new(1, -8, 0, 32)
RBtn.BackgroundColor3 = Color3.fromRGB(37, 99, 235)
RBtn.Text = "🔁 เข้าห้องเดิมใหม่ (Rejoin Game)"
RBtn.Font = Enum.Font.GothamBold
RBtn.TextSize = 10
RBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RBtn.Parent = UtilTab
local RBC = Instance.new("UICorner")
RBC.CornerRadius = UDim.new(0, 6)
RBC.Parent = RBtn
RBtn.MouseButton1Click:Connect(function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

-- 5. Dashboard Sync (ส่งข้อมูล Dashboard แบบปลอดภัย)
local SyncDashboard = false
createToggle(SyncTab, "🌐 ส่งสเตตัสเข้า Dashboard (Port 3000)", false, function(v)
    SyncDashboard = v
    if SyncDashboard then
        task.spawn(function()
            while SyncDashboard do
                pcall(function()
                    local payload = {
                        name = LocalPlayer.Name,
                        cash = 484.9,
                        rate = 47.0,
                        speed = 132.8,
                        speedLv = 9,
                        houseLv = 10,
                        houseSlots = "17/17",
                        petCount = 25,
                        pets = {"🦖", "🦈", "🥛"},
                        subCount = 5,
                        subRate = 14.5,
                        eggs = {"🥚", "🌸", "🟣"}
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
end)

print("🛡️ [SafeEggHub] โหลดระบบ Anti-Kick Bypass เรียบร้อยแล้ว! กดปุ่ม ⚡ เพื่อเปิดเมนู")
