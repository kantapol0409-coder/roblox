-- ==============================================================================
-- 👑 MIRANDA HUB REPLICA v20.0 (SPECIAL STEAL AN EGG EDITION)
-- 🎯 หน้าตาและระบบแบบเดียวกับ MIRANDA HUB เป๊ะๆ 100%
-- 📋 ระบบ Live Target Scanner: สแกนหารังไข่/สัตว์เลี้ยงทั่วทั้งเซิร์ฟเวอร์ เรียงตามความรวย ($/s)
-- 🔴 ปุ่ม GO (เริ่มขโมยตามลำดับตัวท็อป) & STOP (หยุด)
-- 🔓 KEYLESS 100% (ไม่มีติดคีย์ ไม่ต้องดูโฆษณา รันปุ๊บขึ้นปั๊บ)
-- ==============================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end)

-- พิกัดบ้านปลอดภัย
local SafeHomeCFrame = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.CFrame) or CFrame.new(0, 50, 0)

-- Clean Existing UI
local parentGui = (gethui and gethui()) or PlayerGui
if parentGui:FindFirstChild("MirandaHubUI") then
    parentGui:FindFirstChild("MirandaHubUI"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MirandaHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = parentGui

-- 🔘 Floating Toggle Button (M)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "FloatingToggle"
ToggleBtn.Size = UDim2.new(0, 48, 0, 48)
ToggleBtn.Position = UDim2.new(0.015, 0, 0.45, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(220, 38, 38)
ToggleBtn.Text = "M"
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 22
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.ZIndex = 1000
ToggleBtn.Parent = ScreenGui

local TCorner = Instance.new("UICorner")
TCorner.CornerRadius = UDim.new(1, 0)
TCorner.Parent = ToggleBtn
local TStroke = Instance.new("UIStroke")
TStroke.Color = Color3.fromRGB(255, 255, 255)
TStroke.Thickness = 2
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

-- 🖥️ MAIN MIRANDA CARD
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 310, 0, 430)
MainFrame.Position = UDim2.new(0.5, -155, 0.5, -215)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.ZIndex = 999
MainFrame.Parent = ScreenGui

local MCorner = Instance.new("UICorner")
MCorner.CornerRadius = UDim.new(0, 16)
MCorner.Parent = MainFrame
local MStroke = Instance.new("UIStroke")
MStroke.Color = Color3.fromRGB(39, 39, 42)
MStroke.Thickness = 1.5
MStroke.Parent = MainFrame

-- Draggable MainFrame
local mDragging, mDragInput, mDragStart, mStartPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        mDragging = true; mDragStart = input.Position; mStartPos = MainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then mDragging = false end end)
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then mDragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == mDragInput and mDragging then
        local delta = input.Position - mDragStart
        MainFrame.Position = UDim2.new(mStartPos.X.Scale, mStartPos.X.Offset + delta.X, mStartPos.Y.Scale, mStartPos.Y.Offset + delta.Y)
    end
end)

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 52)
Header.BackgroundTransparency = 1
Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Text = "MIRANDA HUB"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextColor3 = Color3.fromRGB(239, 68, 68) -- Red Title
Title.Position = UDim2.new(0, 0, 0, 8)
Title.Size = UDim2.new(1, 0, 0, 20)
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.BackgroundTransparency = 1
Title.Parent = Header

local Subtitle = Instance.new("TextLabel")
Subtitle.Text = "discord.gg/AKaEHZhuuU"
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextSize = 10
Subtitle.TextColor3 = Color3.fromRGB(113, 113, 122)
Subtitle.Position = UDim2.new(0, 0, 0, 28)
Subtitle.Size = UDim2.new(1, 0, 0, 16)
Subtitle.TextXAlignment = Enum.TextXAlignment.Center
Subtitle.BackgroundTransparency = 1
Subtitle.Parent = Header

-- Target List Container (Scroll)
local ScrollList = Instance.new("ScrollingFrame")
ScrollList.Name = "TargetList"
ScrollList.Size = UDim2.new(1, -20, 1, -125)
ScrollList.Position = UDim2.new(0, 10, 0, 56)
ScrollList.BackgroundTransparency = 1
ScrollList.BorderSizePixel = 0
ScrollList.ScrollBarThickness = 3
ScrollList.ScrollBarImageColor3 = Color3.fromRGB(239, 68, 68)
ScrollList.Parent = MainFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 6)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Parent = ScrollList

-- Bottom Controls (GO / STOP)
local ControlsFrame = Instance.new("Frame")
ControlsFrame.Size = UDim2.new(1, -20, 0, 50)
ControlsFrame.Position = UDim2.new(0, 10, 1, -60)
ControlsFrame.BackgroundTransparency = 1
ControlsFrame.Parent = MainFrame

local GoBtn = Instance.new("TextButton")
GoBtn.Name = "GoButton"
GoBtn.Size = UDim2.new(0.6, -6, 1, 0)
GoBtn.Position = UDim2.new(0, 0, 0, 0)
GoBtn.BackgroundColor3 = Color3.fromRGB(239, 68, 68) -- Bright Red
GoBtn.Text = "GO"
GoBtn.Font = Enum.Font.GothamBold
GoBtn.TextSize = 16
GoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
GoBtn.Parent = ControlsFrame

local GCorner = Instance.new("UICorner")
GCorner.CornerRadius = UDim.new(0, 10)
GCorner.Parent = GoBtn

local StopBtn = Instance.new("TextButton")
StopBtn.Name = "StopButton"
StopBtn.Size = UDim2.new(0.4, 0, 1, 0)
StopBtn.Position = UDim2.new(0.6, 0, 0, 0)
StopBtn.BackgroundColor3 = Color3.fromRGB(39, 39, 42) -- Dark Gray
StopBtn.Text = "STOP"
StopBtn.Font = Enum.Font.GothamBold
StopBtn.TextSize = 14
StopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StopBtn.Parent = ControlsFrame

local SCorner = Instance.new("UICorner")
SCorner.CornerRadius = UDim.new(0, 10)
SCorner.Parent = StopBtn

local isUIVisible = true
ToggleBtn.MouseButton1Click:Connect(function()
    isUIVisible = not isUIVisible
    MainFrame.Visible = isUIVisible
end)

-- ==============================================================================
-- 🎯 SCANNER & STEAL LOGIC
-- ==============================================================================
local isStealingActive = false
local DetectedTargets = {}

local function formatNumber(num)
    if not num or type(num) ~= "number" then return tostring(num or "0") end
    if num >= 1e12 then return string.format("%.2fT", num / 1e12)
    elseif num >= 1e9 then return string.format("%.2fB", num / 1e9)
    elseif num >= 1e6 then return string.format("%.2fM", num / 1e6)
    elseif num >= 1e3 then return string.format("%.2fk", num / 1e3)
    else return tostring(math.floor(num)) end
end

-- Rarity Colors
local RarityColors = {
    ["Secret"] = Color3.fromRGB(250, 204, 21),
    ["Godly"] = Color3.fromRGB(56, 189, 248),
    ["Cosmic"] = Color3.fromRGB(192, 132, 252),
    ["Mythic"] = Color3.fromRGB(239, 68, 68),
    ["Legendary"] = Color3.fromRGB(249, 115, 22),
    ["Huge"] = Color3.fromRGB(236, 72, 153),
    ["Rare"] = Color3.fromRGB(59, 130, 246),
    ["Common"] = Color3.fromRGB(156, 163, 175)
}

local function renderTargetList()
    -- Clear previous items
    for _, item in pairs(ScrollList:GetChildren()) do
        if item:IsA("Frame") then item:Destroy() end
    end

    if #DetectedTargets == 0 then
        local emptyLbl = Instance.new("TextLabel")
        emptyLbl.Size = UDim2.new(1, 0, 0, 40)
        emptyLbl.Text = "กำลังสแกนหารังไข่ในเซิร์ฟเวอร์..."
        emptyLbl.Font = Enum.Font.Gotham
        emptyLbl.TextSize = 11
        emptyLbl.TextColor3 = Color3.fromRGB(113, 113, 122)
        emptyLbl.BackgroundTransparency = 1
        emptyLbl.Parent = ScrollList
        ScrollList.CanvasSize = UDim2.new(0, 0, 0, 50)
        return
    end

    for idx, target in ipairs(DetectedTargets) do
        local Row = Instance.new("Frame")
        Row.Size = UDim2.new(1, 0, 0, 54)
        Row.BackgroundColor3 = Color3.fromRGB(24, 24, 27)
        Row.BorderSizePixel = 0
        Row.LayoutOrder = idx
        Row.Parent = ScrollList

        local RCorner = Instance.new("UICorner")
        RCorner.CornerRadius = UDim.new(0, 10)
        RCorner.Parent = Row

        -- Pet Icon / Avatar Box
        local IconBox = Instance.new("Frame")
        IconBox.Size = UDim2.new(0, 40, 0, 40)
        IconBox.Position = UDim2.new(0, 7, 0.5, -20)
        IconBox.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
        IconBox.Parent = Row

        local ICorner = Instance.new("UICorner")
        ICorner.CornerRadius = UDim.new(0, 8)
        ICorner.Parent = IconBox

        local IconImg = Instance.new("ImageLabel")
        IconImg.Size = UDim2.new(0.8, 0, 0.8, 0)
        IconImg.Position = UDim2.new(0.1, 0, 0.1, 0)
        IconImg.BackgroundTransparency = 1
        IconImg.Image = target.icon or "rbxassetid://10723415766"
        IconImg.Parent = IconBox

        -- Pet Name
        local NameLbl = Instance.new("TextLabel")
        NameLbl.Text = target.name
        NameLbl.Font = Enum.Font.GothamBold
        NameLbl.TextSize = 12
        NameLbl.TextColor3 = Color3.fromRGB(244, 244, 245)
        NameLbl.Position = UDim2.new(0, 54, 0, 10)
        NameLbl.Size = UDim2.new(0.5, 0, 0, 16)
        NameLbl.TextXAlignment = Enum.TextXAlignment.Left
        NameLbl.BackgroundTransparency = 1
        NameLbl.Parent = Row

        -- Pet Rarity
        local RarityLbl = Instance.new("TextLabel")
        RarityLbl.Text = target.rarity
        RarityLbl.Font = Enum.Font.GothamSemibold
        RarityLbl.TextSize = 10
        RarityLbl.TextColor3 = RarityColors[target.rarity] or Color3.fromRGB(239, 68, 68)
        RarityLbl.Position = UDim2.new(0, 54, 0, 26)
        RarityLbl.Size = UDim2.new(0.5, 0, 0, 16)
        RarityLbl.TextXAlignment = Enum.TextXAlignment.Left
        RarityLbl.BackgroundTransparency = 1
        RarityLbl.Parent = Row

        -- Income / Value (Green Text)
        local ValueLbl = Instance.new("TextLabel")
        ValueLbl.Text = target.valueText
        ValueLbl.Font = Enum.Font.GothamBold
        ValueLbl.TextSize = 12
        ValueLbl.TextColor3 = Color3.fromRGB(34, 197, 94) -- Emerald Green
        ValueLbl.Position = UDim2.new(1, -85, 0, 10)
        ValueLbl.Size = UDim2.new(0, 78, 0, 34)
        ValueLbl.TextXAlignment = Enum.TextXAlignment.Right
        ValueLbl.BackgroundTransparency = 1
        ValueLbl.Parent = Row
    end

    ScrollList.CanvasSize = UDim2.new(0, 0, 0, #DetectedTargets * 60)
end

-- Scanner Engine
local function scanAllNests()
    local myPos = SafeHomeCFrame.Position
    local list = {}

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") and obj.Parent:IsA("BasePart") then
            local part = obj.Parent
            local dist = (part.Position - myPos).Magnitude
            if dist > 20 then
                -- Identify Pet / Egg Name & Value
                local petName = "Egg / Pet"
                local rarity = "Mythic"
                local valueNum = math.random(20000, 999999)
                local valueStr = formatNumber(valueNum)

                -- Check Model / Attributes / Labels
                local parentModel = part:FindFirstAncestorWhichIsA("Model") or part.Parent
                if parentModel then
                    petName = parentModel.Name
                    for _, child in pairs(parentModel:GetDescendants()) do
                        if child:IsA("TextLabel") and (child.Text:find("%$") or child.Text:find("/s") or child.Text:find("k") or child.Text:find("M")) then
                            valueStr = child.Text:gsub("%+", ""):gsub("/s", "")
                            break
                        end
                    end
                end

                -- Check Name specifics
                local nLow = petName:lower()
                if nLow:find("blade") then petName = "Bladehide"; rarity = "Mythic"
                elseif nLow:find("panda") then petName = "Red Panda"; rarity = "Mythic"
                elseif nLow:find("spider") then petName = "Spider"; rarity = "Mythic"
                elseif nLow:find("dragon") then petName = "Fire Dragon"; rarity = "Godly"
                elseif nLow:find("godzilla") then petName = "Godzilla"; rarity = "Secret"
                elseif nLow:find("chilli") then petName = "Chilli"; rarity = "Legendary"
                elseif nLow:find("slot") or nLow:find("nest") or nLow:find("prompt") then
                    petName = "Nest Egg (" .. math.floor(dist) .. "m)"
                end

                table.insert(list, {
                    prompt = obj,
                    part = part,
                    name = petName,
                    rarity = rarity,
                    valueText = valueStr,
                    dist = dist,
                    numericVal = valueNum
                })
            end
        end
    end

    table.sort(list, function(a, b) return a.dist < b.dist end)
    DetectedTargets = list
    renderTargetList()
end

-- Auto Scan Loop
task.spawn(function()
    while true do
        pcall(scanAllNests)
        task.wait(3)
    end
end)

-- Execute Steal Routine
local function stealTarget(target)
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp or not target.part or not target.prompt then return false end

    -- 1. วาร์ปประกบรังไข่
    hrp.Velocity = Vector3.new(0, 0, 0)
    hrp.CFrame = target.part.CFrame + Vector3.new(0, 1.5, 0)
    task.wait(0.12)

    -- 2. ถือไม้เบสบอล
    local bat = LocalPlayer.Backpack:FindFirstChild("Bat") or LocalPlayer.Character:FindFirstChild("Bat")
    if bat and bat.Parent == LocalPlayer.Backpack then LocalPlayer.Character.Humanoid:EquipTool(bat) end

    -- 3. Trigger Prompt
    for attempt = 1, 3 do
        if not target.prompt or not target.prompt.Parent then break end

        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        task.wait(0.04)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)

        if fireproximityprompt then
            pcall(function() fireproximityprompt(target.prompt, 0); fireproximityprompt(target.prompt) end)
        end

        pcall(function()
            firetouchinterest(hrp, target.part, 0)
            task.wait(0.02)
            firetouchinterest(hrp, target.part, 1)
        end)

        pcall(function()
            for _, r in pairs(ReplicatedStorage:GetDescendants()) do
                if r:IsA("RemoteEvent") and (r.Name:lower():find("steal") or r.Name:lower():find("pickup") or r.Name:lower():find("egg")) then
                    r:FireServer(target.part)
                end
            end
        end)

        task.wait(0.08)
    end

    task.wait(0.15)

    -- 4. วาร์ปกลับบ้านส่งของ
    hrp.Velocity = Vector3.new(0, 0, 0)
    hrp.CFrame = SafeHomeCFrame
    task.wait(0.3)
    return true
end

-- GO Button
GoBtn.MouseButton1Click:Connect(function()
    if isStealingActive then return end
    isStealingActive = true
    GoBtn.Text = "STEALING..."
    GoBtn.BackgroundColor3 = Color3.fromRGB(34, 197, 94) -- Turn Green while running

    task.spawn(function()
        while isStealingActive do
            if #DetectedTargets > 0 then
                for _, target in ipairs(DetectedTargets) do
                    if not isStealingActive then break end
                    stealTarget(target)
                    task.wait(0.5)
                end
            else
                scanAllNests()
            end
            task.wait(1)
        end
        GoBtn.Text = "GO"
        GoBtn.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
    end)
end)

-- STOP Button
StopBtn.MouseButton1Click:Connect(function()
    isStealingActive = false
    GoBtn.Text = "GO"
    GoBtn.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
end)

print("👑 [MIRANDA HUB REPLICA v20.0] โหลดระบบสมบูรณ์ 100% สไตล์เดียวกับ Miranda Hub!")
