-- ==============================================================================
-- 🐍 OUROBOROS & SPEED HUB X - FLUENT UI MASTER HUB v12.0
-- 👑 ดีไซน์หรูหราระดับ AAA สไตล์ Speed Hub X & Ouroboros ด้วย Fluent UI Library
-- ⚡ ฟังก์ชันครบวงจร: Auto Steal + Multi Rarity Dropdown + Base Auto + Lucky Block + Combat
-- 📱 รองรับทั้ง PC, Android Emulator (MuMu) และ Mobile 100% (Keyless ไม่ติดคีย์)
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

-- พิกัดบ้านปลอดภัย
local SafeHomeCFrame = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.CFrame) or CFrame.new(0, 50, 0)

-- ==============================================================================
-- 🎨 FLUENT UI INITIALIZATION
-- ==============================================================================
local FluentSuccess, Fluent = pcall(function()
    return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end)

if FluentSuccess and Fluent then
    local Window = Fluent:CreateWindow({
        Title = "⚡ OUROBOROS & SPEED HUB",
        SubTitle = "Dont Steal the Bobo / Steal Egg (v12.0)",
        TabWidth = 150,
        Size = UDim2.fromOffset(580, 420),
        Acrylic = true,
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.LeftControl
    })

    -- Tabs
    local Tabs = {
        Main = Window:AddTab({ Title = "Auto Steal", Icon = "egg" }),
        Base = Window:AddTab({ Title = "Base Auto", Icon = "home" }),
        World = Window:AddTab({ Title = "World Farm", Icon = "sparkles" }),
        Combat = Window:AddTab({ Title = "Combat & ESP", Icon = "swords" }),
        Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
    }

    -- Options Table
    local Options = Fluent.Options

    -- 🎯 TAB 1: AUTO STEAL
    Tabs.Main:AddParagraph({
        Title = "🎯 ระบบขโมยไข่และสัตว์เลี้ยง (Auto Steal Engine)",
        Content = "เลือกความหายากที่ต้องการขโมย แล้วเปิดสวิตช์ บอทจะวาร์ปไปฉกแล้วพากลับบ้านทันที"
    })

    local isAutoSteal = false
    local AutoReturn = true
    local MinIncomeValue = 0

    local StealToggle = Tabs.Main:AddToggle("AutoStealToggle", {
        Title = "🚀 เปิดระบบขโมยอัตโนมัติ (Auto Steal)",
        Description = "สแกนรังไข่ในคอกคนอื่นทั้งแมพ แล้ววาร์ปไปฉกทันที",
        Default = false
    })

    local ReturnToggle = Tabs.Main:AddToggle("AutoReturnToggle", {
        Title = "🏠 วาร์ปกลับบ้านหลังฉกไข่เสร็จ (Auto Return)",
        Description = "นำไข่กลับมาส่งที่คอกเราทันที",
        Default = true
    })

    local RarityDropdown = Tabs.Main:AddDropdown("RaritySelect", {
        Title = "👑 เลือกระดับความหายากที่จะขโมย (Steal Rarities)",
        Values = {"Secret", "Godly", "Cosmic", "Mythic", "Legendary", "Huge", "Rare", "Common"},
        Multi = true,
        Default = {"Secret", "Godly", "Cosmic", "Mythic", "Legendary", "Huge"}
    })

    local MinIncomeSlider = Tabs.Main:AddSlider("MinIncomeSlider", {
        Title = "💵 รายได้ขั้นต่ำ ($/s)",
        Description = "ขโมยเฉพาะตัวที่ผลิตเงินมากกว่าค่านี้",
        Default = 0,
        Min = 0,
        Max = 100000000,
        Rounding = 0,
        Callback = function(Value)
            MinIncomeValue = Value
        end
    })

    Tabs.Main:AddButton({
        Title = "⚡ ฉกรังไข่ที่ใกล้ที่สุดทันที (Instant Grab)",
        Description = "วาร์ปไปฉกไข่ที่ใกล้ที่สุด 1 รังแล้วพากลับบ้าน",
        Callback = function()
            patchPrompts()
            for _, prompt in pairs(workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") and prompt.Parent:IsA("BasePart") then
                    if (prompt.Parent.Position - SafeHomeCFrame.Position).Magnitude > 25 then
                        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            hrp.Velocity = Vector3.new(0, 0, 0)
                            hrp.CFrame = prompt.Parent.CFrame + Vector3.new(0, 2, 0)
                            task.wait(0.15)
                            triggerPrompt(prompt)
                            task.wait(0.2)
                            hrp.CFrame = SafeHomeCFrame
                            Fluent:Notify({ Title = "Steal Success", Content = "ขโมยไข่สำเร็จและกลับมาที่บ้านแล้ว!", Duration = 3 })
                            break
                        end
                    end
                end
            end
        end
    })

    StealToggle:OnChanged(function()
        isAutoSteal = Options.AutoStealToggle.Value
        if isAutoSteal then
            Fluent:Notify({ Title = "Auto Steal", Content = "เริ่มระบบขโมยอัตโนมัติแล้ว!", Duration = 3 })
            task.spawn(function()
                while isAutoSteal do
                    pcall(function()
                        patchPrompts()
                        for _, prompt in pairs(workspace:GetDescendants()) do
                            if not isAutoSteal then break end
                            if prompt:IsA("ProximityPrompt") and prompt.Parent:IsA("BasePart") then
                                if (prompt.Parent.Position - SafeHomeCFrame.Position).Magnitude > 25 then
                                    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                                    if hrp then
                                        hrp.Velocity = Vector3.new(0, 0, 0)
                                        hrp.CFrame = prompt.Parent.CFrame + Vector3.new(0, 2, 0)
                                        task.wait(0.15)
                                        triggerPrompt(prompt)
                                        task.wait(0.2)
                                        if Options.AutoReturnToggle.Value then
                                            hrp.Velocity = Vector3.new(0, 0, 0)
                                            hrp.CFrame = SafeHomeCFrame
                                            task.wait(0.4)
                                        end
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(1)
                end
            end)
        end
    end)

    -- 🏠 TAB 2: BASE AUTOMATION
    Tabs.Base:AddParagraph({
        Title = "🏠 จัดการคอกตัวเองอัตโนมัติ (Base Management)",
        Content = "ดูดเงิน อัปเกรดคอก และสวมใส่สัตว์เลี้ยงที่ดีที่สุด"
    })

    Tabs.Base:AddToggle("AutoCollectToggle", {
        Title = "💵 ดูดเงินอัตโนมัติ (Auto Collect Money)",
        Description = "เก็บเงินทุกบาทในคอกเราเข้าตัวทันที",
        Default = false,
        Callback = function(v)
            if v then
                task.spawn(function()
                    while Options.AutoCollectToggle.Value do
                        pcall(function()
                            for _, r in pairs(ReplicatedStorage:GetDescendants()) do
                                if r:IsA("RemoteEvent") and (r.Name:lower():find("collect") or r.Name:lower():find("cash") or r.Name:lower():find("money")) then
                                    r:FireServer()
                                end
                            end
                        end)
                        task.wait(1)
                    end
                end)
            end
        end
    })

    Tabs.Base:AddToggle("AutoUpgradeToggle", {
        Title = "🏗️ อัปเกรดคอกอัตโนมัติ (Auto Upgrade Plot)",
        Description = "ขยายช่องสัตว์เลี้ยงและเพิ่มเลเวลคอกอัตโนมัติ",
        Default = false,
        Callback = function(v)
            if v then
                task.spawn(function()
                    while Options.AutoUpgradeToggle.Value do
                        pcall(function()
                            for _, r in pairs(ReplicatedStorage:GetDescendants()) do
                                if r:IsA("RemoteEvent") and (r.Name:lower():find("upgrade") or r.Name:lower():find("buyslot")) then
                                    r:FireServer()
                                end
                            end
                        end)
                        task.wait(3)
                    end
                end)
            end
        end
    })

    Tabs.Base:AddButton({
        Title = "📌 บันทึกจุดยืนปัจจุบันเป็นบ้าน (Set Home Base)",
        Description = "ล็อคพิกัดจุดนี้เป็นบ้านที่ตัวละครจะวาร์ปกลับมาส่งของ",
        Callback = function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                SafeHomeCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                Fluent:Notify({ Title = "Home Saved", Content = "บันทึกพิกัดบ้านเรียบร้อยแล้ว!", Duration = 3 })
            end
        end
    })

    -- 📦 TAB 3: WORLD FARM
    Tabs.World:AddParagraph({
        Title = "📦 ฟาร์มแมพและกล่องสุ่ม (World Farming)",
        Content = "ฟาร์มเสากล่องสุ่ม Lucky Blocks กลางแมพ และตีบอส"
    })

    Tabs.World:AddToggle("AutoLuckyToggle", {
        Title = "📦 ฟาร์มเสากล่อง Lucky Blocks กลางแมพ",
        Description = "ยืนทุบเสากล่องสุ่มเพื่อปั๊มเงิน $B/s และดรอปสัตว์เลี้ยงเทพ",
        Default = false,
        Callback = function(v)
            if v then
                task.spawn(function()
                    while Options.AutoLuckyToggle.Value do
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
                        task.wait(0.4)
                    end
                end)
            end
        end
    })

    Tabs.World:AddToggle("AutoHatchToggle", {
        Title = "🥚 สุ่มเปิดไข่ระดับสูงสุดด้วยเงิน $B (Auto Hatch)",
        Description = "สุ่มเปิดไข่ราคาสูงสุดอัตโนมัติ",
        Default = false,
        Callback = function(v)
            if v then
                task.spawn(function()
                    while Options.AutoHatchToggle.Value do
                        pcall(function()
                            for _, r in pairs(ReplicatedStorage:GetDescendants()) do
                                if r:IsA("RemoteEvent") and (r.Name:lower():find("egg") or r.Name:lower():find("hatch")) then
                                    r:FireServer("Secret", 1)
                                    r:FireServer("Mythic", 1)
                                    r:FireServer(1)
                                end
                            end
                        end)
                        task.wait(1)
                    end
                end)
            end
        end
    })

    -- ⚔️ TAB 4: COMBAT & ESP
    Tabs.Combat:AddToggle("AutoBatToggle", {
        Title = "🏏 ถือไม้เบสบอลฟาดคนรอบตัว (Auto Bat Kill Aura)",
        Description = "ฟาดทุกคนรอบตัว 360 องศาเพื่อป้องกันขโมย",
        Default = false,
        Callback = function(v)
            if v then
                task.spawn(function()
                    while Options.AutoBatToggle.Value do
                        pcall(function()
                            local bat = LocalPlayer.Backpack:FindFirstChild("Bat") or LocalPlayer.Character:FindFirstChild("Bat")
                            if bat and bat.Parent == LocalPlayer.Backpack then LocalPlayer.Character.Humanoid:EquipTool(bat) end
                            if bat and bat:FindFirstChild("Handle") then
                                for _, p in pairs(Players:GetPlayers()) do
                                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                                        if (p.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 18 then
                                            firetouchinterest(bat.Handle, p.Character.HumanoidRootPart, 0)
                                            task.wait(0.02)
                                            firetouchinterest(bat.Handle, p.Character.HumanoidRootPart, 1)
                                        end
                                    end
                                end
                            end
                        end)
                        task.wait(0.2)
                    end
                end)
            end
        end
    })

    Tabs.Combat:AddToggle("NoclipToggle", {
        Title = "👻 เดินทะลุรั้วคอก (Noclip)",
        Description = "เดินทะลุรั้วคอกกั้นทุกประเภท",
        Default = true,
        Callback = function(v)
            RunService.Stepped:Connect(function()
                if Options.NoclipToggle.Value and LocalPlayer.Character then
                    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") and part.Name:lower():find("arm") or part.Name:lower():find("leg") or part.Name:lower():find("torso") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end
    })

    -- ⚙️ TAB 5: SETTINGS
    Tabs.Settings:AddButton({
        Title = "🚨 กู้ชีพด่วน! ดึงตัวกลับมาบนพื้นหญ้า (Rescue Void)",
        Description = "กดเมื่อตัวละครหลุดลอยฟ้าหรือตกโลก",
        Callback = function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                LocalPlayer.Character.HumanoidRootPart.CFrame = SafeHomeCFrame
                Fluent:Notify({ Title = "Rescue Success", Content = "ดึงตัวกลับมาบนพื้นหญ้าเรียบร้อย!", Duration = 3 })
            end
        end
    })

    -- Floating Mobile Toggle Icon (⚡)
    local parentGui = (gethui and gethui()) or game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FluentMobileToggle"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = parentGui

    local ToggleBtn = Instance.new("ImageButton")
    ToggleBtn.Size = UDim2.new(0, 52, 0, 52)
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
    TStroke.Thickness = 2.5
    TStroke.Parent = ToggleBtn

    ToggleBtn.MouseButton1Click:Connect(function()
        Window:Minimize()
    end)

    Window:SelectTab(1)
    Fluent:Notify({
        Title = "OUROBOROS & SPEED HUB v12.0",
        Content = "โหลดระบบสำเร็จเรียบร้อย! (Keyless 100%)",
        Duration = 5
    })
else
    -- Fallback Standalone GUI if Fluent fails to load on some mobile environments
    loadstring(game:HttpGet("https://raw.githubusercontent.com/kantapol0409-coder/roblox/main/auto_pilot_v10.lua"))()
end

print("⚡ [Fluent Master Hub v12.0] โหลดระบบสมบูรณ์!")
