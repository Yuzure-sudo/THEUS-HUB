--Ultimate Combat Hub Mobile v4.0 Professional Edition
--Desenvolvido para máxima performance e usabilidade em dispositivos móveis
--Interface moderna e responsiva com animações suaves

local Services = {
    TweenService = game:GetService("TweenService"),
    UserInputService = game:GetService("UserInputService"),
    Players = game:GetService("Players"),
    RunService = game:GetService("RunService"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    Lighting = game:GetService("Lighting")
}

local LocalPlayer = Services.Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Cache = {}

--Configuração da Interface Principal
local MainGUI = Instance.new("ScreenGui")
MainGUI.Name = "UltimateCombatHubPro"
MainGUI.ResetOnSpawn = false
MainGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MainGUI.Parent = game.CoreGui

--Frame Principal com Design Moderno
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainContainer"
MainFrame.Size = UDim2.new(0, 320, 0, 480)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = MainGUI

--Adicionando Cantos Arredondados
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

--Sistema de Sombras Avançado
local ShadowFrame = Instance.new("Frame")
ShadowFrame.Name = "ShadowEffect"
ShadowFrame.BackgroundTransparency = 1
ShadowFrame.Size = UDim2.new(1, 30, 1, 30)
ShadowFrame.Position = UDim2.new(0, -15, 0, -15)
ShadowFrame.ZIndex = 0
ShadowFrame.Parent = MainFrame

--Gradiente para Efeito Visual
local GradientEffect = Instance.new("ImageLabel")
GradientEffect.Name = "BackgroundGradient"
GradientEffect.BackgroundTransparency = 1
GradientEffect.Size = UDim2.new(1, 0, 1, 0)
GradientEffect.Image = "rbxassetid://4155801252"
GradientEffect.ImageTransparency = 0.8
GradientEffect.Parent = ShadowFrame

--Barra Superior com Título
local TopBar = Instance.new("Frame")
TopBar.Name = "NavigationBar"
TopBar.Size = UDim2.new(1, 0, 0, 48)
TopBar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
TopBar.Parent = MainFrame

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 12)
TopBarCorner.Parent = TopBar

--Título Personalizado
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "HeaderTitle"
TitleLabel.Size = UDim2.new(1, -80, 1, 0)
TitleLabel.Position = UDim2.new(0, 20, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Ultimate Combat Hub Pro"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 18
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

--Botão de Minimizar Animado
local MinimizeButton = Instance.new("ImageButton")
MinimizeButton.Name = "CollapseButton"
MinimizeButton.Size = UDim2.new(0, 38, 0, 38)
MinimizeButton.Position = UDim2.new(1, -44, 0.5, -19)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
MinimizeButton.AutoButtonColor = false
MinimizeButton.Image = "rbxassetid://7072718362"
MinimizeButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.Parent = TopBar

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(1, 0)
MinimizeCorner.Parent = MinimizeButton

--Container Principal para Conteúdo
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "MainContent"
ContentContainer.Size = UDim2.new(1, -20, 1, -68)
ContentContainer.Position = UDim2.new(0, 10, 0, 58)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

--Configurações Globais do Sistema
_G.Settings = {
    Aimbot = {
        Enabled = false,
        TeamCheck = true,
        WallCheck = true,
        Smoothness = 0.25,
        AimPart = "Head",
        FOV = 400,
        ShowFOV = true,
        Prediction = true,
        AutoShoot = false,
        TriggerBot = false,
        SilentAim = false,
        Sensitivity = 1.0,
        PredictionStrength = 2.0
    },
    ESP = {
        Enabled = false,
        TeamCheck = true,
        BoxEnabled = true,
        NameEnabled = true,
        HealthEnabled = true,
        DistanceEnabled = true,
        TracerEnabled = false,
        ChamsEnabled = false,
        ShowSkeleton = false,
        RainbowMode = false,
        TextSize = 14,
        BoxThickness = 1.5
    },
    Combat = {
        KillAura = false,
        AutoParry = false,
        AutoBlock = false,
        Range = 15,
        HitDelay = 0.1,
        AutoHeal = false,
        FastAttack = false,
        CriticalHits = false,
        DamageMultiplier = 1.0
    },
    Movement = {
        SpeedEnabled = false,
        JumpEnabled = false,
        FlightEnabled = false,
        NoClip = false,
        Speed = 2,
        JumpPower = 50,
        FlightSpeed = 50,
        BunnyHop = false,
        AutoJump = false
    },
    Visuals = {
        FullBright = false,
        NoFog = false,
        CustomFOV = 70,
        ThirdPerson = false,
        Crosshair = true,
        CustomTime = false,
        TimeValue = 14,
        RemoveShadows = false
    }
}

--Funções Utilitárias
local function CreateToggleButton(text, parent)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 45)
    Button.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
    Button.Text = ""
    Button.AutoButtonColor = false
    Button.Parent = parent

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = Button

    local ButtonLabel = Instance.new("TextLabel")
    ButtonLabel.Size = UDim2.new(1, -50, 1, 0)
    ButtonLabel.Position = UDim2.new(0, 15, 0, 0)
    ButtonLabel.BackgroundTransparency = 1
    ButtonLabel.Text = text
    ButtonLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ButtonLabel.TextSize = 14
    ButtonLabel.Font = Enum.Font.GothamSemibold
    ButtonLabel.TextXAlignment = Enum.TextXAlignment.Left
    ButtonLabel.Parent = Button

    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(0, 36, 0, 20)
    ToggleFrame.Position = UDim2.new(1, -46, 0.5, -10)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    ToggleFrame.Parent = Button

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(1, 0)
    ToggleCorner.Parent = ToggleFrame

    local ToggleIndicator = Instance.new("Frame")
    ToggleIndicator.Size = UDim2.new(0, 16, 0, 16)
    ToggleIndicator.Position = UDim2.new(0, 2, 0.5, -8)
    ToggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 69, 72)
    ToggleIndicator.Parent = ToggleFrame

    local IndicatorCorner = Instance.new("UICorner")
    IndicatorCorner.CornerRadius = UDim.new(1, 0)
    IndicatorCorner.Parent = ToggleIndicator

    return Button, ToggleIndicator
end

--[Continuação do script anterior...]

--Sistema de Categorias
local function CreateCategory(name)
    local CategoryLabel = Instance.new("Frame")
    CategoryLabel.Size = UDim2.new(1, 0, 0, 30)
    CategoryLabel.BackgroundTransparency = 1
    CategoryLabel.Parent = ContentContainer

    local TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = name
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.TextSize = 14
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.Parent = CategoryLabel

    return CategoryLabel
end

--Criação dos Botões
CreateCategory("Combat")
local AimbotButton, AimbotIndicator = CreateToggleButton("Aimbot", ContentContainer)
local ESPButton, ESPIndicator = CreateToggleButton("ESP", ContentContainer)
local KillAuraButton, KillAuraIndicator = CreateToggleButton("Kill Aura", ContentContainer)

CreateCategory("Movement")
local SpeedButton, SpeedIndicator = CreateToggleButton("Speed", ContentContainer)
local FlightButton, FlightIndicator = CreateToggleButton("Flight", ContentContainer)

CreateCategory("Visuals")
local BrightButton, BrightIndicator = CreateToggleButton("Full Bright", ContentContainer)
local FOVButton, FOVIndicator = CreateToggleButton("Custom FOV", ContentContainer)

--Funções de Animação
local function EnableToggle(indicator)
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad)
    local goal = {
        Position = UDim2.new(1, -18, 0.5, -8),
        BackgroundColor3 = Color3.fromRGB(0, 255, 128)
    }
    local tween = Services.TweenService:Create(indicator, tweenInfo, goal)
    tween:Play()
end

local function DisableToggle(indicator)
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad)
    local goal = {
        Position = UDim2.new(0, 2, 0.5, -8),
        BackgroundColor3 = Color3.fromRGB(255, 69, 72)
    }
    local tween = Services.TweenService:Create(indicator, tweenInfo, goal)
    tween:Play()
end

--Sistema de Aimbot
local function GetDistance(player)
    if not LocalPlayer.Character then return end
    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local character = player.Character
    if not character then return end
    local targetRoot = character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end
    
    local distance = (root.Position - targetRoot.Position).Magnitude
    return distance
end

local function GetClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = _G.Settings.Aimbot.FOV
    
    for _, player in pairs(Services.Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if player.Character and player.Character:FindFirstChild(_G.Settings.Aimbot.AimPart) then
                if _G.Settings.Aimbot.TeamCheck and player.Team == LocalPlayer.Team then continue end
                
                if _G.Settings.Aimbot.WallCheck then
                    local ray = Ray.new(Camera.CFrame.Position, 
                        (player.Character[_G.Settings.Aimbot.AimPart].Position - Camera.CFrame.Position).Unit * 1000)
                    local hit, _ = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character, player.Character})
                    if hit then continue end
                end
                
                local targetPart = player.Character[_G.Settings.Aimbot.AimPart]
                local screenPoint = Camera:WorldToScreenPoint(targetPart.Position)
                
                if screenPoint.Z > 0 then
                    local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - 
                        Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                    
                    if distance < shortestDistance then
                        closestPlayer = player
                        shortestDistance = distance
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

--Sistema de Combate
local function ActivateKillAura()
    for _, player in pairs(Services.Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local distance = GetDistance(player)
            if distance and distance <= _G.Settings.Combat.Range then
                local args = {
                    [1] = player.Character.Humanoid,
                    [2] = _G.Settings.Combat.HitDelay
                }
                Services.ReplicatedStorage.RemoteEvent:FireServer(unpack(args))
            end
        end
    end
end

--Event Handlers
AimbotButton.MouseButton1Click:Connect(function()
    _G.Settings.Aimbot.Enabled = not _G.Settings.Aimbot.Enabled
    if _G.Settings.Aimbot.Enabled then
        EnableToggle(AimbotIndicator)
    else
        DisableToggle(AimbotIndicator)
    end
end)

ESPButton.MouseButton1Click:Connect(function()
    _G.Settings.ESP.Enabled = not _G.Settings.ESP.Enabled
    if _G.Settings.ESP.Enabled then
        EnableToggle(ESPIndicator)
    else
        DisableToggle(ESPIndicator)
    end
end)

KillAuraButton.MouseButton1Click:Connect(function()
    _G.Settings.Combat.KillAura = not _G.Settings.Combat.KillAura
    if _G.Settings.Combat.KillAura then
        EnableToggle(KillAuraIndicator)
    else
        DisableToggle(KillAuraIndicator)
    end
end)

--Sistema de Minimização
local isMinimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart)
    local targetSize = isMinimized and UDim2.new(0, 320, 0, 48) or UDim2.new(0, 320, 0, 480)
    local tween = Services.TweenService:Create(MainFrame, tweenInfo, {Size = targetSize})
    tween:Play()
    ContentContainer.Visible = not isMinimized
    MinimizeButton.Rotation = isMinimized and 180 or 0
end)

--Arrastar Interface
MainFrame.Draggable = true
MainFrame.Active = true

--Loop Principal
Services.RunService.RenderStepped:Connect(function()
    if _G.Settings.Aimbot.Enabled then
        local target = GetClosestPlayer()
        if target then
            local targetPart = target.Character[_G.Settings.Aimbot.AimPart]
            local prediction = _G.Settings.Aimbot.Prediction and 
                targetPart.Velocity * Vector3.new(1, 0, 1) * 0.165 or Vector3.new()
            
            local screenPoint = Camera:WorldToScreenPoint(targetPart.Position + prediction)
            local mousePos = Vector2.new(Services.UserInputService:GetMouseLocation().X,
                Services.UserInputService:GetMouseLocation().Y)
            local targetPos = Vector2.new(screenPoint.X, screenPoint.Y)
            local delta = (targetPos - mousePos) * _G.Settings.Aimbot.Smoothness
            
            mousemoverel(delta.X, delta.Y)
            
            if _G.Settings.Aimbot.AutoShoot then
                mouse1click()
            end
        end
    end
    
    if _G.Settings.Combat.KillAura then
        ActivateKillAura()
    end
    
    if _G.Settings.Movement.SpeedEnabled and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16 * _G.Settings.Movement.Speed
        end
    end
    
    if _G.Settings.Movement.FlightEnabled and LocalPlayer.Character then
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            local upForce = Services.UserInputService:IsKeyDown(Enum.KeyCode.Space) and 1 or 0
            local downForce = Services.UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and -1 or 0
            root.Velocity = Vector3.new(
                root.Velocity.X,
                50 * (upForce + downForce),
                root.Velocity.Z
            )
        end
    end
    
    if _G.Settings.Visuals.FullBright then
        Services.Lighting.Brightness = 2
        Services.Lighting.ClockTime = 14
        Services.Lighting.FogEnd = 100000
        Services.Lighting.GlobalShadows = false
    end
    
    if _G.Settings.Visuals.CustomFOV then
        Camera.FieldOfView = _G.Settings.Visuals.FOV
    end
end)

--Notificação de Inicialização
local NotificationFrame = Instance.new("Frame")
NotificationFrame.Name = "Notification"
NotificationFrame.Size = UDim2.new(0, 200, 0, 60)
NotificationFrame.Position = UDim2.new(1, 20, 0.5, -30)
NotificationFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
NotificationFrame.BorderSizePixel = 0
NotificationFrame.Parent = MainFrame

local NotificationCorner = Instance.new("UICorner")
NotificationCorner.CornerRadius = UDim.new(0, 8)
NotificationCorner.Parent = NotificationFrame

local NotificationText = Instance.new("TextLabel")
NotificationText.Size = UDim2.new(1, -20, 1, 0)
NotificationText.Position = UDim2.new(0, 10, 0, 0)
NotificationText.BackgroundTransparency = 1
NotificationText.Text = "Script Loaded!\nPress RightAlt to toggle"
NotificationText.TextColor3 = Color3.fromRGB(255, 255, 255)
NotificationText.TextSize = 14
NotificationText.Font = Enum.Font.GothamSemibold
NotificationText.Parent = NotificationFrame

--Animação da Notificação
local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quart)
local showTween = Services.TweenService:Create(NotificationFrame, tweenInfo, 
    {Position = UDim2.new(1, -220, 0.5, -30)})
showTween:Play()
wait(3)
local hideTween = Services.TweenService:Create(NotificationFrame, tweenInfo,
    {Position = UDim2.new(1, 20, 0.5, -30)})
hideTween:Play()

--Atalho para Toggle
Services.UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightAlt then
        MainGUI.Enabled = not MainGUI.Enabled
    end
end)