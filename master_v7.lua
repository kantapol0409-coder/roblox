-- ==============================================================================
-- ⚡ STEAL AN EGG & PET - MASTER SAFE STEALER & AUTO FARM v7.0
-- 🛡️ แก้ไขปัญหาตกโลก 100% (จำพิกัดบ้านอัตโนมัติ + ล็อคพิกัดปลอดภัย)
-- 🎁 รวมฟังก์ชัน: ฟาร์มเสากล่องสุ่มกลางแมพ + เปิดไข่ตัวท็อป + ขโมยสัตว์เลี้ยงในคอก
-- 📱 หน้าต่างเมนูใช้งานง่าย พร้อมระบบ ESP ชี้เป้าสัตว์เลี้ยงทุกตัว
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

-- 🏠 บันทึกพิกัดบ้านปลอดภัย (จุดที่ผู้เล่นยืนตอนรันสคริปต์ ป้องกันตกโลก 100%)
local SafeHomeCFrame = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.CFrame) or CFrame.new(0, 50, 0)

-- 🎨 2. GUI Setup
local parentGui = (gethui and gethui()) or game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")
if parentGui:FindFirstChild("MasterStealHubV7") then parentGui:FindFirstChild("MasterStealHubV7"):Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MasterStealHubV7"
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
Title.Text = "⚡ STEAL EGG & PET | MASTER V7 (NO VOID FALL)"
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
StatusText.Text = "📍 สถานะ: 🟢 พร้อมใช้งาน (เลือกฟังก์ชันฟาร์มด้านล่าง)"
StatusText.Font = Enum.Font.GothamMedium
StatusText.TextSize = 10.5
StatusText.TextColor3 = Color3.fromRGB(52, 211, 153)
StatusText.Position = UDim2.new(0, 10, 0, 0)
StatusText.Size = UDim2.new(1, -20, 1, 0)
StatusText.TextXAlignment = Enum.TextXAlignment.Left
StatusText.BackgroundTransparency = 1
StatusText.Parent = StatusBox

-- ==============================================================================
-- 👑 3. TOP ACTION BUTTONS (ปุ่มฟาร์มหลัก)
-- ==============================================================================

-- 1. บันทึกจุดยืนเป็นบ้าน
local SaveHomeBtn = Instance.new("TextButton")
SaveHomeBtn.Size = UDim2.new(1, 0, 0, 38)
SaveHomeBtn.BackgroundColor3 = Color3.fromRGB(59, 130, 246)
SaveHomeBtn.Text = "📌 บันทึกจุดยืนปัจจุบันเป็นบ้าน (Set Home Base)"
SaveHomeBtn.Font = Enum.Font.GothamBold
SaveHomeBtn.TextSize = 11.5
SaveHomeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveHomeBtn.LayoutOrder = 2
SaveHomeBtn.Parent = ScrollContent
local SHCorner = Instance.new("UICorner")
SHCorner.CornerRadius = UDim.new(0, 8)
SHCorner.Parent = SaveHomeBtn

SaveHomeBtn.MouseButton1Click:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        SafeHomeCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
        StatusText.Text = "✅ บันทึกพิกัดบ้านเรียบร้อยแล้ว!"
        StatusText.TextColor3 = Color3.fromRGB(52, 211, 153)
    end
end)

-- 2. ฟาร์มกล่องสุ่มกลางแมพ (Lucky Block Tower)
local isLuckyFarming = false
local LuckyBtn = Instance.new("TextButton")
LuckyBtn.Size = UDim2.new(1, 0, 0, 44)
LuckyBtn.BackgroundColor3 = Color3.fromRGB(234, 88, 12)
LuckyBtn.Text = "📦 ฟาร์มเสากล่อง Lucky Blocks กลางแมพ (ได้ไข่ & เงินมหาศาล)"
LuckyBtn.Font = Enum.Font.GothamBold
LuckyBtn.TextSize = 11.5
LuckyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LuckyBtn.LayoutOrder = 3
LuckyBtn.Parent = ScrollContent
local LCorner = Instance.new("UICorner")
LCorner.CornerRadius = UDim.new(0, 8)
LCorner.Parent = LuckyBtn

-- 3. เปิดไข่ระดับสูงสุดอัตโนมัติ (Auto Hatch Best Eggs)
local isHatching = false
local HatchBtn = Instance.new("TextButton")
HatchBtn.Size = UDim2.new(1, 0, 0, 44)
HatchBtn.BackgroundColor3 = Color3.fromRGB(147, 51, 234)
HatchBtn.Text = "🥚 สุ่มเปิดไข่ระดับสูงสุดด้วยเงิน $558B (Auto Hatch Best)"
HatchBtn.Font = Enum.Font.GothamBold
HatchBtn.TextSize = 11.5
HatchBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HatchBtn.LayoutOrder = 4
HatchBtn.Parent = ScrollContent
local HCorner = Instance.new("UICorner")
HCorner.CornerRadius = UDim.new(0, 8)
HCorner.Parent = HatchBtn

-- ==============================================================================
-- 👁️ 4. ESP & VISUAL TARGET SCANNER (มองทะลุสัตว์เลี้ยงในคอก)
-- ==============================================================================
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "MasterESPFolder"
ESPFolder.Parent = ScreenGui

local function clearESP()
    ESPFolder:ClearAllChildren()
end

local function runESP()
    clearESP()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and not obj:IsDescendantOf(LocalPlayer.Character) then
            local primary = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
            local n = obj.Name:lower()
            if primary and (n:find("chilli") or n:find("dragon") or n:find("cerberus") or n:find("godzilla") or n:find("milk") or n:find("pet") or n:find("egg")) then
                local bb = Instance.new("BillboardGui")
                bb.Size = UDim2.new(0, 100, 0, 30)
                bb.AlwaysOnTop = true
                bb.Adornee = primary
                bb.Parent = ESPFolder
                local lbl = Instance.new("TextLabel")
                lbl.Size = UDim2.new(1, 0, 1, 0)
                lbl.Text = "⭐ " .. obj.Name
                lbl.Font = Enum.Font.GothamBold
                lbl.TextSize = 10
                lbl.TextColor3 = Color3.fromRGB(250, 204, 21)
                lbl.BackgroundTransparency = 1
                lbl.Parent = bb
            end
        end
    end
end

-- ==============================================================================
-- ⚙️ 5. TOGGLES & HELPERS
-- ==============================================================================
local function createSimpleToggle(title, desc, default, callback)
    local F = Instance.new("Frame")
    F.Size = UDim2.new(1, 0, 0, 42)
    F.BackgroundColor3 = Color3.fromRGB(17, 24, 39)
    F.LayoutOrder = 5
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

local AutoNoclip = true
local AutoKillAura = true
local AutoESP = true

createSimpleToggle("👻 เดินทะลุรั้ว (Noclip)", "เดินทะลุรั้วคอกกั้นทุกคอก", true, function(v)
    AutoNoclip = v
end)

createSimpleToggle("🏏 ป้องกันตัว (Auto Bat Aura)", "ถือไม้เบสบอลฟาดคนรอบตัว", true, function(v)
    AutoKillAura = v
end)

createSimpleToggle("👁️ แสดงชื่อสัตว์เลี้ยงในคอก (ESP)", "มองทะลุเห็นสัตว์เลี้ยงทุกตัวในแมพ", true, function(v)
    AutoESP = v
    if AutoESP then runESP() else clearESP() end
end)

RunService.Stepped:Connect(function()
    if AutoNoclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- ==============================================================================
-- 🚀 6. ACTION EXECUTIONS
-- ==============================================================================

-- ฟังก์ชันฟาร์มกล่อง Lucky Blocks กลางแมพ
LuckyBtn.MouseButton1Click:Connect(function()
    isLuckyFarming = not isLuckyFarming
    if isLuckyFarming then
        LuckyBtn.Text = "⏹️ หยุดฟาร์ม Lucky Blocks"
        LuckyBtn.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
        StatusText.Text = "📦 กำลังฟาร์มเสากล่อง Lucky Blocks กลางแมพ..."
        StatusText.TextColor3 = Color3.fromRGB(250, 204, 21)

        task.spawn(function()
            while isLuckyFarming do
                pcall(function()
                    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        -- ถือไม้เบสบอล
                        local bat = LocalPlayer.Backpack:FindFirstChild("Bat") or LocalPlayer.Character:FindFirstChild("Bat")
                        if bat and bat.Parent == LocalPlayer.Backpack then LocalPlayer.Character.Humanoid:EquipTool(bat) end

                        -- ค้นหากล่องสุ่ม
                        for _, obj in pairs(workspace:GetDescendants()) do
                            if obj:IsA("BasePart") and (obj.Name:lower():find("lucky") or obj.Name:lower():find("block")) then
                                hrp.CFrame = obj.CFrame + Vector3.new(0, 3, 0)
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
        LuckyBtn.Text = "📦 ฟาร์มเสากล่อง Lucky Blocks กลางแมพ (ได้ไข่ & เงินมหาศาล)"
        LuckyBtn.BackgroundColor3 = Color3.fromRGB(234, 88, 12)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = SafeHomeCFrame
        end
        StatusText.Text = "📍 สถานะ: ⏸️ หยุดฟาร์มและกลับมาที่บ้านแล้ว"
        StatusText.TextColor3 = Color3.fromRGB(148, 163, 184)
    end
end)

-- ฟังก์ชันเปิดไข่อัตโนมัติ (Auto Hatch)
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
                        if r:IsA("RemoteFunction") or r:IsA("RemoteEvent") then
                            local n = r.Name:lower()
                            if n:find("buyegg") or n:find("hatchegg") or n:find("openegg") or n:find("egg") then
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
        HatchBtn.Text = "🥚 สุ่มเปิดไข่ระดับสูงสุดด้วยเงิน $558B (Auto Hatch Best)"
        HatchBtn.BackgroundColor3 = Color3.fromRGB(147, 51, 234)
        StatusText.Text = "📍 สถานะ: ⏸️ หยุดสุ่มไข่เรียบร้อย"
        StatusText.TextColor3 = Color3.fromRGB(148, 163, 184)
    end
end)

task.spawn(function()
    task.wait(1)
    if AutoESP then runESP() end
end)

print("⚡ [MasterStealHub v7.0] โหลดระบบสมบูรณ์ ป้องกันตกโลก 100%!")
