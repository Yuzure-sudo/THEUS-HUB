-- Theus Universal Aimbot + ESP [Mobile Optimized]
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/Slash"))()
local Window = Library:Create("Theus Script","Mobile Edition")

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Main Page
local MainPage = Window:Page("Main")
local AimbotSection = MainPage:Section("Aimbot")
local ESPSection = MainPage:Section("ESP")

-- Variables
local AimbotEnabled = false
local ESPEnabled = false
local TeamCheck = true
local WallCheck = true
local Smoothness = 0.25
local FOV = 180
local SelectedPart = "Head"

-- FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.NumSides = 60
FOVCircle.Radius = FOV
FOVCircle.Filled = false
FOVCircle.Visible = false
FOVCircle.ZIndex = 999
FOVCircle.Transparency = 1
FOVCircle.Color = Color3.fromRGB(255, 255, 255)

-- Aimbot Functions
local function GetClosestPlayer()
    local MaxDist = FOV
    local Target = nil
    
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 and v.Character:FindFirstChild(SelectedPart) then
            if TeamCheck and v.Team == LocalPlayer.Team then continue end
            
            local ScreenPos, OnScreen = Camera:WorldToViewportPoint(v.Character[SelectedPart].Position)
            local Distance = (Vector2.new(ScreenPos.X, ScreenPos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
            
            if Distance < MaxDist and OnScreen then
                if WallCheck then
                    local ray = Ray.new(Camera.CFrame.Position, (v.Character[SelectedPart].Position - Camera.CFrame.Position).Unit * 2000)
                    local hit = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character, Camera})
                    if hit and hit:IsDescendantOf(v.Character) then
                        MaxDist = Distance
                        Target = v
                    end
                else
                    MaxDist = Distance
                    Target = v
                end
            end
        end
    end
    return Target
end

-- ESP Functions
local function CreateESP(player)
    local Box = Drawing.new("Square")
    local Tracer = Drawing.new("Line")
    local Name = Drawing.new("Text")
    local Distance = Drawing.new("Text")
    local HealthBar = Drawing.new("Square")
    local HealthBarBG = Drawing.new("Square")
    
    Box.Visible = false
    Box.Color = Color3.fromRGB(255, 255, 255)
    Box.Thickness = 1
    Box.Transparency = 1
    Box.Filled = false
    
    Tracer.Visible = false
    Tracer.Color = Color3.fromRGB(255, 255, 255)
    Tracer.Thickness = 1
    Tracer.Transparency = 1
    
    Name.Visible = false
    Name.Color = Color3.fromRGB(255, 255, 255)
    Name.Size = 14
    Name.Center = true
    Name.Outline = true
    
    Distance.Visible = false
    Distance.Color = Color3.fromRGB(255, 255, 255)
    Distance.Size = 12
    Distance.Center = true
    Distance.Outline = true
    
    HealthBar.Visible = false
    HealthBar.Color = Color3.fromRGB(0, 255, 0)
    HealthBar.Thickness = 1
    HealthBar.Filled = true
    
    HealthBarBG.Visible = false
    HealthBarBG.Color = Color3.fromRGB(0, 0, 0)
    HealthBarBG.Thickness = 1
    HealthBarBG.Filled = true

    local function UpdateESP()
        local character = player.Character
        if not character or not ESPEnabled then
            Box.Visible = false
            Tracer.Visible = false
            Name.Visible = false
            Distance.Visible = false
            HealthBar.Visible = false
            HealthBarBG.Visible = false
            return
        end

        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChild("Humanoid")
        if not humanoidRootPart or not humanoid then return end

        local vector, onScreen = Camera:WorldToViewportPoint(humanoidRootPart.Position)
        if not onScreen then
            Box.Visible = false
            Tracer.Visible = false
            Name.Visible = false
            Distance.Visible = false
            HealthBar.Visible = false
            HealthBarBG.Visible = false
            return
        end

        local rootPos = humanoidRootPart.Position
        local headPos = (character:FindFirstChild("Head") and character.Head.Position) or (rootPos + Vector3.new(0, 2, 0))
        
        local screenRootPos = Camera:WorldToViewportPoint(rootPos)
        local screenHeadPos = Camera:WorldToViewportPoint(headPos)
        
        local boxHeight = math.abs(screenHeadPos.Y - screenRootPos.Y)
        local boxWidth = boxHeight * 0.6
        
        Box.Size = Vector2.new(boxWidth, boxHeight)
        Box.Position = Vector2.new(screenHeadPos.X - boxWidth/2, screenHeadPos.Y)
        Box.Visible = true
        
        Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
        Tracer.To = Vector2.new(screenRootPos.X, screenRootPos.Y)
        Tracer.Visible = true
        
        Name.Position = Vector2.new(screenHeadPos.X, screenHeadPos.Y - 20)
        Name.Text = player.Name
        Name.Visible = true
        
        local distance = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - rootPos).Magnitude)
        Distance.Position = Vector2.new(screenRootPos.X, screenRootPos.Y + 20)
        Distance.Text = tostring(distance).." studs"
        Distance.Visible = true
        
        local healthBarHeight = boxHeight
        local healthBarWidth = 4
        local healthPercentage = humanoid.Health/humanoid.MaxHealth
        
        HealthBarBG.Size = Vector2.new(healthBarWidth, healthBarHeight)
        HealthBarBG.Position = Vector2.new(Box.Position.X - healthBarWidth*2, Box.Position.Y)
        HealthBarBG.Visible = true
        
        HealthBar.Size = Vector2.new(healthBarWidth, healthBarHeight * healthPercentage)
        HealthBar.Position = Vector2.new(Box.Position.X - healthBarWidth*2, Box.Position.Y + healthBarHeight * (1-healthPercentage))
        HealthBar.Color = Color3.fromRGB(255 * (1-healthPercentage), 255 * healthPercentage, 0)
        HealthBar.Visible = true
    end
    
    RunService.RenderStepped:Connect(UpdateESP)
end

-- UI Elements
AimbotSection:Toggle("Enable Aimbot", false, function(value)
    AimbotEnabled = value
end)

AimbotSection:Toggle("Team Check", true, function(value)
    TeamCheck = value
end)

AimbotSection:Toggle("Wall Check", true, function(value)
    WallCheck = value
end)

AimbotSection:Toggle("Show FOV", false, function(value)
    FOVCircle.Visible = value
end)

AimbotSection:Slider("FOV", 0, 500, 180, function(value)
    FOV = value
    FOVCircle.Radius = value
end)

AimbotSection:Slider("Smoothness", 0, 100, 25, function(value)
    Smoothness = value/100
end)

AimbotSection:Dropdown("Target Part", {"Head", "HumanoidRootPart", "Torso"}, function(value)
    SelectedPart = value
end)

ESPSection:Toggle("Enable ESP", false, function(value)
    ESPEnabled = value
end)

-- Initialize
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    CreateESP(player)
end)

-- Aimbot Loop
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    
    if AimbotEnabled then
        local Target = GetClosestPlayer()
        if Target and Target.Character and Target.Character:FindFirstChild(SelectedPart) then
            local TargetPos = Camera:WorldToViewportPoint(Target.Character[SelectedPart].Position)
            local MousePos = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
            local NewPos = Vector2.new(
                (TargetPos.X - MousePos.X) * Smoothness,
                (TargetPos.Y - MousePos.Y) * Smoothness
            )
            mousemoverel(NewPos.X, NewPos.Y)
        end
    end
end)

-- Mobile Optimization
if UserInputService.TouchEnabled then
    -- Add mobile-specific optimizations here
    FOVCircle.Radius = FOV * 1.5 -- Larger FOV for mobile
    Smoothness = Smoothness * 1.2 -- Adjusted smoothness for mobile
end

-- Notification
game.StarterGui:SetCore("SendNotification", {
    Title = "Theus Script Loaded!",
    Text = "Mobile Version | Press RightAlt to toggle UI",
    Duration = 3
})