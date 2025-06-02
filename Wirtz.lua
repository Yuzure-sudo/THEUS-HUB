-- ═══════════════════════════════════════════════════════════════════════════════
-- 🚀 WIXT HUB - MOBILE PERFEITO COM AIMBOT INSANO
-- ═══════════════════════════════════════════════════════════════════════════════

-- 🛡️ LIMPEZA TOTAL
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v.Name:find("Wixt") or v.Name:find("WixT") then
        v:Destroy()
    end
end

-- 🎨 CONFIGURAÇÕES PERFEITAS
local Config = {
    Theme = {
        Primary = Color3.fromRGB(255, 64, 129),
        Secondary = Color3.fromRGB(156, 39, 176),
        Success = Color3.fromRGB(76, 175, 80),
        Warning = Color3.fromRGB(255, 152, 0),
        Error = Color3.fromRGB(244, 67, 54),
        Dark = Color3.fromRGB(18, 18, 18),
        Background = Color3.fromRGB(33, 33, 33),
        Surface = Color3.fromRGB(48, 48, 48),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(158, 158, 158)
    }
}

-- 📱 CRIAÇÃO DA INTERFACE MOBILE PERFEITA
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WixtHubPerfect"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- 🎭 FRAME PRINCIPAL MOBILE
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 600)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -300)
MainFrame.BackgroundColor3 = Config.Theme.Dark
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- 🔥 BORDAS MODERNAS
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 20)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Config.Theme.Primary
MainStroke.Thickness = 3
MainStroke.Parent = MainFrame

-- ⭐ HEADER PERFEITO
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 70)
Header.Position = UDim2.new(0, 0, 0, 0)
Header.BackgroundColor3 = Config.Theme.Primary
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 20)
HeaderCorner.Parent = Header

-- Fix para não cortar embaixo
local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0, 35)
HeaderFix.Position = UDim2.new(0, 0, 0.5, 0)
HeaderFix.BackgroundColor3 = Config.Theme.Primary
HeaderFix.BorderSizePixel = 0
HeaderFix.Parent = Header

-- 🔥 TÍTULO ESTILOSO
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🔥 WixT Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 24
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamBold
Title.Parent = Header

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(0.7, 0, 0.4, 0)
Subtitle.Position = UDim2.new(0, 20, 0.6, 0)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Mobile Perfect"
Subtitle.TextColor3 = Color3.fromRGB(255, 255, 255)
Subtitle.TextSize = 14
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextTransparency = 0.7
Subtitle.Parent = Header

-- ❌ BOTÃO FECHAR ESTILOSO
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 50, 0, 50)
CloseButton.Position = UDim2.new(1, -60, 0, 10)
CloseButton.BackgroundColor3 = Config.Theme.Error
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 20
CloseButton.Font = Enum.Font.GothamBold
CloseButton.BorderSizePixel = 0
CloseButton.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 25)
CloseCorner.Parent = CloseButton

-- 📱 CONTAINER PRINCIPAL
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -20, 1, -90)
Container.Position = UDim2.new(0, 10, 0, 80)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

-- 📋 SISTEMA DE ABAS MOBILE PERFEITO
local TabsContainer = Instance.new("Frame")
TabsContainer.Size = UDim2.new(1, 0, 0, 60)
TabsContainer.Position = UDim2.new(0, 0, 0, 0)
TabsContainer.BackgroundColor3 = Config.Theme.Background
TabsContainer.BorderSizePixel = 0
TabsContainer.Parent = Container

local TabsCorner = Instance.new("UICorner")
TabsCorner.CornerRadius = UDim.new(0, 15)
TabsCorner.Parent = TabsContainer

local TabsLayout = Instance.new("UIListLayout")
TabsLayout.FillDirection = Enum.FillDirection.Horizontal
TabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabsLayout.Padding = UDim.new(0, 5)
TabsLayout.Parent = TabsContainer

local TabsPadding = Instance.new("UIPadding")
TabsPadding.PaddingAll = UDim.new(0, 10)
TabsPadding.Parent = TabsContainer

-- 📋 ÁREA DE CONTEÚDO PERFEITA
local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, 0, 1, -70)
ContentContainer.Position = UDim2.new(0, 0, 0, 70)
ContentContainer.BackgroundColor3 = Config.Theme.Background
ContentContainer.BorderSizePixel = 0
ContentContainer.Parent = Container

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 15)
ContentCorner.Parent = ContentContainer

-- 🎯 SISTEMA DE ABAS FUNCIONAL
local tabs = {}
local currentTab = nil

local function CreateTab(name, icon)
    local tabIndex = #tabs + 1
    
    -- Botão da Aba
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(0, 60, 1, 0)
    TabButton.BackgroundColor3 = Config.Theme.Surface
    TabButton.Text = icon
    TabButton.TextColor3 = Config.Theme.TextSecondary
    TabButton.TextSize = 20
    TabButton.Font = Enum.Font.GothamBold
    TabButton.BorderSizePixel = 0
    TabButton.LayoutOrder = tabIndex
    TabButton.Parent = TabsContainer
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 12)
    TabCorner.Parent = TabButton
    
    -- Conteúdo da Aba
    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Name = name .. "Content"
    ContentFrame.Size = UDim2.new(1, -20, 1, -20)
    ContentFrame.Position = UDim2.new(0, 10, 0, 10)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.ScrollBarThickness = 8
    ContentFrame.ScrollBarImageColor3 = Config.Theme.Primary
    ContentFrame.BorderSizePixel = 0
    ContentFrame.Visible = false
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentFrame.Parent = ContentContainer
    
    -- Layout
    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 15)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Parent = ContentFrame
    
    -- Auto-resize
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ContentFrame.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 30)
    end)
    
    local function SelectTab()
        -- Desativar todas
        for _, tab in pairs(tabs) do
            tab.Button.BackgroundColor3 = Config.Theme.Surface
            tab.Button.TextColor3 = Config.Theme.TextSecondary
            tab.Content.Visible = false
        end
        
        -- Ativar esta
        TabButton.BackgroundColor3 = Config.Theme.Primary
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        ContentFrame.Visible = true
        currentTab = ContentFrame
    end
    
    TabButton.MouseButton1Click:Connect(SelectTab)
    
    table.insert(tabs, {
        Name = name,
        Button = TabButton,
        Content = ContentFrame
    })
    
    -- Ativar primeira aba
    if tabIndex == 1 then
        SelectTab()
    end
    
    return ContentFrame
end

-- 🎮 ELEMENTOS UI PERFEITOS
local function CreateButton(parent, text, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 55)
    Button.BackgroundColor3 = Config.Theme.Primary
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 18
    Button.Font = Enum.Font.GothamBold
    Button.BorderSizePixel = 0
    Button.Parent = parent
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 15)
    Corner.Parent = Button
    
    -- Efeito visual
    Button.MouseButton1Down:Connect(function()
        Button.BackgroundColor3 = Config.Theme.Secondary
        Button.Size = UDim2.new(1, 0, 0, 50)
    end)
    
    Button.MouseButton1Up:Connect(function()
        Button.BackgroundColor3 = Config.Theme.Primary
        Button.Size = UDim2.new(1, 0, 0, 55)
    end)
    
    if callback then
        Button.MouseButton1Click:Connect(callback)
    end
    
    return Button
end

local function CreateToggle(parent, text, defaultValue, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 65)
    ToggleFrame.BackgroundColor3 = Config.Theme.Surface
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = parent
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 15)
    Corner.Parent = ToggleFrame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 1, 0)
    Label.Position = UDim2.new(0, 20, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Config.Theme.Text
    Label.TextSize = 16
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.Gotham
    Label.Parent = ToggleFrame
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 90, 0, 45)
    ToggleButton.Position = UDim2.new(1, -100, 0.5, -22.5)
    ToggleButton.BackgroundColor3 = defaultValue and Config.Theme.Success or Config.Theme.Error
    ToggleButton.Text = defaultValue and "ON" or "OFF"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextSize = 16
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Parent = ToggleFrame
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 22.5)
    ToggleCorner.Parent = ToggleButton
    
    local isEnabled = defaultValue
    
    ToggleButton.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        ToggleButton.BackgroundColor3 = isEnabled and Config.Theme.Success or Config.Theme.Error
        ToggleButton.Text = isEnabled and "ON" or "OFF"
        
        -- Animação
        local TweenService = game:GetService("TweenService")
        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
            Size = UDim2.new(0, 85, 0, 40)
        }):Play()
        wait(0.1)
        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
            Size = UDim2.new(0, 90, 0, 45)
        }):Play()
        
        if callback then
            callback(isEnabled)
        end
    end)
    
    return ToggleFrame
end

local function CreateSlider(parent, text, min, max, defaultValue, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, 0, 0, 85)
    SliderFrame.BackgroundColor3 = Config.Theme.Surface
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Parent = parent
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 15)
    Corner.Parent = SliderFrame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 0, 35)
    Label.Position = UDim2.new(0, 20, 0, 10)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Config.Theme.Text
    Label.TextSize = 16
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.Gotham
    Label.Parent = SliderFrame
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0.4, 0, 0, 35)
    ValueLabel.Position = UDim2.new(0.6, 0, 0, 10)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(defaultValue)
    ValueLabel.TextColor3 = Config.Theme.Primary
    ValueLabel.TextSize = 18
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.Parent = SliderFrame
    
    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(1, -40, 0, 15)
    SliderBar.Position = UDim2.new(0, 20, 1, -30)
    SliderBar.BackgroundColor3 = Config.Theme.Dark
    SliderBar.BorderSizePixel = 0
    SliderBar.Parent = SliderFrame
    
    local SliderBarCorner = Instance.new("UICorner")
    SliderBarCorner.CornerRadius = UDim.new(0, 7.5)
    SliderBarCorner.Parent = SliderBar
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((defaultValue - min) / (max - min), 0, 1, 0)
    SliderFill.Position = UDim2.new(0, 0, 0, 0)
    SliderFill.BackgroundColor3 = Config.Theme.Primary
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBar
    
    local SliderFillCorner = Instance.new("UICorner")
    SliderFillCorner.CornerRadius = UDim.new(0, 7.5)
    SliderFillCorner.Parent = SliderFill
    
    local SliderButton = Instance.new("TextButton")
    SliderButton.Size = UDim2.new(0, 25, 0, 25)
    SliderButton.Position = UDim2.new((defaultValue - min) / (max - min), -12.5, 0.5, -12.5)
    SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderButton.Text = ""
    SliderButton.BorderSizePixel = 0
    SliderButton.Parent = SliderBar
    
    local SliderButtonCorner = Instance.new("UICorner")
    SliderButtonCorner.CornerRadius = UDim.new(0, 12.5)
    SliderButtonCorner.Parent = SliderButton
    
    local dragging = false
    
    SliderButton.MouseButton1Down:Connect(function()
        dragging = true
        SliderButton.BackgroundColor3 = Config.Theme.Primary
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local mouse = game.Players.LocalPlayer:GetMouse()
            local relativeX = math.clamp((mouse.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + (max - min) * relativeX)
            
            SliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
            SliderButton.Position = UDim2.new(relativeX, -12.5, 0.5, -12.5)
            ValueLabel.Text = tostring(value)
            
            if callback then
                callback(value)
            end
        end
    end)
    
    return SliderFrame
end

-- 🔫 AIMBOT INSANO MOBILE
local AimbotSettings = {
    Enabled = false,
    TeamCheck = true,
    WallCheck = true,
    TargetPart = "Head",
    Smoothness = 0.15,
    FOV = 150,
    MaxDistance = 2500,
    PredictMovement = true,
    AutoShoot = false,
    SilentAim = false
}

local function CreateInsaneAimbot()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local Camera = workspace.CurrentCamera
    local LocalPlayer = Players.LocalPlayer
    
    -- FOV Circle
    local FOVCircle = Drawing.new("Circle")
    FOVCircle.Thickness = 3
    FOVCircle.Color = Color3.fromRGB(255, 64, 129)
    FOVCircle.Filled = false
    FOVCircle.Radius = AimbotSettings.FOV
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Visible = false
    
    -- Target Indicator
    local TargetIndicator = Drawing.new("Circle")
    TargetIndicator.Thickness = 4
    TargetIndicator.Color = Color3.fromRGB(255, 0, 0)
    TargetIndicator.Filled = false
    TargetIndicator.Radius = 20
    TargetIndicator.Visible = false
    
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
                local targetPart = character[AimbotSettings.TargetPart]
                local targetPosition = targetPart.Position
                
                -- Predição de movimento avançada
                if AimbotSettings.PredictMovement and character:FindFirstChild("HumanoidRootPart") then
                    local velocity = character.HumanoidRootPart.Velocity
                    local distance = (LocalPlayer.Character.HumanoidRootPart.Position - targetPosition).Magnitude
                    local timeToTarget = distance / 2000 -- Velocidade do projétil
                    targetPosition = targetPosition + (velocity * timeToTarget * 0.8)
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
                            
                            local raycastResult = workspace:Raycast(Camera.CFrame.Position, (targetPosition - Camera.CFrame.Position).Unit * distance3D, raycastParams)
                            
                            if raycastResult and raycastResult.Instance:IsDescendantOf(character) then
                                closestPlayer = player
                                closestDistance = distance2D
                            elseif not raycastResult then
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
    
    -- Detecção de input mobile/PC
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
        
        if enabled then
            aimbotConnection = RunService.Heartbeat:Connect(function()
                -- Atualizar FOV Circle
                FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                FOVCircle.Radius = AimbotSettings.FOV
                
                if isAiming or AimbotSettings.AutoShoot then
                    local target = GetClosestPlayer()
                    if target and target.Character and target.Character:FindFirstChild(AimbotSettings.TargetPart) then
                        currentTarget = target
                        local targetPart = target.Character[AimbotSettings.TargetPart]
                        local targetPosition = targetPart.Position
                        
                        -- Predição melhorada
                        if AimbotSettings.PredictMovement and target.Character:FindFirstChild("HumanoidRootPart") then
                            local velocity = target.Character.HumanoidRootPart.Velocity
                            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - targetPosition).Magnitude
                            local timeToTarget = distance / 2000
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
                        if AimbotSettings.AutoShoot then
                            mouse1click()
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
        end
    end
    
    return {
        Toggle = ToggleAimbot,
        Settings = AimbotSettings,
        FOVCircle = FOVCircle,
        TargetIndicator = TargetIndicator
    }
end

-- 👁️ ESP PERFEITO
local ESPSettings = {
    Enabled = false,
    Names = true,
    Health = true,
    Distance = true,
    Boxes = true,
    TeamCheck = true,
    MaxDistance = 2000
}

local function CreatePerfectESP()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer
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
        esp.box.Color = Color3.fromRGB(255, 64, 129)
        esp.box.Thickness = 2
        esp.box.Filled = false
        esp.box.Visible = false
        
        esp.healthBar = Drawing.new("Square")
        esp.healthBar.Color = Color3.fromRGB(0, 255, 0)
        esp.healthBar.Thickness = 0
        esp.healthBar.Filled = true
        esp.healthBar.Visible = false
        
        return esp
    end
    
    local function UpdateESP()
        for player, esp in pairs(espObjects) do
            if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                if ESPSettings.TeamCheck and player.Team == LocalPlayer.Team then
                    esp.nameLabel.Visible = false
                    esp.healthLabel.Visible = false
                    esp.distanceLabel.Visible = false
                    esp.box.Visible = false
                    esp.healthBar.Visible = false
                    continue
                end
                
                local character = player.Character
                local rootPart = character.HumanoidRootPart
                local humanoid = character:FindFirstChild("Humanoid")
                
                local distance = (LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position)
                
                if onScreen and distance <= ESPSettings.MaxDistance and ESPSettings.Enabled then
                    -- Nomes
                    if ESPSettings.Names then
                        esp.nameLabel.Position = Vector2.new(screenPos.X, screenPos.Y - 60)
                        esp.nameLabel.Text = player.Name
                        esp.nameLabel.Visible = true
                    else
                        esp.nameLabel.Visible = false
                    end
                    
                    -- Vida
                    if ESPSettings.Health and humanoid then
                        esp.healthLabel.Position = Vector2.new(screenPos.X, screenPos.Y - 40)
                        esp.healthLabel.Text = math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
                        esp.healthLabel.Color = Color3.fromRGB(
                            255 - (humanoid.Health / humanoid.MaxHealth) * 255,
                            (humanoid.Health / humanoid.MaxHealth) * 255,
                            0
                        )
                        esp.healthLabel.Visible = true
                    else
                        esp.healthLabel.Visible = false
                    end
                    
                    -- Distância
                    if ESPSettings.Distance then
                        esp.distanceLabel.Position = Vector2.new(screenPos.X, screenPos.Y + 40)
                        esp.distanceLabel.Text = math.floor(distance) .. "m"
                        esp.distanceLabel.Visible = true
                    else
                        esp.distanceLabel.Visible = false
                    end
                    
                    -- Boxes
                    if ESPSettings.Boxes and character:FindFirstChild("Head") then
                        local headPos = workspace.CurrentCamera:WorldToViewportPoint(character.Head.Position + Vector3.new(0, 0.5, 0))
                        local legPos = workspace.CurrentCamera:WorldToViewportPoint(character.HumanoidRootPart.Position - Vector3.new(0, 3, 0))
                        
                        local boxHeight = math.abs(headPos.Y - legPos.Y)
                        local boxWidth = boxHeight * 0.6
                        
                        esp.box.Size = Vector2.new(boxWidth, boxHeight)
                        esp.box.Position = Vector2.new(screenPos.X - boxWidth/2, headPos.Y)
                        esp.box.Visible = true
                        
                        -- Health Bar
                        if humanoid then
                            local healthPercent = humanoid.Health / humanoid.MaxHealth
                            esp.healthBar.Size = Vector2.new(4, boxHeight * healthPercent)
                            esp.healthBar.Position = Vector2.new(screenPos.X - boxWidth/2 - 8, headPos.Y + boxHeight - (boxHeight * healthPercent))
                            esp.healthBar.Color = Color3.fromRGB(
                                255 - healthPercent * 255,
                                healthPercent * 255,
                                0
                            )
                            esp.healthBar.Visible = true
                        end
                    else
                        esp.box.Visible = false
                        esp.healthBar.Visible = false
                    end
                else
                    esp.nameLabel.Visible = false
                    esp.healthLabel.Visible = false
                    esp.distanceLabel.Visible = false
                    esp.box.Visible = false
                    esp.healthBar.Visible = false
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
                object:Remove()
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
            end
            
            for _, esp in pairs(espObjects) do
                esp.nameLabel.Visible = false
                esp.healthLabel.Visible = false
                esp.distanceLabel.Visible = false
                esp.box.Visible = false
                esp.healthBar.Visible = false
            end
        end
    end
    
    return {
        Toggle = ToggleESP,
        Settings = ESPSettings
    }
end

-- 🏃 MOVIMENTO PERFEITO
local function CreatePerfectMovement()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
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
    
    return {
        SetWalkSpeed = SetWalkSpeed,
        SetJumpPower = SetJumpPower
    }
end

-- 🚀 INICIALIZAÇÃO
local aimbotSystem = CreateInsaneAimbot()
local espSystem = CreatePerfectESP()
local movementSystem = CreatePerfectMovement()

-- 🎯 ABA AIMBOT
local aimbotTab = CreateTab("Aimbot", "🎯")

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

CreateSlider(aimbotTab, "🎯 FOV", 30, 300, 150, function(value)
    aimbotSystem.Settings.FOV = value
end)

CreateSlider(aimbotTab, "⚡ Suavidade", 1, 100, 15, function(value)
    aimbotSystem.Settings.Smoothness = value / 100
end)

CreateButton(aimbotTab, "🎯 Cabeça", function()
    aimbotSystem.Settings.TargetPart = "Head"
end)

CreateButton(aimbotTab, "🫀 Torso", function()
    aimbotSystem.Settings.TargetPart = "Torso"
end)

-- 👁️ ABA ESP
local espTab = CreateTab("ESP", "👁️")

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

CreateToggle(espTab, "👥 Team Check", true, function(enabled)
    espSystem.Settings.TeamCheck = enabled
end)

CreateSlider(espTab, "📏 Distância Máx", 500, 3000, 2000, function(value)
    espSystem.Settings.MaxDistance = value
end)

-- 🏃 ABA MOVIMENTO
local moveTab = CreateTab("Move", "🏃")

CreateSlider(moveTab, "🚀 Velocidade", 1, 500, 16, function(value)
    movementSystem.SetWalkSpeed(value)
end)

CreateSlider(moveTab, "🦘 Pulo", 1, 500, 50, function(value)
    movementSystem.SetJumpPower(value)
end)

CreateButton(moveTab, "⚡ Velocidade Extrema", function()
    movementSystem.SetWalkSpeed(300)
    movementSystem.SetJumpPower(300)
end)

CreateButton(moveTab, "🔄 Reset", function()
    movementSystem.SetWalkSpeed(16)
    movementSystem.SetJumpPower(50)
end)

-- 👤 ABA JOGADOR
local playerTab = CreateTab("Player", "👤")

CreateButton(playerTab, "💖 Vida Infinita", function()
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.MaxHealth = math.huge
        player.Character.Humanoid.Health = math.huge
    end
end)

CreateButton(playerTab, "🔄 Reset", function()
    local player = game.Players.LocalPlayer
    if player.Character then
        player.Character:BreakJoints()
    end
end)

CreateButton(playerTab, "🏠 Spawn", function()
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
    end
end)

-- 🌍 ABA MUNDO
local worldTab = CreateTab("World", "🌍")

CreateSlider(worldTab, "☀️ Brilho", 0, 10, 1, function(value)
    game.Lighting.Brightness = value
end)

CreateSlider(worldTab, "🌅 Hora", 0, 24, 12, function(value)
    game.Lighting.TimeOfDay = string.format("%02d:00:00", value)
end)

CreateButton(worldTab, "🌙 Noite", function()
    game.Lighting.Brightness = 0
    game.Lighting.TimeOfDay = "00:00:00"
end)

CreateButton(worldTab, "☀️ Dia", function()
    game.Lighting.Brightness = 2
    game.Lighting.TimeOfDay = "12:00:00"
end)

-- 🎉 ANIMAÇÃO DE ENTRADA ÉPICA
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

local TweenService = game:GetService("TweenService")
TweenService:Create(
    MainFrame,
    TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    {
        Size = UDim2.new(0, 350, 0, 600),
        Position = UDim2.new(0.5, -175, 0.5, -300)
    }
):Play()

-- 🔄 BOTÃO FECHAR
CloseButton.MouseButton1Click:Connect(function()
    TweenService:Create(
        MainFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In),
        {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }
    ):Play()
    
    wait(0.5)
    aimbotSystem.Toggle(false)
    espSystem.Toggle(false)
    ScreenGui:Destroy()
end)

-- 🎉 NOTIFICAÇÃO ÉPICA
game.StarterGui:SetCore("SendNotification", {
    Title = "🔥 WixT Hub";
    Text = "Hub carregado com sucesso! Mobile Perfect Edition";
    Duration = 5;
})

print("🔥 WixT Hub - Mobile Perfect Edition carregado!")