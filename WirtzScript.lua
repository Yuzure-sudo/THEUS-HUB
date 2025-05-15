-- Wirtz Script - Premium Edition
-- Versão com interface aprimorada e aimbot potente

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Remover GUI se existir
pcall(function()
    if game:GetService("CoreGui"):FindFirstChild("WirtzScript") then
        game:GetService("CoreGui"):FindFirstChild("WirtzScript"):Destroy()
    end
end)

-- Criar nova GUI
local GUI = Instance.new("ScreenGui")
GUI.Name = "WirtzScript"
pcall(function()
    GUI.Parent = game:GetService("CoreGui")
end)
if not GUI.Parent then
    GUI.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Estados
local ESPEnabled = false
local FlyEnabled = false
local AimbotEnabled = false

-- Configurações
local Config = {
    Fly = {
        Speed = 80,
        VerticalSpeed = 70
    },
    ESP = {
        ShowDistance = true,
        ShowHealth = true,
        UseTeamColor = true,
        ShowBoxes = true,
        MaxDistance = 2000
    },
    Aimbot = {
        Strength = 1.0, -- Quanto maior, mais "grudento"
        TeamCheck = true,
        TargetPart = "Head",
        Prediction = true,
        PredictionStrength = 0.5,
        AutoShoot = false
    },
    Colors = {
        Primary = Color3.fromRGB(25, 25, 35),
        Secondary = Color3.fromRGB(30, 30, 45),
        Accent = Color3.fromRGB(90, 120, 240),
        Success = Color3.fromRGB(70, 200, 120),
        Warning = Color3.fromRGB(240, 175, 70),
        Danger = Color3.fromRGB(240, 70, 70),
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(180, 180, 180)
    }
}

-- Utilitários UI
local function CreateStroke(parent, thickness, color)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 1.5
    stroke.Color = color or Config.Colors.Accent
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function CreateGradient(parent, angle, color1, color2)
    local gradient = Instance.new("UIGradient")
    gradient.Rotation = angle or 45
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color1 or Config.Colors.Primary),
        ColorSequenceKeypoint.new(1, color2 or Config.Colors.Secondary)
    })
    gradient.Parent = parent
    return gradient
end

local function CreateShadow(parent, size, transparency)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.Size = UDim2.new(1, size or 30, 1, size or 30)
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Image = "rbxassetid://6014054464"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = transparency or 0.6
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(128, 128, 128, 128)
    shadow.Parent = parent
    return shadow
end

local function MakeDraggable(gui, handle)
    local dragging = false
    local dragInput, dragStart, startPos
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            local newPosition = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X, 
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
            gui.Position = newPosition
        end
    end)
end

-- Interface Avançada
-- Frame Principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.BackgroundColor3 = Config.Colors.Primary
MainFrame.BorderSizePixel = 0
MainFrame.ZIndex = 10
MainFrame.Parent = GUI

CreateCorner(MainFrame, 12)
CreateShadow(MainFrame, 50)

-- Painel Superior
local TopPanel = Instance.new("Frame")
TopPanel.Name = "TopPanel"
TopPanel.Size = UDim2.new(1, 0, 0, 40)
TopPanel.BackgroundColor3 = Config.Colors.Secondary
TopPanel.BorderSizePixel = 0
TopPanel.ZIndex = 11
TopPanel.Parent = MainFrame

CreateCorner(TopPanel, 12)

-- Correção visual para que o painel superior tenha apenas cantos arredondados no topo
local TopPanelFix = Instance.new("Frame")
TopPanelFix.Name = "TopPanelFix"
TopPanelFix.Size = UDim2.new(1, 0, 0.5, 0)
TopPanelFix.Position = UDim2.new(0, 0, 0.5, 0)
TopPanelFix.BackgroundColor3 = Config.Colors.Secondary
TopPanelFix.BorderSizePixel = 0
TopPanelFix.ZIndex = 11
TopPanelFix.Parent = TopPanel

-- Título Principal
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, -20, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "WIRTZ SCRIPT"
TitleLabel.TextColor3 = Config.Colors.TextPrimary
TitleLabel.TextSize = 22
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 12
TitleLabel.Parent = TopPanel

-- Subtítulo com efeito gradiente
local Subtitle = Instance.new("TextLabel")
Subtitle.Name = "Subtitle"
Subtitle.Size = UDim2.new(0, 160, 0, 20)
Subtitle.Position = UDim2.new(0, 17, 0, 25)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "PREMIUM EDITION"
Subtitle.TextColor3 = Config.Colors.Accent
Subtitle.TextSize = 12
Subtitle.Font = Enum.Font.GothamSemibold
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.ZIndex = 12
Subtitle.Parent = TopPanel

-- Tornar o frame arrastável
MakeDraggable(MainFrame, TopPanel)

-- Contentor para os controles
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -20, 1, -60)
ContentFrame.Position = UDim2.new(0, 10, 0, 50)
ContentFrame.BackgroundTransparency = 1
ContentFrame.ZIndex = 11
ContentFrame.Parent = MainFrame

-- Separador
local Divider = Instance.new("Frame")
Divider.Name = "Divider"
Divider.Size = UDim2.new(1, 0, 0, 2)
Divider.Position = UDim2.new(0, 0, 0, 0)
Divider.BackgroundColor3 = Config.Colors.Secondary
Divider.BorderSizePixel = 0
Divider.ZIndex = 11
Divider.Parent = ContentFrame

-- Função para criar cartões de função
local function CreateFeatureCard(title, description, icon, position, color)
    local card = Instance.new("Frame")
    card.Name = title .. "Card"
    card.Size = UDim2.new(1, 0, 0, 95)
    card.Position = position
    card.BackgroundColor3 = Config.Colors.Secondary
    card.BorderSizePixel = 0
    card.ZIndex = 11
    card.Parent = ContentFrame
    
    CreateCorner(card, 10)
    CreateStroke(card, 1, Color3.fromRGB(60, 60, 80))
    
    -- Ícone
    local iconLabel = Instance.new("ImageLabel")
    iconLabel.Name = "Icon"
    iconLabel.Size = UDim2.new(0, 40, 0, 40)
    iconLabel.Position = UDim2.new(0, 15, 0, 10)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Image = icon
    iconLabel.ImageColor3 = color or Config.Colors.Accent
    iconLabel.ZIndex = 12
    iconLabel.Parent = card
    
    -- Título
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(0, 150, 0, 25)
    titleLabel.Position = UDim2.new(0, 65, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Config.Colors.TextPrimary
    titleLabel.TextSize = 18
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 12
    titleLabel.Parent = card
    
    -- Descrição
    local descLabel = Instance.new("TextLabel")
    descLabel.Name = "Description"
    descLabel.Size = UDim2.new(0, 170, 0, 35)
    descLabel.Position = UDim2.new(0, 65, 0, 35)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = description
    descLabel.TextColor3 = Config.Colors.TextSecondary
    descLabel.TextSize = 13
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextWrapped = true
    descLabel.ZIndex = 12
    descLabel.Parent = card
    
    -- Toggle Switch Background
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = "ToggleFrame"
    toggleFrame.Size = UDim2.new(0, 55, 0, 26)
    toggleFrame.Position = UDim2.new(1, -70, 0.5, -13)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.ZIndex = 12
    toggleFrame.Parent = card
    
    CreateCorner(toggleFrame, 13)
    
    -- Toggle Switch Circle
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Name = "ToggleCircle"
    toggleCircle.Size = UDim2.new(0, 20, 0, 20)
    toggleCircle.Position = UDim2.new(0, 3, 0, 3)
    toggleCircle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    toggleCircle.BorderSizePixel = 0
    toggleCircle.ZIndex = 13
    toggleCircle.Parent = toggleFrame
    
    CreateCorner(toggleCircle, 10)
    
    -- Button for Interaction
    local button = Instance.new("TextButton")
    button.Name = title .. "Button"
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = ""
    button.ZIndex = 14
    button.Parent = card
    
    -- Estado do toggle
    local enabled = false
    
    -- Função para atualizar visualmente o toggle
    local function updateToggle()
        local targetPos = enabled and UDim2.new(0, 32, 0, 3) or UDim2.new(0, 3, 0, 3)
        local targetColor = enabled and color or Color3.fromRGB(50, 50, 70)
        
        -- Animação suave
        TweenService:Create(toggleCircle, TweenInfo.new(0.3), {Position = targetPos}):Play()
        TweenService:Create(toggleFrame, TweenInfo.new(0.3), {BackgroundColor3 = targetColor}):Play()
    end
    
    -- Efeito de hover
    button.MouseEnter:Connect(function()
        TweenService:Create(card, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(40, 40, 55)}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(card, TweenInfo.new(0.3), {BackgroundColor3 = Config.Colors.Secondary}):Play()
    end)
    
    -- Função para alternar estado
    local function toggle()
        enabled = not enabled
        updateToggle()
        return enabled
    end
    
    return button, toggle
end

-- Criar cartões de função
local yPos = 10

-- ESP Card
local ESPButton, ESPToggle = CreateFeatureCard(
    "ESP", 
    "Visualize jogadores através de paredes com informações detalhadas", 
    "rbxassetid://7733674079", -- Ícone de olho
    UDim2.new(0, 0, 0, yPos),
    Config.Colors.Accent
)
yPos = yPos + 105

-- Fly Card
local FlyButton, FlyToggle = CreateFeatureCard(
    "Fly", 
    "Voe livremente pelo mapa com controles intuitivos", 
    "rbxassetid://7733715400", -- Ícone de asa
    UDim2.new(0, 0, 0, yPos),
    Config.Colors.Success
)
yPos = yPos + 105

-- Aimbot Card
local AimbotButton, AimbotToggle = CreateFeatureCard(
    "Aimbot", 
    "Mira automaticamente nos inimigos com precisão letal", 
    "rbxassetid://7733774602", -- Ícone de alvo
    UDim2.new(0, 0, 0, yPos),
    Config.Colors.Danger
)

-- Barra de Status
local StatusBar = Instance.new("Frame")
StatusBar.Name = "StatusBar"
StatusBar.Size = UDim2.new(1, -20, 0, 35)
StatusBar.Position = UDim2.new(0, 10, 1, -45)
StatusBar.BackgroundColor3 = Config.Colors.Secondary
StatusBar.BorderSizePixel = 0
StatusBar.ZIndex = 11
StatusBar.Parent = MainFrame

CreateCorner(StatusBar, 8)

-- Texto de Status
local StatusText = Instance.new("TextLabel")
StatusText.Name = "StatusText"
StatusText.Size = UDim2.new(1, -20, 1, 0)
StatusText.Position = UDim2.new(0, 10, 0, 0)
StatusText.BackgroundTransparency = 1
StatusText.Text = "Script carregado com sucesso!"
StatusText.TextColor3 = Config.Colors.Success
StatusText.TextSize = 14
StatusText.Font = Enum.Font.GothamSemibold
StatusText.TextXAlignment = Enum.TextXAlignment.Left
StatusText.ZIndex = 12
StatusText.Parent = StatusBar

-- Função para mostrar mensagens de status
local function ShowStatus(message, color)
    StatusText.Text = message
    
    -- Animação de fade
    TweenService:Create(StatusText, TweenInfo.new(0.3), {TextColor3 = color or Config.Colors.Success}):Play()
end

-- Botão para fechar
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Config.Colors.Danger
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = Config.Colors.TextPrimary
CloseButton.TextSize = 16
CloseButton.Font = Enum.Font.GothamBold
CloseButton.ZIndex = 12
CloseButton.Parent = TopPanel

CreateCorner(CloseButton, 15)

-- Botões de controle para Fly (subir/descer)
local FlyControls = Instance.new("Frame")
FlyControls.Name = "FlyControls"
FlyControls.Size = UDim2.new(0, 120, 0, 250)
FlyControls.Position = UDim2.new(1, 20, 0.5, -125)
FlyControls.BackgroundTransparency = 1
FlyControls.Visible = false
FlyControls.Parent = GUI

-- Botão para subir
local UpButton = Instance.new("TextButton")
UpButton.Name = "UpButton"
UpButton.Size = UDim2.new(1, 0, 0.45, 0)
UpButton.BackgroundColor3 = Config.Colors.Success
UpButton.BorderSizePixel = 0
UpButton.Text = "SUBIR"
UpButton.TextColor3 = Config.Colors.TextPrimary
UpButton.TextSize = 18
UpButton.Font = Enum.Font.GothamBold
UpButton.ZIndex = 12
UpButton.Parent = FlyControls

CreateCorner(UpButton, 10)
CreateShadow(UpButton, 15, 0.5)

-- Botão para descer
local DownButton = Instance.new("TextButton")
DownButton.Name = "DownButton"
DownButton.Size = UDim2.new(1, 0, 0.45, 0)
DownButton.Position = UDim2.new(0, 0, 0.55, 0)
DownButton.BackgroundColor3 = Config.Colors.Warning
DownButton.BorderSizePixel = 0
DownButton.Text = "DESCER"
DownButton.TextColor3 = Config.Colors.TextPrimary
DownButton.TextSize = 18
DownButton.Font = Enum.Font.GothamBold
DownButton.ZIndex = 12
DownButton.Parent = FlyControls

CreateCorner(DownButton, 10)
CreateShadow(DownButton, 15, 0.5)

-- Pasta para ESP
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "ESPItems"
ESPFolder.Parent = GUI

-- Sistema de ESP Melhorado
local function CreatePlayerESP(player)
    if player == LocalPlayer then return end
    
    local esp = Instance.new("BillboardGui")
    esp.Name = "ESP_" .. player.Name
    esp.AlwaysOnTop = true
    esp.Size = UDim2.new(0, 200, 0, 50)
    esp.StudsOffset = Vector3.new(0, 3, 0)
    esp.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    esp.Parent = ESPFolder
    
    -- Nome do jogador
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1, 0, 0, 20)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Config.Colors.TextPrimary
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.TextSize = 14
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = esp
    
    -- Distância
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Name = "DistanceLabel"
    distanceLabel.Size = UDim2.new(1, 0, 0, 15)
    distanceLabel.Position = UDim2.new(0, 0, 0, 20)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Text = "0m"
    distanceLabel.TextColor3 = Config.Colors.TextSecondary
    distanceLabel.TextStrokeTransparency = 0.5
    distanceLabel.TextSize = 12
    distanceLabel.Font = Enum.Font.Gotham
    distanceLabel.Parent = esp
    
    -- Vida
    local healthLabel = Instance.new("TextLabel")
    healthLabel.Name = "HealthLabel"
    healthLabel.Size = UDim2.new(1, 0, 0, 15)
    healthLabel.Position = UDim2.new(0, 0, 0, 35)
    healthLabel.BackgroundTransparency = 1
    healthLabel.Text = "100 HP"
    healthLabel.TextColor3 = Config.Colors.Success
    healthLabel.TextStrokeTransparency = 0.5
    healthLabel.TextSize = 12
    healthLabel.Font = Enum.Font.Gotham
    healthLabel.Parent = esp
    
    -- Caixa 3D (se suportado)
    pcall(function()
        if Drawing then
            -- Implementação com Drawing (não disponível em todos os executores)
        end
    end)
    
    return esp
end

local function UpdateESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local espItem = ESPFolder:FindFirstChild("ESP_" .. player.Name)
            
            if not espItem and ESPEnabled then
                espItem = CreatePlayerESP(player)
            end
            
            if espItem then
                local character = player.Character
                if character and character:FindFirstChild("HumanoidRootPart") and ESPEnabled then
                    local hrp = character:FindFirstChild("HumanoidRootPart")
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    
                    -- Verificar distância máxima
                    local distance = (hrp.Position - Camera.CFrame.Position).Magnitude
                    if distance > Config.ESP.MaxDistance then
                        espItem.Enabled = false
                        continue
                    end
                    
                    espItem.Adornee = hrp
                    espItem.Enabled = true
                    
                    -- Nome do jogador
                    local nameLabel = espItem:FindFirstChild("NameLabel")
                    if nameLabel then
                        -- Cor do time
                        if Config.ESP.UseTeamColor and player.Team then
                            nameLabel.TextColor3 = player.TeamColor.Color
                        else
                            nameLabel.TextColor3 = Config.Colors.TextPrimary
                        end
                    end
                    
                    -- Distância
                    local distanceLabel = espItem:FindFirstChild("DistanceLabel")
                    if distanceLabel then
                        distanceLabel.Text = math.floor(distance) .. "m"
                        distanceLabel.Visible = Config.ESP.ShowDistance
                    end
                    
                    -- Vida
                    local healthLabel = espItem:FindFirstChild("HealthLabel")
                    if healthLabel and humanoid then
                        local health = math.floor(humanoid.Health)
                        local maxHealth = math.floor(humanoid.MaxHealth)
                        healthLabel.Text = health .. " HP"
                        
                        -- Cor baseada na vida
                        local healthRatio = health / maxHealth
                        healthLabel.TextColor3 = Color3.fromRGB(
                            255 * (1 - healthRatio),
                            255 * healthRatio,
                            50
                        )
                        
                        healthLabel.Visible = Config.ESP.ShowHealth
                    end
                else
                    espItem.Enabled = false
                end
            end
        end
    end
end

-- Sistema de voo melhorado
local FlyGyro, FlyVel
local IsGoingUp, IsGoingDown = false, false

local function EnableFly()
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        ShowStatus("Erro: Personagem não encontrado", Config.Colors.Danger)
        FlyEnabled = false
        return
    end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    
    FlyGyro = Instance.new("BodyGyro")
    FlyGyro.P = 9e4
    FlyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    FlyGyro.CFrame = hrp.CFrame
    FlyGyro.Parent = hrp
    
    FlyVel = Instance.new("BodyVelocity")
    FlyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    FlyVel.Velocity = Vector3.new(0, 0.1, 0)
    FlyVel.Parent = hrp
    
    -- Mostrar controles
    FlyControls.Visible = true
    
    -- Estados para os botões
    local isUp = false
    local isDown = false
    
    -- Eventos para botões de toque
    UpButton.MouseButton1Down:Connect(function()
        isUp = true
    end)
    
    UpButton.MouseButton1Up:Connect(function()
        isUp = false
    end)
    
    DownButton.MouseButton1Down:Connect(function()
        isDown = true
    end)
    
    DownButton.MouseButton1Up:Connect(function()
        isDown = false
    end)
    
    -- Loop principal do Fly
    RunService:BindToRenderStep("FlyLoop", 1, function()
        if not FlyEnabled then return end
        
        local character = LocalPlayer.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then
            DisableFly()
            return
        end
        
        local hrp = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        
        -- Atualizar orientação
        FlyGyro.CFrame = CFrame.new(hrp.Position, hrp.Position + Camera.CFrame.LookVector)
        
        -- Cálculo de velocidade
        local moveDir = humanoid.MoveDirection
        
        -- Movimento vertical baseado nos botões
        local verticalSpeed = 0
        if isUp then
            verticalSpeed = Config.Fly.VerticalSpeed
        elseif isDown then
            verticalSpeed = -Config.Fly.VerticalSpeed
        end
        
        -- Aplicar velocidade
        FlyVel.Velocity = Vector3.new(
            moveDir.X * Config.Fly.Speed,
            verticalSpeed,
            moveDir.Z * Config.Fly.Speed
        )
    end)
    
    ShowStatus("Fly ativado com sucesso", Config.Colors.Success)
end

local function DisableFly()
    RunService:UnbindFromRenderStep("FlyLoop")
    
    if FlyGyro then FlyGyro:Destroy() end
    if FlyVel then FlyVel:Destroy() end
    
    FlyGyro = nil
    FlyVel = nil
    
    -- Esconder controles
    FlyControls.Visible = false
    
    ShowStatus("Fly desativado", Config.Colors.Warning)
end

-- Aimbot aprimorado com "grude"
local function PredictPosition(player, targetPart)
    local character = player.Character
    if not character or not character:FindFirstChild(targetPart) then return nil end
    
    local part = character[targetPart]
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    if not humanoid then return part.Position end
    
    -- Predição básica
    if Config.Aimbot.Prediction and humanoid.MoveDirection.Magnitude > 0 then
        local velocity = humanoid.MoveDirection * humanoid.WalkSpeed
        return part.Position + (velocity * Config.Aimbot.PredictionStrength)
    else
        return part.Position
    end
end

local function GetClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
             -- Verificar time
            if Config.Aimbot.TeamCheck and player.Team == LocalPlayer.Team then
                continue
            end
            
            local character = player.Character
            if character and character:FindFirstChild(Config.Aimbot.TargetPart) and character:FindFirstChildOfClass("Humanoid") then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                
                -- Verificar se está vivo
                if humanoid.Health <= 0 then continue end
                
                -- Verificar visibilidade na tela
                local targetPart = character[Config.Aimbot.TargetPart]
                local screenPos, onScreen = Camera:WorldToScreenPoint(targetPart.Position)
                
                if onScreen then
                    -- Calcular distância do centro da tela
                    local screenCenter = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
                    local screenDistance = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                    
                    if screenDistance < shortestDistance then
                        shortestDistance = screenDistance
                        closestPlayer = player
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

local function EnableAimbot()
    -- Variável para controlar quando mirar
    local isAiming = false
    
    -- Para dispositivos móveis, usar toque
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            isAiming = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            isAiming = false
        end
    end)
    
    -- Loop do aimbot com "grude"
    RunService:BindToRenderStep("AimbotLoop", 1, function()
        if not AimbotEnabled then return end
        
        -- Verificar se está mirando
        if not isAiming then return end
        
        -- Encontrar alvo mais próximo
        local target = GetClosestPlayer()
        if not target then return end
        
        -- Mirar no alvo
        local character = target.Character
        if not character or not character:FindFirstChild(Config.Aimbot.TargetPart) then return end
        
        -- Predição de movimento avançada
        local predictedPosition = PredictPosition(target, Config.Aimbot.TargetPart)
        if not predictedPosition then return end
        
        -- Calcular nova orientação da câmera com "grude" (força adicional)
        local cameraPos = Camera.CFrame.Position
        local newCFrame = CFrame.new(cameraPos, predictedPosition)
        
        -- Aplicar aimbot com força total para "grudar" no alvo
        -- Quanto maior o Config.Aimbot.Strength, mais forte o "grude"
        Camera.CFrame = Camera.CFrame:Lerp(newCFrame, Config.Aimbot.Strength)
        
        -- Auto-atirar (opcional)
        if Config.Aimbot.AutoShoot then
            -- Tenta simular um clique do mouse se suportado pelo executor
            pcall(function()
                mouse1press()
                wait(0.1)
                mouse1release()
            end)
        end
    end)
    
    ShowStatus("Aimbot ativado! Toque para travar nos alvos", Config.Colors.Success)
end

local function DisableAimbot()
    RunService:UnbindFromRenderStep("AimbotLoop")
    ShowStatus("Aimbot desativado", Config.Colors.Warning)
end

-- Remover ESP de jogadores que saem
Players.PlayerRemoving:Connect(function(player)
    local esp = ESPFolder:FindFirstChild("ESP_" .. player.Name)
    if esp then esp:Destroy() end
end)

-- Conexões de botões
ESPButton.MouseButton1Click:Connect(function()
    ESPEnabled = ESPToggle()
    
    if ESPEnabled then
        -- Iniciar ESP
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                CreatePlayerESP(player)
            end
        end
        
        -- Monitorar novos jogadores
        Players.PlayerAdded:Connect(function(player)
            if player ~= LocalPlayer and ESPEnabled then
                CreatePlayerESP(player)
            end
        end)
        
        -- Atualizar ESP
        RunService:BindToRenderStep("UpdateESP", 5, UpdateESP)
        
        ShowStatus("ESP ativado com sucesso", Config.Colors.Success)
    else
        -- Parar ESP
        RunService:UnbindFromRenderStep("UpdateESP")
        ESPFolder:ClearAllChildren()
        
        ShowStatus("ESP desativado", Config.Colors.Warning)
    end
end)

FlyButton.MouseButton1Click:Connect(function()
    FlyEnabled = FlyToggle()
    
    if FlyEnabled then
        EnableFly()
    else
        DisableFly()
    end
end)

AimbotButton.MouseButton1Click:Connect(function()
    AimbotEnabled = AimbotToggle()
    
    if AimbotEnabled then
        EnableAimbot()
    else
        DisableAimbot()
    end
end)

-- Botão para fechar
CloseButton.MouseButton1Click:Connect(function()
    -- Efeito de fade out
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(MainFrame, tweenInfo, {BackgroundTransparency = 1}):Play()
    
    -- Desativar todos os recursos
    if ESPEnabled then
        ESPEnabled = false
        RunService:UnbindFromRenderStep("UpdateESP")
        ESPFolder:ClearAllChildren()
    end
    
    if FlyEnabled then
        FlyEnabled = false
        DisableFly()
    end
    
    if AimbotEnabled then
        AimbotEnabled = false
        DisableAimbot()
    end
    
    -- Remover a GUI após a animação
    wait(0.5)
    GUI:Destroy()
end)

-- Efeito de abertura
MainFrame.BackgroundTransparency = 1
TopPanel.BackgroundTransparency = 1

local openTween = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
TweenService:Create(MainFrame, openTween, {BackgroundTransparency = 0}):Play()
TweenService:Create(TopPanel, openTween, {BackgroundTransparency = 0}):Play()

-- Mostrar mensagem de inicialização
ShowStatus("Wirtz Script carregado com sucesso!", Config.Colors.Success)

-- Efeito de pulso para o título
spawn(function()
    while wait(2) do
        if not GUI or not GUI.Parent then break end
        
        TweenService:Create(Subtitle, TweenInfo.new(1), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        wait(1)
        TweenService:Create(Subtitle, TweenInfo.new(1), {TextColor3 = Config.Colors.Accent}):Play()
    end
end)
