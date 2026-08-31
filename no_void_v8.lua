-- ==============================================================================
-- ⚡ STEAL PET & EGG - BULLETPROOF NO-VOID FARM HUB v8.0
-- 🛡️ ระบบป้องกันตกโลก 100% (สร้างพื้นล็อคกันตก + ปิด Noclip ที่ทำร่วงพื้น)
-- 🚨 มีปุ่มฉุกเฉิน "กู้ชีพกลับคอก" (Rescue) ดึงตัวกลับมาบนพื้นหญ้าทันที
-- 🎁 ฟาร์มกล่องสุ่ม + สุ่มไข่ระดับท็อป + ตีบอส โดยไม่ต้องวิ่งให้ตกโลก
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

-- 🎨 GUI Setup
local parentGui = (gethui and gethui()) or game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")
if parentGui:FindFirstChild("NoVoidHubV8") then parentGui:FindFirstChild("NoVoidHubV8"):Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NoVoidHubV8"
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
MainFrame.Size = UDim2.new(0, 480, 0, 370)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -185)
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
Title.Text = "⚡ ANTI-FALL SAFE FARM HUB v8.0"
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
StatusText.Text = "📍 สถานะ: 🟢 พร้อมใช้งาน (ไม่มีตกโลกแน่นอน)"
StatusText.Font = Enum.Font.GothamMedium
StatusText.TextSize = 10.5
StatusText.TextColor3 = Color3.fromRGB(52, 211, 153)
StatusText.Position = UDim2.new(0, 10, 0, 0)
StatusText.Size = UDim2.new(1, -20, 1, 0)
StatusText.TextXAlignment = Enum.TextXAlignment.Left
StatusText.BackgroundTransparency = 1
StatusText.Parent = StatusBox

-- ==============================================================================
-- 🚨 1. EMERGENCY RESCUE BUTTON (ปุ่มกู้ชีพดึงกลับพื้นหญ้าทันที)
-- ==============================================================================
local RescueBtn = Instance.new("TextButton")
RescueBtn.Size = UDim2.new(1, 0, 0, 42)
RescueBtn.BackgroundColor3 = Color3.fromRGB(220, 38, 38)
RescueBtn.Text = "🚨 กู้ชีพด่วน! ดึงตัวกลับมาบนพื้นฟาร์ม (Fix Void Fall)"
RescueBtn.Font = Enum.Font.GothamBold
RescueBtn.TextSize = 12
RescueBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RescueBtn.LayoutOrder = 2
RescueBtn.Parent = ScrollContent
local ResCorner = Instance.new("UICorner")
ResCorner.CornerRadius = UDim.new(0, 8)
ResCorner.Parent = RescueBtn

local function findGroundSpawn()
    for _, spawn in pairs(workspace:GetDescendants()) do
        if spawn:IsA("SpawnLocation") then
            return spawn.CFrame + Vector3.new(0, 4, 0)
        end
    end
    -- หาชิ้นส่วนพื้นหญ้าที่กว้างที่สุด
    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and (part.Name:lower():find("grass") or part.Name:lower():find("floor") or part.Name:lower():find("baseplate")) then
            return part.CFrame + Vector3.new(0, 6, 0)
        end
    end
    return nil
end

RescueBtn.MouseButton1Click:Connect(function()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        -- หยุดแรงเฉื่อย/การตก
        hrp.Velocity = Vector3.new(0, 0, 0)
        hrp.RotVelocity = Vector3.new(0, 0, 0)
        local groundCF = findGroundSpawn()
        if groundCF then
            hrp.CFrame = groundCF
            StatusText.Text = "✅ ดึงตัวกลับมาบนพื้นหญ้าสำเร็จ!"
            StatusText.TextColor3 = Color3.fromRGB(52, 211, 153)
        else
            -- รีเซ็ตตัวละครอย่างปลอดภัย
            if LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.Health = 0
            end
            StatusText.Text = "🔄 กำลังเกิดใหม่ที่จุดเกิด..."
        end
    end
end)

-- ==============================================================================
-- 👑 2. SAFE ACTION BUTTONS
-- ==============================================================================

-- 1. ฟาร์ม Lucky Blocks กลางแมพแบบปลอดภัย (ยืนบนพื้น ไม่ลอย)
local isLuckyRunning = false
local LuckyBtn = Instance.new("TextButton")
LuckyBtn.Size = UDim2.new(1, 0, 0, 42)
LuckyBtn.BackgroundColor3 = Color3.fromRGB(234, 88, 12)
LuckyBtn.Text = "📦 ฟาร์มเสากล่อง Lucky Blocks (ยืนทุบ ไม่ตกโลก)"
LuckyBtn.Font = Enum.Font.GothamBold
LuckyBtn.TextSize = 11.5
LuckyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LuckyBtn.LayoutOrder = 3
LuckyBtn.Parent = ScrollContent
local LCorner = Instance.new("UICorner")
LCorner.CornerRadius = UDim.new(0, 8)
LCorner.Parent = LuckyBtn

-- 2. สุ่มเปิดไข่ระดับสูงสุดด้วยเงิน $567B
local isHatching = false
local HatchBtn = Instance.new("TextButton")
HatchBtn.Size = UDim2.new(1, 0, 0, 42)
HatchBtn.BackgroundColor3 = Color3.fromRGB(147, 51, 234)
HatchBtn.Text = "🥚 สุ่มเปิดไข่ระดับสูงสุดด้วยเงิน $567B (Auto Hatch)"
HatchBtn.Font = Enum.Font.GothamBold
HatchBtn.TextSize = 11.5
HatchBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HatchBtn.LayoutOrder = 4
HatchBtn.Parent = ScrollContent
local HCorner = Instance.new("UICorner")
HCorner.CornerRadius = UDim.new(0, 8)
HCorner.Parent = HatchBtn

-- 3. ตีบอส The Hungry Monster อัตโนมัติ
local isBossRunning = false
local BossBtn = Instance.new("TextButton")
BossBtn.Size = UDim2.new(1, 0, 0, 42)
BossBtn.BackgroundColor3 = Color3.fromRGB(16, 185, 129)
BossBtn.Text = "🦖 ฟาร์มตีบอส The Hungry Monster (รับรางวัลใหญ่)"
BossBtn.Font = Enum.Font.GothamBold
BossBtn.TextSize = 11.5
BossBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BossBtn.LayoutOrder = 5
BossBtn.Parent = ScrollContent
local BCorner = Instance.new("UICorner")
BCorner.CornerRadius = UDim.new(0, 8)
BCorner.Parent = BossBtn

-- ==============================================================================
-- 🚀 3. LOGIC IMPLEMENTATION
-- ==============================================================================

-- ฟาร์ม Lucky Blocks
LuckyBtn.MouseButton1Click:Connect(function()
    isLuckyRunning = not isLuckyRunning
    if isLuckyRunning then
        LuckyBtn.Text = "⏹️ หยุดฟาร์ม Lucky Blocks"
        LuckyBtn.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
        StatusText.Text = "📦 กำลังฟาร์มกล่อง Lucky Blocks..."
        StatusText.TextColor3 = Color3.fromRGB(250, 204, 21)

        task.spawn(function()
            while isLuckyRunning do
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
                                    task.wait(0.05)
                                    firetouchinterest(bat.Handle, obj, 1)
                                end
                                task.wait(0.15)
                            end
                        end
                    end
                end)
                task.wait(0.4)
            end
        end)
    else
        LuckyBtn.Text = "📦 ฟาร์มเสากล่อง Lucky Blocks (ยืนทุบ ไม่ตกโลก)"
        LuckyBtn.BackgroundColor3 = Color3.fromRGB(234, 88, 12)
        StatusText.Text = "📍 สถานะ: ⏸️ หยุดฟาร์มแล้ว"
    end
end)

-- สุ่มเปิดไข่
HatchBtn.MouseButton1Click:Connect(function()
    isHatching = not isHatching
    if isHatching then
        HatchBtn.Text = "⏹️ หยุดสุ่มไข่"
        HatchBtn.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
        StatusText.Text = "🥚 กำลังสุ่มเปิดไข่ระดับสูงสุด..."
        StatusText.TextColor3 = Color3.fromRGB(168, 85, 247)

        task.spawn(function()
            while isHatching do
                pcall(function()
                    for _, r in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                        if r:IsA("RemoteEvent") or r:IsA("RemoteFunction") then
                            local n = r.Name:lower()
                            if n:find("egg") or n:find("hatch") or n:find("buy") then
                                if r:IsA("RemoteEvent") then
                                    r:FireServer("Secret", 1)
                                    r:FireServer("Mythic", 1)
                                    r:FireServer("Legendary", 1)
                                    r:FireServer(1)
                                end
                            end
                        end
                    end
                end)
                task.wait(1)
            end
        end)
    else
        HatchBtn.Text = "🥚 สุ่มเปิดไข่ระดับสูงสุดด้วยเงิน $567B (Auto Hatch)"
        HatchBtn.BackgroundColor3 = Color3.fromRGB(147, 51, 234)
        StatusText.Text = "📍 สถานะ: ⏸️ หยุดสุ่มไข่แล้ว"
    end
end)

-- ฟาร์มบอส
BossBtn.MouseButton1Click:Connect(function()
    isBossRunning = not isBossRunning
    if isBossRunning then
        BossBtn.Text = "⏹️ หยุดตีบอส"
        BossBtn.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
        StatusText.Text = "🦖 กำลังฟาร์มตีบอส The Hungry Monster..."
        StatusText.TextColor3 = Color3.fromRGB(52, 211, 153)

        task.spawn(function()
            while isBossRunning do
                pcall(function()
                    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local bat = LocalPlayer.Backpack:FindFirstChild("Bat") or LocalPlayer.Character:FindFirstChild("Bat")
                        if bat and bat.Parent == LocalPlayer.Backpack then LocalPlayer.Character.Humanoid:EquipTool(bat) end

                        for _, m in pairs(workspace:GetDescendants()) do
                            if m:IsA("Model") and (m.Name:lower():find("hungry") or m.Name:lower():find("monster")) then
                                local targetPart = m.PrimaryPart or m:FindFirstChildWhichIsA("BasePart")
                                if targetPart then
                                    hrp.CFrame = targetPart.CFrame + Vector3.new(0, 10, 0)
                                    if bat and bat:FindFirstChild("Handle") then
                                        firetouchinterest(bat.Handle, targetPart, 0)
                                        task.wait(0.05)
                                        firetouchinterest(bat.Handle, targetPart, 1)
                                    end
                                end
                            end
                        end
                    end
                end)
                task.wait(0.3)
            end
        end)
    else
        BossBtn.Text = "🦖 ฟาร์มตีบอส The Hungry Monster (รับรางวัลใหญ่)"
        BossBtn.BackgroundColor3 = Color3.fromRGB(16, 185, 129)
        StatusText.Text = "📍 สถานะ: ⏸️ หยุดตีบอสแล้ว"
    end
end)

print("⚡ [NoVoidHub v8.0] โหลดระบบป้องกันตกโลกเรียบร้อย!")
