local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

_G.Settings = {
    Enabled = false,
    Prediction = 0.12,
    Smoothness = 0.1,
    TeamCheck = true,
    ESP = {
        Enabled = true,
        TeamCheck = true,
        BoxEnabled = true,
        NameEnabled = true
    }
}

local Target = nil

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui

local Button = Instance.new("TextButton") 
Button.Size = UDim2.new(0, 35, 0, 35)
Button.Position = UDim2.new(0.1, 0, 0.5, 0)
Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Button.Text = "🎯"
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.TextSize = 20
Button.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(1, 0)
Corner.Parent = Button

local function getClosest()
    local closest, distance = nil, math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if _G.Settings.TeamCheck and player.Team == LocalPlayer.Team then continue end
            
            local pos = Camera:WorldToScreenPoint(player.Character.HumanoidRootPart.Position)
            local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
            
            if magnitude < distance then
                closest = player
                distance = magnitude
            end
        end
    end
    
    return closest
end

local function ESP(player)
    if not player.Character or not _G.Settings.ESP.Enabled then return end
    if _G.Settings.ESP.TeamCheck and player.Team == LocalPlayer.Team then return end
    
    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    local pos, onScreen = Camera:WorldToScreenPoint(humanoidRootPart.Position)
    if not onScreen then return end
    
    if _G.Settings.ESP.BoxEnabled then
        local box = Drawing.new("Square")
        box.Visible = true
        box.Color = Color3.new(1, 1, 1)
        box.Thickness = 1
        box.Size = Vector2.new(35, 50)
        box.Position = Vector2.new(pos.X - 17.5, pos.Y - 25)
    end
    
    if _G.Settings.ESP.NameEnabled then
        local name = Drawing.new("Text")
        name.Visible = true
        name.Color = Color3.new(1, 1, 1)
        name.Size = 13
        name.Center = true
        name.Text = player.Name
        name.Position = Vector2.new(pos.X, pos.Y - 60)
    end
end

local function updateButton()
    Button.BackgroundColor3 = _G.Settings.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(30, 30, 30)
end

Button.TouchLongPress:Connect(function()
    _G.Settings.Enabled = not _G.Settings.Enabled
    updateButton()
end)

Button.TouchTap:Connect(function()
    Target = getClosest()
end)

Button.TouchEnded:Connect(function()
    Target = nil
end)

RunService.RenderStepped:Connect(function()
    if _G.Settings.Enabled and Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
        local pos = Target.Character.HumanoidRootPart.Position
        local vel = Target.Character.HumanoidRootPart.Velocity
        
        pos = pos + (vel * _G.Settings.Prediction)
        
        local targetPos = Camera:WorldToScreenPoint(pos)
        local movePos = (Vector2.new(targetPos.X, targetPos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)) * _G.Settings.Smoothness
        
        mousemoverel(movePos.X, movePos.Y)
    end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            ESP(player)
        end
    end
end)

Button.Draggable = true