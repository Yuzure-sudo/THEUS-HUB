local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "THEUS PREMIUM",
    SubTitle = "by theuz",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Combat = Window:AddTab({ Title = "Combat", Icon = "combat" }),
    Visuals = Window:AddTab({ Title = "Visuals", Icon = "eye" }),
    Movement = Window:AddTab({ Title = "Movement", Icon = "movement" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Config = {
    Aim = {
        Enabled = false,
        Target = "Head",
        FOV = 500,
        Prediction = 0.165,
        AutoFire = false,
        TeamCheck = false,
        WallCheck = false,
        Smooth = true,
        SmoothValue = 0.5
    },
    ESP = {
        Enabled = false,
        Box = false,
        Tracer = false,
        Name = false,
        Distance = false,
        BoxColor = Color3.fromRGB(255,0,0),
        TracerColor = Color3.fromRGB(255,0,0),
        TextColor = Color3.fromRGB(255,255,255),
        BoxTrans = 0.3,
        TextSize = 14,
        MaxDistance = 2000
    },
    Movement = {
        SpeedEnabled = false,
        SpeedValue = 16,
        JumpEnabled = false,
        JumpPower = 50,
        InfJump = false
    }
}

local AimbotSection = Tabs.Combat:AddSection("Aimbot")

local AimbotToggle = AimbotSection:AddToggle("AimbotEnabled", {
    Title = "Enable Aimbot",
    Default = false,
    Callback = function(Value)
        Config.Aim.Enabled = Value
    end
})

local TargetPartDropdown = AimbotSection:AddDropdown("TargetPart", {
    Title = "Target Part",
    Values = {"Head", "HumanoidRootPart", "Torso"},
    Default = "Head",
    Callback = function(Value)
        Config.Aim.Target = Value
    end
})

local FOVSlider = AimbotSection:AddSlider("FOV", {
    Title = "Field of View",
    Description = "Aimbot FOV Radius",
    Default = 500,
    Min = 10,
    Max = 1000,
    Callback = function(Value)
        Config.Aim.FOV = Value
    end
})

local PredictionSlider = AimbotSection:AddSlider("Prediction", {
    Title = "Prediction",
    Description = "Movement Prediction",
    Default = 0.165,
    Min = 0,
    Max = 1,
    Decimals = 3,
    Callback = function(Value)
        Config.Aim.Prediction = Value
    end
})

local AutoFireToggle = AimbotSection:AddToggle("AutoFire", {
    Title = "Auto Fire",
    Default = false,
    Callback = function(Value)
        Config.Aim.AutoFire = Value
    end
})

local ESPSection = Tabs.Visuals:AddSection("ESP")

local ESPToggle = ESPSection:AddToggle("ESPEnabled", {
    Title = "Enable ESP",
    Default = false,
    Callback = function(Value)
        Config.ESP.Enabled = Value
    end
})

local BoxESPToggle = ESPSection:AddToggle("BoxESP", {
    Title = "Box ESP",
    Default = false,
    Callback = function(Value)
        Config.ESP.Box = Value
    end
})

local TracerESPToggle = ESPSection:AddToggle("TracerESP", {
    Title = "Tracer ESP",
    Default = false,
    Callback = function(Value)
        Config.ESP.Tracer = Value
    end
})

local MovementSection = Tabs.Movement:AddSection("Movement")

local SpeedToggle = MovementSection:AddToggle("SpeedEnabled", {
    Title = "Speed Hack",
    Default = false,
    Callback = function(Value)
        Config.Movement.SpeedEnabled = Value
    end
})

local SpeedSlider = MovementSection:AddSlider("Speed", {
    Title = "Speed Value",
    Default = 16,
    Min = 16,
    Max = 500,
    Callback = function(Value)
        Config.Movement.SpeedValue = Value
    end
})

local InfJumpToggle = MovementSection:AddToggle("InfJump", {
    Title = "Infinite Jump",
    Default = false,
    Callback = function(Value)
        Config.Movement.InfJump = Value
    end
})

-- Main Functions
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local function GetClosestPlayer()
    local Target = nil
    local MaxDist = Config.Aim.FOV
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild(Config.Aim.Target) and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            if Config.Aim.TeamCheck and v.Team == LocalPlayer.Team then continue end
            if Config.Aim.WallCheck then
                local Ray = Ray.new(Camera.CFrame.Position, (v.Character[Config.Aim.Target].Position - Camera.CFrame.Position).Unit * 2000)
                local Hit = workspace:FindPartOnRayWithIgnoreList(Ray, {LocalPlayer.Character, Camera})
                if not Hit or not Hit:IsDescendantOf(v.Character) then continue end
            end
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

local function CreateESP()
    for _, v in pairs(Players:GetPlayers()) do
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
            
            if Config.Aim.AutoFire then
                mouse1click()
            end
        end
    end
    
    if Config.Movement.SpeedEnabled then
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + LocalPlayer.Character.Humanoid.MoveDirection * Config.Movement.SpeedValue/10
    end
end)

UserInputService.JumpRequest:Connect(function()
    if Config.Movement.InfJump then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

CreateESP()
Players.PlayerAdded:Connect(CreateESP)

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

SaveManager:BuildConfigSection(Tabs.Settings)
InterfaceManager:BuildInterfaceSection(Tabs.Settings)

Window:SelectTab(1)

Fluent:Notify({
    Title = "THEUS PREMIUM",
    Content = "Script loaded successfully!",
    Duration = 3
})

SaveManager:LoadAutoloadConfig()