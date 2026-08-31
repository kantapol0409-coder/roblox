-- ==============================================================================
-- ⚡ STEAL AN EGG / PET - RICHEST PLAYER & BASE AUTO-STEALER v6.0
-- 👑 ดึงรายชื่อคนรวยในห้อง (972M/s, 59M/s) + วาร์ปไปขโมยสัตว์เลี้ยงในคอกคนอื่นถึงที่ 100%
-- 📱 หน้าต่างเมนูใช้งานง่าย พร้อมปุ่มกดขโมยจากคนรวยสุดในเซิร์ฟเวอร์ทันที
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

-- 🎨 GUI Setup
local parentGui = (gethui and gethui()) or game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")
if parentGui:FindFirstChild("DirectStealHub") then parentGui:FindFirstChild("DirectStealHub"):Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DirectStealHub"
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
MainFrame.Size = UDim2.new(0, 500, 0, 390)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -195)
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
Title.Text = "⚡ AUTO STEAL PETS FROM RICHEST PLAYERS v6.0"
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

-- 👑 MASTER BUTTON
local isAutoStealing = false
local MasterBtn = Instance.new("TextButton")
MasterBtn.Size = UDim2.new(1, 0, 0, 46)
MasterBtn.BackgroundColor3 = Color3.fromRGB(16, 185, 129)
MasterBtn.Text = "▶️ เริ่มขโมยวนจากคนรวยที่สุดในห้อง (AUTO STEAL LOOP)"
MasterBtn.Font = Enum.Font.GothamBold
MasterBtn.TextSize = 12.5
MasterBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MasterBtn.LayoutOrder = 1
MasterBtn.Parent = ScrollContent
local MasterCorner = Instance.new("UICorner")
MasterCorner.CornerRadius = UDim.new(0, 10)
MasterCorner.Parent = MasterBtn

-- Live Status Box
local StatusBox = Instance.new("Frame")
StatusBox.Size = UDim2.new(1, 0, 0, 36)
StatusBox.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
StatusBox.LayoutOrder = 2
StatusBox.Parent = ScrollContent
local StatCorner = Instance.new("UICorner")
StatCorner.CornerRadius = UDim.new(0, 8)
StatCorner.Parent = StatusBox
local StatStroke = Instance.new("UIStroke")
StatStroke.Color = Color3.fromRGB(55, 65, 81)
StatStroke.Parent = StatusBox

local StatusText = Instance.new("TextLabel")
StatusText.Text = "📍 สถานะ: ⏸️ บอทพร้อมทำงาน (เลือกคนที่จะขโมยด้านล่างได้เลย)"
StatusText.Font = Enum.Font.GothamMedium
StatusText.TextSize = 10.5
StatusText.TextColor3 = Color3.fromRGB(148, 163, 184)
StatusText.Position = UDim2.new(0, 10, 0, 0)
StatusText.Size = UDim2.new(1, -20, 1, 0)
StatusText.TextXAlignment = Enum.TextXAlignment.Left
StatusText.BackgroundTransparency = 1
StatusText.Parent = StatusBox

-- 🏆 PLAYERS LEADERBOARD & TARGET LIST (ดึงรายชื่อคนในเซิร์ฟเวอร์สดๆ)
local TargetsFrame = Instance.new("Frame")
TargetsFrame.Size = UDim2.new(1, 0, 0, 160)
TargetsFrame.BackgroundColor3 = Color3.fromRGB(17, 24, 39)
TargetsFrame.LayoutOrder = 3
TargetsFrame.Parent = ScrollContent
local TgtCorner = Instance.new("UICorner")
TgtCorner.CornerRadius = UDim.new(0, 8)
TgtCorner.Parent = TargetsFrame

local TgtHeader = Instance.new("Frame")
TgtHeader.Size = UDim2.new(1, 0, 0, 30)
TgtHeader.BackgroundTransparency = 1
TgtHeader.Parent = TargetsFrame

local TgtTitle = Instance.new("TextLabel")
TgtTitle.Text = "👑 รายชื่อผู้เล่นในห้อง (กดปุ่มเพื่อวาร์ปไปขโมยคอกคนนั้นทันที):"
TgtTitle.Font = Enum.Font.GothamBold
TgtTitle.TextSize = 10.5
TgtTitle.TextColor3 = Color3.fromRGB(250, 204, 21)
TgtTitle.Position = UDim2.new(0, 10, 0, 0)
TgtTitle.Size = UDim2.new(0.8, 0, 1, 0)
TgtTitle.TextXAlignment = Enum.TextXAlignment.Left
TgtTitle.BackgroundTransparency = 1
TgtTitle.Parent = TgtHeader

local RefreshBtn = Instance.new("TextButton")
RefreshBtn.Text = "🔄 รีเฟรช"
RefreshBtn.Font = Enum.Font.GothamBold
RefreshBtn.TextSize = 9.5
RefreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshBtn.Position = UDim2.new(1, -70, 0, 4)
RefreshBtn.Size = UDim2.new(0, 64, 0, 22)
RefreshBtn.BackgroundColor3 = Color3.fromRGB(79, 70, 229)
RefreshBtn.Parent = TgtHeader
local RefC = Instance.new("UICorner")
RefC.CornerRadius = UDim.new(0, 5)
RefC.Parent = RefreshBtn

local TargetsScroll = Instance.new("ScrollingFrame")
TargetsScroll.Size = UDim2.new(1, -16, 1, -38)
TargetsScroll.Position = UDim2.new(0, 8, 0, 32)
TargetsScroll.BackgroundTransparency = 1
TargetsScroll.BorderSizePixel = 0
TargetsScroll.ScrollBarThickness = 3
TargetsScroll.ScrollBarImageColor3 = Color3.fromRGB(250, 204, 21)
TargetsScroll.Parent = TargetsFrame

local TargetsLayout = Instance.new("UIListLayout")
TargetsLayout.Padding = UDim.new(0, 4)
TargetsLayout.Parent = TargetsScroll

-- Quick Toggles
local function createSimpleToggle(title, desc, default, callback)
    local F = Instance.new("Frame")
    F.Size = UDim2.new(1, 0, 0, 42)
    F.BackgroundColor3 = Color3.fromRGB(17, 24, 39)
    F.LayoutOrder = 4
    F.Parent = ScrollContent
    local FC = Instance.new("UICorner")
    FC.CornerRadius = UDim.new(0, 8)
    FC.Parent = F

    local L = Instance.new("TextLabel")
    L.Text = title
    L.Font = Enum.Font.GothamSemibold
    L.TextSize = 10.5
    L.TextColor3 = Color3.fromRGB(243, 244, 246)
    L.Position = UDim2.new(0, 10, 0, 5)
    L.Size = UDim2.new(0.7, 0, 0, 15)
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.BackgroundTransparency = 1
    L.Parent = F

    local Sub = Instance.new("TextLabel")
    Sub.Text = desc
    Sub.Font = Enum.Font.Gotham
    Sub.TextSize = 8.5
    Sub.TextColor3 = Color3.fromRGB(156, 163, 175)
    Sub.Position = UDim2.new(0, 10, 0, 21)
    Sub.Size = UDim2.new(0.7, 0, 0, 15)
    Sub.TextXAlignment = Enum.TextXAlignment.Left
    Sub.BackgroundTransparency = 1
    Sub.Parent = F

    local B = Instance.new("TextButton")
    B.Size = UDim2.new(0, 50, 0, 22)
    B.Position = UDim2.new(1, -58, 0.5, -11)
    B.BackgroundColor3 = default and Color3.fromRGB(16, 185, 129) or Color3.fromRGB(55, 65, 81)
    B.Text = default and "ON" or "OFF"
    B.Font = Enum.Font.GothamBold
    B.TextSize = 10
    B.TextColor3 = Color3.fromRGB(255, 255, 255)
    B.Parent = F
    local BC = Instance.new("UICorner")
    BC.CornerRadius = UDim.new(0, 5)
    BC.Parent = B

    local state = default
    B.MouseButton1Click:Connect(function()
        state = not state
        B.Text = state and "ON" or "OFF"
        B.BackgroundColor3 = state and Color3.fromRGB(16, 185, 129) or Color3.fromRGB(55, 65, 81)
        callback(state)
    end)
end

local AutoReturnBase = true
local AutoKillAura = true
local AutoNoclip = true

createSimpleToggle("🏠 วาร์ปกลับบ้านอัตโนมัติ (Instant Return Base)", "เมื่อหยิบสัตว์เลี้ยง/ไข่เสร็จจะวาร์ปกลับคอกเราทันที", true, function(v)
    AutoReturnBase = v
end)

createSimpleToggle("🏏 ถือไม้เบสบอลฟาดคน (Auto Bat Aura)", "ฟาดคนรอบตัวและคนที่จะมาแย่งอัตโนมัติ", true, function(v)
    AutoKillAura = v
end)

createSimpleToggle("👻 เดินทะลุรั้ว (Noclip)", "เดินทะลุรั้วคอกกั้นทุกประเภท", true, function(v)
    AutoNoclip = v
end)

RunService.Stepped:Connect(function()
    if AutoNoclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- ==============================================================================
-- 🚀 CORE LOGIC: FINDING PLAYER BASES & STEALING
-- ==============================================================================

local function getMyBaseCFrame()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("SpawnLocation") and (obj.Name:lower():find(LocalPlayer.Name:lower()) or obj.Name:lower():find("base") or obj.Name:lower():find("home")) then
            return obj.CFrame + Vector3.new(0, 3, 0)
        end
    end
    return CFrame.new(0, 5, 0)
end

-- ฟังก์ชันค้นหาพิกัดคอกสัตว์เลี้ยงของผู้เล่นเป้าหมาย
local function findTargetPlayerBase(targetPlayer)
    if not targetPlayer then return nil end

    -- 1. ค้นหาจากชื่อป้ายหรือ SpawnLocation ของผู้เล่นนั้น
    for _, obj in pairs(workspace:GetDescendants()) do
        if (obj:IsA("Model") or obj:IsA("BasePart") or obj:IsA("Folder")) and obj.Name:lower():find(targetPlayer.Name:lower()) then
            local cf = obj:IsA("BasePart") and obj.CFrame or (obj:IsA("Model") and (obj.PrimaryPart and obj.PrimaryPart.CFrame or obj:GetModelCFrame()))
            if cf then return cf end
        end
        if obj:IsA("TextLabel") or obj:IsA("SurfaceGui") or obj:IsA("BillboardGui") then
            local txt = obj:IsA("TextLabel") and obj.Text or (obj:FindFirstChildOfClass("TextLabel") and obj:FindFirstChildOfClass("TextLabel").Text or "")
            if txt:lower():find(targetPlayer.Name:lower()) or txt:lower():find(targetPlayer.DisplayName:lower()) then
                local model = obj:FindFirstAncestorOfClass("Model") or obj.Parent
                if model and model:IsA("Model") and model.PrimaryPart then
                    return model.PrimaryPart.CFrame
                elseif model and model:IsA("BasePart") then
                    return model.CFrame
                end
            end
        end
    end

    -- 2. ถ้าไม่พบป้าย ให้ใช้วาร์ปไปหาตัวผู้เล่นนั้นโดยตรง (ถ้าผู้เล่นกำลังยืนเฝ้าคอก)
    if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return targetPlayer.Character.HumanoidRootPart.CFrame
    end

    return nil
end

-- ฟังก์ชันขโมยเป้าหมายในจุดนั้นๆ
local function performStealAtLocation(targetCFrame, targetName)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = LocalPlayer.Character.HumanoidRootPart

    StatusText.Text = string.format("🏃‍♂️ กำลังวาร์ปไปขโมยที่คอกของ: %s...", targetName)
    StatusText.TextColor3 = Color3.fromRGB(96, 165, 250)

    -- วาร์ปไปที่คอก
    hrp.CFrame = targetCFrame + Vector3.new(0, 3, 0)
    task.wait(0.2)

    -- กวาดขโมยทุกอย่างในรัศมีรอบตัว 35 เมตร
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") and obj.Parent:IsA("BasePart") then
            if (obj.Parent.Position - hrp.Position).Magnitude < 35 then
                pcall(function()
                    fireproximityprompt(obj, 0)
                    fireproximityprompt(obj, 1)
                end)
            end
        end
        if obj:IsA("BasePart") and (obj.Position - hrp.Position).Magnitude < 25 then
            if obj.Name:lower():find("egg") or obj.Name:lower():find("pet") or obj.Name:lower():find("chilli") or obj.Name:lower():find("chilling") or obj.Name:lower():find("dragon") then
                pcall(function()
                    firetouchinterest(hrp, obj, 0)
                    task.wait(0.05)
                    firetouchinterest(hrp, obj, 1)
                end)
            end
        end
    end

    -- ถือไม้เบสบอลฟาดคนรอบตัว
    if AutoKillAura then
        local bat = LocalPlayer.Backpack:FindFirstChild("Bat") or LocalPlayer.Character:FindFirstChild("Bat")
        if bat and bat.Parent == LocalPlayer.Backpack then LocalPlayer.Character.Humanoid:EquipTool(bat) end
        if bat and bat:FindFirstChild("Handle") then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    if (p.Character.HumanoidRootPart.Position - hrp.Position).Magnitude < 20 then
                        firetouchinterest(bat.Handle, p.Character.HumanoidRootPart, 0)
                        task.wait(0.02)
                        firetouchinterest(bat.Handle, p.Character.HumanoidRootPart, 1)
                    end
                end
            end
        end
    end

    StatusText.Text = string.format("✅ ขโมยของจาก [%s] สำเร็จ!", targetName)
    StatusText.TextColor3 = Color3.fromRGB(52, 211, 153)
    task.wait(0.4)

    -- วาร์ปกลับบ้าน
    if AutoReturnBase then
        StatusText.Text = "🏠 กำลังนำสัตว์เลี้ยงกลับมาเก็บที่บ้าน..."
        StatusText.TextColor3 = Color3.fromRGB(168, 85, 247)
        hrp.CFrame = getMyBaseCFrame()
        task.wait(0.5)
    end
end

-- ฟังก์ชันดึงรายชื่อคนในเซิร์ฟเวอร์
local function getSortedPlayerList()
    local pList = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local moneyRate = 0
            pcall(function()
                local leaderstats = p:FindFirstChild("leaderstats")
                if leaderstats then
                    for _, val in pairs(leaderstats:GetChildren()) do
                        if val.Name:lower():find("rate") or val.Name:lower():find("money") or val.Name:lower():find("cash") then
                            moneyRate = tonumber(val.Value) or 0
                        end
                    end
                end
            end)
            table.insert(pList, {
                player = p,
                name = p.Name,
                displayName = p.DisplayName,
                rate = moneyRate
            })
        end
    end

    table.sort(pList, function(a, b)
        return a.rate > b.rate
    end)
    return pList
end

-- อัปเดตรายชื่อใน UI
local function updatePlayerTargetsUI()
    TargetsScroll:ClearAllChildren()
    local list = getSortedPlayerList()

    if #list == 0 then
        local emptyLbl = Instance.new("TextLabel")
        emptyLbl.Size = UDim2.new(1, 0, 0, 30)
        emptyLbl.Text = "ไม่พบผู้เล่นอื่นในห้อง..."
        emptyLbl.Font = Enum.Font.Gotham
        emptyLbl.TextSize = 10
        emptyLbl.TextColor3 = Color3.fromRGB(156, 163, 175)
        emptyLbl.BackgroundTransparency = 1
        emptyLbl.Parent = TargetsScroll
        return
    end

    for idx, item in ipairs(list) do
        local Row = Instance.new("Frame")
        Row.Size = UDim2.new(1, -6, 0, 28)
        Row.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
        Row.Parent = TargetsScroll
        local RC = Instance.new("UICorner")
        RC.CornerRadius = UDim.new(0, 5)
        RC.Parent = Row

        local PName = Instance.new("TextLabel")
        PName.Text = string.format("#%d 👤 %s (@%s)", idx, item.displayName, item.name)
        PName.Font = Enum.Font.GothamSemibold
        PName.TextSize = 9.5
        PName.TextColor3 = Color3.fromRGB(243, 244, 246)
        PName.Position = UDim2.new(0, 8, 0, 0)
        PName.Size = UDim2.new(0.68, 0, 1, 0)
        PName.TextXAlignment = Enum.TextXAlignment.Left
        PName.BackgroundTransparency = 1
        PName.Parent = Row

        local StealBtn = Instance.new("TextButton")
        StealBtn.Text = "🚀 ขโมยคอกนี้"
        StealBtn.Font = Enum.Font.GothamBold
        StealBtn.TextSize = 9
        StealBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        StealBtn.Position = UDim2.new(1, -78, 0, 3)
        StealBtn.Size = UDim2.new(0, 72, 0, 22)
        StealBtn.BackgroundColor3 = Color3.fromRGB(234, 88, 12)
        StealBtn.Parent = Row
        local SC = Instance.new("UICorner")
        SC.CornerRadius = UDim.new(0, 4)
        SC.Parent = StealBtn

        StealBtn.MouseButton1Click:Connect(function()
            local cf = findTargetPlayerBase(item.player)
            if cf then
                performStealAtLocation(cf, item.name)
            else
                StatusText.Text = "❌ ไม่พบตำแหน่งคอกของผู้เล่นนี้"
                StatusText.TextColor3 = Color3.fromRGB(239, 68, 68)
            end
        end)
    end
end
RefreshBtn.MouseButton1Click:Connect(updatePlayerTargetsUI)

-- ลูปบอทอัตโนมัติ (ขโมยวนทุกคนในห้อง)
local function runAutoStealLoop()
    task.spawn(function()
        while isAutoStealing do
            pcall(function()
                local list = getSortedPlayerList()
                if #list > 0 then
                    for _, item in ipairs(list) do
                        if not isAutoStealing then break end
                        local cf = findTargetPlayerBase(item.player)
                        if cf then
                            performStealAtLocation(cf, item.name)
                            task.wait(1.5)
                        end
                    end
                else
                    StatusText.Text = "⏳ ไม่มีคนอื่นในห้อง กำลังรอ..."
                    task.wait(2)
                end
            end)
            task.wait(1)
        end
    end)
end

MasterBtn.MouseButton1Click:Connect(function()
    isAutoStealing = not isAutoStealing
    if isAutoStealing then
        MasterBtn.Text = "⏹️ หยุดระบบบอท (STOP BOT)"
        MasterBtn.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
        runAutoStealLoop()
    else
        MasterBtn.Text = "▶️ เริ่มขโมยวนจากคนรวยที่สุดในห้อง (AUTO STEAL LOOP)"
        MasterBtn.BackgroundColor3 = Color3.fromRGB(16, 185, 129)
        StatusText.Text = "📍 สถานะ: ⏸️ บอทหยุดทำงานเรียบร้อย"
        StatusText.TextColor3 = Color3.fromRGB(148, 163, 184)
    end
end)

task.spawn(function()
    task.wait(1)
    updatePlayerTargetsUI()
end)

print("⚡ [DirectStealHub v6.0] โหลดระบบขโมยคอกผู้เล่นสำเร็จ!")
