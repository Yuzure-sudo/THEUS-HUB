-- ═══════════════════════════════════════════════════════════════════════════════
-- 🚀 WIXT HUB - MOBILE ULTRA OTIMIZADO COM AIMBOT PROFISSIONAL
-- ═══════════════════════════════════════════════════════════════════════════════

local WixtHub = {}

-- 🎨 CONFIGURAÇÕES MOBILE
local Config = {
    Name = "🔥 WixT Hub",
    Theme = {
        Primary = Color3.fromRGB(0, 162, 255),
        Secondary = Color3.fromRGB(138, 43, 226),
        Success = Color3.fromRGB(34, 197, 94),
        Warning = Color3.fromRGB(251, 146, 60),
        Error = Color3.fromRGB(239, 68, 68),
        Dark = Color3.fromRGB(17, 24, 39),
        Background = Color3.fromRGB(31, 41, 55),
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(156, 163, 175)
    }
}

-- 🛡️ PROTEÇÕES
local function AntiDetection()
    for _, v in pairs(game.CoreGui:GetChildren()) do
        if v.Name:find("Wixt") or v.Name:find("WixT") then
            v:Destroy()
        end
    end
end

-- 📱 INTERFACE MOBILE ULTRA OTIMIZADA
local function CreateMobileInterface()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "WixtHubMobile"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    -- 🎭 FRAME PRINCIPAL MOBILE
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 320, 0, 480) -- Tamanho perfeito para mobile
    MainFrame.Position = UDim2.new(0.5, -160, 0.5, -240)
    MainFrame.BackgroundColor3 = Config.Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    
    -- 🔥 BORDAS MODERNAS
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 20)
    Corner.Parent = MainFrame
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Config.Theme.Primary
    Stroke.Thickness = 3
    Stroke.Parent = MainFrame
    
    -- ⭐ HEADER MOBILE
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 60)
    Header.Position = UDim2.new(0, 0, 0, 0)
    Header.BackgroundColor3 = Config.Theme.Dark
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 20)
    HeaderCorner.Parent = Header
    
    -- Fix para não cortar embaixo
    local HeaderFix = Instance.new("Frame")
    HeaderFix.Size = UDim2.new(1, 0, 0, 30)
    HeaderFix.Position = UDim2.new(0, 0, 0.5, 0)
    HeaderFix.BackgroundColor3 = Config.Theme.Dark
    HeaderFix.BorderSizePixel = 0
    HeaderFix.Parent = Header
    
    -- 🔥 TÍTULO
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0.7, 0, 1, 0)
    Title.Position = UDim2.new(0, 20, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "🔥 WixT Hub"
    Title.TextColor3 = Config.Theme.Text
    Title.TextSize = 22
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Font = Enum.Font.GothamBold
    Title.Parent = Header
    
    -- ❌ BOTÃO FECHAR MOBILE
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 50, 0, 40)
    CloseButton.Position = UDim2.new(1, -60, 0, 10)
    CloseButton.BackgroundColor3 = Config.Theme.Error
    CloseButton.Text = "✕"
    CloseButton.TextColor3 = Config.Theme.Text
    CloseButton.TextSize = 20
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.BorderSizePixel = 0
    CloseButton.Parent = Header
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 12)
    CloseCorner.Parent = CloseButton
    
    -- 📱 CONTAINER PRINCIPAL
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -20, 1, -80)
    Container.Position = UDim2.new(0, 10, 0, 70)
    Container.BackgroundTransparency = 1
    Container.Parent = MainFrame
    
    -- 📋 ABAS MOBILE (VERTICAL STACK)
    local TabsFrame = Instance.new("Frame")
    TabsFrame.Size = UDim2.new(1, 0, 0, 60)
    TabsFrame.Position = UDim2.new(0, 0, 0, 0)
    TabsFrame.BackgroundColor3 = Config.Theme.Dark
    TabsFrame.BorderSizePixel = 0
    TabsFrame.Parent = Container
    
    local TabsCorner = Instance.new("UICorner")
    TabsCorner.CornerRadius = UDim.new(0, 15)
    TabsCorner.Parent = TabsFrame
    
    local TabsLayout = Instance.new("UIListLayout")
    TabsLayout.FillDirection = Enum.FillDirection.Horizontal
    TabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabsLayout.Padding = UDim.new(0, 5)
    TabsLayout.Parent = TabsFrame
    
    local TabsPadding = Instance.new("UIPadding")
    TabsPadding.PaddingAll = UDim.new(0, 10)
    TabsPadding.Parent = TabsFrame
    
    -- 📋 ÁREA DE CONTEÚDO
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size = UDim2.new(1, 0, 1, -70)
    ContentFrame.Position = UDim2.new(0, 0, 0, 70)
    ContentFrame.BackgroundColor3 = Config.Theme.Dark
    ContentFrame.BorderSizePixel = 0
    ContentFrame.Parent = Container
    
    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 15)
    ContentCorner.Parent = ContentFrame
    
    return {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        Header = Header,
        TabsFrame = TabsFrame,
        ContentFrame = ContentFrame,
        CloseButton = CloseButton
    }
end

-- 🎯 SISTEMA DE ABAS MOBILE OTIMIZADO
local function CreateMobileTabSystem(interface)
    local tabs = {}
    local currentTab = nil
    
    local function CreateTab(name, icon)
        local tabIndex = #tabs + 1
        
        -- Botão da Aba
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(0, 50, 1, 0)
        TabButton.BackgroundColor3 = Config.Theme.Background
        TabButton.Text = icon
        TabButton.TextColor3 = Config.Theme.TextDim
        TabButton.TextSize = 18
        TabButton.Font = Enum.Font.GothamBold
        TabButton.BorderSizePixel = 0
        TabButton.LayoutOrder = tabIndex
        TabButton.Parent = interface.TabsFrame
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 12)
        TabCorner.Parent = TabButton
        
        -- Conteúdo da Aba
        local ContentScroll = Instance.new("ScrollingFrame")
        ContentScroll.Name = name .. "Content"
        ContentScroll.Size = UDim2.new(1, -20, 1, -20)
        ContentScroll.Position = UDim2.new(0, 10, 0, 10)
        ContentScroll.BackgroundTransparency = 1
        ContentScroll.ScrollBarThickness = 8
        ContentScroll.ScrollBarImageColor3 = Config.Theme.Primary
        ContentScroll.BorderSizePixel = 0
        ContentScroll.Visible = false
        ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        ContentScroll.Parent = interface.ContentFrame
        
        -- Layout
        local Layout = Instance.new("UIListLayout")
        Layout.Padding = UDim.new(0, 15)
        Layout.SortOrder = Enum.SortOrder.LayoutOrder
        Layout.Parent = ContentScroll
        
        -- Auto-resize
        Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            ContentScroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 30)
        end)
        
        local function SelectTab()
            -- Desativar todas
            for _, tab in pairs(tabs) do
                tab.Button.BackgroundColor3 = Config.Theme.Background
                tab.Button.TextColor3 = Config.Theme.TextDim
                tab.Content.Visible = false
            end
            
            -- Ativar esta
            TabButton.BackgroundColor3 = Config.Theme.Primary
            TabButton.TextColor3 = Config.Theme.Text
            ContentScroll.Visible = true
            currentTab = ContentScroll
        end
        
        TabButton.MouseButton1Click:Connect(SelectTab)
        
        table.insert(tabs, {
            Name = name,
            Button = TabButton,
            Content = ContentScroll
        })
        
        -- Ativar primeira aba
        if tabIndex == 1 then
            SelectTab()
        end
        
        return ContentScroll
    end
    
    return CreateTab
end

-- 🎮 ELEMENTOS UI MOBILE OTIMIZADOS
local function CreateMobileButton(parent, text, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 50) -- Altura perfeita para mobile
    Button.BackgroundColor3 = Config.Theme.Primary
    Button.Text = text
    Button.TextColor3 = Config.Theme.Text
    Button.TextSize = 16
    Button.Font = Enum.Font.GothamBold
    Button.BorderSizePixel = 0
    Button.Parent = parent
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = Button
    
    -- Efeito visual
    Button.MouseButton1Down:Connect(function()
        Button.BackgroundColor3 = Config.Theme.Secondary
    end)
    
    Button.MouseButton1Up:Connect(function()
        Button.BackgroundColor3 = Config.Theme.Primary
    end)
    
    if callback then
        Button.MouseButton1Click:Connect(callback)
    end
    
    return Button
end

local function CreateMobileToggle(parent, text, defaultValue, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 60)
    ToggleFrame.BackgroundColor3 = Config.Theme.Background
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = parent
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = ToggleFrame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 1, 0)
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Config.Theme.Text
    Label.TextSize = 16
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.Gotham
    Label.Parent = ToggleFrame
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 80, 0, 40)
    ToggleButton.Position = UDim2.new(1, -90, 0.5, -20)
    ToggleButton.BackgroundColor3 = defaultValue and Config.Theme.Success or Config.Theme.Error
    ToggleButton.Text = defaultValue and "ON" or "OFF"
    ToggleButton.TextColor3 = Config.Theme.Text
    ToggleButton.TextSize = 14
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Parent = ToggleFrame
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 10)
    ToggleCorner.Parent = ToggleButton
    
    local isEnabled = defaultValue
    
    ToggleButton.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        ToggleButton.BackgroundColor3 = isEnabled and Config.Theme.Success or Config.Theme.Error
        ToggleButton.Text = isEnabled and "ON" or "OFF"
        
        if callback then
            callback(isEnabled)
        end
    end)
    
    return ToggleFrame
end

local function CreateMobileSlider(parent, text, min, max, defaultValue, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, 0, 0, 80)
    SliderFrame.BackgroundColor3 = Config.Theme.Background
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Parent = parent
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = SliderFrame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 0, 30)
    Label.Position = UDim2.new(0, 15, 0, 10)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Config.Theme.Text
    Label.TextSize = 16
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.Gotham
    Label.Parent = SliderFrame
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0.4, 0, 0, 30)
    ValueLabel.Position = UDim2.new(0.6, 0, 0, 10)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(defaultValue)
    ValueLabel.TextColor3 = Config.Theme.Primary
    ValueLabel.TextSize = 16
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.Parent = SliderFrame
    
    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(1, -30, 0, 12)
    SliderBar.Position = UDim2.new(0, 15, 1, -25)
    SliderBar.BackgroundColor3 = Config.Theme.Dark
    SliderBar.BorderSizePixel = 0
    SliderBar.Parent = SliderFrame
    
    local SliderBarCorner = Instance.new("UICorner")
    SliderBarCorner.CornerRadius = UDim.new(0, 6)
    SliderBarCorner.Parent = SliderBar
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((defaultValue - min) / (max - min), 0, 1, 0)
    SliderFill.Position = UDim2.new(0, 0, 0, 0)
    SliderFill.BackgroundColor3 = Config.Theme.Primary
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBar
    
    local SliderFillCorner = Instance.new("UICorner")
    SliderFillCorner.CornerRadius = UDim.new(0, 6)
    SliderFillCorner.Parent = SliderFill
    
    local SliderButton = Instance.new("TextButton")
    SliderButton.Size = UDim2.new(0, 24, 0, 24)
    SliderButton.Position = UDim2.new((defaultValue - min) / (max - min), -12, 0.5, -12)
    SliderButton.BackgroundColor3 = Config.Theme.Text
    SliderButton.Text = ""
    SliderButton.BorderSizePixel = 0
    SliderButton.Parent = SliderBar
    
    local SliderButtonCorner = Instance.new("UICorner")
    SliderButtonCorner.CornerRadius = UDim.new(0, 12)
    SliderButtonCorner.Parent = SliderButton
    
    local dragging = false
    
    SliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local mouse = game.Players.LocalPlayer:GetMouse()
            local relativeX = math.clamp((mouse.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + (max - min) * relativeX)
            
            SliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
            SliderButton.Position = UDim2.new(relativeX, -12, 0.5, -12)
            ValueLabel.Text = tostring(value)
            
            if callback then
                callback(value)
            end
        end
    end)
    
    return SliderFrame
end

-- 🔫 AIMBOT PROFISSIONAL MOBILE
local AimbotSettings = {
    Enabled = false,
    TeamCheck = true,
    WallCheck = true,
    TargetPart = "Head",
    Smoothness = 0.2,
    FOV = 120,
    MaxDistance = 2000,
    PredictMovement = true,
    AutoShoot = false
}

local function CreateProfessionalAimbot()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local Camera = workspace.CurrentCamera
    local LocalPlayer = Players.LocalPlayer
    
    local FOVCircle = Drawing.new("Circle")
    FOVCircle.Thickness = 2
    FOVCircle.Color = Color3.fromRGB(0, 162, 255)
    FOVCircle.Filled = false
    FOVCircle.Radius = AimbotSettings.FOV
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Visible = true
    
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
                
                -- Predição de movimento
                if AimbotSettings.PredictMovement and character:FindFirstChild("HumanoidRootPart") then
                    local velocity = character.HumanoidRootPart.Velocity
                    local distance = (LocalPlayer.Character.HumanoidRootPart.Position - targetPosition).Magnitude
                    local timeToTarget = distance / 1000 -- Velocidade estimada do projétil
                    targetPosition = targetPosition + (velocity * timeToTarget)
                end
                
                local screenPoint, onScreen = Camera:WorldToViewportPoint(targetPosition)
                
                if onScreen then
                    local distance2D = (Vector2.new(screenPoint.X, screenPoint.Y) - centerScreen).Magnitude
                    local distance3D = (LocalPlayer.Character.HumanoidRootPart.Position - targetPosition).Magnitude
                    
                    if distance2D < AimbotSettings.FOV and distance3D < AimbotSettings.MaxDistance and distance2D < closestDistance then
                        -- Wall Check
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
    
    -- Detecção de toque/clique para mobile
    UserInputService.TouchStarted:Connect(function(touch, gameProcessed)
        if not gameProcessed and AimbotSettings.Enabled then
            isAiming = true
        end
    end)
    
    UserInputService.TouchEnded:Connect(function(touch, gameProcessed)
        isAiming = false
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
                        local targetPart = target.Character[AimbotSettings.TargetPart]
                        local targetPosition = targetPart.Position
                        
                        -- Predição de movimento melhorada
                        if AimbotSettings.PredictMovement and target.Character:FindFirstChild("HumanoidRootPart") then
                            local velocity = target.Character.HumanoidRootPart.Velocity
                            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - targetPosition).Magnitude
                            local timeToTarget = distance / 1500
                            targetPosition = targetPosition + (velocity * timeToTarget)
                        end
                        
                        local cameraDirection = (targetPosition - Camera.CFrame.Position).Unit
                        local newCFrame = CFrame.lookAt(Camera.CFrame.Position, Camera.CFrame.Position + cameraDirection)
                        
                        -- Suavização melhorada
                        Camera.CFrame = Camera.CFrame:Lerp(newCFrame, AimbotSettings.Smoothness)
                        
                        -- Auto Shoot (se habilitado)
                        if AimbotSettings.AutoShoot then
                            mouse1click()
                        end
                    end
                end
            end)
        else
            if aimbotConnection then
                aimbotConnection:Disconnect()
            end
        end
    end
    
    return {
        Toggle = ToggleAimbot,
        Settings = AimbotSettings,
        FOVCircle = FOVCircle
    }
end

-- 👁️ ESP OTIMIZADO MOBILE
local ESPSettings = {
    Enabled = false,
    Names = true,
    Health = true,
    Distance = true,
    TeamCheck = true,
    MaxDistance = 1500
}

local function CreateOptimizedESP()
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
        esp.box.Color = Color3.fromRGB(0, 162, 255)
        esp.box.Thickness = 2
        esp.box.Filled = false
        esp.box.Visible = false
        
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
                        esp.nameLabel.Position = Vector2.new(screenPos.X, screenPos.Y - 50)
                        esp.nameLabel.Text = player.Name
                        esp.nameLabel.Visible = true
                    else
                        esp.nameLabel.Visible = false
                    end
                    
                    -- Vida
                    if ESPSettings.Health and humanoid then
                        esp.healthLabel.Position = Vector2.new(screenPos.X, screenPos.Y - 30)
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
                        esp.distanceLabel.Position = Vector2.new(screenPos.X, screenPos.Y + 30)
                        esp.distanceLabel.Text = math.floor(distance) .. "m"
                        esp.distanceLabel.Visible = true
                    else
                        esp.distanceLabel.Visible = false
                    end
                    
                    -- Box
                    if character:FindFirstChild("Head") then
                        local headPos = workspace.CurrentCamera:WorldToViewportPoint(character.Head.Position + Vector3.new(0, 0.5, 0))
                        local legPos = workspace.CurrentCamera:WorldToViewportPoint(character.HumanoidRootPart.Position - Vector3.new(0, 3, 0))
                        
                        local boxHeight = math.abs(headPos.Y - legPos.Y)
                        local boxWidth = boxHeight * 0.6
                        
                        esp.box.Size = Vector2.new(boxWidth, boxHeight)
                        esp.box.Position = Vector2.new(screenPos.X - boxWidth/2, headPos.Y)
                        esp.box.Visible = true
                    end
                else
                    esp.nameLabel.Visible = false
                    esp.healthLabel.Visible = false
                    esp.distanceLabel.Visible = false
                    esp.box.Visible = false
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
            end
        end
    end
    
    return {
        Toggle = ToggleESP,
        Settings = ESPSettings
    }
end

-- 🏃 MOVIMENTO OTIMIZADO
local function CreateOptimizedMovement()
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

-- 🚀 FUNÇÃO PRINCIPAL
local function InitializeWixtHubMobile()
    AntiDetection()
    
    local interface = CreateMobileInterface()
    local createTab = CreateMobileTabSystem(interface)
    local aimbotSystem = CreateProfessionalAimbot()
    local espSystem = CreateOptimizedESP()
    local movementSystem = CreateOptimizedMovement()
    
    -- 🎯 ABA AIMBOT
    local aimbotTab = createTab("Aimbot", "🎯")
    
    CreateMobileToggle(aimbotTab, "🔥 Aimbot Ativado", false, function(enabled)
        aimbotSystem.Toggle(enabled)
    end)
    
    CreateMobileToggle(aimbotTab, "👥 Team Check", true, function(enabled)
        aimbotSystem.Settings.TeamCheck = enabled
    end)
    
    CreateMobileToggle(aimbotTab, "🧱 Wall Check", true, function(enabled)
        aimbotSystem.Settings.WallCheck = enabled
    end)
    
    CreateMobileToggle(aimbotTab, "🎯 Predição", true, function(enabled)
        aimbotSystem.Settings.PredictMovement = enabled
    end)
    
    CreateMobileSlider(aimbotTab, "🎯 FOV", 30, 300, 120, function(value)
        aimbotSystem.Settings.FOV = value
    end)
    
    CreateMobileSlider(aimbotTab, "⚡ Suavidade", 1, 100, 20, function(value)
        aimbotSystem.Settings.Smoothness = value / 100
    end)
    
    CreateMobileButton(aimbotTab, "🎯 Cabeça", function()
        aimbotSystem.Settings.TargetPart = "Head"
    end)
    
    CreateMobileButton(aimbotTab, "🫀 Torso", function()
        aimbotSystem.Settings.TargetPart = "Torso"
    end)
    
    -- 👁️ ABA ESP
    local espTab = createTab("ESP", "👁️")
    
    CreateMobileToggle(espTab, "🔥 ESP Ativado", false, function(enabled)
        espSystem.Toggle(enabled)
    end)
    
    CreateMobileToggle(espTab, "📝 Nomes", true, function(enabled)
        espSystem.Settings.Names = enabled
    end)
    
    CreateMobileToggle(espTab, "❤️ Vida", true, function(enabled)
        espSystem.Settings.Health = enabled
    end)
    
    CreateMobileToggle(espTab, "📏 Distância", true, function(enabled)
        espSystem.Settings.Distance = enabled
    end)
    
    CreateMobileToggle(espTab, "👥 Team Check", true, function(enabled)
        espSystem.Settings.TeamCheck = enabled
    end)
    
    CreateMobileSlider(espTab, "📏 Distância Máx", 500, 3000, 1500, function(value)
        espSystem.Settings.MaxDistance = value
    end)
    
    -- 🏃 ABA MOVIMENTO
    local moveTab = createTab("Move", "🏃")
    
    CreateMobileSlider(moveTab, "🚀 Velocidade", 1, 500, 16, function(value)
        movementSystem.SetWalkSpeed(value)
    end)
    
    CreateMobileSlider(moveTab, "🦘 Pulo", 1, 500, 50, function(value)
        movementSystem.SetJumpPower(value)
    end)
    
    CreateMobileButton(moveTab, "⚡ Velocidade Extrema", function()
        movementSystem.SetWalkSpeed(200)
        movementSystem.SetJumpPower(200)
    end)
    
    CreateMobileButton(moveTab, "🔄 Reset", function()
        movementSystem.SetWalkSpeed(16)
        movementSystem.SetJumpPower(50)
    end)
    
    -- 👤 ABA JOGADOR
    local playerTab = createTab("Player", "👤")
    
    CreateMobileButton(playerTab, "💖 Vida Infinita", function()
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.MaxHealth = math.huge
            player.Character.Humanoid.Health = math.huge
        end
    end)
    
    CreateMobileButton(playerTab, "🔄 Reset", function()
        local player = game.Players.LocalPlayer
        if player.Character then
            player.Character:BreakJoints()
        end
    end)
    
    CreateMobileButton(playerTab, "🏠 Spawn", function()
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
        end
    end)
    
    -- 🌍 ABA MUNDO
    local worldTab = createTab("World", "🌍")
    
    CreateMobileSlider(worldTab, "☀️ Brilho", 0, 10, 1, function(value)
        game.Lighting.Brightness = value
    end)
    
    CreateMobileSlider(worldTab, "🌅 Hora", 0, 24, 12, function(value)
        game.Lighting.TimeOfDay = string.format("%02d:00:00", value)
    end)
    
    CreateMobileButton(worldTab, "🌙 Noite", function()
        game.Lighting.Brightness = 0
        game.Lighting.TimeOfDay = "00:00:00"
    end)
    
    CreateMobileButton(worldTab, "☀️ Dia", function()
        game.Lighting.Brightness = 2
        game.Lighting.TimeOfDay = "12:00:00"
    end)
    
    -- 🎉 ANIMAÇÃO DE ENTRADA
    interface.MainFrame.Size = UDim2.new(0, 0, 0, 0)
    interface.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    local TweenService = game:GetService("TweenService")
    TweenService:Create(
        interface.MainFrame,
        TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {
            Size = UDim2.new(0, 320, 0, 480),
            Position = UDim2.new(0.5, -160, 0.5, -240)
        }
    ):Play()
    
    -- 🔄 BOTÃO FECHAR
    interface.CloseButton.MouseButton1Click:Connect(function()
        TweenService:Create(
            interface.MainFrame,
            TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In),
            {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0)
            }
        ):Play()
        
        wait(0.5)
        aimbotSystem.Toggle(false)
        espSystem.Toggle(false)
        interface.ScreenGui:Destroy()
    end)
    
    -- 🎉 NOTIFICAÇÃO
    game.StarterGui:SetCore("SendNotification", {
        Title = "🔥 WixT Hub";
        Text = "Hub carregado! Mobile Optimized";
        Duration = 5;
    })
    
    return interface
end

-- 🚀 EXECUTAR
return InitializeWixtHubMobile()