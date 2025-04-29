-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Variables
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.NumSides = 100
FOVCircle.Radius = _G.Settings.Aimbot.FOV
FOVCircle.Filled = false
FOVCircle.Visible = _G.Settings.Aimbot.ShowFOV
FOVCircle.ZIndex = 999
FOVCircle.Transparency = 1
FOVCircle.Color = Color3.fromRGB(255, 255, 255)

-- Functions
local function GetClosestPlayer()
    local MaxDist = _G.Settings.Aimbot.FOV
    local Target = nil
    
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer then
            if v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 and v.Character:FindFirstChild(_G.Settings.Aimbot.TargetPart) and v.Character:FindFirstChild("HumanoidRootPart") then
                if _G.Settings.Aimbot.TeamCheck and v.Team == LocalPlayer.Team then continue end
                
                local ScreenPoint = Camera:WorldToScreenPoint(v.Character[_G.Settings.Aimbot.TargetPart].Position)
                local VectorDistance = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude
                
                if VectorDistance < MaxDist then
                    MaxDist = VectorDistance
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
    
    ESPContainer[player] = {
        Box = Box,
        Tracer = Tracer,
        Name = Name
    }
end

local function UpdateESP()
    for player, drawings in pairs(ESPContainer) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local Vector, OnScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            
            if OnScreen and (_G.Settings.ESP.TeamCheck == false or player.Team ~= LocalPlayer.Team) then
                local RootPart = player.Character.HumanoidRootPart
                local Head = player.Character.Head
                local RootPosition = RootPart.Position
                local HeadPosition = Head.Position + Vector3.new(0, 0.5, 0)
                local LegPosition = RootPosition - Vector3.new(0, 3, 0)
                
                -- Box ESP
                local BoxSize = Vector2.new(2000 / Vector.Z, HeadPosition.Y - LegPosition.Y)
                local BoxPosition = Vector2.new(Vector.X - BoxSize.X / 2, Vector.Y - BoxSize.Y / 2)
                
                drawings.Box.Size = BoxSize
                drawings.Box.Position = BoxPosition
                drawings.Box.Visible = _G.Settings.ESP.Enabled
                drawings.Box.Color = Color3.fromRGB(255, 255, 255)
                drawings.Box.Thickness = 1
                drawings.Box.Filled = false
                
                -- Tracer ESP
                drawings.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                drawings.Tracer.To = Vector2.new(Vector.X, Vector.Y)
                drawings.Tracer.Visible = _G.Settings.ESP.Enabled
                drawings.Tracer.Color = Color3.fromRGB(255, 255, 255)
                drawings.Tracer.Thickness = 1
                
                -- Name ESP
                drawings.Name.Text = player.Name
                drawings.Name.Position = Vector2.new(Vector.X, Vector.Y - BoxSize.Y / 2 - 15)
                drawings.Name.Visible = _G.Settings.ESP.Enabled
                drawings.Name.Color = Color3.fromRGB(255, 255, 255)
                drawings.Name.Size = 14
                drawings.Name.Center = true
                drawings.Name.Outline = true
            else
                drawings.Box.Visible = false
                drawings.Tracer.Visible = false
                drawings.Name.Visible = false
            end
        else
            drawings.Box.Visible = false
            drawings.Tracer.Visible = false
            drawings.Name.Visible = false
        end
    end
end

-- GUI Functions
local function CreateToggle(name, parent, default, callback)
    local ToggleFrame = Instance.new("Frame")
    local ToggleButton = Instance.new("TextButton")
    local UICorner = Instance.new("UICorner")
    local Title = Instance.new("TextLabel")
    
    ToggleFrame.Name = name.."Toggle"
    ToggleFrame.Parent = parent
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Size = UDim2.new(1, 0, 0, 30)
    
    ToggleButton.Name = "Button"
    ToggleButton.Parent = ToggleFrame
    ToggleButton.BackgroundColor3 = default and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    ToggleButton.Position = UDim2.new(1, -40, 0.5, -10)
    ToggleButton.Size = UDim2.new(0, 20, 0, 20)
    ToggleButton.Font = Enum.Font.SourceSans
    ToggleButton.Text = ""
    
    UICorner.Parent = ToggleButton
    UICorner.CornerRadius = UDim.new(0, 4)
    
    Title.Name = "Title"
    Title.Parent = ToggleFrame
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.Size = UDim2.new(1, -60, 1, 0)
    Title.Font = Enum.Font.Gotham
    Title.Text = name
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    local toggled = default
    
    ToggleButton.MouseButton1Click:Connect(function()
        toggled = not toggled
        ToggleButton.BackgroundColor3 = toggled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        callback(toggled)
    end)
end

-- Create GUI Elements
local AimbotSection = Instance.new("Frame")
AimbotSection.Name = "AimbotSection"
AimbotSection.Parent = Container
AimbotSection.BackgroundTransparency = 1
AimbotSection.Position = UDim2.new(0, 10, 0, 10)
AimbotSection.Size = UDim2.new(1, -20, 0, 120)

CreateToggle("Aimbot", AimbotSection, _G.Settings.Aimbot.Enabled, function(value)
    _G.Settings.Aimbot.Enabled = value
end)

CreateToggle("Show FOV", AimbotSection, _G.Settings.Aimbot.ShowFOV, function(value)
    _G.Settings.Aimbot.ShowFOV = value
    FOVCircle.Visible = value
end)

CreateToggle("Team Check", AimbotSection, _G.Settings.Aimbot.TeamCheck, function(value)
    _G.Settings.Aimbot.TeamCheck = value
end)

CreateToggle("No Recoil", AimbotSection, _G.Settings.Aimbot.NoRecoil, function(value)
    _G.Settings.Aimbot.NoRecoil = value
end)

local ESPSection = Instance.new("Frame")
ESPSection.Name = "ESPSection"
ESPSection.Parent = Container
ESPSection.BackgroundTransparency = 1
ESPSection.Position = UDim2.new(0, 10, 0, 140)
ESPSection.Size = UDim2.new(1, -20, 0, 60)

CreateToggle("ESP", ESPSection, _G.Settings.ESP.Enabled, function(value)
    _G.Settings.ESP.Enabled = value
end)

CreateToggle("ESP Team Check", ESPSection, _G.Settings.ESP.TeamCheck, function(value)
    _G.Settings.ESP.TeamCheck = value
end)

-- Initialize ESP
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    CreateESP(player)
end)

Players.PlayerRemoving:Connect(function(player)
    if ESPContainer[player] then
        for _, drawing in pairs(ESPContainer[player]) do
            drawing:Remove()
        end
        ESPContainer[player] = nil
    end
end)

-- Main Loop
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
    
    if _G.Settings.Aimbot.Enabled then
        local Target = GetClosestPlayer()
        if Target then
            local TargetPos = Target.Character[_G.Settings.Aimbot.TargetPart].Position
            local ScreenPos = Camera:WorldToScreenPoint(TargetPos)
            local MousePos = Vector2.new(Mouse.X, Mouse.Y)
            local NewPos = Vector2.new(ScreenPos.X, ScreenPos.Y)
            
            mousemoverel(
                (NewPos.X - MousePos.X) * _G.Settings.Aimbot.Smoothness,
                (NewPos.Y - MousePos.Y) * _G.Settings.Aimbot.Smoothness
            )
        end
    end
    
    UpdateESP()
end)

-- Minimize Button
MinimizeBtn.MouseButton1Click:Connect(function()
    Container.Visible = not Container.Visible
end)