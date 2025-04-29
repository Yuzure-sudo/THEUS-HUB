-- Script FPS Aimbot + ESP + Auto Farm
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Interface
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local Container = Instance.new("Frame")
local AimbotToggle = Instance.new("TextButton")
local ESPToggle = Instance.new("TextButton")
local AutoFarmToggle = Instance.new("TextButton")

-- Settings
_G.Settings = {
    Aimbot = {
        Enabled = false,
        TeamCheck = true,
        TargetPart = "Head",
        Smoothness = 0.1,
        FOV = 400
    },
    ESP = {
        Enabled = false,
        TeamCheck = true,
        BoxesEnabled = true,
        NamesEnabled = true
    },
    AutoFarm = {
        Enabled = false,
        Range = 15
    }
}

-- Interface Setup
ScreenGui.Parent = game.CoreGui
MainFrame.Size = UDim2.new(0, 200, 0, 160)
MainFrame.Position = UDim2.new(0.8, 0, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Parent = ScreenGui

Title.Text = "Combat Hub"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Parent = MainFrame

Container.Position = UDim2.new(0, 0, 0, 35)
Container.Size = UDim2.new(1, 0, 1, -35)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

-- Buttons
local function CreateButton(name, position)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.9, 0, 0, 30)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = name
    button.Parent = Container
    return button
end

AimbotToggle = CreateButton("Aimbot: OFF", UDim2.new(0.05, 0, 0, 10))
ESPToggle = CreateButton("ESP: OFF", UDim2.new(0.05, 0, 0, 50))
AutoFarmToggle = CreateButton("Auto Farm: OFF", UDim2.new(0.05, 0, 0, 90))

-- ESP Functions
local function CreateESP(player)
    local Box = Drawing.new("Square")
    Box.Visible = false
    Box.Color = Color3.fromRGB(255, 0, 0)
    Box.Thickness = 1
    Box.Transparency = 1
    Box.Filled = false

    local Name = Drawing.new("Text")
    Name.Visible = false
    Name.Color = Color3.fromRGB(255, 255, 255)
    Name.Size = 14
    Name.Center = true
    Name.Outline = true

    RunService.RenderStepped:Connect(function()
        if not _G.Settings.ESP.Enabled then
            Box.Visible = false
            Name.Visible = false
            return
        end

        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local humanoidRootPart = player.Character.HumanoidRootPart
            local vector, onScreen = Camera:WorldToViewportPoint(humanoidRootPart.Position)
            
            if onScreen and player ~= LocalPlayer then
                if _G.Settings.ESP.TeamCheck and player.Team == LocalPlayer.Team then
                    Box.Visible = false
                    Name.Visible = false
                    return
                end

                local rootPosition = player.Character.HumanoidRootPart.Position
                local headPosition = player.Character.Head.Position
                local screenPosition = Camera:WorldToViewportPoint(rootPosition)
                
                Box.Size = Vector2.new(1000 / screenPosition.Z, 1000 / screenPosition.Z)
                Box.Position = Vector2.new(screenPosition.X - Box.Size.X / 2, screenPosition.Y - Box.Size.Y / 2)
                Box.Visible = _G.Settings.ESP.BoxesEnabled
                
                Name.Position = Vector2.new(screenPosition.X, screenPosition.Y - Box.Size.Y / 2 - 15)
                Name.Text = player.Name
                Name.Visible = _G.Settings.ESP.NamesEnabled
            else
                Box.Visible = false
                Name.Visible = false
            end
        end
    end)
end

-- Aimbot Function
local function GetClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = _G.Settings.Aimbot.FOV

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(_G.Settings.Aimbot.TargetPart) then
            if _G.Settings.Aimbot.TeamCheck and player.Team == LocalPlayer.Team then
                continue
            end

            local pos = Camera:WorldToViewportPoint(player.Character[_G.Settings.Aimbot.TargetPart].Position)
            local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).magnitude

            if magnitude < shortestDistance then
                closestPlayer = player
                shortestDistance = magnitude
            end
        end
    end

    return closestPlayer
end

-- Auto Farm Function
local function AutoFarm()
    while _G.Settings.AutoFarm.Enabled do
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                if _G.Settings.AutoFarm.TeamCheck and player.Team == LocalPlayer.Team then
                    continue
                end

                local distance = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).magnitude
                if distance <= _G.Settings.AutoFarm.Range then
                    local args = {
                        [1] = player.Character.Humanoid,
                        [2] = player.Character.HumanoidRootPart.Position
                    }
                    game:GetService("ReplicatedStorage").RemoteEvent:FireServer(unpack(args))
                end
            end
        end
        wait(0.1)
    end
end

-- Button Functions
AimbotToggle.MouseButton1Click:Connect(function()
    _G.Settings.Aimbot.Enabled = not _G.Settings.Aimbot.Enabled
    AimbotToggle.Text = "Aimbot: " .. (_G.Settings.Aimbot.Enabled and "ON" or "OFF")
end)

ESPToggle.MouseButton1Click:Connect(function()
    _G.Settings.ESP.Enabled = not _G.Settings.ESP.Enabled
    ESPToggle.Text = "ESP: " .. (_G.Settings.ESP.Enabled and "ON" or "OFF")
end)

AutoFarmToggle.MouseButton1Click:Connect(function()
    _G.Settings.AutoFarm.Enabled = not _G.Settings.AutoFarm.Enabled
    AutoFarmToggle.Text = "Auto Farm: " .. (_G.Settings.AutoFarm.Enabled and "ON" or "OFF")
    if _G.Settings.AutoFarm.Enabled then
        AutoFarm()
    end
end)

-- Main Loop
RunService.RenderStepped:Connect(function()
    if _G.Settings.Aimbot.Enabled then
        local target = GetClosestPlayer()
        if target and target.Character then
            local pos = Camera:WorldToViewportPoint(target.Character[_G.Settings.Aimbot.TargetPart].Position)
            mousemoverel(
                (pos.X - Mouse.X) * _G.Settings.Aimbot.Smoothness,
                (pos.Y - Mouse.Y) * _G.Settings.Aimbot.Smoothness
            )
        end
    end
end)

-- Initialize ESP for all players
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    CreateESP(player)
end)

-- Toggle GUI
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightAlt then
        MainFrame.Visible = not MainFrame.Visible
    end
end)