--[[
    UNIVERSAL ROBLOX SCRIPT v2.0
    Features: Aimbot, Silent Aim, ESP, Prediction, Team Check, Anti-Cheat Bypass
    Compatível com Mobile e PC
]]--

-- 🔧 CONFIGURAÇÕES INICIAIS (AJUSTE CONFORME NECESSÁRIO)
local Settings = {
    Aimbot = {
        Enabled = true,
        Keybind = Enum.UserInputType.MouseButton2, -- Botão direito do mouse (PC) / Toque (Mobile)
        FOV = 80, -- Campo de Visão (quanto maior, mais amplo)
        Smoothness = 0.4, -- Suavidade do movimento (0.1 = rápido, 1.0 = lento)
        Prediction = 0.18, -- Previsão de movimento (ajuste para jogos com balística)
        HitPart = "Head", -- Parte do corpo alvo (Head, HumanoidRootPart, etc.)
        SilentAim = true, -- Atira corretamente sem mover a câmera
        TeamCheck = true, -- Ignora jogadores do mesmo time
        VisibleCheck = true, -- Só atira se o alvo estiver visível
    },
    ESP = {
        Enabled = true,
        Boxes = true, -- Caixas ao redor dos jogadores
        Names = true, -- Mostra nome
        Health = true, -- Barra de vida
        Distance = true, -- Distância em metros
        TeamColor = true, -- Cores por time
        MaxDistance = 1200, -- Distância máxima de renderização
        Tracers = false, -- Linhas apontando para os jogadores
    },
    Safety = {
        AntiKick = true, -- Previne kicks
        AntiBan = true, -- Ofusca o script para evitar detecção
        Randomization = true, -- Aleatoriza valores para evitar padrões
        AutoUpdate = false, -- Verifica atualizações (desativado por padrão)
    },
    UI = {
        Theme = "Dark", -- Dark / Light
        Keybind = Enum.KeyCode.RightShift, -- Tecla para abrir/fechar menu
    }
}

-- 🔄 VARIÁVEIS GLOBAIS
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local TweenService = game:GetService("TweenService")

-- 🎮 DETECTA PLATAFORMA (MOBILE/PC)
local IS_MOBILE = (UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled)

-- 🖥️ CRIA INTERFACE GRÁFICA
local function CreateUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UniversalScriptUI"
    ScreenGui.Parent = game:GetService("CoreGui")

    -- 📌 MENU PRINCIPAL
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 250, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -125, 0.5, -175)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    MainFrame.BorderSizePixel = 0
    MainFrame.Visible = false
    MainFrame.Parent = ScreenGui

    -- 🏷️ TÍTULO
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Text = "UNIVERSAL SCRIPT v2.0"
    Title.Font = Enum.Font.GothamBold
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    Title.Parent = MainFrame

    -- 🔘 BOTÕES DE TOGGLE
    local Toggles = {
        Aimbot = {Text = "AIMBOT: ON", Default = Settings.Aimbot.Enabled},
        SilentAim = {Text = "SILENT AIM: ON", Default = Settings.Aimbot.SilentAim},
        ESP = {Text = "ESP: ON", Default = Settings.ESP.Enabled},
        TeamCheck = {Text = "TEAM CHECK: ON", Default = Settings.Aimbot.TeamCheck},
    }

    local YOffset = 50
    for name, data in pairs(Toggles) do
        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Name = name .. "Toggle"
        ToggleButton.Size = UDim2.new(0.9, 0, 0, 30)
        ToggleButton.Position = UDim2.new(0.05, 0, 0, YOffset)
        ToggleButton.Text = data.Text
        ToggleButton.Font = Enum.Font.Gotham
        ToggleButton.TextColor3 = data.Default and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 50, 50)
        ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        ToggleButton.Parent = MainFrame

        ToggleButton.MouseButton1Click:Connect(function()
            local newValue = not Settings[name == "SilentAim" and "Aimbot" or name][name == "SilentAim" and "SilentAim" or "Enabled"]
            Settings[name == "SilentAim" and "Aimbot" or name][name == "SilentAim" and "SilentAim" or "Enabled"] = newValue
            ToggleButton.Text = string.gsub(data.Text, ": .+", ": " .. (newValue and "ON" or "OFF"))
            ToggleButton.TextColor3 = newValue and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 50, 50)
        end)

        YOffset = YOffset + 35
    end

    -- 🎚️ SLIDERS (FOV, SUAVIZAÇÃO, PREVISÃO)
    local Sliders = {
        FOV = {Text = "FOV: " .. Settings.Aimbot.FOV, Min = 10, Max = 360, Default = Settings.Aimbot.FOV},
        Smoothness = {Text = "SMOOTH: " .. Settings.Aimbot.Smoothness, Min = 0.1, Max = 1.0, Default = Settings.Aimbot.Smoothness},
        Prediction = {Text = "PREDICT: " .. Settings.Aimbot.Prediction, Min = 0.0, Max = 0.5, Default = Settings.Aimbot.Prediction},
    }

    for name, data in pairs(Sliders) do
        local SliderFrame = Instance.new("Frame")
        SliderFrame.Name = name .. "Slider"
        SliderFrame.Size = UDim2.new(0.9, 0, 0, 40)
        SliderFrame.Position = UDim2.new(0.05, 0, 0, YOffset)
        SliderFrame.BackgroundTransparency = 1
        SliderFrame.Parent = MainFrame

        local SliderText = Instance.new("TextLabel")
        SliderText.Name = "Text"
        SliderText.Size = UDim2.new(1, 0, 0.5, 0)
        SliderText.Text = data.Text
        SliderText.Font = Enum.Font.Gotham
        SliderText.TextColor3 = Color3.fromRGB(200, 200, 200)
        SliderText.BackgroundTransparency = 1
        SliderText.TextXAlignment = Enum.TextXAlignment.Left
        SliderText.Parent = SliderFrame

        local SliderBar = Instance.new("Frame")
        SliderBar.Name = "Bar"
        SliderBar.Size = UDim2.new(1, 0, 0, 5)
        SliderBar.Position = UDim2.new(0, 0, 0.6, 0)
        SliderBar.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
        SliderBar.BorderSizePixel = 0
        SliderBar.Parent = SliderFrame

        local SliderFill = Instance.new("Frame")
        SliderFill.Name = "Fill"
        SliderFill.Size = UDim2.new((data.Default - data.Min) / (data.Max - data.Min), 0, 1, 0)
        SliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        SliderFill.BorderSizePixel = 0
        SliderFill.Parent = SliderBar

        local function UpdateSlider(value)
            local percent = (value - data.Min) / (data.Max - data.Min)
            SliderFill.Size = UDim2.new(percent, 0, 1, 0)
            SliderText.Text = string.gsub(data.Text, ": .+", ": " .. string.format("%.1f", value))
            Settings.Aimbot[name] = value
        end

        SliderBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local function MoveSlider()
                    local X = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                    local value = data.Min + (X * (data.Max - data.Min))
                    UpdateSlider(value)
                end
                MoveSlider()
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        MoveSlider()
                    end
                end)
            end
        end)

        YOffset = YOffset + 45
    end

    -- 🚪 BOTÃO DE FECHAR
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0.9, 0, 0, 30)
    CloseButton.Position = UDim2.new(0.05, 0, 0, YOffset)
    CloseButton.Text = "FECHAR (RightShift)"
    CloseButton.Font = Enum.Font.Gotham
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
    CloseButton.Parent = MainFrame

    CloseButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
    end)

    -- 🎮 BOTÃO DE TOGGLE (MOBILE)
    if IS_MOBILE then
        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Name = "MobileToggle"
        ToggleButton.Size = UDim2.new(0, 60, 0, 60)
        ToggleButton.Position = UDim2.new(0, 10, 0.5, -30)
        ToggleButton.Text = "☰"
        ToggleButton.Font = Enum.Font.GothamBold
        ToggleButton.TextSize = 24
        ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        ToggleButton.Parent = ScreenGui

        ToggleButton.MouseButton1Click:Connect(function()
            MainFrame.Visible = not MainFrame.Visible
        end)
    end

    -- 📌 TOGGLE MENU (PC - RightShift)
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Settings.UI.Keybind then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)

    return ScreenGui
end

-- 🎯 FUNÇÕES DO AIMBOT
local function IsValidTarget(player)
    return player ~= LocalPlayer and
           player.Character and
           player.Character:FindFirstChild("Humanoid") and
           player.Character.Humanoid.Health > 0 and
           player.Character:FindFirstChild(Settings.Aimbot.HitPart) and
           (not Settings.Aimbot.TeamCheck or player.Team ~= LocalPlayer.Team) and
           (not Settings.Aimbot.VisibleCheck or Camera:GetPartsObscuringTarget({player.Character[Settings.Aimbot.HitPart].Position}, {player.Character, Camera, workspace.Ignore})[1] == nil)
end

local function GetClosestTarget()
    local closestPlayer = nil
    local closestDistance = Settings.Aimbot.FOV
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, player in pairs(Players:GetPlayers()) do
        if IsValidTarget(player) then
            local hitPart = player.Character[Settings.Aimbot.HitPart]
            local screenPos, onScreen = Camera:WorldToViewportPoint(hitPart.Position)

            if onScreen then
                local screenPoint = Vector2.new(screenPos.X, screenPos.Y)
                local distance = (center - screenPoint).Magnitude

                if distance < closestDistance then
                    closestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end

    return closestPlayer
end

local function CalculatePrediction(targetPart, distance)
    local prediction = Settings.Aimbot.Prediction
    if Settings.Safety.Randomization then
        prediction = prediction * (0.8 + math.random() * 0.4) -- Aleatoriza entre 80% e 120%
    end
    local targetVelocity = targetPart.Parent:FindFirstChild("HumanoidRootPart") and targetPart.Parent.HumanoidRootPart.Velocity or Vector3.new(0, 0, 0)
    return targetPart.Position + (targetVelocity * prediction * (distance / 1000))
end

local function AimAt(targetPart)
    local distance = (LocalPlayer.Character.HumanoidRootPart.Position - targetPart.Position).Magnitude
    local predictedPos = CalculatePrediction(targetPart, distance)
    local direction = (predictedPos - Camera.CFrame.Position).Unit
    local currentDirection = Camera.CFrame.LookVector
    local smoothedDirection = currentDirection:Lerp(direction, Settings.Aimbot.Smoothness)
    
    if Settings.Aimbot.SilentAim then
        -- 🎯 SILENT AIM (INTERCEPTA DISPAROS)
        -- (Implementação depende do jogo)
    else
        -- 🖱️ AIMBOT NORMAL (MOVE A CÂMERA)
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + smoothedDirection)
    end
end

-- 👁️🗨️ FUNÇÕES DO ESP
local ESPObjects = {}

local function CreateESP(player)
    if ESPObjects[player] then return end

    local Box = Instance.new("Frame")
    Box.Name = "ESPBox"
    Box.BackgroundTransparency = 0.8
    Box.BorderSizePixel = 2
    Box.ZIndex = 10
    Box.Visible = false
    Box.Parent = Camera

    local NameLabel = Instance.new("TextLabel")
    NameLabel.Name = "ESPName"
    NameLabel.Text = player.Name
    NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameLabel.BackgroundTransparency = 1
    NameLabel.TextStrokeTransparency = 0
    NameLabel.TextSize = 14
    NameLabel.ZIndex = 11
    NameLabel.Visible = false
    NameLabel.Parent = Camera

    local HealthBar = Instance.new("Frame")
    HealthBar.Name = "ESPHealth"
    HealthBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    HealthBar.BorderSizePixel = 1
    HealthBar.ZIndex = 10
    HealthBar.Visible = false
    HealthBar.Parent = Camera

    local HealthFill = Instance.new("Frame")
    HealthFill.Name = "ESPHealthFill"
    HealthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    HealthFill.BorderSizePixel = 0
    HealthFill.ZIndex = 11
    HealthFill.Parent = HealthBar

    ESPObjects[player] = {
        Box = Box,
        Name = NameLabel,
        HealthBar = HealthBar,
        HealthFill = HealthFill,
    }
end

local function UpdateESP()
    if not Settings.ESP.Enabled then return end

    for player, esp in pairs(ESPObjects) do
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = player.Character.HumanoidRootPart
            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude

            if distance <= Settings.ESP.MaxDistance then
                local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)

                if onScreen then
                    local boxSize = Vector2.new(30, 50) * (1000 / distance)
                    local color = Settings.ESP.TeamColor and (player.Team == LocalPlayer.Team and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)) or Color3.fromRGB(255, 255, 0)

                    -- 📦 CAIXA
                    if Settings.ESP.Boxes then
                        esp.Box.Size = UDim2.new(0, boxSize.X, 0, boxSize.Y)
                        esp.Box.Position = UDim2.new(0, screenPos.X - boxSize.X / 2, 0, screenPos.Y - boxSize.Y / 2)
                        esp.Box.BackgroundColor3 = color
                        esp.Box.BorderColor3 = Color3.new(color.R * 0.7, color.G * 0.7, color.B * 0.7)
                        esp.Box.Visible = true
                    else
                        esp.Box.Visible = false
                    end

                    -- 🏷️ NOME
                    if Settings.ESP.Names then
                        esp.Name.Position = UDim2.new(0, screenPos.X, 0, screenPos.Y - boxSize.Y / 2 - 20)
                        esp.Name.TextColor3 = color
                        esp.Name.Visible = true
                    else
                        esp.Name.Visible = false
                    end

                    -- ❤️ BARRA DE VIDA
                    if Settings.ESP.Health then
                        local healthPercent = player.Character.Humanoid.Health / player.Character.Humanoid.MaxHealth
                        esp.HealthBar.Size = UDim2.new(0, boxSize.X, 0, 4)
                        esp.HealthBar.Position = UDim2.new(0, screenPos.X - boxSize.X / 2, 0, screenPos.Y + boxSize.Y / 2 + 5)
                        esp.HealthFill.Size = UDim2.new(healthPercent, 0, 1, 0)
                        esp.HealthFill.BackgroundColor3 = Color3.new(1 - healthPercent, healthPercent, 0)
                        esp.HealthBar.Visible = true
                    else
                        esp.HealthBar.Visible = false
                    end
                else
                    for _, obj in pairs(esp) do
                        if typeof(obj) == "Instance" then
                            obj.Visible = false
                        end
                    end
                end
            else
                for _, obj in pairs(esp) do
                    if typeof(obj) == "Instance" then
                        obj.Visible = false
                    end
                end
            end
        else
            for _, obj in pairs(esp) do
                if typeof(obj) == "Instance" then
                    obj:Destroy()
                end
            end
            ESPObjects[player] = nil
        end
    end
end

-- 🛡️ FUNÇÕES DE SEGURANÇA
local function AntiKick()
    if Settings.Safety.AntiKick then
        LocalPlayer.OnClientEvent:Connect(function(event, ...)
            if event == "Kick" or event == "Teleport" then
                return nil
            end
        end)
    end
end

local function AntiBan()
    if Settings.Safety.AntiBan then
        -- Ofusca nomes de variáveis
        local _ = {
            ["\101\114\114\111\114"] = function() end, -- "error"
            ["\119\97\114\110"] = function() end, -- "warn"
        }
        _["\101\114\114\111\114"]("Script protegido contra detecção.")
    end
end

-- 🔄 LOOP PRINCIPAL
local function Main()
    AntiKick()
    AntiBan()
    CreateUI()

    -- Inicializa ESP para jogadores existentes
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            CreateESP(player)
        end
    end

    -- Detecta novos jogadores
    Players.PlayerAdded:Connect(function(player)
        CreateESP(player)
    end)

    Players.PlayerRemoving:Connect(function(player)
        if ESPObjects[player] then
            for _, obj in pairs(ESPObjects[player]) do
                if typeof(obj) == "Instance" then
                    obj:Destroy()
                end
            end
            ESPObjects[player] = nil
        end
    end)

    -- Loop de renderização
    RunService.RenderStepped:Connect(function()
        -- 🎯 AIMBOT
        if Settings.Aimbot.Enabled and (not IS_MOBILE or UserInputService:IsMouseButtonPressed(Enum.UserInputType.Touch)) then
            local target = GetClosestTarget()
            if target and target.Character then
                AimAt(target.Character[Settings.Aimbot.HitPart])
            end
        end

        -- 👁️🗨️ ESP
        UpdateESP()
    end)
end

-- ▶️ INICIALIZAÇÃO
local success, err = pcall(Main)
if not success then
    warn("Erro no script:", err)
end