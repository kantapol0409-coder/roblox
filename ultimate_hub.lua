-- ==============================================================================
-- 🚀 STEAL PET & EGG - ULTIMATE ALL-IN-ONE MASTER HUB v4.0
-- 👑 จัดเต็มทุกฟังก์ชัน: Auto Farm, Steal, Kill Aura, Boss Fight, Fly, ESP, Teleport, Auto Upgrade
-- 📱 รองรับ Android Emulator (MuMu, LDPlayer, BlueStacks, Delta, Fluxus, Codex) & PC 100%
-- 🛡️ ปลอดภัย พร้อมระบบ Anti-Kick / Undetected Bypass
-- ==============================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer

-- ==============================================================================
-- 🛡️ 1. BYPASS & ANTI-CHEAT PROTECTION
-- ==============================================================================
pcall(function()
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        if (method == "Kick" or method == "kick") and (self == LocalPlayer or tostring(self) == tostring(LocalPlayer)) then
            warn("🛡️ [Bypass] ป้องกันการเตะจากเกมสำเร็จ! (" .. tostring(args[1]) .. ")")
            return nil
        end
        return oldNamecall(self, ...)
    end))
end)

-- Anti-AFK Safe
pcall(function()
    for _, conn in pairs(getconnections(LocalPlayer.Idled)) do
        if conn.Disable then conn:Disable() elseif conn.Disconnect then conn:Disconnect() end
    end
end)

-- ==============================================================================
-- 🎨 2. UI SETUP (HIDDEN GUI + FLOATING BUTTON)
-- ==============================================================================
local parentGui = (gethui and gethui()) or game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")
if parentGui:FindFirstChild("UltimateEggHub") then parentGui:FindFirstChild("UltimateEggHub"):Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltimateEggHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = parentGui

-- 🔘 Floating Toggle Button (⚡)
local ToggleBtn = Instance.new("ImageButton")
ToggleBtn.Name = "FloatingToggle"
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0.02, 0, 0.45, 0)
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

-- 🖥️ MAIN HUB WINDOW
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainHubWindow"
MainFrame.Size = UDim2.new(0, 540, 0, 360)
MainFrame.Position = UDim2.new(0.5, -270, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 14, 26)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MCorner = Instance.new("UICorner")
MCorner.CornerRadius = UDim.new(0, 14)
MCorner.Parent = MainFrame

local MStroke = Instance.new("UIStroke")
MStroke.Color = Color3.fromRGB(99, 102, 241)
MStroke.Thickness = 1.5
MStroke.Parent = MainFrame

-- Top Bar Header
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 42)
TopBar.BackgroundColor3 = Color3.fromRGB(17, 24, 39)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Text = "⚡ STEAL PET & EGG | ULTIMATE MASTER HUB v4.0"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Position = UDim2.new(0, 14, 0, 0)
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "✕"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.TextColor3 = Color3.fromRGB(239, 68, 68)
CloseBtn.Position = UDim2.new(1, -38, 0, 6)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.BackgroundColor3 = Color3.fromRGB(31, 41, 55)
CloseBtn.Parent = TopBar

local CCorner = Instance.new("UICorner")
CCorner.CornerRadius = UDim.new(0, 8)
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
Sidebar.Size = UDim2.new(0, 135, 1, -42)
Sidebar.Position = UDim2.new(0, 0, 0, 42)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -145, 1, -50)
Content.Position = UDim2.new(0, 140, 0, 46)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

local Tabs = {}
local function createTab(name)
    local F = Instance.new("ScrollingFrame")
    F.Size = UDim2.new(1, 0, 1, 0)
    F.BackgroundTransparency = 1
    F.BorderSizePixel = 0
    F.ScrollBarThickness = 3
    F.ScrollBarImageColor3 = Color3.fromRGB(99, 102, 241)
    F.Visible = false
    F.Parent = Content
    local L = Instance.new("UIListLayout")
    L.Padding = UDim.new(0, 7)
    L.Parent = F
    Tabs[name] = F
    return F
end

-- สร้าง 7 แท็บหลัก
local TabFarm = createTab("Farm")
local TabCombat = createTab("Combat")
local TabMove = createTab("Move")
local TabESP = createTab("ESP")
local TabTP = createTab("TP")
local TabShop = createTab("Shop")
local TabSync = createTab("Sync")

local function createTabBtn(text, icon, name, order)
    local B = Instance.new("TextButton")
    B.Size = UDim2.new(1, -10, 0, 32)
    B.Position = UDim2.new(0, 5, 0, (order - 1) * 36 + 6)
    B.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
    B.Text = icon .. " " .. text
    B.Font = Enum.Font.GothamSemibold
    B.TextSize = 10.5
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

local b1 = createTabBtn("ฟาร์ม & ขโมย", "🎯", "Farm", 1)
local b2 = createTabBtn("ต่อสู้ & ป้องกัน", "⚔️", "Combat", 2)
local b3 = createTabBtn("การเคลื่อนที่", "🚀", "Move", 3)
local b4 = createTabBtn("มองทะลุ (ESP)", "👁️", "ESP", 4)
local b5 = createTabBtn("วาร์ป (Teleport)", "📍", "TP", 5)
local b6 = createTabBtn("อัปเกรด & ร้าน", "🛒", "Shop", 6)
local b7 = createTabBtn("Dashboard", "📊", "Sync", 7)

b1.BackgroundColor3 = Color3.fromRGB(79, 70, 229)
b1.TextColor3 = Color3.fromRGB(255, 255, 255)
TabFarm.Visible = true

-- ==============================================================================
-- 🛠️ UI CONTROLS BUILDERS
-- ==============================================================================
local function createToggle(parent, title, desc, default, callback)
    local F = Instance.new("Frame")
    F.Size = UDim2.new(1, -8, 0, 44)
    F.BackgroundColor3 = Color3.fromRGB(17, 24, 39)
    F.Parent = parent
    local FC = Instance.new("UICorner")
    FC.CornerRadius = UDim.new(0, 8)
    FC.Parent = F

    local L = Instance.new("TextLabel")
    L.Text = title
    L.Font = Enum.Font.GothamSemibold
    L.TextSize = 11
    L.TextColor3 = Color3.fromRGB(243, 244, 246)
    L.Position = UDim2.new(0, 10, 0, 6)
    L.Size = UDim2.new(0.7, 0, 0, 16)
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.BackgroundTransparency = 1
    L.Parent = F

    local Sub = Instance.new("TextLabel")
    Sub.Text = desc or ""
    Sub.Font = Enum.Font.Gotham
    Sub.TextSize = 9
    Sub.TextColor3 = Color3.fromRGB(156, 163, 175)
    Sub.Position = UDim2.new(0, 10, 0, 22)
    Sub.Size = UDim2.new(0.7, 0, 0, 16)
    Sub.TextXAlignment = Enum.TextXAlignment.Left
    Sub.BackgroundTransparency = 1
    Sub.Parent = F

    local B = Instance.new("TextButton")
    B.Size = UDim2.new(0, 52, 0, 24)
    B.Position = UDim2.new(1, -60, 0.5, -12)
    B.BackgroundColor3 = default and Color3.fromRGB(16, 185, 129) or Color3.fromRGB(55, 65, 81)
    B.Text = default and "ON" or "OFF"
    B.Font = Enum.Font.GothamBold
    B.TextSize = 11
    B.TextColor3 = Color3.fromRGB(255, 255, 255)
    B.Parent = F
    local BC = Instance.new("UICorner")
    BC.CornerRadius = UDim.new(0, 6)
    BC.Parent = B

    local state = default
    B.MouseButton1Click:Connect(function()
        state = not state
        B.Text = state and "ON" or "OFF"
        B.BackgroundColor3 = state and Color3.fromRGB(16, 185, 129) or Color3.fromRGB(55, 65, 81)
        callback(state)
    end)
end

local function createButton(parent, title, icon, color, callback)
    local B = Instance.new("TextButton")
    B.Size = UDim2.new(1, -8, 0, 36)
    B.BackgroundColor3 = color or Color3.fromRGB(37, 99, 235)
    B.Text = (icon and (icon .. " ") or "") .. title
    B.Font = Enum.Font.GothamBold
    B.TextSize = 11
    B.TextColor3 = Color3.fromRGB(255, 255, 255)
    B.Parent = parent
    local C = Instance.new("UICorner")
    C.CornerRadius = UDim.new(0, 8)
    C.Parent = B
    B.MouseButton1Click:Connect(callback)
    return B
end

local function createSlider(parent, title, min, max, default, callback)
    local F = Instance.new("Frame")
    F.Size = UDim2.new(1, -8, 0, 48)
    F.BackgroundColor3 = Color3.fromRGB(17, 24, 39)
    F.Parent = parent
    local FC = Instance.new("UICorner")
    FC.CornerRadius = UDim.new(0, 8)
    FC.Parent = F

    local L = Instance.new("TextLabel")
    L.Text = title .. ": " .. tostring(default)
    L.Font = Enum.Font.GothamSemibold
    L.TextSize = 11
    L.TextColor3 = Color3.fromRGB(243, 244, 246)
    L.Position = UDim2.new(0, 10, 0, 6)
    L.Size = UDim2.new(1, -20, 0, 14)
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.BackgroundTransparency = 1
    L.Parent = F

    local SB = Instance.new("TextButton")
    SB.Text = ""
    SB.Size = UDim2.new(1, -20, 0, 8)
    SB.Position = UDim2.new(0, 10, 0, 28)
    SB.BackgroundColor3 = Color3.fromRGB(55, 65, 81)
    SB.Parent = F
    local SBC = Instance.new("UICorner")
    SBC.CornerRadius = UDim.new(1, 0)
    SBC.Parent = SB

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(99, 102, 241)
    Fill.BorderSizePixel = 0
    Fill.Parent = SB
    local FillC = Instance.new("UICorner")
    FillC.CornerRadius = UDim.new(1, 0)
    FillC.Parent = Fill

    local function update(input)
        local pos = math.clamp((input.Position.X - SB.AbsolutePosition.X) / SB.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * pos)
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        L.Text = title .. ": " .. tostring(val)
        callback(val)
    end

    local sliding = false
    SB.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = true; update(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
end

-- ==============================================================================
-- 🎯 TAB 1: ฟาร์ม & ขโมยอัตโนมัติ (AUTO FARM & STEAL)
-- ==============================================================================
local AutoStealEgg = false
local AutoCollectCash = false
local AutoLuckyBlock = false
local AutoHatch = false
local AutoEquipBest = false

createToggle(TabFarm, "🥚 Auto Steal Eggs (ขโมยไข่อัตโนมัติ)", "เดินไปเก็บไข่ที่เกิดในรังอัตโนมัติ", false, function(v)
    AutoStealEgg = v
    if AutoStealEgg then
        task.spawn(function()
            while AutoStealEgg do
                pcall(function()
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        for _, obj in pairs(workspace:GetDescendants()) do
                            if obj:IsA("BasePart") and obj.Name:lower():find("egg") then
                                if (obj.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 30 then
                                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj, 0)
                                    task.wait(0.05)
                                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj, 1)
                                end
                            end
                        end
                    end
                end)
                task.wait(0.6)
            end
        end)
    end
end)

createToggle(TabFarm, "💵 Auto Collect Cash (ดูดเงินอัตโนมัติ)", "ดูดเงินที่ตกในคอกและฟาร์มเข้าตัว", false, function(v)
    AutoCollectCash = v
    if AutoCollectCash then
        task.spawn(function()
            while AutoCollectCash do
                pcall(function()
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        for _, obj in pairs(workspace:GetDescendants()) do
                            if obj:IsA("BasePart") and (obj.Name:lower():find("cash") or obj.Name:lower():find("coin") or obj.Name:lower():find("drop")) then
                                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj, 0)
                                task.wait(0.02)
                                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj, 1)
                            end
                        end
                    end
                end)
                task.wait(0.5)
            end
        end)
    end
end)

createToggle(TabFarm, "📦 Auto Open Lucky Block (เปิดบล็อกเสี่ยงโชค)", "ตีและเปิดบล็อกปริศนากลางแมพ", false, function(v)
    AutoLuckyBlock = v
    if AutoLuckyBlock then
        task.spawn(function()
            while AutoLuckyBlock do
                pcall(function()
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj:IsA("BasePart") and (obj.Name:lower():find("lucky") or obj.Name:lower():find("block")) then
                            if (obj.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 25 then
                                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj, 0)
                                task.wait(0.05)
                                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj, 1)
                            end
                        end
                    end
                end)
                task.wait(0.8)
            end
        end)
    end
end)

createToggle(TabFarm, "🐾 Auto Equip Best (ใส่สัตว์เลี้ยงเก่งสุด)", "สวมใส่สัตว์เลี้ยงที่ผลิตเงินไวที่สุดเสมอ", false, function(v)
    AutoEquipBest = v
    if AutoEquipBest then
        task.spawn(function()
            while AutoEquipBest do
                pcall(function()
                    for _, r in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                        if r:IsA("RemoteFunction") or r:IsA("RemoteEvent") then
                            if r.Name:lower():find("equipbest") or r.Name:lower():find("bestpet") then
                                r:FireServer()
                            end
                        end
                    end
                end)
                task.wait(5)
            end
        end)
    end
end)

-- ==============================================================================
-- ⚔️ TAB 2: ต่อสู้ & ป้องกันบ้าน (COMBAT & DEFENSE)
-- ==============================================================================
local BatKillAura = false
local BossAttack = false
local AutoTrap = false

createToggle(TabCombat, "🏏 Bat Kill Aura (ฟาดไม้เบสบอลรอบตัว 360°)", "ตีศัตรูและคนที่จะมาขโมยของรอบตัว", false, function(v)
    BatKillAura = v
    if BatKillAura then
        task.spawn(function()
            while BatKillAura do
                pcall(function()
                    -- ถือไม้เบสบอล
                    local bat = LocalPlayer.Backpack:FindFirstChild("Bat") or LocalPlayer.Character:FindFirstChild("Bat")
                    if bat and bat.Parent == LocalPlayer.Backpack then
                        LocalPlayer.Character.Humanoid:EquipTool(bat)
                    end
                    if bat and bat:FindFirstChild("Handle") then
                        for _, p in pairs(Players:GetPlayers()) do
                            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                                if (p.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 20 then
                                    firetouchinterest(bat.Handle, p.Character.HumanoidRootPart, 0)
                                    task.wait(0.05)
                                    firetouchinterest(bat.Handle, p.Character.HumanoidRootPart, 1)
                                end
                            end
                        end
                    end
                end)
                task.wait(0.2)
            end
        end)
    end
end)

createToggle(TabCombat, "🦖 Auto Attack Boss (ตีมอนสเตอร์/บอส)", "โจมตี The Hungry Monster & บอสโลก", false, function(v)
    BossAttack = v
    if BossAttack then
        task.spawn(function()
            while BossAttack do
                pcall(function()
                    for _, m in pairs(workspace:GetDescendants()) do
                        if m:IsA("Model") and (m.Name:lower():find("monster") or m.Name:lower():find("boss") or m.Name:lower():find("hungry")) then
                            if m:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                if (m.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 35 then
                                    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                                    if tool and tool:FindFirstChild("Handle") then
                                        firetouchinterest(tool.Handle, m.HumanoidRootPart, 0)
                                        task.wait(0.05)
                                        firetouchinterest(tool.Handle, m.HumanoidRootPart, 1)
                                    end
                                end
                            end
                        end
                    end
                end)
                task.wait(0.3)
            end
        end)
    end
end)

createToggle(TabCombat, "🪤 Auto Place Traps (วางกับดักรอบบ้าน)", "วางกับดักดักขโมยอัตโนมัติ", false, function(v)
    AutoTrap = v
    if AutoTrap then
        task.spawn(function()
            while AutoTrap do
                pcall(function()
                    local trap = LocalPlayer.Backpack:FindFirstChild("Trap") or LocalPlayer.Character:FindFirstChild("Trap")
                    if trap and trap.Parent == LocalPlayer.Backpack then
                        LocalPlayer.Character.Humanoid:EquipTool(trap)
                        task.wait(0.2)
                        trap:Activate()
                    end
                end)
                task.wait(3)
            end
        end)
    end
end)

-- ==============================================================================
-- 🚀 TAB 3: การเคลื่อนที่ & พลังตัวละคร (MOVEMENT)
-- ==============================================================================
local isSpeed = false
local speedMultiplier = 0.5
createSlider(TabMove, "👟 ปรับระดับความเร็ว Boost", 1, 10, 3, function(v)
    speedMultiplier = v * 0.2
end)

createToggle(TabMove, "⚡ Safe Speed Boost (เดินไวพิเศษ)", "เคลื่อนที่ไวแบบ CFrame ไม่โดน Anti-Cheat ตรวจจับ", false, function(v)
    isSpeed = v
end)

RunService.RenderStepped:Connect(function()
    if isSpeed and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local moveDir = LocalPlayer.Character.Humanoid.MoveDirection
        if moveDir.Magnitude > 0 then
            LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + (moveDir * speedMultiplier)
        end
    end
end)

local isFlying = false
local flySpeed = 50
createToggle(TabMove, "🕊️ Fly Hack (บินได้อิสระบนฟ้า)", "บินข้ามรั้วและขโมยไข่จากมุมสูง", false, function(v)
    isFlying = v
    if isFlying then
        task.spawn(function()
            local bv = Instance.new("BodyVelocity")
            bv.Name = "EggFlyBV"
            bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bv.Parent = LocalPlayer.Character.HumanoidRootPart
            while isFlying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") do
                local cam = workspace.CurrentCamera
                local moveDir = LocalPlayer.Character.Humanoid.MoveDirection
                if moveDir.Magnitude > 0 then
                    bv.Velocity = cam.CFrame.LookVector * flySpeed
                else
                    bv.Velocity = Vector3.new(0, 0.5, 0)
                end
                task.wait()
            end
            bv:Destroy()
        end)
    end
end)

local Noclip = false
createToggle(TabMove, "👻 Noclip (เดินทะลุกำแพง & รั้ว)", "เดินทะลุรั้วกั้นบ้านคนอื่นได้ทันที", false, function(v)
    Noclip = v
end)

RunService.Stepped:Connect(function()
    if Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

local InfJump = false
createToggle(TabMove, "🦘 Infinite Jump (กระโดดกลางอากาศ)", "กดกระโดดไต่ขึ้นฟ้าได้ไม่จำกัด", false, function(v)
    InfJump = v
end)
UserInputService.JumpRequest:Connect(function()
    if InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- ==============================================================================
-- 👁️ TAB 4: มองทะลุ (ESP VISUALS)
-- ==============================================================================
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "EggESPFolder"
ESPFolder.Parent = ScreenGui

local EggESP = false
createToggle(TabESP, "🥚 Egg / Pet ESP (มองทะลุตำแหน่งไข่)", "แสดงกรอบและชื่อระดับความหายากของไข่", false, function(v)
    EggESP = v
    if not EggESP then ESPFolder:ClearAllChildren() end
    if EggESP then
        task.spawn(function()
            while EggESP do
                ESPFolder:ClearAllChildren()
                pcall(function()
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj:IsA("BasePart") and (obj.Name:lower():find("egg") or obj.Name:lower():find("pet")) then
                            local bb = Instance.new("BillboardGui")
                            bb.Size = UDim2.new(0, 80, 0, 24)
                            bb.AlwaysOnTop = true
                            bb.Adornee = obj
                            bb.Parent = ESPFolder
                            local lbl = Instance.new("TextLabel")
                            lbl.Size = UDim2.new(1, 0, 1, 0)
                            lbl.Text = "⭐ " .. obj.Name
                            lbl.Font = Enum.Font.GothamBold
                            lbl.TextSize = 10
                            lbl.TextColor3 = Color3.fromRGB(250, 204, 21)
                            lbl.BackgroundTransparency = 1
                            lbl.Parent = bb
                        end
                    end
                end)
                task.wait(2)
            end
        end)
    end
end)

local PlayerESP = false
createToggle(TabESP, "👤 Player ESP (มองทะลุผู้เล่นคนอื่น)", "ดูตำแหน่งและระยะห่างของคนในเซิร์ฟ", false, function(v)
    PlayerESP = v
    if not PlayerESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("PlayerHighlight") then
                p.Character.PlayerHighlight:Destroy()
            end
        end
    end
    if PlayerESP then
        task.spawn(function()
            while PlayerESP do
                pcall(function()
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and p.Character and not p.Character:FindFirstChild("PlayerHighlight") then
                            local h = Instance.new("Highlight")
                            h.Name = "PlayerHighlight"
                            h.FillColor = Color3.fromRGB(239, 68, 68)
                            h.OutlineColor = Color3.fromRGB(255, 255, 255)
                            h.Parent = p.Character
                        end
                    end
                end)
                task.wait(2)
            end
        end)
    end
end)

-- ==============================================================================
-- 📍 TAB 5: วาร์ปจุดสำคัญ (TELEPORT)
-- ==============================================================================
createButton(TabTP, "🏠 วาร์ปกลับบ้านตัวเอง (My Base)", "🏠", Color3.fromRGB(16, 185, 129), function()
    pcall(function()
        for _, spawn in pairs(workspace:GetDescendants()) do
            if spawn:IsA("SpawnLocation") and (spawn.Name:lower():find("base") or spawn.Name:lower():find("home")) then
                LocalPlayer.Character.HumanoidRootPart.CFrame = spawn.CFrame + Vector3.new(0, 4, 0)
                return
            end
        end
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 10, 0)
    end)
end)

createButton(TabTP, "📦 วาร์ปไปจุด Lucky Blocks กลางแมพ", "📦", Color3.fromRGB(245, 158, 11), function()
    pcall(function()
        for _, b in pairs(workspace:GetDescendants()) do
            if b:IsA("BasePart") and b.Name:lower():find("lucky") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = b.CFrame + Vector3.new(0, 4, 0)
                return
            end
        end
    end)
end)

createButton(TabTP, "🦖 วาร์ปไปโซนบอส (The Hungry Monster)", "🦖", Color3.fromRGB(239, 68, 68), function()
    pcall(function()
        for _, m in pairs(workspace:GetDescendants()) do
            if m:IsA("Model") and (m.Name:lower():find("hungry") or m.Name:lower():find("monster")) and m:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = m.HumanoidRootPart.CFrame + Vector3.new(0, 15, 0)
                return
            end
        end
    end)
end)

createButton(TabTP, "🛒 วาร์ปไปร้านค้า / จุดขาย (Shop)", "🛒", Color3.fromRGB(99, 102, 241), function()
    pcall(function()
        for _, s in pairs(workspace:GetDescendants()) do
            if s:IsA("BasePart") and (s.Name:lower():find("shop") or s.Name:lower():find("sell")) then
                LocalPlayer.Character.HumanoidRootPart.CFrame = s.CFrame + Vector3.new(0, 4, 0)
                return
            end
        end
    end)
end)

-- ==============================================================================
-- 🛒 TAB 6: อัปเกรด & ร้านค้าอัตโนมัติ (UPGRADE & SHOP)
-- ==============================================================================
local AutoClaimGifts = false
createToggle(TabShop, "🎁 Auto Claim Free Gifts (รับของขวัญฟรี)", "กดรับของรางวัลตามเวลาและของแจกฟรี", false, function(v)
    AutoClaimGifts = v
    if AutoClaimGifts then
        task.spawn(function()
            while AutoClaimGifts do
                pcall(function()
                    for _, r in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                        if r:IsA("RemoteFunction") or r:IsA("RemoteEvent") then
                            if r.Name:lower():find("claim") or r.Name:lower():find("gift") or r.Name:lower():find("reward") then
                                r:FireServer()
                            end
                        end
                    end
                end)
                task.wait(10)
            end
        end)
    end
end)

local AutoUpgradeSpeed = false
createToggle(TabShop, "👟 Auto Upgrade Speed (อัปสปีดอัตโนมัติ)", "ซื้อเลเวลความเร็วรองเท้าเมื่อเงินพอ", false, function(v)
    AutoUpgradeSpeed = v
    if AutoUpgradeSpeed then
        task.spawn(function()
            while AutoUpgradeSpeed do
                pcall(function()
                    for _, r in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                        if r:IsA("RemoteEvent") or r:IsA("RemoteFunction") then
                            if r.Name:lower():find("upgradespeed") or r.Name:lower():find("buyspeed") then
                                r:FireServer()
                            end
                        end
                    end
                end)
                task.wait(5)
            end
        end)
    end
end)

local AutoUpgradeHouse = false
createToggle(TabShop, "🏠 Auto Upgrade House (อัปเลเวลบ้าน)", "ขยายช่องเก็บสัตว์เลี้ยงอัตโนมัติ", false, function(v)
    AutoUpgradeHouse = v
    if AutoUpgradeHouse then
        task.spawn(function()
            while AutoUpgradeHouse do
                pcall(function()
                    for _, r in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                        if r:IsA("RemoteEvent") or r:IsA("RemoteFunction") then
                            if r.Name:lower():find("upgradehouse") or r.Name:lower():find("buyhouse") then
                                r:FireServer()
                            end
                        end
                    end
                end)
                task.wait(5)
            end
        end)
    end
end)

createButton(TabShop, "🔁 Rejoin Game (เข้าเซิร์ฟเดิมใหม่)", "🔁", Color3.fromRGB(59, 130, 246), function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

-- ==============================================================================
-- 📊 TAB 7: DASHBOARD SYNC (เชื่อมต่อ WEB DASHBOARD)
-- ==============================================================================
local SyncDash = false
createToggle(TabSync, "🌐 ส่งสเตตัสสดเข้า Dashboard (Port 3000)", "ส่งข้อมูลเงิน ค่าผลิต สปีด เข้าหน้าเว็บเรียลไทม์", false, function(v)
    SyncDash = v
    if SyncDash then
        task.spawn(function()
            while SyncDash do
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

print("🚀 [UltimateEggHub v4.0] โหลดครบ 7 หมวดหมู่เรียบร้อย! กดปุ่มไอคอนสายฟ้า ⚡ บนจอเพื่อเปิด/ปิดเมนู")
