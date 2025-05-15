-- THEUS-HUB Premium | Fly + ESP + Aimbot
-- Desenvolvido por Yuzure-sudo | github.com/Yuzure-sudo/THEUS-HUB

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Configurações
local Config = {
    Fly = {
        Enabled = false,
        Speed = 50,
        MaxSpeed = 150,
        Keys = {W = false, A = false, S = false, D = false, Space = false, LeftShift = false}
    },
    ESP = {
        Enabled = false,
        ShowName = true,
        ShowDistance = true,
        ShowHealth = true,
        TeamCheck = false,
        TeamColor = true,
        BoxEnabled = true,
        TracerEnabled = false,
        MaxDistance = 1000,
        Color = Color3.fromRGB(255, 0, 0)
    },
    Aimbot = {
        Enabled = false,
        TeamCheck = true,
        VisibilityCheck = true,
        TargetPart = "Head",
        Sensitivity = 3,
        FOV = 100,
        ShowFOV = true,
        Smoothness = 0.5,
        MaxDistance = 1000,
        TriggerKey = Enum.KeyCode.E
    }
}

-- Limpar GUIs anteriores
if CoreGui:FindFirstChild("THEUS_HUB") then
    CoreGui:FindFirstChild("THEUS_HUB"):Destroy()
end

-- Criar GUI principal
local GUI = Instance.new("ScreenGui")
GUI.Name = "THEUS_HUB"
GUI.Parent = CoreGui
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GUI.ResetOnSpawn = false

-- Funções de UI
local function CreateElement(class, properties)
    local element = Instance.new(class)
    for prop, value in pairs(properties) do
        element[prop] = value
    end
    return element
end

local function CreateCorner(parent, radius)
    return CreateElement("UICorner", {
        CornerRadius = UDim.new(0, radius or 8),
        Parent = parent
    })
end

local function CreateStroke(parent, color, thickness)
    return CreateElement("UIStroke", {
        Color = color or Color3.fromRGB(60, 60, 70),
        Thickness = thickness or 1.5,
        Parent = parent
    })
end

local function CreateGradient(parent, colors, rotation)
    local gradient = CreateElement("UIGradient", {
        Rotation = rotation or 45,
        Parent = parent
    })
    
    if colors then
        local colorSequence = {}
        for i, color in ipairs(colors) do
            table.insert(colorSequence, ColorSequenceKeypoint.new((i-1)/(#colors-1), color))
        end
        gradient.Color = ColorSequence.new(colorSequence)
    else
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 65)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 50))
        })
    end
    
    return gradient
end

-- Criar o painel principal
local MainFrame = CreateElement("Frame", {
    Name = "MainFrame",
    BackgroundColor3 = Color3.fromRGB(25, 25, 35),
    BorderSizePixel = 0,
    Position = UDim2.new(0.5, -150, 0.5, -125),
    Size = UDim2.new(0, 300, 0, 250),
    Active = true,
    Draggable = true,
    ZIndex = 10,
    Parent = GUI
})

CreateCorner(MainFrame, 10)
CreateStroke(MainFrame, Color3.fromRGB(60, 60, 80), 1.5)

-- Título
local TitleBar = CreateElement("Frame", {
    Name = "TitleBar",
    BackgroundColor3 = Color3.fromRGB(35, 35, 45),
    BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 0, 35),
    ZIndex = 11,
    Parent = MainFrame
})

CreateCorner(TitleBar, 10)
CreateGradient(TitleBar, {Color3.fromRGB(40, 40, 60), Color3.fromRGB(30, 30, 45)}, 90)

local Title = CreateElement("TextLabel", {
    Name = "Title",
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 10, 0, 0),
    Size = UDim2.new(1, -20, 1, 0),
    Font = Enum.Font.GothamBold,
    Text = "THEUS-HUB PREMIUM",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 12,
    Parent = TitleBar
})

-- Funções de criação de abas
local TabButtons = {}
local TabFrames = {}
local CurrentTab = nil

local TabsFrame = CreateElement("Frame", {
    Name = "TabsFrame",
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 0, 0, 35),
    Size = UDim2.new(1, 0, 0, 30),
    ZIndex = 11,
    Parent = MainFrame
})

local function CreateTab(name)
    -- Botão da aba
    local tabButton = CreateElement("TextButton", {
        Name = name.."Tab",
        BackgroundColor3 = Color3.fromRGB(35, 35, 45),
        BorderSizePixel = 0,
        Position = UDim2.new(0, #TabButtons * 100, 0, 0),
        Size = UDim2.new(0, 100, 1, 0),
        Font = Enum.Font.GothamSemibold,
        Text = name,
        TextColor3 = Color3.fromRGB(180, 180, 180),
        TextSize = 14,
        ZIndex = 12,
        Parent = TabsFrame
    })
    
    CreateCorner(tabButton, 6)
    
    -- Conteúdo da aba
    local tabFrame = CreateElement("ScrollingFrame", {
        Name = name.."Frame",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 70),
        Size = UDim2.new(1, 0, 1, -75),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Color3.fromRGB(60, 60, 80),
        Visible = false,
        ZIndex = 11,
        Parent = MainFrame
    })
    
    -- Adicionar à lista de abas
    table.insert(TabButtons, tabButton)
    TabFrames[name] = tabFrame
    
    -- Evento de clique
    tabButton.MouseButton1Click:Connect(function()
        if CurrentTab then
            TabFrames[CurrentTab].Visible = false
            for _, btn in ipairs(TabButtons) do
                btn.TextColor3 = Color3.fromRGB(180, 180, 180)
                btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            end
        end
        
        CurrentTab = name
        tabFrame.Visible = true
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    end)
    
    return tabFrame
end

-- Criar abas
local FlyTab = CreateTab("Fly")
local ESPTab = CreateTab("ESP")
local AimbotTab = CreateTab("Aimbot")

-- Função para criar controles
local function CreateToggle(parent, text, default, callback)
    local toggleFrame = CreateElement("Frame", {
        Name = text.."Toggle",
        BackgroundColor3 = Color3.fromRGB(35, 35, 45),
        BorderSizePixel = 0,
        Size = UDim2.new(1, -20, 0, 35),
        Position = UDim2.new(0, 10, 0, #parent:GetChildren() * 40),
        ZIndex = 12,
        Parent = parent
    })
    
    CreateCorner(toggleFrame, 6)
    
    local toggleLabel = CreateElement("TextLabel", {
        Name = "Label",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(0.7, 0, 1, 0),
        Font = Enum.Font.GothamSemibold,
        Text = text,
        TextColor3 = Color3.fromRGB(220, 220, 220),
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 13,
        Parent = toggleFrame
    })
    
    local toggleButton = CreateElement("Frame", {
        Name = "Button",
        BackgroundColor3 = default and Color3.fromRGB(0, 170, 127) or Color3.fromRGB(100, 100, 120),
        BorderSizePixel = 0,
        Position = UDim2.new(0.85, -15, 0.5, -10),
        Size = UDim2.new(0, 40, 0, 20),
        ZIndex = 13,
        Parent = toggleFrame
    })
    
    CreateCorner(toggleButton, 10)
    
    local toggleCircle = CreateElement("Frame", {
        Name = "Circle",
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Position = default and UDim2.new(0.5, 0, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
        Size = UDim2.new(0, 16, 0, 16),
        ZIndex = 14,
        Parent = toggleButton
    })
    
    CreateCorner(toggleCircle, 8)
    
    local toggled = default
    
    toggleFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            toggled = not toggled
            
            if toggled then
                TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 170, 127)}):Play()
                TweenService:Create(toggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0.5, 0, 0.5, -8)}):Play()
            else
                TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 100, 120)}):Play()
                TweenService:Create(toggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -8)}):Play()
            end
            
            callback(toggled)
        end
    end)
    
    parent.CanvasSize = UDim2.new(0, 0, 0, #parent:GetChildren() * 40 + 10)
    
    return toggleFrame
end

local function CreateSlider(parent, text, min, max, default, callback)
    local sliderFrame = CreateElement("Frame", {
        Name = text.."Slider",
        BackgroundColor3 = Color3.fromRGB(35, 35, 45),
        BorderSizePixel = 0,
        Size = UDim2.new(1, -20, 0, 50),
        Position = UDim2.new(0, 10, 0, #parent:GetChildren() * 40),
        ZIndex = 12,
        Parent = parent
    })
    
    CreateCorner(sliderFrame, 6)
    
    local sliderLabel = CreateElement("TextLabel", {
        Name = "Label",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(0.5, 0, 0, 25),
        Font = Enum.Font.GothamSemibold,
        Text = text,
        TextColor3 = Color3.fromRGB(220, 220, 220),
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 13,
        Parent = sliderFrame
    })
    
    local sliderValue = CreateElement("TextLabel", {
        Name = "Value",
        BackgroundTransparency = 1,
        Position = UDim2.new(0.7, 0, 0, 0),
        Size = UDim2.new(0.3, -10, 0, 25),
        Font = Enum.Font.GothamBold,
        Text = tostring(default),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Right,
        ZIndex = 13,
        Parent = sliderFrame
    })
    
    local sliderBG = CreateElement("Frame", {
        Name = "Background",
        BackgroundColor3 = Color3.fromRGB(25, 25, 35),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 10, 0, 30),
        Size = UDim2.new(1, -20, 0, 6),
        ZIndex = 13,
        Parent = sliderFrame
    })
    
    CreateCorner(sliderBG, 3)
    
    local sliderFill = CreateElement("Frame", {
        Name = "Fill",
        BackgroundColor3 = Color3.fromRGB(0, 170, 127),
        BorderSizePixel = 0,
        Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
        ZIndex = 14,
        Parent = sliderBG
    })
    
    CreateCorner(sliderFill, 3)
    CreateGradient(sliderFill, {Color3.fromRGB(0, 180, 137), Color3.fromRGB(0, 150, 107)}, 90)
    
    local sliderDrag = CreateElement("TextButton", {
        Name = "Drag",
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Position = UDim2.new((default - min) / (max - min), -6, 0.5, -6),
        Size = UDim2.new(0, 12, 0, 12),
        Text = "",
        ZIndex = 15,
        Parent = sliderBG
    })
    
    CreateCorner(sliderDrag, 6)
    
    local dragging = false
    
    sliderDrag.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    sliderBG.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local relX = math.clamp((input.Position.X - sliderBG.AbsolutePosition.X) / sliderBG.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + relX * (max - min))
            
            sliderFill.Size = UDim2.new(relX, 0, 1, 0)
            sliderDrag.Position = UDim2.new(relX, -6, 0.5, -6)
            sliderValue.Text = tostring(value)
            
            callback(value)
        end
    end)
    
    RunService.RenderStepped:Connect(function()
        if dragging then
            local mousePos = UserInputService:GetMouseLocation()
            local relX = math.clamp((mousePos.X - sliderBG.AbsolutePosition.X) / sliderBG.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + relX * (max - min))
            
            sliderFill.Size = UDim2.new(relX, 0, 1, 0)
            sliderDrag.Position = UDim2.new(relX, -6, 0.5, -6)
            sliderValue.Text = tostring(value)
            
            callback(value)
        end
    end)
    
    parent.CanvasSize = UDim2.new(0, 0, 0, #parent:GetChildren() * 40 + 20)
    
    return sliderFrame
end

-- Configurar abas
-- Aba Fly
CreateToggle(FlyTab, "Ativar Fly", Config.Fly.Enabled, function(value)
    Config.Fly.Enabled = value
    if value then
        EnableFly()
    else
        DisableFly()
    end
end)

CreateSlider(FlyTab, "Velocidade", 10, 150, Config.Fly.Speed, function(value)
    Config.Fly.Speed = value
end)

-- Aba ESP
CreateToggle(ESPTab, "Ativar ESP", Config.ESP.Enabled, function(value)
    Config.ESP.Enabled = value
    if value then
        EnableESP()
    else
        DisableESP()
    end
end)

CreateToggle(ESPTab, "Mostrar Nomes", Config.ESP.ShowName, function(value)
    Config.ESP.ShowName = value
end)

CreateToggle(ESPTab, "Mostrar Distância", Config.ESP.ShowDistance, function(value)
    Config.ESP.ShowDistance = value
end)

CreateToggle(ESPTab, "Verificar Time", Config.ESP.TeamCheck, function(value)
    Config.ESP.TeamCheck = value
end)

CreateToggle(ESPTab, "Caixas", Config.ESP.BoxEnabled, function(value)
    Config.ESP.BoxEnabled = value
end)

CreateToggle(ESPTab, "Tracers", Config.ESP.TracerEnabled, function(value)
    Config.ESP.TracerEnabled = value
end)

-- Aba Aimbot
CreateToggle(AimbotTab, "Ativar Aimbot", Config.Aimbot.Enabled, function(value)
    Config.Aimbot.Enabled = value
end)

CreateToggle(AimbotTab, "Verificar Time", Config.Aimbot.TeamCheck, function(value)
    Config.Aimbot.TeamCheck = value
end)

CreateToggle(AimbotTab, "Verificar Visibilidade", Config.Aimbot.VisibilityCheck, function(value)
    Config.Aimbot.VisibilityCheck = value
end)

CreateToggle(AimbotTab, "Mostrar FOV", Config.Aimbot.ShowFOV, function(value)
    Config.Aimbot.ShowFOV = value
    FOVCircle.Visible = value
end)

CreateSlider(AimbotTab, "FOV", 30, 500, Config.Aimbot.FOV, function(value)
    Config.Aimbot.FOV = value
    UpdateFOVCircle()
end)

CreateSlider(AimbotTab, "Suavidade", 1, 10, Config.Aimbot.Smoothness * 10, function(value)
    Config.Aimbot.Smoothness = value / 10
end)

-- Selecionar a primeira aba por padrão
TabButtons[1].MouseButton1Click:Fire()

-- Implementação do Fly
local FlyGyro, FlyVel

function EnableFly()
    local Character = LocalPlayer.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end
    
    local HRP = Character:FindFirstChild("HumanoidRootPart")
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    
    if not HRP or not Humanoid then return end
    
    -- Criar BodyGyro e BodyVelocity
    FlyGyro = Instance.new("BodyGyro")
    FlyGyro.P = 9e4
    FlyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    FlyGyro.CFrame = HRP.CFrame
    FlyGyro.Parent = HRP
    
    FlyVel = Instance.new("BodyVelocity")
    FlyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    FlyVel.Velocity = Vector3.new(0, 0.1, 0)
    FlyVel.Parent = HRP
    
    -- Loop de voo
    RunService:BindToRenderStep("FlyLoop", 1, function()
        if not Config.Fly.Enabled then return end
        
        local Character = LocalPlayer.Character
        if not Character or not Character:FindFirstChild("HumanoidRootPart") or not FlyGyro or not FlyVel then
            DisableFly()
            return
        end
        
        local HRP = Character:FindFirstChild("HumanoidRootPart")
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        
        -- Orientação baseada na câmera
        FlyGyro.CFrame = CFrame.new(HRP.Position, HRP.Position + Camera.CFrame.LookVector)
        
        -- Movimento baseado no analógico ou teclado
        local moveDir = Humanoid.MoveDirection
        
        -- Usar analógico para movimento vertical se disponível
        local yVelocity = 0
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            yVelocity = Config.Fly.Speed
        elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            yVelocity = -Config.Fly.Speed
        end
        
        -- Aplicar velocidade
        FlyVel.Velocity = Vector3.new(
            moveDir.X * Config.Fly.Speed, 
            yVelocity, 
            moveDir.Z * Config.Fly.Speed
        )
    end)
    
    ShowNotification("Fly Ativado", "Use o analógico/WASD para mover e Space/Shift para subir/descer")
end

function DisableFly()
    RunService:UnbindFromRenderStep("FlyLoop")
    
    if FlyGyro then FlyGyro:Destroy() end
    if FlyVel then FlyVel:Destroy() end
    
    FlyGyro = nil
    FlyVel = nil
    
    ShowNotification("Fly Desativado", "Modo de voo encerrado")
end

-- Implementação do ESP
local ESPFolder = Instance.new("Folder", GUI)
ESPFolder.Name = "ESPElements"

function EnableESP()
    RunService:BindToRenderStep("ESPLoop", 5, function()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                UpdateESP(player)
            end
        end
    end)
    
    ShowNotification("ESP Ativado", "Agora você pode ver outros jogadores")
end

function DisableESP()
    RunService:UnbindFromRenderStep("ESPLoop")
    ESPFolder:ClearAllChildren()
    
    ShowNotification("ESP Desativado", "ESP removido")
end

function UpdateESP(player)
    if not Config.ESP.Enabled then return end
    
    -- Verificar time se necessário
    if Config.ESP.TeamCheck and player.Team == LocalPlayer.Team then
        local esp = ESPFolder:FindFirstChild("ESP_" .. player.Name)
        if esp then esp:Destroy() end
        return
    end
    
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") or not character:FindFirstChildOfClass("Humanoid") then
        local esp = ESPFolder:FindFirstChild("ESP_" .. player.Name)
        if esp then esp.Enabled = false end
        return
    end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    -- Verificar distância
    local distance = (humanoidRootPart.Position - Camera.CFrame.Position).Magnitude
    if distance > Config.ESP.MaxDistance then
        local esp = ESPFolder:FindFirstChild("ESP_" .. player.Name)
        if esp then esp.Enabled = false end
        return
    end
    
    -- Criar ou obter ESP
    local esp = ESPFolder:FindFirstChild("ESP_" .. player.Name)
    if not esp then
        esp = Instance.new("BillboardGui")
        esp.Name = "ESP_" .. player.Name
        esp.AlwaysOnTop = true
        esp.Size = UDim2.new(0, 200, 0, 50)
        esp.StudsOffset = Vector3.new(0, 3, 0)
        esp.Adornee = humanoidRootPart
        esp.Parent = ESPFolder
        
        -- Nome
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
        nameLabel.ZIndex = 2
        nameLabel.Parent = esp
        
        -- Distância
        local distanceLabel = Instance.new("TextLabel")
        distanceLabel.Name = "DistanceLabel"
        distanceLabel.BackgroundTransparency = 1
        distanceLabel.Position = UDim2.new(0, 0, 0, 20)
        distanceLabel.Size = UDim2.new(1, 0, 0, 20)
        distanceLabel.Font = Enum.Font.Gotham
        distanceLabel.Text = "0m"
        distanceLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
        distanceLabel.TextStrokeTransparency = 0.3
        distanceLabel.TextSize = 12
        distanceLabel.ZIndex = 2
        distanceLabel.Parent = esp
    end
    
    -- Atualizar ESP
    esp.Enabled = true
    esp.Adornee = humanoidRootPart
    
    local nameLabel = esp:FindFirstChild("NameLabel")
    local distanceLabel = esp:FindFirstChild("DistanceLabel")
    
    -- Atualizar informações
    nameLabel.Visible = Config.ESP.ShowName
    distanceLabel.Visible = Config.ESP.ShowDistance
    distanceLabel.Text = math.floor(distance) .. "m"
    
    -- Cor baseada no time
    if Config.ESP.TeamColor and player.Team then
        nameLabel.TextColor3 = player.TeamColor.Color
    else
        nameLabel.TextColor3 = Config.ESP.Color
    end
end

-- Implementação do Aimbot
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = Config.Aimbot.ShowFOV
FOVCircle.Radius = Config.Aimbot.FOV
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Thickness = 1
FOVCircle.Transparency = 1
FOVCircle.NumSides = 36
FOVCircle.Filled = false

function UpdateFOVCircle()
    FOVCircle.Radius = Config.Aimbot.FOV
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
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
            
            local targetPart = character:FindFirstChild(Config.Aimbot.TargetPart)
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            
            -- Verificar se está vivo
            if not humanoid or humanoid.Health <= 0 then
                continue
            end
            
           -- Verificar distância
            local distance = (targetPart.Position - Camera.CFrame.Position).Magnitude
            if distance > Config.Aimbot.MaxDistance then
                continue
            end
            
            -- Verificar visibilidade
            if Config.Aimbot.VisibilityCheck then
                local ray = Ray.new(Camera.CFrame.Position, targetPart.Position - Camera.CFrame.Position)
                local hit, _ = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character, character})
                if hit then
                    continue
                end
            end
            
            -- Verificar se está dentro do FOV
            local screenPos, onScreen = Camera:WorldToScreenPoint(targetPart.Position)
            if not onScreen then
                continue
            end
            
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

-- Sistema de Aimbot
RunService.RenderStepped:Connect(function()
    UpdateFOVCircle()
    
    if Config.Aimbot.Enabled and UserInputService:IsKeyDown(Config.Aimbot.TriggerKey) then
        local target = GetClosestPlayerToCursor()
        if target then
            local character = target.Character
            if character and character:FindFirstChild(Config.Aimbot.TargetPart) then
                local targetPart = character:FindFirstChild(Config.Aimbot.TargetPart)
                
                -- Suavidade do aimbot (menor = mais suave)
                local smoothness = Config.Aimbot.Smoothness
                
                -- Calcular ângulo para mirar
                local targetPos = targetPart.Position
                local cameraPos = Camera.CFrame.Position
                
                local targetCFrame = CFrame.new(cameraPos, targetPos)
                local cameraCFrame = Camera.CFrame
                
                -- Suavizar movimento da câmera
                local newCFrame = cameraCFrame:Lerp(targetCFrame, smoothness)
                
                -- Aplicar nova rotação da câmera
                Camera.CFrame = newCFrame
            end
        end
    end
end)

-- Sistema de notificações
local NotificationFrame = CreateElement("Frame", {
    Name = "NotificationFrame",
    BackgroundColor3 = Color3.fromRGB(35, 35, 45),
    BorderSizePixel = 0,
    Position = UDim2.new(0.5, -150, 0, -100),
    Size = UDim2.new(0, 300, 0, 70),
    ZIndex = 100,
    Parent = GUI
})

CreateCorner(NotificationFrame, 8)
CreateStroke(NotificationFrame, Color3.fromRGB(60, 60, 80), 1.5)
CreateGradient(NotificationFrame, {Color3.fromRGB(40, 40, 60), Color3.fromRGB(30, 30, 45)}, 90)

local NotificationTitle = CreateElement("TextLabel", {
    Name = "Title",
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 15, 0, 10),
    Size = UDim2.new(1, -30, 0, 20),
    Font = Enum.Font.GothamBold,
    Text = "Notificação",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 101,
    Parent = NotificationFrame
})

local NotificationText = CreateElement("TextLabel", {
    Name = "Text",
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 15, 0, 35),
    Size = UDim2.new(1, -30, 0, 20),
    Font = Enum.Font.Gotham,
    Text = "",
    TextColor3 = Color3.fromRGB(200, 200, 200),
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 101,
    Parent = NotificationFrame
})

function ShowNotification(title, text)
    NotificationTitle.Text = title
    NotificationText.Text = text
    
    TweenService:Create(NotificationFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Position = UDim2.new(0.5, -150, 0, 20)}):Play()
    
    task.delay(3, function()
        TweenService:Create(NotificationFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Position = UDim2.new(0.5, -150, 0, -100)}):Play()
    end)
end

-- Inicialização
ShowNotification("THEUS-HUB Premium", "Script carregado com sucesso!")

-- Evento de jogador adicionado para ESP
Players.PlayerAdded:Connect(function(player)
    if Config.ESP.Enabled then
        UpdateESP(player)
    end
end)

-- Atalhos de teclado
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- Tecla F para ativar/desativar o fly
    if input.KeyCode == Enum.KeyCode.X then
        Config.Fly.Enabled = not Config.Fly.Enabled
        if Config.Fly.Enabled then
            EnableFly()
        else
            DisableFly()
        end
    end
    
    -- Tecla V para ativar/desativar o ESP
    if input.KeyCode == Enum.KeyCode.V then
        Config.ESP.Enabled = not Config.ESP.Enabled
        if Config.ESP.Enabled then
            EnableESP()
        else
            DisableESP()
        end
    end
end)

-- Watermark
local Watermark = CreateElement("TextLabel", {
    Name = "Watermark",
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 5, 1, -25),
    Size = UDim2.new(0, 200, 0, 20),
    Font = Enum.Font.Gotham,
    Text = "THEUS-HUB Premium v1.0",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextTransparency = 0.7,
    TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 1,
    Parent = GUI
})

-- Limpar ao sair
LocalPlayer.CharacterRemoving:Connect(function()
    if Config.Fly.Enabled then
        Config.Fly.Enabled = false
        DisableFly()
    end
end)

-- Iniciar na primeira aba
TabButtons[1].MouseButton1Click:Fire()
