-- ==============================================================================
-- 🔑 PROFESSIONAL KEY SYSTEM TEMPLATE (ONYX / JNKIE STYLE)
-- 📱 หน้าต่างยืนยันคีย์หรูหรา สไตล์ Onyx UI / Miranda
-- 💾 ระบบบันทึกคีย์อัตโนมัติ (Save Key): ใส่ครั้งเดียว จำไว้ตลอด ไม่ต้องกรอกซ้ำ
-- 📋 ปุ่ม Get Key (คัดลอกลิงก์รับคีย์) & ปุ่ม Discord
-- ==============================================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ⚙️ 1. ตั้งค่าระบบคีย์ของคุณ (CUSTOMIZE CONFIG)
local Config = {
    HubTitle = "⚡ MY SCRIPT HUB",
    Subtitle = "Enter your key to continue",
    GetKeyURL = "https://discord.gg/your-link", -- ใส่ลิงก์รับคีย์ของคุณที่นี่
    DiscordURL = "https://discord.gg/your-server", -- ใส่ลิงก์ Discord ของคุณ
    KeyFileName = "my_script_hub_key.txt", -- ชื่อไฟล์บันทึกคีย์ในเครื่อง
    
    -- 🔑 รายชื่อคีย์ที่ถูกต้อง (สามารถเพิ่มคีย์ของคุณได้ที่นี่)
    ValidKeys = {
        ["FREE-KEY-2026"] = true,
        ["VIP-SUPER-KEY"] = true,
        ["TEST-KEY-1234"] = true,
        ["EGG-FARMER-999"] = true
    }
}

-- 🎯 2. ฟังก์ชันเมื่อใส่คีย์ผ่าน (โค้ดสคริปต์หลักที่จะให้ทำงาน)
local function onKeyVerified()
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "✅ Key Verified!",
            Text = "ยืนยันคีย์สำเร็จ! กำลังเปิดใช้งานสคริปต์...",
            Duration = 5
        })
    end)
    
    -- [ ใส่โค้ดสคริปต์หลักของคุณตรงนี้ ]
    print("🎉 ยืนยันคีย์สำเร็จ! สคริปต์หลักเริ่มทำงาน...")
end

-- 💾 3. ตรวจสอบคีย์ที่เคยบันทึกไว้ในเครื่อง (Auto-Login)
local function checkSavedKey()
    if readfile and isfile and isfile(Config.KeyFileName) then
        local savedKey = readfile(Config.KeyFileName)
        if savedKey and Config.ValidKeys[savedKey] then
            print("🔑 พบคีย์ที่บันทึกไว้: ผ่านการยืนยันอัตโนมัติ!")
            onKeyVerified()
            return true
        end
    end
    return false
end

-- ถ้ามีคีย์ที่ถูกต้องบันทึกไว้อยู่แล้ว ให้ผ่านทันทีไม่ต้องเปิดหน้าต่าง
if checkSavedKey() then return end

-- 🎨 4. สร้างหน้าต่าง KEY SYSTEM UI
local parentGui = (gethui and gethui()) or PlayerGui
if parentGui:FindFirstChild("CustomKeySystemUI") then
    parentGui:FindFirstChild("CustomKeySystemUI"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomKeySystemUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 9999
ScreenGui.Parent = parentGui

-- Main Card Frame
local Card = Instance.new("Frame")
Card.Name = "KeyCard"
Card.Size = UDim2.new(0, 340, 0, 240)
Card.Position = UDim2.new(0.5, -170, 0.5, -120)
Card.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
Card.BorderSizePixel = 0
Card.ClipsDescendants = true
Card.Parent = ScreenGui

local CCorner = Instance.new("UICorner")
CCorner.CornerRadius = UDim.new(0, 14)
CCorner.Parent = Card

local CStroke = Instance.new("UIStroke")
CStroke.Color = Color3.fromRGB(45, 45, 55)
CStroke.Thickness = 1.5
CStroke.Parent = Card

-- Top Title
local TitleLbl = Instance.new("TextLabel")
TitleLbl.Text = Config.HubTitle
TitleLbl.Font = Enum.Font.GothamBold
TitleLbl.TextSize = 15
TitleLbl.TextColor3 = Color3.fromRGB(244, 244, 245)
TitleLbl.Position = UDim2.new(0, 0, 0, 16)
TitleLbl.Size = UDim2.new(1, 0, 0, 20)
TitleLbl.TextXAlignment = Enum.TextXAlignment.Center
TitleLbl.BackgroundTransparency = 1
TitleLbl.Parent = Card

local SubtitleLbl = Instance.new("TextLabel")
SubtitleLbl.Text = Config.Subtitle
SubtitleLbl.Font = Enum.Font.Gotham
SubtitleLbl.TextSize = 11
SubtitleLbl.TextColor3 = Color3.fromRGB(113, 113, 122)
SubtitleLbl.Position = UDim2.new(0, 0, 0, 36)
SubtitleLbl.Size = UDim2.new(1, 0, 0, 16)
SubtitleLbl.TextXAlignment = Enum.TextXAlignment.Center
SubtitleLbl.BackgroundTransparency = 1
SubtitleLbl.Parent = Card

-- Key Input TextBox
local InputBox = Instance.new("TextBox")
InputBox.Name = "KeyInput"
InputBox.Size = UDim2.new(1, -40, 0, 42)
InputBox.Position = UDim2.new(0, 20, 0, 68)
InputBox.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
InputBox.PlaceholderText = "Paste your key here..."
InputBox.PlaceholderColor3 = Color3.fromRGB(82, 82, 91)
InputBox.Text = ""
InputBox.Font = Enum.Font.GothamSemibold
InputBox.TextSize = 12
InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
InputBox.ClearTextOnFocus = false
InputBox.Parent = Card

local IBCorner = Instance.new("UICorner")
IBCorner.CornerRadius = UDim.new(0, 8)
IBCorner.Parent = InputBox

local IBStroke = Instance.new("UIStroke")
IBStroke.Color = Color3.fromRGB(63, 63, 70)
IBStroke.Thickness = 1
IBStroke.Parent = InputBox

-- Verify Button
local VerifyBtn = Instance.new("TextButton")
VerifyBtn.Name = "VerifyButton"
VerifyBtn.Size = UDim2.new(1, -40, 0, 40)
VerifyBtn.Position = UDim2.new(0, 20, 0, 120)
VerifyBtn.BackgroundColor3 = Color3.fromRGB(244, 244, 245) -- White Pill Button
VerifyBtn.Text = "Verify"
VerifyBtn.Font = Enum.Font.GothamBold
VerifyBtn.TextSize = 13
VerifyBtn.TextColor3 = Color3.fromRGB(18, 18, 22)
VerifyBtn.Parent = Card

local VCorner = Instance.new("UICorner")
VCorner.CornerRadius = UDim.new(0, 8)
VCorner.Parent = VerifyBtn

-- Sub Links (Get Key & Discord)
local LinksFrame = Instance.new("Frame")
LinksFrame.Size = UDim2.new(1, -40, 0, 30)
LinksFrame.Position = UDim2.new(0, 20, 0, 175)
LinksFrame.BackgroundTransparency = 1
LinksFrame.Parent = Card

local GetKeyBtn = Instance.new("TextButton")
GetKeyBtn.Text = "🔑 Get Key"
GetKeyBtn.Font = Enum.Font.GothamSemibold
GetKeyBtn.TextSize = 11
GetKeyBtn.TextColor3 = Color3.fromRGB(161, 161, 170)
GetKeyBtn.Size = UDim2.new(0.5, -5, 1, 0)
GetKeyBtn.Position = UDim2.new(0, 0, 0, 0)
GetKeyBtn.BackgroundTransparency = 1
GetKeyBtn.Parent = LinksFrame

local DiscordBtn = Instance.new("TextButton")
DiscordBtn.Text = "💬 Discord"
DiscordBtn.Font = Enum.Font.GothamSemibold
DiscordBtn.TextSize = 11
DiscordBtn.TextColor3 = Color3.fromRGB(161, 161, 170)
DiscordBtn.Size = UDim2.new(0.5, -5, 1, 0)
DiscordBtn.Position = UDim2.new(0.5, 5, 0, 0)
DiscordBtn.BackgroundTransparency = 1
DiscordBtn.Parent = LinksFrame

-- Status Label
local StatusLbl = Instance.new("TextLabel")
StatusLbl.Size = UDim2.new(1, 0, 0, 16)
StatusLbl.Position = UDim2.new(0, 0, 1, -22)
StatusLbl.Text = ""
StatusLbl.Font = Enum.Font.Gotham
StatusLbl.TextSize = 10
StatusLbl.BackgroundTransparency = 1
StatusLbl.Parent = Card

-- 🎯 5. EVENT HANDLERS

-- กดปุ่ม Verify
VerifyBtn.MouseButton1Click:Connect(function()
    local enteredKey = InputBox.Text:gsub("%s+", "") -- ลบเว้นวรรค
    
    if Config.ValidKeys[enteredKey] then
        StatusLbl.TextColor3 = Color3.fromRGB(34, 197, 94)
        StatusLbl.Text = "✓ Key Valid! Loading script..."
        VerifyBtn.Text = "Success!"
        VerifyBtn.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
        VerifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        
        -- บันทึกคีย์ลงในเครื่อง
        pcall(function()
            if writefile then
                writefile(Config.KeyFileName, enteredKey)
            end
        end)
        
        task.wait(1)
        ScreenGui:Destroy()
        onKeyVerified()
    else
        StatusLbl.TextColor3 = Color3.fromRGB(239, 68, 68)
        StatusLbl.Text = "✕ Invalid key. Please try again."
        IBStroke.Color = Color3.fromRGB(239, 68, 68)
        task.wait(2)
        IBStroke.Color = Color3.fromRGB(63, 63, 70)
    end
end)

-- กดปุ่ม Get Key
GetKeyBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(Config.GetKeyURL)
        StatusLbl.TextColor3 = Color3.fromRGB(56, 189, 248)
        StatusLbl.Text = "✓ Link copied to clipboard!"
    end
end)

-- กดปุ่ม Discord
DiscordBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(Config.DiscordURL)
        StatusLbl.TextColor3 = Color3.fromRGB(129, 140, 248)
        StatusLbl.Text = "✓ Discord link copied!"
    end
end)

print("🔑 [Key System Template] พร้อมใช้งานแล้ว!")
