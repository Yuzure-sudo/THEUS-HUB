-- THEUS-HUB Mobile | Versão Enhanced ESP
-- Versão 1.5 - Interface aprimorada e ESP garantido

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- Limpar GUI anterior se existir
local previousGUI = CoreGui:FindFirstChild("THEUS_HUB_Mobile")
if previousGUI then previousGUI:Destroy() end

-- Criar nova GUI
local GUI = Instance.new("ScreenGui")
GUI.Name = "THEUS_HUB_Mobile"
GUI.ResetOnSpawn = false
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GUI.Parent = CoreGui

-- Configurações
local Settings = {
    ESP = {
        Enabled = false,
        ShowName = true,
        ShowDistance = true,
        ShowHealth = true,
        TeamCheck = false,
        TeamColor = true,
        BoxEnabled = true,
        TextSize = 14,
        TextColor = Color3.fromRGB(255, 255, 255),
        BoxColor = Color3.fromRGB(255, 0, 0),
        BoxThickness = 1,
        MaxDistance = 500
    },
    Theme = {
        Background = Color3.fromRGB(25, 25, 35),
        DarkElement = Color3.fromRGB(35, 35, 45),
        LightElement = Color3.fromRGB(45, 45, 55),
        Accent = Color3.fromRGB(0, 175, 225),
        TextColor = Color3.fromRGB(255, 255, 255),
        BorderSize = 0
    }
}

-- Funções de Utilidade para Interface
local function AddUICorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function MakeElementsDraggable(gui, handle)
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
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
            update(input)
        end
    end)
end

-- Funções para controle de status
local StatusMessages = {}
local function ShowStatus(message, color, duration)
    if StatusLabel then
        table.insert(StatusMessages, {Message = message, Color = color, Time = os.clock(), Duration = duration or 3})
    end
end

local function UpdateStatusMessages()
    if #StatusMessages > 0 and StatusLabel then
        local currentTime = os.clock()
        local message = StatusMessages[1](StatusLabel.Text) = message.Message
        StatusLabel.TextColor3 = message.Color or Settings.Theme.TextColor
        
        if currentTime - message.Time >= message.Duration then
            table.remove(StatusMessages, 1)
        end
    end
end

-- Criar Interface Principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 350)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
MainFrame.BackgroundColor3 = Settings.Theme.Background
MainFrame.BorderSizePixel = Settings.Theme.BorderSize
MainFrame.Active = true
MainFrame.Parent = GUI

AddUICorner(MainFrame, 10)

-- Barra de Título
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Settings.Theme.DarkElement
TitleBar.BorderSizePixel = Settings.Theme.BorderSize
TitleBar.Parent = MainFrame

AddUICorner(TitleBar, 10)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, -40, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "THEUS-HUB Mobile v1.5"
TitleLabel.TextColor3 = Settings.Theme.TextColor
TitleLabel.TextSize = 18
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

-- Tornar o frame arrastável
MakeElementsDraggable(MainFrame, TitleBar)

-- Botão de Fechar
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = Settings.Theme.TextColor
CloseButton.TextSize = 16
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TitleBar

AddUICorner(CloseButton, 15)

-- Container de Conteúdo
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -20, 1, -50)
ContentFrame.Position = UDim2.new(0, 10, 0, 45)
ContentFrame.BackgroundTransparency = 1
ContentFrame.BorderSizePixel = 0
ContentFrame.Parent = MainFrame

-- Criar seção ESP
local ESPSection = Instance.new("Frame")
ESPSection.Name = "ESPSection"
ESPSection.Size = UDim2.new(1, 0, 0, 270)
ESPSection.BackgroundColor3 = Settings.Theme.LightElement
ESPSection.BorderSizePixel = 0
ESPSection.Parent = ContentFrame

AddUICorner(ESPSection, 8)

local ESPTitle = Instance.new("TextLabel")
ESPTitle.Name = "ESPTitle"
ESPTitle.Size = UDim2.new(1, 0, 0, 30)
ESPTitle.BackgroundTransparency = 1
ESPTitle.Text = "ESP Configuration"
ESPTitle.TextColor3 = Settings.Theme.TextColor
ESPTitle.TextSize = 16
ESPTitle.Font = Enum.Font.GothamBold
ESPTitle.Parent = ESPSection

-- Botão principal ESP
local ESPToggle = Instance.new("TextButton")
ESPToggle.Name = "ESPToggle"
ESPToggle.Size = UDim2.new(1, -20, 0, 45)
ESPToggle.Position = UDim2.new(0, 10, 0, 35)
ESPToggle.BackgroundColor3 = Settings.Theme.Accent
ESPToggle.BorderSizePixel = 0
ESPToggle.Text = "ACTIVATE ESP"
ESPToggle.TextColor3 = Settings.Theme.TextColor
ESPToggle.TextSize = 18
ESPToggle.Font = Enum.Font.GothamBold
ESPToggle.Parent = ESPSection

AddUICorner(ESPToggle, 8)

-- Opções do ESP (checkboxes)
local function CreateToggleOption(text, position, defaultValue)
    local optionFrame = Instance.new("Frame")
    optionFrame.Name = text .. "Option"
    optionFrame.Size = UDim2.new(1, -20, 0, 30)
    optionFrame.Position = position
    optionFrame.BackgroundTransparency = 1
    optionFrame.Parent = ESPSection
    
    local optionLabel = Instance.new("TextLabel")
    optionLabel.Size = UDim2.new(0, 150, 1, 0)
    optionLabel.BackgroundTransparency = 1
    optionLabel.Text = text
    optionLabel.TextColor3 = Settings.Theme.TextColor
    optionLabel.TextSize = 16
    optionLabel.Font = Enum.Font.Gotham
    optionLabel.TextXAlignment = Enum.TextXAlignment.Left
    optionLabel.Parent = optionFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, 30, 0, 30)
    toggleButton.Position = UDim2.new(1, -30, 0, 0)
    toggleButton.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 70, 70)
    toggleButton.BorderSizePixel = 0
    toggleButton.Text = defaultValue and "ON" or "OFF"
    toggleButton.TextColor3 = Settings.Theme.TextColor
    toggleButton.TextSize = 14
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.Parent = optionFrame
    
    AddUICorner(toggleButton, 6)
    
    local value = defaultValue
    
    toggleButton.MouseButton1Click:Connect(function()
        value = not value
        toggleButton.Text = value and "ON" or "OFF"
        toggleButton.BackgroundColor3 = value and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 70, 70)
        
        -- Atualizar configuração
        local settingPath = text:gsub(" ", "")
        if settingPath == "Names" then
            Settings.ESP.ShowName = value
        elseif settingPath == "Distance" then
            Settings.ESP.ShowDistance = value
        elseif settingPath == "Health" then
            Settings.ESP.ShowHealth = value
        elseif settingPath == "TeamCheck" then
            Settings.ESP.TeamCheck = value
        elseif settingPath == "TeamColor" then
            Settings.ESP.TeamColor = value
        elseif settingPath == "Boxes" then
            Settings.ESP.BoxEnabled = value
        end
    end)
    
    return optionFrame, toggleButton, value
end

-- Criar as opções do ESP
local option1, toggle1 = CreateToggleOption("Names", UDim2.new(0, 10, 0, 90), Settings.ESP.ShowName)
local option2, toggle2 = CreateToggleOption("Distance", UDim2.new(0, 10, 0, 125), Settings.ESP.ShowDistance)
local option3, toggle3 = CreateToggleOption("Health", UDim2.new(0, 10, 0, 160), Settings.ESP.ShowHealth)
local option4, toggle4 = CreateToggleOption("Team Check", UDim2.new(0, 10, 0, 195), Settings.ESP.TeamCheck)
local option5, toggle5 = CreateToggleOption("Team Color", UDim2.new(0, 10, 0, 230), Settings.ESP.TeamColor)

-- Status da aplicação
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(1, 0, 0, 30)
StatusLabel.Position = UDim2.new(0, 0, 1, -30)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Ready to use"
StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
StatusLabel.TextSize = 14
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Parent = MainFrame

-- Sistema de ESP Aprimorado
local ESPContainer = Instance.new("Folder")
ESPContainer.Name = "ESPElements"
ESPContainer.Parent = GUI

-- Função para criar o ESP para um jogador
function CreatePlayerESP(player)
    if player == LocalPlayer then return end
    
    -- Criamos um container para armazenar todos os elementos do ESP para esse jogador
    local espFolder = Instance.new("Folder")
    espFolder.Name = "ESP_" .. player.Name
    espFolder.Parent = ESPContainer
    
    -- Texto principal (nome + distância + vida)
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "ESPBillboard"
    billboardGui.AlwaysOnTop = true
    billboardGui.Size = UDim2.new(0, 200, 0, 50)
    billboardGui.StudsOffset = Vector3.new(0, 3, 0)
    billboardGui.Parent = espFolder
    
    -- Nome do jogador
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1, 0, 0, Settings.ESP.TextSize)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Settings.ESP.TextColor
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.TextSize = Settings.ESP.TextSize
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.Parent = billboardGui
    
    -- Distância
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Name = "DistanceLabel"
    distanceLabel.Size = UDim2.new(1, 0, 0, Settings.ESP.TextSize)
    distanceLabel.Position = UDim2.new(0, 0, 0, Settings.ESP.TextSize)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Text = "0m"
    distanceLabel.TextColor3 = Settings.ESP.TextColor
    distanceLabel.TextStrokeTransparency = 0.5
    distanceLabel.TextSize = Settings.ESP.TextSize - 2
    distanceLabel.Font = Enum.Font.SourceSans
    distanceLabel.Parent = billboardGui
    
    -- Vida
    local healthLabel = Instance.new("TextLabel")
    healthLabel.Name = "HealthLabel"
    healthLabel.Size = UDim2.new(1, 0, 0, Settings.ESP.TextSize)
    healthLabel.Position = UDim2.new(0, 0, 0, Settings.ESP.TextSize * 2)
    healthLabel.BackgroundTransparency = 1
    healthLabel.Text = "100 HP"
    healthLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    healthLabel.TextStrokeTransparency = 0.5
    healthLabel.TextSize = Settings.ESP.TextSize - 2
    healthLabel.Font = Enum.Font.SourceSans
    healthLabel.Parent = billboardGui
    
    return espFolder
end

-- Função para atualizar o ESP de um jogador
function UpdatePlayerESP(espFolder)
    local playerName = espFolder.Name:sub(5) -- Remover "ESP_" do nome
    local player = Players:FindFirstChild(playerName)
    
    -- Verificar se o jogador ainda existe
    if not player then
        espFolder:Destroy()
        return
    end
    
    -- Verificar se o personagem existe
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") or not character:FindFirstChildOfClass("Humanoid") then
        for _, item in pairs(espFolder:GetChildren()) do
            item.Enabled = false
        end
        return
    end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local hrp = character:FindFirstChild("HumanoidRootPart")
    
    -- Verificar se está dentro da distância máxima
    local distance = (hrp.Position - Camera.CFrame.Position).Magnitude
    if distance > Settings.ESP.MaxDistance then
        for _, item in pairs(espFolder:GetChildren()) do
            item.Enabled = false
        end
        return
    end
    
    -- Verificar time se necessário
    if Settings.ESP.TeamCheck and player.Team == LocalPlayer.Team then
        for _, item in pairs(espFolder:GetChildren()) do
            item.Enabled = false
        end
        return
    end
    
    -- Atualizar billboard
    local billboard = espFolder:FindFirstChild("ESPBillboard")
    if billboard then
        billboard.Enabled = true
        billboard.Adornee = hrp
        
        -- Atualizar nome
        local nameLabel = billboard:FindFirstChild("NameLabel")
        if nameLabel then
            nameLabel.Visible = Settings.ESP.ShowName
            
            -- Cor baseada no time se ativado
            if Settings.ESP.TeamColor and player.Team then
                nameLabel.TextColor3 = player.TeamColor.Color
            else
                nameLabel.TextColor3 = Settings.ESP.TextColor
            end
        end
        
        -- Atualizar distância
        local distanceLabel = billboard:FindFirstChild("DistanceLabel")
        if distanceLabel then
            distanceLabel.Visible = Settings.ESP.ShowDistance
            distanceLabel.Text = math.floor(distance) .. "m"
        end
        
        -- Atualizar vida
        local healthLabel = billboard:FindFirstChild("HealthLabel")
        if healthLabel and humanoid then
            healthLabel.Visible = Settings.ESP.ShowHealth
            
            local health = math.floor(humanoid.Health)
            local maxHealth = math.floor(humanoid.MaxHealth)
            healthLabel.Text = health .. " HP"
            
            -- Cor baseada na porcentagem de vida
            local healthPercent = health / maxHealth
            healthLabel.TextColor3 = Color3.fromRGB(
                255 * (1 - healthPercent),
                255 * healthPercent,
                50
            )
        end
    end
end

-- Gerenciamento do ESP
function EnableESP()
    -- Limpar ESP existente
    ESPContainer:ClearAllChildren()
    
    -- Criar ESP para jogadores existentes
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            CreatePlayerESP(player)
        end
    end
    
    -- Lidar com jogadores que entram no jogo
    local playerAddedConnection = Players.PlayerAdded:Connect(function(player)
        CreatePlayerESP(player)
    end)
    
    -- Lidar com jogadores que saem do jogo
    local playerRemovingConnection = Players.PlayerRemoving:Connect(function(player)
        local espFolder = ESPContainer:FindFirstChild("ESP_" .. player.Name)
        if espFolder then
            espFolder:Destroy()
        end
    end)
    
    -- Atualizar ESP em tempo real
    RunService:BindToRenderStep("ESPUpdate", 5, function()
        if not Settings.ESP.Enabled then return end
        
        for _, espFolder in pairs(ESPContainer:GetChildren()) do
            UpdatePlayerESP(espFolder)
        end
        
        -- Atualizar mensagens de status
        UpdateStatusMessages()
    end)
    
    -- Guardar as conexões para desconectar depois
    ESPContainer:SetAttribute("PlayerAddedConnection", playerAddedConnection)
    ESPContainer:SetAttribute("PlayerRemovingConnection", playerRemovingConnection)
    
    ShowStatus("ESP Ativado com Sucesso", Color3.fromRGB(100, 255, 100))
    ESPToggle.Text = "DISABLE ESP"
    ESPToggle.BackgroundColor3 = Color3.fromRGB(200, 70, 70)
end

function DisableESP()
    -- Desconectar eventos
    local playerAddedConnection = ESPContainer:GetAttribute("PlayerAddedConnection")
    local playerRemovingConnection = ESPContainer:GetAttribute("PlayerRemovingConnection")
    
    if playerAddedConnection then
        playerAddedConnection:Disconnect()
    end
    
    if playerRemovingConnection then
        playerRemovingConnection:Disconnect()
    end
    
    -- Parar o loop de atualização
    RunService:UnbindFromRenderStep("ESPUpdate")
    
    -- Limpar elementos ESP
    ESPContainer:ClearAllChildren()
    
    ShowStatus("ESP Desativado", Color3.fromRGB(255, 150, 100))
    ESPToggle.Text = "ACTIVATE ESP"
    ESPToggle.BackgroundColor3 = Settings.Theme.Accent
end

-- Conectar botões a funções
ESPToggle.MouseButton1Click:Connect(function()
    Settings.ESP.Enabled = not Settings.ESP.Enabled
    
    if Settings.ESP.Enabled then
        EnableESP()
    else
        DisableESP()
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    if Settings.ESP.Enabled then
        DisableESP()
    end
    
    GUI:Destroy()
end)

-- Inicializar
ShowStatus("THEUS-HUB Mobile v1.5 Carregado", Color3.fromRGB(100, 255, 100), 3)