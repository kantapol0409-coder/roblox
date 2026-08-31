-- ==============================================================================
-- ⚡ STEAL PET & EGG - PRO AUTO-STEAL & RUNNER HUB (EASY EDITION)
-- 👑 เลือกไข่ระดับสูงสุด/แพงสุดได้ + วิ่งไปขโมยให้อัตโนมัติ + เมนูใช้งานง่ายสุดๆ
-- 📱 ออกแบบพิเศษสำหรับ Android Emulator (MuMu, LDPlayer, BlueStacks) & Mobile & PC
-- 🛡️ ระบบเคลื่อนที่แบบ Safe CFrame Glide ไม่โดน Anti-Cheat เตะ (No Error 267)
-- ==============================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

-- 🛡️ 1. BYPASS ANTI-CHEAT (BAC-8514 / Error 267 Bypass)
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

-- 🎨 2. SCREEN GUI SETUP
local parentGui = (gethui and gethui()) or game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")
if parentGui:FindFirstChild("EasyEggHub") then parentGui:FindFirstChild("EasyEggHub"):Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EasyEggHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = parentGui

-- 🔘 Floating Toggle Button (ปุ่มลอย ⚡ วงกลมใหญ่กดง่าย)
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

-- ลากปุ่มลอยได้
local dragging, dragInput, dragStart, startPos
ToggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = ToggleBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
ToggleBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        ToggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- 🖥️ MAIN EASY GUI (หน้าต่างเมนูสไตล์กระชับ ใช้งานง่าย)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainEasyFrame"
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
MStroke.Color = Color3.fromRGB(79, 70, 229)
MStroke.Thickness = 2
MStroke.Parent = MainFrame

-- Header
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 42)
TopBar.BackgroundColor3 = Color3.fromRGB(17, 24, 39)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Text = "⚡ AUTO STEAL EGG | วิ่งขโมยไข่อัตโนมัติ"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Position = UDim2.new(0, 14, 0, 0)
Title.Size = UDim2.new(0.7, 0, 1, 0)
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
Layout.Padding = UDim.new(0, 9)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = ScrollContent

-- ==============================================================================
-- 👑 1. MASTER START/STOP BUTTON (ปุ่มเปิด-ปิดระบบบอทใหญ่สุด)
-- ==============================================================================
local isBotRunning = false
local MasterBtn = Instance.new("TextButton")
MasterBtn.Size = UDim2.new(1, 0, 0, 48)
MasterBtn.BackgroundColor3 = Color3.fromRGB(16, 185, 129)
MasterBtn.Text = "▶️ เริ่มระบบวิ่งขโมยไข่อัตโนมัติ (START BOT)"
MasterBtn.Font = Enum.Font.GothamBold
MasterBtn.TextSize = 13
MasterBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MasterBtn.LayoutOrder = 1
MasterBtn.Parent = ScrollContent

local MasterCorner = Instance.new("UICorner")
MasterCorner.CornerRadius = UDim.new(0, 10)
MasterCorner.Parent = MasterBtn

-- Status Box
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
StatusText.Text = "📍 สถานะ: ⏸️ บอทหยุดทำงาน (กดปุ่มเขียวด้านบนเพื่อเริ่ม)"
StatusText.Font = Enum.Font.GothamMedium
StatusText.TextSize = 11
StatusText.TextColor3 = Color3.fromRGB(148, 163, 184)
StatusText.Position = UDim2.new(0, 10, 0, 0)
StatusText.Size = UDim2.new(1, -20, 1, 0)
StatusText.TextXAlignment = Enum.TextXAlignment.Left
StatusText.BackgroundTransparency = 1
StatusText.Parent = StatusBox

-- ==============================================================================
-- 🎯 2. RARITY SELECTOR (เลือกระดับไข่ที่ต้องการ)
-- ==============================================================================
local RarityFrame = Instance.new("Frame")
RarityFrame.Size = UDim2.new(1, 0, 0, 78)
RarityFrame.BackgroundColor3 = Color3.fromRGB(17, 24, 39)
RarityFrame.LayoutOrder = 3
RarityFrame.Parent = ScrollContent

local RCorner = Instance.new("UICorner")
RCorner.CornerRadius = UDim.new(0, 8)
RCorner.Parent = RarityFrame

local RLabel = Instance.new("TextLabel")
RLabel.Text = "🎯 เลือกระดับไข่เป้าหมาย (เลือกโหมดความหายาก):"
RLabel.Font = Enum.Font.GothamBold
RLabel.TextSize = 11
RLabel.TextColor3 = Color3.fromRGB(250, 204, 21)
RLabel.Position = UDim2.new(0, 10, 0, 6)
RLabel.Size = UDim2.new(1, -20, 0, 16)
RLabel.TextXAlignment = Enum.TextXAlignment.Left
RLabel.BackgroundTransparency = 1
RLabel.Parent = RarityFrame

local RarityButtonsContainer = Instance.new("Frame")
RarityButtonsContainer.Size = UDim2.new(1, -16, 0, 42)
RarityButtonsContainer.Position = UDim2.new(0, 8, 0, 28)
RarityButtonsContainer.BackgroundTransparency = 1
RarityButtonsContainer.Parent = RarityFrame

local selectedRarityMode = "highest" -- "highest", "secret", "legendary", "all"
local rBtns = {}

local function createRarityBtn(text, mode, xPos, width)
    local B = Instance.new("TextButton")
    B.Size = UDim2.new(width, -4, 1, 0)
    B.Position = UDim2.new(xPos, 2, 0, 0)
    B.BackgroundColor3 = (selectedRarityMode == mode) and Color3.fromRGB(79, 70, 229) or Color3.fromRGB(31, 41, 55)
    B.Text = text
    B.Font = Enum.Font.GothamBold
    B.TextSize = 9.5
    B.TextColor3 = Color3.fromRGB(255, 255, 255)
    B.Parent = RarityButtonsContainer

    local C = Instance.new("UICorner")
    C.CornerRadius = UDim.new(0, 6)
    C.Parent = B

    rBtns[mode] = B
    B.MouseButton1Click:Connect(function()
        selectedRarityMode = mode
        for m, btn in pairs(rBtns) do
            btn.BackgroundColor3 = (m == mode) and Color3.fromRGB(79, 70, 229) or Color3.fromRGB(31, 41, 55)
        end
    end)
end

createRarityBtn("👑 สูงสุด/แพงสุด", "highest", 0, 0.25)
createRarityBtn("🟣 Secret / Mythic", "secret", 0.25, 0.25)
createRarityBtn("🦅 Legendary+", "legendary", 0.50, 0.25)
createRarityBtn("🥚 เก็บทุกใบ", "all", 0.75, 0.25)

-- ==============================================================================
-- ⚙️ 3. TOGGLE CONTROLS (ฟังก์ชันเสริม)
-- ==============================================================================
local function createSimpleToggle(title, desc, default, callback)
    local F = Instance.new("Frame")
    F.Size = UDim2.new(1, 0, 0, 44)
    F.BackgroundColor3 = Color3.fromRGB(17, 24, 39)
    F.LayoutOrder = 4
    F.Parent = ScrollContent
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
    Sub.Text = desc
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

-- Slider Builder
local function createSimpleSlider(title, min, max, default, callback)
    local F = Instance.new("Frame")
    F.Size = UDim2.new(1, 0, 0, 48)
    F.BackgroundColor3 = Color3.fromRGB(17, 24, 39)
    F.LayoutOrder = 5
    F.Parent = ScrollContent
    local FC = Instance.new("UICorner")
    FC.CornerRadius = UDim.new(0, 8)
    FC.Parent = F

    local L = Instance.new("TextLabel")
    L.Text = title .. ": " .. tostring(default)
    L.Font = Enum.Font.GothamSemibold
    L.TextSize = 11
    L.TextColor3 = Color3.fromRGB(243, 244, 246)
    L.Position = UDim2.new(0, 10, 0, 6)
    L.Size = UDim2.new(1, -20, 0, 14)
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.BackgroundTransparency = 1
    L.Parent = F

    local SB = Instance.new("TextButton")
    SB.Text = ""
    SB.Size = UDim2.new(1, -20, 0, 8)
    SB.Position = UDim2.new(0, 10, 0, 28)
    SB.BackgroundColor3 = Color3.fromRGB(55, 65, 81)
    SB.Parent = F
    local SBC = Instance.new("UICorner")
    SBC.CornerRadius = UDim.new(1, 0)
    SBC.Parent = SB

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(99, 102, 241)
    Fill.BorderSizePixel = 0
    Fill.Parent = SB
    local FillC = Instance.new("UICorner")
    FillC.CornerRadius = UDim.new(1, 0)
    FillC.Parent = Fill

    local function update(input)
        local pos = math.clamp((input.Position.X - SB.AbsolutePosition.X) / SB.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * pos)
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        L.Text = title .. ": " .. tostring(val)
        callback(val)
    end

    local sliding = false
    SB.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = true; update(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
end

-- Settings State
local AutoReturnBase = true
local SpeedMultiplier = 1.0
local AutoKillAura = true
local AutoNoclip = true
local AutoCollectCash = true

createSimpleSlider("👟 ความเร็วในการวิ่งไปขโมย (Run Speed)", 1, 5, 2, function(v)
    SpeedMultiplier = v * 0.45
end)

createSimpleToggle("🏠 วิ่งกลับบ้านอัตโนมัติ (Auto Return Base)", "เมื่อขโมยไข่เสร็จจะวิ่งกลับมาเก็บที่บ้านทันที", true, function(v)
    AutoReturnBase = v
end)

createSimpleToggle("🏏 ป้องกันตัวรอบด้าน (Auto Bat Aura)", "ถือไม้เบสบอลฟาดคนที่จะมาแย่ง/ขวางทาง", true, function(v)
    AutoKillAura = v
end)

createSimpleToggle("👻 เดินทะลุรั้ว (Noclip)", "เดินทะลุรั้วคอกและกำแพงบ้านคนอื่น", true, function(v)
    AutoNoclip = v
end)

createSimpleToggle("💵 ดูดเงินรอบตัว (Auto Collect Cash)", "ดูดเงินที่ตกตามพื้นและในคอกอัตโนมัติ", true, function(v)
    AutoCollectCash = v
end)

-- Noclip Handler
RunService.Stepped:Connect(function()
    if isBotRunning and AutoNoclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- ==============================================================================
-- 🚀 4. CORE AUTO-RUN & SMART TARGET FINDER
-- ==============================================================================

-- ตารางคะแนนความหายากของไข่
local RarityWeights = {
    ["secret"] = 10000,
    ["godly"] = 9000,
    ["cosmic"] = 8000,
    ["void"] = 7500,
    ["mythic"] = 7000,
    ["diamond"] = 6000,
    ["golden"] = 5000,
    ["legendary"] = 4000,
    ["epic"] = 2000,
    ["rare"] = 1000,
    ["uncommon"] = 500,
    ["common"] = 100,
    ["egg"] = 50
}

local function getEggScore(obj)
    local name = obj.Name:lower()
    local score = 10
    for keyword, weight in pairs(RarityWeights) do
        if name:find(keyword) then
            if weight > score then score = weight end
        end
    end
    -- ตรวจสอบ Attributes เพิ่มเติมถ้าเกมใส่ไว้
    pcall(function()
        local attrRarity = obj:GetAttribute("Rarity") or obj:GetAttribute("Tier") or obj:GetAttribute("Price")
        if attrRarity then
            local aStr = tostring(attrRarity):lower()
            for keyword, weight in pairs(RarityWeights) do
                if aStr:find(keyword) then
                    if weight > score then score = weight end
                end
            end
        end
    end)
    return score
end

local function findBestTargetEgg()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return nil end
    local myPos = LocalPlayer.Character.HumanoidRootPart.Position

    local candidateEggs = {}

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("egg") or obj.Name:lower():find("pet")) then
            -- ไม่นับตัวเราเองหรือสัตว์เลี้ยงที่ถืออยู่
            if not obj:IsDescendantOf(LocalPlayer.Character) then
                local score = getEggScore(obj)
                local dist = (obj.Position - myPos).Magnitude

                local match = false
                if selectedRarityMode == "highest" then
                    match = true -- จะถูก sort ด้วย score สูงสุด
                elseif selectedRarityMode == "secret" and score >= 7000 then
                    match = true
                elseif selectedRarityMode == "legendary" and score >= 4000 then
                    match = true
                elseif selectedRarityMode == "all" then
                    match = true
                end

                if match then
                    table.insert(candidateEggs, {
                        part = obj,
                        score = score,
                        dist = dist,
                        name = obj.Name
                    })
                end
            end
        end
    end

    if #candidateEggs == 0 then return nil end

    -- เรียงตามคะแนนความหายากสูงสุด (ถ้าเท่ากันให้เอาตัวที่ใกล้สุด)
    table.sort(candidateEggs, function(a, b)
        if a.score ~= b.score then
            return a.score > b.score
        else
            return a.dist < b.dist
        end
    end)

    return candidateEggs[1]
end

local function getBaseLocation()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("SpawnLocation") and (obj.Name:lower():find("base") or obj.Name:lower():find("home") or obj.Name:lower():find(LocalPlayer.Name:lower())) then
            return obj.Position + Vector3.new(0, 3, 0)
        end
    end
    return Vector3.new(0, 5, 0)
end

-- ฟังก์ชันวิ่งแบบ Smooth Glide ป้องกันการวาร์ปกระชากโดนแบน
local function smoothMoveTo(targetPosition, onStepCallback)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = LocalPlayer.Character.HumanoidRootPart
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")

    local stepDist = 0.8 * SpeedMultiplier

    while isBotRunning and (hrp.Position - targetPosition).Magnitude > 4 do
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then break end
        
        local currentPos = hrp.Position
        local dir = (targetPosition - currentPos).Unit
        local nextPos = currentPos + (dir * stepDist)

        hrp.CFrame = CFrame.new(nextPos, nextPos + dir)
        if humanoid then humanoid:MoveTo(targetPosition) end

        if onStepCallback then onStepCallback() end
        RunService.RenderStepped:Wait()
    end
end

-- ==============================================================================
-- 🔄 5. MASTER BOT LOOP
-- ==============================================================================
local function runBotLoop()
    task.spawn(function()
        while isBotRunning do
            pcall(function()
                -- ค้นหาไข่ที่ดีที่สุด
                StatusText.Text = "📍 สถานะ: 🔍 กำลังค้นหาไข่ระดับสูงสุดในแมพ..."
                StatusText.TextColor3 = Color3.fromRGB(250, 204, 21)

                local target = findBestTargetEgg()

                if target and target.part and target.part.Parent then
                    local targetName = target.name
                    local targetScore = target.score

                    StatusText.Text = string.format("📍 กำลังวิ่งไปขโมย: [%s] (ความหายาก: ⭐%d)", targetName, targetScore)
                    StatusText.TextColor3 = Color3.fromRGB(96, 165, 250)

                    -- วิ่งไปหาเป้าหมาย
                    smoothMoveTo(target.part.Position, function()
                        -- Auto Bat Kill Aura ระหว่างวิ่ง
                        if AutoKillAura then
                            local bat = LocalPlayer.Backpack:FindFirstChild("Bat") or LocalPlayer.Character:FindFirstChild("Bat")
                            if bat and bat.Parent == LocalPlayer.Backpack then
                                LocalPlayer.Character.Humanoid:EquipTool(bat)
                            end
                            if bat and bat:FindFirstChild("Handle") then
                                for _, p in pairs(Players:GetPlayers()) do
                                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                                        if (p.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 15 then
                                            firetouchinterest(bat.Handle, p.Character.HumanoidRootPart, 0)
                                            task.wait(0.02)
                                            firetouchinterest(bat.Handle, p.Character.HumanoidRootPart, 1)
                                        end
                                    end
                                end
                            end
                        end
                        -- Auto Collect Cash ระหว่างทาง
                        if AutoCollectCash then
                            for _, c in pairs(workspace:GetDescendants()) do
                                if c:IsA("BasePart") and (c.Name:lower():find("cash") or c.Name:lower():find("coin")) then
                                    if (c.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 12 then
                                        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, c, 0)
                                        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, c, 1)
                                    end
                                end
                            end
                        end
                    end)

                    -- แตะเพื่อขโมย
                    if target.part and target.part.Parent and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, target.part, 0)
                        task.wait(0.1)
                        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, target.part, 1)
                        
                        StatusText.Text = string.format("✅ ขโมย [%s] สำเร็จแล้ว!", targetName)
                        StatusText.TextColor3 = Color3.fromRGB(52, 211, 153)
                        task.wait(0.3)

                        -- วิ่งกลับบ้าน
                        if AutoReturnBase then
                            local basePos = getBaseLocation()
                            StatusText.Text = "🏠 กำลังวิ่งนำไข่กลับมาเก็บที่บ้าน..."
                            StatusText.TextColor3 = Color3.fromRGB(168, 85, 247)
                            smoothMoveTo(basePos)
                            task.wait(0.5)
                        end
                    end
                else
                    StatusText.Text = "⏳ ยังไม่พบไข่ที่ตรงเงื่อนไข กำลังรอไข่เกิดใหม่..."
                    StatusText.TextColor3 = Color3.fromRGB(156, 163, 175)
                    task.wait(1.5)
                end
            end)
            task.wait(0.5)
        end
    end)
end

-- สลับเปิด/ปิด Master Button
MasterBtn.MouseButton1Click:Connect(function()
    isBotRunning = not isBotRunning
    if isBotRunning then
        MasterBtn.Text = "⏹️ หยุดระบบบอท (STOP BOT)"
        MasterBtn.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
        runBotLoop()
    else
        MasterBtn.Text = "▶️ เริ่มระบบวิ่งขโมยไข่อัตโนมัติ (START BOT)"
        MasterBtn.BackgroundColor3 = Color3.fromRGB(16, 185, 129)
        StatusText.Text = "📍 สถานะ: ⏸️ บอทหยุดทำงานเรียบร้อย"
        StatusText.TextColor3 = Color3.fromRGB(148, 163, 184)
    end
end)

print("⚡ [EasyEggHub] โหลดสำเร็จ! กดปุ่มไอคอนสายฟ้าสีเหลือง ⚡ เพื่อเปิดเมนูบอท")
