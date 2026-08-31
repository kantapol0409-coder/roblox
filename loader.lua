-- ==============================================================================
-- ⚡ STEAL AN EGG - SOLARA PC & ALL EXECUTORS MASTER HUB v15.0
-- 👑 Zero External Dependency (โหลดขึ้นหน้าจอทันที 100% ไม่ติด Redirect / Solara Ready)
-- 🛡️ Anti-Kick Bypass + Anti-AFK + Guaranteed 100% Steal Engine
-- 📱 ดีไซน์หรูหรา 30+ ฟังก์ชัน: Auto Steal, Base Auto, World Farm, Combat, ESP, Teleport
-- ==============================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

-- 🛡️ 1. Anti-Kick Bypass
pcall(function()
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local method = getnamecallmethod():lower()
        if method == "kick" then return nil end
        if method == "fireserver" or method == "invokeserver" then
            local rName = tostring(self.Name):lower()
            if rName:find("bac") or rName:find("anticheat") or rName:find("cheat") or rName:find("ban") or rName:find("flag") or rName:find("security") then
                return nil
            end
        end
        return oldNamecall(self, ...)
    end))
end)

pcall(function()
    for _, conn in pairs(getconnections(LocalPlayer.Idled)) do
        if conn.Disable then conn:Disable() elseif conn.Disconnect then conn:Disconnect() end
    end
end)

-- พิกัดบ้านปลอดภัย
local SafeHomeCFrame = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.CFrame) or CFrame.new(0, 50, 0)

-- 🎨 2. GUI Setup (รองรับ Solara / CoreGui / PlayerGui 100%)
local parentGui = (gethui and gethui()) or LocalPlayer:WaitForChild("PlayerGui") or game:GetService("CoreGui")
if parentGui:FindFirstChild("SolaraMasterEggHub") then parentGui:FindFirstChild("SolaraMasterEggHub"):Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SolaraMasterEggHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = parentGui

-- 🔘 Floating Toggle Button (⚡)
local ToggleBtn = Instance.new("ImageButton")
ToggleBtn.Name = "FloatingToggle"
ToggleBtn.Size = UDim2.new(0, 52, 0, 52)
ToggleBtn.Position = UDim2.new(0.02, 0, 0.35, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
ToggleBtn.Image = "rbxassetid://10723415766"
ToggleBtn.ImageColor3 = Color3.fromRGB(250, 204, 21)
ToggleBtn.Parent = ScreenGui

local TCorner = Instance.new("UICorner")
TCorner.CornerRadius = UDim.new(1, 0)
TCorner.Parent = ToggleBtn
local TStroke = Instance.new("UIStroke")
TStroke.Color = Color3.fromRGB(99, 102, 241)
TStroke.Thickness = 2.5
TStroke.Parent = ToggleBtn

-- Draggable Toggle
local dragging, dragInput, dragStart, startPos
ToggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = ToggleBtn.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
ToggleBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        ToggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- 🖥️ MAIN FRAME
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 560, 0, 410)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -205)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 14, 26)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MCorner = Instance.new("UICorner")
MCorner.CornerRadius = UDim.new(0, 12)
MCorner.Parent = MainFrame
local MStroke = Instance.new("UIStroke")
MStroke.Color = Color3.fromRGB(99, 102, 241)
MStroke.Thickness = 2
MStroke.Parent = MainFrame

-- TopBar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 42)
TopBar.BackgroundColor3 = Color3.fromRGB(17, 24, 39)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Text = "⚡ STEAL AN EGG | SOLARA ULTIMATE HUB v15.0"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Position = UDim2.new(0, 14, 0, 0)
Title.Size = UDim2.new(0.75, 0, 1, 0)
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
CCorner.CornerRadius = UDim.new(0, 6)
CCorner.Parent = CloseBtn

local isUIVisible = true
local function toggleUI()
    isUIVisible = not isUIVisible
    MainFrame.Visible = isUIVisible
end
ToggleBtn.MouseButton1Click:Connect(toggleUI)
CloseBtn.MouseButton1Click:Connect(toggleUI)

-- PC Keybind (Left Control to Toggle)
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.LeftControl then
        toggleUI()
    end
end)

-- Sidebar & Content
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 140, 1, -42)
Sidebar.Position = UDim2.new(0, 0, 0, 42)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -150, 1, -50)
ContentArea.Position = UDim2.new(0, 145, 0, 46)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

local Tabs = {}
local function createTab(name)
    local F = Instance.new("ScrollingFrame")
    F.Size = UDim2.new(1, 0, 1, 0)
    F.BackgroundTransparency = 1
    F.BorderSizePixel = 0
    F.ScrollBarThickness = 3
    F.ScrollBarImageColor3 = Color3.fromRGB(99, 102, 241)
    F.Visible = false
    F.Parent = ContentArea
    local L = Instance.new("UIListLayout")
    L.Padding = UDim.new(0, 8)
    L.SortOrder = Enum.SortOrder.LayoutOrder
    L.Parent = F
    Tabs[name] = F
    return F
end

local TabSteal = createTab("Steal")
local TabBase = createTab("Base")
local TabWorld = createTab("World")
local TabCombat = createTab("Combat")
local TabESP = createTab("ESP")
local TabTP = createTab("TP")

local function createTabBtn(text, icon, name, order)
    local B = Instance.new("TextButton")
    B.Size = UDim2.new(1, -12, 0, 34)
    B.Position = UDim2.new(0, 6, 0, (order - 1) * 38 + 8)
    B.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
    B.Text = icon .. " " .. text
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

local b1 = createTabBtn("ขโมย (Steal)", "🎯", "Steal", 1)
local b2 = createTabBtn("คอกเรา (Base)", "🏠", "Base", 2)
local b3 = createTabBtn("ฟาร์มแมพ (World)", "📦", "World", 3)
local b4 = createTabBtn("ต่อสู้ (Combat)", "⚔️", "Combat", 4)
local b5 = createTabBtn("มองทะลุ (ESP)", "👁️", "ESP", 5)
local b6 = createTabBtn("วาร์ป (Teleport)", "🚀", "TP", 6)

b1.BackgroundColor3 = Color3.fromRGB(79, 70, 229)
b1.TextColor3 = Color3.fromRGB(255, 255, 255)
TabSteal.Visible = true

-- Helper UI Functions
local function createToggle(parent, title, desc, default, callback)
    local F = Instance.new("Frame")
    F.Size = UDim2.new(1, -6, 0, 46)
    F.BackgroundColor3 = Color3.fromRGB(17, 24, 39)
    F.Parent = parent
    local FC = Instance.new("UICorner")
    FC.CornerRadius = UDim.new(0, 8)
    FC.Parent = F

    local L = Instance.new("TextLabel")
    L.Text = title
    L.Font = Enum.Font.GothamSemibold
    L.TextSize = 11.5
    L.TextColor3 = Color3.fromRGB(243, 244, 246)
    L.Position = UDim2.new(0, 10, 0, 6)
    L.Size = UDim2.new(0.72, 0, 0, 16)
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.BackgroundTransparency = 1
    L.Parent = F

    local Sub = Instance.new("TextLabel")
    Sub.Text = desc or ""
    Sub.Font = Enum.Font.Gotham
    Sub.TextSize = 9
    Sub.TextColor3 = Color3.fromRGB(156, 163, 175)
    Sub.Position = UDim2.new(0, 10, 0, 24)
    Sub.Size = UDim2.new(0.72, 0, 0, 16)
    Sub.TextXAlignment = Enum.TextXAlignment.Left
    Sub.BackgroundTransparency = 1
    Sub.Parent = F

    local B = Instance.new("TextButton")
    B.Size = UDim2.new(0, 52, 0, 26)
    B.Position = UDim2.new(1, -62, 0.5, -13)
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

local function createButton(parent, title, desc, btnText, color, callback)
    local F = Instance.new("Frame")
    F.Size = UDim2.new(1, -6, 0, 46)
    F.BackgroundColor3 = Color3.fromRGB(17, 24, 39)
    F.Parent = parent
    local FC = Instance.new("UICorner")
    FC.CornerRadius = UDim.new(0, 8)
    FC.Parent = F

    local L = Instance.new("TextLabel")
    L.Text = title
    L.Font = Enum.Font.GothamSemibold
    L.TextSize = 11.5
    L.TextColor3 = Color3.fromRGB(243, 244, 246)
    L.Position = UDim2.new(0, 10, 0, 6)
    L.Size = UDim2.new(0.68, 0, 0, 16)
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.BackgroundTransparency = 1
    L.Parent = F

    local Sub = Instance.new("TextLabel")
    Sub.Text = desc or ""
    Sub.Font = Enum.Font.Gotham
    Sub.TextSize = 9
    Sub.TextColor3 = Color3.fromRGB(156, 163, 175)
    Sub.Position = UDim2.new(0, 10, 0, 24)
    Sub.Size = UDim2.new(0.68, 0, 0, 16)
    Sub.TextXAlignment = Enum.TextXAlignment.Left
    Sub.BackgroundTransparency = 1
    Sub.Parent = F

    local B = Instance.new("TextButton")
    B.Size = UDim2.new(0, 75, 0, 28)
    B.Position = UDim2.new(1, -85, 0.5, -14)
    B.BackgroundColor3 = color or Color3.fromRGB(79, 70, 229)
    B.Text = btnText
    B.Font = Enum.Font.GothamBold
    B.TextSize = 10.5
    B.TextColor3 = Color3.fromRGB(255, 255, 255)
    B.Parent = F
    local BC = Instance.new("UICorner")
    BC.CornerRadius = UDim.new(0, 6)
    BC.Parent = B

    B.MouseButton1Click:Connect(callback)
end

-- ==============================================================================
-- 🚀 3. CORE LOGIC: GUARANTEED STEAL 100%
-- ==============================================================================
local function executeSteal(prompt, targetPart, autoReturn)
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp or not targetPart then return false end

    hrp.Velocity = Vector3.new(0, 0, 0)
    hrp.CFrame = targetPart.CFrame + Vector3.new(0, 1.5, 0)
    task.wait(0.12)

    local bat = LocalPlayer.Backpack:FindFirstChild("Bat") or LocalPlayer.Character:FindFirstChild("Bat")
    if bat and bat.Parent == LocalPlayer.Backpack then LocalPlayer.Character.Humanoid:EquipTool(bat) end

    for attempt = 1, 4 do
        if not prompt or not prompt.Parent then break end

        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        task.wait(0.04)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)

        if fireproximityprompt then fireproximityprompt(prompt, 0); fireproximityprompt(prompt) end

        pcall(function()
            firetouchinterest(hrp, targetPart, 0)
            task.wait(0.02)
            firetouchinterest(hrp, targetPart, 1)
        end)

        pcall(function()
            for _, r in pairs(ReplicatedStorage:GetDescendants()) do
                if r:IsA("RemoteEvent") and (r.Name:lower():find("steal") or r.Name:lower():find("pickup") or r.Name:lower():find("egg")) then
                    r:FireServer(targetPart)
                end
            end
        end)

        task.wait(0.08)
    end

    task.wait(0.15)
    if autoReturn then
        hrp.Velocity = Vector3.new(0, 0, 0)
        hrp.CFrame = SafeHomeCFrame
        task.wait(0.3)
    end
    return true
end

-- ==============================================================================
-- 🎯 TAB 1: AUTO STEAL
-- ==============================================================================
local isAutoSteal = false
local AutoReturnBase = true

createToggle(TabSteal, "🚀 เริ่มระบบขโมยอัตโนมัติ (Auto Steal Loop)", "สแกนรังไข่ทั่วทั้งเซิร์ฟเวอร์ วาร์ปไปฉกแล้วส่งกลับบ้าน", false, function(v)
    isAutoSteal = v
    if isAutoSteal then
        task.spawn(function()
            while isAutoSteal do
                pcall(function()
                    local myPos = SafeHomeCFrame.Position
                    local nests = {}
                    for _, p in pairs(workspace:GetDescendants()) do
                        if not isAutoSteal then break end
                        if p:IsA("ProximityPrompt") and p.Parent:IsA("BasePart") then
                            local dist = (p.Parent.Position - myPos).Magnitude
                            if dist > 25 then
                                table.insert(nests, { prompt = p, part = p.Parent, dist = dist })
                            end
                        end
                    end
                    table.sort(nests, function(a, b) return a.dist < b.dist end)

                    if #nests > 0 then
                        for _, n in ipairs(nests) do
                            if not isAutoSteal then break end
                            executeSteal(n.prompt, n.part, AutoReturnBase)
                            task.wait(0.5)
                        end
                    else
                        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local bat = LocalPlayer.Backpack:FindFirstChild("Bat") or LocalPlayer.Character:FindFirstChild("Bat")
                            if bat and bat.Parent == LocalPlayer.Backpack then LocalPlayer.Character.Humanoid:EquipTool(bat) end
                            for _, obj in pairs(workspace:GetDescendants()) do
                                if obj:IsA("BasePart") and (obj.Name:lower():find("lucky") or obj.Name:lower():find("block")) then
                                    hrp.CFrame = obj.CFrame + Vector3.new(0, 4, 0)
                                    if bat and bat:FindFirstChild("Handle") then
                                        firetouchinterest(bat.Handle, obj, 0)
                                        firetouchinterest(bat.Handle, obj, 1)
                                    end
                                    task.wait(0.2)
                                end
                            end
                        end
                    end
                end)
                task.wait(1)
            end
        end)
    end
end)

createToggle(TabSteal, "🏠 วาร์ปกลับบ้านหลังฉกเสร็จ (Auto Return)", "นำไข่กลับมาส่งที่คอกเราอัตโนมัติ", true, function(v)
    AutoReturnBase = v
end)

createButton(TabSteal, "⚡ ฉกรังไข่ที่ใกล้ที่สุด 1 รังทันที", "วาร์ปไปฉกไข่ที่ใกล้ที่สุดแล้วพากลับบ้าน", "ฉกทันที", Color3.fromRGB(234, 88, 12), function()
    local myPos = SafeHomeCFrame.Position
    for _, p in pairs(workspace:GetDescendants()) do
        if p:IsA("ProximityPrompt") and p.Parent:IsA("BasePart") then
            if (p.Parent.Position - myPos).Magnitude > 25 then
                executeSteal(p, p.Parent, AutoReturnBase)
                break
            end
        end
    end
end)

-- ==============================================================================
-- 🏠 TAB 2: BASE AUTOMATION
-- ==============================================================================
local isAutoCollect = false
local isAutoUpgrade = false

createToggle(TabBase, "💵 ดูดเงินทั้งหมดในคอก (Auto Collect Cash)", "เก็บเงินทุกบาทในคอกเราเข้าตัวทันที", false, function(v)
    isAutoCollect = v
    if isAutoCollect then
        task.spawn(function()
            while isAutoCollect do
                pcall(function()
                    for _, r in pairs(ReplicatedStorage:GetDescendants()) do
                        if r:IsA("RemoteEvent") and (r.Name:lower():find("collect") or r.Name:lower():find("cash") or r.Name:lower():find("money")) then
                            r:FireServer()
                        end
                    end
                end)
                task.wait(1)
            end
        end)
    end
end)

createToggle(TabBase, "🏗️ อัปเกรดคอกอัตโนมัติ (Auto Upgrade Plot)", "ขยายช่องสัตว์เลี้ยงและเพิ่มเลเวลคอก", false, function(v)
    isAutoUpgrade = v
    if isAutoUpgrade then
        task.spawn(function()
            while isAutoUpgrade do
                pcall(function()
                    for _, r in pairs(ReplicatedStorage:GetDescendants()) do
                        if r:IsA("RemoteEvent") and (r.Name:lower():find("upgrade") or r.Name:lower():find("buyslot")) then
                            r:FireServer()
                        end
                    end
                end)
                task.wait(3)
            end
        end)
    end
end)

createButton(TabBase, "📌 บันทึกตำแหน่งยืนปัจจุบันเป็นบ้าน", "ล็อคพิกัดคอกเราที่จะวาร์ปกลับมาส่งของ", "บันทึก", Color3.fromRGB(59, 130, 246), function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        SafeHomeCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
    end
end)

-- ==============================================================================
-- 📦 TAB 3: WORLD FARM
-- ==============================================================================
local isAutoLucky = false
local isAutoBoss = false

createToggle(TabWorld, "📦 ฟาร์มเสากล่อง Lucky Blocks กลางแมพ", "ยืนทุบเสากล่องสุ่มเพื่อปั๊มเงิน $B/s และดรอปสัตว์เลี้ยง", false, function(v)
    isAutoLucky = v
    if isAutoLucky then
        task.spawn(function()
            while isAutoLucky do
                pcall(function()
                    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local bat = LocalPlayer.Backpack:FindFirstChild("Bat") or LocalPlayer.Character:FindFirstChild("Bat")
                        if bat and bat.Parent == LocalPlayer.Backpack then LocalPlayer.Character.Humanoid:EquipTool(bat) end
                        for _, obj in pairs(workspace:GetDescendants()) do
                            if obj:IsA("BasePart") and (obj.Name:lower():find("lucky") or obj.Name:lower():find("block")) then
                                hrp.CFrame = obj.CFrame + Vector3.new(0, 4, 0)
                                if bat and bat:FindFirstChild("Handle") then
                                    firetouchinterest(bat.Handle, obj, 0)
                                    task.wait(0.04)
                                    firetouchinterest(bat.Handle, obj, 1)
                                end
                                task.wait(0.2)
                            end
                        end
                    end
                end)
                task.wait(0.4)
            end
        end)
    end
end)

createToggle(TabWorld, "🦖 ฟาร์มตีบอส The Hungry Monster", "วาร์ปไปตีบอสรับรางวัลใหญ่", false, function(v)
    isAutoBoss = v
    if isAutoBoss then
        task.spawn(function()
            while isAutoBoss do
                pcall(function()
                    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local bat = LocalPlayer.Backpack:FindFirstChild("Bat") or LocalPlayer.Character:FindFirstChild("Bat")
                        if bat and bat.Parent == LocalPlayer.Backpack then LocalPlayer.Character.Humanoid:EquipTool(bat) end
                        for _, m in pairs(workspace:GetDescendants()) do
                            if m:IsA("Model") and (m.Name:lower():find("hungry") or m.Name:lower():find("monster")) then
                                local tp = m.PrimaryPart or m:FindFirstChildWhichIsA("BasePart")
                                if tp then
                                    hrp.CFrame = tp.CFrame + Vector3.new(0, 8, 0)
                                    if bat and bat:FindFirstChild("Handle") then
                                        firetouchinterest(bat.Handle, tp, 0)
                                        firetouchinterest(bat.Handle, tp, 1)
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

createToggle(TabWorld, "🎁 รับของขวัญฟรีทุกอย่าง (Time & Daily)", "กดรับรางวัลเวลารายวันและของขวัญฟรี", true, function(v)
    if v then
        task.spawn(function()
            for _, r in pairs(ReplicatedStorage:GetDescendants()) do
                if r:IsA("RemoteEvent") and (r.Name:lower():find("claim") or r.Name:lower():find("gift") or r.Name:lower():find("reward")) then
                    r:FireServer()
                end
            end
        end)
    end
end)

-- ==============================================================================
-- ⚔️ TAB 4: COMBAT & MOVEMENT
-- ==============================================================================
local isBatAura = false
local isNoclip = true

createToggle(TabCombat, "🏏 ถือไม้เบสบอลฟาดคนรอบตัว (Auto Bat Aura)", "ฟาดทุกคนรอบตัว 360 องศาเพื่อป้องกันขโมย", false, function(v)
    isBatAura = v
    if isBatAura then
        task.spawn(function()
            while isBatAura do
                pcall(function()
                    local bat = LocalPlayer.Backpack:FindFirstChild("Bat") or LocalPlayer.Character:FindFirstChild("Bat")
                    if bat and bat.Parent == LocalPlayer.Backpack then LocalPlayer.Character.Humanoid:EquipTool(bat) end
                    if bat and bat:FindFirstChild("Handle") then
                        for _, p in pairs(Players:GetPlayers()) do
                            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                                if (p.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 20 then
                                    firetouchinterest(bat.Handle, p.Character.HumanoidRootPart, 0)
                                    task.wait(0.02)
                                    firetouchinterest(bat.Handle, p.Character.HumanoidRootPart, 1)
                                end
                            end
                        end
                    end
                end)
                task.wait(0.15)
            end
        end)
    end
end)

createToggle(TabCombat, "👻 เดินทะลุรั้วคอก (Safe Noclip)", "เดินทะลุรั้วคอกกั้นทุกประเภทโดยไม่ตกโลก", true, function(v)
    isNoclip = v
end)

RunService.Stepped:Connect(function()
    if isNoclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and (part.Name:lower():find("arm") or part.Name:lower():find("leg") or part.Name:lower():find("torso")) then
                part.CanCollide = false
            end
        end
    end
end)

-- ==============================================================================
-- 👁️ TAB 5: ESP
-- ==============================================================================
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "MasterESPFolder"
ESPFolder.Parent = ScreenGui

local isESP = false
local function updateESP()
    ESPFolder:ClearAllChildren()
    if not isESP then return end
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and not obj:IsDescendantOf(LocalPlayer.Character) then
            local primary = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
            local n = obj.Name:lower()
            if primary and (n:find("chilli") or n:find("dragon") or n:find("cerberus") or n:find("godzilla") or n:find("milk") or n:find("pet") or n:find("egg")) then
                local bb = Instance.new("BillboardGui")
                bb.Size = UDim2.new(0, 120, 0, 30)
                bb.AlwaysOnTop = true
                bb.Adornee = primary
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
    end
end

createToggle(TabESP, "👁️ มองทะลุสัตว์เลี้ยงและไข่ (Pet 3D ESP)", "ขึ้นกรอบสีทองบอกชื่อสัตว์เลี้ยงและไข่ทุกตัวในแมพ", false, function(v)
    isESP = v
    updateESP()
end)

-- ==============================================================================
-- 🚀 TAB 6: TELEPORTS
-- ==============================================================================
createButton(TabTP, "🏠 วาร์ปกลับคอกเรา (Teleport Base)", "วาร์ปกลับจุดส่งของทันที", "วาร์ป", Color3.fromRGB(59, 130, 246), function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        LocalPlayer.Character.HumanoidRootPart.CFrame = SafeHomeCFrame
    end
end)

createButton(TabTP, "📦 วาร์ปไปเสากล่อง Lucky Blocks", "วาร์ปไปเสากล่องสุ่มกลางแมพ", "วาร์ป", Color3.fromRGB(234, 88, 12), function()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("lucky") or obj.Name:lower():find("block")) then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0, 5, 0)
                break
            end
        end
    end
end)

createButton(TabTP, "🦖 วาร์ปไปหาบอส The Hungry Monster", "วาร์ปไปจุดเกิดบอส", "วาร์ป", Color3.fromRGB(16, 185, 129), function()
    for _, m in pairs(workspace:GetDescendants()) do
        if m:IsA("Model") and (m.Name:lower():find("hungry") or m.Name:lower():find("monster")) then
            local tp = m.PrimaryPart or m:FindFirstChildWhichIsA("BasePart")
            if tp and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = tp.CFrame + Vector3.new(0, 8, 0)
                break
            end
        end
    end
end)

createButton(TabTP, "🚨 กู้ชีพด่วน! ดึงตัวกลับมาบนพื้นหญ้า", "กดเมื่อตัวละครหลุดลอยฟ้าหรือตกโลก", "กู้ชีพ", Color3.fromRGB(220, 38, 38), function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        LocalPlayer.Character.HumanoidRootPart.CFrame = SafeHomeCFrame
    end
end)

print("⚡ [Solara Master Hub v15.0] โหลดระบบสมบูรณ์ 100% พร้อมใช้งานบน Solara!")
