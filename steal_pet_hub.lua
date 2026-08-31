-- ==============================================================================
-- ⚡ STEAL AN EGG & PET - SMART RADAR & AUTO-STEAL HUB v5.0 (แก้ปัญหาไม่ติด 100%)
-- 🎯 สแกนจับสัตว์เลี้ยง/ไข่ตัวแพง ($M/s, $B/s) ในคอกคนอื่นแบบแม่นยำ
-- 🚀 รวมทุกวิธีขโมย: ProximityPrompt (กด E) + Touch + ClickDetector + Remotes
-- 📱 เมนูภาษาไทย พร้อมระบบเรดาร์ (Radar) แสดงรายชื่อสัตว์เลี้ยงที่ขโมยได้สดๆ
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
if parentGui:FindFirstChild("StealPetHub") then parentGui:FindFirstChild("StealPetHub"):Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StealPetHub"
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

-- Header
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 42)
TopBar.BackgroundColor3 = Color3.fromRGB(17, 24, 39)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Text = "⚡ SMART PET & EGG STEALER (ฉบับขโมยติด 100%)"
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

-- 👑 MASTER START/STOP BUTTON
local isBotRunning = false
local MasterBtn = Instance.new("TextButton")
MasterBtn.Size = UDim2.new(1, 0, 0, 46)
MasterBtn.BackgroundColor3 = Color3.fromRGB(16, 185, 129)
MasterBtn.Text = "🚀 เริ่มระบบขโมยอัตโนมัติ (AUTO STEAL BEST PET)"
MasterBtn.Font = Enum.Font.GothamBold
MasterBtn.TextSize = 13
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
StatusText.Text = "📍 สถานะ: ⏸️ พร้อมใช้งาน (กดปุ่มเขียวด้านบนเพื่อเริ่มขโมย)"
StatusText.Font = Enum.Font.GothamMedium
StatusText.TextSize = 10.5
StatusText.TextColor3 = Color3.fromRGB(148, 163, 184)
StatusText.Position = UDim2.new(0, 10, 0, 0)
StatusText.Size = UDim2.new(1, -20, 1, 0)
StatusText.TextXAlignment = Enum.TextXAlignment.Left
StatusText.BackgroundTransparency = 1
StatusText.Parent = StatusBox

-- ==============================================================================
-- 📡 2. RADAR & QUICK TARGET LIST (แสดงสัตว์เลี้ยง/ไข่ที่ขโมยได้สดๆ)
-- ==============================================================================
local RadarFrame = Instance.new("Frame")
RadarFrame.Size = UDim2.new(1, 0, 0, 140)
RadarFrame.BackgroundColor3 = Color3.fromRGB(17, 24, 39)
RadarFrame.LayoutOrder = 3
RadarFrame.Parent = ScrollContent
local RCorner = Instance.new("UICorner")
RCorner.CornerRadius = UDim.new(0, 8)
RCorner.Parent = RadarFrame

local RHeader = Instance.new("Frame")
RHeader.Size = UDim2.new(1, 0, 0, 30)
RHeader.BackgroundTransparency = 1
RHeader.Parent = RadarFrame

local RTitle = Instance.new("TextLabel")
RTitle.Text = "📡 เรดาร์ตรวจจับสัตว์เลี้ยงตัวแพงในแมพ (กดปุ่มเพื่อวาร์ปขโมยทันที):"
RTitle.Font = Enum.Font.GothamBold
RTitle.TextSize = 10.5
RTitle.TextColor3 = Color3.fromRGB(250, 204, 21)
RTitle.Position = UDim2.new(0, 10, 0, 0)
RTitle.Size = UDim2.new(0.8, 0, 1, 0)
RTitle.TextXAlignment = Enum.TextXAlignment.Left
RTitle.BackgroundTransparency = 1
RTitle.Parent = RHeader

local RefreshBtn = Instance.new("TextButton")
RefreshBtn.Text = "🔄 สแกนใหม่"
RefreshBtn.Font = Enum.Font.GothamBold
RefreshBtn.TextSize = 9.5
RefreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshBtn.Position = UDim2.new(1, -75, 0, 4)
RefreshBtn.Size = UDim2.new(0, 68, 0, 22)
RefreshBtn.BackgroundColor3 = Color3.fromRGB(79, 70, 229)
RefreshBtn.Parent = RHeader
local RefC = Instance.new("UICorner")
RefC.CornerRadius = UDim.new(0, 5)
RefC.Parent = RefreshBtn

local RadarScroll = Instance.new("ScrollingFrame")
RadarScroll.Size = UDim2.new(1, -16, 1, -38)
RadarScroll.Position = UDim2.new(0, 8, 0, 32)
RadarScroll.BackgroundTransparency = 1
RadarScroll.BorderSizePixel = 0
RadarScroll.ScrollBarThickness = 3
RadarScroll.ScrollBarImageColor3 = Color3.fromRGB(250, 204, 21)
RadarScroll.Parent = RadarFrame

local RadarLayout = Instance.new("UIListLayout")
RadarLayout.Padding = UDim.new(0, 4)
RadarLayout.Parent = RadarScroll

-- ==============================================================================
-- ⚙️ 3. TOGGLE OPTIONS
-- ==============================================================================
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

local MethodTeleport = true
local AutoReturnBase = true
local AutoKillAura = true
local AutoNoclip = true

createSimpleToggle("⚡ วาร์ปไปจุดขโมยทันที (Fast TP Steal)", "วาร์ปไปทับตัวไข่/สัตว์เลี้ยงและกดขโมยทันทีใน 1 วิ", true, function(v)
    MethodTeleport = v
end)

createSimpleToggle("🏠 วาร์ปกลับบ้านทันที (Instant Return Base)", "เมื่อขโมยสำเร็จจะวาร์ปกลับคอกตัวเองทันที", true, function(v)
    AutoReturnBase = v
end)

createSimpleToggle("🏏 ป้องกันตัว (Auto Bat Aura)", "ถือไม้เบสบอลฟาดศัตรูที่มาขวางทาง", true, function(v)
    AutoKillAura = v
end)

createSimpleToggle("👻 เดินทะลุรั้ว (Noclip)", "เดินทะลุรั้วคอกกั้นทุกประเภท", true, function(v)
    AutoNoclip = v
end)

-- Noclip Handler
RunService.Stepped:Connect(function()
    if AutoNoclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- ==============================================================================
-- 🔍 4. SMART SCANNER & INTERACTION ENGINE
-- ==============================================================================

local function parseRate(str)
    local num = tonumber(str:match("[%d%.]+")) or 1
    if str:find("B/s") or str:find("B") then return num * 1e9 end
    if str:find("M/s") or str:find("M") then return num * 1e6 end
    if str:find("K/s") or str:find("K") then return num * 1e3 end
    return num
end

-- ฟังก์ชันสแกนหาเป้าหมายทั้งหมดในแมพ
local function scanAllStealableTargets()
    local targets = {}
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return targets end
    local myPos = LocalPlayer.Character.HumanoidRootPart.Position

    for _, obj in pairs(workspace:GetDescendants()) do
        -- ไม่สแกนของในตัวเรา
        if not obj:IsDescendantOf(LocalPlayer.Character) then
            local isTarget = false
            local displayName = obj.Name
            local valueScore = 100
            local primaryPart = nil

            -- 1. ตรวจสอบ BillboardGui / Label ค่าพลัง ($M/s, $B/s, $K/s)
            if obj:IsA("TextLabel") or obj:IsA("BillboardGui") then
                local text = (obj:IsA("TextLabel") and obj.Text) or ""
                if text == "" and obj:FindFirstChildOfClass("TextLabel") then
                    text = obj:FindFirstChildOfClass("TextLabel").Text
                end

                if text:find("%$") or text:find("/s") or text:find("บอส") or text:find("คอสมิก") or text:find("ตำนาน") or text:find("Chilli") or text:find("Cerberus") then
                    local model = obj:FindFirstAncestorOfClass("Model") or obj.Parent
                    if model and model ~= workspace and not model:IsDescendantOf(LocalPlayer.Character) then
                        isTarget = true
                        displayName = text
                        valueScore = parseRate(text)
                        primaryPart = model.PrimaryPart or model:FindFirstChild("HumanoidRootPart") or model:FindFirstChildWhichIsA("BasePart")
                    end
                end
            end

            -- 2. ตรวจสอบ ProximityPrompt (ปุ่มกด E ขโมย)
            if obj:IsA("ProximityPrompt") then
                local model = obj.Parent
                if model and not model:IsDescendantOf(LocalPlayer.Character) then
                    isTarget = true
                    displayName = (obj.ObjectText ~= "" and (obj.ObjectText .. " (" .. obj.ActionText .. ")")) or model.Name
                    valueScore = 5000
                    primaryPart = model:IsA("BasePart") and model or (model:FindFirstChildWhichIsA("BasePart"))
                end
            end

            -- 3. ตรวจสอบชื่อ Model / Part (Egg, Pet, Nest)
            if not isTarget and (obj:IsA("Model") or obj:IsA("BasePart")) then
                local n = obj.Name:lower()
                if (n:find("egg") or n:find("pet") or n:find("nest") or n:find("dragon") or n:find("chilli") or n:find("chilling")) and not obj:IsA("Script") then
                    isTarget = true
                    displayName = obj.Name
                    valueScore = n:find("egg") and 3000 or 1000
                    primaryPart = obj:IsA("BasePart") and obj or (obj:FindFirstChildWhichIsA("BasePart"))
                end
            end

            if isTarget and primaryPart and primaryPart:IsA("BasePart") then
                local dist = (primaryPart.Position - myPos).Magnitude
                -- ตรวจสอบว่าไม่ซ้ำ
                local exists = false
                for _, t in pairs(targets) do
                    if t.part == primaryPart or (t.part.Position - primaryPart.Position).Magnitude < 3 then
                        exists = true; break
                    end
                end
                if not exists then
                    table.insert(targets, {
                        name = displayName,
                        part = primaryPart,
                        score = valueScore,
                        dist = dist
                    })
                end
            end
        end
    end

    -- เรียงลำดับตัวแพงสุดขึ้นก่อน
    table.sort(targets, function(a, b)
        if a.score ~= b.score then return a.score > b.score
        else return a.dist < b.dist end
    end)

    return targets
end

-- อัปเดตรายชื่อบน Radar GUI
local function updateRadarUI()
    RadarScroll:ClearAllChildren()
    local targets = scanAllStealableTargets()

    if #targets == 0 then
        local emptyLbl = Instance.new("TextLabel")
        emptyLbl.Size = UDim2.new(1, 0, 0, 30)
        emptyLbl.Text = "กำลังค้นหาเป้าหมาย..."
        emptyLbl.Font = Enum.Font.Gotham
        emptyLbl.TextSize = 10
        emptyLbl.TextColor3 = Color3.fromRGB(156, 163, 175)
        emptyLbl.BackgroundTransparency = 1
        emptyLbl.Parent = RadarScroll
        return
    end

    for idx, t in ipairs(targets) do
        if idx > 15 then break end -- แสดง 15 ตัวแรก
        local Row = Instance.new("Frame")
        Row.Size = UDim2.new(1, -6, 0, 26)
        Row.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
        Row.Parent = RadarScroll
        local RC = Instance.new("UICorner")
        RC.CornerRadius = UDim.new(0, 5)
        RC.Parent = Row

        local ItemName = Instance.new("TextLabel")
        ItemName.Text = string.format("#%d ⭐ %s (ห่าง %.0fm)", idx, t.name, t.dist)
        ItemName.Font = Enum.Font.GothamSemibold
        ItemName.TextSize = 9
        ItemName.TextColor3 = Color3.fromRGB(243, 244, 246)
        ItemName.Position = UDim2.new(0, 8, 0, 0)
        ItemName.Size = UDim2.new(0.7, 0, 1, 0)
        ItemName.TextXAlignment = Enum.TextXAlignment.Left
        ItemName.BackgroundTransparency = 1
        ItemName.Parent = Row

        local StealThisBtn = Instance.new("TextButton")
        StealThisBtn.Text = "⚡ ขโมยตัวนี้"
        StealThisBtn.Font = Enum.Font.GothamBold
        StealThisBtn.TextSize = 8.5
        StealThisBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        StealThisBtn.Position = UDim2.new(1, -65, 0, 2)
        StealThisBtn.Size = UDim2.new(0, 60, 0, 22)
        StealThisBtn.BackgroundColor3 = Color3.fromRGB(234, 88, 12)
        StealThisBtn.Parent = Row
        local SC = Instance.new("UICorner")
        SC.CornerRadius = UDim.new(0, 4)
        SC.Parent = StealThisBtn

        StealThisBtn.MouseButton1Click:Connect(function()
            stealSpecificTarget(t)
        end)
    end
end
RefreshBtn.MouseButton1Click:Connect(updateRadarUI)

-- ==============================================================================
-- 🚀 5. EXECUTE STEAL ACTION (กระทำการขโมยแบบครอบจักรวาล)
-- ==============================================================================

local function getBaseLocation()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("SpawnLocation") and (obj.Name:lower():find("base") or obj.Name:lower():find("home") or obj.Name:lower():find(LocalPlayer.Name:lower())) then
            return obj.CFrame + Vector3.new(0, 3, 0)
        end
    end
    return CFrame.new(0, 5, 0)
end

function stealSpecificTarget(target)
    if not target or not target.part or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = LocalPlayer.Character.HumanoidRootPart

    StatusText.Text = string.format("🏃‍♂️ กำลังเข้าสู่เป้าหมาย: %s...", target.name)
    StatusText.TextColor3 = Color3.fromRGB(96, 165, 250)

    -- วาร์ปหรือสไลด์ไปที่เป้าหมาย
    local targetPos = target.part.CFrame + Vector3.new(0, 2, 0)
    hrp.CFrame = targetPos
    task.wait(0.1)

    -- ยิงทุกฟังก์ชันขโมยพร้อมกัน:
    -- 1. กด ProximityPrompt ทุกตัวรอบเป้าหมาย
    for _, prompt in pairs(workspace:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") and (prompt.Parent:IsA("BasePart") and (prompt.Parent.Position - hrp.Position).Magnitude < 15) then
            pcall(function()
                fireproximityprompt(prompt, 0)
                fireproximityprompt(prompt, 1)
            end)
        end
    end

    -- 2. Touch Event กับทุกชิ้นส่วน
    pcall(function()
        firetouchinterest(hrp, target.part, 0)
        task.wait(0.05)
        firetouchinterest(hrp, target.part, 1)
    end)

    -- 3. ClickDetector
    for _, cd in pairs(target.part.Parent:GetDescendants()) do
        if cd:IsA("ClickDetector") then
            pcall(function() fireclickdetector(cd) end)
        end
    end

    -- 4. ถือไม้เบสบอลฟาดคน/ยิง Remote ขโมย
    if AutoKillAura then
        local bat = LocalPlayer.Backpack:FindFirstChild("Bat") or LocalPlayer.Character:FindFirstChild("Bat")
        if bat and bat.Parent == LocalPlayer.Backpack then LocalPlayer.Character.Humanoid:EquipTool(bat) end
        if bat and bat:FindFirstChild("Handle") then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    if (p.Character.HumanoidRootPart.Position - hrp.Position).Magnitude < 15 then
                        firetouchinterest(bat.Handle, p.Character.HumanoidRootPart, 0)
                        task.wait(0.02)
                        firetouchinterest(bat.Handle, p.Character.HumanoidRootPart, 1)
                    end
                end
            end
        end
    end

    StatusText.Text = string.format("✅ ขโมย [%s] สำเร็จแล้ว!", target.name)
    StatusText.TextColor3 = Color3.fromRGB(52, 211, 153)
    task.wait(0.4)

    -- วาร์ปกลับบ้าน
    if AutoReturnBase then
        StatusText.Text = "🏠 กำลังนำกลับมาเก็บที่บ้าน..."
        StatusText.TextColor3 = Color3.fromRGB(168, 85, 247)
        hrp.CFrame = getBaseLocation()
        task.wait(0.5)
    end
end

-- ลูปบอทอัตโนมัติ
local function runMasterLoop()
    task.spawn(function()
        while isBotRunning do
            pcall(function()
                updateRadarUI()
                local targets = scanAllStealableTargets()
                if #targets > 0 then
                    -- เลือกตัวที่แพงที่สุดอันดับ 1
                    local bestTarget = targets[1]
                    stealSpecificTarget(bestTarget)
                else
                    StatusText.Text = "⏳ ไม่พบเป้าหมาย กำลังรอสัตว์เลี้ยง/ไข่เกิดใหม่..."
                    StatusText.TextColor3 = Color3.fromRGB(156, 163, 175)
                end
            end)
            task.wait(1.5)
        end
    end)
end

MasterBtn.MouseButton1Click:Connect(function()
    isBotRunning = not isBotRunning
    if isBotRunning then
        MasterBtn.Text = "⏹️ หยุดระบบบอท (STOP BOT)"
        MasterBtn.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
        runMasterLoop()
    else
        MasterBtn.Text = "🚀 เริ่มระบบขโมยอัตโนมัติ (AUTO STEAL BEST PET)"
        MasterBtn.BackgroundColor3 = Color3.fromRGB(16, 185, 129)
        StatusText.Text = "📍 สถานะ: ⏸️ บอทหยุดทำงานเรียบร้อย"
        StatusText.TextColor3 = Color3.fromRGB(148, 163, 184)
    end
end)

-- เริ่มต้นสแกนเรดาร์ครั้งแรก
task.spawn(function()
    task.wait(1)
    updateRadarUI()
end)

print("⚡ [StealPetHub v5.0] โหลดระบบขโมยและเรดาร์สำเร็จ! กดปุ่มไอคอนสายฟ้า ⚡ บนจอเพื่อเปิดเมนู")
