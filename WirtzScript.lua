-- Wirtz Script | Versão Ultra Simples
-- Remover GUIs anteriores
pcall(function()
    for _, gui in pairs(game:GetService("CoreGui"):GetChildren()) do
        if gui.Name == "WirtzGUI" or gui.Name == "FlyControls" or gui.Name == "ESPGui" then
            gui:Destroy()
        end
    end
end)

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Anti-AFK
for _, connection in pairs(getconnections(LocalPlayer.Idled)) do
    connection:Disable()
end

-- Configurações
local Config = {
    ESP = {
        Enabled = false,
        TeamCheck = true,
        MaxDistance = 2000
    },
    Aimbot = {
        Enabled = false,
        TeamCheck = true,
        TargetPart = "Head",
        Sensitivity = 0.8,
        FOV = 100
    },
    Fly = {
        Enabled = false,
        Speed = 80,
        VerticalSpeed = 70
    }
}

-- Criar GUI Principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WirtzGUI"
ScreenGui.ResetOnSpawn = false

-- Tentar colocar na CoreGui
pcall(function()
    syn = syn or {}
    if syn.protect_gui then
        syn.protect_gui(ScreenGui)
    end
    ScreenGui.Parent = game:GetService("CoreGui")
end)

-- Fallback para PlayerGui
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer.PlayerGui
end

-- Frame principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 250, 0, 300)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Arredondar cantos
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Título
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
Title.BorderSizePixel = 0
Title.Text = "Wirtz Script"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Arredondar título
local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = Title

-- Conteúdo
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -20, 1, -40)
Content.Position = UDim2.new(0, 10, 0, 35)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- Função para criar toggle
local function CreateToggle(parent, text, position, callback)
    local toggle = Instance.new("Frame")
    toggle.Name = text .. "Toggle"
    toggle.Size = UDim2.new(1, 0, 0, 30)
    toggle.Position = position
    toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    toggle.BorderSizePixel = 0
    toggle.Parent = parent
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = toggle
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.Font = Enum.Font.GothamSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggle
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 40, 0, 20)
    button.Position = UDim2.new(1, -50, 0.5, -10)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
    button.BorderSizePixel = 0
    button.Text = ""
    button.Parent = toggle
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 10)
    buttonCorner.Parent = button
    
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 16, 0, 16)
    indicator.Position = UDim2.new(0, 2, 0.5, -8)
    indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    indicator.BorderSizePixel = 0
    indicator.Parent = button
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(0, 8)
    indicatorCorner.Parent = indicator
    
    local toggled = false
    
    local function updateToggle()
        if toggled then
            button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            indicator.Position = UDim2.new(1, -18, 0.5, -8)
        else
            button.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
            indicator.Position = UDim2.new(0, 2, 0.5, -8)
        end
    end
    
    button.MouseButton1Click:Connect(function()
        toggled = not toggled
        updateToggle()
        callback(toggled)
    end)
    
    return {
        SetValue = function(value)
            toggled = value
            updateToggle()
        end,
        GetValue = function()
            return toggled
        end
    }
end

-- ESP System
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
    esp.Parent = ESPFolder
    
    -- Box
    local box = Instance.new("Frame")
    box.Size = UDim2.new(1, 0, 1, 0)
    box.BackgroundTransparency = 0.5
    box.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    box.BorderSizePixel = 0
    box.Parent = esp
    
    -- Nome
    local name = Instance.new("TextLabel")
    name.Size = UDim2.new(1, 0, 0, 20)
    name.Position = UDim2.new(0, 0, 0, -25)
    name.BackgroundTransparency = 1
    name.Text = player.Name
    name.TextColor3 = Color3.fromRGB(255, 255, 255)
    name.TextSize = 14
    name.Font = Enum.Font.GothamBold
    name.TextStrokeTransparency = 0.5
    name.Parent = esp
    
    -- Saúde
    local health = Instance.new("TextLabel")
    health.Size = UDim2.new(1, 0, 0, 20)
    health.Position = UDim2.new(0, 0, 1, 5)
    health.BackgroundTransparency = 1
    health.Text = "100 HP"
    health.TextColor3 = Color3.fromRGB(0, 255, 0)
    health.TextSize = 14
    health.Font = Enum.Font.Gotham
    health.TextStrokeTransparency = 0.5
    health.Parent = esp
    
    return esp
end

-- Atualizar ESP
local ESPUpdateConnection
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
                
                -- Atualizar saúde
                local healthLabel = esp:FindFirstChild("TextLabel", true)
                if healthLabel and humanoid then
                    local hp = math.floor(humanoid.Health)
                    healthLabel.Text = hp .. " HP"
                    
                    -- Cor baseada na saúde
                    local healthRatio = hp / humanoid.MaxHealth
                    healthLabel.TextColor3 = Color3.fromRGB(
                        255 * (1 - healthRatio),
                        255 * healthRatio,
                        0
                    )
                end
            end
        end
    end
end

-- Aimbot System
local AimbotActive = false
local AimbotUpdateConnection

-- Obter jogador mais próximo
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
            if character and character:FindFirstChild(Config.Aimbot.TargetPart) then
                local targetPart = character[Config.Aimbot.TargetPart]
                local screenPos, onScreen = Camera:WorldToScreenPoint(targetPart.Position)
                
                if onScreen then
                    -- Distância na tela
                    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                    local screenDistance = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                    
                    if screenDistance < shortestDistance then
                        closestPlayer = player
                        shortestDistance = screenDistance
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

-- Fly System
local FlyGyro
local FlyVel
local FlyControls
local IsUp = false
local IsDown = false

-- Criar controles de voo
local function CreateFlyControls()
    FlyControls = Instance.new("ScreenGui")
    FlyControls.Name = "FlyControls"
    FlyControls.Enabled = false
    
    -- Tentar colocar na CoreGui
    pcall(function()
        if syn and syn.protect_gui then
            syn.protect_gui(FlyControls)
        end
        FlyControls.Parent = game:GetService("CoreGui")
    end)
    
    -- Fallback para PlayerGui
    if not FlyControls.Parent then
        FlyControls.Parent = LocalPlayer.PlayerGui
    end
    
    -- Botão para subir
    local upButton = Instance.new("TextButton")
    upButton.Size = UDim2.new(0, 70, 0, 70)
    upButton.Position = UDim2.new(0, 10, 0.5, -80)
    upButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    upButton.Text = "↑"
    upButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    upButton.TextSize = 30
    upButton.Font = Enum.Font.GothamBold
    upButton.Parent = FlyControls
    
    local upCorner = Instance.new("UICorner")
    upCorner.CornerRadius = UDim.new(0, 10)
    upCorner.Parent = upButton
    
    -- Botão para descer
    local downButton = Instance.new("TextButton")
    downButton.Size = UDim2.new(0, 70, 0, 70)
    downButton.Position = UDim2.new(0, 10, 0.5, 10)
    downButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
    downButton.Text = "↓"
    downButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    downButton.TextSize = 30
    downButton.Font = Enum.Font.GothamBold
    downButton.Parent = FlyControls
    
    local downCorner = Instance.new("UICorner")
    downCorner.CornerRadius = UDim.new(0, 10)
    downCorner.Parent = downButton
    
    -- Eventos dos botões
    upButton.MouseButton1Down:Connect(function() IsUp = true end)
    upButton.MouseButton1Up:Connect(function() IsUp = false end)
    downButton.MouseButton1Down:Connect(function() IsDown = true end)
    downButton.MouseButton1Up:Connect(function() IsDown = false end)
    
    return FlyControls
end

-- Habilitar voo
local FlyUpdateConnection
local function EnableFly()
    if not FlyControls then
        CreateFlyControls()
    end
    
    FlyControls.Enabled = true
    
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    
    -- Criar BodyGyro
    FlyGyro = Instance.new("BodyGyro")
    FlyGyro.P = 9e4
    FlyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    FlyGyro.CFrame = hrp.CFrame
    FlyGyro.Parent = hrp
    
    -- Criar BodyVelocity
    FlyVel = Instance.new("BodyVelocity")
    FlyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    FlyVel.Velocity = Vector3.new(0, 0.1, 0)
    FlyVel.Parent = hrp
    
    -- Loop de atualização
    if not FlyUpdateConnection then
        FlyUpdateConnection = RunService.RenderStepped:Connect(function()
            if not Config.Fly.Enabled then return end
            
            local character = LocalPlayer.Character
            if not character or not character:FindFirstChild("HumanoidRootPart") then
                DisableFly()
                return
            end
            
            local hrp = character:FindFirstChild("HumanoidRootPart")
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            
            -- Atualizar orientação
            FlyGyro.CFrame = CFrame.new(hrp.Position, hrp.Position + Camera.CFrame.LookVector)
            
            -- Calcular velocidade vertical
            local verticalSpeed = 0
            if IsUp then
                verticalSpeed = Config.Fly.VerticalSpeed
            elseif IsDown then
                verticalSpeed = -Config.Fly.VerticalSpeed
            end
            
            -- Atualizar velocidade
            local moveDir = humanoid.MoveDirection
            FlyVel.Velocity = Vector3.new(
                moveDir.X * Config.Fly.Speed,
                verticalSpeed,
                moveDir.Z * Config.Fly.Speed
            )
        end)
    end
end

-- Desabilitar voo
local function DisableFly()
    if FlyControls then
        FlyControls.Enabled = false
    end
    
    if FlyGyro then
        FlyGyro:Destroy()
        FlyGyro = nil
    end
    
    if FlyVel then
        FlyVel:Destroy()
        FlyVel = nil
    end
    
    if FlyUpdateConnection then
        FlyUpdateConnection:Disconnect()
        FlyUpdateConnection = nil
    end
    
    IsUp = false
    IsDown = false
end

-- Criar toggles
local ESPToggle = CreateToggle(Content, "ESP", UDim2.new(0, 0, 0, 10), function(value)
    Config.ESP.Enabled = value
    
    if value then
        -- Criar ESP para jogadores existentes
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                CreateESP(player)
            end
        end
        
        -- Conectar update
        if not ESPUpdateConnection then
            ESPUpdateConnection = RunService.RenderStepped:Connect(UpdateESP)
        end
    else
        -- Desconectar update
        if ESPUpdateConnection then
            ESPUpdateConnection:Disconnect()
            ESPUpdateConnection = nil
        end
        
        -- Limpar ESP
        ESPFolder:ClearAllChildren()
    end
end)

local ESPTeamToggle = CreateToggle(Content, "ESP Team Check", UDim2.new(0, 0, 0, 50), function(value)
    Config.ESP.TeamCheck = value
end)

local AimbotToggle = CreateToggle(Content, "Aimbot", UDim2.new(0, 0, 0, 90), function(value)
    Config.Aimbot.Enabled = value
    
    if value then
        -- Detectar input
        UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton2 then
                AimbotActive = true
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton2 then
                AimbotActive = false
            end
        end)
        
        -- Loop do aimbot
        if not AimbotUpdateConnection then
            AimbotUpdateConnection = RunService.RenderStepped:Connect(function()
                if not Config.Aimbot.Enabled or not AimbotActive then return end
                
                local target = GetClosestPlayer()
                if not target then return end
                
                local character = target.Character
                if not character then return end
                
                local targetPart = character:FindFirstChild(Config.Aimbot.TargetPart)
                if not targetPart then return end
                
                -- Calcular nova orientação
                local cameraPos = Camera.CFrame.Position
                local targetPos = targetPart.Position
                local newCFrame = CFrame.new(cameraPos, targetPos)
                
                -- Aplicar aimbot com suavização
                Camera.CFrame = Camera.CFrame:Lerp(newCFrame, Config.Aimbot.Sensitivity)
            end)
        end
    else
        AimbotActive = false
        
        if AimbotUpdateConnection then
            AimbotUpdateConnection:Disconnect()
            AimbotUpdateConnection = nil
        end
    end
end)

local AimbotTeamToggle = CreateToggle(Content, "Aimbot Team Check", UDim2.new(0, 0, 0, 130), function(value)
    Config.Aimbot.TeamCheck = value
end)

local FlyToggle = CreateToggle(Content, "Fly", UDim2.new(0, 0, 0, 170), function(value)
    Config.Fly.Enabled = value
    
    if value then
        EnableFly()
    else
        DisableFly()
    end
end)

-- Limpar ao sair
game:GetService("Players").LocalPlayer.OnTeleport:Connect(function()
    pcall(function()
        if ESPUpdateConnection then ESPUpdateConnection:Disconnect() end
        if AimbotUpdateConnection then AimbotUpdateConnection:Disconnect() end
        if FlyUpdateConnection then FlyUpdateConnection:Disconnect() end
        ScreenGui:Destroy()
        if FlyControls then FlyControls:Destroy() end
    end)
end)

-- Notificação
local function Notify(text)
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, 200, 0, 60)
    notification.Position = UDim2.new(0.5, -100, 0, -70)
    notification.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    notification.BorderSizePixel = 0
    notification.Parent = ScreenGui
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 8)
    notifCorner.Parent = notification
    
    local notifText = Instance.new("TextLabel")
    notifText.Size = UDim2.new(1, -20, 1, 0)
    notifText.Position = UDim2.new(0, 10, 0, 0)
    notifText.BackgroundTransparency = 1
    notifText.Text = text
    notifText.TextColor3 = Color3.fromRGB(255, 255, 255)
    notifText.TextSize = 14
    notifText.Font = Enum.Font.GothamSemibold
    notifText.TextWrapped = true
    notifText.Parent = notification
    
    -- Animar entrada
    notification:TweenPosition(UDim2.new(0.5, -100, 0, 20), "Out", "Quad", 0.5)
    
    -- Remover após 3 segundos
    task.delay(3, function()
        notification:TweenPosition(UDim2.new(0.5, -100, 0, -70), "Out", "Quad", 0.5)
        task.delay(0.5, function()
            notification:Destroy()
        end)
    end)
end

-- Notificar carregamento
Notify("Wirtz Script carregado com sucesso!")
