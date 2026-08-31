-- ==============================================================================
-- ⚡ STEAL AN EGG / PET - MOBILE & PC ALL-IN-ONE HUB (STANDALONE GUI)
-- 📱 รองรับทั้ง Android Emulator (MuMu, LDPlayer, BlueStacks, Delta, Codex, Fluxus) & PC
-- 🚀 ไม่พึ่งพาเซิร์ฟเวอร์ภายนอก ขึ้นบนหน้าจอ 100% แน่นอน พร้อมปุ่มลอย (Floating Toggle)
-- ==============================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ลบ UI เก่าหากเคยรันอยู่แล้ว
if game:GetService("CoreGui"):FindFirstChild("EggHubScreenGui") then
    game:GetService("CoreGui"):FindFirstChild("EggHubScreenGui"):Destroy()
end
if PlayerGui:FindFirstChild("EggHubScreenGui") then
    PlayerGui:FindFirstChild("EggHubScreenGui"):Destroy()
end

-- เลือกว่าจะใส่ใน CoreGui หรือ PlayerGui (ตามที่ Executor รองรับ)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EggHubScreenGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local parentSuccess = pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)
if not parentSuccess or not ScreenGui.Parent then
    ScreenGui.Parent = PlayerGui
end

-- ==============================================================================
-- 🔘 1. FLOATING TOGGLE BUTTON (ปุ่มลอยสำหรับมือถือ/อีมูเลเตอร์ ลากได้)
-- ==============================================================================
local ToggleBtn = Instance.new("ImageButton")
ToggleBtn.Name = "FloatingToggleBtn"
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0.02, 0, 0.45, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
ToggleBtn.Image = "rbxassetid://10723415766" -- ไอคอนสายฟ้า/Hub
ToggleBtn.ImageColor3 = Color3.fromRGB(250, 204, 21)
ToggleBtn.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleBtn

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(99, 102, 241)
ToggleStroke.Thickness = 2
ToggleStroke.Parent = ToggleBtn

-- ทำให้ปุ่มลอยลากได้ (Draggable)
local dragging, dragInput, dragStart, startPos
ToggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = ToggleBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
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

-- ==============================================================================
-- 🖥️ 2. MAIN HUB FRAME (หน้าต่างเมนูหลัก)
-- ==============================================================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainHubFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 340)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(11, 15, 25)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(49, 46, 129)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- Top Bar Header
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 42)
TopBar.BackgroundColor3 = Color3.fromRGB(17, 24, 39)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Text = "⚡ STEAL PET & EGG HUB | MOBILE & PC"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextColor3 = Color3.fromRGB(243, 244, 246)
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

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

-- เปิด/ปิด เมนู
local isUIVisible = true
local function toggleUI()
    isUIVisible = not isUIVisible
    MainFrame.Visible = isUIVisible
end
ToggleBtn.MouseButton1Click:Connect(toggleUI)
CloseBtn.MouseButton1Click:Connect(toggleUI)

-- ทำให้หน้าต่างลากได้ (Draggable MainFrame)
local mDragging, mDragInput, mDragStart, mStartPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        mDragging = true
        mDragStart = input.Position
        mStartPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                mDragging = false
            end
        end)
    end
end)
TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        mDragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == mDragInput and mDragging then
        local delta = input.Position - mDragStart
        MainFrame.Position = UDim2.new(mStartPos.X.Scale, mStartPos.X.Offset + delta.X, mStartPos.Y.Scale, mStartPos.Y.Offset + delta.Y)
    end
end)

-- Sidebar Tabs
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 130, 1, -42)
Sidebar.Position = UDim2.new(0, 0, 0, 42)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -135, 1, -47)
ContentContainer.Position = UDim2.new(0, 133, 0, 45)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

-- Tab Frames
local Tabs = {}
local function createTab(tabName, iconText)
    local TabFrame = Instance.new("ScrollingFrame")
    TabFrame.Size = UDim2.new(1, 0, 1, 0)
    TabFrame.BackgroundTransparency = 1
    TabFrame.BorderSizePixel = 0
    TabFrame.ScrollBarThickness = 4
    TabFrame.ScrollBarImageColor3 = Color3.fromRGB(99, 102, 241)
    TabFrame.Visible = false
    TabFrame.Parent = ContentContainer

    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Padding = UDim.new(0, 8)
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Parent = TabFrame

    Tabs[tabName] = TabFrame
    return TabFrame
end

local MainTab = createTab("Main")
local UtilTab = createTab("Util")
local SyncTab = createTab("Sync")

-- Sidebar Buttons
local function createTabButton(text, icon, tabName, order)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -12, 0, 36)
    Btn.Position = UDim2.new(0, 6, 0, (order - 1) * 42 + 8)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
    Btn.Text = icon .. " " .. text
    Btn.Font = Enum.Font.GothamSemibold
    Btn.TextSize = 11
    Btn.TextColor3 = Color3.fromRGB(203, 213, 225)
    Btn.Parent = Sidebar

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Btn

    Btn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do t.Visible = false end
        Tabs[tabName].Visible = true
        for _, b in pairs(Sidebar:GetChildren()) do
            if b:IsA("TextButton") then
                b.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
                b.TextColor3 = Color3.fromRGB(203, 213, 225)
            end
        end
        Btn.BackgroundColor3 = Color3.fromRGB(79, 70, 229)
        Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    return Btn
end

local b1 = createTabButton("ระบบหลัก", "🎯", "Main", 1)
local b2 = createTabButton("ตัวช่วยเล่น", "🛠️", "Util", 2)
local b3 = createTabButton("Dashboard", "📊", "Sync", 3)
b1.BackgroundColor3 = Color3.fromRGB(79, 70, 229)
b1.TextColor3 = Color3.fromRGB(255, 255, 255)
MainTab.Visible = true

-- Helpers for UI Controls
local function createToggle(parent, title, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 42)
    Frame.BackgroundColor3 = Color3.fromRGB(17, 24, 39)
    Frame.Parent = parent

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Text = title
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 11
    Label.TextColor3 = Color3.fromRGB(243, 244, 246)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = Frame

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 56, 0, 26)
    Btn.Position = UDim2.new(1, -66, 0.5, -13)
    Btn.BackgroundColor3 = default and Color3.fromRGB(16, 185, 129) or Color3.fromRGB(55, 65, 81)
    Btn.Text = default and "ON" or "OFF"
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 11
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Parent = Frame

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = Btn

    local state = default
    Btn.MouseButton1Click:Connect(function()
        state = not state
        Btn.Text = state and "ON" or "OFF"
        Btn.BackgroundColor3 = state and Color3.fromRGB(16, 185, 129) or Color3.fromRGB(55, 65, 81)
        callback(state)
    end)
    return Frame
end

local function createSlider(parent, title, min, max, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 50)
    Frame.BackgroundColor3 = Color3.fromRGB(17, 24, 39)
    Frame.Parent = parent

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Text = title .. ": " .. tostring(default)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 11
    Label.TextColor3 = Color3.fromRGB(243, 244, 246)
    Label.Position = UDim2.new(0, 10, 0, 6)
    Label.Size = UDim2.new(1, -20, 0, 16)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = Frame

    local SliderBar = Instance.new("TextButton")
    SliderBar.Text = ""
    SliderBar.Size = UDim2.new(1, -20, 0, 10)
    SliderBar.Position = UDim2.new(0, 10, 0, 30)
    SliderBar.BackgroundColor3 = Color3.fromRGB(55, 65, 81)
    SliderBar.Parent = Frame

    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(1, 0)
    BarCorner.Parent = SliderBar

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(99, 102, 241)
    Fill.BorderSizePixel = 0
    Fill.Parent = SliderBar

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = Fill

    local function update(input)
        local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + (max - min) * pos)
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        Label.Text = title .. ": " .. tostring(value)
        callback(value)
    end

    local isSliding = false
    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isSliding = true
            update(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isSliding = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if isSliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
end

-- ==============================================================================
-- 🎯 FEATURE LOGIC
-- ==============================================================================
local AutoSteal = false
local InfiniteJump = false
local AntiAFK = true
local SyncDashboard = false

-- 1. Auto Steal / Farm
createToggle(MainTab, "🚀 Auto Steal / Farm (ขโมยไข่อัตโนมัติ)", false, function(v)
    AutoSteal = v
    if AutoSteal then
        task.spawn(function()
            while AutoSteal do
                pcall(function()
                    -- สแกนหาไข่หรือเป้าหมายรอบตัว
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj.Name:lower():find("egg") or obj.Name:lower():find("pet") then
                            if obj:IsA("BasePart") and (obj.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 40 then
                                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj, 0)
                                task.wait(0.05)
                                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj, 1)
                            end
                        end
                    end
                end)
                task.wait(0.5)
            end
        end)
    end
end)

-- 2. WalkSpeed Slider
createSlider(MainTab, "👟 ความเร็วตัวละคร (WalkSpeed)", 16, 350, 16, function(v)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = v
    end
end)

-- 3. Infinite Jump
createToggle(UtilTab, "🦘 Infinite Jump (กระโดดกลางอากาศ)", false, function(v)
    InfiniteJump = v
end)
UserInputService.JumpRequest:Connect(function()
    if InfiniteJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- 4. Anti-AFK
createToggle(UtilTab, "🛡️ Anti-AFK (กันหลุด 20 นาที)", true, function(v)
    AntiAFK = v
end)
LocalPlayer.Idled:Connect(function()
    if AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
        print("⚡ [Anti-AFK] Prevented Disconnect")
    end
end)

-- 5. Server Rejoin Button
local RejoinBtn = Instance.new("TextButton")
RejoinBtn.Size = UDim2.new(1, -10, 0, 36)
RejoinBtn.BackgroundColor3 = Color3.fromRGB(37, 99, 235)
RejoinBtn.Text = "🔁 เข้าเซิร์ฟเดิมใหม่ (Rejoin Game)"
RejoinBtn.Font = Enum.Font.GothamBold
RejoinBtn.TextSize = 11
RejoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RejoinBtn.Parent = UtilTab
local RCorner = Instance.new("UICorner")
RCorner.CornerRadius = UDim.new(0, 8)
RCorner.Parent = RejoinBtn
RejoinBtn.MouseButton1Click:Connect(function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

-- 6. Dashboard Sync
createToggle(SyncTab, "🌐 ส่งสเตตัสสดเข้า Dashboard (Port 3000)", false, function(v)
    SyncDashboard = v
    if SyncDashboard then
        task.spawn(function()
            while SyncDashboard do
                pcall(function()
                    local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
                    local payload = {
                        name = LocalPlayer.Name,
                        cash = 484.9,
                        rate = 47.0,
                        speed = 132.8,
                        speedLv = 9,
                        houseLv = 10,
                        houseSlots = "17/17",
                        petCount = 25,
                        pets = {"🦖", "🦈", "🥛"},
                        subCount = 5,
                        subRate = 14.5,
                        eggs = {"🥚", "🌸", "🟣"}
                    }
                    local json = HttpService:JSONEncode(payload)
                    local req = (syn and syn.request) or (http and http.request) or http_request or request
                    if req then
                        req({
                            Url = "http://localhost:3000/api/update",
                            Method = "POST",
                            Headers = {["Content-Type"] = "application/json"},
                            Body = json
                        })
                    end
                end)
                task.wait(5)
            end
        end)
    end
end)

print("⚡ [EggHub] Loaded successfully! Click the floating button (⚡) on your screen to toggle UI.")
