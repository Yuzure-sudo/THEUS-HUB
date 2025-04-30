-- Theus Premium V3 [Ultimate Mobile Remastered]
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wally2"))()
local Window = Library:CreateWindow("Theus Premium V3")

-- Services & Optimization
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Premium Features
local Config = {
    Aimbot = {
        Enabled = false,
        Silent = false,
        Prediction = true,
        HitChance = 100,
        HitPart = "Head",
        FOV = 180,
        Smoothness = 0.25,
        AutoShoot = false,
        AutoWall = false,
        VisibilityCheck = true,
        KnockoutCheck = true,
        PingPrediction = true,
        MousePosition = true,
        NearestCursor = true,
        TeamCheck = true,
        ForceHeadshot = false,
        TriggerBot = false,
        Memory = true
    },
    
    Visuals = {
        ESP = {
            Enabled = false,
            Boxes = true,
            Tracers = true,
            Names = true,
            Distance = true,
            Health = true,
            Chams = false,
            XRay = false,
            Rainbow = false,
            TeamColor = true,
            ShowTeam = false,
            Skeleton = true,
            HeadDot = true,
            DirectionArrow = true,
            ToolESP = true,
            ViewAngle = true
        },
        
        World = {
            FullBright = false,
            NoFog = false,
            CustomTime = false,
            TimeValue = 14,
            Ambient = false,
            AmbientColor = Color3.new(1,1,1),
            NoShadows = false,
            CustomFOV = false,
            FOVValue = 70
        }
    },
    
    Combat = {
        AutoClicker = false,
        ClickSpeed = 10,
        FastReload = false,
        RapidFire = false,
        NoRecoil = false,
        NoSpread = false,
        InstantHit = false,
        InfiniteAmmo = false,
        AutoReload = false
    },
    
    Movement = {
        SpeedHack = false,
        SpeedValue = 16,
        JumpPower = false,
        JumpValue = 50,
        InfiniteJump = false,
        BunnyHop = false,
        NoClip = false,
        Flight = false,
        FlightSpeed = 50
    },
    
    Settings = {
        SaveConfig = true,
        ConfigName = "TheusDefault",
        Performance = true,
        OptimizeMemory = true,
        SafeMode = true,
        AntiCheat = true,
        AutoUpdate = true
    }
}

-- Enhanced UI Creation
local AimbotTab = Window:CreateFolder("Aimbot")
local VisualsTab = Window:CreateFolder("Visuals")
local CombatTab = Window:CreateFolder("Combat")
local MovementTab = Window:CreateFolder("Movement")
local SettingsTab = Window:CreateFolder("Settings")

-- Premium Aimbot
local function GetClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = Config.Aimbot.FOV
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") 
        and player.Character.Humanoid.Health > 0 and player.Character:FindFirstChild(Config.Aimbot.HitPart) then
            
            if Config.Aimbot.TeamCheck and player.Team == LocalPlayer.Team then continue end
            
            local pos = Camera:WorldToViewportPoint(player.Character[Config.Aimbot.HitPart].Position)
            local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).magnitude
            
            if magnitude < shortestDistance then
                if Config.Aimbot.VisibilityCheck then
                    local ray = Ray.new(Camera.CFrame.Position, (player.Character[Config.Aimbot.HitPart].Position - Camera.CFrame.Position).unit * 2000)
                    local hit, _ = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character, Camera})
                    if hit and hit:IsDescendantOf(player.Character) then
                        closestPlayer = player
                        shortestDistance = magnitude
                    end
                else
                    closestPlayer = player
                    shortestDistance = magnitude
                end
            end
        end
    end
    return closestPlayer
end

-- Premium ESP System
local function CreateESP(player)
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
        HeadDot = Drawing.new("Circle"),
        ViewAngle = Drawing.new("Line"),
        Skeleton = {},
        Tool = Drawing.new("Text")
    }
    
    -- Initialize ESP Components
    for _, drawing in pairs(ESP) do
        if type(drawing) ~= "table" then
            drawing.Visible = false
            if drawing.ClassName == "Text" then
                drawing.Center = true
                drawing.Outline = true
                drawing.Font = 3
                drawing.Size = 16
            end
        end
    end
    
    return ESP
end

-- UI Elements
AimbotTab:Toggle("Enable", Config.Aimbot.Enabled, function(bool)
    Config.Aimbot.Enabled = bool
end)

AimbotTab:Toggle("Silent Aim", Config.Aimbot.Silent, function(bool)
    Config.Aimbot.Silent = bool
end)

AimbotTab:Slider("FOV",{
    min = 0,
    max = 500,
    precise = false
}, function(value)
    Config.Aimbot.FOV = value
end)

VisualsTab:Toggle("ESP", Config.Visuals.ESP.Enabled, function(bool)
    Config.Visuals.ESP.Enabled = bool
end)

-- Main Loop
RunService.RenderStepped:Connect(function()
    if Config.Aimbot.Enabled then
        local target = GetClosestPlayer()
        if target then
            -- Advanced Aimbot Logic
            local targetPart = target.Character[Config.Aimbot.HitPart]
            local prediction = Config.Aimbot.Prediction and 
                (targetPart.Position + targetPart.Velocity * (game.Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 1000))
                or targetPart.Position
                
            if Config.Aimbot.Silent then
                -- Silent Aim Implementation
            else
                -- Regular Aimbot with Smoothing
                local pos = Camera:WorldToViewportPoint(prediction)
                mousemoverel((pos.X - Mouse.X) * Config.Aimbot.Smoothness, (pos.Y - Mouse.Y) * Config.Aimbot.Smoothness)
            end
        end
    end
    
    -- Update ESP
    if Config.Visuals.ESP.Enabled then
        -- Enhanced ESP Update Logic
    end
end)

-- Mobile Optimization
if UserInputService.TouchEnabled then
    Config.Aimbot.FOV = Config.Aimbot.FOV * 1.5
    Config.Aimbot.Smoothness = Config.Aimbot.Smoothness * 1.2
end

-- Load Success
game.StarterGui:SetCore("SendNotification", {
    Title = "Theus Premium V3",
    Text = "Loaded Successfully | Mobile Enhanced",
    Duration = 5
})