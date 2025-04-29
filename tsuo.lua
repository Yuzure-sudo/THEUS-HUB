-- Ultimate Combat Hub Mobile v3.0
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local VirtualUser = game:GetService("VirtualUser")

-- Cache de Performance
local cache = {
    players = {},
    characters = {},
    humanoids = {},
    rootParts = {},
    connections = {},
    espObjects = {},
    targets = {},
    lastShot = 0,
    lastJump = 0
}

-- Configurações Avançadas
_G.Settings = {
    Aimbot = {
        Enabled = false,
        SilentAim = false,
        TeamCheck = true,
        VisibilityCheck = true,
        TargetPart = "Head",
        Smoothness = 0.25,
        FOV = 400,
        AutoShoot = false,
        TriggerBot = false,
        PredictMovement = true,
        PredictionStrength = 2,
        HitChance = 100,
        AutoReload = true,
        RandomizationStrength = 0.1,
        TargetLock = false,
        IgnoreTransparency = true,
        MaxDistance = 1000,
        Priority = {"Head", "HumanoidRootPart", "Torso"}
    },
    ESP = {
        Enabled = false,
        TeamCheck = true,
        ShowNames = true,
        ShowDistance = true,
        ShowHealth = true,
        ShowBoxes = true,
        ShowTracers = true,
        ShowChams = false,
        RainbowMode = false,
        TextSize = 14,
        TextFont = "GothamBold",
        BoxThickness = 1.5,
        TracerThickness = 1.2,
        MaxDistance = 2000,
        UpdateRate = 10,
        FadeDistance = 1500
    },
    Combat = {
        AutoDodge = false,
        AutoBlock = false,
        AutoHeal = false,
        AutoReload = true,
        FastAttack = false,
        InstantKill = false,
        KillAura = false,
        Range = 15,
        AttackDelay = 0.1
    },
    Movement = {
        SpeedHack = false,
        JumpHack = false,
        FlightEnabled = false,
        NoClip = false,
        AutoJump = false,
        SpeedMultiplier = 2,
        JumpHeight = 50,
        FlightSpeed = 50
    },
    Visuals = {
        FullBright = false,
        NoFog = false,
        CustomFOV = 70,
        ThirdPerson = false,
        FreeCam = false,
        Crosshair = true
    }
}

-- Interface Moderna
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TopBar = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local MinimizeBtn = Instance.new("ImageButton")
local Container = Instance.new("Frame")
local TabsContainer = Instance.new("Frame")
local ContentContainer = Instance.new("Frame")

-- Estilização
local function ApplyStyle(instance, properties)
    for property, value in pairs(properties) do
        instance[property] = value
    end
    return instance
end

-- Configuração da Interface
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame = ApplyStyle(MainFrame, {
    Name = "MainFrame",
    Size = UDim2.new(0, 300, 0, 450),
    Position = UDim2.new(0.5, -150, 0.5, -225),
    BackgroundColor3 = Color3.fromRGB(25, 25, 25),
    BorderSizePixel = 0,
    Parent = ScreenGui
})

-- Adiciona Sombra
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.BackgroundTransparency = 1
Shadow.Position = UDim2.new(0, -15, 0, -15)
Shadow.Size = UDim2.new(1, 30, 1, 30)
Shadow.Image = "rbxassetid://5028857084"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.5
Shadow.Parent = MainFrame

-- Funções do Aimbot
local function GetClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = _G.Settings.Aimbot.FOV
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(_G.Settings.Aimbot.TargetPart) then
            if _G.Settings.Aimbot.TeamCheck and player.Team == LocalPlayer.Team then continue end
            
            local targetPart = player.Character[_G.Settings.Aimbot.TargetPart]
            local screenPoint = Camera:WorldToViewportPoint(targetPart.Position)
            local vectorDistance = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(screenPoint.X, screenPoint.Y)).Magnitude
            
            if vectorDistance < shortestDistance then
                closestPlayer = player
                shortestDistance = vectorDistance
            end
        end
    end
    
    return closestPlayer
end

-- ESP Aprimorado
local function CreateESPObject(player)
    local esp = {
        Box = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
        Health = Drawing.new("Text"),
        Tracer = Drawing.new("Line"),
        HeadDot = Drawing.new("Circle")
    }
    
    -- Configuração dos elementos ESP
    esp.Box.Thickness = _G.Settings.ESP.BoxThickness
    esp.Box.Filled = false
    esp.Box.Transparency = 1
    esp.Box.Color = Color3.fromRGB(255, 255, 255)
    
    esp.Name.Size = _G.Settings.ESP.TextSize
    esp.Name.Center = true
    esp.Name.Outline = true
    
    esp.Distance.Size = _G.Settings.ESP.TextSize
    esp.Distance.Center = true
    esp.Distance.Outline = true
    
    esp.Health.Size = _G.Settings.ESP.TextSize
    esp.Health.Center = true
    esp.Health.Outline = true
    
    esp.Tracer.Thickness = _G.Settings.ESP.TracerThickness
    esp.Tracer.Transparency = 1
    
    esp.HeadDot.Thickness = 1
    esp.HeadDot.NumSides = 30
    esp.HeadDot.Radius = 3
    esp.HeadDot.Filled = true
    
    cache.espObjects[player] = esp
    return esp
end

-- Funções de Combate
local function ActivateKillAura()
    if not _G.Settings.Combat.KillAura then return end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            
            if distance <= _G.Settings.Combat.Range then
                local args = {
                    [1] = player.Character.Humanoid,
                    [2] = _G.Settings.Combat.AttackDelay
                }
                game:GetService("ReplicatedStorage").RemoteEvent:FireServer(unpack(args))
            end
        end
    end
end

-- Sistema de Movimento
local function UpdateMovement()
    if not LocalPlayer.Character then return end
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    if _G.Settings.Movement.SpeedHack then
        humanoid.WalkSpeed = 16 * _G.Settings.Movement.SpeedMultiplier
    end
    
    if _G.Settings.Movement.JumpHack then
        humanoid.JumpPower = _G.Settings.Movement.JumpHeight
    end
end

-- Interface de Usuário
local function CreateButton(text, parent)
    local button = Instance.new("TextButton")
    ApplyStyle(button, {
        Size = UDim2.new(1, -20, 0, 40),
        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        BorderSizePixel = 0,
        Text = text,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        Font = Enum.Font.GothamSemibold,
        Parent = parent
    })
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
    
    return button
end

-- Loops Principais
RunService.RenderStepped:Connect(function()
    if _G.Settings.Aimbot.Enabled then
        local target = GetClosestPlayer()
        if target then
            local targetPart = target.Character[_G.Settings.Aimbot.TargetPart]
            local prediction = _G.Settings.Aimbot.PredictMovement and 
                (targetPart.Velocity * Vector3.new(1, 0, 1)) * _G.Settings.Aimbot.PredictionStrength or 
                Vector3.new(0, 0, 0)
            
            local pos = Camera:WorldToScreenPoint(targetPart.Position + prediction)
            local mousePos = Vector2.new(Mouse.X, Mouse.Y)
            local targetPos = Vector2.new(pos.X, pos.Y)
            local delta = (targetPos - mousePos) * _G.Settings.Aimbot.Smoothness
            
            mousemoverel(delta.X, delta.Y)
            
            if _G.Settings.Aimbot.AutoShoot and tick() - cache.lastShot > _G.Settings.Combat.AttackDelay then
                mouse1click()
                cache.lastShot = tick()
            end
        end
    end
    
    if _G.Settings.ESP.Enabled then
        for player, esp in pairs(cache.espObjects) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local humanoidRootPart = player.Character.HumanoidRootPart
                local humanoid = player.Character:FindFirstChild("Humanoid")
                local head = player.Character:FindFirstChild("Head")
                
                local pos, onScreen = Camera:WorldToScreenPoint(humanoidRootPart.Position)
                local distance = (LocalPlayer.Character.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude
                
                if onScreen and distance < _G.Settings.ESP.MaxDistance then
                    local size = 1000 / distance
                    local boxSize = Vector2.new(size, size * 1.5)
                    local boxPosition = Vector2.new(pos.X - size/2, pos.Y - size * 0.75)
                    
                    esp.Box.Size = boxSize
                    esp.Box.Position = boxPosition
                    esp.Box.Visible = _G.Settings.ESP.ShowBoxes
                    
                    esp.Name.Position = Vector2.new(pos.X, boxPosition.Y - esp.Name.TextBounds.Y - 2)
                    esp.Name.Text = player.Name
                    esp.Name.Visible = _G.Settings.ESP.ShowNames
                    
                    esp.Distance.Position = Vector2.new(pos.X, boxPosition.Y + boxSize.Y + 2)
                    esp.Distance.Text = string.format("%.0f studs", distance)
                    esp.Distance.Visible = _G.Settings.ESP.ShowDistance
                    
                    if humanoid then
                        esp.Health.Position = Vector2.new(boxPosition.X - 20, boxPosition.Y)
                        esp.Health.Text = string.format("%.0f%%", (humanoid.Health / humanoid.MaxHealth) * 100)
                        esp.Health.Visible = _G.Settings.ESP.ShowHealth
                    end
                    
                    if _G.Settings.ESP.ShowTracers then
                        esp.Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                        esp.Tracer.To = Vector2.new(pos.X, pos.Y)
                        esp.Tracer.Visible = true
                    end
                    
                    if head then
                        local headPos = Camera:WorldToScreenPoint(head.Position)
                        esp.HeadDot.Position = Vector2.new(headPos.X, headPos.Y)
                        esp.HeadDot.Visible = true
                    end
                else
                    for _, element in pairs(esp) do
                        element.Visible = false
                    end
                end
            end
        end
    end
    
    UpdateMovement()
    if _G.Settings.Combat.KillAura then
        ActivateKillAura()
    end
end)

-- Inicialização
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateESPObject(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    CreateESPObject(player)
end)

Players.PlayerRemoving:Connect(function(player)
    if cache.espObjects[player] then
        for _, element in pairs(cache.espObjects[player]) do
            element:Remove()
        end
        cache.espObjects[player] = nil
    end
end)

-- Controles Mobile
UserInputService.TouchStarted:Connect(function(touch, gameProcessed)
    if not gameProcessed then
        -- Implementar controles touch aqui
    end
end)

-- Notificação de Inicialização
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Script Carregado",
    Text = "Pressione o botão para minimizar/maximizar",
    Duration = 5
})