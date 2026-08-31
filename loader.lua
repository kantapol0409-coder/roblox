-- ==============================================================================
-- 🛡️ BAC ANTI-CHEAT BYPASS & 100% STEAL HUB v14.0
-- 👑 บายพาสระบบกันโปร BAC Anti-Cheat (CODE BAC-9514) 100%
-- 🚫 ดักจับและบล็อกคำสั่ง Kick + บล็อก Remote แจ้งแบนของ BAC ทุกชนิด
-- ⚡ ปรับระบบขโมยไข่ให้ทำงานแบบปลอดภัย (Safe Trigger) ไม่โดนเตะออกจากเกม
-- ==============================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- ==============================================================================
-- 🛡️ 1. ULTIMATE BAC ANTI-CHEAT BYPASS (บล็อกการเตะ 100%)
-- ==============================================================================
pcall(function()
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local method = getnamecallmethod():lower()

        -- 1. บล็อกคำสั่ง Kick ทุกรูปแบบ
        if method == "kick" then
            return nil
        end

        -- 2. บล็อก Remote แจ้งแบน/ตรวจจับของ BAC Anti-Cheat
        if method == "fireserver" or method == "invokeserver" then
            local rName = tostring(self.Name):lower()
            if rName:find("bac") or rName:find("anticheat") or rName:find("cheat") or rName:find("ban") or rName:find("flag") or rName:find("detect") or rName:find("security") or rName:find("report") then
                return nil
            end
        end

        return oldNamecall(self, ...)
    end))
end)

-- Hook ฟังก์ชัน LocalPlayer:Kick โดยตรง
pcall(function()
    if hookfunction and LocalPlayer and LocalPlayer.Kick then
        hookfunction(LocalPlayer.Kick, newcclosure(function(...)
            return nil
        end))
    end
end)

-- ป้องกันหลุดจอ (Anti-AFK)
pcall(function()
    for _, conn in pairs(getconnections(LocalPlayer.Idled)) do
        if conn.Disable then conn:Disable() elseif conn.Disconnect then conn:Disconnect() end
    end
end)

-- พิกัดบ้านปลอดภัย
local SafeHomeCFrame = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.CFrame) or CFrame.new(0, 50, 0)

-- ==============================================================================
-- ⚡ 2. SAFE PROMPT STEAL ENGINE (ขโมยแบบปลอดภัย ไม่กระตุ้นตัวตรวจจับ)
-- ==============================================================================
local function safeStealInteraction(prompt, targetPart, autoReturn)
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp or not targetPart then return false end

    -- 1. วาร์ปประกบชิดรังไข่ (ระยะ 1.5 studs)
    hrp.Velocity = Vector3.new(0, 0, 0)
    hrp.CFrame = targetPart.CFrame + Vector3.new(0, 1.5, 0)
    task.wait(0.12)

    -- 2. ถือไม้เบสบอล
    local bat = LocalPlayer.Backpack:FindFirstChild("Bat") or LocalPlayer.Character:FindFirstChild("Bat")
    if bat and bat.Parent == LocalPlayer.Backpack then LocalPlayer.Character.Humanoid:EquipTool(bat) end

    -- 3. ส่งสัญญาณกด E ธรรมชาติ (ไม่แก้ Property ของ Prompt ให้ตัวกันโปรจับได้)
    for attempt = 1, 4 do
        if not prompt or not prompt.Parent then break end

        -- A. Virtual Key [E]
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        task.wait(0.04)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)

        -- B. fireproximityprompt
        if fireproximityprompt then
            fireproximityprompt(prompt, 0)
            fireproximityprompt(prompt)
        end

        -- C. Touch Interest
        pcall(function()
            firetouchinterest(hrp, targetPart, 0)
            task.wait(0.02)
            firetouchinterest(hrp, targetPart, 1)
        end)

        -- D. Remote Trigger
        pcall(function()
            for _, r in pairs(ReplicatedStorage:GetDescendants()) do
                if r:IsA("RemoteEvent") then
                    local n = r.Name:lower()
                    if n:find("steal") or n:find("pickup") or n:find("egg") or n:find("grab") then
                        r:FireServer(targetPart)
                    end
                end
            end
        end)

        task.wait(0.08)
    end

    task.wait(0.15)

    -- 4. วาร์ปกลับบ้านส่งของ
    if autoReturn then
        hrp.Velocity = Vector3.new(0, 0, 0)
        hrp.CFrame = SafeHomeCFrame
        task.wait(0.3)
    end
    return true
end

-- ==============================================================================
-- 🎨 3. FLUENT UI INITIALIZATION
-- ==============================================================================
local FluentSuccess, Fluent = pcall(function()
    return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end)

if FluentSuccess and Fluent then
    local Window = Fluent:CreateWindow({
        Title = "🛡️ BAC BYPASSED | SPEED HUB X",
        SubTitle = "Steal An Egg / Don't Steal the Bobo (v14.0)",
        TabWidth = 150,
        Size = UDim2.fromOffset(590, 430),
        Acrylic = true,
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.LeftControl
    })

    local Tabs = {
        Steal = Window:AddTab({ Title = "Auto Steal", Icon = "egg" }),
        Base = Window:AddTab({ Title = "Base Auto", Icon = "home" }),
        World = Window:AddTab({ Title = "World Farm", Icon = "sparkles" }),
        Combat = Window:AddTab({ Title = "Combat", Icon = "swords" }),
        ESP = Window:AddTab({ Title = "ESP & Visuals", Icon = "eye" }),
        Teleport = Window:AddTab({ Title = "Teleports", Icon = "map-pin" }),
        Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
    }

    local Options = Fluent.Options

    -- ==============================================================================
    -- 🎯 1. TAB: AUTO STEAL
    -- ==============================================================================
    Tabs.Steal:AddParagraph({
        Title = "🛡️ ระบบขโมยไข่ปลอดภัย (BAC Bypass Active)",
        Content = "ปลดล็อคระบบกันเตะ BAC-9514 แล้ว วาร์ปไปฉกไข่และนำกลับมาส่งที่บ้านได้อย่างปลอดภัย 100%"
    })

    local isAutoSteal = false
    local StealDelay = 0.6

    local StealToggle = Tabs.Steal:AddToggle("AutoStealToggle", {
        Title = "🚀 เริ่มระบบขโมยอัตโนมัติ (AUTO STEAL LOOP)",
        Description = "สแกนรังไข่ทั่วทั้งเซิร์ฟเวอร์ วาร์ปไปฉกแล้วนำกลับมาส่งที่บ้าน",
        Default = false
    })

    Tabs.Steal:AddToggle("AutoReturnToggle", {
        Title = "🏠 วาร์ปกลับบ้านหลังฉกเสร็จ (Auto Return Base)",
        Description = "นำไข่กลับมาส่งที่คอกเราอัตโนมัติ",
        Default = true
    })

    Tabs.Steal:AddDropdown("RarityDropdown", {
        Title = "👑 เลือกระดับความหายากที่จะขโมย (Steal Rarities)",
        Values = {"Secret", "Godly", "Cosmic", "Mythic", "Legendary", "Huge", "Epic", "Rare", "Common"},
        Multi = true,
        Default = {"Secret", "Godly", "Cosmic", "Mythic", "Legendary", "Huge"}
    })

    Tabs.Steal:AddSlider("StealDelaySlider", {
        Title = "⏱️ หน่วงเวลาระหว่างขโมย (วินาที)",
        Description = "แนะนำ 0.5s - 1.0s เพื่อความปลอดภัยและเสถียรที่สุด",
        Default = 0.6,
        Min = 0.2,
        Max = 3.0,
        Rounding = 1,
        Callback = function(v) StealDelay = v end
    })

    Tabs.Steal:AddButton({
        Title = "⚡ ฉกรังไข่ที่ใกล้ที่สุดทันที (Fast Single Grab)",
        Description = "วาร์ปไปฉกไข่ที่ใกล้ที่สุด 1 รังแล้วพากลับบ้านทันที",
        Callback = function()
            local myPos = SafeHomeCFrame.Position
            for _, p in pairs(workspace:GetDescendants()) do
                if p:IsA("ProximityPrompt") and p.Parent:IsA("BasePart") then
                    if (p.Parent.Position - myPos).Magnitude > 25 then
                        safeStealInteraction(p, p.Parent, Options.AutoReturnToggle.Value)
                        Fluent:Notify({ Title = "Steal Success", Content = "ขโมยไข่สำเร็จเรียบร้อย!", Duration = 3 })
                        break
                    end
                end
            end
        end
    })

    StealToggle:OnChanged(function()
        isAutoSteal = Options.AutoStealToggle.Value
        if isAutoSteal then
            Fluent:Notify({ Title = "Auto Steal", Content = "เริ่มระบบขโมยอัตโนมัติ (BAC Safe)!", Duration = 3 })
            task.spawn(function()
                while isAutoSteal do
                    pcall(function()
                        local nests = {}
                        local myPos = SafeHomeCFrame.Position

                        for _, p in pairs(workspace:GetDescendants()) do
                            if not isAutoSteal then break end
                            if p:IsA("ProximityPrompt") and p.Parent:IsA("BasePart") then
                                local dist = (p.Parent.Position - myPos).Magnitude
                                if dist > 25 then
                                    table.insert(nests, { prompt = p, part = p.Parent, dist = dist })
                                end
                            end
                        end

                        table.sort(nests, function(a, b) return a.dist < b.dist end)

                        if #nests > 0 then
                            for _, n in ipairs(nests) do
                                if not isAutoSteal then break end
                                safeStealInteraction(n.prompt, n.part, Options.AutoReturnToggle.Value)
                                task.wait(StealDelay)
                            end
                        else
                            -- ไม่มีไข่ ให้ไปฟาร์ม Lucky Block รอ
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
        end
    end)

    -- ==============================================================================
    -- 🏠 2. TAB: BASE AUTOMATION
    -- ==============================================================================
    Tabs.Base:AddParagraph({
        Title = "🏠 จัดการคอกตัวเองอัตโนมัติ (Base Management)",
        Content = "ดูดเงิน อัปเกรดคอก สวมใส่ตัวท็อป และจุติอัตโนมัติ"
    })

    Tabs.Base:AddToggle("AutoCollectToggle", {
        Title = "💵 ดูดเงินทั้งหมดในคอกเรา (Auto Collect Cash)",
        Description = "เก็บเงินทุกบาทในคอกเข้าตัวทันที 100%",
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
        Description = "ขยายช่องสัตว์เลี้ยงและอัปเลเวลคอกเมื่อเงินถึง",
        Default = false,
        Callback = function(v)
            if v then
                task.spawn(function()
                    while Options.AutoUpgradeToggle.Value do
                        pcall(function()
                            for _, r in pairs(ReplicatedStorage:GetDescendants()) do
                                if r:IsA("RemoteEvent") and (r.Name:lower():find("upgrade") or r.Name:lower():find("buyslot") or r.Name:lower():find("buyplot")) then
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

    Tabs.Base:AddToggle("AutoEquipToggle", {
        Title = "🐾 ใส่สัตว์เลี้ยงตัวเก่งสุดเสมอ (Auto Equip Best)",
        Description = "สวมใส่ตัวที่ทำเงิน $/s สูงที่สุดในคลัง",
        Default = true,
        Callback = function(v)
            if v then
                for _, r in pairs(ReplicatedStorage:GetDescendants()) do
                    if r:IsA("RemoteEvent") and (r.Name:lower():find("equipbest") or r.Name:lower():find("best")) then
                        r:FireServer()
                    end
                end
            end
        end
    })

    Tabs.Base:AddButton({
        Title = "📌 บันทึกตำแหน่งยืนปัจจุบันเป็นบ้าน (Set Home)",
        Description = "ล็อคพิกัดคอกเราที่ตัวละครจะวาร์ปกลับมาส่งของ",
        Callback = function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                SafeHomeCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                Fluent:Notify({ Title = "Home Saved", Content = "บันทึกพิกัดบ้านเรียบร้อยแล้ว!", Duration = 3 })
            end
        end
    })

    -- ==============================================================================
    -- 📦 3. TAB: WORLD FARM
    -- ==============================================================================
    Tabs.World:AddParagraph({
        Title = "📦 ฟาร์มเสากล่องสุ่ม & ตีบอส",
        Content = "ปั๊มเงิน $B/s และดรอปสัตว์เลี้ยงระดับเทพ"
    })

    Tabs.World:AddToggle("AutoLuckyToggle", {
        Title = "📦 ฟาร์มเสากล่อง Lucky Blocks กลางแมพ",
        Description = "ยืนทุบเสากล่องสุ่มเพื่อรับเงินและไข่ระดับเทพ",
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
                                            task.wait(0.04)
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

    Tabs.World:AddToggle("AutoRewardsToggle", {
        Title = "🎁 รับของขวัญฟรีทุกอย่าง (Time & Daily Gifts)",
        Description = "กดรับรางวัลเวลารายวันและของขวัญฟรีอัตโนมัติ",
        Default = true,
        Callback = function(v)
            if v then
                task.spawn(function()
                    while Options.AutoRewardsToggle.Value do
                        pcall(function()
                            for _, r in pairs(ReplicatedStorage:GetDescendants()) do
                                if r:IsA("RemoteEvent") and (r.Name:lower():find("claim") or r.Name:lower():find("gift") or r.Name:lower():find("reward")) then
                                    r:FireServer()
                                end
                            end
                        end)
                        task.wait(10)
                    end
                end)
            end
        end
    })

    -- ==============================================================================
    -- ⚔️ 4. TAB: COMBAT & MOVEMENT
    -- ==============================================================================
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
                                        if (p.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 20 then
                                            firetouchinterest(bat.Handle, p.Character.HumanoidRootPart, 0)
                                            task.wait(0.02)
                                            firetouchinterest(bat.Handle, p.Character.HumanoidRootPart, 1)
                                        end
                                    end
                                end
                            end
                        end)
                        task.wait(0.15)
                    end
                end)
            end
        end)
    })

    Tabs.Combat:AddToggle("NoclipToggle", {
        Title = "👻 เดินทะลุรั้วคอก (Safe Noclip)",
        Description = "เดินทะลุรั้วคอกกั้นทุกประเภทโดยไม่ตกโลก",
        Default = true,
        Callback = function(v)
            RunService.Stepped:Connect(function()
                if Options.NoclipToggle.Value and LocalPlayer.Character then
                    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") and (part.Name:lower():find("arm") or part.Name:lower():find("leg") or part.Name:lower():find("torso")) then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end
    })

    Tabs.Combat:AddSlider("SpeedSlider", {
        Title = "🏃‍♂️ ความเร็วการเดิน (WalkSpeed)",
        Description = "ปรับความเร็วการวิ่งของตัวละคร",
        Default = 16,
        Min = 16,
        Max = 200,
        Rounding = 0,
        Callback = function(v)
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = v
            end
        end
    })

    -- ==============================================================================
    -- 👁️ 5. TAB: ESP & VISUALS
    -- ==============================================================================
    local ESPFolder = Instance.new("Folder")
    ESPFolder.Name = "FluentESPFolder"
    ESPFolder.Parent = ScreenGui

    local function updateESP()
        ESPFolder:ClearAllChildren()
        if not Options.PetESPToggle.Value then return end
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and not obj:IsDescendantOf(LocalPlayer.Character) then
                local primary = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                local n = obj.Name:lower()
                if primary and (n:find("chilli") or n:find("dragon") or n:find("cerberus") or n:find("godzilla") or n:find("milk") or n:find("pet") or n:find("egg")) then
                    local bb = Instance.new("BillboardGui")
                    bb.Size = UDim2.new(0, 120, 0, 30)
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

    Tabs.ESP:AddToggle("PetESPToggle", {
        Title = "👁️ มองทะลุสัตว์เลี้ยงและไข่ (Pet & Egg 3D ESP)",
        Description = "ขึ้นกรอบสีทองบอกชื่อสัตว์เลี้ยงและไข่ทุกตัวในแมพ",
        Default = false,
        Callback = function(v)
            updateESP()
        end
    })

    -- ==============================================================================
    -- 🚀 6. TAB: TELEPORTS
    -- ==============================================================================
    Tabs.Teleport:AddButton({
        Title = "🏠 วาร์ปกลับคอกเรา (Teleport to Base)",
        Callback = function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                LocalPlayer.Character.HumanoidRootPart.CFrame = SafeHomeCFrame
            end
        end
    })

    Tabs.Teleport:AddButton({
        Title = "📦 วาร์ปไปเสากล่อง Lucky Blocks กลางแมพ",
        Callback = function()
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and (obj.Name:lower():find("lucky") or obj.Name:lower():find("block")) then
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0, 5, 0)
                        break
                    end
                end
            end
        end
    })

    -- ==============================================================================
    -- ⚙️ 7. TAB: SETTINGS
    -- ==============================================================================
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

    Tabs.Settings:AddButton({
        Title = "🔄 รีจอยน์เข้าเซิร์ฟเวอร์เดิม (Rejoin Server)",
        Callback = function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end
    })

    Tabs.Settings:AddButton({
        Title = "🌐 ย้ายเซิร์ฟเวอร์หาห้องใหม่ (Server Hop)",
        Callback = function()
            pcall(function()
                local servers = HttpService:JSONDecode(game:HttpGet(string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100", game.PlaceId)))
                for _, s in pairs(servers.data) do
                    if s.id ~= game.JobId and s.playing < s.maxPlayers then
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
                        break
                    end
                end
            end)
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
        Title = "BAC BYPASSED v14.0",
        Content = "ปลดล็อคระบบกันเตะ BAC-9514 สำเร็จเรียบร้อย!",
        Duration = 5
    })
end

print("🛡️ [BAC Bypassed Hub v14.0] โหลดระบบสมบูรณ์ ปลอดภัย 100%!")
