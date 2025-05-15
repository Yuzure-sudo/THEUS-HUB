-- Wirtz Script Premium - Versão Mobile
-- Interface aprimorada com aimbot melhorado

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
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
    ESP = {
        TextSize = 14,
        MaxDistance = 2000
    },
    Fly = {
        Speed = 85,
        VerticalSpeed = 75
    },
    Aimbot = {
        LockStrength = 1, -- 1 = travado, valores menores = mais suave
        TeamCheck = true,
        TargetPart = "Head",
        Range = 1000
    },
    Colors = {
        Primary = Color3.fromRGB(25, 25, 35),
        Secondary = Color3.fromRGB(35, 35, 50),
        Accent = Color3.fromRGB(85, 85, 255),
        AccentDark = Color3.fromRGB(65, 65, 175),
        Enabled = Color3.fromRGB(255, 80, 80),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(180, 180, 180),
        Success = Color3.fromRGB(85, 185, 85),
        Warning = Color3.fromRGB(230, 180, 80)
    }
}

-- Funções de UI
local function AddUICorner(element, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = element
    return corner
end

local function AddShadow(element)
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 6, 1, 6)
    shadow.Position = UDim2.new(0, -3, 0, -3)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.7
    shadow.BorderSizePixel = 0
    shadow.ZIndex = -1
    AddUICorner(shadow, 10)
    shadow.Parent = element
    return shadow
end

local function MakeElementDraggable(gui)
    local dragging = false
    local dragInput, dragStart, startPos
    
    gui.InputBegan:Connect(function(input)
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
    
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Interface Principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 280, 0, 320)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -160)
MainFrame.BackgroundColor3 = Config.Colors.Primary
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = GUI

AddUICorner(MainFrame, 10)
AddShadow(MainFrame)
MakeElementDraggable(MainFrame)

-- Barra superior
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Config.Colors.Secondary
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

AddUICorner(TopBar, 10)

-- Impedir que arredonde a parte inferior
local TopBarCover = Instance.new("Frame")
TopBarCover.Name = "TopBarCover"
TopBarCover.Size = UDim2.new(1, 0, 0.5, 0)
TopBarCover.Position = UDim2.new(0, 0, 0.5, 0)
TopBarCover.BackgroundColor3 = Config.Colors.Secondary
TopBarCover.BorderSizePixel = 0
TopBarCover.Parent = TopBar

-- Logo
local LogoLabel = Instance.new("TextLabel")
LogoLabel.Name = "LogoLabel"
LogoLabel.Size = UDim2.new(0, 40, 0, 40)
LogoLabel.Position = UDim2.new(0, 10, 0, 0)
LogoLabel.BackgroundTransparency = 1
LogoLabel.Text = "W"
LogoLabel.TextColor3 = Config.Colors.Accent
LogoLabel.TextSize = 28
LogoLabel.Font = Enum.Font.GothamBold
LogoLabel.Parent = TopBar

-- Título
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, -70, 0, 40)
TitleLabel.Position = UDim2.new(0, 60, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Wirtz Script"
TitleLabel.TextColor3 = Config.Colors.Text
TitleLabel.TextSize = 18
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

-- Container para os botões
local ButtonContainer = Instance.new("Frame")
ButtonContainer.Name = "ButtonContainer"
ButtonContainer.Size = UDim2.new(1, -20, 1, -50)
ButtonContainer.Position = UDim2.new(0, 10, 0, 45)
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.Parent = MainFrame

-- Criar botões estilizados
local function CreateStyledButton(name, position, iconText, info)
    -- Container principal
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Name = name .. "Frame"
    buttonFrame.Size = UDim2.new(1, 0, 0, 75)
    buttonFrame.Position = position
    buttonFrame.BackgroundColor3 = Config.Colors.Secondary
    buttonFrame.BorderSizePixel = 0
    buttonFrame.Parent = ButtonContainer
    
    AddUICorner(buttonFrame, 8)
    
    -- Ícone circular
    local iconCircle = Instance.new("Frame")
    iconCircle.Name = "IconCircle"
    iconCircle.Size = UDim2.new(0, 50, 0, 50)
    iconCircle.Position = UDim2.new(0, 12, 0.5, -25)
    iconCircle.BackgroundColor3 = Config.Colors.Accent
    iconCircle.BorderSizePixel = 0
    iconCircle.Parent = buttonFrame
    
    AddUICorner(iconCircle, 25)
    
    -- Ícone (texto)
    local icon = Instance.new("TextLabel")
    icon.Name = "Icon"
    icon.Size = UDim2.new(1, 0, 1, 0)
    icon.BackgroundTransparency = 1
    icon.Text = iconText
    icon.TextColor3 = Config.Colors.Text
    icon.TextSize = 24
    icon.Font = Enum.Font.GothamBold
    icon.Parent = iconCircle
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(0, 120, 0, 30)
    title.Position = UDim2.new(0, 75, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = name
    title.TextColor3 = Config.Colors.Text
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = buttonFrame
    
    -- Informação
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Name = "Info"
    infoLabel.Size = UDim2.new(0, 150, 0, 20)
    infoLabel.Position = UDim2.new(0, 75, 0, 40)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = info
    infoLabel.TextColor3 = Config.Colors.SubText
    infoLabel.TextSize = 14
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.TextXAlignment = Enum.TextXAlignment.Left
    infoLabel.Parent = buttonFrame
    
    -- Status (ON/OFF)
    local status = Instance.new("TextLabel")
    status.Name = "Status"
    status.Size = UDim2.new(0, 40, 0, 30)
    status.Position = UDim2.new(1, -50, 0.5, -15)
    status.BackgroundTransparency = 1
    status.Text = "OFF"
    status.TextColor3 = Config.Colors.SubText
    status.TextSize = 16
    status.Font = Enum.Font.GothamBold
    status.Parent = buttonFrame
    
    -- Botão invisível para clique
    local button = Instance.new("TextButton")
    button.Name = name .. "Button"
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = ""
    button.Parent = buttonFrame
    
    -- Estado
    local enabled = false
    
    -- Função para atualizar visual
    local function updateVisual()
        if enabled then
            iconCircle.BackgroundColor3 = Config.Colors.Enabled
            status.Text = "ON"
            status.TextColor3 = Config.Colors.Enabled
        else
            iconCircle.BackgroundColor3 = Config.Colors.Accent
            status.Text = "OFF"
            status.TextColor3 = Config.Colors.SubText
        end
    end
    
    -- Efeito de clique
    button.MouseButton1Click:Connect(function()
        enabled = not enabled
        updateVisual()
    end)
    
    return button, function() return enabled end, function(value)
        enabled = value
        updateVisual()
    end
end

-- Criar os 3 botões principais
local yPos = 0
local spacing = 85

local ESPButton, GetESPState, SetESPState = CreateStyledButton(
    "ESP", 
    UDim2.new(0, 0, 0, yPos),
    "👁️",
    "Ver jogadores através das paredes"
)
yPos = yPos + spacing

local FlyButton, GetFlyState, SetFlyState = CreateStyledButton(
    "Fly", 
    UDim2.new(0, 0, 0, yPos),
    "✈️",
    "Voe livremente pelo mapa"
)
yPos = yPos + spacing

local AimbotButton, GetAimbotState, SetAimbotState = CreateStyledButton(
    "Aimbot", 
    UDim2.new(0, 0, 0, yPos),
    "🎯",
    "Mira automática travada nos inimigos"
)

-- Rodapé com status
local StatusBar = Instance.new("Frame")
StatusBar.Name = "StatusBar"
StatusBar.Size = UDim2.new(1, 0, 0, 30)
StatusBar.Position = UDim2.new(0, 0, 1, -30)
StatusBar.BackgroundColor3 = Config.Colors.Secondary
StatusBar.BorderSizePixel = 0
StatusBar.Parent = MainFrame

-- Cantos arredondados apenas na parte inferior
local StatusBarCorner = Instance.new("UICorner")
StatusBarCorner.CornerRadius = UDim.new(0, 10)
StatusBarCorner.Parent = StatusBar

-- Cobrir os cantos superiores
local StatusBarCover = Instance.new("Frame")
StatusBarCover.Name = "StatusBarCover"
StatusBarCover.Size = UDim2.new(1, 0, 0.5, 0)
StatusBarCover.BackgroundColor3 = Config.Colors.Secondary
StatusBarCover.BorderSizePixel = 0
StatusBarCover.Parent = StatusBar

-- Texto de status
local StatusText = Instance.new("TextLabel")
StatusText.Name = "StatusText"
StatusText.Size = UDim2.new(1, -10, 1, 0)
StatusText.Position = UDim2.new(0, 10, 0, 0)
StatusText.BackgroundTransparency = 1
StatusText.Text = "Wirtz Script carregado!"
StatusText.TextColor3 = Config.Colors.Success
StatusText.TextSize = 14
StatusText.Font = Enum.Font.Gotham
StatusText.TextXAlignment = Enum.TextXAlignment.Left
StatusText.Parent = StatusBar

-- Botões de controle para Fly
local FlyControls = Instance.new("Frame")
FlyControls.Name = "FlyControls"
FlyControls.Size = UDim2.new(0, 80, 0, 160)
FlyControls.Position = UDim2.new(0, 10, 0.5, -80)
FlyControls.BackgroundTransparency = 1
FlyControls.Visible = false
FlyControls.Parent = GUI

