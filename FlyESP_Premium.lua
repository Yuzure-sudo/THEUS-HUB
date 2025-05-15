-- THEUS-HUB | Mobile Edition
-- Desenvolvido por Yuzure-sudo para dispositivos móveis

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- Remover GUI anterior se existir
if CoreGui:FindFirstChild("THEUSHUB_Mobile") then
    CoreGui:FindFirstChild("THEUSHUB_Mobile"):Destroy()
end

-- Criar GUI principal
local GUI = Instance.new("ScreenGui")
GUI.Name = "THEUSHUB_Mobile"
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GUI.ResetOnSpawn = false
GUI.Parent = CoreGui

-- Configurações
local Settings = {
    Fly = {
        Enabled = false,
        Speed = 50,
        MaxSpeed = 150
    },
    ESP = {
        Enabled = false,
        ShowName = true,
        ShowDistance = true,
        TeamCheck = false,
        MaxDistance = 2000,
        BoxEnabled = true,
        Color = Color3.fromRGB(255, 0, 0)
    },
    Aimbot = {
        Enabled = false,
        TeamCheck = true,
        TargetPart = "Head",
        FOV = 150,
        ShowFOV = true,
        Smoothness = 0.5
    },
    UI = {
        MainColor = Color3.fromRGB(30, 30, 40),
        AccentColor = Color3.fromRGB(0, 170, 127),
        TextColor = Color3.fromRGB(255, 255, 255),
        MobileControlsVisible = true
    }
}

-- Funções de Utilitário
local function CreateElement(className, properties)
    local element = Instance.new(className)
    for property, value in pairs(properties) do
        element[property] = value
    end
    return element
end

local function ApplyCorners(instance, radius)
    local corner = CreateElement("UICorner", {
        CornerRadius = UDim.new(0, radius or 8),
        Parent = instance
    })
    return corner
end

local function ApplyStroke(instance, color, thickness)
    local stroke = CreateElement("UIStroke", {
        Color = color or Color3.fromRGB(60, 60, 80),
        Thickness = thickness or 1.5,
        Parent = instance
    })
    return stroke
end

local function ApplyGradient(instance, colors, rotation)
    local gradient = CreateElement("UIGradient", {
        Rotation = rotation or 45,
        Parent = instance
    })
    
    local colorSequence = {}
    for i, color in ipairs(colors) do
        colorSequence[i] = ColorSequenceKeypoint.new((i-1)/(#colors-1), color)
    end
    gradient.Color = ColorSequence.new(colorSequence)
    
    return gradient
end

-- Sistema de Notificação
local function CreateNotification(title, text, duration)
    duration = duration or 3
    
    local notifFrame = CreateElement("Frame", {
        Name = "Notification",
        BackgroundColor3 = Settings.UI.MainColor,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -150, 0, -80),
        Size = UDim2.new(0, 300, 0, 70),
        ZIndex = 100,
        Parent = GUI
    })
    
    ApplyCorners(notifFrame, 10)
    ApplyStroke(notifFrame, Color3.fromRGB(60, 60, 80), 1.5)
    ApplyGradient(notifFrame, {Color3.fromRGB(35, 35, 45), Color3.fromRGB(25, 25, 35)}, 90)
    
    local notifTitle = CreateElement("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 10),
        Size = UDim2.new(1, -30, 0, 25),
        Font = Enum.Font.GothamBold,
        Text = title,
        TextColor3 = Settings.UI.TextColor,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 101,
        Parent = notifFrame
    })
    
    local notifText = CreateElement("TextLabel", {
        Name = "Text",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 35),
        Size = UDim2.new(1, -30, 0, 25),
        Font = Enum.Font.Gotham,
        Text = text,
        TextColor3 = Color3.fromRGB(200, 200, 200),
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 101,
        Parent = notifFrame
    })
    
    -- Animar notificação
    TweenService:Create(notifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Position = UDim2.new(0.5, -150, 0, 20)}):Play()
    
    -- Auto fechar após duração
    task.delay(duration, function()
        TweenService:Create(notifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Position = UDim2.new(0.5, -150, 0, -80)}):Play()
        task.delay(0.5, function()
            notifFrame:Destroy()
        end)
    end)
    
    return notifFrame
end

-- Criar Interface Principal (Otimizada para Mobile)
local MainFrame = CreateElement("Frame", {
    Name = "MainFrame",
    BackgroundColor3 = Settings.UI.MainColor,
    BorderSizePixel = 0,
    Position = UDim2.new(0.5, -150, 0.3, -100),
    Size = UDim2.new(0, 300, 0, 350),
    Active = true,
    Draggable = true,
    ZIndex = 10,
    Parent = GUI
})

ApplyCorners(MainFrame, 16)
ApplyStroke(MainFrame, Color3.fromRGB(60, 60, 80), 2)
ApplyGradient(MainFrame, {Color3.fromRGB(35, 35, 45), Color3.fromRGB(25, 25, 35)}, 90)

-- Barra de Título
local TitleBar = CreateElement("Frame", {
    Name = "TitleBar",
    BackgroundColor3 = Color3.fromRGB(40, 40, 50),
    BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 0, 40),
    ZIndex = 11,
    Parent = MainFrame
})

ApplyCorners(TitleBar, 12)
ApplyGradient(TitleBar, {Color3.fromRGB(45, 45, 55), Color3.fromRGB(35, 35, 45)}, 90)

local TitleText = CreateElement("TextLabel", {
    Name = "TitleText",
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 15, 0, 0),
    Size = UDim2.new(1, -30, 1, 0),
    Font = Enum.Font.GothamBold,
    Text = "THEUS-HUB MOBILE",
    TextColor3 = Settings.UI.TextColor,
    TextSize = 18,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 12,
    Parent = TitleBar
})

-- Botão para Minimizar/Maximizar Controles Mobile
local ControlsToggle = CreateElement("TextButton", {
    Name = "ControlsToggle",
    BackgroundColor3 = Color3.fromRGB(50, 50, 60),
    BorderSizePixel = 0,
    Position = UDim2.new(1, -100, 0, 8),
    Size = UDim2.new(0, 85, 0, 24),
    Font = Enum.Font.GothamSemibold,
    Text = "Controles: ON",
    TextColor3 = Settings.UI.TextColor,
    TextSize = 12,
    ZIndex = 12,
    Parent = TitleBar
})

ApplyCorners(ControlsToggle, 12)
ApplyGradient(ControlsToggle, {Color3.fromRGB(60, 60, 70), Color3.fromRGB(50, 50, 60)}, 90)

ControlsToggle.MouseButton1Click:Connect(function()
    Settings.UI.MobileControlsVisible = not Settings.UI.MobileControlsVisible
    ControlsToggle.Text = "Controles: " .. (Settings.UI.MobileControlsVisible and "ON" or "OFF")
    
    -- Atualizar visibilidade dos controles
    for _, control in pairs(GUI:GetDescendants()) do
        if control:IsA("Frame") and control.Name == "MobileControls" then
            control.Visible = Settings.UI.MobileControlsVisible
        end
    end
end)

-- Botão para Fechar
local CloseButton = CreateElement("TextButton", {
    Name = "CloseButton",
    BackgroundColor3 = Color3.fromRGB(255, 70, 70),
    BorderSizePixel = 0,
    Position = UDim2.new(1, -35, 0, 8),
    Size = UDim2.new(0, 24, 0, 24),
    Font = Enum.Font.GothamBold,
    Text = "X",
    TextColor3 = Settings.UI.TextColor,
    TextSize = 14,
    ZIndex = 12,
    Parent = TitleBar
})

ApplyCorners(CloseButton, 12)

CloseButton.MouseButton1Click:Connect(function()
    -- Desabilitar todas as funcionalidades
    if Settings.Fly.Enabled then DisableFly() end
    if Settings.ESP.Enabled then DisableESP() end
    if Settings.Aimbot.Enabled then DisableAimbot() end
    
    -- Limpar FOV Circle
    if FOVCircle then
        FOVCircle:Remove()
    end
    
    -- Destruir GUI
    GUI:Destroy()
end)

-- Função para criar botões grandes otimizados para toque
local function CreateMobileButton(name, position, text, color)
    local button = CreateElement("TextButton", {
        Name = name,
        BackgroundColor3 = color or Color3.fromRGB(40, 40, 60),
        BorderSizePixel = 0,
        Position = position,
        Size = UDim2.new(0, 280, 0, 60),
        Font = Enum.Font.GothamBold,
        Text = text,
        TextColor3 = Settings.UI.TextColor,
        TextSize = 22,
        ZIndex = 12,
        Parent = MainFrame
    })
    
    ApplyCorners(button, 10)
    ApplyGradient(button, {Color3.fromRGB(50, 50, 70), Color3.fromRGB(40, 40, 60)}, 90)
    
    -- Efeito de clique
    button.MouseButton1Down:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(30, 30, 50)}):Play()
    end)
    
    button.MouseButton1Up:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = color or Color3.fromRGB(40, 40, 60)}):Play()
    end)
    
    return button
end

-- Criar botões grandes para cada função
local FlyButton = CreateMobileButton("FlyButton", UDim2.new(0.5, -140, 0, 60), "ATIVAR FLY", Color3.fromRGB(20, 110, 180))
local ESPButton = CreateMobileButton("ESPButton", UDim2.new(0.5, -140, 0, 130), "ATIVAR ESP", Color3.fromRGB(140, 60, 190))
local AimbotButton = CreateMobileButton("AimbotButton", UDim2.new(0.5, -140, 0, 200), "ATIVAR AIMBOT", Color3.fromRGB(190, 60, 60))

-- Controladores de velocidade (para FLY)
local SpeedFrame = CreateElement("Frame", {
    Name = "SpeedFrame",
    BackgroundColor3 = Color3.fromRGB(30, 30, 40),
    BorderSizePixel = 0,
    Position = UDim2.new(0.5, -140, 0, 270),
    Size = UDim2.new(0, 280, 0, 60),
    ZIndex = 12,
    Parent = MainFrame
})

ApplyCorners(SpeedFrame, 10)
ApplyGradient(SpeedFrame, {Color3.fromRGB(40, 40, 50), Color3.fromRGB(30, 30, 40)}, 90)

local SpeedLabel = CreateElement("TextLabel", {
    Name = "SpeedLabel",
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 10, 0, 5),
    Size = UDim2.new(1, -20, 0, 25),
    Font = Enum.Font.GothamSemibold,
    Text = "Velocidade: 50",
    TextColor3 = Settings.UI.TextColor,
    TextSize = 18,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 13,
    Parent = SpeedFrame
})

local SpeedSliderBG = CreateElement("Frame", {
    Name = "SliderBG",
    BackgroundColor3 = Color3.fromRGB(20, 20, 30),
    BorderSizePixel = 0,
    Position = UDim2.new(0, 10, 0, 35),
    Size = UDim2.new(1, -20, 0, 15),
    ZIndex = 13,
    Parent = SpeedFrame
})

ApplyCorners(SpeedSliderBG, 8)

local SpeedSliderFill = CreateElement("Frame", {
    Name = "SliderFill",
    BackgroundColor3 = Settings.UI.AccentColor,
    BorderSizePixel = 0,
    Size = UDim2.new(Settings.Fly.Speed / Settings.Fly.MaxSpeed, 0, 1, 0),
    ZIndex = 14,
    Parent = SpeedSliderBG
})

ApplyCorners(SpeedSliderFill, 8)
ApplyGradient(SpeedSliderFill, {Color3.fromRGB(0, 190, 137), Color3.fromRGB(0, 150, 107)}, 90)

-- Fazer slider funcionar com toque
SpeedSliderBG.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        local updateSpeed = function(input)
            local posX = math.clamp(input.Position.X - SpeedSliderBG.AbsolutePosition.X, 0, SpeedSliderBG.AbsoluteSize.X)
            local relativePos = posX / SpeedSliderBG.AbsoluteSize.X
            local newSpeed = math.floor(relativePos * Settings.Fly.MaxSpeed)
            newSpeed = math.max(10, newSpeed) -- Mínimo de 10
            
            Settings.Fly.Speed = newSpeed
            SpeedLabel.Text = "Velocidade: " .. newSpeed
            SpeedSliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
            
            -- Atualizar velocidade do fly se estiver ativo
            if Settings.Fly.Enabled and FlyVel then
                -- A velocidade será atualizada no próximo frame do loop de fly
            end
        end
        
        updateSpeed(input)
        
        local moveConnection
        moveConnection = UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
                updateSpeed(input)
            end
        end)
        
        local endConnection
        endConnection = UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                moveConnection:Disconnect()
                endConnection:Disconnect()
            end
        end)
    end
end)

-- Controles para Mobile (Botões de Subir/Descer)
local MobileControls = CreateElement("Frame", {
    Name = "MobileControls",
    BackgroundTransparency = 1,
    Position = UDim2.new(1, 20, 0.5, -100),
    Size = UDim2.new(0, 80, 0, 200),
    ZIndex = 20,
    Visible = Settings.UI.MobileControlsVisible,
    Parent = GUI
})

-- Botão de Subir
local UpButton = CreateElement("TextButton", {
    Name = "UpButton",
    BackgroundColor3 = Color3.fromRGB(0, 140, 100),
    BorderSizePixel = 0,
    Position = UDim2.new(0, 0, 0, 0),
    Size = UDim2.new(1, 0, 0, 80),
    Font = Enum.Font.GothamBold,
    Text = "▲",
    TextColor3 = Settings.UI.TextColor,
    TextSize = 30,
    ZIndex = 21,
    Parent = MobileControls
})

ApplyCorners(UpButton, 10)
ApplyGradient(UpButton, {Color3.fromRGB(0, 160, 120), Color3.fromRGB(0, 140, 100)}, 90)

-- Botão de Descer
local DownButton = CreateElement("TextButton", {
    Name = "DownButton",
    BackgroundColor3 = Color3.fromRGB(140, 70, 20),
    BorderSizePixel = 0,
    Position = UDim2.new(0, 0, 0, 120),
    Size = UDim2.new(1, 0, 0, 80),
    Font = Enum.Font.GothamBold,
    Text = "▼",
    TextColor3 = Settings.UI.TextColor,
    TextSize = 30,
    ZIndex = 21,
    Parent = MobileControls
})

ApplyCorners(DownButton, 10)
ApplyGradient(DownButton, {Color3.fromRGB(160, 90, 30), Color3.fromRGB(140, 70, 20)}, 90)

-- Variáveis para os sistemas
local FlyGyro, FlyVel
local ESPFolder = CreateElement("Folder", {
    Name = "ESPElements",
    Parent = GUI
})

local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Radius = Settings.Aimbot.FOV
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Thickness = 1
FOVCircle.Transparency = 1
FOVCircle.NumSides = 36
FOVCircle.Filled = false

-- Sistema de Voo (FLY)
function EnableFly()
    local Character = LocalPlayer.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then
        CreateNotification("Erro", "Seu personagem não foi encontrado", 3)
        Settings.Fly.Enabled = false
        return
    end
    
    local HRP = Character:FindFirstChild("HumanoidRootPart")
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    
    if not HRP or not Humanoid then
        CreateNotification("Erro", "Humanoid não encontrado", 3)
        Settings.Fly.Enabled = false
        return
    end
    
    -- Criar controles de voo
    FlyGyro = Instance.new("BodyGyro")
    FlyGyro.P = 9e4
    FlyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    FlyGyro.CFrame = HRP.CFrame
    FlyGyro.Parent = HRP
    
    FlyVel = Instance.new("BodyVelocity")
    FlyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    FlyVel.Velocity = Vector3.new(0, 0.1, 0)
    FlyVel.Parent = HRP
    
    CreateNotification("Fly Ativado", "Use o analógico para mover e os botões para subir/descer", 3)
    FlyButton.Text = "DESATIVAR FLY"
    ApplyGradient(FlyButton, {Color3.fromRGB(200, 60, 60), Color3.fromRGB(180, 40, 40)}, 90)
    
    -- Variáveis de controle para movimento vertical
    local isUpPressed = false
    local isDownPressed = false
    
    -- Eventos de toque para subir/descer
    local function handleUpPress(pressed)
        isUpPressed = pressed
    end
    
    local function handleDownPress(pressed)
        isDownPressed = pressed
    end
    
    -- Conectar eventos de toque
    local upPressed = UpButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            handleUpPress(true)
        end
    end)
    
    local upReleased = UpButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            handleUpPress(false)
        end
    end)
    
    local downPressed = DownButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            handleDownPress(true)
        end
    end)
    
    local downReleased = DownButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            handleDownPress(false)
        end
    end)
    
    -- Loop de voo
    RunService:BindToRenderStep("FlyLoop", 1, function()
        if not Settings.Fly.Enabled then
            upPressed:Disconnect()
            upReleased:Disconnect()
            downPressed:Disconnect()
            downReleased:Disconnect()
            return
        end
        
        local Character = LocalPlayer.Character
        if not Character or not Character:FindFirstChild("HumanoidRootPart") or not FlyGyro or not FlyVel then
            DisableFly()
            return
        end
        
        local HRP = Character:FindFirstChild("HumanoidRootPart")
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        
        -- Orientação baseada na câmera
        FlyGyro.CFrame = CFrame.new(HRP.Position, HRP.Position + Camera.CFrame.LookVector)
        
        -- Movimento horizontal (usando o analógico nativo do Roblox)
        local moveDir = Humanoid.MoveDirection
        
        -- Movimento vertical baseado nos botões de toque
        local verticalSpeed = 0
        if isUpPressed then
            verticalSpeed = Settings.Fly.Speed
        elseif isDownPressed then
            verticalSpeed = -Settings.Fly.Speed
        end
        
        -- Aplicar velocidade
        FlyVel.Velocity = Vector3.new(
            moveDir.X * Settings.Fly.Speed,
            verticalSpeed,
            moveDir.Z * Settings.Fly.Speed
        )
    end)
end

function DisableFly()
    RunService:UnbindFromRenderStep("FlyLoop")
    
    if FlyGyro then FlyGyro:Destroy() end
    if FlyVel then FlyVel:Destroy() end
    
    FlyGyro = nil
    FlyVel = nil
    
    CreateNotification("Fly Desativado", "Voltando à movimentação normal", 3)
    FlyButton.Text = "ATIVAR FLY"
    ApplyGradient(FlyButton, {Color3.fromRGB(30, 120, 190), Color3.fromRGB(20, 110, 180)}, 90)
    
    Settings.Fly.Enabled = false
end

-- Sistema de ESP
function EnableESP()
    ESPFolder:ClearAllChildren()
    
    CreateNotification("ESP Ativado", "Agora você pode ver outros jogadores", 3)
    ESPButton.Text = "DESATIVAR ESP"
    ApplyGradient(ESPButton, {Color3.fromRGB(200, 60, 60), Color3.fromRGB(180, 40, 40)}, 90)
    
    -- Criar ESP para os jogadores atuais
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            CreatePlayerESP(player)
        end
    end
    
    -- Eventos para novos jogadores
    local playerAddedConnection = Players.PlayerAdded:Connect(function(player)
        if Settings.ESP.Enabled then
            CreatePlayerESP(player)
        end
    end)
    
    -- Atualizar ESP constantemente
    RunService:BindToRenderStep("ESPLoop", 5, function()
        if not Settings.ESP.Enabled then
            playerAddedConnection:Disconnect()
            return
        end
        
        -- Atualizar ESP para todos os jogadores
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                UpdatePlayerESP(player)
            end
        end
    end)
end

function DisableESP()
    RunService:UnbindFromRenderStep("ESPLoop")
    ESPFolder:ClearAllChildren()
    
    CreateNotification("ESP Desativado", "ESP removido", 3)
    ESPButton.Text = "ATIVAR ESP"
    ApplyGradient(ESPButton, {Color3.fromRGB(150, 70, 200), Color3.fromRGB(140, 60, 190)}, 90)
    
    Settings.ESP.Enabled = false
end

function CreatePlayerESP(player)
    local espBillboard = CreateElement("BillboardGui", {
        Name = "ESP_" .. player.Name,
        AlwaysOnTop = true,
        Size = UDim2.new(0, 200, 0, 50),
        StudsOffset = Vector3.new(0, 3, 0),
        Parent = ESPFolder
    })
    
    -- Nome do jogador
    local nameLabel = CreateElement("TextLabel", {
        Name = "NameLabel",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 0, 20),
        Font = Enum.Font.GothamBold,
        Text = player.Name,
        TextColor3 = Settings.UI.TextColor,
        TextStrokeTransparency = 0.3,
        TextSize = 14,
        ZIndex = 2,
        Parent = espBillboard
    })
    
    -- Distância
    local distanceLabel = CreateElement("TextLabel", {
        Name = "DistanceLabel",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 20),
        Size = UDim2.new(1, 0, 0, 20),
        Font = Enum.Font.Gotham,
        Text = "0m",
        TextColor3 = Color3.fromRGB(200, 200, 200),
        TextStrokeTransparency = 0.3,
        TextSize = 12,
        ZIndex = 2,
        Parent = espBillboard
    })
    
    -- Saúde (opcional)
    local healthLabel = CreateElement("TextLabel", {
        Name = "HealthLabel",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 40),
        Size = UDim2.new(1, 0, 0, 20),
        Font = Enum.Font.Gotham,
        Text = "100 HP",
        TextColor3 = Color3.fromRGB(100, 255, 100),
        TextStrokeTransparency = 0.3,
        TextSize = 12,
        ZIndex = 2,
        Parent = espBillboard
    })
    
    UpdatePlayerESP(player)
end

function UpdatePlayerESP(player)
    local espBillboard = ESPFolder:FindFirstChild("ESP_" .. player.Name)
    if not espBillboard then
        return -- ESP não criado ainda
    end
    
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") or not character:FindFirstChildOfClass("Humanoid") then
        espBillboard.Enabled = false
        return
    end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    -- Verificar distância
    local distance = (hrp.Position - Camera.CFrame.Position).Magnitude
    if distance > Settings.ESP.MaxDistance then
        espBillboard.Enabled = false
        return
    end
    
    -- Verificar time se necessário
    if Settings.ESP.TeamCheck and player.Team == LocalPlayer.Team then
        espBillboard.Enabled = false
        return
    end
    
    -- Atualizar ESP
    espBillboard.Enabled = true
    espBillboard.Adornee = hrp
    
    -- Atualizar distância
    local distanceLabel = espBillboard:FindFirstChild("DistanceLabel")
    if distanceLabel and Settings.ESP.ShowDistance then
        distanceLabel.Visible = true
        distanceLabel.Text = math.floor(distance) .. "m"
    elseif distanceLabel then
        distanceLabel.Visible = false
    end
    
    -- Atualizar nome
    local nameLabel = espBillboard:FindFirstChild("NameLabel")
    if nameLabel and Settings.ESP.ShowName then
        nameLabel.Visible = true
        
        -- Cor com base na equipe
        if player.Team then
            nameLabel.TextColor3 = player.TeamColor.Color
        else
            nameLabel.TextColor3 = Settings.ESP.Color
        end
    elseif nameLabel then
        nameLabel.Visible = false
    end
    
    -- Atualizar saúde se disponível
    local healthLabel = espBillboard:FindFirstChild("HealthLabel")
    if healthLabel and humanoid then
        healthLabel.Text = math.floor(humanoid.Health) .. " HP"
        
        -- Cor baseada na saúde
        local healthRatio = humanoid.Health / humanoid.MaxHealth
        healthLabel.TextColor3 = Color3.fromRGB(
            255 * (1 - healthRatio),
            255 * healthRatio,
            50
        )
    end
end

-- Sistema de Aimbot
function EnableAimbot()
    FOVCircle.Visible = Settings.Aimbot.ShowFOV
    FOVCircle.Radius = Settings.Aimbot.FOV
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    CreateNotification("Aimbot Ativado", "Toque e segure na tela para ativar a mira", 3)
    AimbotButton.Text = "DESATIVAR AIMBOT"
    ApplyGradient(AimbotButton, {Color3.fromRGB(200, 60, 60), Color3.fromRGB(180, 40, 40)}, 90)
    
    -- Variável para rastrear estado de mira
    local isAiming = false
    
    -- Para dispositivos móveis, usamos toque segurado para ativar
    local touchBeganConnection = UserInputService.TouchTapInWorld:Connect(function(_, gameProcessed)
        if gameProcessed then return end
        isAiming = true
    end)
    
    local touchEndedConnection = UserInputService.TouchEnded:Connect(function()
        isAiming = false
    end)
    
    -- Loop principal do Aimbot
    RunService:BindToRenderStep("AimbotLoop", 1, function()
        if not Settings.Aimbot.Enabled then
            touchBeganConnection:Disconnect()
            touchEndedConnection:Disconnect()
            return
        end
        
        -- Atualizar círculo FOV
        FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        FOVCircle.Radius = Settings.Aimbot.FOV
        FOVCircle.Visible = Settings.Aimbot.ShowFOV
        
        -- Verificar se estamos mirando
        if not isAiming then return end
        
        -- Encontrar alvo mais próximo
        local closestPlayer = GetClosestPlayerToCursor()
        if not closestPlayer then return end
        
        -- Mirar no alvo
        local character = closestPlayer.Character
        if not character or not character:FindFirstChild(Settings.Aimbot.TargetPart) then return end
        
        local targetPart = character:FindFirstChild(Settings.Aimbot.TargetPart)
        
        -- Calcular nova orientação da câmera
        local targetPos = targetPart.Position
        local cameraPos = Camera.CFrame.Position
        
        local targetCFrame = CFrame.new(cameraPos, targetPos)
        
        -- Aplicar suavização
        Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, Settings.Aimbot.Smoothness)
    end)
end

function DisableAimbot()
    RunService:UnbindFromRenderStep("AimbotLoop")
    FOVCircle.Visible = false
    
    CreateNotification("Aimbot Desativado", "Mira automática desligada", 3)
    AimbotButton.Text = "ATIVAR AIMBOT"
    ApplyGradient(AimbotButton, {Color3.fromRGB(200, 70, 70), Color3.fromRGB(190, 60, 60)}, 90)
    
    Settings.Aimbot.Enabled = false
end

function GetClosestPlayerToCursor()
    local closestPlayer = nil
    local shortestDistance = Settings.Aimbot.FOV
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            -- Verificar time se necessário
            if Settings.Aimbot.TeamCheck and player.Team == LocalPlayer.Team then
                continue
            end
            
            local character = player.Character
            if not character or not character:FindFirstChild(Settings.Aimbot.TargetPart) then
                continue
            end
            
            -- Verificar se está vivo
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if not humanoid or humanoid.Health <= 0 then
                continue
            end
            
            -- Obter posição na tela
            local targetPart = character[Settings.Aimbot.TargetPart]
            local screenPos, onScreen = Camera:WorldToScreenPoint(targetPart.Position)
            
            if not onScreen then
                continue
            end
            
            -- Calcular distância até o centro da tela
            local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            local screenDistance = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
            
            if screenDistance < shortestDistance then
                shortestDistance = screenDistance
                closestPlayer = player
            end
        end
    end
    
    return closestPlayer
end

-- Conectar botões aos sistemas
FlyButton.MouseButton1Click:Connect(function()
    Settings.Fly.Enabled = not Settings.Fly.Enabled
    
    if Settings.Fly.Enabled then
        EnableFly()
    else
        DisableFly()
    end
end)

ESPButton.MouseButton1Click:Connect(function()
    Settings.ESP.Enabled = not Settings.ESP.Enabled
    
    if Settings.ESP.Enabled then
        EnableESP()
    else
        DisableESP()
    end
end)

AimbotButton.MouseButton1Click:Connect(function()
    Settings.Aimbot.Enabled = not Settings.Aimbot.Enabled
    
    if Settings.Aimbot.Enabled then
        EnableAimbot()
    else
        DisableAimbot()
    end
end)

-- Adaptando o script para quando o personagem do jogador ressurgir
LocalPlayer.CharacterAdded:Connect(function()
    -- Reativar fly se estiver ativado
    if Settings.Fly.Enabled then
        task.wait(0.5)  -- Pequena espera para garantir que o personagem carregou
        DisableFly()
        task.wait(0.1)
        Settings.Fly.Enabled = true
        EnableFly()
    end
end)

-- Preparar controles e tela para mobile
if isMobile then
    -- Ajustar posição da interface para melhor visibilidade em dispositivos móveis
    MainFrame.Position = UDim2.new(0.5, -150, 0.1, 0)
    
    -- Adicionar informação de ajuda
    local HelpLabel = CreateElement("TextLabel", {
        Name = "HelpLabel",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 1, -30),
        Size = UDim2.new(1, -20, 0, 20),
        Font = Enum.Font.Gotham,
        Text = "Dica: Use os botões laterais para subir/descer",
        TextColor3 = Color3.fromRGB(180, 180, 180),
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 12,
        Parent = MainFrame
    })
end

-- Exibir notificação inicial
CreateNotification("THEUS-HUB Mobile", "Script carregado! Use os botões para ativar as funções", 4)