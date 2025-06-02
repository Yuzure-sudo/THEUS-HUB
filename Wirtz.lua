-- 🔥 WIXT HUB ULTIMATE - MOBILE PERFECT v4.0
-- 🎨 INTERFACE SUPER BONITA E COMPACTA

-- 🧹 LIMPEZA TOTAL
for _, gui in pairs(game.CoreGui:GetChildren()) do
    if gui.Name:lower():find("wixt") or gui.Name:lower():find("hub") then
        gui:Destroy()
    end
end

-- 📦 SERVIÇOS
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- 🎨 INTERFACE PRINCIPAL
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "WixtHubUltimatev4"
screenGui.Parent = game.CoreGui
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- 🌟 FRAME PRINCIPAL (MENOR E MAIS BONITO)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 320, 0, 450)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- 🎨 GRADIENTE BONITO
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 45)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 25))
}
gradient.Rotation = 45
gradient.Parent = mainFrame

-- 🎨 CANTOS ARREDONDADOS
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 20)
corner.Parent = mainFrame

-- ✨ BORDA BRILHANTE
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(100, 200, 255)
stroke.Thickness = 2
stroke.Transparency = 0.3
stroke.Parent = mainFrame

-- 🎯 HEADER COMPACTO
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
header.BackgroundTransparency = 0.2
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 20)
headerCorner.Parent = header

-- 🔥 TÍTULO ESTILOSO
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -100, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🔥 WixT Hub"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.Parent = header

-- 📱 BOTÃO MINIMIZAR
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -70, 0, 10)
minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
minimizeButton.Text = "−"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.TextSize = 16
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.BorderSizePixel = 0
minimizeButton.Parent = header

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 8)
minimizeCorner.Parent = minimizeButton

-- ❌ BOTÃO FECHAR
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 10)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 14
closeButton.Font = Enum.Font.GothamBold
closeButton.BorderSizePixel = 0
closeButton.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

-- 📂 SISTEMA DE ABAS
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, -20, 0, 40)
tabFrame.Position = UDim2.new(0, 10, 0, 60)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = mainFrame

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0, 5)
tabLayout.Parent = tabFrame

-- 📋 CONTAINER DE CONTEÚDO
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Size = UDim2.new(1, -20, 1, -120)
contentFrame.Position = UDim2.new(0, 10, 0, 110)
contentFrame.BackgroundTransparency = 1
contentFrame.ScrollBarThickness = 6
contentFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 200, 255)
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
contentFrame.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 8)
layout.Parent = contentFrame

-- 🎨 VARIÁVEIS GLOBAIS
local currentTab = "Aimbot"
local isMinimized = false
local tabs = {}

-- 🎨 FUNÇÃO CRIAR ABA
local function createTab(name, icon)
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(0, 70, 1, 0)
    tabButton.BackgroundColor3 = name == currentTab and Color3.fromRGB(100, 200, 255) or Color3.fromRGB(60, 60, 80)
    tabButton.Text = icon
    tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabButton.TextSize = 16
    tabButton.Font = Enum.Font.GothamBold
    tabButton.BorderSizePixel = 0
    tabButton.Parent = tabFrame
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 8)
    tabCorner.Parent = tabButton
    
    tabs[name] = {button = tabButton, elements = {}}
    
    tabButton.MouseButton1Click:Connect(function()
        -- Atualizar visual das abas
        for tabName, tabData in pairs(tabs) do
            tabData.button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        end
        tabButton.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
        
        -- Esconder todos os elementos
        for _, child in pairs(contentFrame:GetChildren()) do
            if child:IsA("Frame") or child:IsA("TextButton") then
                child.Visible = false
            end
        end
        
        -- Mostrar elementos da aba atual
        currentTab = name
        for _, element in pairs(tabs[name].elements) do
            element.Visible = true
        end
    end)
    
    return tabButton
end

-- 🔘 CRIAR TOGGLE COMPACTO
local function createToggle(name, defaultValue, callback, tab)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 35)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Visible = tab == currentTab
    toggleFrame.Parent = contentFrame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 10)
    toggleCorner.Parent = toggleFrame
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Size = UDim2.new(1, -60, 1, 0)
    toggleLabel.Position = UDim2.new(0, 10, 0, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = name
    toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleLabel.TextSize = 12
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Font = Enum.Font.Gotham
    toggleLabel.Parent = toggleFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 45, 0, 20)
    toggleButton.Position = UDim2.new(1, -50, 0.5, -10)
    toggleButton.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(100, 100, 120)
    toggleButton.Text = defaultValue and "ON" or "OFF"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.TextSize = 10
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.BorderSizePixel = 0
    toggleButton.Parent = toggleFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 10)
    buttonCorner.Parent = toggleButton
    
    local isToggled = defaultValue
    
    toggleButton.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        
        TweenService:Create(toggleButton, TweenInfo.new(0.2), {
            BackgroundColor3 = isToggled and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(100, 100, 120)
        }):Play()
        
        toggleButton.Text = isToggled and "ON" or "OFF"
        callback(isToggled)
    end)
    
    table.insert(tabs[tab].elements, toggleFrame)
    return toggleFrame
end

-- 📊 CRIAR SLIDER COMPACTO
local function createSlider(name, min, max, default, callback, tab)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 45)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Visible = tab == currentTab
    sliderFrame.Parent = contentFrame
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 10)
    sliderCorner.Parent = sliderFrame
    
    local sliderLabel = Instance.new("TextLabel")
    sliderLabel.Size = UDim2.new(1, -20, 0, 15)
    sliderLabel.Position = UDim2.new(0, 10, 0, 5)
    sliderLabel.BackgroundTransparency = 1
    sliderLabel.Text = name .. ": " .. default
    sliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    sliderLabel.TextSize = 12
    sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    sliderLabel.Font = Enum.Font.Gotham
    sliderLabel.Parent = sliderFrame
    
    local sliderBackground = Instance.new("Frame")
    sliderBackground.Size = UDim2.new(1, -20, 0, 12)
    sliderBackground.Position = UDim2.new(0, 10, 0, 25)
    sliderBackground.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    sliderBackground.BorderSizePixel = 0
    sliderBackground.Parent = sliderFrame
    
    local sliderBgCorner = Instance.new("UICorner")
    sliderBgCorner.CornerRadius = UDim.new(0, 6)
    sliderBgCorner.Parent = sliderBackground
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBackground
    
    local sliderFillCorner = Instance.new("UICorner")
    sliderFillCorner.CornerRadius = UDim.new(0, 6)
    sliderFillCorner.Parent = sliderFill
    
    local currentValue = default
    
    sliderBackground.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local function updateSlider()
                local mousePos = UserInputService:GetMouseLocation().X
                local framePos = sliderBackground.AbsolutePosition.X
                local frameSize = sliderBackground.AbsoluteSize.X
                local percentage = math.clamp((mousePos - framePos) / frameSize, 0, 1)
                
                currentValue = math.floor(min + (max - min) * percentage)
                
                TweenService:Create(sliderFill, TweenInfo.new(0.1), {
                    Size = UDim2.new(percentage, 0, 1, 0)
                }):Play()
                
                sliderLabel.Text = name .. ": " .. currentValue
                callback(currentValue)
            end
            
            updateSlider()
            
            local connection
            connection = UserInputService.InputEnded:Connect(function(endInput)
                if endInput.UserInputType == Enum.UserInputType.MouseButton1 or endInput.UserInputType == Enum.UserInputType.Touch then
                    connection:Disconnect()
                end
            end)
            
            local moveConnection
            moveConnection = UserInputService.InputChanged:Connect(function(changeInput)
                if changeInput.UserInputType == Enum.UserInputType.MouseMovement or changeInput.UserInputType == Enum.UserInputType.Touch then
                    updateSlider()
                end
            end)
            
            connection.Disconnected:Connect(function()
                moveConnection:Disconnect()
            end)
        end
    end)
    
    table.insert(tabs[tab].elements, sliderFrame)
    return sliderFrame
end

-- 🔲 CRIAR BOTÃO COMPACTO
local function createButton(name, callback, tab)
    local buttonFrame = Instance.new("TextButton")
    buttonFrame.Size = UDim2.new(1, 0, 0, 35)
    buttonFrame.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
    buttonFrame.Text = name
    buttonFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
    buttonFrame.TextSize = 12
    buttonFrame.Font = Enum.Font.GothamBold
    buttonFrame.BorderSizePixel = 0
    buttonFrame.Visible = tab == currentTab
    buttonFrame.Parent = contentFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 10)
    buttonCorner.Parent = buttonFrame
    
    buttonFrame.MouseButton1Click:Connect(function()
        TweenService:Create(buttonFrame, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(80, 160, 200)
        }):Play()
        
        wait(0.1)
        
        TweenService:Create(buttonFrame, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(100, 200, 255)
        }):Play()
        
        callback()
    end)
    
    table.insert(tabs[tab].elements, buttonFrame)
    return buttonFrame
end

-- 🎯 SISTEMA AIMBOT
local aimbotEnabled = false
local aimbotFOV = 100
local aimbotSmoothing = 0.1

local function getClosestPlayer()
    local closestPlayer = nil
    local closestDistance = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local screenPos, onScreen = Camera:WorldToViewportPoint(player.Character.Head.Position)
            if onScreen then
                local distance = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                if distance < aimbotFOV and distance < closestDistance then
                    closestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end
    
    return closestPlayer
end

local function aimAt(character)
    if character and character:FindFirstChild("Head") then
        local targetPos = Camera:WorldToScreenPoint(character.Head.Position)
        local currentPos = Vector2.new(Mouse.X, Mouse.Y)
        local targetPos2D = Vector2.new(targetPos.X, targetPos.Y)
        local newPos = currentPos:Lerp(targetPos2D, aimbotSmoothing)
        
        mousemoverel(newPos.X - currentPos.X, newPos.Y - currentPos.Y)
    end
end

RunService.Heartbeat:Connect(function()
    if aimbotEnabled then
        local target = getClosestPlayer()
        if target then
            aimAt(target.Character)
        end
    end
end)

-- 👁️ SISTEMA ESP
local espEnabled = false
local espObjects = {}

local function createESP(player)
    local esp = {}
    
    esp.nameLabel = Drawing.new("Text")
    esp.nameLabel.Size = 14
    esp.nameLabel.Color = Color3.fromRGB(255, 255, 255)
    esp.nameLabel.Center = true
    esp.nameLabel.Outline = true
    esp.nameLabel.OutlineColor = Color3.fromRGB(0, 0, 0)
    
    esp.box = Drawing.new("Square")
    esp.box.Color = Color3.fromRGB(100, 200, 255)
    esp.box.Thickness = 2
    esp.box.Filled = false
    
    return esp
end

local function updateESP()
    for player, esp in pairs(espObjects) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Head") then
            local rootPart = player.Character.HumanoidRootPart
            local head = player.Character.Head
            
            local rootPos, rootOnScreen = Camera:WorldToViewportPoint(rootPart.Position)
            local headPos, headOnScreen = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
            
            if rootOnScreen and headOnScreen then
                esp.nameLabel.Position = Vector2.new(headPos.X, headPos.Y - 25)
                esp.nameLabel.Text = player.Name
                esp.nameLabel.Visible = true
                
                local boxHeight = math.abs(headPos.Y - rootPos.Y) * 1.2
                local boxWidth = boxHeight * 0.6
                
                esp.box.Size = Vector2.new(boxWidth, boxHeight)
                esp.box.Position = Vector2.new(headPos.X - boxWidth/2, headPos.Y)
                esp.box.Visible = true
            else
                esp.nameLabel.Visible = false
                esp.box.Visible = false
            end
        else
            esp.nameLabel.Visible = false
            esp.box.Visible = false
        end
    end
end

RunService.Heartbeat:Connect(function()
    if espEnabled then
        updateESP()
    end
end)

Players.PlayerAdded:Connect(function(player)
    espObjects[player] = createESP(player)
end)

Players.PlayerRemoving:Connect(function(player)
    if espObjects[player] then
        for _, object in pairs(espObjects[player]) do
            if object.Remove then
                object:Remove()
            end
        end
        espObjects[player] = nil
    end
end)

for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        espObjects[player] = createESP(player)
    end
end

-- 🏃 SISTEMA DE MOVIMENTO
local function setSpeed(speed)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = speed
    end
end

local function setJump(jump)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = jump
    end
end

-- 🎨 CRIAÇÃO DAS ABAS
createTab("Aimbot", "🎯")
createTab("ESP", "👁️")
createTab("Move", "🏃")
createTab("Player", "👤")

-- 🎯 ABA AIMBOT
createToggle("🔥 Aimbot Ativado", false, function(enabled)
    aimbotEnabled = enabled
end, "Aimbot")

createSlider("🎯 FOV", 50, 300, 100, function(value)
    aimbotFOV = value
end, "Aimbot")

createSlider("⚡ Suavidade", 1, 50, 10, function(value)
    aimbotSmoothing = value / 100
end, "Aimbot")

-- 👁️ ABA ESP
createToggle("🔥 ESP Ativado", false, function(enabled)
    espEnabled = enabled
    if not enabled then
        for _, esp in pairs(espObjects) do
            esp.nameLabel.Visible = false
            esp.box.Visible = false
        end
    end
end, "ESP")

-- 🏃 ABA MOVIMENTO
createSlider("🚀 Velocidade", 1, 200, 16, function(value)
    setSpeed(value)
end, "Move")

createSlider("🦘 Altura Pulo", 1, 150, 50, function(value)
    setJump(value)
end, "Move")

createButton("🔄 Reset Movimento", function()
    setSpeed(16)
    setJump(50)
end, "Move")

-- 👤 ABA JOGADOR
createButton("💖 Vida Infinita", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.MaxHealth = math.huge
        LocalPlayer.Character.Humanoid.Health = math.huge
        
        game.StarterGui:SetCore("SendNotification", {
            Title = "💖 WixT Hub";
            Text = "Vida infinita ativada!";
            Duration = 3;
        })
    end
end, "Player")

createButton("🔄 Reset Personagem", function()
    if LocalPlayer.Character then
        LocalPlayer.Character:BreakJoints()
    end
end, "Player")

createButton("📋 Copiar Discord", function()
    setclipboard("https://discord.gg/wixt")
    game.StarterGui:SetCore("SendNotification", {
        Title = "📋 WixT Hub";
        Text = "Discord copiado!";
        Duration = 3;
    })
end, "Player")

-- 📱 SISTEMA DE MINIMIZAR
minimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    
    if isMinimized then
        TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 320, 0, 50)
        }):Play()
        
        tabFrame.Visible = false
        contentFrame.Visible = false
        minimizeButton.Text = "+"
    else
        TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 320, 0, 450)
        }):Play()
        
        tabFrame.Visible = true
        contentFrame.Visible = true
        minimizeButton.Text = "−"
    end
end)

-- ❌ FECHAR HUB
closeButton.MouseButton1Click:Connect(function()
    TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    
    wait(0.5)
    screenGui:Destroy()
end)

-- 🚀 ANIMAÇÃO DE ENTRADA ÉPICA
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

TweenService:Create(mainFrame, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 320, 0, 450),
    Position = UDim2.new(0.5, -160, 0.5, -225)
}):Play()

-- 🎉 NOTIFICAÇÃO DE SUCESSO
game.StarterGui:SetCore("SendNotification", {
    Title = "🔥 WixT Hub Ultimate";
    Text = "Interface Mobile Perfect v4.0 carregada!";
    Duration = 5;
})

print("🔥 WixT Hub Ultimate - Mobile Perfect v4.0 carregado com sucesso!")
