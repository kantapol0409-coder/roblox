-- ==============================================================================
-- ⚡ SPEED HUB X - KEY BYPASS & KEYLESS LOADER
-- 👑 ปลดล็อคระบบคีย์ Speed Hub X (Auto Key Bypasser + Request Hook)
-- 🔓 ข้ามหน้าต่างกรอกคีย์ / ไม่ต้องผ่านลิงก์โฆษณา (Linkvertise / Platoboost)
-- ==============================================================================

-- 🛡️ 1. Hook HTTP Request Key Verification (จำลองการยืนยันคีย์สำเร็จ 100%)
pcall(function()
    local httpRequest = (syn and syn.request) or (http and http.request) or http_request or request
    if httpRequest then
        local oldReq
        oldReq = hookfunction(httpRequest, function(req)
            local url = req and req.Url and tostring(req.Url):lower() or ""
            if url:find("key") or url:find("verify") or url:find("whitelist") or url:find("check") or url:find("platoboost") or url:find("gateway") or url:find("speed") then
                return {
                    StatusCode = 200,
                    Body = '{"success":true,"valid":true,"status":true,"key":"SPEEDHUBX_KEYLESS_BYPASS"}'
                }
            end
            return oldReq(req)
        end)
    end
end)

-- 🔑 2. ตั้งค่า Global Key Variables ล่วงหน้า
getgenv().Key = "SPEEDHUBX_KEYLESS_BYPASS"
getgenv().SpeedHubKey = "SPEEDHUBX_KEYLESS_BYPASS"
getgenv().VerifiedKey = true

-- 🚀 3. รัน Speed Hub X ตัวเต็ม
pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()
end)

print("⚡ [Speed Hub X Bypass] ปลดล็อคคีย์และโหลดสคริปต์เรียบร้อย!")
