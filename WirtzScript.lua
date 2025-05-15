-- // Arise Crossover Hub by wirtz.dev
-- // Versão 1.0

-- // Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")

-- // Variáveis
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HRP = Character:WaitForChild("HumanoidRootPart")
local Camera = workspace.CurrentCamera

-- // Anti-AFK
for _, connection in pairs(getconnections(LocalPlayer.Idled)) do
    connection:Disable()
end

-- // Limpar GUIs existentes
pcall(function()
    for _, gui in pairs(game:GetService("CoreGui"):GetChildren()) do
        if gui.Name == "AriseHubGUI" or gui.Name == "MinimizedCube" then
            gui:Destroy()
        end
    end
end)

-- // Cores e Temas
local Theme = {
    Background = Color3.fromRGB(25, 25, 30),
    Accent = Color3.fromRGB(87, 115, 255),
    LightAccent = Color3.fromRGB(100, 130, 255),
    DarkAccent = Color3.fromRGB(70, 90, 210),
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(200, 200, 200),
    Border = Color3.fromRGB(50, 50, 60),
    Header = Color3.fromRGB(30, 30, 35),
    Button = Color3.fromRGB(40, 40, 45)
}

-- // Configurações
local Config = {
    AutoFarm = {
        Enabled = false,
        Target = "None",
        Range = 10,
        Mode = "Normal"
    },
    Combat = {
        AutoAttack = false,
        AutoDodge = false,
        AttackSpeed = 1
    },
    Movement = {
        Speed = false,
        SpeedMultiplier = 2,
        Jump = false,
        JumpMultiplier = 2,
        NoClip = false
    },
    Visual = {
        ESP = false,
        FullBright = false,
        ChestESP = false,
        ItemESP = false
    },
    Misc = {
        AutoQuest = false,
        AutoPickup = false,
        InfiniteStamina = false
    }
}

-- // Criar GUI Principal
local AriseHubGUI = Instance.new("ScreenGui")
AriseHubGUI.Name = "AriseHubGUI"
AriseHubGUI.ResetOnSpawn = false

-- Tentar adicionar à CoreGui
pcall(function()
    if syn and syn.protect_gui then
        syn.protect_gui(AriseHubGUI)
        AriseHubGUI.Parent = game:GetService("CoreGui")
    else
        AriseHubGUI.Parent = game:GetService("CoreGui")
    end
end)
if not AriseHubGUI.Parent then
    AriseHubGUI.Parent = LocalPlayer.PlayerGui
end

-- GUI Minimizada (Cubo)
local MinimizedCube = Instance.new("ScreenGui")
MinimizedCube.Name = "MinimizedCube"
MinimizedCube.ResetOnSpawn = false
MinimizedCube.Enabled = false

pcall(function()
    if syn and syn.protect_gui then
        syn.protect_gui(MinimizedCube)
        MinimizedCube.Parent = game:GetService("CoreGui")
    else
        MinimizedCube.Parent = game:GetService("CoreGui")
    end
end)
if not MinimizedCube.Parent then
    MinimizedCube.Parent = LocalPlayer.PlayerGui
end

-- Criar o Cubo de Minimizar
local CubeButton = Instance.new("ImageButton")
CubeButton.Name = "CubeButton"
CubeButton.Size = UDim2.new(0, 50, 0, 50)
CubeButton.Position = UDim2.new(0.05, 0, 0.5, -25)
CubeButton.BackgroundColor3 = Theme.Accent
CubeButton.BorderSizePixel = 0
CubeButton.Image = "rbxassetid://6031280882" -- ID de uma imagem de cubo
CubeButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
CubeButton.ImageTransparency = 0.2
CubeButton.Parent = MinimizedCube

local CubeCorner = Instance.new("UICorner")
CubeCorner.CornerRadius = UDim.new(0.2, 0)
CubeCorner.Parent = CubeButton

local CubePulse = Instance.new("UIStroke")
CubePulse.Color = Theme.LightAccent
CubePulse.Thickness = 2
CubePulse.Parent = CubeButton

-- Animação de pulso para o cubo
spawn(function()
    while true do
        TweenService:Create(CubePulse, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Transparency = 0.8}):Play()
        wait(2)
    end
end)

-- Draggable para o cubo
local isDraggingCube = false
local dragStartCube
local startPosCube

CubeButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDraggingCube = true
        dragStartCube = input.Position
        startPosCube = CubeButton.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDraggingCube and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStartCube
        CubeButton.Position = UDim2.new(
            startPosCube.X.Scale, startPosCube.X.Offset + delta.X,
            startPosCube.Y.Scale, startPosCube.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDraggingCube = false
    end
end)

-- Interface principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 700, 0, 450)
MainFrame.Position = UDim2.new(0.5, -350, 0.5, -225)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = AriseHubGUI

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Theme.Border
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- Barra de título
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Theme.Header
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

-- Bloco para corrigir cantos da barra de título
local TitleBlocker = Instance.new("Frame")
TitleBlocker.Size = UDim2.new(1, 0, 0.5, 0)
TitleBlocker.Position = UDim2.new(0, 0, 0.5, 0)
TitleBlocker.BackgroundColor3 = Theme.Header
TitleBlocker.BorderSizePixel = 0
TitleBlocker.ZIndex = 0
TitleBlocker.Parent = TitleBar

-- Logo
local Logo = Instance.new("ImageLabel")
Logo.Name = "Logo"
Logo.Size = UDim2.new(0, 30, 0, 30)
Logo.Position = UDim2.new(0, 10, 0, 5)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://6026568198" -- Logo genérico
Logo.Parent = TitleBar

-- Título
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -120, 1, 0)
Title.Position = UDim2.new(0, 50, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Arise Crossover Hub"
Title.TextColor3 = Theme.Text
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Botão minimizar
local MinimizeButton = Instance.new("ImageButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 24, 0, 24)
MinimizeButton.Position = UDim2.new(1, -70, 0, 8)
MinimizeButton.BackgroundTransparency = 1
MinimizeButton.Image = "rbxassetid://6031094678" -- Ícone de minimizar
MinimizeButton.Parent = TitleBar

-- Botão fechar
local CloseButton = Instance.new("ImageButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 24, 0, 24)
CloseButton.Position = UDim2.new(1, -35, 0, 8)
CloseButton.BackgroundTransparency = 1
CloseButton.Image = "rbxassetid://6031094687" -- Ícone de fechar
CloseButton.Parent = TitleBar

-- Tornar a interface arrastável
local isDragging = false
local dragStart = nil
local startPos = nil

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
    end
end)

-- Container de abas
local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Size = UDim2.new(0, 150, 1, -40)
TabContainer.Position = UDim2.new(0, 0, 0, 40)
TabContainer.BackgroundColor3 = Theme.Header
TabContainer.BorderSizePixel = 0
TabContainer.Parent = MainFrame

-- Conteúdo das abas
local TabContent = Instance.new("Frame")
TabContent.Name = "TabContent"
TabContent.Size = UDim2.new(1, -150, 1, -40)
TabContent.Position = UDim2.new(0, 150, 0, 40)
TabContent.BackgroundTransparency = 1
TabContent.Parent = MainFrame

-- Função para criar uma nova aba
local selectedTab = nil
local tabs = {}

local function CreateTab(name, icon)
    -- Botão da aba
    local tabButton = Instance.new("TextButton")
    tabButton.Name = name .. "Tab"
    tabButton.Size = UDim2.new(1, 0, 0, 40)
    tabButton.Position = UDim2.new(0, 0, 0, #tabs * 40)
    tabButton.BackgroundTransparency = 1
    tabButton.Text = ""
    tabButton.Parent = TabContainer
    
    local tabIcon = Instance.new("ImageLabel")
    tabIcon.Name = "Icon"
    tabIcon.Size = UDim2.new(0, 20, 0, 20)
    tabIcon.Position = UDim2.new(0, 15, 0.5, -10)
    tabIcon.BackgroundTransparency = 1
    tabIcon.Image = icon
    tabIcon.ImageColor3 = Theme.SubText
    tabIcon.Parent = tabButton
    
    local tabText = Instance.new("TextLabel")
    tabText.Name = "Text"
    tabText.Size = UDim2.new(0, 100, 1, 0)
    tabText.Position = UDim2.new(0, 45, 0, 0)
    tabText.BackgroundTransparency = 1
    tabText.Text = name
    tabText.TextColor3 = Theme.SubText
    tabText.TextSize = 15
    tabText.Font = Enum.Font.GothamSemibold
    tabText.TextXAlignment = Enum.TextXAlignment.Left
    tabText.Parent = tabButton
    
    -- Indicador de seleção
    local tabIndicator = Instance.new("Frame")
    tabIndicator.Name = "Indicator"
    tabIndicator.Size = UDim2.new(0, 4, 1, -10)
    tabIndicator.Position = UDim2.new(0, 0, 0, 5)
    tabIndicator.BackgroundColor3 = Theme.Accent
    tabIndicator.BorderSizePixel = 0
    tabIndicator.Visible = false
    tabIndicator.Parent = tabButton
    
    -- Container do conteúdo da aba
    local tabFrame = Instance.new("ScrollingFrame")
    tabFrame.Name = name .. "Frame"
    tabFrame.Size = UDim2.new(1, -20, 1, -20)
    tabFrame.Position = UDim2.new(0, 10, 0, 10)
    tabFrame.BackgroundTransparency = 1
    tabFrame.BorderSizePixel = 0
    tabFrame.ScrollBarThickness = 4
    tabFrame.ScrollBarImageColor3 = Theme.Accent
    tabFrame.Visible = false
    tabFrame.Parent = TabContent
    
    local tabUIListLayout = Instance.new("UIListLayout")
    tabUIListLayout.Padding = UDim.new(0, 10)
    tabUIListLayout.Parent = tabFrame
    
    -- Adicionar à lista de abas
    table.insert(tabs, {
        Button = tabButton,
        Frame = tabFrame,
        Indicator = tabIndicator,
        Icon = tabIcon,
        Text = tabText
    })
    
    -- Comportamento de clique
    tabButton.MouseButton1Click:Connect(function()
        -- Desselecionar aba atual
        if selectedTab then
            selectedTab.Indicator.Visible = false
            selectedTab.Icon.ImageColor3 = Theme.SubText
            selectedTab.Text.TextColor3 = Theme.SubText
            selectedTab.Frame.Visible = false
        end
        
        -- Selecionar nova aba
        tabIndicator.Visible = true
        tabIcon.ImageColor3 = Theme.Accent
        tabText.TextColor3 = Theme.Text
        tabFrame.Visible = true
        selectedTab = {
            Indicator = tabIndicator,
            Icon = tabIcon,
            Text = tabText,
            Frame = tabFrame
        }
    end)
    
    -- Retornar o frame para adicionar elementos
    return tabFrame
end

-- Função para criar uma seção
local function CreateSection(parent, title)
    local sectionContainer = Instance.new("Frame")
    sectionContainer.Name = title .. "Section"
    sectionContainer.Size = UDim2.new(1, 0, 0, 30) -- Será redimensionado depois
    sectionContainer.BackgroundTransparency = 1
    sectionContainer.Parent = parent
    
    local sectionTitle = Instance.new("TextLabel")
    sectionTitle.Name = "Title"
    sectionTitle.Size = UDim2.new(1, 0, 0, 30)
    sectionTitle.BackgroundTransparency = 1
    sectionTitle.Text = title
    sectionTitle.TextColor3 = Theme.Accent
    sectionTitle.TextSize = 16
    sectionTitle.Font = Enum.Font.GothamBold
    sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    sectionTitle.Parent = sectionContainer
    
    local sectionContent = Instance.new("Frame")
    sectionContent.Name = "Content"
    sectionContent.Size = UDim2.new(1, 0, 0, 0) -- Será redimensionado quando elementos forem adicionados
    sectionContent.Position = UDim2.new(0, 0, 0, 30)
    sectionContent.BackgroundTransparency = 1
    sectionContent.Parent = sectionContainer
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 8)
    contentLayout.Parent = sectionContent
    
    -- Atualizar tamanho da seção quando elementos forem adicionados
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        sectionContent.Size = UDim2.new(1, 0, 0, contentLayout.AbsoluteContentSize.Y)
        sectionContainer.Size = UDim2.new(1, 0, 0, 30 + contentLayout.AbsoluteContentSize.Y)
    end)
    
    return sectionContent
end

-- Função para criar um toggle
local function CreateToggle(parent, title, description, default, callback)
    local toggleContainer = Instance.new("Frame")
    toggleContainer.Name = title .. "Toggle"
    toggleContainer.Size = UDim2.new(1, 0, 0, 50)
    toggleContainer.BackgroundColor3 = Theme.Button
    toggleContainer.BorderSizePixel = 0
    toggleContainer.Parent = parent
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = toggleContainer
    
    local toggleTitle = Instance.new("TextLabel")
    toggleTitle.Name = "Title"
    toggleTitle.Size = UDim2.new(1, -60, 0, 20)
    toggleTitle.Position = UDim2.new(0, 12, 0, 8)
    toggleTitle.BackgroundTransparency = 1
    toggleTitle.Text = title
    toggleTitle.TextColor3 = Theme.Text
    toggleTitle.TextSize = 15
    toggleTitle.Font = Enum.Font.GothamSemibold
    toggleTitle.TextXAlignment = Enum.TextXAlignment.Left
    toggleTitle.Parent = toggleContainer
    
    local toggleDescription = Instance.new("TextLabel")
    toggleDescription.Name = "Description"
    toggleDescription.Size = UDim2.new(1, -60, 0, 16)
    toggleDescription.Position = UDim2.new(0, 12, 1, -24)
    toggleDescription.BackgroundTransparency = 1
    toggleDescription.Text = description
    toggleDescription.TextColor3 = Theme.SubText
    toggleDescription.TextSize = 13
    toggleDescription.Font = Enum.Font.Gotham
    toggleDescription.TextXAlignment = Enum.TextXAlignment.Left
    toggleDescription.TextWrapped = true
    toggleDescription.Parent = toggleContainer
    
    local switch = Instance.new("Frame")
    switch.Name = "Switch"
    switch.Size = UDim2.new(0, 40, 0, 20)
    switch.Position = UDim2.new(1, -52, 0.5, -10)
    switch.BackgroundColor3 = default and Theme.Accent or Color3.fromRGB(60, 60, 65)
    switch.BorderSizePixel = 0
    switch.Parent = toggleContainer
    
    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(0, 10)
    switchCorner.Parent = switch
    
    local knob = Instance.new("Frame")
    knob.Name = "Knob"
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = UDim2.new(default and 1 or 0, default and -18 or 2, 0.5, -8)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Parent = switch
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(0, 8)
    knobCorner.Parent = knob
    
    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = ""
    button.Parent = toggleContainer
    
    local toggled = default
    
    button.MouseButton1Click:Connect(function()
        toggled = not toggled
        
        local targetPosition = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        local targetColor = toggled and Theme.Accent or Color3.fromRGB(60, 60, 65)
        
        TweenService:Create(knob, TweenInfo.new(0.2), {Position = targetPosition}):Play()
        TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
        
        callback(toggled)
    end)
    
    return {
        Instance = toggleContainer,
        SetValue = function(value)
            toggled = value
            
            local targetPosition = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            local targetColor = toggled and Theme.Accent or Color3.fromRGB(60, 60, 65)
            
            knob.Position = targetPosition
            switch.BackgroundColor3 = targetColor
            
            callback(toggled)
        end,
        GetValue = function()
            return toggled
        end
    }
end

-- Função para criar um slider
local function CreateSlider(parent, title, min, max, default, suffix, callback)
    local sliderContainer = Instance.new("Frame")
    sliderContainer.Name = title .. "Slider"
    sliderContainer.Size = UDim2.new(1, 0, 0, 60)
    sliderContainer.BackgroundColor3 = Theme.Button
    sliderContainer.BorderSizePixel = 0
    sliderContainer.Parent = parent
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 6)
    sliderCorner.Parent = sliderContainer
    
    local sliderTitle = Instance.new("TextLabel")
    sliderTitle.Name = "Title"
    sliderTitle.Size = UDim2.new(1, -100, 0, 20)
    sliderTitle.Position = UDim2.new(0, 12, 0, 8)
    sliderTitle.BackgroundTransparency = 1
    sliderTitle.Text = title
    sliderTitle.TextColor3 = Theme.Text
    sliderTitle.TextSize = 15
    sliderTitle.Font = Enum.Font.GothamSemibold
    sliderTitle.TextXAlignment = Enum.TextXAlignment.Left
    sliderTitle.Parent = sliderContainer
    
    local valueDisplay = Instance.new("TextLabel")
    valueDisplay.Name = "Value"
    valueDisplay.Size = UDim2.new(0, 80, 0, 20)
    valueDisplay.Position = UDim2.new(1, -92, 0, 8)
    valueDisplay.BackgroundTransparency = 1
    valueDisplay.Text = default .. suffix
    valueDisplay.TextColor3 = Theme.Text
    valueDisplay.TextSize = 15
    valueDisplay.Font = Enum.Font.GothamSemibold
    valueDisplay.TextXAlignment = Enum.TextXAlignment.Right
    valueDisplay.Parent = sliderContainer
    
    local sliderBack = Instance.new("Frame")
    sliderBack.Name = "Back"
    sliderBack.Size = UDim2.new(1, -24, 0, 6)
    sliderBack.Position = UDim2.new(0, 12, 0, 40)
    sliderBack.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    sliderBack.BorderSizePixel = 0
    sliderBack.Parent = sliderContainer
    
    local sliderBackCorner = Instance.new("UICorner")
    sliderBackCorner.CornerRadius = UDim.new(0, 3)
    sliderBackCorner.Parent = sliderBack
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "Fill"
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Theme.Accent
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBack
    
    local sliderFillCorner = Instance.new("UICorner")
    sliderFillCorner.CornerRadius = UDim.new(0, 3)
    sliderFillCorner.Parent = sliderFill
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Name = "Button"
    sliderButton.Size = UDim2.new(1, 0, 1, 0)
    sliderButton.BackgroundTransparency = 1
    sliderButton.Text = ""
    sliderButton.Parent = sliderBack
    
    local function updateSlider(input)
        local relativePos = math.clamp((input - sliderBack.AbsolutePosition.X) / sliderBack.AbsoluteSize.X, 0, 1)
        local value = min + ((max - min) * relativePos)
        
        -- Arredondar para o mais próximo de 0.01
        value = math.floor(value * 100) / 100
        
        sliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
        valueDisplay.Text = value .. suffix
        
        callback(value)
    end
    
    sliderButton.MouseButton1Down:Connect(function()
        local mouseConnection
        local inputEndedConnection
        
        mouseConnection = RunService.RenderStepped:Connect(function()
            updateSlider(UserInputService:GetMouseLocation().X)
        end)
        
        inputEndedConnection = UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                mouseConnection:Disconnect()
                inputEndedConnection:Disconnect()
            end
        end)
    end)
    
    return {
        Instance = sliderContainer,
        SetValue = function(value)
            value = math.clamp(value, min, max)
            local relativePos = (value - min) / (max - min)
            
            sliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
            valueDisplay.Text = value .. suffix
            
            callback(value)
        end
    }
end


    -- Função para criar um dropdown
    local function CreateDropdown(parent, title, options, default, callback)
        local dropdownContainer = Instance.new("Frame")
        dropdownContainer.Name = title .. "Dropdown"
        dropdownContainer.Size = UDim2.new(1, 0, 0, 50)
        dropdownContainer.BackgroundColor3 = Theme.Button
        dropdownContainer.BorderSizePixel = 0
        dropdownContainer.ClipsDescendants = true
        dropdownContainer.Parent = parent
        
        local dropdownCorner = Instance.new("UICorner")
        dropdownCorner.CornerRadius = UDim.new(0, 6)
        dropdownCorner.Parent = dropdownContainer
        
        local dropdownTitle = Instance.new("TextLabel")
        dropdownTitle.Name = "Title"
        dropdownTitle.Size = UDim2.new(1, -12, 0, 20)
        dropdownTitle.Position = UDim2.new(0, 12, 0, 8)
        dropdownTitle.BackgroundTransparency = 1
        dropdownTitle.Text = title
        dropdownTitle.TextColor3 = Theme.Text
        dropdownTitle.TextSize = 15
        dropdownTitle.Font = Enum.Font.GothamSemibold
        dropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
        dropdownTitle.Parent = dropdownContainer
        
        local dropdownButton = Instance.new("TextButton")
        dropdownButton.Name = "Button"
        dropdownButton.Size = UDim2.new(1, -24, 0, 25)
        dropdownButton.Position = UDim2.new(0, 12, 0, 30)
        dropdownButton.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        dropdownButton.BorderSizePixel = 0
        dropdownButton.Text = ""
        dropdownButton.Parent = dropdownContainer
        
        local dropdownButtonCorner = Instance.new("UICorner")
        dropdownButtonCorner.CornerRadius = UDim.new(0, 4)
        dropdownButtonCorner.Parent = dropdownButton
        
        local selectedText = Instance.new("TextLabel")
        selectedText.Name = "SelectedText"
        selectedText.Size = UDim2.new(1, -30, 1, 0)
        selectedText.Position = UDim2.new(0, 10, 0, 0)
        selectedText.BackgroundTransparency = 1
        selectedText.Text = default or "Select..."
        selectedText.TextColor3 = Theme.Text
        selectedText.TextSize = 14
        selectedText.Font = Enum.Font.Gotham
        selectedText.TextXAlignment = Enum.TextXAlignment.Left
        selectedText.Parent = dropdownButton
        
        local dropdownArrow = Instance.new("ImageLabel")
        dropdownArrow.Name = "Arrow"
        dropdownArrow.Size = UDim2.new(0, 16, 0, 16)
        dropdownArrow.Position = UDim2.new(1, -20, 0.5, -8)
        dropdownArrow.BackgroundTransparency = 1
        dropdownArrow.Image = "rbxassetid://6031091004" -- Seta para baixo
        dropdownArrow.ImageColor3 = Theme.SubText
        dropdownArrow.Parent = dropdownButton
        
        local optionsContainer = Instance.new("Frame")
        optionsContainer.Name = "Options"
        optionsContainer.Size = UDim2.new(1, -24, 0, 0) -- Será ajustado com base nas opções
        optionsContainer.Position = UDim2.new(0, 12, 0, 60)
        optionsContainer.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        optionsContainer.BorderSizePixel = 0
        optionsContainer.Visible = false
        optionsContainer.Parent = dropdownContainer
        
        local optionsCorner = Instance.new("UICorner")
        optionsCorner.CornerRadius = UDim.new(0, 4)
        optionsCorner.Parent = optionsContainer
        
        local optionsList = Instance.new("Frame")
        optionsList.Name = "List"
        optionsList.Size = UDim2.new(1, -10, 1, -10)
        optionsList.Position = UDim2.new(0, 5, 0, 5)
        optionsList.BackgroundTransparency = 1
        optionsList.Parent = optionsContainer
        
        local optionsLayout = Instance.new("UIListLayout")
        optionsLayout.Padding = UDim.new(0, 5)
        optionsLayout.Parent = optionsList
        
        -- Preencher opções
        local optionsHeight = 0
        for i, option in ipairs(options) do
            local optionButton = Instance.new("TextButton")
            optionButton.Name = option
            optionButton.Size = UDim2.new(1, 0, 0, 25)
            optionButton.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
            optionButton.BorderSizePixel = 0
            optionButton.Text = ""
            optionButton.AutoButtonColor = false
            optionButton.Parent = optionsList
            
            local optionCorner = Instance.new("UICorner")
            optionCorner.CornerRadius = UDim.new(0, 4)
            optionCorner.Parent = optionButton
            
            local optionText = Instance.new("TextLabel")
            optionText.Size = UDim2.new(1, -10, 1, 0)
            optionText.Position = UDim2.new(0, 10, 0, 0)
            optionText.BackgroundTransparency = 1
            optionText.Text = option
            optionText.TextColor3 = Theme.Text
            optionText.TextSize = 14
            optionText.Font = Enum.Font.Gotham
            optionText.TextXAlignment = Enum.TextXAlignment.Left
            optionText.Parent = optionButton
            
            optionButton.MouseEnter:Connect(function()
                TweenService:Create(optionButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 65)}):Play()
            end)
            
            optionButton.MouseLeave:Connect(function()
                TweenService:Create(optionButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 55)}):Play()
            end)
            
            optionButton.MouseButton1Click:Connect(function()
                selectedText.Text = option
                
                -- Fechar dropdown
                TweenService:Create(dropdownContainer, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 50)}):Play()
                TweenService:Create(dropdownArrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                optionsContainer.Visible = false
                
                callback(option)
            end)
            
            optionsHeight = optionsHeight + 30 -- 25 para altura + 5 para padding
        end
        
        -- Ajustar altura do container de opções
        optionsContainer.Size = UDim2.new(1, -24, 0, math.min(optionsHeight, 150))
        
        -- Adicionar scrolling se necessário
        if optionsHeight > 150 then
            optionsList:Destroy() -- Remover o frame existente
            
            local scrollingOptionsList = Instance.new("ScrollingFrame")
            scrollingOptionsList.Name = "List"
            scrollingOptionsList.Size = UDim2.new(1, -10, 1, -10)
            scrollingOptionsList.Position = UDim2.new(0, 5, 0, 5)
            scrollingOptionsList.BackgroundTransparency = 1
            scrollingOptionsList.BorderSizePixel = 0
            scrollingOptionsList.ScrollBarThickness = 4
            scrollingOptionsList.ScrollBarImageColor3 = Theme.Accent
            scrollingOptionsList.CanvasSize = UDim2.new(0, 0, 0, optionsHeight)
            scrollingOptionsList.Parent = optionsContainer
            
            optionsLayout.Parent = scrollingOptionsList
            
            -- Mover as opções para o novo scrolling frame
            for _, option in ipairs(options) do
                local optionButton = Instance.new("TextButton")
                optionButton.Name = option
                optionButton.Size = UDim2.new(1, -4, 0, 25)
                optionButton.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
                optionButton.BorderSizePixel = 0
                optionButton.Text = ""
                optionButton.AutoButtonColor = false
                optionButton.Parent = scrollingOptionsList
                
                local optionCorner = Instance.new("UICorner")
                optionCorner.CornerRadius = UDim.new(0, 4)
                optionCorner.Parent = optionButton
                
                local optionText = Instance.new("TextLabel")
                optionText.Size = UDim2.new(1, -10, 1, 0)
                optionText.Position = UDim2.new(0, 10, 0, 0)
                optionText.BackgroundTransparency = 1
                optionText.Text = option
                optionText.TextColor3 = Theme.Text
                optionText.TextSize = 14
                optionText.Font = Enum.Font.Gotham
                optionText.TextXAlignment = Enum.TextXAlignment.Left
                optionText.Parent = optionButton
                
                optionButton.MouseEnter:Connect(function()
                    TweenService:Create(optionButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 65)}):Play()
                end)
                
                optionButton.MouseLeave:Connect(function()
                    TweenService:Create(optionButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 55)}):Play()
                end)
                
                optionButton.MouseButton1Click:Connect(function()
                    selectedText.Text = option
                    
                    -- Fechar dropdown
                    TweenService:Create(dropdownContainer, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 50)}):Play()
                    TweenService:Create(dropdownArrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                    optionsContainer.Visible = false
                    
                    callback(option)
                end)
            end
        end
        
        -- Estado do dropdown
        local isOpen = false
        
        -- Comportamento de clique
        dropdownButton.MouseButton1Click:Connect(function()
            isOpen = not isOpen
            
            if isOpen then
                -- Abrir dropdown
                TweenService:Create(dropdownContainer, TweenInfo.new(0.2), 
                    {Size = UDim2.new(1, 0, 0, 50 + optionsContainer.AbsoluteSize.Y + 10)}):Play()
                TweenService:Create(dropdownArrow, TweenInfo.new(0.2), {Rotation = 180}):Play()
                optionsContainer.Visible = true
            else
                -- Fechar dropdown
                TweenService:Create(dropdownContainer, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 50)}):Play()
                TweenService:Create(dropdownArrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                optionsContainer.Visible = false
            end
        end)
        
        -- Retornar API
        return {
            Instance = dropdownContainer,
            SetValue = function(value)
                if table.find(options, value) then
                    selectedText.Text = value
                    callback(value)
                end
            end,
            GetValue = function()
                return selectedText.Text
            end
        }
    end

    -- Função para criar um botão
    local function CreateButton(parent, title, description, callback)
        local buttonContainer = Instance.new("Frame")
        buttonContainer.Name = title .. "Button"
        buttonContainer.Size = UDim2.new(1, 0, 0, 50)
        buttonContainer.BackgroundColor3 = Theme.Button
        buttonContainer.BorderSizePixel = 0
        buttonContainer.Parent = parent
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 6)
        buttonCorner.Parent = buttonContainer
        
        local buttonTitle = Instance.new("TextLabel")
        buttonTitle.Name = "Title"
        buttonTitle.Size = UDim2.new(1, -24, 0, 20)
        buttonTitle.Position = UDim2.new(0, 12, 0, 8)
        buttonTitle.BackgroundTransparency = 1
        buttonTitle.Text = title
        buttonTitle.TextColor3 = Theme.Text
        buttonTitle.TextSize = 15
        buttonTitle.Font = Enum.Font.GothamSemibold
        buttonTitle.TextXAlignment = Enum.TextXAlignment.Left
        buttonTitle.Parent = buttonContainer
        
        local buttonDescription = Instance.new("TextLabel")
        buttonDescription.Name = "Description"
        buttonDescription.Size = UDim2.new(1, -24, 0, 16)
        buttonDescription.Position = UDim2.new(0, 12, 1, -24)
        buttonDescription.BackgroundTransparency = 1
        buttonDescription.Text = description
        buttonDescription.TextColor3 = Theme.SubText
        buttonDescription.TextSize = 13
        buttonDescription.Font = Enum.Font.Gotham
        buttonDescription.TextXAlignment = Enum.TextXAlignment.Left
        buttonDescription.TextWrapped = true
        buttonDescription.Parent = buttonContainer
        
        local buttonClick = Instance.new("TextButton")
        buttonClick.Name = "Click"
        buttonClick.Size = UDim2.new(1, 0, 1, 0)
        buttonClick.BackgroundTransparency = 1
        buttonClick.Text = ""
        buttonClick.Parent = buttonContainer
        
        -- Efeito de hover
        buttonClick.MouseEnter:Connect(function()
            TweenService:Create(buttonContainer, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(55, 55, 65)}):Play()
        end)
        
        buttonClick.MouseLeave:Connect(function()
            TweenService:Create(buttonContainer, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Button}):Play()
        end)
        
        -- Efeito de clique
        buttonClick.MouseButton1Down:Connect(function()
            TweenService:Create(buttonContainer, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(45, 45, 55)}):Play()
        end)
        
        buttonClick.MouseButton1Up:Connect(function()
            TweenService:Create(buttonContainer, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(55, 55, 65)}):Play()
        end)
        
        buttonClick.MouseButton1Click:Connect(callback)
        
        return buttonContainer
    end

    -- Função para criar um input de texto
    local function CreateTextInput(parent, title, placeholder, callback)
        local inputContainer = Instance.new("Frame")
        inputContainer.Name = title .. "Input"
        inputContainer.Size = UDim2.new(1, 0, 0, 60)
        inputContainer.BackgroundColor3 = Theme.Button
        inputContainer.BorderSizePixel = 0
        inputContainer.Parent = parent
        
        local inputCorner = Instance.new("UICorner")
        inputCorner.CornerRadius = UDim.new(0, 6)
        inputCorner.Parent = inputContainer
        
        local inputTitle = Instance.new("TextLabel")
        inputTitle.Name = "Title"
        inputTitle.Size = UDim2.new(1, -12, 0, 20)
        inputTitle.Position = UDim2.new(0, 12, 0, 8)
        inputTitle.BackgroundTransparency = 1
        inputTitle.Text = title
        inputTitle.TextColor3 = Theme.Text
        inputTitle.TextSize = 15
        inputTitle.Font = Enum.Font.GothamSemibold
        inputTitle.TextXAlignment = Enum.TextXAlignment.Left
        inputTitle.Parent = inputContainer
        
        local inputBox = Instance.new("TextBox")
        inputBox.Name = "Input"
        inputBox.Size = UDim2.new(1, -24, 0, 25)
        inputBox.Position = UDim2.new(0, 12, 0, 28)
        inputBox.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        inputBox.BorderSizePixel = 0
        inputBox.PlaceholderText = placeholder
        inputBox.PlaceholderColor3 = Color3.fromRGB(140, 140, 150)
        inputBox.Text = ""
        inputBox.TextColor3 = Theme.Text
        inputBox.TextSize = 14
        inputBox.Font = Enum.Font.Gotham
        inputBox.TextXAlignment = Enum.TextXAlignment.Left
        inputBox.Parent = inputContainer
        
        local inputPadding = Instance.new("UIPadding")
        inputPadding.PaddingLeft = UDim.new(0, 10)
        inputPadding.Parent = inputBox
        
        local inputCorner = Instance.new("UICorner")
        inputCorner.CornerRadius = UDim.new(0, 4)
        inputCorner.Parent = inputBox
        
        inputBox.Changed:Connect(function(prop)
            if prop == "Text" then
                callback(inputBox.Text)
            end
        end)
        
        return {
            Instance = inputContainer,
            SetValue = function(value)
                inputBox.Text = value
            end,
            GetValue = function()
                return inputBox.Text
            end
        }
    end

    -- Criar abas
    local homeTab = CreateTab("Home", "rbxassetid://6026568198")
    local combatTab = CreateTab("Combat", "rbxassetid://6034509993")
    local farmTab = CreateTab("Farming", "rbxassetid://6031280882")
    local teleportTab = CreateTab("Teleport", "rbxassetid://6034479958")
    local visualTab = CreateTab("Visual", "rbxassetid://6034328955")
    local miscTab = CreateTab("Misc", "rbxassetid://6031075931")
    local settingsTab = CreateTab("Settings", "rbxassetid://6031280882")

    -- Selecionar primeira aba por padrão
    if #tabs > 0 then
        tabs[1].Button.MouseButton1Click:Fire()
    end

    -- Preencher aba Home
    local homeWelcome = CreateSection(homeTab, "Welcome")
    
    CreateButton(homeWelcome, "Welcome to Arise Crossover Hub", "The most advanced script for Arise Crossover with multiple features.", function()
        -- Apenas informação, sem ação necessária
    end)
    
    local homeStats = CreateSection(homeTab, "Your Stats")
    
    CreateButton(homeStats, "Player Information", "Level: " .. (LocalPlayer.Level and LocalPlayer.Level.Value or "N/A") .. " | Health: 100%", function() end)
    
    local homeSocial = CreateSection(homeTab, "Socials")
    
    CreateButton(homeSocial, "Join our Discord", "Get notified about updates and more features.", function()
        setclipboard("https://discord.gg/examplelink")
        
        -- Notificação
        local notification = Instance.new("Frame")
        notification.Name = "Notification"
        notification.Size = UDim2.new(0, 250, 0, 60)
        notification.Position = UDim2.new(0.5, -125, 0, -70)
        notification.BackgroundColor3 = Theme.Header
        notification.BorderSizePixel = 0
        notification.Parent = AriseHubGUI
        
        local notifCorner = Instance.new("UICorner")
        notifCorner.CornerRadius = UDim.new(0, 6)
        notifCorner.Parent = notification
        
        local notifTitle = Instance.new("TextLabel")
        notifTitle.Name = "Title"
        notifTitle.Size = UDim2.new(1, -20, 0, 25)
        notifTitle.Position = UDim2.new(0, 10, 0, 5)
        notifTitle.BackgroundTransparency = 1
        notifTitle.Text = "Discord Link Copied!"
        notifTitle.TextColor3 = Theme.Text
        notifTitle.TextSize = 16
        notifTitle.Font = Enum.Font.GothamBold
        notifTitle.Parent = notification
        
        local notifMessage = Instance.new("TextLabel")
        notifMessage.Name = "Message"
        notifMessage.Size = UDim2.new(1, -20, 0, 20)
        notifMessage.Position = UDim2.new(0, 10, 0, 30)
        notifMessage.BackgroundTransparency = 1
        notifMessage.Text = "Invitation link has been copied to clipboard."
        notifMessage.TextColor3 = Theme.SubText
        notifMessage.TextSize = 14
        notifMessage.Font = Enum.Font.Gotham
        notifMessage.Parent = notification
        
        -- Animação de entrada
        TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -125, 0, 20)}):Play()
        
        -- Animação de saída após 3 segundos
        spawn(function()
            wait(3)
            TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -125, 0, -70)}):Play()
            wait(0.3)
            notification:Destroy()
        end)
    end)

    -- Preencher aba Combat
    local combatMain = CreateSection(combatTab, "Combat Features")
    
    local autoAttackToggle = CreateToggle(combatMain, "Auto Attack", "Automatically attacks nearby enemies", false, function(value)
        Config.Combat.AutoAttack = value
    end)
    
    local autoDodgeToggle = CreateToggle(combatMain, "Auto Dodge", "Automatically dodges incoming attacks", false, function(value)
        Config.Combat.AutoDodge = value
    end)
    
    local attackSpeedSlider = CreateSlider(combatMain, "Attack Speed", 1, 5, 1, "x", function(value)
        Config.Combat.AttackSpeed = value
    end)
    
    -- Preencher aba Farming
    local farmingMain = CreateSection(farmTab, "Auto Farm")
    
    local autoFarmToggle = CreateToggle(farmingMain, "Auto Farm", "Automatically farms the selected target", false, function(value)
        Config.AutoFarm.Enabled = value
    end)
    
    local farmTargetDropdown = CreateDropdown(farmingMain, "Farm Target", {"Monsters", "Bosses", "Chests", "Items"}, "Monsters", function(value)
        Config.AutoFarm.Target = value
    end)
    
    local farmRangeSlider = CreateSlider(farmingMain, "Farm Range", 5, 30, 10, "m", function(value)
        Config.AutoFarm.Range = value
    end)
    
    local farmModeDropdown = CreateDropdown(farmingMain, "Farm Mode", {"Normal", "Aggressive", "Stealth"}, "Normal", function(value)
        Config.AutoFarm.Mode = value
    end)
    
    -- Preencher aba Visual
    local visualMain = CreateSection(visualTab, "ESP")
    
    local espToggle = CreateToggle(visualMain, "Player ESP", "Show player boxes, names, and distance", false, function(value)
        Config.Visual.ESP = value
    end)
    
    local chestEspToggle = CreateToggle(visualMain, "Chest ESP", "Show chest locations with distance", false, function(value)
        Config.Visual.ChestESP = value
    end)
    
    local itemEspToggle = CreateToggle(visualMain, "Item ESP", "Show dropped items with names", false, function(value)
        Config.Visual.ItemESP = value
    end)
    
    local visualEffects = CreateSection(visualTab, "Effects")
    
    local fullBrightToggle = CreateToggle(visualEffects, "Full Bright", "Removes darkness and enhances visibility", false, function(value)
        Config.Visual.FullBright = value
        
        -- Implementação do Full Bright
        if value then
            local lighting = game:GetService("Lighting")
            lighting.Brightness = 2
            lighting.ClockTime = 14
            lighting.FogEnd = 100000
            lighting.GlobalShadows = false
            lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        else
            local lighting = game:GetService("Lighting")
            lighting.Brightness = 1
            lighting.ClockTime = lighting:GetMinutesAfterMidnight() / 60
            lighting.FogEnd = 500
            lighting.GlobalShadows = true
            lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
        end
    end)
    
    -- Preencher aba Movement
    local movementSection = CreateSection(teleportTab, "Movement")
    
    local speedToggle = CreateToggle(movementSection, "Speed Hack", "Increases your movement speed", false, function(value)
        Config.Movement.Speed = value
        
        -- Implementação do Speed Hack
        if value then
            OriginalWalkSpeed = Humanoid.WalkSpeed
            Humanoid.WalkSpeed = OriginalWalkSpeed * Config.Movement.SpeedMultiplier
        else
            Humanoid.WalkSpeed = OriginalWalkSpeed
        end
    end)
    
    local speedMultiplierSlider = CreateSlider(movementSection, "Speed Multiplier", 1, 10, 2, "x", function(value)
        Config.Movement.SpeedMultiplier = value
        
        if Config.Movement.Speed then
            Humanoid.WalkSpeed = OriginalWalkSpeed * value
        end
    end)
    
    local jumpToggle = CreateToggle(movementSection, "Jump Power", "Increases your jump height", false, function(value)
        Config.Movement.Jump = value
        
        -- Implementação do Jump Power
        if value then
            OriginalJumpPower = Humanoid.JumpPower
            Humanoid.JumpPower = OriginalJumpPower * Config.Movement.JumpMultiplier
        else
            Humanoid.JumpPower = OriginalJumpPower
        end
    end)
    
    local jumpMultiplierSlider = CreateSlider(movementSection, "Jump Multiplier", 1, 5, 2, "x", function(value)
        Config.Movement.JumpMultiplier = value
        
        if Config.Movement.Jump then
            Humanoid.JumpPower = OriginalJumpPower * value
        end
    end)
    
    local noClipToggle = CreateToggle(movementSection, "No Clip", "Walk through walls and objects", false, function(value)
        Config.Movement.NoClip = value
    end)
    
    local teleportSection = CreateSection(teleportTab, "Teleport")
    
    -- Preencher aba Misc
    local miscSection = CreateSection(miscTab, "Utilities")
    
    local autoQuestToggle = CreateToggle(miscSection, "Auto Quest", "Automatically accepts and completes quests", false, function(value)
        Config.Misc.AutoQuest = value
    end)
    
    local autoPickupToggle = CreateToggle(miscSection, "Auto Pickup", "Automatically collects nearby items", false, function(value)
        Config.Misc.AutoPickup = value
    end)
    
    local infiniteStaminaToggle = CreateToggle(miscSection, "Infinite Stamina", "Never run out of stamina", false, function(value)
        Config.Misc.InfiniteStamina = value
    end)
    
    -- Preencher aba Settings
    local settingsSection = CreateSection(settingsTab, "Interface")
    
    local uiToggleInput = CreateTextInput(settingsSection, "UI Toggle Key", "RightControl", function(value)
        -- Parser básico para converter texto em KeyCode
        local keyMap = {
            ["rightcontrol"] = Enum.KeyCode.RightControl,
            ["leftcontrol"] = Enum.KeyCode.LeftControl,
            ["rightalt"] = Enum.KeyCode.RightAlt,
            ["leftalt"] = Enum.KeyCode.LeftAlt,
            ["rightshift"] = Enum.KeyCode.RightShift,
            ["leftshift"] = Enum.KeyCode.LeftShift,
            ["q"] = Enum.KeyCode.Q,
            ["e"] = Enum.KeyCode.E,
            ["r"] = Enum.KeyCode.R,
            ["t"] = Enum.KeyCode.T,
            ["y"] = Enum.KeyCode.Y,
            ["u"] = Enum.KeyCode.U,
            ["p"] = Enum.KeyCode.P,
            ["f"] = Enum.KeyCode.F,
            ["g"] = Enum.KeyCode.G,
            ["h"] = Enum.KeyCode.H,
            ["j"] = Enum.KeyCode.J,
            ["k"] = Enum.KeyCode.K,
            ["l"] = Enum.KeyCode.L,
            ["z"] = Enum.KeyCode.Z,
            ["x"] = Enum.KeyCode.X,
            ["c"] = Enum.KeyCode.C,
            ["v"] = Enum.KeyCode.V,
            ["b"] = Enum.KeyCode.B,
            ["n"] = Enum.KeyCode.N,
            ["m"] = Enum.KeyCode.M
        }
        
        local lowerValue = value:lower()
        if keyMap[lowerValue] then
            ToggleKey = keyMap[lowerValue]
        end
    end)
    
    -- Configuração de funcionalidades do botão fechar/minimizar
    CloseButton.MouseButton1Click:Connect(function()
        AriseHubGUI:Destroy()
        MinimizedCube:Destroy()
        
        -- Limpar connections e reverter alterações
        for _, connection in pairs(getconnections(RunService.RenderStepped)) do
            if connection.Function and string.find(debug.info(connection.Function, "s"), "AriseHub") then
                connection:Disconnect()
            end
        end
        
        -- Restaurar valores originais
        if Humanoid then
            Humanoid.WalkSpeed = OriginalWalkSpeed
            Humanoid.JumpPower = OriginalJumpPower
        end
    end)
    
    MinimizeButton.MouseButton1Click:Connect(function()
        -- Minimizar GUI principal e mostrar o cubo
        AriseHubGUI.Enabled = false
        MinimizedCube.Enabled = true
        
        -- Efeito de animação
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
    end)
    
    CubeButton.MouseButton1Click:Connect(function()
        -- Maximizar GUI principal e esconder o cubo
        AriseHubGUI.Enabled = true
        MinimizedCube.Enabled = false
        
        -- Resetar tamanho para animação
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        
        -- Animar abertura
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 700, 0, 450), Position = UDim2.new(0.5, -350, 0.5, -225)}):Play()
    end)
    
    -- Alternância de interface com tecla de atalho
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == ToggleKey then
            if AriseHubGUI.Enabled then
                MinimizeButton.MouseButton1Click:Fire()
            else
                CubeButton.MouseButton1Click:Fire()
            end
        end
    end)
    
    -- Implementação de funcionalidades principais
    
    -- Sistema Auto Farm
    local farmConnection = nil
    local function AutoFarm()
        if farmConnection then farmConnection:Disconnect() end
        
        if not Config.AutoFarm.Enabled then return end
        
        farmConnection = RunService.Heartbeat:Connect(function()
            if not Config.AutoFarm.Enabled then farmConnection:Disconnect() return end
            
            -- Verificar se o personagem está vivo
            if not Character or not Character:FindFirstChild("HumanoidRootPart") or not Character:FindFirstChildOfClass("Humanoid") or Character:FindFirstChildOfClass("Humanoid").Health <= 0 then
                return
            end
            
            local HRP = Character:FindFirstChild("HumanoidRootPart")
            local targetPart = nil
            local closestDistance = math.huge
            local targetModel = nil
            
            -- Função para verificar NPCs e monstros
            local function CheckNPC(model)
                if not model:IsA("Model") then return end
                if not model:FindFirstChild("HumanoidRootPart") or not model:FindFirstChildOfClass("Humanoid") then return end
                if model:FindFirstChildOfClass("Humanoid").Health <= 0 then return end
                
                local enemyHRP = model:FindFirstChild("HumanoidRootPart")
                local distance = (HRP.Position - enemyHRP.Position).Magnitude
                
                if distance <= Config.AutoFarm.Range and distance < closestDistance then
                    -- Verificar tipo de alvo baseado na seleção
                    local isValidTarget = false
                    
                    if Config.AutoFarm.Target == "Monsters" and not model:FindFirstChild("BossTag") then
                        isValidTarget = true
                    elseif Config.AutoFarm.Target == "Bosses" and model:FindFirstChild("BossTag") then
                        isValidTarget = true
                    end
                    
                    if isValidTarget then
                        closestDistance = distance
                        targetPart = enemyHRP
                        targetModel = model
                    end
                end
            end
            
            -- Função para verificar baús e itens
            local function CheckItem(item)
                if not item:IsA("Model") and not item:IsA("Part") and not item:IsA("MeshPart") then return end
                
                local itemPart = item:IsA("Model") and (item:FindFirstChild("HumanoidRootPart") or item:FindFirstChild("PrimaryPart") or item:FindFirstChildWhichIsA("BasePart")) or item
                
                if not itemPart then return end
                
                local distance = (HRP.Position - itemPart.Position).Magnitude
                
                if distance <= Config.AutoFarm.Range and distance < closestDistance then
                    -- Verificar tipo de alvo baseado na seleção
                    local isValidTarget = false
                    
                    if Config.AutoFarm.Target == "Chests" and (item.Name:lower():find("chest") or item.Name:lower():find("treasure")) then
                        isValidTarget = true
                    elseif Config.AutoFarm.Target == "Items" and not (item.Name:lower():find("chest") or item.Name:lower():find("treasure")) then
                        isValidTarget = true
                    end
                    
                    if isValidTarget then
                        closestDistance = distance
                        targetPart = itemPart
                        targetModel = item
                    end
                end
            end
            
            -- Procurar alvos no workspace
            if Config.AutoFarm.Target == "Monsters" or Config.AutoFarm.Target == "Bosses" then
                for _, model in pairs(workspace:GetChildren()) do
                    CheckNPC(model)
                end
                
                -- Verificar pastas específicas do jogo onde inimigos possam estar
                local enemyFolders = {"Enemies", "Monsters", "NPCs", "Mobs", "Spawns"}
                for _, folderName in ipairs(enemyFolders) do
                    local folder = workspace:FindFirstChild(folderName)
                    if folder then
                        for _, model in pairs(folder:GetChildren()) do
                            CheckNPC(model)
                        end
                    end
                end
            end
            
            if Config.AutoFarm.Target == "Chests" or Config.AutoFarm.Target == "Items" then
                for _, item in pairs(workspace:GetChildren()) do
                    CheckItem(item)
                end
                
                -- Verificar pastas específicas do jogo onde itens possam estar
                local itemFolders = {"Items", "Pickups", "Collectibles", "Chests", "Drops"}
                for _, folderName in ipairs(itemFolders) do
                    local folder = workspace:FindFirstChild(folderName)
                    if folder then
                        for _, item in pairs(folder:GetChildren()) do
                            CheckItem(item)
                        end
                    end
                end
            end
            
            -- Se encontrou um alvo, mover até ele e atacar/coletar
            if targetPart and targetModel then
                local distance = (HRP.Position - targetPart.Position).Magnitude
                
                -- Mover para o alvo
                if distance > 5 then
                    local moveDirection = (targetPart.Position - HRP.Position).Unit
                    local movePosition = targetPart.Position - moveDirection * 4 -- Ficar a 4 studs de distância
                    
                    -- Teleportar suavemente para o alvo
                    HRP.CFrame = HRP.CFrame:Lerp(CFrame.new(movePosition, targetPart.Position), 0.1)
                end
                
                -- Atacar o alvo (se for monstro/boss)
                if (Config.AutoFarm.Target == "Monsters" or Config.AutoFarm.Target == "Bosses") and distance <= 5 then
                    -- Tentar encontrar e usar remotes de ataque
                    local attackRemotes = {"Attack", "Combat", "LightAttack", "HeavyAttack", "SpecialAttack"}
                    
                    for _, remote in ipairs(attackRemotes) do
                        local attackRemote = Character:FindFirstChild(remote) or
                                            LocalPlayer.Backpack:FindFirstChild(remote) or
                                            ReplicatedStorage:FindFirstChild(remote)
                        
                        if attackRemote and attackRemote:IsA("RemoteEvent") then
                            attackRemote:FireServer()
                            break
                        end
                    end
                    
                    -- Método alternativo: simular clique de mouse
                    mouse1click()
                end
                
                -- Coletar o item (se for baú/item)
                if (Config.AutoFarm.Target == "Chests" or Config.AutoFarm.Target == "Items") and distance <= 5 then
                    -- Tentar usar proximity prompt se existir
                    local prompt = targetModel:FindFirstChildWhichIsA("ProximityPrompt")
                    if prompt then
                        fireproximityprompt(prompt)
                    end
                    
                    -- Método alternativo: tentar remotes de interação
                    local interactRemotes = {"Interact", "Collect", "Open", "Pickup"}
                    
                    for _, remote in ipairs(interactRemotes) do
                        local interactRemote = ReplicatedStorage:FindFirstChild(remote)
                        
                        if interactRemote and interactRemote:IsA("RemoteEvent") then
                            interactRemote:FireServer(targetModel)
                            break
                        end
                    end
                end
            end
        end)
    end
    
    -- Observer para mudanças no AutoFarm
    autoFarmToggle.SetValue = function(value)
        Config.AutoFarm.Enabled = value
        AutoFarm()
    end
    
    -- Sistema Auto Attack
    local attackConnection = nil
    local function AutoAttack()
        if attackConnection then attackConnection:Disconnect() end
        
        if not Config.Combat.AutoAttack then return end
        
        attackConnection = RunService.Heartbeat:Connect(function()
            if not Config.Combat.AutoAttack then attackConnection:Disconnect() return end
            
            -- Verificar se o personagem está vivo
            if not Character or not Character:FindFirstChild("HumanoidRootPart") or not Character:FindFirstChildOfClass("Humanoid") or Character:FindFirstChildOfClass("Humanoid").Health <= 0 then
                return
            end
            
            local HRP = Character:FindFirstChild("HumanoidRootPart")
            local targetPart = nil
            local closestDistance = 10 -- Range máximo fixo para auto attack
            
            -- Procurar inimigos próximos
            for _, model in pairs(workspace:GetChildren()) do
                if model:IsA("Model") and model ~= Character and model:FindFirstChild("HumanoidRootPart") and model:FindFirstChildOfClass("Humanoid") then
                    if model:FindFirstChildOfClass("Humanoid").Health > 0 then
                        local enemyHRP = model:FindFirstChild("HumanoidRootPart")
                        local distance = (HRP.Position - enemyHRP.Position).Magnitude
                        
                        if distance <= closestDistance then
                            closestDistance = distance
                            targetPart = enemyHRP
                        end
                    end
                end
            end
            
            -- Se encontrou um alvo, atacar
            if targetPart then
                -- Virar para o alvo
                HRP.CFrame = CFrame.new(HRP.Position, Vector3.new(targetPart.Position.X, HRP.Position.Y, targetPart.Position.Z))
                
                -- Tentar encontrar e usar remotes de ataque
                local attackRemotes = {"Attack", "Combat", "LightAttack", "HeavyAttack", "SpecialAttack"}
                
                for _, remote in ipairs(attackRemotes) do
                    local attackRemote = Character:FindFirstChild(remote) or
                                        LocalPlayer.Backpack:FindFirstChild(remote) or
                                        ReplicatedStorage:FindFirstChild(remote)
                    
                    if attackRemote and attackRemote:IsA("RemoteEvent") then
                        attackRemote:FireServer()
                        break
                    end
                end
                
                -- Método alternativo: simular clique de mouse
                mouse1click()
            end
        end)
    end
    
    -- Observer para mudanças no Auto Attack
    autoAttackToggle.SetValue = function(value)
        Config.Combat.AutoAttack = value
        AutoAttack()
    end
    
    -- Sistema de No Clip
    local noclipConnection = nil
    local function ToggleNoClip()
        if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
        
        if Config.Movement.NoClip then
            noclipConnection = RunService.Stepped:Connect(function()
                if not Character then return end
                
                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end)
        end
    end
    
    -- Observer para mudanças no No Clip
    noClipToggle.SetValue = function(value)
        Config.Movement.NoClip = value
        ToggleNoClip()
    end
    
    -- ESP para jogadores
    local espObjectList = {}
    local espConnection = nil
    
    local function ClearESP()
        for _, obj in pairs(espObjectList) do
            if obj.Box then obj.Box:Destroy() end
            if obj.Name then obj.Name:Destroy() end
            if obj.Distance then obj.Distance:Destroy() end
            if obj.Tracer then obj.Tracer:Destroy() end
        end
        espObjectList = {}
    end
    
    local function CreateESP()
        if espConnection then espConnection:Disconnect() end
        ClearESP()
        
        if not Config.Visual.ESP then return end
        
        -- Criar container de ESP se não existir
        local espFolder = AriseHubGUI:FindFirstChild("ESPContainer")
        if not espFolder then
            espFolder = Instance.new("Folder")
            espFolder.Name = "ESPContainer"
            espFolder.Parent = AriseHubGUI
        end
        
        espConnection = RunService.RenderStepped:Connect(function()
            -- Limpar ESP de jogadores que saíram
            for player, data in pairs(espObjectList) do
                if not player or not player.Parent then
                    if data.Box then data.Box:Destroy() end
                    if data.Name then data.Name:Destroy() end
                    if data.Distance then data.Distance:Destroy() end
                    if data.Tracer then data.Tracer:Destroy() end
                    espObjectList[player] = nil
                end
            end
            
            -- Atualizar ESP
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    local character = player.Character
                    if character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChildOfClass("Humanoid") then
                        -- Criar ou obter objetos de ESP
                        local espData = espObjectList[player] or {}
                        
                        -- Box
                        if not espData.Box then
                            local box = Drawing.new("Square")
                            box.Visible = false
                            box.Color = Color3.fromRGB(255, 255, 255)
                            box.Thickness = 1
                            box.Transparency = 1
                            box.Filled = false
                            espData.Box = box
                        end
                        
                        -- Nome
                        if not espData.Name then
                            local name = Drawing.new("Text")
                            name.Visible = false
                            name.Color = Color3.fromRGB(255, 255, 255)
                            name.Size = 16
                            name.Center = true
                            name.Outline = true
                            espData.Name = name
                        end
                        
                        -- Distância
                        if not espData.Distance then
                            local distance = Drawing.new("Text")
                            distance.Visible = false
                            distance.Color = Color3.fromRGB(255, 255, 255)
                            distance.Size = 14
                            distance.Center = true
                            distance.Outline = true
                            espData.Distance = distance
                        end
                        
                        -- Linha traçadora
                        if not espData.Tracer then
                            local tracer = Drawing.new("Line")
                            tracer.Visible = false
                            tracer.Color = Color3.fromRGB(255, 255, 255)
                            tracer.Thickness = 1
                            tracer.Transparency = 1
                            espData.Tracer = tracer
                        end
                        
                        -- Adicionar à lista
                        espObjectList[player] = espData
                        
                        -- Calcular posição na tela
                        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                        local head = character:FindFirstChild("Head")
                        
                        local rootPos, rootVis = Camera:WorldToViewportPoint(humanoidRootPart.Position)
                        
                        if rootVis then
                            -- Posição do personagem
                            local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                            local legPos = Camera:WorldToViewportPoint(humanoidRootPart.Position - Vector3.new(0, 3, 0))
                            
                            -- Calcular dimensões
                            local boxSize = Vector2.new(math.abs(headPos.Y - legPos.Y) * 0.6, math.abs(headPos.Y - legPos.Y))
                            local boxPos = Vector2.new(rootPos.X - boxSize.X / 2, rootPos.Y - boxSize.Y / 2)
                            
                            -- Atualizar box
                            espData.Box.Size = boxSize
                            espData.Box.Position = boxPos
                            espData.Box.Visible = true
                            
                            -- Atualizar nome
                            espData.Name.Text = player.Name
                            espData.Name.Position = Vector2.new(rootPos.X, boxPos.Y - 16)
                            espData.Name.Visible = true
                            
                            -- Atualizar distância
                            local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude)
                            espData.Distance.Text = tostring(dist) .. "m"
                            espData.Distance.Position = Vector2.new(rootPos.X, boxPos.Y + boxSize.Y)
                            espData.Distance.Visible = true
                            
                            -- Atualizar traçador
                            espData.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                            espData.Tracer.To = Vector2.new(rootPos.X, rootPos.Y)
                            espData.Tracer.Visible = true
                        else
                            espData.Box.Visible = false
                            espData.Name.Visible = false
                            espData.Distance.Visible = false
                            espData.Tracer.Visible = false
                        end
                    end
                end
            end
        end)
    end
    
    -- Observer para mudanças no ESP
    espToggle.SetValue = function(value)
        Config.Visual.ESP = value
        
        if value then
            pcall(function()
                -- Verificar se a biblioteca Drawing está disponível
                if Drawing then
                    CreateESP()
                else
                    -- Fallback para ESP básico usando BillboardGuis se Drawing não está disponível
                    Config.Visual.ESP = false
                    espToggle.SetValue(false)
                    
                    -- Notificar o usuário
                    local notification = Instance.new("Frame")
                    notification.Name = "Notification"
                    notification.Size = UDim2.new(0, 250, 0, 60)
                    notification.Position = UDim2.new(0.5, -125, 0, -70)
                    notification.BackgroundColor3 = Theme.Header
                    notification.BorderSizePixel = 0
                    notification.Parent = AriseHubGUI
                    
                    local notifCorner = Instance.new("UICorner")
                    notifCorner.CornerRadius = UDim.new(0, 6)
                    notifCorner.Parent = notification
                    
                    local notifTitle = Instance.new("TextLabel")
                    notifTitle.Name = "Title"
                    notifTitle.Size = UDim2.new(1, -20, 0, 25)
                    notifTitle.Position = UDim2.new(0, 10, 0, 5)
                    notifTitle.BackgroundTransparency = 1
                    notifTitle.Text = "ESP Not Available"
                    notifTitle.TextColor3 = Theme.Text
                    notifTitle.TextSize = 16
                    notifTitle.Font = Enum.Font.GothamBold
                    notifTitle.Parent = notification
                    
                    local notifMessage = Instance.new("TextLabel")
                    notifMessage.Name = "Message"
                    notifMessage.Size = UDim2.new(1, -20, 0, 20)
                    notifMessage.Position = UDim2.new(0, 10, 0, 30)
                    notifMessage.BackgroundTransparency = 1
                    notifMessage.Text = "Your executor doesn't support Drawing library."
                    notifMessage.TextColor3 = Theme.SubText
                    notifMessage.TextSize = 14
                    notifMessage.Font = Enum.Font.Gotham
                    notifMessage.Parent = notification
                    
                    -- Animação de entrada
                    TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -125, 0, 20)}):Play()
                    
                    -- Animação de saída após 3 segundos
                    spawn(function()
                        wait(3)
                        TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -125, 0, -70)}):Play()
                        wait(0.3)
                        notification:Destroy()
                    end)
                end
            end)
        else
            ClearESP()
            if espConnection then espConnection:Disconnect() end
        end
    end
    
    -- Sistema de Infinite Stamina
    local staminaConnection = nil
    local function InfiniteStamina()
        if staminaConnection then staminaConnection:Disconnect() end
        
        if not Config.Misc.InfiniteStamina then return end
        
        staminaConnection = RunService.Heartbeat:Connect(function()
            -- Tentar encontrar o valor de estamina em diferentes locais comuns
            local staminaValue = LocalPlayer:FindFirstChild("Stamina") or 
                                Character:FindFirstChild("Stamina") or
                                LocalPlayer:FindFirstChild("Stats"):FindFirstChild("Stamina")
            
            if staminaValue and staminaValue:IsA("NumberValue") then
                staminaValue.Value = staminaValue.MaxValue or 100
            end
            
            -- Método alternativo: definir atributos comuns de estamina
            LocalPlayer:SetAttribute("Stamina", 100)
            if Character then
                Character:SetAttribute("Stamina", 100)
            end
        end)
    end
    
    -- Observer para mudanças no Infinite Stamina
    infiniteStaminaToggle.SetValue = function(value)
        Config.Misc.InfiniteStamina = value
        InfiniteStamina()
    end
    
    -- Inicializar recursos ativos por padrão e manipuladores de caracteres
    local function InitializeCharacter(char)
        if not char then return end
        
        -- Salvar valores originais
        local humanoid = char:WaitForChild("Humanoid")
        OriginalWalkSpeed = humanoid.WalkSpeed
        OriginalJumpPower = humanoid.JumpPower
        
        -- Aplicar configurações ativas
        if Config.Movement.Speed then
            humanoid.WalkSpeed = OriginalWalkSpeed * Config.Movement.SpeedMultiplier
        end
        
        if Config.Movement.Jump then
            humanoid.JumpPower = OriginalJumpPower * Config.Movement.JumpMultiplier
        end
        
        -- Reinicializar No Clip
        if Config.Movement.NoClip then
            ToggleNoClip()
        end
    end
    
    -- Conectar à troca de personagem
    LocalPlayer.CharacterAdded:Connect(function(char)
        Character = char
        InitializeCharacter(char)
    end)
    
    -- Iniciar recursos com o personagem atual
    InitializeCharacter(Character)
    
    -- Inicializar funcionalidades ativas por padrão
    if Config.AutoFarm.Enabled then AutoFarm() end
    if Config.Combat.AutoAttack then AutoAttack() end
    if Config.Movement.NoClip then ToggleNoClip() end
    if Config.Visual.ESP then espToggle.SetValue(true) end
    if Config.Misc.InfiniteStamina then InfiniteStamina() end
    
    -- Notificação de inicialização
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.Size = UDim2.new(0, 250, 0, 60)
    notification.Position = UDim2.new(0.5, -125, 0, -70)
    notification.BackgroundColor3 = Theme.Header
    notification.BorderSizePixel = 0
    notification.Parent = AriseHubGUI
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 6)
    notifCorner.Parent = notification
    
    local notifTitle = Instance.new("TextLabel")
    notifTitle.Name = "Title"
    notifTitle.Size = UDim2.new(1, -20, 0, 25)
    notifTitle.Position = UDim2.new(0, 10, 0, 5)
    notifTitle.BackgroundTransparency = 1
    notifTitle.Text = "Arise Crossover Hub"
    notifTitle.TextColor3 = Theme.Text
    notifTitle.TextSize = 16
    notifTitle.Font = Enum.Font.GothamBold
    notifTitle.Parent = notification
    
    local notifMessage = Instance.new("TextLabel")
    notifMessage.Name = "Message"
    notifMessage.Size = UDim2.new(1, -20, 0, 20)
    notifMessage.Position = UDim2.new(0, 10, 0, 30)
    notifMessage.BackgroundTransparency = 1
    notifMessage.Text = "Script loaded successfully! Press RightCtrl to toggle."
    notifMessage.TextColor3 = Theme.SubText
    notifMessage.TextSize = 14
    notifMessage.Font = Enum.Font.Gotham
    notifMessage.Parent = notification
    
    -- Animação de entrada
    TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -125, 0, 20)}):Play()
    
    -- Animação de saída após 3 segundos
    spawn(function()
        wait(3)
        TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -125, 0, -70)}):Play()
        wait(0.3)
        notification:Destroy()
    end)
end)()