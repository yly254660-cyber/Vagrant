-- 1. استدعاء واجهة Orion الخفيفة والمتوافقة مع هاك دلتا
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({
    Name = "👑 سـكربت لـيـدر VIP | مدمج بأكواد Infinite Yield",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "LeaderVagrantConfig",
    IntroText = "جاري حقن أكواد Infinite Yield المتقدمة..."
})

-- الخدمات الأساسية من سورس Infinite Yield ولعبة روبلوكس
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = game:GetService("Workspace").CurrentCamera
local UserInputService = game:GetService("UserInputService")

-- متغيرات التحكم بالتفعيلات
local AimbotEnabled = false
local ESPEnabled = false
local SpeedEnabled = false
local TargetSpeed = 16
local NoclipEnabled = false
local FlyEnabled = false
local FlySpeed = 50

-- =======================================================
-- [ التبويبات الرئيسية باللغة العربية ]
-- =======================================================
local MainTab = Window:MakeTab({Name = "👤 خواص اللاعب", Icon = "rbxassetid://4483362458"})
local AdminTab = Window:MakeTab({Name = "✈️ طيران واختراق (IY)", Icon = "rbxassetid://4483362458"})
local CombatTab = Window:MakeTab({Name = "🎯 القتال والأيم بوت", Icon = "rbxassetid://4483362458"})
local VisualsTab = Window:MakeTab({Name = "👁️ كاشف الأماكن", Icon = "rbxassetid://4483362458"})
local FarmTab = Window:MakeTab({Name = "🌾 التجميع التلقائي", Icon = "rbxassetid://4483362458"})

-- =======================================================
-- [ تبويب اللاعب - إدارة السرعة ]
-- =======================================================
MainTab:AddToggle({
    Name = "تشغيل / إطفاء السرعة الخارقة",
    Default = false,
    Callback = function(Value)
        SpeedEnabled = Value
    end
})

MainTab:AddSlider({
    Name = "تحديد مستوى السرعة",
    Min = 16,
    Max = 200,
    Default = 50,
    Color = Color3.fromRGB(0, 255, 127),
    Increment = 1,
    ValueName = "سرعة",
    Callback = function(Value)
        TargetSpeed = Value
    end    
})

RunService.RenderStepped:Connect(function()
    if SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = TargetSpeed
    elseif not SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
    end
end)

-- =======================================================
-- [ تبويب Infinite Yield - الطيران واختراق الجدران ]
-- =======================================================

-- ميزة اختراق الجدران (Noclip) المأخوذة من Infinite Yield
AdminTab:AddToggle({
    Name = "اختراق الجدران والأشياء (Noclip)",
    Default = false,
    Callback = function(Value)
        NoclipEnabled = Value
    end
})

RunService.Stepped:Connect(function()
    if NoclipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- ميزة الطيران الاحترافي (Fly) المعدلة لتناسب شاشات الجوال داخل هاat دلتا
AdminTab:AddToggle({
    Name = "تفعيل الطيران الحر (Fly)",
    Default = false,
    Callback = function(Value)
        FlyEnabled = Value
        local Character = LocalPlayer.Character
        if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end
        
        if FlyEnabled then
            local BodyVelocity = Instance.new("BodyVelocity")
            BodyVelocity.Name = "IY_Fly"
            BodyVelocity.Velocity = Vector3.new(0, 0, 0)
            BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            BodyVelocity.Parent = Character.HumanoidRootPart
            
            task.spawn(function()
                while FlyEnabled and Character:FindFirstChild("HumanoidRootPart") and Character:FindFirstChild("IY_Fly") do
                    RunService.RenderStepped:Wait()
                    -- الطيران يتبع اتجاه كاميرا الموبايل تلقائياً عند التحرك
                    local FlyDirection = Vector3.new(0,0,0)
                    local Hum = Character:FindFirstChildOfClass("Humanoid")
                    if Hum and Hum.MoveDirection.Magnitude > 0 then
                        FlyDirection = Camera.CFrame.LookVector * FlySpeed
                    end
                    Character.IY_Fly.Velocity = FlyDirection
                end
            end)
        else
            if Character.HumanoidRootPart:FindFirstChild("IY_Fly") then
                Character.HumanoidRootPart.IY_Fly:Destroy()
            end
        end
    end
})

AdminTab:AddSlider({
    Name = "سرعة الطيران",
    Min = 20,
    Max = 200,
    Default = 50,
    Color = Color3.fromRGB(0, 170, 255),
    Increment = 5,
    ValueName = "سرعة الطيران",
    Callback = function(Value)
        FlySpeed = Value
    end    
})

-- =======================================================
-- [ تبويب القتال - الأيم بوت ]
-- =======================================================
CombatTab:AddToggle({
    Name = "تشغيل / إطفاء الأيم بوت التلقائي",
    Default = false,
    Callback = function(Value)
        AimbotEnabled = Value
    end
})

local function GetClosestPlayer()
    local ClosestTarget = nil
    local MaxDistance = math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
            local TargetPart = player.Character.HumanoidRootPart
            local ScreenPosition, OnScreen = Camera:WorldToScreenPoint(TargetPart.Position)
            if OnScreen then
                local MousePosition = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                local DistanceToMouse = (Vector2.new(ScreenPosition.X, ScreenPosition.Y) - MousePosition).Magnitude
                if DistanceToMouse < MaxDistance then
                    MaxDistance = DistanceToMouse
                    ClosestTarget = TargetPart
                end
            end
        end
    end
    return ClosestTarget
end

RunService.RenderStepped:Connect(function()
    if AimbotEnabled then
        local Target = GetClosestPlayer()
        if Target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Position)
        end
    end
end)

-- =======================================================
-- [ تبويب كاشف الأشخاص (ESP) ]
-- =======================================================
VisualsTab:AddToggle({
    Name = "تشغيل / إطفاء كاشف جدران اللاعبين",
    Default = false,
    Callback = function(Value)
        ESPEnabled = Value
        if Value then
            task.spawn(function()
                while ESPEnabled do
                    task.wait(1)
                    pcall(function()
                        for _, player in pairs(Players:GetPlayers()) do
                            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                local root = player.Character.HumanoidRootPart
                                if not root:FindFirstChild("Leader_ESP") then
                                    local box = Instance.new("BoxHandleAdornment")
                                    box.Name = "Leader_ESP"
                                    box.Size = Vector3.new(4, 6, 4)
                                    box.Color3 = Color3.fromRGB(255, 0, 50)
                                    box.AlwaysOnTop = true
                                    box.ZIndex = 5
                                    box.Adornee = root
                                    box.Transparency = 0.5
                                    box.Parent = root
                                end
                            end
                        end
                    end)
                end
            end)
        else
            for _, player in pairs(Players:GetPlayers()) do
                pcall(function()
                    if player.Character.HumanoidRootPart:FindFirstChild("Leader_ESP") then
                        player.Character.HumanoidRootPart.Leader_ESP:Destroy()
                    end
                end)
            end
        end
    end
})

-- =======================================================
-- [ تبويب الأوتو لوت ]
-- =======================================================
FarmTab:AddToggle({
    Name = "تشغيل / إطفاء سحب اللوت والصناديق تلقائياً",
    Default = false,
    Callback = function(Value)
        _G.LeaderLoot = Value
        task.spawn(function()
            while _G.LeaderLoot do
                task.wait(0.5)
                pcall(function()
                    local myChar = LocalPlayer.Character
                    if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                        for _, obj in pairs(game.Workspace:GetChildren()) do
                            if obj:IsA("Model") and (obj.Name:lower():find("loot") or obj.Name:lower():find("box") or obj.Name:lower():find("item")) then
                                local targetPart = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildOfClass("Part")
                                if targetPart then
                                    local distance = (myChar.HumanoidRootPart.Position - targetPart.Position).Magnitude
                                    if distance < 60 then
                                        firetouchinterest(myChar.HumanoidRootPart, targetPart, 0)
                                        task.wait(0.02)
                                        firetouchinterest(myChar.HumanoidRootPart, targetPart, 1)
                                    end
                                end
                            end
                        end
                    end
                end)
            end
        end)
    end
})

OrionLib:Init()
