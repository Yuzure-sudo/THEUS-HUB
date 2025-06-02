-- ═══════════════════════════════════════════════════════════════════════════════
-- 🚀 WIXT HUB - ROBLOX EXPLOIT MOBILE OPTIMIZED
-- ═══════════════════════════════════════════════════════════════════════════════

local WixtHub = {}

-- 🎨 CONFIGURAÇÕES VISUAIS MOBILE
local Config = {
    Name = "🔥 WixT Hub",
    Theme = {
        Primary = Color3.fromRGB(0, 212, 255),
        Secondary = Color3.fromRGB(153, 69, 255),
        Success = Color3.fromRGB(0, 255, 136),
        Warning = Color3.fromRGB(255, 170, 0),
        Error = Color3.fromRGB(255, 0, 102),
        Dark = Color3.fromRGB(26, 26, 26),
        Background = Color3.fromRGB(15, 15, 15),
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(180, 180, 180)
    }
}

-- 🛡️ PROTEÇÕES ANTI-DETECÇÃO
local function AntiDetection()
    for _, v in pairs(game.CoreGui:GetChildren()) do
        if v.Name:find("Wixt") or v.Name:find("WixT") then
            v:Destroy()
        end
    end
end

-- 📱 CRIAÇÃO DA INTERFACE MOBILE
local function CreateMobileInterface()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "WixtHubMobile"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    -- 🎭 FRAME PRINCIPAL MOBILE
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 380, 0, 520) -- Tamanho mobile
    MainFrame.Position = UDim2.new(0.5, -190, 0.5, -260)
    MainFrame.BackgroundColor3 = Config.Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    
    -- 🔥 BORDAS E CANTOS
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 15)
    Corner.Parent = MainFrame
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Config.Theme.Primary
    Stroke.Thickness = 2
    Stroke.Parent = MainFrame
    
    -- ⭐ HEADER MOBILE
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 50)
    Header.Position = UDim2.new(0, 0, 0, 0)
    Header.BackgroundColor3 = Config.Theme.Dark
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 15)
    HeaderCorner.Parent = Header
    
    -- 🔥 TÍTULO
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0.7, 0, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "🔥 WixT Hub"
    Title.TextColor3 = Config.Theme.Text
    Title.TextSize = 20
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Font = Enum.Font.GothamBold
    Title.Parent = Header
    
    -- ❌ BOTÃO FECHAR MOBILE
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 40, 0, 30)
    CloseButton.Position = UDim2.new(1, -50, 0, 10)
    CloseButton.BackgroundColor3 = Config.Theme.Error
    CloseButton.Text = "✕"
    CloseButton.TextColor3 = Config.Theme.Text
    CloseButton.TextSize = 18
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.BorderSizePixel = 0
    CloseButton.Parent = Header
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseButton
    
    -- 📱 SISTEMA DE ABAS MOBILE (HORIZONTAL)
    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(1, -20, 0, 45)
    TabContainer.Position = UDim2.new(0, 10, 0, 60)
    TabContainer.BackgroundColor3 = Config.Theme.Dark
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = MainFrame
    
    local TabContainerCorner = Instance.new("UICorner")
    TabContainerCorner.CornerRadius = UDim.new(0, 10)
    TabContainerCorner.Parent = TabContainer
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 5)
    TabLayout.Parent = TabContainer
    
    -- 📋 ÁREA DE CONTEÚDO MOBILE
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size = UDim2.new(1, -20, 1, -125)
    ContentFrame.Position = UDim2.new(0, 10, 0, 115)
    ContentFrame.BackgroundColor3 = Config.Theme.Dark
    ContentFrame.BorderSizePixel = 0
    ContentFrame.Parent = MainFrame
    
    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 10)
    ContentCorner.Parent = ContentFrame
    
    return {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        Header = Header,
        TabContainer = TabContainer,
        ContentFrame = ContentFrame,
        CloseButton = CloseButton
    }
end

-- 🎯 SISTEMA DE ABAS MOBILE (CORRIGIDO)
local function CreateMobileTabSystem(interface)
    local tabs = {}
    local currentTab = nil
    
    local function CreateTab(name, icon, contentFunction)
        local tabIndex = #tabs + 1
        
        -- Botão da Aba (Horizontal)
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(0, 70, 1, -10)
        TabButton.Position = UDim2.new(0, 0, 0, 5)
        TabButton.BackgroundColor3 = Config.Theme.Background
        TabButton.Text = icon
        TabButton.TextColor3 = Config.Theme.TextDim
        TabButton.TextSize = 16
        TabButton.Font = Enum.Font.GothamBold
        TabButton.BorderSizePixel = 0
        TabButton.LayoutOrder = tabIndex
        TabButton.Parent = interface.TabContainer
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 8)
        tabCorner.Parent = TabButton
        
        -- Frame do Conteúdo (CORRIGIDO)
        local contentFrame = Instance.new("ScrollingFrame")
        contentFrame.Name = name .. "Content"
        contentFrame.Size = UDim2.new(1, -20, 1, -20)
        contentFrame.Position = UDim2.new(0, 10, 0, 10)
        contentFrame.BackgroundTransparency = 1
        contentFrame.ScrollBarThickness = 6
        contentFrame.ScrollBarImageColor3 = Config.Theme.Primary
        contentFrame.BorderSizePixel = 0
        contentFrame.Visible = false
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        contentFrame.Parent = interface.ContentFrame
        
        -- Layout para organizar elementos
        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 10)
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Parent = contentFrame
        
        -- Auto-resize do canvas
        listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            contentFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)
        end)
        
        -- EXECUTAR FUNÇÃO DE CONTEÚDO AQUI
        if contentFunction then
            contentFunction(contentFrame)
        end
        
        local function SelectTab()
            -- Desativar todas as abas
            for i, tab in ipairs(tabs) do
                tab.Button.BackgroundColor3 = Config.Theme.Background
                tab.Button.TextColor3 = Config.Theme.TextDim
                tab.Content.Visible = false
            end
            
            -- Ativar esta aba
            TabButton.BackgroundColor3 = Config.Theme.Primary
            TabButton.TextColor3 = Config.Theme.Text
            contentFrame.Visible = true
            currentTab = {Button = TabButton, Content = contentFrame}
        end
        
        TabButton.MouseButton1Click:Connect(SelectTab)
        
        table.insert(tabs, {
            Name = name,
            Button = TabButton,
            Content = contentFrame
        })
        
        -- Ativar primeira aba por padrão
        if tabIndex == 1 then
            SelectTab()
        end
        
        return contentFrame
    end
    
    return CreateTab
end

-- 🎮 ELEMENTOS DE UI MOBILE
local function CreateMobileButton(parent, text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 45) -- Maior para mobile
    button.BackgroundColor3 = Config.Theme.Primary
    button.Text = text
    button.TextColor3 = Config.Theme.Text
    button.TextSize = 16
    button.Font = Enum.Font.GothamBold
    button.BorderSizePixel = 0
    button.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = button
    
    if callback then
        button.MouseButton1Click:Connect(callback)
    end
    
    return button
end

local function CreateMobileToggle(parent, text, defaultValue, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, -20, 0, 50) -- Maior para mobile
    toggleFrame.BackgroundColor3 = Config.Theme.Background
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = toggleFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Config.Theme.Text
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = toggleFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 80, 0, 35) -- Maior para mobile
    toggleButton.Position = UDim2.new(1, -90, 0.5, -17.5)
    toggleButton.BackgroundColor3 = defaultValue and Config.Theme.Success or Config.Theme.Error
    toggleButton.Text = defaultValue and "ON" or "OFF"
    toggleButton.TextColor3 = Config.Theme.Text
    toggleButton.TextSize = 14
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.BorderSizePixel = 0
    toggleButton.Parent = toggleFrame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 8)
    toggleCorner.Parent = toggleButton
    
    local isEnabled = defaultValue
    
    toggleButton.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        toggleButton.BackgroundColor3 = isEnabled and Config.Theme.Success or Config.Theme.Error
        toggleButton.Text = isEnabled and "ON" or "OFF"
        if callback then
            callback(isEnabled)
        end
    end)
    
    return toggleFrame
end

local function CreateMobileSlider(parent, text, min, max, defaultValue, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, -20, 0, 70) -- Maior para mobile
    sliderFrame.BackgroundColor3 = Config.Theme.Background
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = sliderFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 0, 25)
    label.Position = UDim2.new(0, 15, 0, 10)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Config.Theme.Text
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = sliderFrame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.4, 0, 0, 25)
    valueLabel.Position = UDim2.new(0.6, 0, 0, 10)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(defaultValue)
    valueLabel.TextColor3 = Config.Theme.Primary
    valueLabel.TextSize = 14
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.Parent = sliderFrame
    
    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1, -30, 0, 8) -- Maior para mobile
    sliderBar.Position = UDim2.new(0, 15, 1, -25)
    sliderBar.BackgroundColor3 = Config.Theme.Dark
    sliderBar.BorderSizePixel = 0
    sliderBar.Parent = sliderFrame
    
    local sliderBarCorner = Instance.new("UICorner")
    sliderBarCorner.CornerRadius = UDim.new(0, 4)
    sliderBarCorner.Parent = sliderBar
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((defaultValue - min) / (max - min), 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = Config.Theme.Primary
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBar
    
    local sliderFillCorner = Instance.new("UICorner")
    sliderFillCorner.CornerRadius = UDim.new(0, 4)
    sliderFillCorner.Parent = sliderFill
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(0, 20, 0, 20) -- Maior para mobile
    sliderButton.Position = UDim2.new((defaultValue - min) / (max - min), -10, 0.5, -10)
    sliderButton.BackgroundColor3 = Config.Theme.Text
    sliderButton.Text = ""
    sliderButton.BorderSizePixel = 0
    sliderButton.Parent = sliderBar
    
    local sliderButtonCorner = Instance.new("UICorner")
    sliderButtonCorner.CornerRadius = UDim.new(0, 10)
    sliderButtonCorner.Parent = sliderButton
    
    local dragging = false
    
    sliderButton.MouseButton1Down:Connect(function()
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
            local relativeX = math.clamp((mouse.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + (max - min) * relativeX)
            
            sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
            sliderButton.Position = UDim2.new(relativeX, -10, 0.5, -10)
            valueLabel.Text = tostring(value)
            
            if callback then
                callback(value)
            end
        end
    end)
    
    return sliderFrame
end

-- 🔫 SISTEMA DE AIMBOT MOBILE
local AimbotSettings = {
    Enabled = false,
    TeamCheck = true,
    WallCheck = true,
    TargetPart = "Head",
    Smoothness = 0.1,
    FOV = 90
}

local function CreateMobileAimbot()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local Camera = workspace.CurrentCamera
    local LocalPlayer = Players.LocalPlayer
    
    local function GetClosestPlayer()
        local closestPlayer = nil
        local closestDistance = math.huge
        local centerScreen = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(AimbotSettings.TargetPart) then
                if AimbotSettings.TeamCheck and player.Team == LocalPlayer.Team then
                    continue
                end
                
                local targetPosition = player.Character[AimbotSettings.TargetPart].Position
                local screenPoint, onScreen = Camera:WorldToViewportPoint(targetPosition)
                
                if onScreen then
                    local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - centerScreen).Magnitude
                    
                    if distance < AimbotSettings.FOV and distance < closestDistance then
                        closestPlayer = player
                        closestDistance = distance
                    end
                end
            end
        end
        
        return closestPlayer
    end
    
    local aimbotConnection
    
    local function ToggleAimbot(enabled)
        AimbotSettings.Enabled = enabled
        
        if enabled then
            aimbotConnection = RunService.Heartbeat:Connect(function()
                local target = GetClosestPlayer()
                if target and target.Character and target.Character:FindFirstChild(AimbotSettings.TargetPart) then
                    local targetPosition = target.Character[AimbotSettings.TargetPart].Position
                    local cameraDirection = (targetPosition - Camera.CFrame.Position).Unit
                    local newCFrame = CFrame.lookAt(Camera.CFrame.Position, Camera.CFrame.Position + cameraDirection)
                    
                    Camera.CFrame = Camera.CFrame:Lerp(newCFrame, AimbotSettings.Smoothness)
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
        Settings = AimbotSettings
    }
end

-- 👁️ SISTEMA DE ESP MOBILE
local ESPSettings = {
    Enabled = false,
    Names = true,
    Health = true,
    Distance = true,
    TeamCheck = true
}

local function CreateMobileESP()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer
    local espObjects = {}
    
    local function CreateESPObject(player)
        local esp = {}
        
        esp.nameLabel = Drawing.new("Text")
        esp.nameLabel.Size = 16
        esp.nameLabel.Color = Color3.fromRGB(255, 255, 255)
        esp.nameLabel.Font = 2
        esp.nameLabel.Outline = true
        esp.nameLabel.Center = true
        esp.nameLabel.Visible = false
        
        esp.healthLabel = Drawing.new("Text")
        esp.healthLabel.Size = 14
        esp.healthLabel.Color = Color3.fromRGB(0, 255, 0)
        esp.healthLabel.Font = 2
        esp.healthLabel.Outline = true
        esp.healthLabel.Center = true
        esp.healthLabel.Visible = false
        
        esp.distanceLabel = Drawing.new("Text")
        esp.distanceLabel.Size = 12
        esp.distanceLabel.Color = Color3.fromRGB(255, 255, 0)
        esp.distanceLabel.Font = 2
        esp.distanceLabel.Outline = true
        esp.distanceLabel.Center = true
        esp.distanceLabel.Visible = false
        
        return esp
    end
    
    local function UpdateESP()
        for player, esp in pairs(espObjects) do
            if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                if ESPSettings.TeamCheck and player.Team == LocalPlayer.Team then
                    esp.nameLabel.Visible = false
                    esp.healthLabel.Visible = false
                    esp.distanceLabel.Visible = false
                    continue
                end
                
                local character = player.Character
                local rootPart = character.HumanoidRootPart
                local humanoid = character:FindFirstChild("Humanoid")
                
                local distance = (LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position)
                
                if onScreen and distance <= 1000 then
                    if ESPSettings.Names then
                        esp.nameLabel.Position = Vector2.new(screenPos.X, screenPos.Y - 40)
                        esp.nameLabel.Text = player.Name
                        esp.nameLabel.Visible = ESPSettings.Enabled
                    end
                    
                    if ESPSettings.Health and humanoid then
                        esp.healthLabel.Position = Vector2.new(screenPos.X, screenPos.Y - 20)
                        esp.healthLabel.Text = math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
                        esp.healthLabel.Visible = ESPSettings.Enabled
                    end
                    
                    if ESPSettings.Distance then
                        esp.distanceLabel.Position = Vector2.new(screenPos.X, screenPos.Y + 20)
                        esp.distanceLabel.Text = math.floor(distance) .. "m"
                        esp.distanceLabel.Visible = ESPSettings.Enabled
                    end
                else
                    esp.nameLabel.Visible = false
                    esp.healthLabel.Visible = false
                    esp.distanceLabel.Visible = false
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
            end
        end
    end
    
    return {
        Toggle = ToggleESP,
        Settings = ESPSettings
    }
end

-- 🏃 SISTEMA DE MOVIMENTO MOBILE
local function CreateMobileMovement()
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
    
    local function ToggleNoclip(enabled)
        local noclipConnection
        if enabled then
            noclipConnection = game:GetService("RunService").Stepped:Connect(function()
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
            end
        end
    end
    
    return {
        SetWalkSpeed = SetWalkSpeed,
        SetJumpPower = SetJumpPower,
        ToggleNoclip = ToggleNoclip
    }
end

-- 🚀 FUNÇÃO PRINCIPAL MOBILE
local function InitializeWixtHubMobile()
    AntiDetection()
    
    local interface = CreateMobileInterface()
    local createTab = CreateMobileTabSystem(interface)
    local aimbotSystem = CreateMobileAimbot()
    local espSystem = CreateMobileESP()
    local movementSystem = CreateMobileMovement()
    
    -- 🎯 ABA AIMBOT
    createTab("Aimbot", "🎯", function(content)
        CreateMobileToggle(content, "🔥 Aimbot Ativado", false, function(enabled)
            aimbotSystem.Toggle(enabled)
        end)
        
        CreateMobileToggle(content, "👥 Team Check", true, function(enabled)
            aimbotSystem.Settings.TeamCheck = enabled
        end)
        
        CreateMobileSlider(content, "🎯 FOV", 10, 360, 90, function(value)
            aimbotSystem.Settings.FOV = value
        end)
        
        CreateMobileSlider(content, "⚡ Suavidade", 1, 100, 10, function(value)
            aimbotSystem.Settings.Smoothness = value / 100
        end)
        
        CreateMobileButton(content, "🎯 Cabeça", function()
            aimbotSystem.Settings.TargetPart = "Head"
        end)
        
        CreateMobileButton(content, "🫀 Torso", function()
            aimbotSystem.Settings.TargetPart = "Torso"
        end)
    end)
    
    -- 👁️ ABA ESP
    createTab("ESP", "👁️", function(content)
        CreateMobileToggle(content, "🔥 ESP Ativado", false, function(enabled)
            espSystem.Toggle(enabled)
        end)
        
        CreateMobileToggle(content, "📝 Mostrar Nomes", true, function(enabled)
            espSystem.Settings.Names = enabled
        end)
        
        CreateMobileToggle(content, "❤️ Mostrar Vida", true, function(enabled)
            espSystem.Settings.Health = enabled
        end)
        
        CreateMobileToggle(content, "📏 Mostrar Distância", true, function(enabled)
            espSystem.Settings.Distance = enabled
        end)
        
        CreateMobileToggle(content, "👥 Team Check", true, function(enabled)
            espSystem.Settings.TeamCheck = enabled
        end)
    end)
    
    -- 🏃 ABA MOVIMENTO
    createTab("Move", "🏃", function(content)
        CreateMobileSlider(content, "🚀 Velocidade", 1, 500, 16, function(value)
            movementSystem.SetWalkSpeed(value)
        end)
        
        CreateMobileSlider(content, "🦘 Força do Pulo", 1, 500, 50, function(value)
            movementSystem.SetJumpPower(value)
        end)
        
        CreateMobileToggle(content, "👻 Noclip", false, function(enabled)
            movementSystem.ToggleNoclip(enabled)
        end)
        
        CreateMobileButton(content, "⚡ Velocidade Extrema", function()
            movementSystem.SetWalkSpeed(200)
            movementSystem.SetJumpPower(200)
        end)
        
        CreateMobileButton(content, "🔄 Reset", function()
            movementSystem.SetWalkSpeed(16)
            movementSystem.SetJumpPower(50)
        end)
    end)
    
    -- 👤 ABA JOGADOR
    createTab("Player", "👤", function(content)
        CreateMobileButton(content, "💖 Vida Infinita", function()
            local player = game.Players.LocalPlayer
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.MaxHealth = math.huge
                player.Character.Humanoid.Health = math.huge
            end
        end)
        
        CreateMobileButton(content, "🔄 Reset Personagem", function()
            local player = game.Players.LocalPlayer
            if player.Character then
                player.Character:BreakJoints()
            end
        end)
        
        CreateMobileToggle(content, "👻 Invisibilidade", false, function(enabled)
            local player = game.Players.LocalPlayer
            if player.Character then
                for _, part in pairs(player.Character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.Transparency = enabled and 1 or 0
                    end
                end
            end
        end)
        
        CreateMobileButton(content, "🏠 Teleport Spawn", function()
            local player = game.Players.LocalPlayer
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
            end
        end)
    end)
    
    -- 🌍 ABA MUNDO
    createTab("World", "🌍", function(content)
        CreateMobileSlider(content, "☀️ Brilho", 0, 10, 1, function(value)
            game.Lighting.Brightness = value
        end)
        
        CreateMobileSlider(content, "🌅 Hora", 0, 24, 12, function(value)
            game.Lighting.TimeOfDay = string.format("%02d:00:00", value)
        end)
        
        CreateMobileButton(content, "🌙 Modo Noite", function()
            game.Lighting.Brightness = 0
            game.Lighting.TimeOfDay = "00:00:00"
        end)
        
        CreateMobileButton(content, "☀️ Modo Dia", function()
            game.Lighting.Brightness = 2
            game.Lighting.TimeOfDay = "12:00:00"
        end)
        
        CreateMobileToggle(content, "✨ Remover Névoa", false, function(enabled)
            game.Lighting.FogEnd = enabled and 100000 or 1000
        end)
    end)
    
    -- 🎉 ANIMAÇÃO DE ENTRADA
    interface.MainFrame.Size = UDim2.new(0, 0, 0, 0)
    interface.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    local TweenService = game:GetService("TweenService")
    TweenService:Create(
        interface.MainFrame,
        TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {
            Size = UDim2.new(0, 380, 0, 520),
            Position = UDim2.new(0.5, -190, 0.5, -260)
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
        interface.ScreenGui:Destroy()
    end)
    
    -- 🎉 NOTIFICAÇÃO
    game.StarterGui:SetCore("SendNotification", {
        Title = "🔥 WixT Hub";
        Text = "Hub carregado com sucesso! Mobile Optimized";
        Duration = 5;
    })
    
    return interface
end

-- 🚀 EXECUTAR O HUB
return InitializeWixtHubMobile()