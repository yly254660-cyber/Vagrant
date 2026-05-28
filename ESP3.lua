-- تنظيف السكربت القديم إذا كان شغالاً
if game:GetService("CoreGui"):FindFirstChild("Leader_ESP_System") then
    game:GetService("CoreGui")["Leader_ESP_System"]:Destroy()
end

for _, v in pairs(game:GetService("Players"):GetPlayers()) do
    if v.Character and v.Character:FindFirstChild("LeaderHighlight") then
        v.Character.LeaderHighlight:Destroy()
    end
end

-- إنشاء واجهة المستخدم
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local ToggleBtn = Instance.new("TextButton")
local UIStroke = Instance.new("UIStroke")

ScreenGui.Name = "Leader_ESP_System"
ScreenGui.Parent = game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(0.3, 0, 0.05, 0) -- مكان مناسب أعلى الشاشة
MainFrame.Size = UDim2.new(0, 220, 0, 110)
MainFrame.Active = true
MainFrame.Draggable = true

UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

UIStroke.Color = Color3.fromRGB(0, 255, 150)
UIStroke.Thickness = 1.5
UIStroke.Parent = MainFrame

Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Font = Enum.Font.GothamBold
Title.Text = "🧪 كاشف Rivals | ليدر"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14

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

-- منطق الكاشف الاحترافي (Highlight)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ESPEnabled = false

local function applyESP(player)
    if player ~= LocalPlayer and player.Character then
        if not player.Character:FindFirstChild("LeaderHighlight") then
            local highlight = Instance.new("Highlight")
            highlight.Name = "LeaderHighlight"
            highlight.FillColor = Color3.fromRGB(255, 0, 0) -- لون التعبئة الداخلي (أحمر)
            highlight.FillTransparency = 0.5 -- شفافية اللون الداخلي
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- لون الخط الخارجي (أبيض)
            highlight.OutlineTransparency = 0 -- خط خارجي واضح جداً
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- يظهر من خلف الجدران رغماً عن الماب
            highlight.Parent = player.Character
        end
    end
end

local function removeESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("LeaderHighlight") then
            player.Character.LeaderHighlight:Destroy()
        end
    end
end

-- التحديث التلقائي المستمر لمنع اختفاء الخطوط عند الموت أو ريسبون
RunService.RenderStepped:Connect(function()
    if ESPEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            applyESP(player)
        end
    end
end)

ToggleBtn.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    if ESPEnabled then
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        ToggleBtn.Text = "الكاشف: شـغـال ✅"
    else
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        ToggleBtn.Text = "الكاشف: مـطـفـأ ❌"
        removeESP()
    end
end)
