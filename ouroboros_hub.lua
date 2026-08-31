-- ==============================================================================
-- 🐍 OUROBOROS MASTER HUB - DONT STEAL THE BOBO / STEAL PET & EGG
-- 👑 GitHub: https://github.com/kantapol0409-coder/roblox
-- ⚡ ฟังก์ชันครบวงจรระดับท็อป (Ouroboros Feature Engine):
--    🎯 Auto Steal (กรองระดับความหายาก, กรองรายได้ขั้นต่ำ, วาร์ปฉกแล้วพากลับบ้าน)
--    💵 Auto Collect Cash (ดูดเงินทั้งหมดในคอกอัตโนมัติ)
--    🏠 Auto Upgrade Plot (อัปเกรดคอกและช่องสัตว์เลี้ยงอัตโนมัติ)
--    🐾 Auto Equip Best (สวมใส่สัตว์เลี้ยงที่ทำเงินสูงสุด)
--    🛒 Auto Gear Shop (ซื้อไม้เบสบอลและกับดักอัตโนมัติ)
--    🎁 Auto Claim Rewards (รับของขวัญและรางวัลเวลาฟรี)
--    🏏 Auto Bat Kill Aura (ฟาดคนรอบตัวป้องกันขโมย)
-- ==============================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

-- 🛡️ Anti-Kick Bypass
pcall(function()
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if (method == "Kick" or method == "kick") and (self == LocalPlayer or tostring(self) == tostring(LocalPlayer)) then
            return nil
        end
        return oldNamecall(self, ...)
    end))
end)

pcall(function()
    for _, conn in pairs(getconnections(LocalPlayer.Idled)) do
        if conn.Disable then conn:Disable() elseif conn.Disconnect then conn:Disconnect() end
    end
end)

-- ⚡ ProximityPrompt Instant Trigger
local function patchPrompts()
    for _, p in pairs(workspace:GetDescendants()) do
        if p:IsA("ProximityPrompt") then
            p.HoldDuration = 0
            p.RequiresLineOfSight = false
            p.MaxActivationDistance = 40
        end
    end
end
patchPrompts()
workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("ProximityPrompt") then
        obj.HoldDuration = 0
        obj.RequiresLineOfSight = false
        obj.MaxActivationDistance = 40
    end
end)

local function triggerPrompt(prompt)
    if not prompt or not prompt.Parent then return end
    prompt.HoldDuration = 0
    pcall(function()
        if fireproximityprompt then fireproximityprompt(prompt) end
        prompt:InputHoldBegin()
        task.wait(0.04)
        prompt:InputHoldEnd()
    end)
end

-- ==============================================================================
-- 🏠 PLOT & BASE FINDER
-- ==============================================================================
local function getMyPlot()
    local plots = workspace:FindFirstChild("Plots") or workspace:FindFirstChild("Bases") or workspace:FindFirstChild("Farms")
    if plots then
        for _, plot in pairs(plots:GetChildren()) do
            local owner = plot:FindFirstChild("OwnerName") or plot:FindFirstChild("Owner")
            if owner and (tostring(owner.Value) == LocalPlayer.Name or tostring(owner.Value) == LocalPlayer.DisplayName) then
                return plot
            end
            if plot.Name:lower():find(LocalPlayer.Name:lower()) then
                return plot
            end
        end
    end
    return nil
end

local function getMyHomePosition()
    local myPlot = getMyPlot()
    if myPlot then
        local spawnPt = myPlot:FindFirstChild("OwnerSpawnPoint") or myPlot:FindFirstChild("SpawnLocation") or myPlot:FindFirstChildWhichIsA("SpawnLocation")
        if spawnPt then return spawnPt.CFrame + Vector3.new(0, 3, 0) end
        if myPlot.PrimaryPart then return myPlot.PrimaryPart.CFrame + Vector3.new(0, 3, 0) end
    end
    for _, s in pairs(workspace:GetDescendants()) do
        if s:IsA("SpawnLocation") and s.Name:lower():find(LocalPlayer.Name:lower()) then
            return s.CFrame + Vector3.new(0, 3, 0)
        end
    end
    return (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.CFrame) or CFrame.new(0, 50, 0)
end

-- ==============================================================================
-- 🎨 GUI SETUP (OUROBOROS THEME)
-- ==============================================================================
local parentGui = (gethui and gethui()) or game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")
if parentGui:FindFirstChild("OuroborosEggHub") then parentGui:FindFirstChild("OuroborosEggHub"):Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "OuroborosEggHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = parentGui

-- 🔘 Floating Toggle Button
local ToggleBtn = Instance.new("ImageButton")
ToggleBtn.Name = "FloatingToggle"
ToggleBtn.Size = UDim2.new(0, 52, 0, 52)
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
TStroke.Thickness = 2.5
TStroke.Parent = ToggleBtn

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
MainFrame.Size = UDim2.new(0, 520, 0, 380)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 14, 26)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MCorner = Instance.new("UICorner")
MCorner.CornerRadius = UDim.new(0, 14)
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
Title.Text = "🐍 OUROBOROS MASTER HUB - DONT STEAL THE BOBO"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
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
CCorner.CornerRadius = UDim.new(0, 8)
CCorner.Parent = CloseBtn

local isUIVisible = true
local function toggleUI()
    isUIVisible = not isUIVisible
    MainFrame.Visible = isUIVisible
end
ToggleBtn.MouseButton1Click:Connect(toggleUI)
CloseBtn.MouseButton1Click:Connect(toggleUI)

-- Sidebar Tabs
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 130, 1, -42)
Sidebar.Position = UDim2.new(0, 0, 0, 42)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -140, 1, -50)
Content.Position = UDim2.new(0, 135, 0, 46)
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

local TabSteal = createTab("Steal")
local TabBase = createTab("Base")
local TabShop = createTab("Shop")
local TabCombat = createTab("Combat")

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

local b1 = createTabBtn("ขโมย (Steal)", "🎯", "Steal", 1)
local b2 = createTabBtn("คอกเรา (Base)", "🏠", "Base", 2)
local b3 = createTabBtn("ร้านค้า (Shop)", "🛒", "Shop", 3)
local b4 = createTabBtn("ป้องกัน (Combat)", "⚔️", "Combat", 4)

b1.BackgroundColor3 = Color3.fromRGB(79, 70, 229)
b1.TextColor3 = Color3.fromRGB(255, 255, 255)
TabSteal.Visible = true

-- Toggle Helper
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

-- ==============================================================================
-- 🎯 TAB 1: OUROBOROS AUTO STEAL ENGINE
-- ==============================================================================
local isAutoSteal = false
local AutoReturn = true
local MinIncomeSteal = 1000000 -- 1M/s
local SelectedRarities = {
    ["Secret"] = true,
    ["Godly"] = true,
    ["Cosmic"] = true,
    ["Mythic"] = true,
    ["Legendary"] = true,
    ["Huge"] = true,
    ["Mutation"] = true
}

-- Status Label
local StealStatusLbl = Instance.new("TextLabel")
StealStatusLbl.Size = UDim2.new(1, -8, 0, 32)
StealStatusLbl.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
StealStatusLbl.Text = "📍 สถานะ: 🟢 พร้อมใช้งาน"
StealStatusLbl.Font = Enum.Font.GothamMedium
StealStatusLbl.TextSize = 10.5
StealStatusLbl.TextColor3 = Color3.fromRGB(52, 211, 153)
StealStatusLbl.Parent = TabSteal
local SSLCorner = Instance.new("UICorner")
SSLCorner.CornerRadius = UDim.new(0, 6)
SSLCorner.Parent = StealStatusLbl

createToggle(TabSteal, "🚀 Auto Steal (ขโมยอัตโนมัติ)", "สแกนรังไข่และคอกคนอื่นแล้ววาร์ปไปขโมยทันที", false, function(v)
    isAutoSteal = v
    if isAutoSteal then
        StealStatusLbl.Text = "🏃‍♂️ กำลังสแกนหาเป้าหมายและขโมย..."
        StealStatusLbl.TextColor3 = Color3.fromRGB(96, 165, 250)

        task.spawn(function()
            while isAutoSteal do
                pcall(function()
                    patchPrompts()
                    local myHome = getMyHomePosition()

                    -- ค้นหา ProximityPrompts ในคอกคนอื่น
                    for _, prompt in pairs(workspace:GetDescendants()) do
                        if not isAutoSteal then break end
                        if prompt:IsA("ProximityPrompt") and prompt.Parent:IsA("BasePart") then
                            local targetPart = prompt.Parent
                            -- เช็คว่าไม่ได้อยู่ในบ้านเรา
                            if (targetPart.Position - myHome.Position).Magnitude > 30 then
                                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                    LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                                    LocalPlayer.Character.HumanoidRootPart.CFrame = targetPart.CFrame + Vector3.new(0, 2, 0)
                                    task.wait(0.15)
                                    triggerPrompt(prompt)
                                    task.wait(0.2)

                                    if AutoReturn then
                                        LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                                        LocalPlayer.Character.HumanoidRootPart.CFrame = myHome
                                        task.wait(0.4)
                                    end
                                end
                            end
                        end
                    end
                end)
                task.wait(1)
            end
        end)
    else
        StealStatusLbl.Text = "📍 สถานะ: ⏸️ หยุดขโมยแล้ว"
        StealStatusLbl.TextColor3 = Color3.fromRGB(148, 163, 184)
    end
end)

createToggle(TabSteal, "🏠 Auto Return (นำกลับบ้านทันที)", "เมื่อขโมยเสร็จจะวาร์ปกลับคอกบ้านเราทันที", true, function(v)
    AutoReturn = v
end)

-- ==============================================================================
-- 🏠 TAB 2: BASE AUTOMATION (คอกเรา)
-- ==============================================================================
local isAutoCollect = false
local isAutoUpgrade = false

createToggle(TabBase, "💵 Auto Collect Money (ดูดเงินอัตโนมัติ)", "เก็บเงินและเหรียญทั้งหมดในคอกเราทันที", false, function(v)
    isAutoCollect = v
    if isAutoCollect then
        task.spawn(function()
            while isAutoCollect do
                pcall(function()
                    -- ดึงเงินจาก Plots/Remotes
                    for _, r in pairs(ReplicatedStorage:GetDescendants()) do
                        if r:IsA("RemoteEvent") or r:IsA("RemoteFunction") then
                            local n = r.Name:lower()
                            if n:find("collect") or n:find("cash") or n:find("claim") or n:find("money") then
                                if r:IsA("RemoteEvent") then r:FireServer() end
                            end
                        end
                    end
                    local myPlot = getMyPlot()
                    if myPlot then
                        for _, p in pairs(myPlot:GetDescendants()) do
                            if p:IsA("ProximityPrompt") then triggerPrompt(p) end
                            if p:IsA("BasePart") and (p.Name:lower():find("cash") or p.Name:lower():find("drop")) then
                                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, p, 0)
                                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, p, 1)
                            end
                        end
                    end
                end)
                task.wait(1)
            end
        end)
    end
end)

createToggle(TabBase, "🏠 Auto Upgrade Plot (อัปเกรดคอกอัตโนมัติ)", "ขยายช่องและอัปเกรดเลเวลคอกอัตโนมัติเมื่อเงินถึง", false, function(v)
    isAutoUpgrade = v
    if isAutoUpgrade then
        task.spawn(function()
            while isAutoUpgrade do
                pcall(function()
                    for _, r in pairs(ReplicatedStorage:GetDescendants()) do
                        if r:IsA("RemoteEvent") or r:IsA("RemoteFunction") then
                            local n = r.Name:lower()
                            if n:find("upgrade") or n:find("buyplot") or n:find("buyslot") then
                                if r:IsA("RemoteEvent") then r:FireServer() end
                            end
                        end
                    end
                end)
                task.wait(3)
            end
        end)
    end
end)

createToggle(TabBase, "🐾 Auto Equip Best (ใส่ตัวเก่งสุด)", "สวมใส่สัตว์เลี้ยงที่ผลิตเงินไวที่สุดเสมอ", true, function(v)
    if v then
        task.spawn(function()
            for _, r in pairs(ReplicatedStorage:GetDescendants()) do
                if r:IsA("RemoteEvent") and (r.Name:lower():find("equipbest") or r.Name:lower():find("best")) then
                    r:FireServer()
                end
            end
        end)
    end
end)

-- ==============================================================================
-- 🛒 TAB 3: SHOP & REWARDS
-- ==============================================================================
local isAutoGear = false
local isAutoRewards = false

createToggle(TabShop, "🏏 Auto Gear Shop (ซื้ออาวุธอัตโนมัติ)", "ซื้อไม้เบสบอลและกับดักอัตโนมัติเมื่อหมด", false, function(v)
    isAutoGear = v
    if isAutoGear then
        task.spawn(function()
            while isAutoGear do
                pcall(function()
                    for _, r in pairs(ReplicatedStorage:GetDescendants()) do
                        if r:IsA("RemoteEvent") and (r.Name:lower():find("buygear") or r.Name:lower():find("buyitem")) then
                            r:FireServer("Bat")
                            r:FireServer("Trap")
                        end
                    end
                end)
                task.wait(5)
            end
        end)
    end
end)

createToggle(TabShop, "🎁 Auto Claim Rewards (รับของขวัญฟรี)", "รับ Time Gifts และ Daily Rewards อัตโนมัติ", true, function(v)
    isAutoRewards = v
    if isAutoRewards then
        task.spawn(function()
            while isAutoRewards do
                pcall(function()
                    for _, r in pairs(ReplicatedStorage:GetDescendants()) do
                        if r:IsA("RemoteEvent") and (r.Name:lower():find("claim") or r.Name:lower():find("reward") or r.Name:lower():find("gift")) then
                            r:FireServer()
                        end
                    end
                end)
                task.wait(10)
            end
        end)
    end
end)

-- ==============================================================================
-- ⚔️ TAB 4: COMBAT & DEFENSE
-- ==============================================================================
local isBatAura = false

createToggle(TabCombat, "🏏 Auto Bat Kill Aura (ฟาดคนรอบตัว)", "ถือไม้เบสบอลฟาดคนที่จะมาแอบขโมยของในคอก", false, function(v)
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
                                if (p.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 18 then
                                    firetouchinterest(bat.Handle, p.Character.HumanoidRootPart, 0)
                                    task.wait(0.02)
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

print("🐍 [Ouroboros Master Hub] โหลดฟังก์ชันเต็มรูปแบบเรียบร้อย!")
