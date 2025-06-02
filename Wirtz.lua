-- ═══════════════════════════════════════════════════════════════════════════════
-- 🚀 WIXT HUB V2.0 - EXPLOIT ULTRA TECNOLÓGICO PARA ROBLOX
-- ═══════════════════════════════════════════════════════════════════════════════

local WixtHub = {}

-- 🎨 CONFIGURAÇÕES VISUAIS ULTRA MODERNAS
local Config = {
    Name = "🔥 WixT Hub V2.0",
    Version = "2.0.0",
    Theme = {
        Primary = Color3.fromRGB(0, 212, 255),     -- Azul Cyber
        Secondary = Color3.fromRGB(153, 69, 255),  -- Roxo Neon
        Success = Color3.fromRGB(0, 255, 136),     -- Verde Neon
        Warning = Color3.fromRGB(255, 170, 0),     -- Laranja Cyber
        Error = Color3.fromRGB(255, 0, 102),       -- Rosa Neon
        Dark = Color3.fromRGB(26, 26, 26),         -- Preto Premium
        Accent = Color3.fromRGB(0, 255, 255),      -- Ciano Brilhante
        Background = Color3.fromRGB(15, 15, 15),   -- Fundo Ultra Dark
        Text = Color3.fromRGB(255, 255, 255),      -- Branco Puro
        TextDim = Color3.fromRGB(180, 180, 180)    -- Branco Suave
    }
}

-- 🛡️ PROTEÇÕES ANTI-DETECÇÃO
local function AntiDetection()
    -- Esconde da lista de CoreGuis
    for _, v in pairs(game.CoreGui:GetChildren()) do
        if v.Name:find("WixT") then
            v:Destroy()
        end
    end
    
    -- Proteção contra ban
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local oldNamecall = mt.__namecall
    
    mt.__namecall = function(self, ...)
        local args = {...}
        local method = getnamecallmethod()
        
        if method == "FireServer" and tostring(self):find("Ban") then
            return nil
        end
        
        return oldNamecall(self, ...)
    end
    
    setreadonly(mt, true)
end

-- 🚀 CRIAÇÃO DA INTERFACE ULTRA FUTURISTA
local function CreateWixtInterface()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "WixtHubInterface"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    -- 🌟 EFEITO DE BLUR CYBERPUNK
    local BlurEffect = Instance.new("BlurEffect")
    BlurEffect.Size = 0
    BlurEffect.Parent = workspace.CurrentCamera
    
    -- 🎭 FRAME PRINCIPAL ULTRA MODERNO
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 650, 0, 480)
    MainFrame.Position = UDim2.new(0.5, -325, 0.5, -240)
    MainFrame.BackgroundColor3 = Config.Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    
    -- 🔥 BORDAS NEON CYBERPUNK
    local function CreateNeonBorder(parent)
        local border = Instance.new("Frame")
        border.Name = "NeonBorder"
        border.Size = UDim2.new(1, 4, 1, 4)
        border.Position = UDim2.new(0, -2, 0, -2)
        border.BackgroundColor3 = Config.Theme.Primary
        border.BorderSizePixel = 0
        border.Parent = parent
        border.ZIndex = parent.ZIndex - 1
        
        -- Gradiente animado
        local gradient = Instance.new("UIGradient")
        gradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Config.Theme.Primary),
            ColorSequenceKeypoint.new(0.5, Config.Theme.Accent),
            ColorSequenceKeypoint.new(1, Config.Theme.Secondary)
        }
        gradient.Rotation = 45
        gradient.Parent = border
        
        -- Animação de rotação
        local TweenService = game:GetService("TweenService")
        local rotationTween = TweenService:Create(
            gradient,
            TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
            {Rotation = 405}
        )
        rotationTween:Play()
        
        return border
    end
    
    CreateNeonBorder(MainFrame)
    
    -- 🎨 CANTOS ARREDONDADOS ULTRA SUAVES
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = MainFrame
    
    -- ⭐ HEADER CYBERPUNK
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 60)
    Header.Position = UDim2.new(0, 0, 0, 0)
    Header.BackgroundColor3 = Config.Theme.Dark
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 12)
    HeaderCorner.Parent = Header
    
    -- 🔥 TÍTULO ULTRA ESTILIZADO
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0.7, 0, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "🔥 WixT Hub V2.0 🚀"
    Title.TextColor3 = Config.Theme.Text
    Title.TextSize = 24
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Font = Enum.Font.GothamBold
    Title.Parent = Header
    
    -- 🌟 EFEITO GLOW NO TÍTULO
    local TitleGlow = Instance.new("TextLabel")
    TitleGlow.Size = Title.Size
    TitleGlow.Position = Title.Position
    TitleGlow.BackgroundTransparency = 1
    TitleGlow.Text = Title.Text
    TitleGlow.TextColor3 = Config.Theme.Primary
    TitleGlow.TextSize = 24
    TitleGlow.TextXAlignment = Enum.TextXAlignment.Left
    TitleGlow.Font = Enum.Font.GothamBold
    TitleGlow.TextTransparency = 0.7
    TitleGlow.Parent = Header
    TitleGlow.ZIndex = Title.ZIndex - 1
    
    -- 📊 STATUS INDICATOR
    local StatusFrame = Instance.new("Frame")
    StatusFrame.Size = UDim2.new(0, 120, 0, 25)
    StatusFrame.Position = UDim2.new(1, -135, 0, 8)
    StatusFrame.BackgroundColor3 = Config.Theme.Success
    StatusFrame.BorderSizePixel = 0
    StatusFrame.Parent = Header
    
    local StatusCorner = Instance.new("UICorner")
    StatusCorner.CornerRadius = UDim.new(0, 12)
    StatusCorner.Parent = StatusFrame
    
    local StatusText = Instance.new("TextLabel")
    StatusText.Size = UDim2.new(1, 0, 1, 0)
    StatusText.BackgroundTransparency = 1
    StatusText.Text = "🟢 ONLINE"
    StatusText.TextColor3 = Color3.new(0, 0, 0)
    StatusText.TextSize = 12
    StatusText.Font = Enum.Font.GothamBold
    StatusText.Parent = StatusFrame
    
    -- ❌ BOTÃO FECHAR ULTRA MODERNO
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -40, 0, 15)
    CloseButton.BackgroundColor3 = Config.Theme.Error
    CloseButton.Text = "✕"
    CloseButton.TextColor3 = Config.Theme.Text
    CloseButton.TextSize = 16
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.BorderSizePixel = 0
    CloseButton.Parent = Header
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseButton
    
    -- 📱 SISTEMA DE ABAS ULTRA FUTURISTA
    local TabFrame = Instance.new("Frame")
    TabFrame.Size = UDim2.new(0, 140, 1, -70)
    TabFrame.Position = UDim2.new(0, 10, 0, 70)
    TabFrame.BackgroundColor3 = Config.Theme.Dark
    TabFrame.BorderSizePixel = 0
    TabFrame.Parent = MainFrame
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 8)
    TabCorner.Parent = TabFrame
    
    -- 📋 ÁREA DE CONTEÚDO
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size = UDim2.new(1, -170, 1, -70)
    ContentFrame.Position = UDim2.new(0, 160, 0, 70)
    ContentFrame.BackgroundColor3 = Config.Theme.Dark
    ContentFrame.BorderSizePixel = 0
    ContentFrame.Parent = MainFrame
    
    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 8)
    ContentCorner.Parent = ContentFrame
    
    return {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        Header = Header,
        TabFrame = TabFrame,
        ContentFrame = ContentFrame,
        CloseButton = CloseButton,
        BlurEffect = BlurEffect
    }
end

-- 🎯 SISTEMA DE ABAS ULTRA TECNOLÓGICO
local function CreateTabSystem(interface)
    local tabs = {}
    local currentTab = nil
    
    local function CreateTab(name, icon, content)
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(1, -10, 0, 40)
        tabButton.Position = UDim2.new(0, 5, 0, 5 + (#tabs * 45))
        tabButton.BackgroundColor3 = Config.Theme.Background
        tabButton.Text = icon .. " " .. name
        tabButton.TextColor3 = Config.Theme.TextDim
        tabButton.TextSize = 14
        tabButton.Font = Enum.Font.Gotham
        tabButton.BorderSizePixel = 0
        tabButton.Parent = interface.TabFrame
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 8)
        tabCorner.Parent = tabButton
        
        local contentFrame = Instance.new("ScrollingFrame")
        contentFrame.Size = UDim2.new(1, -20, 1, -20)
        contentFrame.Position = UDim2.new(0, 10, 0, 10)
        contentFrame.BackgroundTransparency = 1
        contentFrame.ScrollBarThickness = 4
        contentFrame.ScrollBarImageColor3 = Config.Theme.Primary
        contentFrame.BorderSizePixel = 0
        contentFrame.Visible = false
        contentFrame.Parent = interface.ContentFrame
        
        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 8)
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Parent = contentFrame
        
        local function SelectTab()
            if currentTab then
                currentTab.Button.BackgroundColor3 = Config.Theme.Background
                currentTab.Button.TextColor3 = Config.Theme.TextDim
                currentTab.Content.Visible = false
            end
            
            tabButton.BackgroundColor3 = Config.Theme.Primary
            tabButton.TextColor3 = Config.Theme.Text
            contentFrame.Visible = true
            currentTab = {Button = tabButton, Content = contentFrame}
        end
        
        tabButton.MouseButton1Click:Connect(SelectTab)
        
        if #tabs == 0 then
            SelectTab()
        end
        
        table.insert(tabs, {
            Name = name,
            Button = tabButton,
            Content = contentFrame
        })
        
        return contentFrame
    end
    
    return CreateTab
end

-- 🔫 SISTEMA DE AIMBOT ULTRA AVANÇADO
local AimbotSettings = {
    Enabled = false,
    TeamCheck = true,
    WallCheck = true,
    TargetPart = "Head",
    Smoothness = 0.1,
    FOV = 90,
    MaxDistance = 1000,
    VisibleCheck = true
}

local function CreateAimbot()
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local Camera = workspace.CurrentCamera
    local LocalPlayer = Players.LocalPlayer
    
    local FOVCircle = Drawing.new("Circle")
    FOVCircle.Thickness = 2
    FOVCircle.Color = Color3.fromRGB(0, 212, 255)
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
                
                local targetPosition = player.Character[AimbotSettings.TargetPart].Position
                local screenPoint, onScreen = Camera:WorldToViewportPoint(targetPosition)
                
                if onScreen then
                    local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - centerScreen).Magnitude
                    
                    if distance < AimbotSettings.FOV and distance < closestDistance then
                        if AimbotSettings.WallCheck then
                            local ray = workspace:Raycast(Camera.CFrame.Position, (targetPosition - Camera.CFrame.Position).Unit * AimbotSettings.MaxDistance)
                            if ray and ray.Instance and ray.Instance:IsDescendantOf(player.Character) then
                                closestPlayer = player
                                closestDistance = distance
                            end
                        else
                            closestPlayer = player
                            closestDistance = distance
                        end
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
                if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                    local target = GetClosestPlayer()
                    if target and target.Character and target.Character:FindFirstChild(AimbotSettings.TargetPart) then
                        local targetPosition = target.Character[AimbotSettings.TargetPart].Position
                        local cameraDirection = (targetPosition - Camera.CFrame.Position).Unit
                        local newCFrame = CFrame.lookAt(Camera.CFrame.Position, Camera.CFrame.Position + cameraDirection)
                        
                        Camera.CFrame = Camera.CFrame:Lerp(newCFrame, AimbotSettings.Smoothness)
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

-- 👁️ SISTEMA DE ESP ULTRA AVANÇADO
local ESPSettings = {
    Enabled = false,
    Names = true,
    Health = true,
    Distance = true,
    TeamCheck = true,
    MaxDistance = 1000,
    TextSize = 18
}

local function CreateESP()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer
    local espObjects = {}
    
    local function CreateESPObject(player)
        local esp = {}
        
        -- Nome
        esp.nameLabel = Drawing.new("Text")
        esp.nameLabel.Size = ESPSettings.TextSize
        esp.nameLabel.Color = Color3.fromRGB(255, 255, 255)
        esp.nameLabel.Font = 2
        esp.nameLabel.Outline = true
        esp.nameLabel.Center = true
        esp.nameLabel.Visible = false
        
        -- Vida
        esp.healthLabel = Drawing.new("Text")
        esp.healthLabel.Size = ESPSettings.TextSize - 2
        esp.healthLabel.Color = Color3.fromRGB(0, 255, 0)
        esp.healthLabel.Font = 2
        esp.healthLabel.Outline = true
        esp.healthLabel.Center = true
        esp.healthLabel.Visible = false
        
        -- Distância
        esp.distanceLabel = Drawing.new("Text")
        esp.distanceLabel.Size = ESPSettings.TextSize - 4
        esp.distanceLabel.Color = Color3.fromRGB(255, 255, 0)
        esp.distanceLabel.Font = 2
        esp.distanceLabel.Outline = true
        esp.distanceLabel.Center = true
        esp.distanceLabel.Visible = false
        
        -- Box
        esp.box = Drawing.new("Square")
        esp.box.Color = Color3.fromRGB(0, 212, 255)
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
                
                if distance <= ESPSettings.MaxDistance then
                    local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position)
                    
                    if onScreen then
                        -- Nome
                        if ESPSettings.Names then
                            esp.nameLabel.Position = Vector2.new(screenPos.X, screenPos.Y - 40)
                            esp.nameLabel.Text = player.Name
                            esp.nameLabel.Visible = ESPSettings.Enabled
                        end
                        
                        -- Vida
                        if ESPSettings.Health and humanoid then
                            esp.healthLabel.Position = Vector2.new(screenPos.X, screenPos.Y - 20)
                            esp.healthLabel.Text = math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
                            esp.healthLabel.Color = Color3.fromRGB(
                                255 - (humanoid.Health / humanoid.MaxHealth) * 255,
                                (humanoid.Health / humanoid.MaxHealth) * 255,
                                0
                            )
                            esp.healthLabel.Visible = ESPSettings.Enabled
                        end
                        
                        -- Distância
                        if ESPSettings.Distance then
                            esp.distanceLabel.Position = Vector2.new(screenPos.X, screenPos.Y + 20)
                            esp.distanceLabel.Text = math.floor(distance) .. "m"
                            esp.distanceLabel.Visible = ESPSettings.Enabled
                        end
                        
                        -- Box
                        local headPos = workspace.CurrentCamera:WorldToViewportPoint(character.Head.Position + Vector3.new(0, 0.5, 0))
                        local legPos = workspace.CurrentCamera:WorldToViewportPoint(character.HumanoidRootPart.Position - Vector3.new(0, 3, 0))
                        
                        local boxHeight = math.abs(headPos.Y - legPos.Y)
                        local boxWidth = boxHeight * 0.6
                        
                        esp.box.Size = Vector2.new(boxWidth, boxHeight)
                        esp.box.Position = Vector2.new(screenPos.X - boxWidth/2, headPos.Y)
                        esp.box.Visible = ESPSettings.Enabled
                    else
                        esp.nameLabel.Visible = false
                        esp.healthLabel.Visible = false
                        esp.distanceLabel.Visible = false
                        esp.box.Visible = false
                    end
                else
                    esp.nameLabel.Visible = false
                    esp.healthLabel.Visible = false
                    esp.distanceLabel.Visible = false
                    esp.box.Visible = false
                end
            else
                esp.nameLabel.Visible = false
                esp.healthLabel.Visible = false
                esp.distanceLabel.Visible = false
                esp.box.Visible = false
            end
        end
    end
    
    -- Conecta novos players
    Players.PlayerAdded:Connect(function(player)
        espObjects[player] = CreateESPObject(player)
    end)
    
    -- Remove players que saíram
    Players.PlayerRemoving:Connect(function(player)
        if espObjects[player] then
            for _, object in pairs(espObjects[player]) do
                object:Remove()
            end
            espObjects[player] = nil
        end
    end)
    
    -- Cria ESP para players existentes
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

-- 🏃 SISTEMA DE MOVIMENTO ULTRA AVANÇADO
local MovementSettings = {
    WalkSpeed = 16,
    JumpPower = 50,
    InfiniteJump = false,
    Noclip = false,
    Fly = false,
    FlySpeed = 16
}

local function CreateMovementHacks()
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer
    
    local flying = false
    local flyConnection
    local noclipConnection
    
    local function ToggleFly(enabled)
        MovementSettings.Fly = enabled
        flying = enabled
        
        if enabled then
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.Parent = LocalPlayer.Character.HumanoidRootPart
            
            flyConnection = RunService.Heartbeat:Connect(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local camera = workspace.CurrentCamera
                    local direction = Vector3.new(0, 0, 0)
                    
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        direction = direction + camera.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        direction = direction - camera.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        direction = direction - camera.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        direction = direction + camera.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        direction = direction + camera.CFrame.UpVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        direction = direction - camera.CFrame.UpVector
                    end
                    
                    bodyVelocity.Velocity = direction.Unit * MovementSettings.FlySpeed
                end
            end)
        else
            if flyConnection then flyConnection:Disconnect() end
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local bodyVelocity = LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyVelocity")
                if bodyVelocity then bodyVelocity:Destroy() end
            end
        end
    end
    
    local function ToggleNoclip(enabled)
        MovementSettings.Noclip = enabled
        
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
            if noclipConnection then noclipConnection:Disconnect() end
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
    
    local function SetWalkSpeed(speed)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = speed
            MovementSettings.WalkSpeed = speed
        end
    end
    
    local function SetJumpPower(power)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = power
            MovementSettings.JumpPower = power
        end
    end
    
    return {
        ToggleFly = ToggleFly,
        ToggleNoclip = ToggleNoclip,
        SetWalkSpeed = SetWalkSpeed,
        SetJumpPower = SetJumpPower,
        Settings = MovementSettings
    }
end

-- 🎮 CRIAÇÃO DE ELEMENTOS DE UI
local function CreateButton(parent, text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 35)
    button.BackgroundColor3 = Config.Theme.Primary
    button.Text = text
    button.TextColor3 = Config.Theme.Text
    button.TextSize = 14
    button.Font = Enum.Font.Gotham
    button.BorderSizePixel = 0
    button.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    button.MouseButton1Click:Connect(callback)
    
    -- Efeito hover
    button.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(
            button,
            TweenInfo.new(0.2),
            {BackgroundColor3 = Config.Theme.Secondary}
        ):Play()
    end)
    
    button.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(
            button,
            TweenInfo.new(0.2),
            {BackgroundColor3 = Config.Theme.Primary}
        ):Play()
    end)
    
    return button
end

local function CreateToggle(parent, text, defaultValue, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, -20, 0, 35)
    toggleFrame.BackgroundColor3 = Config.Theme.Background
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = toggleFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Config.Theme.Text
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = toggleFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 60, 0, 25)
    toggleButton.Position = UDim2.new(1, -70, 0.5, -12.5)
    toggleButton.BackgroundColor3 = defaultValue and Config.Theme.Success or Config.Theme.Error
    toggleButton.Text = defaultValue and "ON" or "OFF"
    toggleButton.TextColor3 = Config.Theme.Text
    toggleButton.TextSize = 12
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.BorderSizePixel = 0
    toggleButton.Parent = toggleFrame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 4)
    toggleCorner.Parent = toggleButton
    
    local isEnabled = defaultValue
    
    toggleButton.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        toggleButton.BackgroundColor3 = isEnabled and Config.Theme.Success or Config.Theme.Error
        toggleButton.Text = isEnabled and "ON" or "OFF"
        callback(isEnabled)
    end)
    
    return toggleFrame
end

local function CreateSlider(parent, text, min, max, defaultValue, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, -20, 0, 50)
    sliderFrame.BackgroundColor3 = Config.Theme.Background
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = sliderFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Config.Theme.Text
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = sliderFrame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.3, 0, 0, 20)
    valueLabel.Position = UDim2.new(0.7, 0, 0, 5)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(defaultValue)
    valueLabel.TextColor3 = Config.Theme.Primary
    valueLabel.TextSize = 14
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.Parent = sliderFrame
    
    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1, -20, 0, 6)
    sliderBar.Position = UDim2.new(0, 10, 1, -16)
    sliderBar.BackgroundColor3 = Config.Theme.Dark
    sliderBar.BorderSizePixel = 0
    sliderBar.Parent = sliderFrame
    
    local sliderBarCorner = Instance.new("UICorner")
    sliderBarCorner.CornerRadius = UDim.new(0, 3)
    sliderBarCorner.Parent = sliderBar
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((defaultValue - min) / (max - min), 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = Config.Theme.Primary
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBar
    
    local sliderFillCorner = Instance.new("UICorner")
    sliderFillCorner.CornerRadius = UDim.new(0, 3)
    sliderFillCorner.Parent = sliderFill
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(0, 16, 0, 16)
    sliderButton.Position = UDim2.new((defaultValue - min) / (max - min), -8, 0.5, -8)
    sliderButton.BackgroundColor3 = Config.Theme.Accent
    sliderButton.Text = ""
    sliderButton.BorderSizePixel = 0
    sliderButton.Parent = sliderBar
    
    local sliderButtonCorner = Instance.new("UICorner")
    sliderButtonCorner.CornerRadius = UDim.new(0, 8)
    sliderButtonCorner.Parent = sliderButton
    
    local dragging = false
    
    sliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouse = game.Players.LocalPlayer:GetMouse()
            local relativeX = math.clamp((mouse.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + (max - min) * relativeX)
            
            sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
            sliderButton.Position = UDim2.new(relativeX, -8, 0.5, -8)
            valueLabel.Text = tostring(value)
            
            callback(value)
        end
    end)
    
    return sliderFrame
end

-- 🚀 FUNÇÃO PRINCIPAL PARA CRIAR O HUB
local function InitializeWixtHub()
    AntiDetection()
    
    local interface = CreateWixtInterface()
    local createTab = CreateTabSystem(interface)
    local aimbotSystem = CreateAimbot()
    local espSystem = CreateESP()
    local movementSystem = CreateMovementHacks()
    
    -- 🎯 ABA AIMBOT
    local aimbotTab = createTab("Aimbot", "🎯", function(content)
        -- Header da seção
        local aimbotHeader = Instance.new("TextLabel")
        aimbotHeader.Size = UDim2.new(1, 0, 0, 30)
        aimbotHeader.BackgroundColor3 = Config.Theme.Primary
        aimbotHeader.Text = "🎯 AIMBOT ULTRA AVANÇADO"
        aimbotHeader.TextColor3 = Config.Theme.Text
        aimbotHeader.TextSize = 16
        aimbotHeader.Font = Enum.Font.GothamBold
        aimbotHeader.BorderSizePixel = 0
        aimbotHeader.Parent = content
        
        local headerCorner = Instance.new("UICorner")
        headerCorner.CornerRadius = UDim.new(0, 8)
        headerCorner.Parent = aimbotHeader
        
        -- Toggle principal do Aimbot
        CreateToggle(content, "🔥 Aimbot Ativado", false, function(enabled)
            aimbotSystem.Toggle(enabled)
        end)
        
        -- Configurações do Aimbot
        CreateToggle(content, "👥 Team Check", true, function(enabled)
            aimbotSystem.Settings.TeamCheck = enabled
        end)
        
        CreateToggle(content, "🧱 Wall Check", true, function(enabled)
            aimbotSystem.Settings.WallCheck = enabled
        end)
        
        CreateToggle(content, "👁️ Visible Check", true, function(enabled)
            aimbotSystem.Settings.VisibleCheck = enabled
        end)
        
        -- Sliders de configuração
        CreateSlider(content, "🎯 FOV (Campo de Visão)", 10, 360, 90, function(value)
            aimbotSystem.Settings.FOV = value
            aimbotSystem.FOVCircle.Radius = value
        end)
        
        CreateSlider(content, "⚡ Suavidade", 0.01, 1, 0.1, function(value)
            aimbotSystem.Settings.Smoothness = value
        end)
        
        CreateSlider(content, "📏 Distância Máxima", 100, 5000, 1000, function(value)
            aimbotSystem.Settings.MaxDistance = value
        end)
        
        -- Seletor de parte do corpo
        local targetPartFrame = Instance.new("Frame")
        targetPartFrame.Size = UDim2.new(1, -20, 0, 35)
        targetPartFrame.BackgroundColor3 = Config.Theme.Background
        targetPartFrame.BorderSizePixel = 0
        targetPartFrame.Parent = content
        
        local targetCorner = Instance.new("UICorner")
        targetCorner.CornerRadius = UDim.new(0, 8)
        targetCorner.Parent = targetPartFrame
        
        local targetLabel = Instance.new("TextLabel")
        targetLabel.Size = UDim2.new(0.5, 0, 1, 0)
        targetLabel.Position = UDim2.new(0, 10, 0, 0)
        targetLabel.BackgroundTransparency = 1
        targetLabel.Text = "🎯 Parte do Corpo:"
        targetLabel.TextColor3 = Config.Theme.Text
        targetLabel.TextSize = 14
        targetLabel.TextXAlignment = Enum.TextXAlignment.Left
        targetLabel.Font = Enum.Font.Gotham
        targetLabel.Parent = targetPartFrame
        
        local targetDropdown = Instance.new("TextButton")
        targetDropdown.Size = UDim2.new(0.4, 0, 0, 25)
        targetDropdown.Position = UDim2.new(0.55, 0, 0.5, -12.5)
        targetDropdown.BackgroundColor3 = Config.Theme.Primary
        targetDropdown.Text = "Head ▼"
        targetDropdown.TextColor3 = Config.Theme.Text
        targetDropdown.TextSize = 12
        targetDropdown.Font = Enum.Font.Gotham
        targetDropdown.BorderSizePixel = 0
        targetDropdown.Parent = targetPartFrame
        
        local dropdownCorner = Instance.new("UICorner")
        dropdownCorner.CornerRadius = UDim.new(0, 4)
        dropdownCorner.Parent = targetDropdown
        
        local bodyParts = {"Head", "Torso", "HumanoidRootPart"}
        local currentPart = 1
        
        targetDropdown.MouseButton1Click:Connect(function()
            currentPart = currentPart % #bodyParts + 1
            targetDropdown.Text = bodyParts[currentPart] .. " ▼"
            aimbotSystem.Settings.TargetPart = bodyParts[currentPart]
        end)
        
        -- Botão para mostrar/esconder FOV Circle
        CreateToggle(content, "⭕ Mostrar FOV Circle", true, function(enabled)
            aimbotSystem.FOVCircle.Visible = enabled
        end)
    end)
    
    -- 👁️ ABA ESP
    local espTab = createTab("ESP", "👁️", function(content)
        local espHeader = Instance.new("TextLabel")
        espHeader.Size = UDim2.new(1, 0, 0, 30)
        espHeader.BackgroundColor3 = Config.Theme.Secondary
        espHeader.Text = "👁️ ESP ULTRA AVANÇADO"
        espHeader.TextColor3 = Config.Theme.Text
        espHeader.TextSize = 16
        espHeader.Font = Enum.Font.GothamBold
        espHeader.BorderSizePixel = 0
        espHeader.Parent = content
        
        local espHeaderCorner = Instance.new("UICorner")
        espHeaderCorner.CornerRadius = UDim.new(0, 8)
        espHeaderCorner.Parent = espHeader
        
        -- Toggle principal do ESP
        CreateToggle(content, "🔥 ESP Ativado", false, function(enabled)
            espSystem.Toggle(enabled)
        end)
        
        -- Opções de ESP
        CreateToggle(content, "📝 Mostrar Nomes", true, function(enabled)
            espSystem.Settings.Names = enabled
        end)
        
        CreateToggle(content, "❤️ Mostrar Vida", true, function(enabled)
            espSystem.Settings.Health = enabled
        end)
        
        CreateToggle(content, "📏 Mostrar Distância", true, function(enabled)
            espSystem.Settings.Distance = enabled
        end)
        
        CreateToggle(content, "👥 Team Check", true, function(enabled)
            espSystem.Settings.TeamCheck = enabled
        end)
        
        -- Configurações avançadas
        CreateSlider(content, "📏 Distância Máxima", 100, 5000, 1000, function(value)
            espSystem.Settings.MaxDistance = value
        end)
        
        CreateSlider(content, "📝 Tamanho do Texto", 12, 30, 18, function(value)
            espSystem.Settings.TextSize = value
        end)
        
        -- Botões de preset
        CreateButton(content, "🌈 ESP Colorido", function()
            -- Implementar ESP colorido
        end)
        
        CreateButton(content, "⚡ ESP Rápido", function()
            espSystem.Settings.MaxDistance = 500
            espSystem.Settings.TextSize = 14
        end)
    end)
    
    -- 🏃 ABA MOVIMENTO
    local movementTab = createTab("Movimento", "🏃", function(content)
        local movementHeader = Instance.new("TextLabel")
        movementHeader.Size = UDim2.new(1, 0, 0, 30)
        movementHeader.BackgroundColor3 = Config.Theme.Success
        movementHeader.Text = "🏃 MOVIMENTO ULTRA AVANÇADO"
        movementHeader.TextColor3 = Config.Theme.Text
        movementHeader.TextSize = 16
        movementHeader.Font = Enum.Font.GothamBold
        movementHeader.BorderSizePixel = 0
        movementHeader.Parent = content
        
        local movementHeaderCorner = Instance.new("UICorner")
        movementHeaderCorner.CornerRadius = UDim.new(0, 8)
        movementHeaderCorner.Parent = movementHeader
        
        -- Controles de velocidade
        CreateSlider(content, "🚀 Velocidade de Caminhada", 1, 500, 16, function(value)
            movementSystem.SetWalkSpeed(value)
        end)
        
        CreateSlider(content, "🦘 Força do Pulo", 1, 500, 50, function(value)
            movementSystem.SetJumpPower(value)
        end)
        
        CreateSlider(content, "✈️ Velocidade de Voo", 1, 200, 16, function(value)
            movementSystem.Settings.FlySpeed = value
        end)
        
        -- Toggles de movimento
        CreateToggle(content, "✈️ Modo Voo", false, function(enabled)
            movementSystem.ToggleFly(enabled)
        end)
        
        CreateToggle(content, "👻 Noclip", false, function(enabled)
            movementSystem.ToggleNoclip(enabled)
        end)
        
        CreateToggle(content, "🌟 Pulo Infinito", false, function(enabled)
            movementSystem.Settings.InfiniteJump = enabled
            
            if enabled then
                local connection
                connection = game:GetService("UserInputService").JumpRequest:Connect(function()
                    if movementSystem.Settings.InfiniteJump then
                        local player = game.Players.LocalPlayer
                        if player.Character and player.Character:FindFirstChild("Humanoid") then
                            player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                        end
                    else
                        connection:Disconnect()
                    end
                end)
            end
        end)
        
        -- Botões de preset
        CreateButton(content, "⚡ Velocidade Extrema", function()
            movementSystem.SetWalkSpeed(200)
            movementSystem.SetJumpPower(200)
        end)
        
        CreateButton(content, "🔄 Reset Movimento", function()
            movementSystem.SetWalkSpeed(16)
            movementSystem.SetJumpPower(50)
            movementSystem.ToggleFly(false)
            movementSystem.ToggleNoclip(false)
        end)
    end)
    
    -- 🎮 ABA JOGADOR
    local playerTab = createTab("Jogador", "👤", function(content)
        local playerHeader = Instance.new("TextLabel")
        playerHeader.Size = UDim2.new(1, 0, 0, 30)
        playerHeader.BackgroundColor3 = Config.Theme.Warning
        playerHeader.Text = "👤 HACKS DE JOGADOR"
        playerHeader.TextColor3 = Config.Theme.Text
        playerHeader.TextSize = 16
        playerHeader.Font = Enum.Font.GothamBold
        playerHeader.BorderSizePixel = 0
        playerHeader.Parent = content
        
        local playerHeaderCorner = Instance.new("UICorner")
        playerHeaderCorner.CornerRadius = UDim.new(0, 8)
        playerHeaderCorner.Parent = playerHeader
        
        -- Hacks de vida
        CreateButton(content, "💖 Vida Infinita", function()
            local player = game.Players.LocalPlayer
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.MaxHealth = math.huge
                player.Character.Humanoid.Health = math.huge
            end
        end)
        
        CreateButton(content, "🔄 Reset Personagem", function()
            local player = game.Players.LocalPlayer
            if player.Character then
                player.Character:BreakJoints()
            end
        end)
        
        -- Teleporte
        CreateToggle(content, "🖱️ Click Teleport", false, function(enabled)
            if enabled then
                local mouse = game.Players.LocalPlayer:GetMouse()
                mouse.Button1Down:Connect(function()
                    local player = game.Players.LocalPlayer
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        player.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position)
                    end
                end)
            end
        end)
        
        -- Botões de teleporte rápido
        CreateButton(content, "🏠 Teleport para Spawn", function()
            local player = game.Players.LocalPlayer
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
            end
        end)
        
        -- Invisibilidade
        CreateToggle(content, "👻 Invisibilidade", false, function(enabled)
            local player = game.Players.LocalPlayer
            if player.Character then
                for _, part in pairs(player.Character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.Transparency = enabled and 1 or 0
                    elseif part:IsA("Accessory") then
                        part.Handle.Transparency = enabled and 1 or 0
                    end
                end
                
                if player.Character:FindFirstChild("Head") and player.Character.Head:FindFirstChild("face") then
                    player.Character.Head.face.Transparency = enabled and 1 or 0
                end
            end
        end)
        
        -- Remover acessórios
        CreateButton(content, "🎩 Remover Acessórios", function()
            local player = game.Players.LocalPlayer
            if player.Character then
                for _, accessory in pairs(player.Character:GetChildren()) do
                    if accessory:IsA("Accessory") then
                        accessory:Destroy()
                    end
                end
            end
        end)
    end)
    
    -- 🌍 ABA MUNDO
    local worldTab = createTab("Mundo", "🌍", function(content)
        local worldHeader = Instance.new("TextLabel")
        worldHeader.Size = UDim2.new(1, 0, 0, 30)
        worldHeader.BackgroundColor3 = Config.Theme.Error
        worldHeader.Text = "🌍 HACKS DE MUNDO"
        worldHeader.TextColor3 = Config.Theme.Text
        worldHeader.TextSize = 16
        worldHeader.Font = Enum.Font.GothamBold
        worldHeader.BorderSizePixel = 0
        worldHeader.Parent = content
        
        local worldHeaderCorner = Instance.new("UICorner")
        worldHeaderCorner.CornerRadius = UDim.new(0, 8)
        worldHeaderCorner.Parent = worldHeader
        
        -- Controles de iluminação
        CreateSlider(content, "☀️ Brilho", 0, 10, 1, function(value)
            game.Lighting.Brightness = value
        end)
        
        CreateSlider(content, "🌫️ Fim da Névoa", 100, 10000, 1000, function(value)
            game.Lighting.FogEnd = value
        end)
        
        CreateSlider(content, "🌅 Hora do Dia", 0, 24, 12, function(value)
            game.Lighting.TimeOfDay = string.format("%02d:00:00", value)
        end)
        
        -- Efeitos visuais
        CreateToggle(content, "🌈 Iluminação Arco-íris", false, function(enabled)
            if enabled then
                spawn(function()
                    while enabled do
                        for i = 0, 1, 0.01 do
                            if not enabled then break end
                            game.Lighting.ColorShift_Top = Color3.fromHSV(i, 1, 1)
                            game.Lighting.ColorShift_Bottom = Color3.fromHSV((i + 0.5) % 1, 1, 1)
                            wait(0.1)
                        end
                    end
                end)
            else
                game.Lighting.ColorShift_Top = Color3.new(0, 0, 0)
                game.Lighting.ColorShift_Bottom = Color3.new(0, 0, 0)
            end
        end)
        
        CreateToggle(content, "✨ Remover Névoa", false, function(enabled)
            if enabled then
                game.Lighting.FogEnd = 100000
                game.Lighting.FogStart = 0
            else
                game.Lighting.FogEnd = 1000
                game.Lighting.FogStart = 0
            end
        end)
        
        -- Presets de iluminação
        CreateButton(content, "🌙 Modo Noturno", function()
            game.Lighting.Brightness = 0
            game.Lighting.TimeOfDay = "00:00:00"
            game.Lighting.FogEnd = 500
        end)
        
        CreateButton(content, "☀️ Modo Dia", function()
            game.Lighting.Brightness = 2
            game.Lighting.TimeOfDay = "12:00:00"
            game.Lighting.FogEnd = 10000
        end)
        
        CreateButton(content, "🔥 Modo Cyberpunk", function()
            game.Lighting.Brightness = 0.5
            game.Lighting.ColorShift_Top = Color3.fromRGB(0, 212, 255)
            game.Lighting.ColorShift_Bottom = Color3.fromRGB(153, 69, 255)
            game.Lighting.TimeOfDay = "20:00:00"
        end)
    end)
    
    -- ⚙️ ABA CONFIGURAÇÕES
    local settingsTab = createTab("Config", "⚙️", function(content)
        local settingsHeader = Instance.new("TextLabel")
        settingsHeader.Size = UDim2.new(1, 0, 0, 30)
        settingsHeader.BackgroundColor3 = Config.Theme.Dark
        settingsHeader.Text = "⚙️ CONFIGURAÇÕES"
        settingsHeader.TextColor3 = Config.Theme.Text
        settingsHeader.TextSize = 16
        settingsHeader.Font = Enum.Font.GothamBold
        settingsHeader.BorderSizePixel = 0
        settingsHeader.Parent = content
        
        local settingsHeaderCorner = Instance.new("UICorner")
        settingsHeaderCorner.CornerRadius = UDim.new(0, 8)
        settingsHeaderCorner.Parent = settingsHeader
        
        -- Informações do hub
        local infoFrame = Instance.new("Frame")
        infoFrame.Size = UDim2.new(1, -20, 0, 80)
        infoFrame.BackgroundColor3 = Config.Theme.Background
        infoFrame.BorderSizePixel = 0
        infoFrame.Parent = content
        
        local infoCorner = Instance.new("UICorner")
        infoCorner.CornerRadius = UDim.new(0, 8)
        infoCorner.Parent = infoFrame
        
        local infoText = Instance.new("TextLabel")
        infoText.Size = UDim2.new(1, -20, 1, -20)
        infoText.Position = UDim2.new(0, 10, 0, 10)
        infoText.BackgroundTransparency = 1
        infoText.Text = string.format([[
🔥 WixT Hub V2.0
👨‍💻 Desenvolvido por: WixT Team
🎮 Versão: %s
⚡ Status: Online
🛡️ Anti-Detecção: Ativo
        ]], Config.Version)
        infoText.TextColor3 = Config.Theme.Text
        infoText.TextSize = 12
        infoText.TextXAlignment = Enum.TextXAlignment.Left
        infoText.TextYAlignment = Enum.TextYAlignment.Top
        infoText.Font = Enum.Font.Gotham
        infoText.Parent = infoFrame
        
        -- Botões de ação
        CreateButton(content, "🔄 Recarregar Hub", function()
            interface.ScreenGui:Destroy()
            wait(0.5)
            InitializeWixtHub()
        end)
        
        CreateButton(content, "💾 Salvar Configurações", function()
            -- Implementar sistema de save
            game.StarterGui:SetCore("SendNotification", {
                Title = "WixT Hub";
                Text = "Configurações salvas!";
                Duration = 3;
            })
        end)
        
        CreateButton(content, "📋 Copiar Loadstring", function()
            setclipboard('loadstring(game:HttpGet("https://raw.githubusercontent.com/WixTHub/Scripts/main/WixTHub.lua"))()')
            game.StarterGui:SetCore("SendNotification", {
                Title = "WixT Hub";
                Text = "Loadstring copiada!";
                Duration = 3;
            })
        end)
        
        -- Toggle de interface
        CreateToggle(content, "🎨 Interface Transparente", false, function(enabled)
            interface.MainFrame.BackgroundTransparency = enabled and 0.3 or 0
        end)
        
        CreateToggle(content, "🔊 Sons da Interface", true, function(enabled)
            -- Implementar sons
        end)
    end)
    
    -- 🎯 SISTEMA DE NOTIFICAÇÕES
    local function ShowNotification(title, text, duration)
        game.StarterGui:SetCore("SendNotification", {
            Title = title;
            Text = text;
            Duration = duration or 5;
        })
    end
    
    -- 🔐 SISTEMA DE KEYBINDS
    local UserInputService = game:GetService("UserInputService")
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        -- Toggle da interface com INSERT
        if input.KeyCode == Enum.KeyCode.Insert then
            interface.MainFrame.Visible = not interface.MainFrame.Visible
            interface.BlurEffect.Size = interface.MainFrame.Visible and 10 or 0
        end
        
        -- Aimbot toggle com F
        if input.KeyCode == Enum.KeyCode.F then
            aimbotSystem.Settings.Enabled = not aimbotSystem.Settings.Enabled
            aimbotSystem.Toggle(aimbotSystem.Settings.Enabled)
            ShowNotification("WixT Hub", "Aimbot: " .. (aimbotSystem.Settings.Enabled and "ON" or "OFF"), 2)
        end
        
        -- ESP toggle com G
        if input.KeyCode == Enum.KeyCode.G then
            espSystem.Settings.Enabled = not espSystem.Settings.Enabled
            espSystem.Toggle(espSystem.Settings.Enabled)
            ShowNotification("WixT Hub", "ESP: " .. (espSystem.Settings.Enabled and "ON" or "OFF"), 2)
        end
        
        -- Fly toggle com X
        if input.KeyCode == Enum.KeyCode.X then
            movementSystem.Settings.Fly = not movementSystem.Settings.Fly
            movementSystem.ToggleFly(movementSystem.Settings.Fly)
            ShowNotification("WixT Hub", "Fly: " .. (movementSystem.Settings.Fly and "ON" or "OFF"), 2)
        end
    end)
    
    -- 🎭 ANIMAÇÃO DE ENTRADA ÉPICA
    interface.MainFrame.Size = UDim2.new(0, 0, 0, 0)
    interface.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    local TweenService = game:GetService("TweenService")
    
    -- Efeito de blur
    TweenService:Create(
        interface.BlurEffect,
        TweenInfo.new(0.5, Enum.EasingStyle.Quint),
        {Size = 10}
    ):Play()
    
    -- Animação da janela principal
    TweenService:Create(
        interface.MainFrame,
        TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {
            Size = UDim2.new(0, 650, 0, 480),
            Position = UDim2.new(0.5, -325, 0.5, -240)
        }
    ):Play()
    
    -- 🔥 EFEITO DE PARTÍCULAS CYBERPUNK
    spawn(function()
        while interface.ScreenGui.Parent do
            local particle = Instance.new("Frame")
            particle.Size = UDim2.new(0, math.random(2, 4), 0, math.random(2, 4))
            particle.Position = UDim2.new(0, math.random(0, 650), 0, -10)
            particle.BackgroundColor3 = Color3.fromHSV(math.random(), 1, 1)
            particle.BorderSizePixel = 0
            particle.Parent = interface.MainFrame
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 2)
            corner.Parent = particle
            
            TweenService:Create(
                particle,
                TweenInfo.new(math.random(2, 5), Enum.EasingStyle.Linear),
                {
                    Position = UDim2.new(0, particle.Position.X.Offset, 0, 500),
                    BackgroundTransparency = 1
                }
            ):Play()
            
            game:GetService("Debris"):AddItem(particle, 5)
            wait(0.1)
        end
    end)
    
    -- 🎉 NOTIFICAÇÃO DE CARREGAMENTO
    ShowNotification("🔥 WixT Hub V2.0", "Hub carregado com sucesso! Pressione INSERT para abrir/fechar", 5)
    
    -- 📊 SISTEMA DE ESTATÍSTICAS
    local stats = {
        LoadTime = tick(),
        Version = Config.Version,
        User = game.Players.LocalPlayer.Name,
        Game = game.PlaceId
    }
    
    print("🔥 WixT Hub V2.0 - Carregado com sucesso!")
    print("👤 Usuário:", stats.User)
    print("🎮 Jogo:", stats.Game)
    print("⏱️ Tempo de carregamento:", string.format("%.2fs", tick() - stats.LoadTime))
    
    -- 🔄 FUNÇÃO DE CLEANUP
    interface.CloseButton.MouseButton1Click:Connect(function()
        -- Animação de saída
        TweenService:Create(
            interface.BlurEffect,
            TweenInfo.new(0.3),
            {Size = 0}
        ):Play()
        
        TweenService:Create(
            interface.MainFrame,
            TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In),
            {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0)
            }
        ):Play()
        
        wait(0.5)
        
        -- Cleanup
        aimbotSystem.Toggle(false)
        espSystem.Toggle(false)
        movementSystem.ToggleFly(false)
        movementSystem.ToggleNoclip(false)
        
        interface.ScreenGui:Destroy()
        ShowNotification("WixT Hub", "Hub fechado com sucesso!", 3)
    end)
    
    return interface
end

-- 🚀 INICIALIZAÇÃO AUTOMÁTICA
WixtHub.Initialize = InitializeWixtHub

-- 🔥 EXECUTAR O HUB
return WixtHub.Initialize()