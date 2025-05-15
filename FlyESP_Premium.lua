-- THEUS-HUB | Script básico de Fly, ESP e Aimbot
-- Criado por Yuzure-sudo

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Limpar GUI anterior se existir
if CoreGui:FindFirstChild("THEUS_HUB") then
    CoreGui:FindFirstChild("THEUS_HUB"):Destroy()
end

-- Criar GUI
local GUI = Instance.new("ScreenGui")
GUI.Name = "THEUS_HUB"
GUI.Parent = CoreGui
GUI.ResetOnSpawn = false

-- Configurações
local Config = {
    Fly = {
        Enabled = false,
        Speed = 50
    },
    ESP = {
        Enabled = false,
        MaxDistance = 5000
    },
    Aimbot = {
        Enabled = false,
        FOV = 100,
        Smoothness = 0.5,
        TeamCheck = true,
        TargetPart = "Head"
    }
}

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -125)
MainFrame.Size = UDim2.new(0, 300, 0, 250)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = GUI

-- Cantos arredondados para o MainFrame
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Título
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.Parent = MainFrame

-- Cantos arredondados para o TitleBar
local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

-- Texto do título
local TitleText = Instance.new("TextLabel")
TitleText.Name = "TitleText"
TitleText.BackgroundTransparency = 1
TitleText.Position = UDim2.new(0, 10, 0, 0)
TitleText.Size = UDim2.new(1, -20, 1, 0)
TitleText.Font = Enum.Font.GothamBold
TitleText.Text = "THEUS-HUB"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 16
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

-- Botões principais
local function CreateButton(name, pos, text)
    local button = Instance.new("TextButton")
    button.Name = name
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    button.BorderSizePixel = 0
    button.Position = pos
    button.Size = UDim2.new(0, 280, 0, 40)
    button.Font = Enum.Font.GothamSemibold
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 16
    button.Parent = MainFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    return button
end

-- Criar botões
local FlyButton = CreateButton("FlyButton", UDim2.new(0.5, -140, 0, 50), "Ativar Fly")
local ESPButton = CreateButton("ESPButton", UDim2.new(0.5, -140, 0, 110), "Ativar ESP")
local AimbotButton = CreateButton("AimbotButton", UDim2.new(0.5, -140, 0, 170), "Ativar Aimbot")

-- Status de texto
local StatusText = Instance.new("TextLabel")
StatusText.Name = "StatusText"
StatusText.BackgroundTransparency = 1
StatusText.Position = UDim2.new(0, 10, 1, -30)
StatusText.Size = UDim2.new(1, -20, 0, 20)
StatusText.Font = Enum.Font.Gotham
StatusText.Text = "Status: Carregado com sucesso"
StatusText.TextColor3 = Color3.fromRGB(100, 255, 100)
StatusText.TextSize = 14
StatusText.TextXAlignment = Enum.TextXAlignment.Left
StatusText.Parent = MainFrame

-- Função de notificação simplificada
function UpdateStatus(text, color)
    StatusText.Text = "Status: " .. text
    StatusText.TextColor3 = color or Color3.fromRGB(100, 255, 100)
end

-- Fly simples
local FlyGyro, FlyVel

function StartFly()
    local Character = LocalPlayer.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then
        UpdateStatus("Erro: Personagem não encontrado", Color3.fromRGB(255, 100, 100))
        return
    end
    
    local HRP = Character.HumanoidRootPart
    
    -- Criar controles de voo
    FlyGyro = Instance.new("BodyGyro")
    FlyGyro.P = 9e4
    FlyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    FlyGyro.CFrame = HRP.CFrame
    FlyGyro.Parent = HRP
    
    FlyVel = Instance.new("BodyVelocity")
    FlyVel.Velocity = Vector3.new(0, 0.1, 0)
    FlyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    FlyVel.Parent = HRP
    
    -- Atualizar status
    UpdateStatus("Fly ativado - Use WASD e Space/Ctrl", Color3.fromRGB(100, 200, 255))
    FlyButton.Text = "Desativar Fly"
    FlyButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    
    -- Conectar ao RenderStepped para movimentação fluida
    RunService:BindToRenderStep("Fly", 1, function()
        if not Config.Fly.Enabled then return end
        
        local Character = LocalPlayer.Character
        if not Character or not Character:FindFirstChild("HumanoidRootPart") then
            StopFly()
            return
        end
        
        local HRP = Character.HumanoidRootPart
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        
        -- Atualizar orientação
        FlyGyro.CFrame = CFrame.new(HRP.Position, HRP.Position + Camera.CFrame.LookVector)
        
        -- Calcular velocidade
        local moveDirection = Humanoid.MoveDirection * Config.Fly.Speed
        
        -- Movimento vertical
        local verticalSpeed = 0
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            verticalSpeed = Config.Fly.Speed
        elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            verticalSpeed = -Config.Fly.Speed
        end
        
        -- Aplicar movimento
        FlyVel.Velocity = Vector3.new(moveDirection.X, verticalSpeed, moveDirection.Z)
    end)
end

function StopFly()
    RunService:UnbindFromRenderStep("Fly")
    
    if FlyGyro then FlyGyro:Destroy() end
    if FlyVel then FlyVel:Destroy() end
    
    FlyGyro = nil
    FlyVel = nil
    
    UpdateStatus("Fly desativado", Color3.fromRGB(255, 200, 100))
    FlyButton.Text = "Ativar Fly"
    FlyButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    
    Config.Fly.Enabled = false
end

-- ESP simples
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "ESPElements"
ESPFolder.Parent = GUI

function StartESP()
    -- Limpar ESP existente
    ESPFolder:ClearAllChildren()
    
    UpdateStatus("ESP ativado", Color3.fromRGB(100, 255, 100))
    ESPButton.Text = "Desativar ESP"
    ESPButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    
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
    RunService:BindToRenderStep("ESP", 5, function()
        if not Config.ESP.Enabled then return end
        
        for _, esp in pairs(ESPFolder:GetChildren()) do
            UpdateESP(esp)
        end
    end)
end

function StopESP()
    RunService:UnbindFromRenderStep("ESP")
    ESPFolder:ClearAllChildren()
    
    UpdateStatus("ESP desativado", Color3.fromRGB(255, 200, 100))
    ESPButton.Text = "Ativar ESP"
    ESPButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    
    Config.ESP.Enabled = false
end

function CreatePlayerESP(player)
    local esp = Instance.new("BillboardGui")
    esp.Name = "ESP_" .. player.Name
    esp.AlwaysOnTop = true
    esp.Size = UDim2.new(0, 200, 0, 50)
    esp.StudsOffset = Vector3.new(0, 3, 0)
    esp.Adornee = nil  -- Será definido em UpdateESP
    esp.Player = player.Name  -- Armazenar nome do jogador
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
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    -- Verificar distância
    local distance = (hrp.Position - Camera.CFrame.Position).Magnitude
    if distance > Config.ESP.MaxDistance then
        esp.Enabled = false
        return
    end
    
    -- Atualizar ESP
    esp.Enabled = true
    esp.Adornee = hrp
    
    -- Atualizar informações
    local distanceLabel = esp:FindFirstChild("DistanceLabel")
    if distanceLabel then
        distanceLabel.Text = math.floor(distance) .. "m"
    end
    
    -- Cor com base na equipe
    local nameLabel = esp:FindFirstChild("NameLabel")
    if nameLabel and player.Team then
        nameLabel.TextColor3 = player.TeamColor.Color
    end
end

-- Aimbot simples
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Radius = Config.Aimbot.FOV
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Thickness = 1
FOVCircle.Transparency = 1
FOVCircle.NumSides = 36
FOVCircle.Filled = false

function StartAimbot()
    FOVCircle.Visible = true
    
    UpdateStatus("Aimbot ativado - Pressione E para usar", Color3.fromRGB(255, 150, 150))
    AimbotButton.Text = "Desativar Aimbot"
    AimbotButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    
    RunService:BindToRenderStep("Aimbot", 1, function()
        if not Config.Aimbot.Enabled then return end
        
        -- Atualizar círculo FOV
        FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        FOVCircle.Radius = Config.Aimbot.FOV
        
        -- Verificar tecla pressionada (E)
        if not UserInputService:IsKeyDown(Enum.KeyCode.E) then return end
        
        -- Encontrar alvo mais próximo
        local target = GetClosestPlayerToCursor()
        if not target then return end
        
        -- Mirar no alvo
        local targetPart = target.Character:FindFirstChild(Config.Aimbot.TargetPart)
        if not targetPart then return end
        
        -- Calcular nova orientação da câmera
        local targetPos = targetPart.Position
        local cameraPos = Camera.CFrame.Position
        
        local targetCFrame = CFrame.new(cameraPos, targetPos)
        
        -- Aplicar suavização
        Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, Config.Aimbot.Smoothness)
    end)
end

function StopAimbot()
    RunService:UnbindFromRenderStep("Aimbot")
    FOVCircle.Visible = false
    
    UpdateStatus("Aimbot desativado", Color3.fromRGB(255, 200, 100))
    AimbotButton.Text = "Ativar Aimbot"
    AimbotButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    
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
            
            -- Verificar personagem
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
            
            -- Calcular distância até o cursor
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

-- Conectar eventos de botões
FlyButton.MouseButton1Click:Connect(function()
    Config.Fly.Enabled = not Config.Fly.Enabled
    
    if Config.Fly.Enabled then
        StartFly()
    else
        StopFly()
    end
end)

ESPButton.MouseButton1Click:Connect(function()
    Config.ESP.Enabled = not Config.ESP.Enabled
    
    if Config.ESP.Enabled then
        StartESP()
    else
        StopESP()
    end
end)

AimbotButton.MouseButton1Click:Connect(function()
    Config.Aimbot.Enabled = not Config.Aimbot.Enabled
    
    if Config.Aimbot.Enabled then
        StartAimbot()
    else
        StopAimbot()
    end
end)

-- Teclas de atalho
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.X then
        -- Alternar Fly
        FlyButton.MouseButton1Click:Fire()
    elseif input.KeyCode == Enum.KeyCode.C then
        -- Alternar ESP
        ESPButton.MouseButton1Click:Fire()
    elseif input.KeyCode == Enum.KeyCode.V then
        -- Alternar Aimbot
        AimbotButton.MouseButton1Click:Fire()
    end
end)

-- Botão de fechar
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(1, -25, 0, 5)
CloseButton.Size = UDim2.new(0, 20, 0, 20)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 12
CloseButton.Parent = TitleBar

-- Cantos arredondados para o botão de fechar
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 4)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    -- Desativar todas as funcionalidades
    if Config.Fly.Enabled then StopFly() end
    if Config.ESP.Enabled then StopESP() end
    if Config.Aimbot.Enabled then StopAimbot() end
    
    -- Remover FOV Circle
    FOVCircle:Remove()
    
    -- Destruir GUI
    GUI:Destroy()
end)

-- Mensagem inicial
UpdateStatus("Script carregado com sucesso", Color3.fromRGB(100, 255, 100))