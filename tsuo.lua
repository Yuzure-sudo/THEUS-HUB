--[[
  Sistema de AssistÃªncia Ã  Mira e VisualizaÃ§Ã£o para Roblox
  VersÃ£o: 1.0
  Data: 30/04/2025
  
  Este script implementa:
  1. AssistÃªncia Ã  mira com suavidade configurÃ¡vel
  2. Sistema de visualizaÃ§Ã£o de jogadores
  3. Interface otimizada para dispositivos mÃ³veis
  4. ConfiguraÃ§Ãµes personalizÃ¡veis
  
  NOTA: Este script Ã© para fins educacionais apenas. Usar scripts que dÃ£o vantagens
  competitivas pode violar os Termos de ServiÃ§o do Roblox.
]]

-- ConfiguraÃ§Ãµes principais
local Config = {
    -- ConfiguraÃ§Ãµes de assistÃªncia Ã  mira
    AimAssist = {
        Enabled = false,
        TargetPart = "Head", -- Parte do corpo alvo (Head, Torso, HumanoidRootPart)
        MaxDistance = 1000, -- DistÃ¢ncia mÃ¡xima para detectar jogadores
        TeamCheck = true, -- NÃ£o mirar em colegas de equipe
        VisibilityCheck = true, -- Verificar se o alvo estÃ¡ visÃ­vel
        Smoothness = 0.5, -- Suavidade da mira (0.1 - 1, quanto menor mais suave)
        FOV = 250, -- Campo de visÃ£o para detectar jogadores
        ShowFOV = true, -- Mostrar cÃ­rculo do FOV
        ToggleKey = Enum.KeyCode.E -- Tecla para ativar/desativar (no PC)
    },
    
    -- ConfiguraÃ§Ãµes de visualizaÃ§Ã£o
    ESP = {
        Enabled = false,
        ShowNames = true, -- Mostrar nomes dos jogadores
        ShowDistance = true, -- Mostrar distÃ¢ncia atÃ© os jogadores
        ShowHealth = true, -- Mostrar vida dos jogadores
        ShowBoxes = true, -- Mostrar caixas ao redor dos jogadores
        ShowTracers = true, -- Mostrar linhas atÃ© os jogadores
        MaxDistance = 2000, -- DistÃ¢ncia mÃ¡xima para o ESP
        TeamCheck = true, -- NÃ£o mostrar ESP para colegas de equipe
        TeamColor = false, -- Usar cor da equipe (se false, usa EnemyColor)
        EnemyColor = Color3.fromRGB(255, 0, 0), -- Cor para inimigos
        AllyColor = Color3.fromRGB(0, 255, 0), -- Cor para aliados
        TextSize = 18, -- Tamanho do texto
        TextOutline = true, -- Contorno do texto
        BoxesOutline = true, -- Contorno das caixas
        TracerOrigin = "Bottom", -- Origem dos traÃ§adores ("Bottom", "Top", "Mouse")
        ToggleKey = Enum.KeyCode.Q -- Tecla para ativar/desativar (no PC)
    },
    
    -- ConfiguraÃ§Ãµes gerais
    General = {
        RefreshRate = 10, -- Taxa de atualizaÃ§Ã£o (ms)
        MobileButtonSize = UDim2.new(0, 50, 0, 50), -- Tamanho dos botÃµes para mobile
        MobileButtonPosition = UDim2.new(0.9, -100, 0.8, -100) -- PosiÃ§Ã£o dos botÃµes para mobile
    }
}

-- VariÃ¡veis globais
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local ESPContainer = {}
local Target = nil
local FOVCircle = nil
local MobileUI = nil
local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- FunÃ§Ãµes utilitÃ¡rias
local Utility = {}

-- Verificar se um jogador Ã© um inimigo
function Utility:IsEnemy(player)
    if not Config.AimAssist.TeamCheck and not Config.ESP.TeamCheck then return true end
    if player.Team == LocalPlayer.Team then return false end
    return true
end

-- Obter a parte do corpo alvo de um jogador
function Utility:GetTargetPart(player)
    if not player or not player.Character or not player.Character:FindFirstChild(Config.AimAssist.TargetPart) then
        return nil
    end
    return player.Character[Config.AimAssist.TargetPart]
end

-- Verificar se um jogador estÃ¡ visÃ­vel
function Utility:IsVisible(player)
    if not Config.AimAssist.VisibilityCheck then return true end
    
    local targetPart = Utility:GetTargetPart(player)
    if not targetPart then return false end
    
    local ray = Ray.new(Camera.CFrame.Position, targetPart.Position - Camera.CFrame.Position)
    local hit, position = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character, player.Character})
    
    return hit == nil or hit:IsDescendantOf(player.Character)
end

-- Verificar se um jogador estÃ¡ dentro do FOV
function Utility:IsInFOV(player)
    local targetPart = Utility:GetTargetPart(player)
    if not targetPart then return false end
    
    local screenPos, onScreen = Camera:WorldToScreenPoint(targetPart.Position)
    if not onScreen then return false end
    
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local screenPosition = Vector2.new(screenPos.X, screenPos.Y)
    local distance = (screenPosition - screenCenter).Magnitude
    
    return distance <= Config.AimAssist.FOV
end

-- Obter o jogador mais prÃ³ximo para mirar
function Utility:GetClosestPlayer()
    local closestPlayer = nil
    local closestDistance = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            if not Utility:IsEnemy(player) then continue end
            if not Utility:IsVisible(player) then continue end
            if not Utility:IsInFOV(player) then continue end
            
            local targetPart = Utility:GetTargetPart(player)
            if not targetPart then continue end
            
            local distance = (targetPart.Position - Camera.CFrame.Position).Magnitude
            if distance <= Config.AimAssist.MaxDistance and distance < closestDistance then
                closestPlayer = player
                closestDistance = distance
            end
        end
    end
    
    return closestPlayer
end

-- Criar uma instÃ¢ncia de DrawingObject
function Utility:Create(objectType, properties)
    local object = Drawing.new(objectType)
    for property, value in pairs(properties) do
        object[property] = value
    end
    return object
end

-- FunÃ§Ã£o para criar cÃ­rculo de FOV
function Utility:CreateFOVCircle()
    FOVCircle = Utility:Create("Circle", {
        Visible = Config.AimAssist.ShowFOV and Config.AimAssist.Enabled,
        Color = Color3.fromRGB(255, 255, 255),
        Thickness = 1,
        NumSides = 64,
        Radius = Config.AimAssist.FOV,
        Filled = false,
        Transparency = 0.7
    })
end

-- Sistema de assistÃªncia Ã  mira
local AimAssist = {}

-- Inicializar sistema de assistÃªncia Ã  mira
function AimAssist:Init()
    Utility:CreateFOVCircle()
    
    RunService:BindToRenderStep("AimAssist", 0, function()
        if FOVCircle then
            FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            FOVCircle.Radius = Config.AimAssist.FOV
            FOVCircle.Visible = Config.AimAssist.ShowFOV and Config.AimAssist.Enabled
        end
        
        if not Config.AimAssist.Enabled then
            Target = nil
            return
        end
        
        Target = Utility:GetClosestPlayer()
        if not Target then return end
        
        local targetPart = Utility:GetTargetPart(Target)
        if not targetPart then return end
        
        local screenPos, onScreen = Camera:WorldToScreenPoint(targetPart.Position)
        if not onScreen then return end
        
        local mousePos = UserInputService:GetMouseLocation()
        local targetPos = Vector2.new(screenPos.X, screenPos.Y)
        local smoothness = math.clamp(Config.AimAssist.Smoothness, 0.1, 1)
        
        local newPos = mousePos:Lerp(targetPos, smoothness)
        mousemoveabs(newPos.X, newPos.Y)
    end)
end

-- Alternar sistema de assistÃªncia Ã  mira
function AimAssist:Toggle()
    Config.AimAssist.Enabled = not Config.AimAssist.Enabled
    if MobileUI and MobileUI.AimButton then
        MobileUI.AimButton.BackgroundColor3 = Config.AimAssist.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    end
end

-- Sistema de visualizaÃ§Ã£o (ESP)
local ESP = {}

-- Criar rÃ³tulo ESP para um jogador
function ESP:CreatePlayerESP(player)
    if player == LocalPlayer then return end
    
    local esp = {
        Player = player,
        Name = Utility:Create("Text", {
            Visible = false,
            Text = player.Name,
            Size = Config.ESP.TextSize,
            Center = true,
            Outline = Config.ESP.TextOutline,
            OutlineColor = Color3.fromRGB(0, 0, 0),
            Font = Drawing.Fonts.UI
        }),
        Box = Utility:Create("Square", {
            Visible = false,
            Thickness = 1,
            Filled = false,
            Transparency = 1,
            Outline = Config.ESP.BoxesOutline,
            OutlineColor = Color3.fromRGB(0, 0, 0)
        }),
        BoxFill = Utility:Create("Square", {
            Visible = false,
            Thickness = 1,
            Filled = true,
            Transparency = 0.3,
            Outline = false
        }),
        Tracer = Utility:Create("Line", {
            Visible = false,
            Thickness = 1,
            Transparency = 1
        }),
        Distance = Utility:Create("Text", {
            Visible = false,
            Size = Config.ESP.TextSize - 2,
            Center = true,
            Outline = Config.ESP.TextOutline,
            OutlineColor = Color3.fromRGB(0, 0, 0),
            Font = Drawing.Fonts.UI
        }),
        Health = Utility:Create("Text", {
            Visible = false,
            Size = Config.ESP.TextSize - 2,
            Center = true,
            Outline = Config.ESP.TextOutline,
            OutlineColor = Color3.fromRGB(0, 0, 0),
            Font = Drawing.Fonts.UI
        }),
        Connections = {}
    }
    
    -- Remover ESP quando o jogador sair
    local connection = player.CharacterRemoving:Connect(function()
        ESP:RemovePlayerESP(player)
    end)
    table.insert(esp.Connections, connection)
    
    -- Adicionar ao container
    ESPContainer[player.Name] = esp
    
    return esp
end

-- Remover ESP de um jogador
function ESP:RemovePlayerESP(player)
    local esp = ESPContainer[player.Name]
    if not esp then return end
    
    -- Limpar objetos de desenho
    for _, obj in pairs(esp) do
        if typeof(obj) == "table" and obj.Remove then
            obj:Remove()
        end
    end
    
    -- Limpar conexÃµes
    for _, connection in pairs(esp.Connections) do
        connection:Disconnect()
    end
    
    -- Remover do container
    ESPContainer[player.Name] = nil
end

-- Atualizar ESP para um jogador
function ESP:UpdatePlayerESP(player)
    local esp = ESPContainer[player.Name]
    if not esp then
        esp = ESP:CreatePlayerESP(player)
    end
    
    if not player.Character or not player.Character:FindFirstChild("Humanoid") or not player.Character:FindFirstChild("HumanoidRootPart") then
        for _, obj in pairs({"Name", "Box", "BoxFill", "Tracer", "Distance", "Health"}) do
            if esp[obj] then
                esp[obj].Visible = false
            end
        end
        return
    end
    
    local humanoid = player.Character:FindFirstChild("Humanoid")
    local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart or humanoid.Health <= 0 then
        for _, obj in pairs({"Name", "Box", "BoxFill", "Tracer", "Distance", "Health"}) do
            if esp[obj] then
                esp[obj].Visible = false
            end
        end
        return
    end
    
    -- Verificar distÃ¢ncia mÃ¡xima
    local distance = (rootPart.Position - Camera.CFrame.Position).Magnitude
    if distance > Config.ESP.MaxDistance then
        for _, obj in pairs({"Name", "Box", "BoxFill", "Tracer", "Distance", "Health"}) do
            if esp[obj] then
                esp[obj].Visible = false
            end
        end
        return
    end
    
    -- Verificar time
    local isEnemy = Utility:IsEnemy(player)
    if Config.ESP.TeamCheck and not isEnemy then
        for _, obj in pairs({"Name", "Box", "BoxFill", "Tracer", "Distance", "Health"}) do
            if esp[obj] then
                esp[obj].Visible = false
            end
        end
        return
    end
    
    -- Determinar cor
    local espColor
    if Config.ESP.TeamColor then
        espColor = player.TeamColor.Color
    else
        espColor = isEnemy and Config.ESP.EnemyColor or Config.ESP.AllyColor
    end
    
    -- Obter posiÃ§Ã£o na tela
    local rootPos, rootOnScreen = Camera:WorldToScreenPoint(rootPart.Position)
    if not rootOnScreen then
        for _, obj in pairs({"Name", "Box", "BoxFill", "Tracer", "Distance", "Health"}) do
            if esp[obj] then
                esp[obj].Visible = false
            end
        end
        return
    end
    
    -- Calcular tamanho da caixa baseado no personagem
    local hrp = rootPart
    local head = player.Character:FindFirstChild("Head")
    
    if not hrp or not head then
        for _, obj in pairs({"Name", "Box", "BoxFill", "Tracer", "Distance", "Health"}) do
            if esp[obj] then
                esp[obj].Visible = false
            end
        end
        return
    end
    
    -- Obter pontos para a caixa
    local topPos = Camera:WorldToScreenPoint((head.CFrame * CFrame.new(0, head.Size.Y / 2, 0)).Position)
    local bottomPos = Camera:WorldToScreenPoint((hrp.CFrame * CFrame.new(0, -hrp.Size.Y / 2, 0)).Position)
    
    local boxSize = Vector2.new(math.max(math.abs(topPos.Y - bottomPos.Y) / 2, 5), math.abs(topPos.Y - bottomPos.Y))
    local boxPosition = Vector2.new(rootPos.X - boxSize.X / 2, rootPos.Y - boxSize.Y / 2)
    
    -- Atualizar Nome
    esp.Name.Visible = Config.ESP.Enabled and Config.ESP.ShowNames
    esp.Name.Position = Vector2.new(rootPos.X, boxPosition.Y - 15)
    esp.Name.Text = player.Name
    esp.Name.Color = espColor
    
    -- Atualizar Caixa
    esp.Box.Visible = Config.ESP.Enabled and Config.ESP.ShowBoxes
    esp.Box.Size = boxSize
    esp.Box.Position = boxPosition
    esp.Box.Color = espColor
    
    esp.BoxFill.Visible = Config.ESP.Enabled and Config.ESP.ShowBoxes
    esp.BoxFill.Size = boxSize
    esp.BoxFill.Position = boxPosition
    esp.BoxFill.Color = espColor
    
    -- Atualizar TraÃ§ador
    esp.Tracer.Visible = Config.ESP.Enabled and Config.ESP.ShowTracers
    
    local tracerOrigin
    if Config.ESP.TracerOrigin == "Bottom" then
        tracerOrigin = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
    elseif Config.ESP.TracerOrigin == "Top" then
        tracerOrigin = Vector2.new(Camera.ViewportSize.X / 2, 0)
    elseif Config.ESP.TracerOrigin == "Mouse" then
        tracerOrigin = UserInputService:GetMouseLocation()
    end
    
    esp.Tracer.From = tracerOrigin
    esp.Tracer.To = Vector2.new(rootPos.X, rootPos.Y)
    esp.Tracer.Color = espColor
    
    -- Atualizar DistÃ¢ncia
    esp.Distance.Visible = Config.ESP.Enabled and Config.ESP.ShowDistance
    esp.Distance.Position = Vector2.new(rootPos.X, boxPosition.Y + boxSize.Y + 3)
    esp.Distance.Text = string.format("%.0f studs", distance)
    esp.Distance.Color = espColor
    
    -- Atualizar Vida
    esp.Health.Visible = Config.ESP.Enabled and Config.ESP.ShowHealth
    esp.Health.Position = Vector2.new(boxPosition.X - 15, boxPosition.Y)
    esp.Health.Text = string.format("%.0f HP", humanoid.Health)
    esp.Health.Color = Color3.fromRGB(
        255 - math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1) * 255,
        math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1) * 255,
        0
    )
end

-- Inicializar sistema ESP
function ESP:Init()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            ESP:CreatePlayerESP(player)
        end
    end
    
    -- Adicionar novos jogadores que entrarem
    Players.PlayerAdded:Connect(function(player)
        ESP:CreatePlayerESP(player)
    end)
    
    -- Remover jogadores que saÃ­rem
    Players.PlayerRemoving:Connect(function(player)
        ESP:RemovePlayerESP(player)
    end)
    
    -- Atualizar ESP
    RunService:BindToRenderStep("ESP", 0, function()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                ESP:UpdatePlayerESP(player)
            end
        end
    end)
end

-- Alternar ESP
function ESP:Toggle()
    Config.ESP.Enabled = not Config.ESP.Enabled
    if MobileUI and MobileUI.ESPButton then
        MobileUI.ESPButton.BackgroundColor3 = Config.ESP.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    end
end

-- Sistema de Interface para Mobile
local UI = {}

-- Inicializar interface Mobile
function UI:InitMobile()
    if not IsMobile then return end
    
    -- Container principal
    local container = Instance.new("ScreenGui")
    container.Name = "AimAssistGUI"
    container.ResetOnSpawn = false
    
    -- Propriedades de proteÃ§Ã£o
    container.IgnoreGuiInset = true
    
    -- BotÃ£o de assistÃªncia Ã  mira
    local aimButton = Instance.new("TextButton")
    aimButton.Name = "AimButton"
    aimButton.Size = Config.General.MobileButtonSize
    aimButton.Position = Config.General.MobileButtonPosition
    aimButton.BackgroundColor3 = Config.AimAssist.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    aimButton.Text = "Aim"
    aimButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    aimButton.BorderSizePixel = 2
    aimButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    aimButton.Font = Enum.Font.SourceSansBold
    aimButton.TextSize = 18
    aimButton.Parent = container
    
    -- Adicionar cantos arredondados
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0.5, 0)
    uiCorner.Parent = aimButton
    
    -- BotÃ£o ESP
    local espButton = Instance.new("TextButton")
    espButton.Name = "ESPButton"
    espButton.Size = Config.General.MobileButtonSize
    espButton.Position = UDim2.new(
        Config.General.MobileButtonPosition.X.Scale,
        Config.General.MobileButtonPosition.X.Offset,
        Config.General.MobileButtonPosition.Y.Scale,
        Config.General.MobileButtonPosition.Y.Offset - 60
    )
    espButton.BackgroundColor3 = Config.ESP.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    espButton.Text = "ESP"
    espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    espButton.BorderSizePixel = 2
    espButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    espButton.Font = Enum.Font.SourceSansBold
    espButton.TextSize = 18
    espButton.Parent = container
    
    -- Adicionar cantos arredondados
    local uiCorner2 = Instance.new("UICorner")
    uiCorner2.CornerRadius = UDim.new(0.5, 0)
    uiCorner2.Parent = espButton
    
    -- Eventos de clique
    aimButton.TouchTap:Connect(function()
        AimAssist:Toggle()
    end)
    
    espButton.TouchTap:Connect(function()
        ESP:Toggle()
    end)
    
    -- NÃ£o mostrar GUI imediatamente para usuÃ¡rios de teclado
    container.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    -- Armazenar referÃªncia
    MobileUI = {
        Container = container,
        AimButton = aimButton,
        ESPButton = espButton
    }
end

-- Inicializar controles para teclado
function UI:InitKeyboard()
    if IsMobile then return end
    
    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        
        if input.KeyCode == Config.AimAssist.ToggleKey then
            AimAssist:Toggle()
        elseif input.KeyCode == Config.ESP.ToggleKey then
            ESP:Toggle()
        end
    end)
end

-- Inicializar controles
function UI:Init()
    UI:InitMobile()
    UI:InitKeyboard()
end

-- InicializaÃ§Ã£o principal
local function Initialize()
    pcall(function()
        -- Criar objeto Drawing para os elementos visuais
        if not Drawing then
            print("Drawing library is not available. ESP features disabled.")
            return
        end
        
        -- Inicializar sistemas
        AimAssist:Init()
        ESP:Init()
        UI:Init()
        
        print("Sistema de AssistÃªncia Ã  Mira e VisualizaÃ§Ã£o iniciado!")
    end)
end

-- Executar inicializaÃ§Ã£o
Initialize()