-- Aimbot Universal + ESP [By Theus]
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Theus Script By Theus", "Ocean")

-- Tabs
local AimTab = Window:NewTab("Aimbot")
local ESPTab = Window:NewTab("ESP")
local SettingsTab = Window:NewTab("Settings")

-- Sections
local AimSection = AimTab:NewSection("Aimbot Settings")
local ESPSection = ESPTab:NewSection("ESP Settings")
local SettingsSection = SettingsTab:NewSection("Script Settings")

-- Aimbot
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")

local AimbotEnabled = false
local TeamCheck = true
local TargetPart = "Head"
local Sensitivity = 0.5

AimSection:NewToggle("Enable Aimbot", "Toggles aimbot functionality", function(state)
    AimbotEnabled = state
end)

AimSection:NewToggle("Team Check", "Don't target teammates", function(state)
    TeamCheck = state
end)

AimSection:NewDropdown("Target Part", "Select part to aim at", {"Head", "Torso"}, function(selected)
    TargetPart = selected
end)

AimSection:NewSlider("Sensitivity", "Adjust aimbot sensitivity", 100, 1, function(value)
    Sensitivity = value/100
end)

-- ESP Functions
local ESPEnabled = false
local BoxesEnabled = true
local NamesEnabled = true
local DistanceEnabled = true

ESPSection:NewToggle("Enable ESP", "Toggles ESP functionality", function(state)
    ESPEnabled = state
end)

ESPSection:NewToggle("Show Boxes", "Displays boxes around players", function(state)
    BoxesEnabled = state
end)

ESPSection:NewToggle("Show Names", "Displays player names", function(state)
    NamesEnabled = state
end)

ESPSection:NewToggle("Show Distance", "Shows distance to players", function(state)
    DistanceEnabled = state
end)

-- ESP Drawing
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

    local Distance = Drawing.new("Text")
    Distance.Visible = false
    Distance.Color = Color3.fromRGB(255, 255, 255)
    Distance.Size = 12
    Distance.Center = true
    Distance.Outline = true

    game:GetService("RunService").RenderStepped:Connect(function()
        if ESPEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local Vector, OnScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            
            if OnScreen and player ~= LocalPlayer then
                if TeamCheck and player.Team == LocalPlayer.Team then
                    Box.Color = Color3.fromRGB(0, 255, 0)
                else
                    Box.Color = Color3.fromRGB(255, 0, 0)
                end

                local RootPart = player.Character.HumanoidRootPart
                local Head = player.Character.Head
                local RootPosition = RootPart.Position
                local HeadPosition = Head.Position
                
                local TopLeft = Camera:WorldToViewportPoint(Vector3.new(RootPosition.X - 3, HeadPosition.Y + 2, RootPosition.Z - 3))
                local TopRight = Camera:WorldToViewportPoint(Vector3.new(RootPosition.X + 3, HeadPosition.Y + 2, RootPosition.Z + 3))
                local BottomLeft = Camera:WorldToViewportPoint(Vector3.new(RootPosition.X - 3, RootPosition.Y - 3, RootPosition.Z - 3))
                local BottomRight = Camera:WorldToViewportPoint(Vector3.new(RootPosition.X + 3, RootPosition.Y - 3, RootPosition.Z + 3))

                Box.Size = Vector2.new(TopRight.X - TopLeft.X, BottomLeft.Y - TopLeft.Y)
                Box.Position = Vector2.new(TopLeft.X, TopLeft.Y)
                Box.Visible = BoxesEnabled

                Name.Position = Vector2.new(TopLeft.X + Box.Size.X / 2, TopLeft.Y - 20)
                Name.Text = player.Name
                Name.Visible = NamesEnabled

                local dist = math.floor((RootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
                Distance.Position = Vector2.new(TopLeft.X + Box.Size.X / 2, BottomLeft.Y + 20)
                Distance.Text = tostring(dist) .. " studs"
                Distance.Visible = DistanceEnabled
            else
                Box.Visible = false
                Name.Visible = false
                Distance.Visible = false
            end
        else
            Box.Visible = false
            Name.Visible = false
            Distance.Visible = false
        end
    end)
end

-- Initialize ESP for existing players
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end

-- Initialize ESP for new players
Players.PlayerAdded:Connect(function(player)
    CreateESP(player)
end)

-- Aimbot Logic
game:GetService("RunService").RenderStepped:Connect(function()
    if AimbotEnabled then
        local closest = math.huge
        local target = nil
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(TargetPart) then
                if TeamCheck and player.Team == LocalPlayer.Team then continue end
                
                local pos = Camera:WorldToViewportPoint(player.Character[TargetPart].Position)
                local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).magnitude
                
                if magnitude < closest then
                    closest = magnitude
                    target = player.Character[TargetPart]
                end
            end
        end
        
        if target then
            local pos = Camera:WorldToViewportPoint(target.Position)
            mousemoverel((pos.X - Mouse.X) * Sensitivity, (pos.Y - Mouse.Y) * Sensitivity)
        end
    end
end)

-- Settings
SettingsSection:NewKeybind("Toggle UI", "Shows/Hides the UI", Enum.KeyCode.RightControl, function()
    Library:ToggleUI()
end)

-- Notification
game.StarterGui:SetCore("SendNotification", {
    Title = "Script Loaded!",
    Text = "Made by Theus",
    Duration = 3
})