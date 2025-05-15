-- THEUS-HUB Mobile Edition
-- Script compacto otimizado para dispositivos móveis

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- Verificar se já existe uma GUI anterior
local ScreenGui = game:GetService("CoreGui"):FindFirstChild("THEUSHUB_Mobile")
if ScreenGui then ScreenGui:Destroy() end

-- Criar GUI
ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "THEUSHUB_Mobile"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game:GetService("CoreGui")

-- Configurações
local Config = {
    Fly = {
        Enabled = false,
        Speed = 50
    },
    ESP = {
        Enabled = false,
        ShowName = true,
        ShowDistance = true,
        TeamCheck = false,
        MaxDistance = 2000
    },
    Aimbot = {
        Enabled = false,
        TeamCheck = true,
        TargetPart = "Head",
        FOV = 150,
        ShowFOV = true,
        Smoothness = 0.5
    }
}

-- Criar interface principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -150, 0.2, 0)
MainFrame.Size = UDim2.new(0, 300, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Arredondar cantos
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Barra de título
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Name = "Title"
TitleText.BackgroundTransparency = 1
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.Size = UDim2.new(1, -30, 1, 0)
TitleText.Font = Enum.Font.GothamBold
TitleText.Text = "THEUS-HUB MOBILE"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 18
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

-- Botão de fechar
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(1, -30, 0, 10)
CloseButton.Size = UDim2.new(0, 20, 0, 20)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 4)
CloseCorner.Parent = CloseButton

-- Função para criar botões
local function CreateButton(text, position, color)
    local button = Instance.new("TextButton")
    button.Name = text .. "Button"
    button.BackgroundColor3 = color or Color3.fromRGB(40, 40, 60)
    button.BorderSizePixel = 0
    button.Position = position
    button.Size = UDim2.new(0, 280, 0, 60)
    button.Font = Enum.Font.GothamBold
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 20
    button.Parent = MainFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    return button
end

-- Criar botões principais
local FlyButton = CreateButton("ATIVAR FLY", UDim2.new(0.5, -140, 0, 50), Color3.fromRGB(0, 120, 180))
local ESPButton = CreateButton("ATIVAR ESP", UDim2.new(0.5, -140, 0, 120), Color3.fromRGB(120, 60, 180))
local AimbotButton = CreateButton("ATIVAR AIMBOT", UDim2.new(0.5, -140, 0, 190), Color3.fromRGB(180, 60, 60))

-- Status
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "Status"
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 10, 0, 260)
StatusLabel.Size = UDim2.new(1, -20, 0, 30)
StatusLabel.Font = Enum.Font.GothamSemibold
StatusLabel.Text = "Status: Pronto"
StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
StatusLabel.TextSize = 16
StatusLabel.TextXAlignment = Enum.TextXAlignment.Center
StatusLabel.Parent = MainFrame

-- Função para atualizar status
local function UpdateStatus(text, color)
    StatusLabel.Text = "Status: " .. text
    StatusLabel.TextColor3 = color or Color3.fromRGB(100, 255, 100)
end

-- Controles para Mobile
local MobileControls = Instance.new("Frame")
MobileControls.Name = "MobileControls"
MobileControls.BackgroundTransparency = 1
MobileControls.Position = UDim2.new(1, 20, 0.5, -80)
MobileControls.Size = UDim2.new(0, 70, 0, 160)
MobileControls.Parent = ScreenGui

-- Botão para subir
local UpButton = Instance.new("TextButton")
UpButton.Name = "UpButton"
UpButton.BackgroundColor3 = Color3.fromRGB(0, 150, 120)
UpButton.BorderSizePixel = 0
UpButton.Position = UDim2.new(0, 0, 0, 0)
UpButton.Size = UDim2.new(1, 0, 0, 70)
UpButton.Font = Enum.Font.GothamBold
UpButton.Text = "▲"
UpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
UpButton.TextSize = 30
UpButton.Parent = MobileControls

local UpCorner = Instance.new("UICorner")
UpCorner.CornerRadius = UDim.new(0, 8)
UpCorner.Parent = UpButton

-- Botão para descer
local DownButton = Instance.new("TextButton")
DownButton.Name = "DownButton"
DownButton.BackgroundColor3 = Color3.fromRGB(150, 70, 30)
DownButton.BorderSizePixel = 0
DownButton.Position = UDim2.new(0, 0, 0, 90)
DownButton.Size = UDim2.new(1, 0, 0, 70)
DownButton.Font = Enum.Font.GothamBold
DownButton.Text = "▼"
DownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DownButton.TextSize = 30
DownButton.Parent = MobileControls

local DownCorner = Instance.new("UICorner")
DownCorner.CornerRadius = UDim.new(0, 8)
DownCorner.Parent = DownButton

-- Variáveis para sistemas
local FlyGyro, FlyVel
local ESPFolder = Instance.new("Folder", ScreenGui)
ESPFolder.Name = "ESPElements"

-- Círculo FOV para Aimbot
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Radius = Config.Aimbot.FOV
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Thickness = 1
FOVCircle.Transparency = 0.7
FOVCircle.NumSides = 36
FOVCircle.Filled = false

-- Sistema de Fly
function EnableFly()
    local Character = LocalPlayer.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then
        UpdateStatus("Erro: Personagem não encontrado", Color3.fromRGB(255, 100, 100))
        Config.Fly.Enabled = false
        return
    end
    
    local HRP = Character:FindFirstChild("HumanoidRootPart")
    
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
    
    UpdateStatus("Fly ativado! Use os botões para subir/descer", Color3.fromRGB(100, 200, 255))
    FlyButton.Text = "DESATIVAR FLY"
    FlyButton.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
    
    -- Variáveis para movimento vertical
    local isUpPressed = false
    local isDownPressed = false
    
    -- Eventos de toque
    UpButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            isUpPressed = true
        end
    end)
    
    UpButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            isUpPressed = false
        end
    end)
    
    DownButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDownPressed = true
        end
    end)
    
    DownButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDownPressed = false
        end
    end)
    
    -- Loop de voo
    RunService:BindToRenderStep("FlyLoop", 1, function()
        if not Config.Fly.Enabled then return end
        
        local Character = LocalPlayer.Character
        if not Character or not Character:FindFirstChild("HumanoidRootPart") then
            DisableFly()
            return
        end
        
        local HRP = Character:FindFirstChild("HumanoidRootPart")
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        
        -- Orientação baseada na câmera
        FlyGyro.CFrame = CFrame.new(HRP.Position, HRP.Position + Camera.CFrame.LookVector)
        
        -- Movimento horizontal (usando o analógico nativo do Roblox)
        local moveDir = Humanoid.MoveDirection
        
        -- Movimento vertical baseado nos botões
        local verticalSpeed = 0
        if isUpPressed then
            verticalSpeed = Config.Fly.Speed
        elseif isDownPressed then
            verticalSpeed = -Config.Fly.Speed
        end
        
        -- Aplicar velocidade
        FlyVel.Velocity = Vector3.new(
            moveDir.X * Config.Fly.Speed,
            verticalSpeed,
            moveDir.Z * Config.Fly.Speed
        )
    end)
end

function DisableFly()
    RunService:UnbindFromRenderStep("FlyLoop")
    
    if FlyGyro then FlyGyro:Destroy() end
    if FlyVel then FlyVel:Destroy() end
    
    FlyGyro = nil
    FlyVel = nil
    
    UpdateStatus("Fly desativado", Color3.fromRGB(255, 200, 100))
    FlyButton.Text = "ATIVAR FLY"
    FlyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 180)
    
    Config.Fly.Enabled = false
end

-- Sistema de ESP
function EnableESP()
    ESPFolder:ClearAllChildren()
    
    UpdateStatus("ESP ativado", Color3.fromRGB(100, 255, 100))
    ESPButton.Text = "DESATIVAR ESP"
    ESPButton.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
    
    -- Criar ESP para jogadores atuais
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            CreatePlayerESP(player)
        end
    end
    
    -- Monitorar novos jogadores
    Players.PlayerAdded:Connect(function(player)
        if Config.ESP.Enabled then
            CreatePlayerESP(player)
        end
    end)
    
    -- Atualizar ESP constantemente
    RunService:BindToRenderStep("ESPLoop", 5, function()
        if not Config.ESP.Enabled then return end
        
        for _, esp in pairs(ESPFolder:GetChildren()) do
            UpdateESP(esp)
        end
    end)
end

function DisableESP()
    RunService:UnbindFromRenderStep("ESPLoop")
    ESPFolder:ClearAllChildren()
    
    UpdateStatus("ESP desativado", Color3.fromRGB(255, 200, 100))
    ESPButton.Text = "ATIVAR ESP"
    ESPButton.BackgroundColor3 = Color3.fromRGB(120, 60, 180)
    
    Config.ESP.Enabled = false
end

function CreatePlayerESP(player)
    local esp = Instance.new("BillboardGui")
    esp.Name = "ESP_" .. player.Name
    esp.AlwaysOnTop = true
    esp.Size = UDim2.new(0, 200, 0, 50)
    esp.StudsOffset = Vector3.new(0, 3, 0)
    esp.Adornee = nil  -- Será definido em UpdateESP
    esp.Player = player.Name
    esp.Parent = ESPFolder
    
    -- Nome do jogador
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.BackgroundTransparency = 1
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.Size = UDim2.new(1, 0, 0, 20)
    nameLabel.Font = Enum.Font.GothamSemibold
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0.3
    nameLabel.TextSize = 14
    nameLabel.Parent = esp
    
    -- Distância
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Name = "DistanceLabel"
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Position = UDim2.new(0, 0, 0, 20)
    distanceLabel.Size = UDim2.new(1, 0, 0, 20)
    distanceLabel.Font = Enum.Font.Gotham
    distanceLabel.Text = "0m"
    distanceLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    distanceLabel.TextStrokeTransparency = 0.3
    distanceLabel.TextSize = 12
    distanceLabel.Parent = esp
    
    return esp
end

function UpdateESP(esp)
    local playerName = esp.Player
    local player = Players:FindFirstChild(playerName)
    
    if not player then
        esp.Enabled = false
        return
    end
    
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        esp.Enabled = false
        return
    end
    
    local hrp = character.HumanoidRootPart
    
    -- Verificar distância
    local distance = (hrp.Position - Camera.CFrame.Position).Magnitude
    if distance > Config.ESP.MaxDistance then
        esp.Enabled = false
        return
    end
    
    -- Verificar time se necessário
    if Config.ESP.TeamCheck and player.Team == LocalPlayer.Team then
        esp.Enabled = false
        return
    end
    
    -- Atualizar ESP
    esp.Enabled = true
    esp.Adornee = hrp
    
    -- Atualizar distância
    local distanceLabel = esp:FindFirstChild("DistanceLabel")
    if distanceLabel and Config.ESP.ShowDistance then
        distanceLabel.Visible = true
        distanceLabel.Text = math.floor(distance) .. "m"
    elseif distanceLabel then
        distanceLabel.Visible = false
    end
    
    -- Atualizar nome
    local nameLabel = esp:FindFirstChild("NameLabel")
    if nameLabel and Config.ESP.ShowName then
        nameLabel.Visible = true
        
        -- Cor com base na equipe
        if player.Team then
            nameLabel.TextColor3 = player.TeamColor.Color
        else
            nameLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        end
    elseif nameLabel then
        nameLabel.Visible = false
    end
end

-- Sistema de Aimbot
function EnableAimbot()
    FOVCircle.Visible = Config.Aimbot.ShowFOV
    FOVCircle.Radius = Config.Aimbot.FOV
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    UpdateStatus("Aimbot ativado - Toque e segure para mirar", Color3.fromRGB(255, 150, 150))
    AimbotButton.Text = "DESATIVAR AIMBOT"
    AimbotButton.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
    
    -- Variável para rastrear estado de mira
    local isAiming = false
    
    -- Para dispositivos móveis, usamos toque segurado para ativar
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.Touch then
            isAiming = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            isAiming = false
        end
    end)
    
    -- Loop principal do Aimbot
    RunService:BindToRenderStep("AimbotLoop", 1, function()
        if not Config.Aimbot.Enabled then return end
        
        -- Atualizar círculo FOV
        FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        FOVCircle.Visible = Config.Aimbot.ShowFOV
        
        -- Verificar se estamos mirando
        if not isAiming then return end
        
        -- Encontrar alvo mais próximo
        local closestPlayer = GetClosestPlayerToCursor()
        if not closestPlayer then return end
        
        -- Mirar no alvo
        local character = closestPlayer.Character
        if not character or not character:FindFirstChild(Config.Aimbot.TargetPart) then return end
        
        local targetPart = character:FindFirstChild(Config.Aimbot.TargetPart)
        
        -- Calcular nova orientação da câmera
        local targetPos = targetPart.Position
        local cameraPos = Camera.CFrame.Position
        
        local targetCFrame = CFrame.new(cameraPos, targetPos)
        
        -- Aplicar suavização
        Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, Config.Aimbot.Smoothness)
    end)
end

function DisableAimbot()
    RunService:UnbindFromRenderStep("AimbotLoop")
    FOVCircle.Visible = false
    
    UpdateStatus("Aimbot desativado", Color3.fromRGB(255, 200, 100))
    AimbotButton.Text = "ATIVAR AIMBOT"
    AimbotButton.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
    
    Config.Aimbot.Enabled = false
end

function GetClosestPlayerToCursor()
    local closestPlayer = nil
    local shortestDistance = Config.Aimbot.FOV
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            -- Verificar time se necessário
            if Config.Aimbot.TeamCheck and player.Team == LocalPlayer.Team then
                continue
            end
            
            local character = player.Character
            if not character or not character:FindFirstChild(Config.Aimbot.TargetPart) then
                continue
            end
            
            -- Verificar se está vivo
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if not humanoid or humanoid.Health <= 0 then
                continue
            end
            
            -- Obter posição na tela
            local targetPart = character[Config.Aimbot.TargetPart]
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
    Config.Fly.Enabled = not Config.Fly.Enabled
    
    if Config.Fly.Enabled then
        EnableFly()
    else
        DisableFly()
    end
end)

ESPButton.MouseButton1Click:Connect(function()
    Config.ESP.Enabled = not Config.ESP.Enabled
    
    if Config.ESP.Enabled then
        EnableESP()
    else
        DisableESP()
    end
end)

AimbotButton.MouseButton1Click:Connect(function()
    Config.Aimbot.Enabled = not Config.Aimbot.Enabled
    
    if Config.Aimbot.Enabled then
        EnableAimbot()
    else
        DisableAimbot()
    end
end)

-- Botão de fechar
CloseButton.MouseButton1Click:Connect(function()
    -- Desativar todas as funcionalidades
    if Config.Fly.Enabled then DisableFly() end
    if Config.ESP.Enabled then DisableESP() end
    if Config.Aimbot.Enabled then DisableAimbot() end
    
    -- Remover FOV Circle
    if FOVCircle then
        FOVCircle:Remove()
    end
    
    -- Destruir GUI
    ScreenGui:Destroy()
end)

-- Mensagem inicial
UpdateStatus("Script carregado com sucesso!", Color3.fromRGB(100, 255, 100))

-- Informações sobre o script
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Name = "InfoLabel"
InfoLabel.BackgroundTransparency = 1
InfoLabel.Position = UDim2.new(0, 0, 1, -20)
InfoLabel.Size = UDim2.new(1, 0, 0, 20)
InfoLabel.Font = Enum.Font.Gotham
InfoLabel.Text = "THEUS-HUB Mobile v1.0"
InfoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
InfoLabel.TextSize = 12
InfoLabel.TextXAlignment = Enum.TextXAlignment.Center
InfoLabel.Parent = MainFrame