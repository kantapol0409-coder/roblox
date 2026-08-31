-- ==============================================================================
-- ⚡ STEAL AN EGG / DONT STEAL THE BOBO - MASTER HUB (100% KEYLESS)
-- 👑 GitHub: https://github.com/kantapol0409-coder/roblox
-- 📱 หน้าต่างเมนูภาษาไทย ออกแบบสำหรับ Mobile & Emulator ไม่ติดคีย์แน่นอน 100%
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

-- ⚡ Hack ProximityPrompts
local function patchPrompts()
    for _, p in pairs(workspace:GetDescendants()) do
        if p:IsA("ProximityPrompt") then
            p.HoldDuration = 0
            p.RequiresLineOfSight = false
            p.MaxActivationDistance = 50
        end
    end
end
patchPrompts()
workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("ProximityPrompt") then
        obj.HoldDuration = 0
        obj.RequiresLineOfSight = false
        obj.MaxActivationDistance = 50
    end
end)

local function triggerPrompt(prompt)
    if not prompt or not prompt.Parent then return end
    prompt.HoldDuration = 0
    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        task.wait(0.06)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    end)
    pcall(function()
        if fireproximityprompt then fireproximityprompt(prompt, 0); fireproximityprompt(prompt) end
        prompt:InputHoldBegin()
        task.wait(0.04)
        prompt:InputHoldEnd()
    end)
    pcall(function()
        for _, r in pairs(ReplicatedStorage:GetDescendants()) do
            if r:IsA("RemoteEvent") then
                local n = r.Name:lower()
                if n:find("steal") or n:find("pickup") or n:find("egg") then
                    r:FireServer(prompt.Parent)
                end
            end
        end
    end)
end

-- พิกัดบ้าน
local MyHomeCFrame = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.CFrame) or CFrame.new(0, 50, 0)

-- 🎨 GUI Setup
local parentGui = (gethui and gethui()) or game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")
if parentGui:FindFirstChild("MasterEggHub") then parentGui:FindFirstChild("MasterEggHub"):Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MasterEggHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = parentGui

-- 🔘 Floating Toggle Button (⚡)
local ToggleBtn = Instance.new("ImageButton")
ToggleBtn.Name = "FloatingToggle"
ToggleBtn.Size = UDim2.new(0, 56, 0, 56)
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
TStroke.Thickness = 3
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
MainFrame.Size = UDim2.new(0, 500, 0, 380)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -190)
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
Title.Text = "⚡ STEAL AN EGG & PET HUB (KEYLESS)"
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
StatusText.Text = "📍 สถานะ: 🟢 พร้อมใช้งาน (ไม่มีติดคีย์ 100%)"
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

-- 1. ปุ่มเริ่ม Auto Pilot เต็มระบบ (วาร์ปไปขโมย + วาร์ปกลับบ้าน)
local isAutoPilot = false
local MasterBtn = Instance.new("TextButton")
MasterBtn.Size = UDim2.new(1, 0, 0, 46)
MasterBtn.BackgroundColor3 = Color3.fromRGB(16, 185, 129)
MasterBtn.Text = "🚀 เริ่มระบบขโมยอัตโนมัติ (AUTO STEAL LOOP)"
MasterBtn.Font = Enum.Font.GothamBold
MasterBtn.TextSize = 13
MasterBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MasterBtn.LayoutOrder = 2
MasterBtn.Parent = ScrollContent
local MasterCorner = Instance.new("UICorner")
MasterCorner.CornerRadius = UDim.new(0, 10)
MasterCorner.Parent = MasterBtn

-- 2. ปุ่มฟาร์มเสากล่อง Lucky Blocks กลางแมพ
local isLucky = false
local LuckyBtn = Instance.new("TextButton")
LuckyBtn.Size = UDim2.new(1, 0, 0, 42)
LuckyBtn.BackgroundColor3 = Color3.fromRGB(234, 88, 12)
LuckyBtn.Text = "📦 ฟาร์มเสากล่อง Lucky Blocks กลางแมพ (ปั๊มเงิน & สัตว์เลี้ยง)"
LuckyBtn.Font = Enum.Font.GothamBold
LuckyBtn.TextSize = 12
LuckyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LuckyBtn.LayoutOrder = 3
LuckyBtn.Parent = ScrollContent
local LCorner = Instance.new("UICorner")
LCorner.CornerRadius = UDim.new(0, 8)
LCorner.Parent = LuckyBtn

-- 3. ปุ่มดูดเงินในคอกเราอัตโนมัติ (Auto Collect Money)
local isCollect = false
local CollectBtn = Instance.new("TextButton")
CollectBtn.Size = UDim2.new(1, 0, 0, 40)
CollectBtn.BackgroundColor3 = Color3.fromRGB(79, 70, 229)
CollectBtn.Text = "💵 ดูดเงินทั้งหมดในคอกเราอัตโนมัติ (Auto Collect Money)"
CollectBtn.Font = Enum.Font.GothamBold
CollectBtn.TextSize = 11.5
CollectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CollectBtn.LayoutOrder = 4
CollectBtn.Parent = ScrollContent
local CBtnCorner = Instance.new("UICorner")
CBtnCorner.CornerRadius = UDim.new(0, 8)
CBtnCorner.Parent = CollectBtn

-- 4. บันทึกจุดยืนเป็นบ้าน
local SaveHomeBtn = Instance.new("TextButton")
SaveHomeBtn.Size = UDim2.new(1, 0, 0, 36)
SaveHomeBtn.BackgroundColor3 = Color3.fromRGB(31, 41, 55)
SaveHomeBtn.Text = "📌 บันทึกตำแหน่งที่ยืนปัจจุบันเป็นบ้าน (Set Home)"
SaveHomeBtn.Font = Enum.Font.GothamSemibold
SaveHomeBtn.TextSize = 10.5
SaveHomeBtn.TextColor3 = Color3.fromRGB(203, 213, 225)
SaveHomeBtn.LayoutOrder = 5
SaveHomeBtn.Parent = ScrollContent
local SHCorner = Instance.new("UICorner")
SHCorner.CornerRadius = UDim.new(0, 8)
SHCorner.Parent = SaveHomeBtn

SaveHomeBtn.MouseButton1Click:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        MyHomeCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
        StatusText.Text = "✅ บันทึกพิกัดบ้านเรียบร้อยแล้ว!"
        StatusText.TextColor3 = Color3.fromRGB(52, 211, 153)
    end
end)

-- ==============================================================================
-- 🚀 CORE LOGIC
-- ==============================================================================
local function getAllNests()
    local nests = {}
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return nests end
    local myPos = LocalPlayer.Character.HumanoidRootPart.Position

    for _, obj in pairs(workspace:GetDescendants()) do
        if not obj:IsDescendantOf(LocalPlayer.Character) then
            if obj:IsA("ProximityPrompt") and obj.Parent:IsA("BasePart") then
                local dist = (obj.Parent.Position - myPos).Magnitude
                if (obj.Parent.Position - MyHomeCFrame.Position).Magnitude > 25 then
                    table.insert(nests, { part = obj.Parent, prompt = obj, dist = dist })
                end
            end
        end
    end
    table.sort(nests, function(a, b) return a.dist < b.dist end)
    return nests
end

-- ลูป Auto Steal
MasterBtn.MouseButton1Click:Connect(function()
    isAutoPilot = not isAutoPilot
    if isAutoPilot then
        MasterBtn.Text = "⏹️ หยุดระบบขโมย (STOP BOT)"
        MasterBtn.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
        StatusText.Text = "🚀 กำลังวาร์ปไปขโมยไข่ทั่วทั้งเซิร์ฟเวอร์..."
        StatusText.TextColor3 = Color3.fromRGB(52, 211, 153)

        task.spawn(function()
            while isAutoPilot do
                pcall(function()
                    patchPrompts()
                    local nests = getAllNests()
                    if #nests > 0 then
                        for _, n in ipairs(nests) do
                            if not isAutoPilot then break end
                            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                hrp.Velocity = Vector3.new(0, 0, 0)
                                hrp.CFrame = n.part.CFrame + Vector3.new(0, 2, 0)
                                task.wait(0.15)
                                triggerPrompt(n.prompt)
                                task.wait(0.2)
                                hrp.Velocity = Vector3.new(0, 0, 0)
                                hrp.CFrame = MyHomeCFrame
                                task.wait(0.4)
                            end
                        end
                    else
                        -- ฟาร์ม Lucky Blocks รอ
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
    else
        MasterBtn.Text = "🚀 เริ่มระบบขโมยอัตโนมัติ (AUTO STEAL LOOP)"
        MasterBtn.BackgroundColor3 = Color3.fromRGB(16, 185, 129)
        StatusText.Text = "📍 สถานะ: ⏸️ บอทหยุดทำงานแล้ว"
        StatusText.TextColor3 = Color3.fromRGB(148, 163, 184)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = MyHomeCFrame
        end
    end
end)

-- ฟาร์ม Lucky Blocks
LuckyBtn.MouseButton1Click:Connect(function()
    isLucky = not isLucky
    if isLucky then
        LuckyBtn.Text = "⏹️ หยุดฟาร์ม Lucky Blocks"
        LuckyBtn.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
        StatusText.Text = "📦 กำลังฟาร์มกล่อง Lucky Blocks กลางแมพ..."
        StatusText.TextColor3 = Color3.fromRGB(250, 204, 21)

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
        LuckyBtn.Text = "📦 ฟาร์มเสากล่อง Lucky Blocks กลางแมพ (ปั๊มเงิน & สัตว์เลี้ยง)"
        LuckyBtn.BackgroundColor3 = Color3.fromRGB(234, 88, 12)
        StatusText.Text = "📍 สถานะ: ⏸️ หยุดฟาร์มแล้ว"
    end
end)

-- ดูดเงินในคอก
CollectBtn.MouseButton1Click:Connect(function()
    isCollect = not isCollect
    if isCollect then
        CollectBtn.Text = "⏹️ หยุดดูดเงิน"
        CollectBtn.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
        task.spawn(function()
            while isCollect do
                pcall(function()
                    for _, r in pairs(ReplicatedStorage:GetDescendants()) do
                        if r:IsA("RemoteEvent") and (r.Name:lower():find("collect") or r.Name:lower():find("cash") or r.Name:lower():find("claim")) then
                            r:FireServer()
                        end
                    end
                end)
                task.wait(1)
            end
        end)
    else
        CollectBtn.Text = "💵 ดูดเงินทั้งหมดในคอกเราอัตโนมัติ (Auto Collect Money)"
        CollectBtn.BackgroundColor3 = Color3.fromRGB(79, 70, 229)
    end
end)

print("⚡ [MasterEggHub] โหลดระบบสมบูรณ์ 100% (Keyless)!")
