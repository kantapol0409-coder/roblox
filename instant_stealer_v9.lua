-- ==============================================================================
-- ⚡ STEAL AN EGG & PET - INSTANT PROXIMITY PROMPT STEALER v9.0
-- 👑 ปลดล็อคปุ่ม [E] ให้กดขโมยติดทันทีใน 0.01 วินาที (ไม่ต้องกดค้าง / No Hold Duration)
-- 🎯 ออโต้ขโมยรังไข่ตรงหน้าแบบแม่นยำ 100% (แก้ปัญหาขโมยไม่ติด)
-- 📱 หน้าต่างเมนูภาษาไทย ออกแบบสำหรับ Android Emulator & Mobile
-- ==============================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
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

-- ⚡ 1. PROXIMITY PROMPT INSTANT HACK (ปรับให้กดขโมยติดทันที ไม่ต้องกดค้าง 3 วิ)
local function patchPrompts()
    for _, prompt in pairs(workspace:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") then
            prompt.HoldDuration = 0
            prompt.RequiresLineOfSight = false
            prompt.MaxActivationDistance = 25
        end
    end
end

patchPrompts()
workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("ProximityPrompt") then
        obj.HoldDuration = 0
        obj.RequiresLineOfSight = false
        obj.MaxActivationDistance = 25
    end
end)

-- ฟังก์ชันกระตุ้นการขโมย ProximityPrompt ทันที
local function triggerInstantPrompt(prompt)
    if not prompt or not prompt.Parent then return end
    prompt.HoldDuration = 0
    pcall(function()
        if fireproximityprompt then
            fireproximityprompt(prompt)
        end
        prompt:InputHoldBegin()
        task.wait(0.05)
        prompt:InputHoldEnd()
    end)
end

-- 🎨 2. GUI Setup
local parentGui = (gethui and gethui()) or game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")
if parentGui:FindFirstChild("InstantStealHubV9") then parentGui:FindFirstChild("InstantStealHubV9"):Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "InstantStealHubV9"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = parentGui

-- 🔘 Floating Toggle Button (⚡)
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
MainFrame.Size = UDim2.new(0, 480, 0, 360)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(11, 15, 25)
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
Title.Text = "⚡ INSTANT EGG STEALER (กด E ขโมยติดทันที)"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12.5
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

-- Scroll Container
local ScrollContent = Instance.new("ScrollingFrame")
ScrollContent.Size = UDim2.new(1, -20, 1, -54)
ScrollContent.Position = UDim2.new(0, 10, 0, 48)
ScrollContent.BackgroundTransparency = 1
ScrollContent.BorderSizePixel = 0
ScrollContent.ScrollBarThickness = 4
ScrollContent.ScrollBarImageColor3 = Color3.fromRGB(99, 102, 241)
ScrollContent.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 8)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = ScrollContent

-- Status Box
local StatusBox = Instance.new("Frame")
StatusBox.Size = UDim2.new(1, 0, 0, 36)
StatusBox.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
StatusBox.LayoutOrder = 1
StatusBox.Parent = ScrollContent
local StatCorner = Instance.new("UICorner")
StatCorner.CornerRadius = UDim.new(0, 8)
StatCorner.Parent = StatusBox
local StatStroke = Instance.new("UIStroke")
StatStroke.Color = Color3.fromRGB(55, 65, 81)
StatStroke.Parent = StatusBox

local StatusText = Instance.new("TextLabel")
StatusText.Text = "📍 สถานะ: 🟢 พร้อมใช้งาน (กดปุ่มส้มเพื่อฉกไข่ตรงหน้าทันที)"
StatusText.Font = Enum.Font.GothamMedium
StatusText.TextSize = 10.5
StatusText.TextColor3 = Color3.fromRGB(52, 211, 153)
StatusText.Position = UDim2.new(0, 10, 0, 0)
StatusText.Size = UDim2.new(1, -20, 1, 0)
StatusText.TextXAlignment = Enum.TextXAlignment.Left
StatusText.BackgroundTransparency = 1
StatusText.Parent = StatusBox

-- ==============================================================================
-- 👑 3. MAIN ACTION BUTTONS
-- ==============================================================================

-- 1. ปุ่มกดขโมยไข่ตรงหน้าทันที (Instant Grab Nearest Egg)
local StealNowBtn = Instance.new("TextButton")
StealNowBtn.Size = UDim2.new(1, 0, 0, 48)
StealNowBtn.BackgroundColor3 = Color3.fromRGB(234, 88, 12)
StealNowBtn.Text = "⚡ ขโมยไข่/สัตว์เลี้ยงตรงหน้านี้ทันที (INSTANT STEAL)"
StealNowBtn.Font = Enum.Font.GothamBold
StealNowBtn.TextSize = 13
StealNowBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StealNowBtn.LayoutOrder = 2
StealNowBtn.Parent = ScrollContent
local SNCorner = Instance.new("UICorner")
SNCorner.CornerRadius = UDim.new(0, 10)
SNCorner.Parent = StealNowBtn

StealNowBtn.MouseButton1Click:Connect(function()
    patchPrompts()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local stolenCount = 0
    for _, prompt in pairs(workspace:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") and prompt.Parent:IsA("BasePart") then
            if (prompt.Parent.Position - hrp.Position).Magnitude < 30 then
                triggerInstantPrompt(prompt)
                stolenCount = stolenCount + 1
            end
        end
    end

    if stolenCount > 0 then
        StatusText.Text = string.format("✅ ขโมยสำเร็จ %d ชิ้นทันที!", stolenCount)
        StatusText.TextColor3 = Color3.fromRGB(52, 211, 153)
    else
        StatusText.Text = "⚠️ ไม่พบปุ่มขโมยในรัศมีใกล้ๆ เดินไปยืนหน้ารังแล้วกดใหม่"
        StatusText.TextColor3 = Color3.fromRGB(245, 158, 11)
    end
end)

-- 2. สวิตช์เปิด Auto Steal Aura (เดินผ่านรังไหน ดูดขโมยไข่ติดมือทันที)
local isAutoAura = false
local AutoAuraBtn = Instance.new("TextButton")
AutoAuraBtn.Size = UDim2.new(1, 0, 0, 44)
AutoAuraBtn.BackgroundColor3 = Color3.fromRGB(16, 185, 129)
AutoAuraBtn.Text = "🚀 เปิดระบบขโมยอัตโนมัติรอบตัว (Auto Steal Aura: OFF)"
AutoAuraBtn.Font = Enum.Font.GothamBold
AutoAuraBtn.TextSize = 11.5
AutoAuraBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoAuraBtn.LayoutOrder = 3
AutoAuraBtn.Parent = ScrollContent
local AACorner = Instance.new("UICorner")
AACorner.CornerRadius = UDim.new(0, 8)
AACorner.Parent = AutoAuraBtn

AutoAuraBtn.MouseButton1Click:Connect(function()
    isAutoAura = not isAutoAura
    if isAutoAura then
        AutoAuraBtn.Text = "⏹️ ปิดระบบขโมยอัตโนมัติ (Auto Steal Aura: ON)"
        AutoAuraBtn.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
        StatusText.Text = "🚀 กำลังขโมยไข่อัตโนมัติทุกรังที่เดินผ่าน..."
        StatusText.TextColor3 = Color3.fromRGB(52, 211, 153)

        task.spawn(function()
            while isAutoAura do
                pcall(function()
                    patchPrompts()
                    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        for _, prompt in pairs(workspace:GetDescendants()) do
                            if prompt:IsA("ProximityPrompt") and prompt.Parent:IsA("BasePart") then
                                if (prompt.Parent.Position - hrp.Position).Magnitude < 25 then
                                    triggerInstantPrompt(prompt)
                                end
                            end
                        end
                    end
                end)
                task.wait(0.2)
            end
        end)
    else
        AutoAuraBtn.Text = "🚀 เปิดระบบขโมยอัตโนมัติรอบตัว (Auto Steal Aura: OFF)"
        AutoAuraBtn.BackgroundColor3 = Color3.fromRGB(16, 185, 129)
        StatusText.Text = "📍 สถานะ: ⏸️ ปิดระบบขโมยอัตโนมัติแล้ว"
        StatusText.TextColor3 = Color3.fromRGB(148, 163, 184)
    end
end)

-- 3. ปุ่มถือไม้เบสบอลฟาดคน/มอนสเตอร์รอบตัว
local isBatOn = false
local BatBtn = Instance.new("TextButton")
BatBtn.Size = UDim2.new(1, 0, 0, 38)
BatBtn.BackgroundColor3 = Color3.fromRGB(79, 70, 229)
BatBtn.Text = "🏏 ถือไม้เบสบอลฟาดศัตรูรอบตัว (Auto Bat Aura: OFF)"
BatBtn.Font = Enum.Font.GothamBold
BatBtn.TextSize = 11
BatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BatBtn.LayoutOrder = 4
BatBtn.Parent = ScrollContent
local BCorner = Instance.new("UICorner")
BCorner.CornerRadius = UDim.new(0, 8)
BCorner.Parent = BatBtn

BatBtn.MouseButton1Click:Connect(function()
    isBatOn = not isBatOn
    if isBatOn then
        BatBtn.Text = "🏏 ปิดไม้เบสบอล (Auto Bat Aura: ON)"
        BatBtn.BackgroundColor3 = Color3.fromRGB(220, 38, 38)
        task.spawn(function()
            while isBatOn do
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
    else
        BatBtn.Text = "🏏 ถือไม้เบสบอลฟาดศัตรูรอบตัว (Auto Bat Aura: OFF)"
        BatBtn.BackgroundColor3 = Color3.fromRGB(79, 70, 229)
    end
end)

print("⚡ [InstantStealHub v9.0] โหลดระบบขโมยติดทันทีเรียบร้อย!")
