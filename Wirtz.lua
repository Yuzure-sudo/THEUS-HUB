-- ═══════════════════════════════════════════════════════════════════════════════
-- 🚀 WIXT HUB - ULTIMATE MOBILE EXPLOIT (REVISÃO DE INTERFACE E ABAS)
-- ═══════════════════════════════════════════════════════════════════════════════

-- 🛡️ LIMPEZA TOTAL
pcall(function()
    for _, v in pairs(game.CoreGui:GetChildren()) do
        if v.Name:find("Wixt") or v.Name:find("WixT") or v.Name:find("Hub") then
            v:Destroy()
        end
    end
end)

-- 🎨 CONFIGURAÇÕES ULTIMATE
local WixtHub = {
    Version = "2.0 Ultimate (Rev. Interface)",
    Theme = {
        Primary = Color3.fromRGB(138, 43, 226),    -- Roxo Principal
        Secondary = Color3.fromRGB(75, 0, 130),    -- Roxo Escuro
        Accent = Color3.fromRGB(255, 20, 147),     -- Rosa Complementar
        Success = Color3.fromRGB(46, 204, 113),    -- Verde Sucesso
        Warning = Color3.fromRGB(241, 196, 15),     -- Amarelo Aviso
        Error = Color3.fromRGB(231, 76, 60),       -- Vermelho Erro
        Background = Color3.fromRGB(23, 23, 23),   -- Fundo Escuro Principal
        Surface = Color3.fromRGB(35, 35, 35),      -- Superfície dos containers
        Card = Color3.fromRGB(45, 45, 45),         -- Cartões de elementos
        Text = Color3.fromRGB(255, 255, 255),      -- Texto Claro
        TextSecondary = Color3.fromRGB(170, 170, 170), -- Texto Secundário
        Border = Color3.fromRGB(60, 60, 60),       -- Bordas
        Hover = Color3.fromRGB(160, 82, 45),       -- Cor de Hover (Alterada)
    }
}

-- 🎯 SERVIÇOS
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- 📱 CRIAÇÃO DA INTERFACE ULTIMATE (REVISADA)
local function CreateUltimateInterface()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "WixtHubUltimate"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true -- Ignora a barra de cima do celular

    -- Adiciona um Frame de fundo semi-transparente
    local BackgroundDim = Instance.new("Frame")
    BackgroundDim.Size = UDim2.new(1, 0, 1, 0)
    BackgroundDim.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    BackgroundDim.BackgroundTransparency = 0.6 -- Ajuste conforme o gosto
    BackgroundDim.Parent = ScreenGui
    BackgroundDim.Visible = false -- Esconde por padrão

    -- Frame Principal Mobile
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 380, 0, 600) -- Ajuste no tamanho
    MainFrame.Position = UDim2.new(0.5, -190, 0.5, -300)
    MainFrame.BackgroundColor3 = WixtHub.Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    MainFrame.Visible = false -- Esconde por padrão

    -- Corner Principal
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 25)
    MainCorner.Parent = MainFrame

    -- Stroke Principal
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = WixtHub.Theme.Primary
    MainStroke.Thickness = 3
    MainStroke.Parent = MainFrame

    -- Header
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 70) -- Altura ajustada
    Header.Position = UDim2.new(0, 0, 0, 0)
    Header.BackgroundColor3 = WixtHub.Theme.Primary
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 25)
    HeaderCorner.Parent = Header

    -- Fix Header Bottom
    local HeaderFix = Instance.new("Frame")
    HeaderFix.Size = UDim2.new(1, 0, 0, 35)
    HeaderFix.Position = UDim2.new(0, 0, 0.5, 0)
    HeaderFix.BackgroundColor3 = WixtHub.Theme.Primary
    HeaderFix.BorderSizePixel = 0
    HeaderFix.Parent = Header

    -- Título
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(0.65, 0, 1, 0)
    Title.Position = UDim2.new(0, 25, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "🔥 WixT Hub"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 28
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Font = Enum.Font.GothamBold
    Title.Parent = Header

    -- Botão Fechar
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 60, 0, 60)
    CloseButton.Position = UDim2.new(1, -85, 0, 5) -- Posição ajustada
    CloseButton.BackgroundColor3 = WixtHub.Theme.Error
    CloseButton.Text = "✕"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 24
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.BorderSizePixel = 0
    CloseButton.Parent = Header

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 30)
    CloseCorner.Parent = CloseButton

    -- Container Principal
    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.Size = UDim2.new(1, -20, 1, -90) -- Tamanho ajustado
    Container.Position = UDim2.new(0, 10, 0, 80) -- Posição ajustada
    Container.BackgroundTransparency = 1
    Container.Parent = MainFrame

    -- Tabs Container (Horizontal)
    local TabsContainer = Instance.new("Frame")
    TabsContainer.Name = "TabsContainer"
    TabsContainer.Size = UDim2.new(1, 0, 0, 80) -- Altura ajustada
    TabsContainer.Position = UDim2.new(0, 0, 0, 0)
    TabsContainer.BackgroundColor3 = WixtHub.Theme.Dark
    TabsContainer.BorderSizePixel = 0
    TabsContainer.Parent = Container

    local TabsCorner = Instance.new("UICorner")
    TabsCorner.CornerRadius = UDim.new(0, 20)
    TabsCorner.Parent = TabsContainer

    local TabsLayout = Instance.new("UIListLayout")
    TabsLayout.FillDirection = Enum.FillDirection.Horizontal
    TabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabsLayout.Padding = UDim.new(0, 10) -- Padding ajustado
    TabsLayout.Parent = TabsContainer

    local TabsPadding = Instance.new("UIPadding")
    TabsPadding.PaddingAll = UDim.new(0, 15) -- Padding ajustado
    TabsPadding.Parent = TabsContainer

    -- Content Container (Área onde o conteúdo das abas aparece)
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, 0, 1, -90) -- Tamanho ajustado
    ContentContainer.Position = UDim2.new(0, 0, 0, 90) -- Posição ajustada
    ContentContainer.BackgroundColor3 = WixtHub.Theme.Dark -- Cor ajustada
    ContentContainer.BorderSizePixel = 0
    ContentContainer.Parent = Container

    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 20)
    ContentCorner.Parent = ContentContainer

    return {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        BackgroundDim = BackgroundDim, -- Incluído
        Header = Header,
        TabsContainer = TabsContainer,
        ContentContainer = ContentContainer,
        CloseButton = CloseButton
    }
end

-- 🎯 SISTEMA DE ABAS ULTIMATE (CORRIGIDO)
local function CreateTabSystem(interface)
    local tabs = {}
    local currentTabName = nil -- Guarda o nome da aba atual

    local function CreateTab(name, icon)
        local tabIndex = #tabs + 1

        -- Botão da Aba
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name .. "Tab"
        TabButton.Size = UDim2.new(0, 80, 1, 0) -- Tamanho ajustado
        TabButton.BackgroundColor3 = WixtHub.Theme.Card
        TabButton.Text = icon
        TabButton.TextColor3 = WixtHub.Theme.TextSecondary
        TabButton.TextSize = 24 -- Tamanho do ícone ajustado
        TabButton.Font = Enum.Font.GothamBold
        TabButton.BorderSizePixel = 0
        TabButton.LayoutOrder = tabIndex
        TabButton.Parent = interface.TabsContainer

        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 15) -- Corner ajustado
        TabCorner.Parent = TabButton

        -- Conteúdo da Aba
        local ContentFrame = Instance.new("ScrollingFrame")
        ContentFrame.Name = name .. "Content"
        ContentFrame.Size = UDim2.new(1, -30, 1, -30) -- Tamanho ajustado
        ContentFrame.Position = UDim2.new(0, 15, 0, 15) -- Posição ajustada
        ContentFrame.BackgroundTransparency = 1 -- Transparente para mostrar o fundo do ContentContainer
        ContentFrame.ScrollBarThickness = 10
        ContentFrame.ScrollBarImageColor3 = WixtHub.Theme.Accent -- Cor ajustada
        ContentFrame.BorderSizePixel = 0
        ContentFrame.Visible = false -- Esconde por padrão
        ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        ContentFrame.Parent = interface.ContentContainer -- Pai correto

        -- Layout
        local Layout = Instance.new("UIListLayout")
        Layout.Padding = UDim.new(0, 20) -- Padding ajustado
        Layout.SortOrder = Enum.SortOrder.LayoutOrder
        Layout.Parent = ContentFrame

        -- Auto-resize
        Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            ContentFrame.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 40)
        end)

        local function SelectTab()
            -- Desativar todas
            for _, tabData in pairs(tabs) do
                TweenService:Create(tabData.Button, TweenInfo.new(0.3), {
                    BackgroundColor3 = WixtHub.Theme.Card,
                    TextColor3 = WixtHub.Theme.TextSecondary
                }):Play()
                tabData.Content.Visible = false
            end

            -- Ativar esta
            TweenService:Create(TabButton, TweenInfo.new(0.3), {
                BackgroundColor3 = WixtHub.Theme.Primary,
                TextColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
            ContentFrame.Visible = true
            currentTabName = name -- Atualiza o nome da aba ativa

            -- Força um update para garantir que os elementos internos apareçam
            ContentFrame.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 41) -- +1 pixel hack
            ContentFrame.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 40)
        end

        TabButton.MouseButton1Click:Connect(SelectTab)

        table.insert(tabs, {
            Name = name,
            Button = TabButton,
            Content = ContentFrame
        })

        -- Ativar primeira aba por padrão
        if tabIndex == 1 then
            SelectTab()
        end

        return ContentFrame -- Retorna o frame de conteúdo da aba
    end

    return CreateTab -- Retorna a função para criar abas
end

-- 🎮 ELEMENTOS UI ULTIMATE (CORRIGIDOS E MELHORADOS)
local function CreateButton(parent, text, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 60) -- Altura ajustada
    Button.BackgroundColor3 = WixtHub.Theme.Primary
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 18
    Button.Font = Enum.Font.GothamBold
    Button.BorderSizePixel = 0
    Button.Parent = parent

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 15)
    Corner.Parent = Button

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = WixtHub.Theme.Border
    Stroke.Thickness = 2
    Stroke.Parent = Button

    -- Efeitos Touch melhores
    Button.MouseButton1Down:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.1), {
             BackgroundColor3 = WixtHub.Theme.Secondary,
             Size = UDim2.new(1, 0, 0, 55)
        }):Play()
    end)

     Button.MouseButton1Up:Connect(function()
         TweenService:Create(Button, TweenInfo.new(0.2), {
              BackgroundColor3 = WixtHub.Theme.Primary,
              Size = UDim2.new(1, 0, 0, 60)
         }):Play()
     end)

    if callback then
        Button.MouseButton1Click:Connect(callback)
    end

    return Button
end

local function CreateToggle(parent, text, defaultValue, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 70) -- Altura ajustada
    ToggleFrame.BackgroundColor3 = WixtHub.Theme.Card
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = parent

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 15)
    Corner.Parent = ToggleFrame

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = WixtHub.Theme.Border
    Stroke.Thickness = 2
    Stroke.Parent = ToggleFrame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 1, 0)
    Label.Position = UDim2.new(0, 20, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = WixtHub.Theme.Text
    Label.TextSize = 16
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.Gotham
    Label.Parent = ToggleFrame

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 100, 0, 50) -- Tamanho ajustado
    ToggleButton.Position = UDim2.new(1, -110, 0.5, -25)
    ToggleButton.BackgroundColor3 = defaultValue and WixtHub.Theme.Success or WixtHub.Theme.Error
    ToggleButton.Text = defaultValue and "ON" or "OFF"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextSize = 16
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Parent = ToggleFrame

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 25) -- Corner ajustado
    ToggleCorner.Parent = ToggleButton

    local isEnabled = defaultValue

    ToggleButton.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled

        TweenService:Create(ToggleButton, TweenInfo.new(0.3), {
            BackgroundColor3 = isEnabled and WixtHub.Theme.Success or WixtHub.Theme.Error
        }):Play()

        ToggleButton.Text = isEnabled and "ON" or "OFF"

        if callback then
            callback(isEnabled)
        end
    end)

    return ToggleFrame
end

local function CreateSlider(parent, text, min, max, defaultValue, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, 0, 0, 95) -- Altura ajustada
    SliderFrame.BackgroundColor3 = WixtHub.Theme.Card
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Parent = parent

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 15)
    Corner.Parent = SliderFrame

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = WixtHub.Theme.Border
    Stroke.Thickness = 2
    Stroke.Parent = SliderFrame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 0, 40) -- Altura ajustada
    Label.Position = UDim2.new(0, 20, 0, 10)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = WixtHub.Theme.Text
    Label.TextSize = 16
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.Gotham
    Label.Parent = SliderFrame

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0.4, 0, 0, 40) -- Altura ajustada
    ValueLabel.Position = UDim2.new(0.6, 0, 0, 10)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(defaultValue)
    ValueLabel.TextColor3 = WixtHub.Theme.Primary
    ValueLabel.TextSize = 18
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.Parent = SliderFrame

    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(1, -40, 0, 18) -- Largura ajustada
    SliderBar.Position = UDim2.new(0, 20, 1, -35) -- Posição ajustada
    SliderBar.BackgroundColor3 = WixtHub.Theme.Background
    SliderBar.BorderSizePixel = 0
    SliderBar.Parent = SliderFrame

    local SliderBarCorner = Instance.new("UICorner")
    SliderBarCorner.CornerRadius = UDim.new(0, 9)
    SliderBarCorner.Parent = SliderBar

    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((defaultValue - min) / (max - min), 0, 1, 0)
    SliderFill.Position = UDim2.new(0, 0, 0, 0)
    SliderFill.BackgroundColor3 = WixtHub.Theme.Primary
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBar

    local SliderFillCorner = Instance.new("UICorner")
    SliderFillCorner.CornerRadius = UDim.new(0, 9)
    SliderFillCorner.Parent = SliderFill

    local SliderButton = Instance.new("TextButton")
    SliderButton.Size = UDim2.new(0, 30, 0, 30) -- Tamanho ajustado
    SliderButton.Position = UDim2.new((defaultValue - min) / (max - min), -15, 0.5, -15) -- Posição ajustada
    SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderButton.Text = ""
    SliderButton.BorderSizePixel = 0
    SliderButton.Parent = SliderBar

    local SliderButtonCorner = Instance.new("UICorner")
    SliderButtonCorner.CornerRadius = UDim.new(0, 15) -- Corner ajustado
    SliderButtonCorner.Parent = SliderButton

    local dragging = false

    SliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
             dragging = true
             TweenService:Create(SliderButton, TweenInfo.new(0.2), {
                 BackgroundColor3 = WixtHub.Theme.Primary,
                 Size = UDim2.new(0, 35, 0, 35)
             }):Play()
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            TweenService:Create(SliderButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Size = UDim2.new(0, 30, 0, 30)
            }):Play()
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local relativeX = math.clamp((Mouse.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + (max - min) * relativeX)

            TweenService:Create(SliderFill, TweenInfo.new(0.1), {
                Size = UDim2.new(relativeX, 0, 1, 0)
            }):Play()

            TweenService:Create(SliderButton, TweenInfo.new(0.1), {
                Position = UDim2.new(relativeX, -15, 0.5, -15)
            }):Play()


            ValueLabel.Text = tostring(value)

            if callback then
                callback(value)
            end
        end
    end)

    return SliderFrame
end


-- 🔫 AIMBOT ULTIMATE (Adicionado TriggerBot e Silent Aim)
local AimbotSettings = {
    Enabled = false,
    TeamCheck = true,
    WallCheck = true,
    TargetPart = "Head",
    Smoothness = 0.12,
    FOV = 180,
    MaxDistance = 2500,
    PredictMovement = true,
    AutoShoot = false,
    SilentAim = false,
    TriggerBot = false, -- Novo
}

local function CreateUltimateAimbot()
    -- FOV Circle
    local FOVCircle = Drawing.new("Circle")
    FOVCircle.Thickness = 3
    FOVCircle.Color = WixtHub.Theme.Primary
    FOVCircle.Filled = false
    FOVCircle.Radius = AimbotSettings.FOV
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Visible = false

    -- Target Indicator
    local TargetIndicator = Drawing.new("Circle")
    TargetIndicator.Thickness = 5
    TargetIndicator.Color = WixtHub.Theme.Accent
    TargetIndicator.Filled = false
    TargetIndicator.Radius = 25
    TargetIndicator.Visible = false

    -- Crosshair
    local CrosshairH = Drawing.new("Line")
    CrosshairH.Thickness = 2
    CrosshairH.Color = Color3.fromRGB(255, 255, 255)
    CrosshairH.Visible = false

    local CrosshairV = Drawing.new("Line")
    CrosshairV.Thickness = 2
    CrosshairV.Color = Color3.fromRGB(255, 255, 255)
    CrosshairV.Visible = false

    local function GetClosestPlayer()
        local closestPlayer = nil
        local closestDistance = math.huge
        local centerScreen = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(AimbotSettings.TargetPart) then
                if AimbotSettings.TeamCheck and player.Team == LocalPlayer.Team then
                    continue
                end

                local character = player.Character
                local targetPart = character:FindFirstChild(AimbotSettings.TargetPart)
                if not targetPart then continue end

                local targetPosition = targetPart.Position

                -- Predição avançada
                if AimbotSettings.PredictMovement and character:FindFirstChild("HumanoidRootPart") and character.HumanoidRootPart:FindFirstChildOfClass("BodyVelocity") or character:FindFirstChild("HumanoidRootPart"):FindFirstChildOfClass("VectorForce") then
                     local velocity = character.HumanoidRootPart.Velocity -- Use a velocidade real
                     local distance = (LocalPlayer.Character.HumanoidRootPart.Position - targetPosition).Magnitude
                     local timeToTarget = distance / 2500 -- Velocidade estimada do projétil
                     targetPosition = targetPosition + (velocity * timeToTarget * 0.9)
                 end

                local screenPoint, onScreen = Camera:WorldToViewportPoint(targetPosition)

                if onScreen then
                    local distance2D = (Vector2.new(screenPoint.X, screenPoint.Y) - centerScreen).Magnitude
                    local distance3D = (LocalPlayer.Character.HumanoidRootPart.Position - targetPosition).Magnitude

                    if distance2D < AimbotSettings.FOV and distance3D < AimbotSettings.MaxDistance and distance2D < closestDistance then
                        -- Wall Check avançado
                        if AimbotSettings.WallCheck then
                            local raycastParams = RaycastParams.new()
                            raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                            raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}

                            local raycastResult = Workspace:Raycast(Camera.CFrame.Position, (targetPosition - Camera.CFrame.Position).Unit * distance3D, raycastParams)

                            if raycastResult and raycastResult.Instance:IsDescendantOf(character) then
                                closestPlayer = player
                                closestDistance = distance2D
                            elseif not raycastResult then -- Se não houver obstáculo
                                closestPlayer = player
                                closestDistance = distance2D
                            end
                        else
                            closestPlayer = player
                            closestDistance = distance2D
                        end
                    end
                end
            end
        end

        return closestPlayer
    end

    local aimbotConnection
    local isAiming = false
    local currentTarget = nil

    -- Input Detection
    UserInputService.TouchStarted:Connect(function(touch, gameProcessed)
        if not gameProcessed and AimbotSettings.Enabled then
            isAiming = true
        end
    end)

    UserInputService.TouchEnded:Connect(function(touch, gameProcessed)
        isAiming = false
        currentTarget = nil
        TargetIndicator.Visible = false
    end)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and AimbotSettings.Enabled then
            if input.UserInputType == Enum.UserInputType.MouseButton2 then
                isAiming = true
            end
        end
    end)

    UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            isAiming = false
            currentTarget = nil
            TargetIndicator.Visible = false
        end
    end)

    local function ToggleAimbot(enabled)
        AimbotSettings.Enabled = enabled
        FOVCircle.Visible = enabled
        CrosshairH.Visible = enabled
        CrosshairV.Visible = enabled

        if enabled then
            aimbotConnection = RunService.Heartbeat:Connect(function()
                -- Update FOV Circle
                FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                FOVCircle.Radius = AimbotSettings.FOV

                -- Update Crosshair
                local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                CrosshairH.From = Vector2.new(center.X - 10, center.Y)
                CrosshairH.To = Vector2.new(center.X + 10, center.Y)
                CrosshairV.From = Vector2.new(center.X, center.Y - 10)
                CrosshairV.To = Vector2.new(center.X, center.Y + 10)


                if isAiming or AimbotSettings.AutoShoot then
                    local target = GetClosestPlayer()
                    if target and target.Character and target.Character:FindFirstChild(AimbotSettings.TargetPart) then
                        currentTarget = target
                        local targetPart = target.Character[AimbotSettings.TargetPart]
                        local targetPosition = targetPart.Position

                        -- Predição
                        if AimbotSettings.PredictMovement and target.Character:FindFirstChild("HumanoidRootPart") then
                            local velocity = target.Character.HumanoidRootPart.Velocity
                            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - targetPosition).Magnitude
                            local timeToTarget = distance / 2500
                            targetPosition = targetPosition + (velocity * timeToTarget * 0.8)
                        end


                        -- Target Indicator
                        local screenPoint, onScreen = Camera:WorldToViewportPoint(targetPosition)
                        if onScreen then
                            TargetIndicator.Position = Vector2.new(screenPoint.X, screenPoint.Y)
                            TargetIndicator.Visible = true
                        end

                        -- Aimbot
                        if not AimbotSettings.SilentAim then
                            local cameraDirection = (targetPosition - Camera.CFrame.Position).Unit
                            local newCFrame = CFrame.lookAt(Camera.CFrame.Position, Camera.CFrame.Position + cameraDirection)
                            Camera.CFrame = Camera.CFrame:Lerp(newCFrame, AimbotSettings.Smoothness)
                        end

                        -- Auto Shoot
                        if AimbotSettings.AutoShoot or AimbotSettings.TriggerBot then -- Dispara se auto shoot ou trigger bot (se no alcance)
                             local distance = (LocalPlayer.Character.HumanoidRootPart.Position - targetPosition).Magnitude
                             if AimbotSettings.AutoShoot or (AimbotSettings.TriggerBot and distance < 100) then // Alcance do trigger bot
                                local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                                if tool and tool:FindFirstChild("RemoteEvents") then // Verifica se tem um remote de tiro (adaptar para cada jogo)
                                     for _, v in pairs(tool.RemoteEvents:GetChildren()) do
                                         if v:IsA("RemoteEvent") then // Dispara qualquer remoteevent no tool
                                              v:FireServer(...)
                                              break
                                         end
                                     end
                                elseif tool and typeof(tool.PrimaryAction) == "function" then // Verifica se tem função de tiro no script local
                                     tool.PrimaryAction()
                                else // Dispara mouse1 click como fallback
                                     mouse1click()
                                end
                             end
                         end

                    else
                        TargetIndicator.Visible = false
                    end
                else
                    TargetIndicator.Visible = false
                end
            end)
        else
            if aimbotConnection then
                aimbotConnection:Disconnect()
            end
            TargetIndicator.Visible = false
            FOVCircle.Visible = false
            CrosshairH.Visible = false
            CrosshairV.Visible = false
        end
    end

    return {
        Toggle = ToggleAimbot,
        Settings = AimbotSettings,
    }
end

-- 👁️ ESP ULTIMATE (Adicionado Skeletons e Tracers)
local ESPSettings = {
    Enabled = false,
    Names = true,
    Health = true,
    Distance = true,
    Boxes = true,
    Skeletons = false, -- Novo
    Tracers = false, -- Novo
    TeamCheck = true,
    MaxDistance = 2500
}

local function CreateUltimateESP()
    local espObjects = {}

    local function CreateESPObject(player)
        local esp = {}

        esp.nameLabel = Drawing.new("Text")
        esp.nameLabel.Size = 18
        esp.nameLabel.Color = Color3.fromRGB(255, 255, 255)
        esp.nameLabel.Font = 2
        esp.nameLabel.Outline = true
        esp.nameLabel.Center = true
        esp.nameLabel.Visible = false

        esp.healthLabel = Drawing.new("Text")
        esp.healthLabel.Size = 16
        esp.healthLabel.Color = Color3.fromRGB(0, 255, 0)
        esp.healthLabel.Font = 2
        esp.healthLabel.Outline = true
        esp.healthLabel.Center = true
        esp.healthLabel.Visible = false

        esp.distanceLabel = Drawing.new("Text")
        esp.distanceLabel.Size = 14
        esp.distanceLabel.Color = Color3.fromRGB(255, 255, 0)
        esp.distanceLabel.Font = 2
        esp.distanceLabel.Outline = true
        esp.distanceLabel.Center = true
        esp.distanceLabel.Visible = false

        esp.box = Drawing.new("Square")
        esp.box.Color = WixtHub.Theme.Primary
        esp.box.Thickness = 2
        esp.box.Filled = false
        esp.box.Visible = false

        esp.healthBar = Drawing.new("Square")
        esp.healthBar.Color = Color3.fromRGB(0, 255, 0)
        esp.healthBar.Thickness = 0
        esp.healthBar.Filled = true
        esp.healthBar.Visible = false

        esp.tracer = Drawing.new("Line")
        esp.tracer.Color = WixtHub.Theme.Accent
        esp.tracer.Thickness = 2
        esp.tracer.Visible = false

        -- Skeletons
        esp.skeleton = {}
        local bones = {
            Head = "Neck",
            Neck = "Torso",
            Torso = "HumanoidRootPart",

            HumanoidRootPart = "LeftUpperLeg",
            LeftUpperLeg = "LeftLowerLeg",
            LeftLowerLeg = "LeftFoot",

            HumanoidRootPart = "RightUpperLeg",
            RightUpperLeg = "RightLowerLeg",
            RightLowerLeg = "RightFoot",

            Torso = "LeftUpperArm",
            LeftUpperArm = "LeftLowerArm",
            LeftLowerArm = "LeftHand",

            Torso = "RightUpperArm",
            RightUpperArm = "RightLowerArm",
            RightLowerArm = "RightHand"
        }

        for p1, p2 in pairs(bones) do
            esp.skeleton[p1 .. "-" .. p2] = Drawing.new("Line")
            esp.skeleton[p1 .. "-" .. p2].Color = WixtHub.Theme.Secondary
            esp.skeleton[p1 .. "-" .. p2].Thickness = 2
            esp.skeleton[p1 .. "-" .. p2].Visible = false
        end


        return esp
    end

    local function UpdateESP()
        for player, esp in pairs(espObjects) do
            local isValid = player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid")

            if isValid then
                local character = player.Character
                local rootPart = character.HumanoidRootPart
                local humanoid = character.Humanoid

                if ESPSettings.TeamCheck and player.Team == LocalPlayer.Team then
                    -- Esconde tudo se for do time
                    for _, d in pairs(esp) do if typeof(d) == "Drawing" then d.Visible = false end end
                    continue
                end

                local distance = (LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)

                -- Verifica se está na tela E dentro da distância máxima E ESP habilitado
                if onScreen and distance <= ESPSettings.MaxDistance and ESPSettings.Enabled then

                    -- Nomes
                    esp.nameLabel.Visible = ESPSettings.Names
                    if ESPSettings.Names then
                         esp.nameLabel.Position = Vector2.new(screenPos.X, screenPos.Y - 70)
                         esp.nameLabel.Text = player.Name
                    end


                    -- Health
                    esp.healthLabel.Visible = ESPSettings.Health
                    if ESPSettings.Health then
                        esp.healthLabel.Position = Vector2.new(screenPos.X, screenPos.Y - 50)
                        esp.healthLabel.Text = math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
                        local healthPercent = humanoid.Health / humanoid.MaxHealth
                        esp.healthLabel.Color = Color3.fromRGB(
                            math.clamp(255 - healthPercent * 255, 0, 255),
                            math.clamp(healthPercent * 255, 0, 255),
                            0
                        )
                    end

                    -- Distance
                    esp.distanceLabel.Visible = ESPSettings.Distance
                     if ESPSettings.Distance then
                         esp.distanceLabel.Position = Vector2.new(screenPos.X, screenPos.Y + 50)
                         esp.distanceLabel.Text = math.floor(distance) .. "m"
                     end


                    -- Boxes & Health Bar
                    esp.box.Visible = ESPSettings.Boxes
                    esp.healthBar.Visible = ESPSettings.Boxes and ESPSettings.Health

                    if ESPSettings.Boxes and character:FindFirstChild("Head") then
                        local headPos, headOnScreen = Camera:WorldToViewportPoint(character.Head.Position + Vector3.new(0, 0.5, 0))
                        local legPos, legOnScreen = Camera:WorldToViewportPoint(character.HumanoidRootPart.Position - Vector3.new(0, 3, 0))

                        if headOnScreen and legOnScreen then
                            local boxHeight = math.abs(headPos.Y - legPos.Y)
                            local boxWidth = boxHeight * 0.6

                            esp.box.Size = Vector2.new(boxWidth, boxHeight)
                            esp.box.Position = Vector2.new(screenPos.X - boxWidth/2, headPos.Y)

                            -- Health Bar ao lado da box
                            if humanoid and ESPSettings.Health then
                                local healthPercent = humanoid.Health / humanoid.MaxHealth
                                esp.healthBar.Size = Vector2.new(6, boxHeight * healthPercent)
                                esp.healthBar.Position = Vector2.new(screenPos.X - boxWidth/2 - 10, headPos.Y + boxHeight - (boxHeight * healthPercent))
                                esp.healthBar.Color = Color3.fromRGB(
                                    math.clamp(255 - healthPercent * 255, 0, 255),
                                    math.clamp(healthPercent * 255, 0, 255),
                                    0
                                )
                            end
                        else
                            esp.box.Visible = false
                            esp.healthBar.Visible = false
                        end
                    else
                        esp.box.Visible = false
                        esp.healthBar.Visible = false
                    end

                    -- Skeletons
                    if ESPSettings.Skeletons then
                        local parts = {
                            Head = character:FindFirstChild("Head"),
                            Torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso"),
                            HumanoidRootPart = character:FindFirstChild("HumanoidRootPart"),
                            
                            LeftUpperLeg = character:FindFirstChild("LeftUpperLeg") or character:FindFirstChild("Left Leg"),
                            LeftLowerLeg = character:FindFirstChild("LeftLowerLeg"),
                            LeftFoot = character:FindFirstChild("LeftFoot"),
                            
                            RightUpperLeg = character:FindFirstChild("RightUpperLeg") or character:FindFirstChild("Right Leg"),
                            RightLowerLeg = character:FindFirstChild("RightLowerLeg"),
                            RightFoot = character:FindFirstChild("RightFoot"),
                            
                            LeftUpperArm = character:FindFirstChild("LeftUpperArm") or character:FindFirstChild("Left Arm"),
                            LeftLowerArm = character:FindFirstChild("LeftLowerArm"),
                            LeftHand = character:FindFirstChild("LeftHand"),
                            
                            RightUpperArm = character:FindFirstChild("RightUpperArm") or character:FindFirstChild("Right Arm"),
                            RightLowerArm = character:FindFirstChild("RightLowerArm"),
                            RightHand = character:FindFirstChild("RightHand")
                        }

                        local bones = {
                            {"Head", "Torso"},
                            {"Torso", "HumanoidRootPart"},
                            {"HumanoidRootPart", "LeftUpperLeg"},
                            {"LeftUpperLeg", "LeftLowerLeg"},
                            {"LeftLowerLeg", "LeftFoot"},
                            {"HumanoidRootPart", "RightUpperLeg"},
                            {"RightUpperLeg", "RightLowerLeg"},
                            {"RightLowerLeg", "RightFoot"},
                            {"Torso", "LeftUpperArm"},
                            {"LeftUpperArm", "LeftLowerArm"},
                            {"LeftLowerArm", "LeftHand"},
                            {"Torso", "RightUpperArm"},
                            {"RightUpperArm", "RightLowerArm"},
                            {"RightLowerArm", "RightHand"}
                        }

                        for _, bonePair in pairs(bones) do
                            local p1Name, p2Name = unpack(bonePair)
                            local p1 = parts[p1Name]
                            local p2 = parts[p2Name]
                            local boneName = p1Name .. "-" .. p2Name

                            if p1 and p2 and esp.skeleton[boneName] then
                                local p1Screen, p1OnScreen = Camera:WorldToViewportPoint(p1.Position)
                                local p2Screen, p2OnScreen = Camera:WorldToViewportPoint(p2.Position)

                                if p1OnScreen and p2OnScreen then
                                    esp.skeleton[boneName].From = Vector2.new(p1Screen.X, p1Screen.Y)
                                    esp.skeleton[boneName].To = Vector2.new(p2Screen.X, p2Screen.Y)
                                    esp.skeleton[boneName].Visible = true
                                else
                                    esp.skeleton[boneName].Visible = false
                                end
                            elseif esp.skeleton[boneName] then
                                esp.skeleton[boneName].Visible = false
                            end
                        end
                    else
                        for _, boneLine in pairs(esp.skeleton) do
                            boneLine.Visible = false
                        end
                    end

                    -- Tracers
                    if ESPSettings.Tracers then
                        esp.tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        esp.tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                        esp.tracer.Visible = true
                    else
                        esp.tracer.Visible = false
                    end

                else
                    -- Esconde tudo se fora da tela/distância
                    esp.nameLabel.Visible = false
                    esp.healthLabel.Visible = false
                    esp.distanceLabel.Visible = false
                    esp.box.Visible = false
                    esp.healthBar.Visible = false
                    esp.tracer.Visible = false
                    for _, boneLine in pairs(esp.skeleton) do
                        boneLine.Visible = false
                    end
                end
            else
                -- Esconde tudo se personagem inválido
                esp.nameLabel.Visible = false
                esp.healthLabel.Visible = false
                esp.distanceLabel.Visible = false
                esp.box.Visible = false
                esp.healthBar.Visible = false
                esp.tracer.Visible = false
                for _, boneLine in pairs(esp.skeleton) do
                    boneLine.Visible = false
                end
            end
        end
    end

    Players.PlayerAdded:Connect(function(player)
        espObjects[player] = CreateESPObject(player)
    end)

    Players.PlayerRemoving:Connect(function(player)
        if espObjects[player] then
            for _, object in pairs(espObjects[player]) do
                if typeof(object) == "userdata" and object.Remove then
                    object:Remove()
                end
            end
            if espObjects[player].skeleton then
                for _, boneLine in pairs(espObjects[player].skeleton) do
                    if boneLine.Remove then
                        boneLine:Remove()
                    end
                end
            end
            espObjects[player] = nil
        end
    end)

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            espObjects[player] = CreateESPObject(player)
        end
    end

    local espConnection

    local function ToggleESP(enabled)
        ESPSettings.Enabled = enabled

        if enabled then
            espConnection = RunService.Heartbeat:Connect(UpdateESP)
        else
            if espConnection then
                espConnection:Disconnect()
                espConnection = nil
            end

            for _, esp in pairs(espObjects) do
                esp.nameLabel.Visible = false
                esp.healthLabel.Visible = false
                esp.distanceLabel.Visible = false
                esp.box.Visible = false
                esp.healthBar.Visible = false
                esp.tracer.Visible = false
                for _, boneLine in pairs(esp.skeleton) do
                    boneLine.Visible = false
                end
            end
        end
    end

    return {
        Toggle = ToggleESP,
        Settings = ESPSettings
    }
end

-- 🏃 MOVIMENTO ULTIMATE (Adicionado Noclip e Fly)
local function CreateUltimateMovement()
    local noclipConnection
    local flyConnection
    local bodyVelocity

    local function SetWalkSpeed(speed)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = speed
        end
    end

    local function SetJumpPower(power)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = power
        end
    end

    local function ToggleNoclip(enabled)
        if enabled then
            noclipConnection = RunService.Stepped:Connect(function()
                if LocalPlayer.Character then
                    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end

    local function ToggleFly(enabled)
        if enabled then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and not LocalPlayer.Character.HumanoidRootPart:FindFirstChildOfClass("BodyVelocity") then
                bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                bodyVelocity.Parent = LocalPlayer.Character.HumanoidRootPart
            end

            flyConnection = RunService.Heartbeat:Connect(function()
                if bodyVelocity then
                    local moveVector = Vector3.new(0, 0, 0)
                    local moveSpeed = 50

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveVector = moveVector + Camera.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveVector = moveVector - Camera.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveVector = moveVector - Camera.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveVector = moveVector + Camera.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveVector = moveVector + Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveVector = moveVector - Vector3.new(0, 1, 0)
                    end

                    bodyVelocity.Velocity = moveVector.Unit * moveSpeed
                end
            end)
        else
            if flyConnection then
                flyConnection:Disconnect()
                flyConnection = nil
            end
            if bodyVelocity then
                bodyVelocity:Destroy()
                bodyVelocity = nil
            end
        end
    end

    return {
        SetWalkSpeed = SetWalkSpeed,
        SetJumpPower = SetJumpPower,
        ToggleNoclip = ToggleNoclip,
        ToggleFly = ToggleFly,
    }
end

-- 🚀 INICIALIZAÇÃO GERAL
local interface = CreateUltimateInterface()
local createTab = CreateTabSystem(interface)
local aimbotSystem = CreateUltimateAimbot()
local espSystem = CreateUltimateESP()
local movementSystem = CreateUltimateMovement()

-- Ativar/Desativar Interface
local isInterfaceVisible = false

local function ToggleInterface(visible)
    isInterfaceVisible = visible

    if visible then
        interface.BackgroundDim.Visible = true
        interface.MainFrame.Visible = true

        TweenService:Create(interface.MainFrame, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 380, 0, 650),
            Position = UDim2.new(0.5, -190, 0.5, -325),
            Rotation = 0
        }):Play()

        TweenService:Create(interface.BackgroundDim, TweenInfo.new(0.5), {
            BackgroundTransparency = 0.6
        }):Play()

    else
        TweenService:Create(interface.MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Rotation = -180
        }):Play()

        TweenService:Create(interface.BackgroundDim, TweenInfo.new(0.5), {
            BackgroundTransparency = 1
        }):Play()

        wait(0.5)
        interface.MainFrame.Visible = false
        interface.BackgroundDim.Visible = false

        aimbotSystem.Toggle(false)
        espSystem.Toggle(false)
    end
end

-- Toggle inicial
local debugButton = Instance.new("TextButton")
debugButton.Size = UDim2.new(0, 100, 0, 50)
debugButton.Position = UDim2.new(0, 10, 0, 10)
debugButton.Text = "Abrir Hub"
debugButton.Parent = game.CoreGui
debugButton.MouseButton1Click:Connect(function()
    ToggleInterface(not isInterfaceVisible)
end)

interface.CloseButton.MouseButton1Click:Connect(function()
    ToggleInterface(false)
end)

-- 🎯 ABA AIMBOT
local aimbotTab = createTab("Aimbot", "🎯")

CreateToggle(aimbotTab, "🔥 Aimbot Ativado", false, function(enabled)
    aimbotSystem.Toggle(enabled)
end)

CreateToggle(aimbotTab, "👥 Team Check", true, function(enabled)
    aimbotSystem.Settings.TeamCheck = enabled
end)

CreateToggle(aimbotTab, "🧱 Wall Check", true, function(enabled)
    aimbotSystem.Settings.WallCheck = enabled
end)

CreateToggle(aimbotTab, "🎯 Predição", true, function(enabled)
    aimbotSystem.Settings.PredictMovement = enabled
end)

CreateToggle(aimbotTab, "🔫 Auto Shoot", false, function(enabled)
    aimbotSystem.Settings.AutoShoot = enabled
end)

CreateToggle(aimbotTab, "⚡ Trigger Bot", false, function(enabled)
    aimbotSystem.Settings.TriggerBot = enabled
end)

CreateSlider(aimbotTab, "🎯 FOV", 30, 360, 180, function(value)
    aimbotSystem.Settings.FOV = value
end)

CreateSlider(aimbotTab, "⚡ Suavidade", 1, 100, 12, function(value)
    aimbotSystem.Settings.Smoothness = value / 100
end)

CreateButton(aimbotTab, "🎯 Cabeça", function()
    aimbotSystem.Settings.TargetPart = "Head"
end)

CreateButton(aimbotTab, "🫀 Torso", function()
    aimbotSystem.Settings.TargetPart = "Torso"
end)

-- 👁️ ABA ESP
local espTab = createTab("ESP", "👁️")

CreateToggle(espTab, "🔥 ESP Ativado", false, function(enabled)
    espSystem.Toggle(enabled)
end)

CreateToggle(espTab, "📝 Nomes", true, function(enabled)
    espSystem.Settings.Names = enabled
end)

CreateToggle(espTab, "❤️ Vida", true, function(enabled)
    espSystem.Settings.Health = enabled
end)

CreateToggle(espTab, "📏 Distância", true, function(enabled)
    espSystem.Settings.Distance = enabled
end)

CreateToggle(espTab, "📦 Boxes", true, function(enabled)
    espSystem.Settings.Boxes = enabled
end)

CreateToggle(espTab, "🦴 Skeletons", false, function(enabled)
    espSystem.Settings.Skeletons = enabled
end)

CreateToggle(espTab, "🔗 Tracers", false, function(enabled)
    espSystem.Settings.Tracers = enabled
end)

CreateToggle(espTab, "👥 Team Check", true, function(enabled)
    espSystem.Settings.TeamCheck = enabled
end)

CreateSlider(espTab, "📏 Distância Máx", 500, 5000, 2500, function(value)
    espSystem.Settings.MaxDistance = value
end)

-- 🏃 ABA MOVIMENTO
local moveTab = createTab("Move", "🏃")

CreateSlider(moveTab, "🚀 Velocidade", 1, 1000, 16, function(value)
    movementSystem.SetWalkSpeed(value)
end)

CreateSlider(moveTab, "🦘 Pulo", 1, 1000, 50, function(value)
    movementSystem.SetJumpPower(value)
end)

CreateToggle(moveTab, "👻 Noclip", false, function(enabled)
    movementSystem.ToggleNoclip(enabled)
end)

CreateToggle(moveTab, "✈️ Fly", false, function(enabled)
    movementSystem.ToggleFly(enabled)
end)

CreateButton(moveTab, "⚡ Velocidade Extrema", function()
    movementSystem.SetWalkSpeed(500)
    movementSystem.SetJumpPower(500)
end)

CreateButton(moveTab, "🔄 Reset", function()
    movementSystem.SetWalkSpeed(16)
    movementSystem.SetJumpPower(50)
    movementSystem.ToggleFly(false)
    movementSystem.ToggleNoclip(false)
end)

-- 👤 ABA JOGADOR
local playerTab = createTab("Player", "👤")

CreateButton(playerTab, "💖 Vida Infinita", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.MaxHealth = math.huge
        LocalPlayer.Character.Humanoid.Health = math.huge
    end
end)

CreateButton(playerTab, "🔄 Reset Personagem", function()
    if LocalPlayer.Character then
        LocalPlayer.Character:BreakJoints()
    end
end)

CreateButton(playerTab, "🏠 Teleport Spawn", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
    end
end)

CreateToggle(playerTab, "👻 Invisibilidade", false, function(enabled)
    if LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Transparency = enabled and 1 or 0
            end
            if part:IsA("Accessory") then
                part.Handle.Transparency = enabled and 1 or 0
            end
            if part:IsA("Part") or part:IsA("MeshPart") then
                if part.Name:match("Arm$") or part.Name:match("Leg$") or part.Name:match("Torso$") or part.Name == "Head" then
                    part.Transparency = enabled and 1 or 0
                end
            end
        end
        if LocalPlayer.Character:FindFirstChild("Head") and LocalPlayer.Character.Head:FindFirstChild("face") then
            LocalPlayer.Character.Head.face.Transparency = enabled and 1 or 0
        end
    end
end)

-- 🌍 ABA MUNDO
local worldTab = createTab("World", "🌍")

CreateSlider(worldTab, "☀️ Brilho", 0, 20, 1, function(value)
    Lighting.Brightness = value
end)

CreateSlider(worldTab, "🌅 Hora do Dia", 0, 24, 12, function(value)
    Lighting.TimeOfDay = string.format("%02d:00:00", value)
end)

CreateToggle(worldTab, "✨ Remover Névoa", false, function(enabled)
    if enabled then
        Lighting.FogEnd = 1000000
        Lighting.FogStart = 0
    else
        Lighting.FogEnd = 1000
        Lighting.FogStart = 0
    end
end)

CreateButton(worldTab, "🌙 Modo Noite", function()
    Lighting.Brightness = 0
    Lighting.TimeOfDay = "00:00:00"
end)

CreateButton(worldTab, "☀️ Modo Dia", function()
    Lighting.Brightness = 2
    Lighting.TimeOfDay = "12:00:00"
end)

CreateButton(worldTab, "🌈 Modo Colorido", function()
    Lighting.Brightness = 5
    Lighting.Ambient = Color3.fromRGB(200, 50, 255)
    Lighting.ColorShift_Top = Color3.fromRGB(0, 255, 255)
    Lighting.ColorShift_Bottom = Color3.fromRGB(255, 0, 255)
end)

-- ⚙️ ABA CONFIGURAÇÕES
local settingsTab = createTab("Settings", "⚙️")

CreateButton(settingsTab, "🔄 Recarregar Hub", function()
    interface.ScreenGui:Destroy()
    aimbotSystem.Toggle(false)
    espSystem.Toggle(false)
    wait(0.5)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Yuzure-sudo/THEUS-HUB/main/Wirtz.lua"))()
end)

CreateButton(settingsTab, "💾 Salvar Configurações (WIP)", function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "💾 WixT Hub";
        Text = "Funcionalidade em desenvolvimento!";
        Duration = 3;
    })
end)

CreateButton(settingsTab, "📋 Copiar Discord", function()
    setclipboard("https://discord.gg/wixt")
    game.StarterGui:SetCore("SendNotification", {
        Title = "📋 WixT Hub";
        Text = "Discord copiado!";
        Duration = 3;
    })
end)

-- 🚀 INICIALIZAÇÃO E ANIMAÇÃO
local isInterfaceVisible = true

TweenService:Create(
    interface.MainFrame,
    TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    {
        Size = UDim2.new(0, 380, 0, 650),
        Position = UDim2.new(0.5, -190, 0.5, -325),
    }
):Play()

TweenService:Create(interface.BackgroundDim, TweenInfo.new(0.5), {
    BackgroundTransparency = 0.6
}):Play()

aimbotSystem.Toggle(true)
espSystem.Toggle(true)

-- 🎵 SOM DE CARREGAMENTO
wait(1)
local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://131961136"
sound.Volume = 0.5
sound.Parent = SoundService
sound:Play()

sound.Ended:Connect(function()
    sound:Destroy()
end)

-- 🎉 NOTIFICAÇÃO DE CARREGAMENTO
game.StarterGui:SetCore("SendNotification", {
    Title = "🔥 WixT Hub Ultimate";
    Text = "Carregado com sucesso! Mobile Perfect Edition v2.0";
    Duration = 8;
})

print("🔥 WixT Hub Ultimate - Mobile Perfect Edition v2.0 carregado com sucesso!")

-- Retorna os sistemas para controle externo se necessário
return {
    ControlInterface = function(visible) ToggleInterface(visible) end,
    Aimbot = aimbotSystem,
    ESP = espSystem,
    Movement = movementSystem
}