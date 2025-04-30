--[[
    Universal Roblox Script (Mobile-Optimized)
    Features: Aimbot, Silent Aim, ESP, Prediction, FOV Customization, Team Check
    Version: 1.0
    Last Updated: 2023-09-20
]]--

-- Configurações iniciais
local Settings = {
    Aimbot = {
        Enabled = true,
        Keybind = Enum.UserInputType.Touch, -- Touch para mobile
        FOV = 50, -- Campo de visão
        Smoothness = 0.5, -- Suavização do movimento
        Prediction = 0.15, -- Previsão de movimento
        HitPart = "Head", -- Parte do corpo alvo
        SilentAim = true, -- Atira na direção certa sem mover a câmera
        TeamCheck = true, -- Ignora membros do mesmo time
        VisibleCheck = true, -- Verifica se o alvo está visível
    },
    ESP = {
        Enabled = true,
        Boxes = true,
        Names = true,
        Health = true,
        Distance = true,
        TeamColor = true,
        MaxDistance = 1000, -- Distância máxima para renderizar ESP
    },
    Safety = {
        AntiKick = true,
        AntiBan = true,
        Randomization = true, -- Aleatoriza valores para evitar detecção
        UpdateCheck = true, -- Verifica atualizações
    }
}

-- Variáveis globais
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")

-- Função para criar interface mobile
local function CreateMobileUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MobileCheatUI"
    ScreenGui.Parent = game:GetService("CoreGui")
    
    -- Botão de toggle para menu
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "ToggleButton"
    ToggleButton.Size = UDim2.new(0, 50, 0, 50)
    ToggleButton.Position = UDim2.new(0, 20, 0.5, -25)
    ToggleButton.Text = "☰"
    ToggleButton.TextSize = 20
    ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.Parent = ScreenGui
    
    -- Menu principal
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 200, 0, 300)
    MainFrame.Position = UDim2.new(0, 80, 0.5, -150)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.Visible = false
    MainFrame.Parent = ScreenGui
    
    -- Título
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Text = "Universal Script"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Title.Parent = MainFrame
    
    -- Botão de toggle para Aimbot
    local AimbotToggle = Instance.new("TextButton")
    AimbotToggle.Name = "AimbotToggle"
    AimbotToggle.Size = UDim2.new(0.9, 0, 0, 30)
    AimbotToggle.Position = UDim2.new(0.05, 0, 0, 40)
    AimbotToggle.Text = "Aimbot: ON"
    AimbotToggle.TextColor3 = Color3.fromRGB(0, 255, 0)
    AimbotToggle.Parent = MainFrame
    
    -- Botão de toggle para ESP
    local ESPToggle = Instance.new("TextButton")
    ESPToggle.Name = "ESPToggle"
    ESPToggle.Size = UDim2.new(0.9, 0, 0, 30)
    ESPToggle.Position = UDim2.new(0.05, 0, 0, 80)
    ESPToggle.Text = "ESP: ON"
    ESPToggle.TextColor3 = Color3.fromRGB(0, 255, 0)
    ESPToggle.Parent = MainFrame
    
    -- Slider para FOV
    local FOVSlider = Instance.new("TextButton")
    FOVSlider.Name = "FOVSlider"
    FOVSlider.Size = UDim2.new(0.9, 0, 0, 30)
    FOVSlider.Position = UDim2.new(0.05, 0, 0, 120)
    FOVSlider.Text = "FOV: " .. Settings.Aimbot.FOV
    FOVSlider.Parent = MainFrame
    
    -- Botão para fechar
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0.9, 0, 0, 30)
    CloseButton.Position = UDim2.new(0.05, 0, 0, 260)
    CloseButton.Text = "Fechar"
    CloseButton.Parent = MainFrame
    
    -- Lógica dos botões
    ToggleButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
    end)
    
    AimbotToggle.MouseButton1Click:Connect(function()
        Settings.Aimbot.Enabled = not Settings.Aimbot.Enabled
        AimbotToggle.Text = "Aimbot: " .. (Settings.Aimbot.Enabled and "ON" or "OFF")
        AimbotToggle.TextColor3 = Settings.Aimbot.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    end)
    
    ESPToggle.MouseButton1Click:Connect(function()
        Settings.ESP.Enabled = not Settings.ESP.Enabled
        ESPToggle.Text = "ESP: " .. (Settings.ESP.Enabled and "ON" or "OFF")
        ESPToggle.TextColor3 = Settings.ESP.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
    end)
    
    return ScreenGui
end

-- Função para verificar se o jogador é válido
local function IsValidPlayer(player)
    return player ~= LocalPlayer and 
           player.Character and 
           player.Character:FindFirstChild("Humanoid") and 
           player.Character.Humanoid.Health > 0 and 
           player.Character:FindFirstChild(Settings.Aimbot.HitPart) and
           (not Settings.Aimbot.TeamCheck or player.Team ~= LocalPlayer.Team)
end

-- Função para obter o jogador mais próximo dentro do FOV
local function GetClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = Settings.Aimbot.FOV
    local mousePos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2) -- Centro da tela para mobile
    
    for _, player in pairs(Players:GetPlayers()) do
        if IsValidPlayer(player) then
            local character = player.Character
            local hitPart = character:FindFirstChild(Settings.Aimbot.HitPart)
            
            if hitPart then
                local screenPos, visible = Camera:WorldToViewportPoint(hitPart.Position)
                
                if visible or not Settings.Aimbot.VisibleCheck then
                    local screenPoint = Vector2.new(screenPos.X, screenPos.Y)
                    local distance = (mousePos - screenPoint).Magnitude
                    
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

-- Função para calcular previsão de movimento
local function CalculatePrediction(targetPart, distance)
    local prediction = Settings.Aimbot.Prediction
    
    -- Aleatorização para evitar detecção
    if Settings.Safety.Randomization then
        prediction = prediction * (0.9 + math.random() * 0.2)
    end
    
    -- Ajuste baseado na distância
    prediction = prediction * (distance / 1000)
    
    -- Verifica se o alvo tem velocidade
    local targetVelocity = targetPart.Parent:FindFirstChild("HumanoidRootPart") and targetPart.Parent.HumanoidRootPart.Velocity or Vector3.new(0, 0, 0)
    
    return targetPart.Position + (targetVelocity * prediction)
end

-- Função principal do Aimbot
local function Aimbot()
    if not Settings.Aimbot.Enabled then return end
    
    local closestPlayer = GetClosestPlayer()
    if not closestPlayer or not closestPlayer.Character then return end
    
    local targetPart = closestPlayer.Character:FindFirstChild(Settings.Aimbot.HitPart)
    if not targetPart then return end
    
    -- Calcula a distância
    local distance = (LocalPlayer.Character.HumanoidRootPart.Position - targetPart.Position).Magnitude
    
    -- Calcula a posição prevista
    local predictedPosition = CalculatePrediction(targetPart, distance)
    
    -- Calcula a direção
    local direction = (predictedPosition - Camera.CFrame.Position).Unit
    
    -- Suavização
    local currentDirection = Camera.CFrame.LookVector
    local smoothedDirection = currentDirection:Lerp(direction, Settings.Aimbot.Smoothness)
    
    -- Silent Aim (aponta internamente sem mover a câmera)
    if Settings.Aimbot.SilentAim then
        -- Esta parte seria usada para modificar os eventos de tiro
        -- (implementação específica depende do jogo)
    else
        -- Aimbot normal (move a câmera)
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + smoothedDirection)
    end
end

-- Função para desenhar ESP
local function DrawESP()
    if not Settings.ESP.Enabled then return end
    
    -- Limpa ESP antigo
    for _, v in pairs(Camera:GetChildren()) do
        if v.Name == "ESP_" then
            v:Destroy()
        end
    end
    
    for _, player in pairs(Players:GetPlayers()) do
        if IsValidPlayer(player) then
            local character = player.Character
            local humanoid = character:FindFirstChild("Humanoid")
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            
            if rootPart then
                local distance = (LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                
                if distance <= Settings.ESP.MaxDistance then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                    
                    if onScreen then
                        -- Calcula o tamanho da caixa baseado na distância
                        local boxSize = Vector2.new(20, 30) * (1000 / distance)
                        
                        -- Cria a caixa do ESP
                        if Settings.ESP.Boxes then
                            local box = Instance.new("Frame")
                            box.Name = "ESP_Box_" .. player.Name
                            box.Size = UDim2.new(0, boxSize.X, 0, boxSize.Y)
                            box.Position = UDim2.new(0, screenPos.X - boxSize.X / 2, 0, screenPos.Y - boxSize.Y / 2)
                            box.BackgroundTransparency = 0.7
                            box.BorderSizePixel = 2
                            box.Parent = Camera
                            
                            -- Cor baseada no time
                            if Settings.ESP.TeamColor then
                                box.BackgroundColor3 = player.Team == LocalPlayer.Team and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
                                box.BorderColor3 = player.Team == LocalPlayer.Team and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
                            else
                                box.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
                                box.BorderColor3 = Color3.fromRGB(200, 200, 0)
                            end
                        end
                        
                        -- Adiciona nome
                        if Settings.ESP.Names then
                            local nameLabel = Instance.new("TextLabel")
                            nameLabel.Name = "ESP_Name_" .. player.Name
                            nameLabel.Text = player.Name
                            nameLabel.Size = UDim2.new(0, 100, 0, 20)
                            nameLabel.Position = UDim2.new(0, screenPos.X - 50, 0, screenPos.Y - boxSize.Y / 2 - 20)
                            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                            nameLabel.BackgroundTransparency = 1
                            nameLabel.TextStrokeTransparency = 0
                            nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                            nameLabel.Parent = Camera
                        end
                        
                        -- Adiciona saúde
                        if Settings.ESP.Health then
                            local healthText = Instance.new("TextLabel")
                            healthText.Name = "ESP_Health_" .. player.Name
                            healthText.Text = "HP: " .. math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
                            healthText.Size = UDim2.new(0, 100, 0, 20)
                            healthText.Position = UDim2.new(0, screenPos.X - 50, 0, screenPos.Y + boxSize.Y / 2)
                            healthText.TextColor3 = Color3.fromRGB(255, 255, 255)
                            healthText.BackgroundTransparency = 1
                            healthText.TextStrokeTransparency = 0
                            healthText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                            healthText.Parent = Camera
                        end
                        
                        -- Adiciona distância
                        if Settings.ESP.Distance then
                            local distanceText = Instance.new("TextLabel")
                            distanceText.Name = "ESP_Distance_" .. player.Name
                            distanceText.Text = math.floor(distance) .. "m"
                            distanceText.Size = UDim2.new(0, 100, 0, 20)
                            distanceText.Position = UDim2.new(0, screenPos.X - 50, 0, screenPos.Y + boxSize.Y / 2 + 20)
                            distanceText.TextColor3 = Color3.fromRGB(255, 255, 255)
                            distanceText.BackgroundTransparency = 1
                            distanceText.TextStrokeTransparency = 0
                            distanceText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                            distanceText.Parent = Camera
                        end
                    end
                end
            end
        end
    end
end

-- Funções de segurança
local function AntiKick()
    if Settings.Safety.AntiKick then
        -- Conecta-se a eventos de kick para prevenir
        LocalPlayer.OnClientEvent:Connect(function(event, ...)
            if event == "Kick" or event == "Teleport" then
                return nil
            end
        end)
    end
end

local function AntiBan()
    if Settings.Safety.AntiBan then
        -- Aleatoriza nomes de instâncias e valores
        local randomString = HttpService:GenerateGUID(false)
        for _, v in pairs(getgc(true)) do
            if type(v) == "table" then
                for i, x in pairs(v) do
                    if type(x) == "string" and (x:find("Cheat") or x:find("Hack") or x:find("Exploit")) then
                        v[i] = randomString
                    end
                end
            end
        end
    end
end

-- Função para verificar atualizações
local function CheckForUpdates()
    if Settings.Safety.UpdateCheck then
        -- Esta função seria implementada com um servidor web para verificar versões
        -- (removido para simplificar o exemplo)
    end
end

-- Função principal de inicialização
local function Main()
    -- Cria a interface mobile
    CreateMobileUI()
    
    -- Aplica proteções
    AntiKick()
    AntiBan()
    
    -- Verifica atualizações
    CheckForUpdates()
    
    -- Loop principal
    RunService.RenderStepped:Connect(function()
        Aimbot()
        DrawESP()
    end)
    
    print("Script carregado com sucesso!")
end

-- Inicializa o script
local success, err = pcall(Main)
if not success then
    warn("Erro ao inicializar o script:", err)
end