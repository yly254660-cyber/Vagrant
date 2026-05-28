-- تنظيف أي كاشف قديم لضمان عدم التعليق
for _, v in pairs(game:GetService("Workspace"):GetChildren()) do
    if v:IsA("Highlight") or v.Name == "Leader_Tracer" then
        v:Destroy()
    end
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- وظيفة صنع الخط والمربع (النيون) المتوافق مع الجوال
local function CleanAndApply(player)
    if player == LocalPlayer or not player.Character then return end
    
    local char = player.Character
    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    
    if root then
        -- 1. رسم المربع والتلوين (Highlight) من محرك اللعبة
        if not char:FindFirstChild("LeaderBoxESP") then
            local highlight = Instance.new("Highlight")
            highlight.Name = "LeaderBoxESP"
            highlight.FillColor = Color3.fromRGB(255, 0, 0) -- تعبئة حمراء
            highlight.FillTransparency = 0.6
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- إطار أبيض ساطع
            highlight.OutlineTransparency = 0
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Parent = char
        end
        
        -- 2. رسم الخط (Beam) من أسفل اللاعب إليك
        local myChar = LocalPlayer.Character
        local myRoot = myChar and (myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Torso"))
        
        if myRoot and not root:FindFirstChild("LeaderTracerBeam") then
            local att0 = Instance.new("Attachment")
            att0.Name = "LeaderAtt0"
            att0.Parent = myRoot
            
            local att1 = Instance.new("Attachment")
            att1.Name = "LeaderAtt1"
            att1.Parent = root
            
            local beam = Instance.new("Beam")
            beam.Name = "LeaderTracerBeam"
            beam.Color = ColorSequence.new(Color3.fromRGB(255, 255, 0)) -- خط أصفر مضيء
            beam.FaceCamera = true
            beam.Width0 = 0.2
            beam.Width1 = 0.2
            beam.Attachment0 = att0
            beam.Attachment1 = att1
            beam.Parent = root
        end
    end
end

-- حلقة تحديث سريعة جداً لمنع الاختفاء عند الموت
RunService.RenderStepped:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        pcall(function()
            CleanAndApply(player)
        end)
    end
end)
