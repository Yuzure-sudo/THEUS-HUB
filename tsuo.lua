local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

getgenv().Settings = {
    Enabled = false,
    Prediction = 0.135,
    Smoothness = 0.2,
    TeamCheck = true,
    FOV = 250,
    AimPart = "HumanoidRootPart",
    ESP = {
        Enabled = true,
        TeamCheck = true,
        Box = true,
        Name = true
    }
}

local Target = nil
local Holding = false

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui

local LockButton = Instance.new("TextButton")
LockButton.Size = UDim2.new(0, 40, 0, 40)
LockButton.Position = UDim2.new(0.1, 0, 0.5, 0)
LockButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
LockButton.Text = "🎯"
LockButton.TextSize = 25
LockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
LockButton.Parent = ScreenGui

Instance.new("UICorner", LockButton).CornerRadius = UDim.new(1, 0)

-- Functions
local function GetClosestPlayer()
    local MaxDist = getgenv().Settings.FOV
    local Target = nil
    
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            if getgenv().Settings.TeamCheck and v.Team == LocalPlayer.Team then continue end
            
            local ScreenPos, OnScreen = Camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
            local Distance = (Vector2.new(ScreenPos.X, ScreenPos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
            
            if Distance < MaxDist and OnScreen then
                MaxDist = Distance
                Target = v
            end
        end
    end
    return Target
end

local function UpdateESP()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            if getgenv().Settings.TeamCheck and v.Team == LocalPlayer.Team then continue end
            
            local pos, onScreen = Camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
            if not onScreen then continue end
            
            if getgenv().Settings.ESP.Box then
                local BoxOutline = Drawing.new("Square")
                BoxOutline.Visible = true
                BoxOutline.Color = Color3.new(0, 0, 0)
                BoxOutline.Thickness = 3
                BoxOutline.Transparency = 1
                BoxOutline.Filled = false
                BoxOutline.Position = Vector2.new(pos.X - 32, pos.Y - 42)
                BoxOutline.Size = Vector2.new(60, 80)
                
                local Box = Drawing.new("Square")
                Box.Visible = true
                Box.Color = Color3.new(1, 1, 1)
                Box.Thickness = 1
                Box.Transparency = 1
                Box.Filled = false
                Box.Position = Vector2.new(pos.X - 32, pos.Y - 42)
                Box.Size = Vector2.new(60, 80)
                
                RunService.RenderStepped:Wait()
                BoxOutline:Remove()
                Box:Remove()
            end
            
            if getgenv().Settings.ESP.Name then
                local NameText = Drawing.new("Text")
                NameText.Visible = true
                NameText.Color = Color3.new(1, 1, 1)
                NameText.Text = v.Name
                NameText.Size = 16
                NameText.Center = true
                NameText.Outline = true
                NameText.Position = Vector2.new(pos.X, pos.Y - 65)
                
                RunService.RenderStepped:Wait()
                NameText:Remove()
            end
        end
    end
end

-- Events
LockButton.MouseButton1Down:Connect(function()
    Holding = true
    Target = GetClosestPlayer()
end)

LockButton.MouseButton1Up:Connect(function()
    Holding = false
    Target = nil
end)

LockButton.TouchLongPress:Connect(function()
    getgenv().Settings.Enabled = not getgenv().Settings.Enabled
    LockButton.BackgroundColor3 = getgenv().Settings.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(30, 30, 30)
end)

RunService.RenderStepped:Connect(function()
    if getgenv().Settings.ESP.Enabled then
        UpdateESP()
    end
    
    if getgenv().Settings.Enabled and Holding and Target and Target.Character and Target.Character:FindFirstChild(getgenv().Settings.AimPart) then
        local pos = Target.Character[getgenv().Settings.AimPart].Position
        local vel = Target.Character[getgenv().Settings.AimPart].Velocity
        
        pos = pos + (vel * getgenv().Settings.Prediction)
        
        local targetPos = Camera:WorldToScreenPoint(pos)
        local mousePos = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        local movePos = (Vector2.new(targetPos.X, targetPos.Y) - mousePos) * getgenv().Settings.Smoothness
        
        mousemoverel(movePos.X, movePos.Y)
    end
end)

LockButton.Draggable = true