-- ==============================================================================
-- ⚡ STEAL AN EGG & PET - VIRTUAL [E] KEY ENGINE v11.0
-- 👑 แก้ปัญหาปุ่ม E ไม่ทำงาน (ส่งสัญญาณคีย์บอร์ด [E] ระดับ Engine ด้วย VirtualInputManager)
-- 🎯 ปลดล็อคทุกวิธีขโมย: Virtual Key E + fireproximityprompt + InputHold + Remotes
-- 📱 เมนูภาษาไทย พร้อมระบบสแปมกด E อัตโนมัติเมื่อยืนใกล้รังไข่ 100%
-- ==============================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
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

-- ⚡ ฟังก์ชันจำลองการกดปุ่ม [E] ขั้นสูงสุด (รวม 4 วิธีเข้าด้วยกัน)
local function forceStealPrompt(prompt)
    if not prompt or not prompt.Parent then return end

    -- 1. ปรับค่าให้กดได้จากระยะไกล ไม่ต้องกดค้าง
    pcall(function()
        prompt.HoldDuration = 0
        prompt.RequiresLineOfSight = false
        prompt.MaxActivationDistance = 50
    end)

    -- 2. ยิงคำสั่งกดคีย์บอร์ดปุ่ม [E] ระดับ VirtualInputManager (เหมือนคนกดจริง 100%)
    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        task.wait(0.08)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    end)

    -- 3. fireproximityprompt ของ Executor
    pcall(function()
        if fireproximityprompt then
            fireproximityprompt(prompt, 0)
            fireproximityprompt(prompt)
        end
    end)

    -- 4. InputHold API
    pcall(function()
        prompt:InputHoldBegin()
        task.wait(0.05)
        prompt:InputHoldEnd()
    end)

    -- 5. สแกนยิง RemoteEvent ของเกม
    pcall(function()
        for _, r in pairs(ReplicatedStorage:GetDescendants()) do
            if r:IsA("RemoteEvent") then
                local n = r.Name:lower()
                if n:find("steal") or n:find("pickup") or n:find("take") or n:find("egg") or n:find("interact") then
                    r:FireServer(prompt.Parent)
                    r:FireServer(prompt.Parent.Parent)
                end
            end
        end
    end)
end

-- สแกนปรับ Prompts ทั่วทั้งแมพ
local function patchAllPrompts()
    for _, p in pairs(workspace:GetDescendants()) do
        if p:IsA("ProximityPrompt") then
            p.HoldDuration = 0
            p.RequiresLineOfSight = false
            p.MaxActivationDistance = 50
        end
    end
end
patchAllPrompts()
workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("ProximityPrompt") then
        obj.HoldDuration = 0
        obj.RequiresLineOfSight = false
        obj.MaxActivationDistance = 50
    end
end)

-- 🎨 GUI Setup
local parentGui = (gethui and gethui()) or game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")
if parentGui:FindFirstChild("VirtualEHubV11") then parentGui:FindFirstChild("VirtualEHubV11"):Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VirtualEHubV11"
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
Title.Text = "⚡ VIRTUAL [E] STEALER (กด E ขโมยติด 100%)"
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
StatusText.Text = "📍 สถานะ: 🟢 พร้อมใช้งาน (ยืนหน้ารังแล้วกดปุ่มส้ม)"
StatusText.Font = Enum.Font.GothamMedium
StatusText.TextSize = 10.5
StatusText.TextColor3 = Color3.fromRGB(52, 211, 153)
StatusText.Position = UDim2.new(0, 10, 0, 0)
StatusText.Size = UDim2.new(1, -20, 1, 0)
StatusText.TextXAlignment = Enum.TextXAlignment.Left
StatusText.BackgroundTransparency = 1
StatusText.Parent = StatusBox

-- ==============================================================================
-- 👑 ACTION BUTTONS
-- ==============================================================================

-- 1. ปุ่มส่งสัญญาณกด [E] ขโมยทันที
local StealNowBtn = Instance.new("TextButton")
StealNowBtn.Size = UDim2.new(1, 0, 0, 48)
StealNowBtn.BackgroundColor3 = Color3.fromRGB(234, 88, 12)
StealNowBtn.Text = "⚡ ยิงสัญญาณกด [E] ขโมยรังไข่ตรงหน้านี้ทันที"
StealNowBtn.Font = Enum.Font.GothamBold
StealNowBtn.TextSize = 12.5
StealNowBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StealNowBtn.LayoutOrder = 2
StealNowBtn.Parent = ScrollContent
local SNCorner = Instance.new("UICorner")
SNCorner.CornerRadius = UDim.new(0, 10)
SNCorner.Parent = StealNowBtn

StealNowBtn.MouseButton1Click:Connect(function()
    patchAllPrompts()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local triggered = 0
    for _, prompt in pairs(workspace:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") and prompt.Parent:IsA("BasePart") then
            if (prompt.Parent.Position - hrp.Position).Magnitude < 35 then
                forceStealPrompt(prompt)
                triggered = triggered + 1
            end
        end
    end

    if triggered > 0 then
        StatusText.Text = string.format("✅ ส่งสัญญาณกด [E] สำเร็จ %d จุด!", triggered)
        StatusText.TextColor3 = Color3.fromRGB(52, 211, 153)
    else
        -- หากไม่พบ prompt ให้ส่ง Virtual E รัวๆ รอบตัว
        pcall(function()
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
            task.wait(0.1)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
        end)
        StatusText.Text = "⚡ ยิงคีย์บอร์ดปุ่ม E รัวๆ รอบตัวเรียบร้อย!"
        StatusText.TextColor3 = Color3.fromRGB(96, 165, 250)
    end
end)

-- 2. สวิตช์สแปมกด [E] อัตโนมัติตลอดเวลา (Auto [E] Spam Aura)
local isSpamming = false
local SpamBtn = Instance.new("TextButton")
SpamBtn.Size = UDim2.new(1, 0, 0, 44)
SpamBtn.BackgroundColor3 = Color3.fromRGB(16, 185, 129)
SpamBtn.Text = "🚀 เปิดระบบสแปมกด [E] อัตโนมัติตลอดเวลา (Auto [E] Loop: OFF)"
SpamBtn.Font = Enum.Font.GothamBold
SpamBtn.TextSize = 11.5
SpamBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SpamBtn.LayoutOrder = 3
SpamBtn.Parent = ScrollContent
local SBCorner = Instance.new("UICorner")
SBCorner.CornerRadius = UDim.new(0, 8)
SBCorner.Parent = SpamBtn

SpamBtn.MouseButton1Click:Connect(function()
    isSpamming = not isSpamming
    if isSpamming then
        SpamBtn.Text = "⏹️ ปิดระบบสแปมกด [E] (Auto [E] Loop: ON)"
        SpamBtn.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
        StatusText.Text = "🚀 กำลังสแปมกด [E] รัวๆ ตลอดเวลา ยืนใกล้รังไหนขโมยทันที..."
        StatusText.TextColor3 = Color3.fromRGB(52, 211, 153)

        task.spawn(function()
            while isSpamming do
                pcall(function()
                    patchAllPrompts()
                    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        for _, prompt in pairs(workspace:GetDescendants()) do
                            if prompt:IsA("ProximityPrompt") and prompt.Parent:IsA("BasePart") then
                                if (prompt.Parent.Position - hrp.Position).Magnitude < 30 then
                                    forceStealPrompt(prompt)
                                end
                            end
                        end
                    end
                end)
                task.wait(0.15)
            end
        end)
    else
        SpamBtn.Text = "🚀 เปิดระบบสแปมกด [E] อัตโนมัติตลอดเวลา (Auto [E] Loop: OFF)"
        SpamBtn.BackgroundColor3 = Color3.fromRGB(16, 185, 129)
        StatusText.Text = "📍 สถานะ: ⏸️ ปิดระบบสแปมกด [E] แล้ว"
        StatusText.TextColor3 = Color3.fromRGB(148, 163, 184)
    end
end)

-- 3. ปุ่มฟาร์มเสากล่อง Lucky Blocks กลางแมพ
local isLucky = false
local LuckyBtn = Instance.new("TextButton")
LuckyBtn.Size = UDim2.new(1, 0, 0, 42)
LuckyBtn.BackgroundColor3 = Color3.fromRGB(79, 70, 229)
LuckyBtn.Text = "📦 ฟาร์มเสากล่อง Lucky Blocks กลางแมพ (ได้เงิน $B/s)"
LuckyBtn.Font = Enum.Font.GothamBold
LuckyBtn.TextSize = 11.5
LuckyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LuckyBtn.LayoutOrder = 4
LuckyBtn.Parent = ScrollContent
local LCorner = Instance.new("UICorner")
LCorner.CornerRadius = UDim.new(0, 8)
LCorner.Parent = LuckyBtn

LuckyBtn.MouseButton1Click:Connect(function()
    isLucky = not isLucky
    if isLucky then
        LuckyBtn.Text = "⏹️ หยุดฟาร์ม Lucky Blocks"
        LuckyBtn.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
        task.spawn(function()
            while isLucky do
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
                                task.wait(0.2)
                            end
                        end
                    end
                end)
                task.wait(0.5)
            end
        end)
    else
        LuckyBtn.Text = "📦 ฟาร์มเสากล่อง Lucky Blocks กลางแมพ (ได้เงิน $B/s)"
        LuckyBtn.BackgroundColor3 = Color3.fromRGB(79, 70, 229)
    end
end)

print("⚡ [VirtualEHub v11.0] โหลดระบบยิงปุ่ม [E] ระดับ Engine สำเร็จ!")
