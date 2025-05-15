-- // Wirtz Script | Versão Standalone
-- // Todos os recursos em um único script, sem dependências externas

-- // Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- // Variáveis locais
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- // Anti-AFK
for i,v in next, getconnections(LocalPlayer.Idled) do
    v:Disable()
end

-- // Limpar GUIs existentes
pcall(function()
    if game:GetService("CoreGui"):FindFirstChild("WirtzScript") then
        game:GetService("CoreGui"):FindFirstChild("WirtzScript"):Destroy()
    end
end)

-- // Configurações
local Config = {
    ESP = {
        Enabled = false,
        TeamCheck = true,
        ShowBox = true,
        ShowInfo = true,
        MaxDistance = 2000,
        BoxColor = Color3.fromRGB(255, 0, 0),
        TextColor = Color3.fromRGB(255, 255, 255)
    },
    Aimbot = {
        Enabled = false,
        TeamCheck = true,
        TargetPart = "Head",
        Sensitivity = 0.8,
        FOV = 100,
        ShowFOV = true
    },
    Fly = {
        Enabled = false,
        Speed = 80,
        VerticalSpeed = 70
    }
}

-- // Criar GUI Principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WirtzScript"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Tentar adicionar à CoreGui (mais seguro)
pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)
-- Fallback para PlayerGui
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- // GUI Principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 350)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Permitir arrastar
MainFrame.Parent = ScreenGui

-- Arredondar bordas
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- // Barra de título
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

-- Arredondar barra de título
local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleBar

-- Correção visual para a barra de título
local TitleFix = Instance.new("Frame")
TitleFix.Name = "TitleFix"
TitleFix.Size = UDim2.new(1, 0, 0.5, 0)
TitleFix.Position = UDim2.new(0, 0, 0.5, 0)
TitleFix.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
TitleFix.BorderSizePixel = 0
TitleFix.Parent = TitleBar

-- Título
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, -50, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "WIRTZ SCRIPT"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 18
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.Parent = TitleBar

-- Botão de fechar
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -40, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 16
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TitleBar

-- Arredondar botão de fechar
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

-- // Abas de navegação
local TabsFrame = Instance.new("Frame")
TabsFrame.Name = "TabsFrame"
TabsFrame.Size = UDim2.new(1, 0, 0, 40)
TabsFrame.Position = UDim2.new(0, 0, 0, 40)
TabsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
TabsFrame.BorderSizePixel = 0
TabsFrame.Parent = MainFrame

-- Botões de aba
local function CreateTabButton(name, position, selected)
    local tabButton = Instance.new("TextButton")
    tabButton.Name = name .. "Tab"
    tabButton.Size = UDim2.new(0.333, 0, 1, 0)
    tabButton.Position = position
    tabButton.BackgroundColor3 = selected and Color3.fromRGB(45, 45, 50) or Color3.fromRGB(35, 35, 40)
    tabButton.BorderSizePixel = 0
    tabButton.Text = name
    tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabButton.TextSize = 14
    tabButton.Font = Enum.Font.GothamSemibold
    tabButton.Parent = TabsFrame
    return tabButton
end

local ESPTab = CreateTabButton("ESP", UDim2.new(0, 0, 0, 0), true)
local AimbotTab = CreateTabButton("AIMBOT", UDim2.new(0.333, 0, 0, 0), false)
local FlyTab = CreateTabButton("FLY", UDim2.new(0.666, 0, 0, 0), false)

-- // Conteúdo da aba
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, 0, 1, -80)
ContentFrame.Position = UDim2.new(0, 0, 0, 80)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Páginas das abas
local ESPPage = Instance.new("Frame")
ESPPage.Name = "ESPPage"
ESPPage.Size = UDim2.new(1, 0, 1, 0)
ESPPage.BackgroundTransparency = 1
ESPPage.Visible = true
ESPPage.Parent = ContentFrame

local AimbotPage = Instance.new("Frame")
AimbotPage.Name = "AimbotPage"
AimbotPage.Size = UDim2.new(1, 0, 1, 0)
AimbotPage.BackgroundTransparency = 1
AimbotPage.Visible = false
AimbotPage.Parent = ContentFrame

local FlyPage = Instance.new("Frame")
FlyPage.Name = "FlyPage"
FlyPage.Size = UDim2.new(1, 0, 1, 0)
FlyPage.BackgroundTransparency = 1
FlyPage.Visible = false
FlyPage.Parent = ContentFrame

-- Função para alternar abas
local function SwitchTab(tab)
    ESPTab.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    AimbotTab.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    FlyTab.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    
    ESPPage.Visible = false
    AimbotPage.Visible = false
    FlyPage.Visible = false
    
    if tab == "ESP" then
        ESPTab.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        ESPPage.Visible = true
    elseif tab == "AIMBOT" then
        AimbotTab.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        AimbotPage.Visible = true
    elseif tab == "FLY" then
        FlyTab.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        FlyPage.Visible = true
    end
end

-- Conectar eventos dos botões de aba
ESPTab.MouseButton1Click:Connect(function() SwitchTab("ESP") end)
AimbotTab.MouseButton1Click:Connect(function() SwitchTab("AIMBOT") end)
FlyTab.MouseButton1Click:Connect(function() SwitchTab("FLY") end)

-- // Função para criar Toggle
local function CreateToggle(parent, name, position, defaultState, callback)
    local toggle = Instance.new("Frame")
    toggle.Name = name .. "Toggle"
    toggle.Size = UDim2.new(1, -20, 0, 40)
    toggle.Position = position
    toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    toggle.BorderSizePixel = 0
    toggle.Parent = parent
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = toggle
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.Font = Enum.Font.GothamSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggle
    
    local switch = Instance.new("Frame")
    switch.Name = "Switch"
    switch.Size = UDim2.new(0, 40, 0, 20)
    switch.Position = UDim2.new(1, -50, 0.5, -10)
    switch.BackgroundColor3 = defaultState and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 65)
    switch.BorderSizePixel = 0
    switch.Parent = toggle
    
    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(0, 10)
    switchCorner.Parent = switch
    
    local knob = Instance.new("Frame")
    knob.Name = "Knob"
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = UDim2.new(defaultState and 1 or 0, defaultState and -18 or 2, 0.5, -8)
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
    button.Parent = toggle
    
    local toggled = defaultState
    
    button.MouseButton1Click:Connect(function()
        toggled = not toggled
        knob.Position = UDim2.new(toggled and 1 or 0, toggled and -18 or 2, 0.5, -8)
        switch.BackgroundColor3 = toggled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 65)
        
        if callback then
            callback(toggled)
        end
    end)
    
    return {
        Instance = toggle,
        GetValue = function() return toggled end,
        SetValue = function(value)
            toggled = value
            knob.Position = UDim2.new(toggled and 1 or 0, toggled and -18 or 2, 0.5, -8)
            switch.BackgroundColor3 = toggled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 65)
            
            if callback then
                callback(toggled)
            end
        end
    }
end

-- // Função para criar Slider
local function CreateSlider(parent, name, position, min, max, default, callback)
    local slider = Instance.new("Frame")
    slider.Name = name .. "Slider"
    slider.Size = UDim2.new(1, -20, 0, 60)
    slider.Position = position
    slider.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    slider.BorderSizePixel = 0
    slider.Parent = parent
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 6)
    sliderCorner.Parent = slider
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.Font = Enum.Font.GothamSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = slider
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "Value"
    valueLabel.Size = UDim2.new(0, 50, 0, 20)
    valueLabel.Position = UDim2.new(1, -60, 0, 5)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    valueLabel.TextSize = 14
    valueLabel.Font = Enum.Font.GothamSemibold
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = slider
    
    local sliderBG = Instance.new("Frame")
    sliderBG.Name = "SliderBG"
    sliderBG.Size = UDim2.new(1, -20, 0, 8)
    sliderBG.Position = UDim2.new(0, 10, 0, 35)
    sliderBG.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    sliderBG.BorderSizePixel = 0
    sliderBG.Parent = slider
    
    local sliderBGCorner = Instance.new("UICorner")
    sliderBGCorner.CornerRadius = UDim.new(0, 4)
    sliderBGCorner.Parent = sliderBG
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "SliderFill"
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBG
    
    local sliderFillCorner = Instance.new("UICorner")
    sliderFillCorner.CornerRadius = UDim.new(0, 4)
    sliderFillCorner.Parent = sliderFill
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Name = "SliderButton"
    sliderButton.Size = UDim2.new(1, 0, 1, 0)
    sliderButton.BackgroundTransparency = 1
    sliderButton.Text = ""
    sliderButton.Parent = sliderBG
    
    local value = default
    
    local function updateSlider(xPos)
        local relativePos = math.clamp((xPos - sliderBG.AbsolutePosition.X) / sliderBG.AbsoluteSize.X, 0, 1)
        local newValue = min + (max - min) * relativePos
        newValue = math.floor(newValue * 10) / 10 -- Arredondar para 1 casa decimal
        
        value = newValue
        valueLabel.Text = tostring(newValue)
        sliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
        
        if callback then
            callback(newValue)
        end
    end
    
    sliderButton.MouseButton1Down:Connect(function(x)
        updateSlider(x)
        
        local moveCon
        local upCon
        
        moveCon = UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                updateSlider(input.Position.X)
            end
        end)
        
        upCon = UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                moveCon:Disconnect()
                upCon:Disconnect()
            end
        end)
    end)
    
    return {
        Instance = slider,
        GetValue = function() return value end,
        SetValue = function(newValue)
            value = math.clamp(newValue, min, max)
            valueLabel.Text = tostring(value)
            sliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
            
            if callback then
                callback(value)
            end
        end
    }
end

-- // ESP CONTROLS
local ESPToggle = CreateToggle(ESPPage, "ESP Master", UDim2.new(0, 10, 0, 10), false, function(value)
    Config.ESP.Enabled = value
    if value then EnableESP() else DisableESP() end
end)

local ESPTeamToggle = CreateToggle(ESPPage, "Team Check", UDim2.new(0, 10, 0, 60), true, function(value)
    Config.ESP.TeamCheck = value
end)

local ESPBoxToggle = CreateToggle(ESPPage, "Show Boxes", UDim2.new(0, 10, 0, 110), true, function(value)
    Config.ESP.ShowBox = value
end)

local ESPInfoToggle = CreateToggle(ESPPage, "Show Info", UDim2.new(0, 10, 0, 160), true, function(value)
    Config.ESP.ShowInfo = value
end)

local MaxDistanceSlider = CreateSlider(ESPPage, "Max Distance", UDim2.new(0, 10, 0, 210), 100, 5000, 2000, function(value)
    Config.ESP.MaxDistance = value
end)

-- // AIMBOT CONTROLS
local AimbotToggle = CreateToggle(AimbotPage, "Aimbot Master", UDim2.new(0, 10, 0, 10), false, function(value)
    Config.Aimbot.Enabled = value
    if value then EnableAimbot() else DisableAimbot() end
end)

local AimbotTeamToggle = CreateToggle(AimbotPage, "Team Check", UDim2.new(0, 10, 0, 60), true, function(value)
    Config.Aimbot.TeamCheck = value
end)

local AimbotFOVToggle = CreateToggle(AimbotPage, "Show FOV", UDim2.new(0, 10, 0, 110), true, function(value)
    Config.Aimbot.ShowFOV = value
    if FOVCircle then
        FOVCircle.Visible = value and Config.Aimbot.Enabled
    end
end)

local AimbotSensSlider = CreateSlider(AimbotPage, "Aimbot Strength", UDim2.new(0, 10, 0, 160), 0.1, 1, 0.8, function(value)
    Config.Aimbot.Sensitivity = value
end)

local AimbotFOVSlider = CreateSlider(AimbotPage, "FOV Size", UDim2.new(0, 10, 0, 230), 50, 400, 100, function(value)
    Config.Aimbot.FOV = value
    if FOVCircle then
        FOVCircle.Radius = value
    end
end)

-- // FLY CONTROLS
local FlyToggle = CreateToggle(FlyPage, "Fly Master", UDim2.new(0, 10, 0, 10), false, function(value)
    Config.Fly.Enabled = value
    if value then EnableFly() else DisableFly() end
end)

local FlySpeedSlider = CreateSlider(FlyPage, "Fly Speed", UDim2.new(0, 10, 0, 60), 10, 200, 80, function(value)
    Config.Fly.Speed = value
end)

local FlyVerticalSlider = CreateSlider(FlyPage, "Vertical Speed", UDim2.new(0, 10, 0, 130), 10, 200, 70, function(value)
    Config.Fly.VerticalSpeed = value
end)

-- Info de controles
local flyInfo = Instance.new("TextLabel")
flyInfo.Name = "FlyInfo"
flyInfo.Size = UDim2.new(1, -20, 0, 40)
flyInfo.Position = UDim2.new(0, 10, 0, 200)
flyInfo.BackgroundTransparency = 1
flyInfo.Text = "Controles de voo aparecerão na lateral da tela quando ativado."
flyInfo.TextColor3 = Color3.fromRGB(200, 200, 200)
flyInfo.TextSize = 12
flyInfo.Font = Enum.Font.Gotham
flyInfo.TextWrapped = true
flyInfo.Parent = FlyPage

-- // Botão de fechar
CloseButton.MouseButton1Click:Connect(function()
    -- Limpar tudo
    DisableESP()
    DisableAimbot()
    DisableFly()
    ScreenGui:Destroy()
end)

-- // CONTROLES DE VOO
local FlyControlsGui = Instance.new("ScreenGui")
FlyControlsGui.Name = "FlyControls"
FlyControlsGui.Enabled = false

pcall(function()
    FlyControlsGui.Parent = game:GetService("CoreGui")
end)
if not FlyControlsGui.Parent then
    FlyControlsGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Botão para subir
local UpButton = Instance.new("TextButton")
UpButton.Name = "UpButton"
UpButton.Size = UDim2.new(0, 80, 0, 80)
UpButton.Position = UDim2.new(0, 10, 0.5, -90)
UpButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
UpButton.BorderSizePixel = 0
UpButton.Text = "↑"
UpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
UpButton.TextSize = 30
UpButton.Font = Enum.Font.GothamBold
UpButton.AutoButtonColor = true
UpButton.Parent = FlyControlsGui

local UpCorner = Instance.new("UICorner")
UpCorner.CornerRadius = UDim.new(0, 10)
UpCorner.Parent = UpButton

-- Botão para descer
local DownButton = Instance.new("TextButton")
DownButton.Name = "DownButton"
DownButton.Size = UDim2.new(0, 80, 0, 80)
DownButton.Position = UDim2.new(0, 10, 0.5, 10)
DownButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
DownButton.BorderSizePixel = 0
DownButton.Text = "↓"
DownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DownButton.TextSize = 30
DownButton.Font = Enum.Font.GothamBold
DownButton.AutoButtonColor = true
DownButton.Parent = FlyControlsGui

local DownCorner = Instance.new("UICorner")
DownCorner.CornerRadius = UDim.new(0, 10)
DownCorner.Parent = DownButton

-- // ESP SYSTEM
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "ESPItems"
ESPFolder.Parent = ScreenGui

-- Criar ESP para um jogador
local function CreateESP(player)
    if player == LocalPlayer then return end
    
    local esp = Instance.new("BillboardGui")
    esp.Name = "ESP_" .. player.Name
    esp.AlwaysOnTop = true
    esp.Size = UDim2.new(4, 0, 5.5, 0)
    esp.StudsOffset = Vector3.new(0, 0.5, 0)
    esp.Adornee = nil -- Será definido no update
    esp.Parent = ESPFolder
    
    -- Box
    local box = Instance.new("Frame")
    box.Name = "Box"
    box.Size = UDim2.new(1, 0, 1, 0)
    box.BackgroundTransparency = 0.5
    box.BackgroundColor3 = Config.ESP.BoxColor
    box.BorderSizePixel = 0
    box.Visible = Config.ESP.ShowBox
    box.Parent = esp
    
    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 4)
    boxCorner.Parent = box
    
    -- Nome
    local name = Instance.new("TextLabel")
    name.Name = "Name"
    name.Size = UDim2.new(1, 0, 0, 20)
    name.Position = UDim2.new(0, 0, 0, -25)
    name.BackgroundTransparency = 1
    name.Text = player.Name
    name.TextColor3 = Config.ESP.TextColor
    name.TextSize = 14
    name.Font = Enum.Font.GothamBold
    name.TextStrokeTransparency = 0.5
    name.Visible = Config.ESP.ShowInfo
    name.Parent = esp
    
    -- Saúde
    local health = Instance.new("TextLabel")
    health.Name = "Health"
    health.Size = UDim2.new(1, 0, 0, 20)
    health.Position = UDim2.new(0, 0, 1, 5)
    health.BackgroundTransparency = 1
    health.Text = "100 HP"
    health.TextColor3 = Color3.fromRGB(0, 255, 0)
    health.TextSize = 14
    health.Font = Enum.Font.Gotham
    health.TextStrokeTransparency = 0.5
    health.Visible = Config.ESP.ShowInfo
    health.Parent = esp
    
    -- Distância
    local distance = Instance.new("TextLabel")
    distance.Name = "Distance"
    distance.Size = UDim2.new(1, 0, 0, 20)
    distance.Position = UDim2.new(0, 0, 1, 25)
    distance.BackgroundTransparency = 1
    distance.Text = "0m"
    distance.TextColor3 = Config.ESP.TextColor
    distance.TextSize = 14
    distance.Font = Enum.Font.Gotham
    distance.TextStrokeTransparency = 0.5
    distance.Visible = Config.ESP.ShowInfo
    distance.Parent = esp
    
    return esp
end

-- Atualizar ESP
local function UpdateESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local esp = ESPFolder:FindFirstChild("ESP_" .. player.Name)
            
            if not esp and Config.ESP.Enabled then
                esp = CreateESP(player)
            end
            
            if esp then
                local character = player.Character
                if not character or not character:FindFirstChild("HumanoidRootPart") or not character:FindFirstChildOfClass("Humanoid") then
                    esp.Enabled = false
                    continue
                end
                
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                local hrp = character:FindFirstChild("HumanoidRootPart")
                
                -- Verificar equipe
                if Config.ESP.TeamCheck and player.Team == LocalPlayer.Team then
                    esp.Enabled = false
                    continue
                end
                
                -- Verificar distância
                local distance = (Camera.CFrame.Position - hrp.Position).Magnitude
                if distance > Config.ESP.MaxDistance then
                    esp.Enabled = false
                    continue
                end
                
                -- Atualizar ESP
                esp.Adornee = hrp
                esp.Enabled = true
                
                -- Atualizar componentes
                local box = esp:FindFirstChild("Box")
                local nameLabel = esp:FindFirstChild("Name")
                local healthLabel = esp:FindFirstChild("Health")
                local distanceLabel = esp:FindFirstChild("Distance")
                
                if box then
                    box.Visible = Config.ESP.ShowBox
                end
                
                if nameLabel then
                    nameLabel.Visible = Config.ESP.ShowInfo
                    if player.Team then
                        nameLabel.TextColor3 = player.TeamColor.Color
                    else
                        nameLabel.TextColor3 = Config.ESP.TextColor
                    end
                end
                
                if healthLabel and humanoid then
                    healthLabel.Visible = Config.ESP.ShowInfo
                    local hp = math.floor(humanoid.Health)
                    local maxHp = math.floor(humanoid.MaxHealth)
                    healthLabel.Text = hp .. " HP"
                    
                    -- Cor baseada na saúde
                    local healthRatio = hp / maxHp
                    healthLabel.TextColor3 = Color3.fromRGB(
                        255 * (1 - healthRatio),
                        255 * healthRatio,
                        0
                    )
                end
                
                if distanceLabel then
                    distanceLabel.Visible = Config.ESP.ShowInfo
                    distanceLabel.Text = math.floor(distance) .. "m"
                end
            end
        end
    end
end

-- Habilitar ESP
function EnableESP()
    -- Criar ESP para jogadores existentes
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            CreateESP(player)
        end
    end
    
    -- Conectar updates
    if not ESPUpdateConnection then
        ESPUpdateConnection = RunService.RenderStepped:Connect(UpdateESP)
    end
    
    -- Criar conexão para novos jogadores
    if not PlayerAddedConnection then
        PlayerAddedConnection = Players.PlayerAdded:Connect(function(player)
            if player ~= LocalPlayer then
                CreateESP(player)
            end
        end)
    end
    
    -- Limpar ESP para jogadores que saem
    if not PlayerRemovedConnection then
        PlayerRemovedConnection = Players.PlayerRemoving:Connect(function(player)
            local esp = ESPFolder:FindFirstChild("ESP_" .. player.Name)
            if esp then
                esp:Destroy()
            end
        end)
    end
end

-- Desabilitar ESP
function DisableESP()
    if ESPUpdateConnection then
        ESPUpdateConnection:Disconnect()
        ESPUpdateConnection = nil
    end
    
    ESPFolder:ClearAllChildren()
end

-- // AIMBOT SYSTEM
local FOVCircle = nil
local AimbotActive = false
local TargetPart = "Head"

-- Criar círculo FOV
local function CreateFOVCircle()
    -- Tentar usar Drawing API
    pcall(function()
        if Drawing then
            FOVCircle = Drawing.new("Circle")
            FOVCircle.Visible = Config.Aimbot.ShowFOV and Config.Aimbot.Enabled
            FOVCircle.Color = Color3.fromRGB(255, 255, 255)
            FOVCircle.Thickness = 1
            FOVCircle.NumSides = 60
            FOVCircle.Radius = Config.Aimbot.FOV
            FOVCircle.Filled = false
            FOVCircle.Transparency = 1
            FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            
            return true
        end
        return false
    end)
    
    -- Se Drawing API não estiver disponível, tentar criar elemento UI
    if not FOVCircle then
        local fovGui = Instance.new("ScreenGui")
        fovGui.Name = "AimbotFOV"
        
        pcall(function() fovGui.Parent = game:GetService("CoreGui") end)
        if not fovGui.Parent then
            fovGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        end
        
        FOVCircle = Instance.new("Frame")
        FOVCircle.Name = "Circle"
        FOVCircle.Size = UDim2.new(0, Config.Aimbot.FOV * 2, 0, Config.Aimbot.FOV * 2)
        FOVCircle.Position = UDim2.new(0.5, -Config.Aimbot.FOV, 0.5, -Config.Aimbot.FOV)
        FOVCircle.BackgroundTransparency = 1
        FOVCircle.BorderSizePixel = 0
        FOVCircle.Parent = fovGui
        
        local circle = Instance.new("UIStroke")
        circle.Color = Color3.fromRGB(255, 255, 255)
        circle.Thickness = 1
        circle.Transparency = 0.5
        circle.Parent = FOVCircle
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = FOVCircle
    end
end

-- Atualizar círculo FOV
local function UpdateFOVCircle()
    if not FOVCircle then return end
    
    if typeof(FOVCircle) == "table" and FOVCircle.Position then
        FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        FOVCircle.Radius = Config.Aimbot.FOV
        FOVCircle.Visible = Config.Aimbot.ShowFOV and Config.Aimbot.Enabled
    elseif FOVCircle:IsA("Frame") then
        FOVCircle.Size = UDim2.new(0, Config.Aimbot.FOV * 2, 0, Config.Aimbot.FOV * 2)
        FOVCircle.Position = UDim2.new(0.5, -Config.Aimbot.FOV, 0.5, -Config.Aimbot.FOV)
        FOVCircle.Visible = Config.Aimbot.ShowFOV and Config.Aimbot.Enabled
    end
end

-- Obter jogador mais próximo do centro da tela
local function GetClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = Config.Aimbot.FOV
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            -- Verificar equipe
            if Config.Aimbot.TeamCheck and player.Team == LocalPlayer.Team then
                continue
            end
            
            local character = player.Character
            if character and character:FindFirstChild(TargetPart) and character:FindFirstChildOfClass("Humanoid") then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                
                -- Verificar se está vivo
                if humanoid.Health <= 0 then continue end
                
                -- Verificar visibilidade na tela
                local target = character[TargetPart]
                local screenPos, onScreen = Camera:WorldToScreenPoint(target.Position)
                
                if onScreen then
                    -- Calcular distância do centro da tela
                    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
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

-- Predizer posição
local function PredictPosition(player)
    local character = player.Character
    if not character or not character:FindFirstChild(TargetPart) then return nil end
    
    local targetPart = character[TargetPart]
    
    -- Predição básica
    return targetPart.Position
end

-- Habilitar Aimbot
function EnableAimbot()
    if not FOVCircle then
        CreateFOVCircle()
    end
    
    -- Atualizar círculo FOV
    if not FOVUpdateConnection then
        FOVUpdateConnection = RunService.RenderStepped:Connect(UpdateFOVCircle)
    end
    
    -- Detectar input para ativar mira
    if not InputBeganConnection then
        InputBeganConnection = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.Touch then
                AimbotActive = true
            end
        end)
    end
    
    if not InputEndedConnection then
        InputEndedConnection = UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.Touch then
                AimbotActive = false
            end
        end)
    end
    
    -- Loop principal do aimbot
    if not AimbotUpdateConnection then
        AimbotUpdateConnection = RunService.RenderStepped:Connect(function()
            if not Config.Aimbot.Enabled or not AimbotActive then return end
            
            local target = GetClosestPlayer()
            if not target then return end
            
            local predictedPosition = PredictPosition(target)
            if not predictedPosition then return end
            
            -- Calcular nova orientação da câmera
            local cameraPos = Camera.CFrame.Position
            local newCFrame = CFrame.new(cameraPos, predictedPosition)
            
            -- Aplicar aimbot com suavização
            Camera.CFrame = Camera.CFrame:Lerp(newCFrame, Config.Aimbot.Sensitivity)
        end)
    end
end

-- Desabilitar Aimbot
function DisableAimbot()
    AimbotActive = false
    
    if InputBeganConnection then
        InputBeganConnection:Disconnect()
        InputBeganConnection = nil
    end
    
    if InputEndedConnection then
        InputEndedConnection:Disconnect()
        InputEndedConnection = nil
    end
    
    if AimbotUpdateConnection then
        AimbotUpdateConnection:Disconnect()
        AimbotUpdateConnection = nil
    end
    
    if FOVUpdateConnection then
        FOVUpdateConnection:Disconnect()
        FOVUpdateConnection = nil
    end
    
    if FOVCircle then
        if typeof(FOVCircle) == "table" and FOVCircle.Remove then
            FOVCircle:Remove()
        elseif typeof(FOVCircle) == "Instance" then
            FOVCircle.Parent:Destroy()
        end
        FOVCircle = nil
    end
end

-- // FLY SYSTEM
local FlyGyro
local FlyVelocity
local IsFlying = false
local FlyPos
local IsUp = false
local IsDown = false

-- Habilitar Fly
function EnableFly()
    IsFlying = true
    FlyControlsGui.Enabled = true
    
    -- Event connections for fly controls
    UpButton.MouseButton1Down:Connect(function()
        IsUp = true
    end)
    
    UpButton.MouseButton1Up:Connect(function()
        IsUp = false
    end)
    
    DownButton.MouseButton1Down:Connect(function()
        IsDown = true
    end)
    
    DownButton.MouseButton1Up:Connect(function()
        IsDown = false
    end)
    
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    
    -- Create gyro and velocity
    FlyGyro = Instance.new("BodyGyro")
    FlyGyro.P = 9e4
    FlyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    FlyGyro.CFrame = hrp.CFrame
    FlyGyro.Parent = hrp
    
    FlyVelocity = Instance.new("BodyVelocity")
    FlyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    FlyVelocity.Velocity = Vector3.new(0, 0.1, 0)
    FlyVelocity.Parent = hrp
    
    -- Main fly loop
    if not FlyUpdateConnection then
        FlyUpdateConnection = RunService.RenderStepped:Connect(function()
            if not IsFlying or not Config.Fly.Enabled then return end
            
            local character = LocalPlayer.Character
            if not character or not character:FindFirstChild("HumanoidRootPart") then
                DisableFly()
                return
            end
            
            local hrp = character:FindFirstChild("HumanoidRootPart")
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            
            -- Update orientation
            FlyGyro.CFrame = CFrame.new(hrp.Position, hrp.Position + Camera.CFrame.LookVector)
            
            -- Calculate vertical speed
            local verticalSpeed = 0
            if IsUp then
                verticalSpeed = Config.Fly.VerticalSpeed
            elseif IsDown then
                verticalSpeed = -Config.Fly.VerticalSpeed
            end
            
            -- Update velocity
            local moveDir = humanoid.MoveDirection
            FlyVelocity.Velocity = Vector3.new(
                moveDir.X * Config.Fly.Speed,
                verticalSpeed,
                moveDir.Z * Config.Fly.Speed
            )
        end)
    end
end

-- Desabilitar Fly
function DisableFly()
    IsFlying = false
    FlyControlsGui.Enabled = false
    
    if FlyGyro then
        FlyGyro:Destroy()
        FlyGyro = nil
    end
    
    if FlyVelocity then
        FlyVelocity:Destroy()
        FlyVelocity = nil
    end
    
    if FlyUpdateConnection then
        FlyUpdateConnection:Disconnect()
        FlyUpdateConnection = nil
    end
    
    IsUp = false
    IsDown = false
}

-- // Conexões de Evento
local ESPUpdateConnection
local PlayerAddedConnection
local PlayerRemovedConnection
local FOVUpdateConnection
local InputBeganConnection
local InputEndedConnection
local AimbotUpdateConnection
local FlyUpdateConnection

-- // Conexão para jogadores que saem
Players.PlayerRemoving:Connect(function(player)
    local esp = ESPFolder:FindFirstChild("ESP_" .. player.Name)
    if esp then esp:Destroy() end
end)

-- // Efeito de animação na inicialização
MainFrame.BackgroundTransparency = 1
TitleBar.BackgroundTransparency = 1
TitleLabel.TextTransparency = 1

-- Aparecer gradualmente
TweenService:Create(MainFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
TweenService:Create(TitleBar, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
TweenService:Create(TitleLabel, TweenInfo.new(0.5), {TextTransparency = 0}):Play()

-- // Notificação de inicialização
local NotifyGui = Instance.new("ScreenGui")
NotifyGui.Name = "WirtzNotify"
NotifyGui.DisplayOrder = 100
pcall(function() NotifyGui.Parent = game:GetService("CoreGui") end)
if not NotifyGui.Parent then NotifyGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local NotifyFrame = Instance.new("Frame")
NotifyFrame.Name = "NotifyFrame"
NotifyFrame.Size = UDim2.new(0, 300, 0, 80)
NotifyFrame.Position = UDim2.new(0.5, -150, 0, -90)
NotifyFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
NotifyFrame.BorderSizePixel = 0
NotifyFrame.Parent = NotifyGui

local NotifyCorner = Instance.new("UICorner")
NotifyCorner.CornerRadius = UDim.new(0, 8)
NotifyCorner.Parent = NotifyFrame

local NotifyTitle = Instance.new("TextLabel")
NotifyTitle.Name = "Title"
NotifyTitle.Size = UDim2.new(1, -20, 0, 30)
NotifyTitle.Position = UDim2.new(0, 10, 0, 5)
NotifyTitle.BackgroundTransparency = 1
NotifyTitle.Text = "Wirtz Script"
NotifyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
NotifyTitle.TextSize = 18
NotifyTitle.Font = Enum.Font.GothamBold
NotifyTitle.TextXAlignment = Enum.TextXAlignment.Left
NotifyTitle.Parent = NotifyFrame

local NotifyText = Instance.new("TextLabel")
NotifyText.Name = "Text"
NotifyText.Size = UDim2.new(1, -20, 0, 40)
NotifyText.Position = UDim2.new(0, 10, 0, 35)
NotifyText.BackgroundTransparency = 1
NotifyText.Text = "Script carregado com sucesso! Use as abas para acessar os recursos."
NotifyText.TextColor3 = Color3.fromRGB(200, 200, 200)
NotifyText.TextSize = 14
NotifyText.Font = Enum.Font.Gotham
NotifyText.TextXAlignment = Enum.TextXAlignment.Left
NotifyText.TextWrapped = true
NotifyText.Parent = NotifyFrame

-- Animar notificação
TweenService:Create(NotifyFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Position = UDim2.new(0.5, -150, 0, 10)}):Play()

-- Remover notificação após alguns segundos
task.delay(5, function()
    TweenService:Create(NotifyFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Position = UDim2.new(0.5, -150, 0, -90)}):Play()
    task.wait(0.5)
    NotifyGui:Destroy()
end)

-- // Limpeza ao sair
game:GetService("Players").LocalPlayer.OnTeleport:Connect(function()
    pcall(function()
        DisableESP()
        DisableAimbot()
        DisableFly()
        ScreenGui:Destroy()
        FlyControlsGui:Destroy()
        if NotifyGui then NotifyGui:Destroy() end
    end)
end)