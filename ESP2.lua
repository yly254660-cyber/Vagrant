-- منع تكرار الواجهة إذا تم تشغيل السكربت أكثر من مرة
if game:GetService("CoreGui"):FindFirstChild("Leader_ESP_System") then
    game:GetService("CoreGui")["Leader_ESP_System"]:Destroy()
end

-- إنشاء واجهة مستخدم أسطورية وخفيفة جداً
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local ToggleBtn = Instance.new("TextButton")
local UIStroke = Instance.new("UIStroke")

ScreenGui.Name = "Leader_ESP_System"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- تصميم اللوحة الرئيسية لتكون أنيقة ومتحركة
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 220, 0, 130)
MainFrame.Active = true
MainFrame.Draggable = true

UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

UIStroke.Color = Color3.fromRGB(0, 255, 150) -- إطار بلون نيون
UIStroke.Thickness = 1.5
UIStroke.Parent = MainFrame

-- العنوان
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Font = Enum.Font.GothamBold
Title.Text = "🧪 كاشف تجريبي عام | ليدر"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14

-- زر تفعيل الكاشف
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = MainFrame
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.45, 0)
ToggleBtn.Size = UDim2.new(0.9, 0, 0, 45)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "تشغيل الكاشف (ESP)"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 14

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 8)
ButtonCorner.Parent = ToggleBtn

-- منطق الكاشف السريع (ESP) المتوافق مع كل المابات
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ESPEnabled = false

-- وظيفة إضافة المربع الأحمر حول اللاعب
local function addESP(player)
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function(char)
            task.wait(0.5)
            local root = char:WaitForChild("HumanoidRootPart", 5)
            if root and ESPEnabled and not root:FindFirstChild("LeaderBox") then
                local box = Instance.new("BoxHandleAdornment")
                box.Name = "LeaderBox"
                box.Size = Vector3.new(4, 6, 4)
                box.Color3 = Color3.fromRGB(255, 0, 0) -- لون أحمر ساطع
                box.AlwaysOnTop = true
                box.ZIndex = 5
                box.Adornee = root
                box.Transparency = 0.4
                box.Parent = root
            end
        end)
        
        -- إذا كان اللاعب حياً وموجوداً بالفعل عند تشغيل الزر
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local root = player.Character.HumanoidRootPart
            if ESPEnabled and not root:FindFirstChild("LeaderBox") then
                local box = Instance.new("BoxHandleAdornment")
                box.Name = "LeaderBox"
                box.Size = Vector3.new(4, 6, 4)
                box.Color3 = Color3.fromRGB(255, 0, 0)
                box.AlwaysOnTop = true
                box.ZIndex = 5
                box.Adornee = root
                box.Transparency = 0.4
                box.Parent = root
            end
        end
    end
end

-- التنظيف عند إطفاء السكربت
local function removeESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart:FindFirstChild("LeaderBox") then
            player.Character.HumanoidRootPart.LeaderBox:Destroy()
        end
    end
end

ToggleBtn.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    if ESPEnabled then
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        ToggleBtn.Text = "الكاشف: شـغـال ✅"
        
        for _, player in pairs(Players:GetPlayers()) do
            addESP(player)
        end
        Players.PlayerAdded:Connect(addESP)
    else
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        ToggleBtn.Text = "الكاشف: مـطـفـأ ❌"
        removeESP()
    end
end)
