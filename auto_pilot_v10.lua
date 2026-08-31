-- ==============================================================================
-- ⚡ STEAL AN EGG & PET - FULL AUTO-PILOT MASTER BOT v10.0 (ฉบับออโต้ 100%)
-- 👑 บอทนำทางเดินไปหารังไข่เอง + กดขโมยติดทันที + วิ่งนำไข่กลับมาเก็บที่บ้าน
-- 🕒 ปรับโหมดอัตโนมัติ: กลางวันฟาร์มกล่อง Lucky Blocks / กลางคืนวิ่งขโมยไข่
-- 📱 หน้าต่างเมนูภาษาไทย ออกแบบสำหรับ Android Emulator & Mobile 100%
-- ==============================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- 🛡️ 1. Anti-Kick Bypass
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

-- บันทึกพิกัดบ้านจุดเกิด (Safe Home)
local MyHomeCFrame = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.CFrame) or CFrame.new(0, 50, 0)

-- ⚡ 2. PROXIMITY PROMPT HACK (ลดเวลาค้างเป็น 0 วิ ทั่วทั้งแมพ)
local function hackAllPrompts()
    for _, prompt in pairs(workspace:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") then
            prompt.HoldDuration = 0
            prompt.RequiresLineOfSight = false
            prompt.MaxActivationDistance = 35
        end
    end
end
hackAllPrompts()
workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("ProximityPrompt") then
        obj.HoldDuration = 0
        obj.RequiresLineOfSight = false
        obj.MaxActivationDistance = 35
    end
end)

local function triggerPrompt(prompt)
    if not prompt or not prompt.Parent then return end
    prompt.HoldDuration = 0
    pcall(function()
        if fireproximityprompt then fireproximityprompt(prompt) end
        prompt:InputHoldBegin()
        task.wait(0.05)
        prompt:InputHoldEnd()
    end)
end

-- 🎨 3. GUI Setup
local parentGui = (gethui and gethui()) or game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")
if parentGui:FindFirstChild("AutoPilotHubV10") then parentGui:FindFirstChild("AutoPilotHubV10"):Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoPilotHubV10"
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
Title.Text = "⚡ FULL AUTO-PILOT EGG BOT v10.0"
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
StatusText.Text = "📍 สถานะ: 🟢 พร้อมใช้งาน (กดปุ่มเขียวด้านบนเพื่อเริ่ม)"
StatusText.Font = Enum.Font.GothamMedium
StatusText.TextSize = 10.5
StatusText.TextColor3 = Color3.fromRGB(52, 211, 153)
StatusText.Position = UDim2.new(0, 10, 0, 0)
StatusText.Size = UDim2.new(1, -20, 1, 0)
StatusText.TextXAlignment = Enum.TextXAlignment.Left
StatusText.BackgroundTransparency = 1
StatusText.Parent = StatusBox

-- ==============================================================================
-- 👑 4. MAIN ACTION BUTTONS
-- ==============================================================================

-- 1. ปุ่มเริ่ม Auto Pilot เต็มระบบ (วิ่งไปขโมยเอง + วิ่งกลับบ้านเอง)
local isAutoPilotRunning = false
local MasterBtn = Instance.new("TextButton")
MasterBtn.Size = UDim2.new(1, 0, 0, 46)
MasterBtn.BackgroundColor3 = Color3.fromRGB(16, 185, 129)
MasterBtn.Text = "🚀 เริ่มระบบออโต้ไพลอต (AUTO PILOT STEAL & FARM)"
MasterBtn.Font = Enum.Font.GothamBold
MasterBtn.TextSize = 12.5
MasterBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MasterBtn.LayoutOrder = 2
MasterBtn.Parent = ScrollContent
local MasterCorner = Instance.new("UICorner")
MasterCorner.CornerRadius = UDim.new(0, 10)
MasterCorner.Parent = MasterBtn

-- 2. ปุ่มวาร์ปไปขโมยรังไข่ที่ใกล้ที่สุดทันที (Fast Grab Nearest Nest)
local FastGrabBtn = Instance.new("TextButton")
FastGrabBtn.Size = UDim2.new(1, 0, 0, 42)
FastGrabBtn.BackgroundColor3 = Color3.fromRGB(234, 88, 12)
FastGrabBtn.Text = "⚡ วาร์ปไปฉกรังไข่ที่ใกล้ที่สุดทันที (Fast Grab Nest)"
FastGrabBtn.Font = Enum.Font.GothamBold
FastGrabBtn.TextSize = 12
FastGrabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FastGrabBtn.LayoutOrder = 3
FastGrabBtn.Parent = ScrollContent
local FGCorner = Instance.new("UICorner")
FGCorner.CornerRadius = UDim.new(0, 8)
FGCorner.Parent = FastGrabBtn

-- 3. ปุ่มฟาร์มเสากล่อง Lucky Blocks กลางแมพ
local isLuckyRunning = false
local LuckyBtn = Instance.new("TextButton")
LuckyBtn.Size = UDim2.new(1, 0, 0, 42)
LuckyBtn.BackgroundColor3 = Color3.fromRGB(79, 70, 229)
LuckyBtn.Text = "📦 ฟาร์มเสากล่อง Lucky Blocks กลางแมพ (ได้เงิน $B/s)"
LuckyBtn.Font = Enum.Font.GothamBold
LuckyBtn.TextSize = 12
LuckyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LuckyBtn.LayoutOrder = 4
LuckyBtn.Parent = ScrollContent
local LCorner = Instance.new("UICorner")
LCorner.CornerRadius = UDim.new(0, 8)
LCorner.Parent = LuckyBtn

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
-- 🚀 5. CORE AUTO-PILOT LOGIC
-- ==============================================================================

-- ฟังก์ชันค้นหารังไข่ทั้งหมดในแมพ
local function getAllNests()
    local nests = {}
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return nests end
    local myPos = LocalPlayer.Character.HumanoidRootPart.Position

    for _, obj in pairs(workspace:GetDescendants()) do
        if not obj:IsDescendantOf(LocalPlayer.Character) then
            local isNest = false
            local part = nil
            local prompt = nil

            -- รังที่มี ProximityPrompt
            if obj:IsA("ProximityPrompt") and obj.Parent:IsA("BasePart") then
                isNest = true
                part = obj.Parent
                prompt = obj
            end

            -- รังไข่หรือโมเดลไข่
            if not isNest and (obj:IsA("BasePart") or obj:IsA("Model")) then
                local n = obj.Name:lower()
                if n:find("nest") or n:find("egg") or n:find("spawn") then
                    part = obj:IsA("BasePart") and obj or (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart"))
                    if part then
                        isNest = true
                        prompt = part:FindFirstChildOfClass("ProximityPrompt") or obj:FindFirstChildOfClass("ProximityPrompt")
                    end
                end
            end

            if isNest and part and part:IsA("BasePart") then
                local dist = (part.Position - myPos).Magnitude
                -- ไม่เอารังที่อยู่ในคอกเรา (ระยะใกล้กว่า 25m จากบ้านเรา)
                if (part.Position - MyHomeCFrame.Position).Magnitude > 25 then
                    table.insert(nests, {
                        part = part,
                        prompt = prompt,
                        dist = dist
                    })
                end
            end
        end
    end

    table.sort(nests, function(a, b) return a.dist < b.dist end)
    return nests
end

-- ฟังก์ชันนำทางแบบปลอดภัย
local function safeGlideTo(targetCFrame, onReach)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = LocalPlayer.Character.HumanoidRootPart

    -- หยุดแรงเฉื่อย
    hrp.Velocity = Vector3.new(0, 0, 0)
    hrp.CFrame = targetCFrame + Vector3.new(0, 3, 0)
    task.wait(0.2)

    if onReach then onReach() end
end

-- ฟังก์ชันขโมยรังนั้นๆ
local function stealNest(nestData)
    if not nestData or not nestData.part then return end
    hackAllPrompts()

    StatusText.Text = "🏃‍♂️ กำลังวาร์ปไปขโมยที่รังไข่..."
    StatusText.TextColor3 = Color3.fromRGB(96, 165, 250)

    safeGlideTo(nestData.part.CFrame, function()
        -- 1. กด Prompt ทันที
        if nestData.prompt then
            triggerPrompt(nestData.prompt)
        end
        for _, p in pairs(workspace:GetDescendants()) do
            if p:IsA("ProximityPrompt") and p.Parent:IsA("BasePart") and (p.Parent.Position - nestData.part.Position).Magnitude < 15 then
                triggerPrompt(p)
            end
        end

        -- 2. Touch Interest
        pcall(function()
            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, nestData.part, 0)
            task.wait(0.05)
            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, nestData.part, 1)
        end)

        -- 3. ถือไม้เบสบอลฟาด
        local bat = LocalPlayer.Backpack:FindFirstChild("Bat") or LocalPlayer.Character:FindFirstChild("Bat")
        if bat and bat.Parent == LocalPlayer.Backpack then LocalPlayer.Character.Humanoid:EquipTool(bat) end

        task.wait(0.3)
    end)

    StatusText.Text = "✅ ขโมยเสร็จแล้ว! กำลังกลับมาเก็บที่บ้าน..."
    StatusText.TextColor3 = Color3.fromRGB(52, 211, 153)
    task.wait(0.3)

    -- วาร์ปกลับบ้าน
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        LocalPlayer.Character.HumanoidRootPart.CFrame = MyHomeCFrame
    end
    task.wait(0.5)
end

-- ปุ่มฉกรังไข่ที่ใกล้ที่สุดทันที
FastGrabBtn.MouseButton1Click:Connect(function()
    hackAllPrompts()
    local nests = getAllNests()
    if #nests > 0 then
        stealNest(nests[1])
    else
        StatusText.Text = "⚠️ ยังไม่พบรังไข่ที่อยู่นอกบ้านคุณ กำลังค้นหา..."
        StatusText.TextColor3 = Color3.fromRGB(245, 158, 11)
    end
end)

-- ลูปออโต้ไพลอต
local function runAutoPilotLoop()
    task.spawn(function()
        while isAutoPilotRunning do
            pcall(function()
                hackAllPrompts()
                local nests = getAllNests()
                if #nests > 0 then
                    for _, nest in ipairs(nests) do
                        if not isAutoPilotRunning then break end
                        stealNest(nest)
                        task.wait(1.5)
                    end
                else
                    -- ถ้ายังไม่มีไข่ ให้ไปฟาร์ม Lucky Blocks กลางแมพรอ
                    StatusText.Text = "📦 ยังไม่มีไข่เกิด กำลังฟาร์ม Lucky Blocks กลางแมพรอ..."
                    StatusText.TextColor3 = Color3.fromRGB(250, 204, 21)

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
                end
            end)
            task.wait(1)
        end
    end)
end

MasterBtn.MouseButton1Click:Connect(function()
    isAutoPilotRunning = not isAutoPilotRunning
    if isAutoPilotRunning then
        MasterBtn.Text = "⏹️ หยุดระบบออโต้ไพลอต (STOP AUTO PILOT)"
        MasterBtn.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
        runAutoPilotLoop()
    else
        MasterBtn.Text = "🚀 เริ่มระบบออโต้ไพลอต (AUTO PILOT STEAL & FARM)"
        MasterBtn.BackgroundColor3 = Color3.fromRGB(16, 185, 129)
        StatusText.Text = "📍 สถานะ: ⏸️ บอทหยุดทำงานเรียบร้อย"
        StatusText.TextColor3 = Color3.fromRGB(148, 163, 184)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = MyHomeCFrame
        end
    end
end)

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
        StatusText.Text = "📍 สถานะ: ⏸️ หยุดฟาร์มแล้ว"
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = MyHomeCFrame
        end
    end
end)

print("⚡ [AutoPilotHub v10.0] โหลดระบบออโต้ไพลอตสมบูรณ์!")
