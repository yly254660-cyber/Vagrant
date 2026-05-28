-- 1. استدعاء مكتبة الواجهات Orion
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- 2. إنشاء النافذة التجريبية العامة
local Window = OrionLib:MakeWindow({
    Name = "🧪 سكربت كاشف عام تجريبي | ليدر VIP",
    HidePremium = false,
    SaveConfig = false,
    IntroText = "جاري تفعيل بيئة الاختبار العامة..."
})

-- الخدمات الأساسية من المحرك لتتبع اللاعبين
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ESPEnabled = false

-- =======================================================
-- [ التبويبات الرئيسية ]
-- =======================================================
local TestTab = Window:MakeTab({Name = "👁️ كاشف الأماكن (ESP)", Icon = "rbxassetid://4483362458"})
local InfoTab = Window:MakeTab({Name = "ℹ️ معلومات", Icon = "rbxassetid://4483362458"})

-- =======================================================
-- [ تفعيل وإطفاء الكاشف التجريبي ]
-- =======================================================
TestTab:AddToggle({
    Name = "تشغيل / إطفاء كاشف اللاعبين عبر الجدران",
    Default = false,
    Callback = function(Value)
        ESPEnabled = Value
        if Value then
            -- تشغيل حلقة فحص متكررة لإضافة المؤشر لجميع اللاعبين في السيرفر
            task.spawn(function()
                while ESPEnabled do
                    task.wait(1)
                    pcall(function()
                        for _, player in pairs(Players:GetPlayers()) do
                            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                local root = player.Character.HumanoidRootPart
                                
                                -- إذا لم يكن اللاعب يمتلك مؤشراً مسبقاً، يتم إنشاؤه
                                if not root:FindFirstChild("Test_ESP_Box") then
                                    local box = Instance.new("BoxHandleAdornment")
                                    box.Name = "Test_ESP_Box"
                                    box.Size = Vector3.new(4, 6, 4)
                                    box.Color3 = Color3.fromRGB(0, 255, 100) -- لون أخضر تجريبي ساطع
                                    box.AlwaysOnTop = true
                                    box.ZIndex = 5
                                    box.Adornee = root
                                    box.Transparency = 0.4
                                    box.Parent = root
                                end
                            end
                        end
                    end)
                end
            end)
        else
            -- تنظيف وإزالة المؤشرات فوراً من كافة اللاعبين عند إطفاء الزر
            for _, player in pairs(Players:GetPlayers()) do
                pcall(function()
                    if player.Character and player.Character.HumanoidRootPart:FindFirstChild("Test_ESP_Box") then
                        player.Character.HumanoidRootPart.Test_ESP_Box:Destroy()
                    end
                end)
            end
        end
    end
})

-- =======================================================
-- [ تبويب المعلومات ]
-- =======================================================
InfoTab:AddLabel("هذا السكربت مخصص لاختبار دمج القوائم وتوافقها")
InfoTab:AddLabel("يعمل كقاعدة أساسية لتطوير ميزاتك الخاصة لاحقاً")

OrionLib:Init()
