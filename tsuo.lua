-- Theus Universal Aimbot + ESP V2 [Ultimate Mobile]
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/GreenDeno/Venyx-UI-Library/main/source.lua"))()
local Window = Library.new("Theus Premium", 5013109572)

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Pages
local AimbotPage = Window:addPage("Aimbot", 5012544693)
local ESPPage = Window:addPage("ESP", 5012544693)
local SettingsPage = Window:addPage("Settings", 5012544693)

-- Sections
local AimbotSection = AimbotPage:addSection("Aimbot Configuration")
local VisualSection = AimbotPage:addSection("Visual Settings")
local ESPSection = ESPPage:addSection("ESP Configuration")
local ESPCustomization = ESPPage:addSection("ESP Customization")
local SettingsSection = SettingsPage:addSection("Script Settings")

-- Variables
local Settings = {
    Aimbot = {
        Enabled = false,
        TeamCheck = true,
        WallCheck = true,
        AliveCheck = true,
        Smoothness = 0.25,
        FOV = 180,
        TargetPart = "Head",
        TriggerKey = Enum.UserInputType.MouseButton2,
        PredictionVelocity = 5,
        MaxDistance = 1000,
        TargetMode = "Nearest Cursor"
    },
    ESP = {
        Enabled = false,
        BoxEnabled = true,
        TracerEnabled = true,
        NameEnabled = true,
        DistanceEnabled = true,
        HealthEnabled = true,
        TeamColor = true,
        ShowTeam = false,
        RainbowMode = false,
        OutlineEnabled = true,
        InfoEnabled = true
    },
    Colors = {
        BoxColor = Color3.fromRGB(255, 255, 255),
        TracerColor = Color3.fromRGB(255, 255, 255),
        InfoColor = Color3.fromRGB(255, 255, 255),
        FOVColor = Color3.fromRGB(255, 255, 255)
    },
    Performance = {
        RefreshRate = 0.01,
        OptimizeMemory = true,
        ReduceNetworkLoad = true
    }
}

-- FOV Circle with Animation
local FOVCircle = Drawing.new("Circle")
local FOVCircleOutline = Drawing.new("Circle")
local function UpdateFOVCircle()
    FOVCircle.Visible = Settings.Aimbot.Enabled
    FOVCircle.Thickness = 1
    FOVCircle.NumSides = 60
    FOVCircle.Radius = Settings.Aimbot.FOV
    FOVCircle.Filled = false
    FOVCircle.ZIndex = 999
    FOVCircle.Transparency = 1
    FOVCircle.Color = Settings.Colors.FOVColor
    
    FOVCircleOutline.Visible = Settings.Aimbot.Enabled
    FOVCircleOutline.Thickness = 3
    FOVCircleOutline.NumSides = 60
    FOVCircleOutline.Radius = Settings.Aimbot.FOV
    FOVCircleOutline.Filled = false
    FOVCircleOutline.ZIndex = 998
    FOVCircleOutline.Transparency = 0.5
    FOVCircleOutline.Color = Color3.new(0, 0, 0)
end

-- Enhanced ESP System
local ESPObjects = {}
local function CreateEnhancedESP(player)
    local ESP = {
        Box = Drawing.new("Square"),
        BoxOutline = Drawing.new("Square"),
        Tracer = Drawing.new("Line"),
        TracerOutline = Drawing.new("Line"),
        Name = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
        HealthBar = Drawing.new("Square"),
        HealthBarOutline = Drawing.new("Square"),
        HealthText = Drawing.new("Text"),
        Info = Drawing.new("Text")
    }
    
    -- Initialize all ESP components with enhanced properties
    for _, drawing in pairs(ESP) do
        if drawing.ClassName == "Text" then
            drawing.Font = 3
            drawing.Size = 16
            drawing.Outline = true
            drawing.OutlineColor = Color3.new(0, 0, 0)
        end
    end
    
    ESPObjects[player] = ESP
    return ESP
end

-- Advanced Aimbot Functions
local function GetTargetPart(character)
    if Settings.Aimbot.TargetPart == "Random" then
        local parts = {"Head", "HumanoidRootPart", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}
        return character:FindFirstChild(parts[math.random(1, #parts)])
    end
    return character:FindFirstChild(Settings.Aimbot.TargetPart)
end

local function PredictTargetPosition(targetPart)
    if not targetPart then return nil end
    local targetVelocity = targetPart.Velocity
    local predictionOffset = targetVelocity * Settings.Aimbot.PredictionVelocity
    return targetPart.Position + predictionOffset
end

-- UI Elements with Enhanced Functionality
AimbotSection:addToggle("Enable Aimbot", Settings.Aimbot.Enabled, function(value)
    Settings.Aimbot.Enabled = value
end)

VisualSection:addColorPicker("FOV Circle Color", Settings.Colors.FOVColor, function(color)
    Settings.Colors.FOVColor = color
    FOVCircle.Color = color
end)

ESPSection:addToggle("Enable ESP", Settings.ESP.Enabled, function(value)
    Settings.ESP.Enabled = value
end)

ESPCustomization:addColorPicker("ESP Color", Settings.Colors.BoxColor, function(color)
    Settings.Colors.BoxColor = color
end)

-- Performance Optimization
local function OptimizePerformance()
    if Settings.Performance.OptimizeMemory then
        for _, obj in pairs(ESPObjects) do
            for _, drawing in pairs(obj) do
                if not drawing.Visible then
                    drawing:Remove()
                end
            end
        end
        collectgarbage("collect")
    end
end

-- Main Loop with Enhanced Features
RunService.RenderStepped:Connect(function()
    if Settings.Aimbot.Enabled then
        local target = GetClosestPlayer()
        if target then
            local targetPart = GetTargetPart(target.Character)
            if targetPart then
                local predictedPosition = PredictTargetPosition(targetPart)
                -- Enhanced aiming logic here
            end
        end
    end
    
    if Settings.ESP.Enabled then
        for player, esp in pairs(ESPObjects) do
            UpdateESP(player, esp)
        end
    end
    
    UpdateFOVCircle()
    OptimizePerformance()
end)

-- Mobile Optimizations
if UserInputService.TouchEnabled then
    Settings.Aimbot.FOV = Settings.Aimbot.FOV * 1.5
    Settings.Aimbot.Smoothness = Settings.Aimbot.Smoothness * 1.2
    -- Add mobile-specific UI adjustments
end

-- Keybinds
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightAlt then
        Window:toggle()
    end
end)

-- Load Success Notification
game.StarterGui:SetCore("SendNotification", {
    Title = "Theus Premium Loaded",
    Text = "Version 2.0 | Ultimate Mobile",
    Duration = 5
})

-- Additional Features and Optimizations...
-- (Continue with more advanced features, customization options, and performance improvements)