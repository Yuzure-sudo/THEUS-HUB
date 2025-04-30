local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wally2"))()
local Window = Lib:CreateWindow("THEUS PREMIUM")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Config = {
    Aim = {
        Enabled = true,
        Target = "Head",
        FOV = 500,
        Prediction = 0.165,
        AutoShoot = true,
        TeamCheck = false,
        WallCheck = false,
        Smooth = true,
        SmoothValue = 0.5
    },
    ESP = {
        Enabled = true,
        Box = true,
        Tracer = true,
        Name = true,
        Distance = true,
        BoxColor = Color3.fromRGB(255,0,0),
        TracerColor = Color3.fromRGB(255,0,0),
        TextColor = Color3.fromRGB(255,255,255),
        BoxTrans = 0.3,
        TextSize = 14,
        MaxDistance = 2000
    }
}

local MainTab = Window:NewTab("MAIN")
local AimSection = MainTab:NewSection("AIM")
local VisualSection = MainTab:NewSection("VISUAL")

AimSection:NewToggle("AIM", "", function(state)
    Config.Aim.Enabled = state
end)

AimSection:NewDropdown("PART", "", {"Head","HumanoidRootPart"}, function(part)
    Config.Aim.Target = part
end)

AimSection:NewSlider("FOV", "", 1000, 10, function(value)
    Config.Aim.FOV = value
end)

AimSection:NewSlider("PREDICTION", "", 1, 0, function(value)
    Config.Aim.Prediction = value
end)

AimSection:NewToggle("AUTO SHOOT", "", function(state)
    Config.Aim.AutoShoot = state
end)

VisualSection:NewToggle("ESP", "", function(state)
    Config.ESP.Enabled = state
end)

VisualSection:NewToggle("BOX", "", function(state)
    Config.ESP.Box = state
end)

VisualSection:NewToggle("TRACER", "", function(state)
    Config.ESP.Tracer = state
end)

local function DrawESP()
    for _,v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer then
            local Box = Drawing.new("Square")
            local Tracer = Drawing.new("Line")
            local Name = Drawing.new("Text")
            
            RunService.RenderStepped:Connect(function()
                if v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and Config.ESP.Enabled then
                    local Vector, OnScreen = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                    local Distance = (Camera.CFrame.Position - v.Character.HumanoidRootPart.Position).Magnitude
                    
                    if OnScreen and Distance <= Config.ESP.MaxDistance then
                        if Config.ESP.Box then
                            Box.Visible = true
                            Box.Color = Config.ESP.BoxColor
                            Box.Transparency = Config.ESP.BoxTrans
                            Box.Size = Vector2.new(2000/Distance, 2500/Distance)
                            Box.Position = Vector2.new(Vector.X - Box.Size.X/2, Vector.Y - Box.Size.Y/2)
                            Box.Thickness = 1
                            Box.Filled = false
                        else
                            Box.Visible = false
                        end
                        
                        if Config.ESP.Tracer then
                            Tracer.Visible = true
                            Tracer.Color = Config.ESP.TracerColor
                            Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                            Tracer.To = Vector2.new(Vector.X, Vector.Y)
                            Tracer.Thickness = 1
                        else
                            Tracer.Visible = false
                        end
                        
                        if Config.ESP.Name then
                            Name.Visible = true
                            Name.Color = Config.ESP.TextColor
                            Name.Text = v.Name.." ["..math.floor(Distance).."]"
                            Name.Center = true
                            Name.Outline = true
                            Name.Position = Vector2.new(Vector.X, Vector.Y - Box.Size.Y/2 - 16)
                            Name.Size = Config.ESP.TextSize
                        else
                            Name.Visible = false
                        end
                    else
                        Box.Visible = false
                        Tracer.Visible = false
                        Name.Visible = false
                    end
                else
                    Box.Visible = false
                    Tracer.Visible = false
                    Name.Visible = false
                end
            end)
        end
    end
end

local function GetClosestPlayer()
    local Target = nil
    local MaxDist = Config.Aim.FOV
    for _,v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild(Config.Aim.Target) and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            if Config.Aim.TeamCheck and v.Team == LocalPlayer.Team then continue end
            local Vector = Camera:WorldToScreenPoint(v.Character[Config.Aim.Target].Position)
            local Distance = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(Vector.X, Vector.Y)).Magnitude
            if Distance < MaxDist then
                MaxDist = Distance
                Target = v
            end
        end
    end
    return Target
end

RunService.RenderStepped:Connect(function()
    if Config.Aim.Enabled then
        local Target = GetClosestPlayer()
        if Target then
            local Position = Target.Character[Config.Aim.Target].Position
            local Velocity = Target.Character[Config.Aim.Target].Velocity
            local Prediction = Position + (Velocity * Config.Aim.Prediction)
            if Config.Aim.Smooth then
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, Prediction), Config.Aim.SmoothValue)
            else
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, Prediction)
            end
            if Config.Aim.AutoShoot then mouse1click() end
        end
    end
end)

DrawESP()
Players.PlayerAdded:Connect(DrawESP)