-- ==============================================================================
-- 🚀 STEAL AN EGG - FPS BOOSTER & STAT CHECKER (HORST COMPANION)
-- ⚡ ลดแลคขั้นสุด (FPS Boost 100% / ปิด Animation / ปิด Particle / ลบ VFX)
-- 📊 สแกนคำนวณมูลค่าไอดี (Income/sec, Speed, ไข่รอฟัก, สัตว์เลี้ยง)
-- 🔄 รองรับระบบ Horst Account Manager (Auto Change Account เมื่อถึงเป้าหมาย)
-- ==============================================================================

if not game:IsLoaded() then repeat game.Loaded:Wait() until game:IsLoaded() end
getgenv().script_log_working = true

local ReplicatedStorage     = game:GetService("ReplicatedStorage")
local Players               = game:GetService("Players")
local HttpService           = game:GetService("HttpService")
local LocalPlayer           = Players.LocalPlayer

local Shared                = ReplicatedStorage:WaitForChild("Shared")
local Data                  = ReplicatedStorage:WaitForChild("Data")
local SaveModule            = require(Shared:WaitForChild("Save"))
local AssetsModule          = require(Data:WaitForChild("Assets"))
local AssetEarnings         = require(Shared:WaitForChild("Util"):WaitForChild("AssetEarnings"))
local AdminBoosts           = require(Shared:WaitForChild("Util"):WaitForChild("AdminBoosts"))
local EggRecords            = require(Shared:WaitForChild("Util"):WaitForChild("EggRecords"))

-- ⚙️ ตั้งค่าเป้าหมายของไอดี (CONFIG)
getgenv().Language_log      = getgenv().Language_log      or "Thai"    -- ภาษาที่ใช้แสดง log: "Thai" | "Eng"
getgenv().DestroyMap        = getgenv().DestroyMap        or true      -- true = ลบและซ่อนแมพเพื่อบูสต์ FPS | false = ปิด
getgenv().income_need       = getgenv().income_need       or "1B"      -- เป้าหมายเงินต่อวินาที (เช่น "500M", "1B", "10B", "1T" หรือ "0" ถ้าไม่เช็ค)
getgenv().speed_need        = getgenv().speed_need        or "2B"      -- เป้าหมาย Speed (เช่น "500M", "1B", "2B" หรือ "0" ถ้าไม่เช็ค)

getgenv().pets_income       = getgenv().pets_income       or false     -- true = รวมเงินสัตว์ทุกตัว | false = หาสัตว์ตัวเดี่ยวที่เกิน income_need
getgenv().showincome_all    = getgenv().showincome_all    or true      -- true = แสดงรายได้รวมทั้งหมด
getgenv().checkincome_egg   = getgenv().checkincome_egg   or true      -- true = เช็คมูลค่าไข่ที่กำลังฟัก
getgenv().check_AdminBoost_Earnings = getgenv().check_AdminBoost_Earnings or true -- เช็คตัวคูณเงินของแอดมิน

-- ==============================================================================
-- ⚡ 1. FPS BOOSTER & RENDER OPTIMIZER
-- ==============================================================================
local function OptimizeRenderAndAnimations()
    local Workspace     = game:GetService("Workspace")
    local TweenService  = game:GetService("TweenService")

    local CONFIG = {
        Mode                         = "SafeInvisible",
        Disable3DAnimations          = true,
        DisableMoneyBounceAnimations = true,
        DisableTreadmillAndSpeedUI   = true,
        DisableVFXAnimations         = true,
        InstantTweenAnimations       = true,
        ProtectLocalPlayerAnimations = true,
        AutoProcessNewDescendants    = true,
        ProtectPlayerCharacters      = true,
        ProtectInteractiveItems      = true,
    }

    local function isPlayerCharacter(inst)
        if not CONFIG.ProtectPlayerCharacters then return false end
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character and inst:IsDescendantOf(player.Character) then
                return true
            end
        end
        return false
    end

    local function isLocalPlayerAnimator(animator)
        if CONFIG.ProtectLocalPlayerAnimations and LocalPlayer.Character then
            if animator:IsDescendantOf(LocalPlayer.Character) then
                return true
            end
        end
        return false
    end

    local function isProtected(inst)
        if isPlayerCharacter(inst) then return true end
        if inst.Name == "Camera" or inst.Name == "Terrain" then return true end
        
        if CONFIG.ProtectInteractiveItems then
            local lowerName = inst.Name:lower()
            if lowerName:find("egg") or lowerName:find("prompt") or lowerName:find("hitbox") or lowerName:find("spawn") then
                return true
            end
            if inst:IsA("ProximityPrompt") or inst:FindFirstChildOfClass("ProximityPrompt") then
                return true
            end
        end
        return false
    end

    if CONFIG.DisableMoneyBounceAnimations then
        pcall(function()
            local pScripts = LocalPlayer:FindFirstChild("PlayerScripts")
            local popupModule = pScripts and pScripts:FindFirstChild("GUI") and pScripts.GUI:FindFirstChild("ActiveAssetIncomePopup")
            if popupModule then
                local popup = require(popupModule)
                if popup and typeof(popup.Show) == "function" then
                    popup.Show = function(...) end
                end
            end
        end)
    end

    local function processSpeedAndTreadmillUI(inst)
        if not CONFIG.DisableTreadmillAndSpeedUI or not inst then return end
        local name = inst.Name:lower()
        if name:find("treadmill") or name:find("speed") or name:find("ratesign") then
            if inst:IsA("SurfaceGui") or inst:IsA("BillboardGui") or inst:IsA("ScreenGui") then
                pcall(function() inst.Enabled = false end)
            elseif inst:IsA("TextLabel") or inst:IsA("ImageLabel") then
                pcall(function() inst.Visible = false end)
            end
        end
    end

    if CONFIG.DisableTreadmillAndSpeedUI then
        pcall(function()
            local pGui = LocalPlayer:FindFirstChild("PlayerGui")
            if pGui then
                for _, child in ipairs(pGui:GetChildren()) do
                    processSpeedAndTreadmillUI(child)
                end
                pGui.ChildAdded:Connect(function(child)
                    task.defer(function() processSpeedAndTreadmillUI(child) end)
                end)
            end
        end)
    end

    if CONFIG.InstantTweenAnimations then
        pcall(function()
            if not getgenv()._TweenServiceHooked then
                getgenv()._TweenServiceHooked = true
                local rawCreate = TweenService.Create
                TweenService.Create = function(self, instance, tweenInfo, targetProps)
                    local instantInfo = TweenInfo.new(0, tweenInfo.EasingStyle, tweenInfo.EasingDirection, 0, false, 0)
                    return rawCreate(self, instance, instantInfo, targetProps)
                end
            end
        end)
    end

    local function processAnimator(animator)
        if not CONFIG.Disable3DAnimations or not animator or not animator.Parent then return end
        if isLocalPlayerAnimator(animator) then return end

        pcall(function()
            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                track:Stop(0)
            end

            if not animator:GetAttribute("_McpAnimHooked") then
                animator:SetAttribute("_McpAnimHooked", true)
                animator.AnimationPlayed:Connect(function(track)
                    task.defer(function()
                        pcall(function() track:Stop(0) end)
                    end)
                end)
            end
        end)
    end

    local function processInstance(inst)
        if not inst or not inst.Parent or isProtected(inst) then return end

        processSpeedAndTreadmillUI(inst)

        if inst:IsA("Animator") then
            processAnimator(inst)
            return
        end

        if CONFIG.DisableVFXAnimations and (inst:IsA("ParticleEmitter") or inst:IsA("Beam") or inst:IsA("Trail") 
            or inst:IsA("Smoke") or inst:IsA("Fire") or inst:IsA("Sparkles") or inst:IsA("Highlight")) then
            pcall(function() inst:Destroy() end)
            return
        end

        if inst:IsA("BasePart") then
            if inst.Transparency < 1 then
                pcall(function()
                    inst.Transparency = 1
                    inst.CastShadow = false
                end)
            end
            
            for _, child in ipairs(inst:GetChildren()) do
                if child:IsA("Decal") or child:IsA("Texture") or child:IsA("SurfaceAppearance")
                    or (CONFIG.DisableVFXAnimations and (child:IsA("ParticleEmitter") or child:IsA("Beam") 
                    or child:IsA("Trail") or child:IsA("Light") or child:IsA("Highlight"))) then
                    pcall(function() child:Destroy() end)
                end
            end
        elseif inst:IsA("Decal") or inst:IsA("Texture") or inst:IsA("SurfaceAppearance") or inst:IsA("Light") then
            pcall(function() inst:Destroy() end)
        end
    end

    local descendants = Workspace:GetDescendants()
    for _, desc in ipairs(descendants) do
        processInstance(desc)
    end

    if CONFIG.AutoProcessNewDescendants then
        Workspace.DescendantAdded:Connect(function(desc)
            task.defer(function()
                if desc and desc.Parent and not isProtected(desc) then
                    processInstance(desc)
                end
            end)
        end)
    end
    
    print("⚡ [FPS Booster] บูสต์ประสิทธิภาพและลดการกินสเปกเรียบร้อยแล้ว!")
end
if getgenv().DestroyMap then pcall(OptimizeRenderAndAnimations) end

-- ==============================================================================
-- 📊 2. FORMATTING HELPERS
-- ==============================================================================
local function FormatMoney(num)
    if not num or num == 0 then return "0/s" end
    if num >= 1e12 then return string.format("%.2fT/s", num / 1e12)
    elseif num >= 1e9 then return string.format("%.2fB/s", num / 1e9)
    elseif num >= 1e6 then return string.format("%.2fM/s", num / 1e6)
    elseif num >= 1e3 then return string.format("%.2fK/s", num / 1e3)
    else return tostring(num) .. "/s" end
end

local function FormatSpeed(val)
    local n = tonumber(val) or 0
    if n >= 1e12 then return string.format("%.1fT", n / 1e12)
    elseif n >= 1e9 then return string.format("%.1fB", n / 1e9)
    elseif n >= 1e6 then return string.format("%.1fM", n / 1e6)
    elseif n >= 1e3 then return string.format("%.1fK", n / 1e3)
    else return tostring(n) end
end

local function FormatNoDecimal(num)
    local n = tonumber(num) or 0
    if n == 0 then return "0" end
    local function cleanDec(v)
        local s = string.format("%.2f", v)
        s = s:gsub("%.00$", "")
        if s:find("%.") then s = s:gsub("0+$", ""):gsub("%.$", "") end
        return s
    end
    if n >= 1e12 then return cleanDec(n / 1e12) .. " T"
    elseif n >= 1e9 then return cleanDec(n / 1e9) .. " B"
    elseif n >= 1e6 then return cleanDec(n / 1e6) .. " M"
    elseif n >= 1e3 then return cleanDec(n / 1e3) .. " K"
    else return tostring(math.floor(n)) end
end

local function ParseMoneyString(val)
    if type(val) == "number" then return val end
    if type(val) ~= "string" then return 0 end
    val = val:upper():gsub("%s+", "")
    local num = tonumber(val:match("[%d%.]+")) or 0
    if val:find("T") then return num * 1e12
    elseif val:find("B") then return num * 1e9
    elseif val:find("M") then return num * 1e6
    elseif val:find("K") then return num * 1e3 end
    return num
end

-- ==============================================================================
-- 📋 3. INVENTORY & PLAYER DATA RETRIEVAL
-- ==============================================================================
local function GetPlayerData()
    local saveData = SaveModule.Get()
    if not saveData then return nil end

    local activePetUIDs = {}
    local equippedAssets = saveData.EquippedAssets or {}
    for _, uid in ipairs(equippedAssets) do activePetUIDs[uid] = true end

    local petsInBag, petsInFarm, eggsInBag, eggsInFarm = {}, {}, {}, {}
    local totalPetIncome, highestPetIncome, highestPetName = 0, 0, "None"
    local totalEggIncome, highestEggIncome, highestEggName = 0, 0, "None"
    local highestGrowingEggIncome, highestGrowingEggName, highestGrowingEggHatchTimeFormatted = 0, "None", ""

    local passes = saveData.Gamepasses or {}
    local robux = saveData.MonetizationRobuxSpentTotal or 0
    local currentTime = (pcall(function() return workspace:GetServerTimeNow() end) and workspace:GetServerTimeNow()) or os.time()

    local inventory = saveData.Inventory or {}
    for uid, petData in pairs(inventory) do
        local category = petData.Category
        local assetConfig = AssetsModule.Directory[category]
        local displayName = (assetConfig and assetConfig.DisplayName) or category or "None"
        local rarityName = (assetConfig and assetConfig.Rarity and assetConfig.Rarity.DisplayName) or "None"
        local activeRecord = activePetUIDs[uid]
        local income = AssetEarnings.RatePerSecond(petData, passes, robux)

        local petInfo = {
            UID = uid, Category = category, Name = displayName, Rarity = rarityName,
            Scale = petData.Scale, Income = income, IncomeFormatted = FormatMoney(income),
            Placed = (activeRecord ~= nil)
        }

        totalPetIncome = totalPetIncome + income
        if income > highestPetIncome then
            highestPetIncome = income
            highestPetName = displayName
        end

        if activeRecord ~= nil then table.insert(petsInFarm, petInfo) else table.insert(petsInBag, petInfo) end
    end

    local eggInventory = saveData.EggInventory or {}
    for uid, eggData in pairs(eggInventory) do
        local category = eggData.Category or eggData.AssetCategory
        local assetConfig = AssetsModule.Directory[category]
        local eggConfig = (assetConfig and assetConfig.Egg) or {}
        local eggName = eggConfig.DisplayName or (category .. " Egg")
        local rarityName = (assetConfig and assetConfig.Rarity and assetConfig.Rarity.DisplayName) or "Unknown"

        local decodedEgg = EggRecords.Decode(eggData)
        local itemData = EggRecords.ToAssetItemData(decodedEgg)
        local income = AssetEarnings.RatePerSecond(itemData, passes, robux)
        local isPlaced = (eggData.Placement ~= nil)
        local formattedHatchTime = ""

        if isPlaced then
            local remainingSeconds = 0
            pcall(function()
                local deserialized = EggRecords.Decode(eggData)
                local speedMult = eggData.GrowthSpeedMultiplier or 1
                remainingSeconds = EggRecords.GrowthSecondsRemaining(deserialized, currentTime, speedMult, nil, LocalPlayer)
            end)

            if remainingSeconds > 0 then
                local hatchTime = currentTime + remainingSeconds
                local isEng = (getgenv().Language_log == "Eng")
                formattedHatchTime = os.date(isEng and "%d-%m Time %H.%M" or "%d-%m เวลา %H.%M", hatchTime)

                if income > highestGrowingEggIncome then
                    highestGrowingEggIncome = income
                    highestGrowingEggName = eggName
                    highestGrowingEggHatchTimeFormatted = formattedHatchTime
                end
            end
        end

        local eggInfo = {
            UID = uid, Category = category, Name = eggName, Rarity = rarityName,
            Income = income, IncomeFormatted = FormatMoney(income),
            Placed = isPlaced, HatchTimeFormatted = formattedHatchTime
        }

        totalEggIncome = totalEggIncome + income
        if income > highestEggIncome then
            highestEggIncome = income
            highestEggName = eggName
        end

        if isPlaced then table.insert(eggsInFarm, eggInfo) else table.insert(eggsInBag, eggInfo) end
    end

    return {
        Summary = {
            TotalPets = #petsInBag + #petsInFarm,
            PetsInBagCount = #petsInBag,
            PetsInFarmCount = #petsInFarm,
            TotalEggs = #eggsInBag + #eggsInFarm,
            EggsInBagCount = #eggsInBag,
            EggsInFarmCount = #eggsInFarm,
            TotalPetIncome = totalPetIncome,
            TotalPetIncomeFormatted = FormatMoney(totalPetIncome),
            HighestPetIncome = highestPetIncome,
            HighestPetIncomeFormatted = FormatMoney(highestPetIncome),
            HighestPetName = highestPetName,
            TotalEggIncome = totalEggIncome,
            TotalEggIncomeFormatted = FormatMoney(totalEggIncome),
            HighestEggIncome = highestEggIncome,
            HighestEggIncomeFormatted = FormatMoney(highestEggIncome),
            HighestEggName = highestEggName,
            HighestGrowingEggIncome = highestGrowingEggIncome,
            HighestGrowingEggIncomeFormatted = FormatMoney(highestGrowingEggIncome),
            HighestGrowingEggName = highestGrowingEggName,
            HighestGrowingEggHatchTimeFormatted = highestGrowingEggHatchTimeFormatted
        },
        PetsInBag = petsInBag,
        PetsInFarm = petsInFarm,
        EggsInBag = eggsInBag,
        EggsInFarm = eggsInFarm
    }
end

-- ==============================================================================
-- 🎯 4. CONDITION & HORST INTEGRATION
-- ==============================================================================
local function BuildDescriptionAndCondition(data)
    local targetIncome = ParseMoneyString(getgenv().income_need)
    local targetSpeed = ParseMoneyString(getgenv().speed_need)
    local isIncomeConditionMet = false
    local petValFormatted = ""

    if targetIncome == 0 then
        isIncomeConditionMet = true
    else
        local isPetConditionMet = false
        if getgenv().pets_income == true then
            isPetConditionMet = (data.Summary.TotalPetIncome >= targetIncome)
            petValFormatted = data.Summary.TotalPetIncomeFormatted
        else
            isPetConditionMet = (data.Summary.HighestPetIncome >= targetIncome)
            petValFormatted = data.Summary.HighestPetIncomeFormatted
        end
        local isEggConditionMet = (getgenv().checkincome_egg == true and data.Summary.HighestGrowingEggIncome >= targetIncome)
        isIncomeConditionMet = isPetConditionMet or isEggConditionMet
    end

    local isBagEggHigh = (targetIncome > 0) and (data.Summary.HighestEggIncome >= targetIncome) and (data.Summary.HighestEggIncome > data.Summary.HighestGrowingEggIncome)
    local rawSpeed = (LocalPlayer:FindFirstChild("leaderstats") and LocalPlayer.leaderstats:FindFirstChild("Speed")) and LocalPlayer.leaderstats.Speed.Value or 0
    local isSpeedConditionMet = (targetSpeed == 0) or (rawSpeed >= targetSpeed)
    local isConditionMet = isIncomeConditionMet and isSpeedConditionMet and (not isBagEggHigh)

    local isEng = (getgenv().Language_log == "Eng")
    local speedStatus = (targetSpeed == 0 and FormatSpeed(rawSpeed)) or (isSpeedConditionMet and string.format("✅ %s / [%s]", FormatSpeed(rawSpeed), tostring(getgenv().speed_need or "0")) or string.format("❌ %s / [%s]", FormatSpeed(rawSpeed), tostring(getgenv().speed_need or "0")))
    local descriptionStr = string.format("%s 💰 %s (%s) │ ⚡ SPEED %s │ 🥚 %s", (isConditionMet and "✅" or "❌"), data.Summary.TotalPetIncomeFormatted, data.Summary.HighestPetName, speedStatus, data.Summary.TotalEggIncomeFormatted)

    local encodeJson = nil
    pcall(function()
        encodeJson = HttpService:JSONEncode({
            ["Income/Sec"] = data.Summary.TotalPetIncomeFormatted,
            ["Speed"] = FormatNoDecimal(rawSpeed),
            ["HighestPet"] = data.Summary.HighestPetName .. " (" .. data.Summary.HighestPetIncomeFormatted .. ")",
            ["TotalEggs"] = FormatNoDecimal(data.Summary.TotalEggIncome)
        })
    end)

    return descriptionStr, isConditionMet, isBagEggHigh, encodeJson
end

-- Main Loop
task.spawn(function()
    while getgenv().script_log_working and task.wait(3) do
        pcall(function()
            local playerData = GetPlayerData()
            if playerData then
                local descriptionStr, isConditionMet, isBagEggHigh, encodeJson = BuildDescriptionAndCondition(playerData)
                
                -- อัปเดตไปยังหน้าต่าง Horst
                if _G.Horst_SetDescription then
                    _G.Horst_SetDescription(descriptionStr, encodeJson)
                end
                
                -- แจ้งเตือนเมื่อถึงเป้าหมาย
                if isConditionMet and (not isBagEggHigh) and _G.Horst_AccountChangeDone then
                    print("🎉 [Horst] ไอดีนี้ฟาร์มถึงเป้าหมายแล้ว! สั่งเปลี่ยนไอดี...")
                    task.wait(5)
                    _G.Horst_AccountChangeDone()
                    getgenv().script_log_working = false
                end
            end
        end)
    end
end)

print("🚀 [FPS Booster & Stat Tracker] เริ่มทำงานเรียบร้อยแล้ว!")
