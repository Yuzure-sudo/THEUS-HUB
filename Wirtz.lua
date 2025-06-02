-- 🔥 WIXT HUB ULTIMATE - MOBILE COMPACT v5.0
-- 🎨 INTERFACE ÚNICA E PEQUENA

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
screenGui.Name = "WixtHubCompact"
screenGui.Parent = game.CoreGui
screenGui.ResetOnSpawn = false

-- 🌟 FRAME PRINCIPAL (SUPER COMPACTO)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 350)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- 🎨 CANTOS ARREDONDADOS
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = mainFrame

-- ✨ BORDA COLORIDA
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(0, 150, 255)
stroke.Thickness = 2
stroke.Parent = mainFrame

-- 🎯 HEADER SIMPLES
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 15)
headerCorner.Parent = header

-- 🔥 TÍTULO
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🔥 WixT Hub"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.Parent = header

-- ❌ BOTÃO FECHAR
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -30, 0, 7.5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 12
closeButton.Font = Enum.Font.GothamBold
closeButton.BorderSizePixel = 0
closeButton.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

-- 📋 CONTAINER DE CONTEÚDO
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Size = UDim2.new(1, -20, 1, -60)
contentFrame.Position = UDim2.new(0, 10, 0, 50)
contentFrame.BackgroundTransparency = 1
contentFrame.ScrollBarThickness = 4
contentFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
contentFrame.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 6)
layout.Parent = contentFrame

-- 🎨 FUNÇÕES DE CRIAÇÃO

-- 📋 CRIAR SEÇÃO
local function createSection(name)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, 0, 0, 30)
    section.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    section.BorderSizePixel = 0
    section.Parent = contentFrame
    
    local sectionCorner = Instance.new("UICorner")
    sectionCorner.CornerRadius = UDim.new(0, 8)
    sectionCorner.Parent = section
    
    local sectionLabel = Instance.new("TextLabel")
    sectionLabel.Size = UDim2.new(1, -10, 1, 0)
    sectionLabel.Position = UDim2.new(0, 5, 0, 0)
    sectionLabel.BackgroundTransparency = 1
    sectionLabel.Text = name
    sectionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    sectionLabel.TextSize = 14
    sectionLabel.TextXAlignment = Enum.TextXAlignment.Center
    sectionLabel.Font = Enum.Font.GothamBold
    sectionLabel.Parent = section
    
    return section
end

-- 🔘 CRIAR TOGGLE
local function createToggle(name, defaultValue, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 30)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = contentFrame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = toggleFrame
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Size = UDim2.new(1, -50, 1, 0)
    toggleLabel.Position = UDim2.new(0, 8, 0, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = name
    toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleLabel.TextSize = 11
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Font = Enum.Font.Gotham
    toggleLabel.Parent = toggleFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 35, 0, 18)
    toggleButton.Position = UDim2.new(1, -40, 0.5, -9)
    toggleButton.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(100, 100, 100)
    toggleButton.Text = defaultValue and "ON" or "OFF"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.TextSize = 9
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.BorderSizePixel = 0
    toggleButton.Parent = toggleFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 9)
    buttonCorner.Parent = toggleButton
    
    local isToggled = defaultValue
    
    toggleButton.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        toggleButton.BackgroundColor3 = isToggled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(100, 100, 100)
        toggleButton.Text = isToggled and "ON" or "OFF"
        callback(isToggled)
    end)
    
    return toggleFrame
end

-- 📊 CRIAR SLIDER
local function createSlider(name, min, max, default, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 40)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = contentFrame
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 6)
    sliderCorner.Parent = sliderFrame
    
    local sliderLabel = Instance.new("TextLabel")
    sliderLabel.Size = UDim2.new(1, -10, 0, 15)
    sliderLabel.Position = UDim2.new(0, 5, 0, 2)
    sliderLabel.BackgroundTransparency = 1
    sliderLabel.Text = name .. ": " .. default
    sliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    sliderLabel.TextSize = 11
    sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    sliderLabel.Font = Enum.Font.Gotham
    sliderLabel.Parent = sliderFrame
    
    local sliderBackground = Instance.new("Frame")
    sliderBackground.Size = UDim2.new(1, -10, 0, 10)
    sliderBackground.Position = UDim2.new(0, 5, 0, 22)
    sliderBackground.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    sliderBackground.BorderSizePixel = 0
    sliderBackground.Parent = sliderFrame
    
    local sliderBgCorner = Instance.new("UICorner")
    sliderBgCorner.CornerRadius = UDim.new(0, 5)
    sliderBgCorner.Parent = sliderBackground
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBackground
    
    local sliderFillCorner = Instance.new("UICorner")
    sliderFillCorner.CornerRadius = UDim.new(0, 5)
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
                sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
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
    
    return sliderFrame
end

-- 🔲 CRIAR BOTÃO
local function createButton(name, callback)
    local buttonFrame = Instance.new("TextButton")
    buttonFrame.Size = UDim2.new(1, 0, 0, 30)
    buttonFrame.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    buttonFrame.Text = name
    buttonFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
    buttonFrame.TextSize = 11
    buttonFrame.Font = Enum.Font.GothamBold
    buttonFrame.BorderSizePixel = 0
    buttonFrame.Parent = contentFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = buttonFrame
    
    buttonFrame.MouseButton1Click:Connect(function()
        buttonFrame.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
        wait(0.1)
        buttonFrame.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        callback()
    end)
    
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
    esp.nameLabel.Size = 13
    esp.nameLabel.Color = Color3.fromRGB(255, 255, 255)
    esp.nameLabel.Center = true
    esp.nameLabel.Outline = true
    esp.nameLabel.OutlineColor = Color3.fromRGB(0, 0, 0)
    
    esp.box = Drawing.new("Square")
    esp.box.Color = Color3.fromRGB(0, 150, 255)
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
                esp.nameLabel.Position = Vector2.new(headPos.X, headPos.Y - 20)
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

-- 🎨 CRIAÇÃO DA INTERFACE

-- 🎯 AIMBOT
createSection("🎯 AIMBOT")
createToggle("🔥 Aimbot Ativado", false, function(enabled)
    aimbotEnabled = enabled
end)
createSlider("🎯 FOV", 50, 200, 100, function(value)
    aimbotFOV = value
end)
createSlider("⚡ Suavidade", 1, 30, 10, function(value)
    aimbotSmoothing = value / 100
end)

-- 👁️ ESP
createSection("👁️ ESP")
createToggle("🔥 ESP Ativado", false, function(enabled)
    espEnabled = enabled
    if not enabled then
        for _, esp in pairs(espObjects) do
            esp.nameLabel.Visible = false
            esp.box.Visible = false
        end
    end
end)

-- 🏃 MOVIMENTO
createSection("🏃 MOVIMENTO")
createSlider("🚀 Velocidade", 1, 150, 16, function(value)
    setSpeed(value)
end)
createSlider("🦘 Altura Pulo", 1, 120, 50, function(value)
    setJump(value)
end)

-- 👤 JOGADOR
createSection("👤 JOGADOR")
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
end)

createButton("🔄 Reset Personagem", function()
    if LocalPlayer.Character then
        LocalPlayer.Character:BreakJoints()
    end
end)

createButton("📋 Copiar Discord", function()
    setclipboard("https://discord.gg/wixt")
    game.StarterGui:SetCore("SendNotification", {
        Title = "📋 WixT Hub";
        Text = "Discord copiado!";
        Duration = 3;
    })
end)

-- ❌ FECHAR HUB
closeButton.MouseButton1Click:Connect(function()
    TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    
    wait(0.4)
    screenGui:Destroy()
end)

-- 🚀 ANIMAÇÃO DE ENTRADA
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 280, 0, 350),
    Position = UDim2.new(0.5, -140, 0.5, -175)
}):Play()

-- 🎉 NOTIFICAÇÃO
game.StarterGui:SetCore("SendNotification", {
    Title = "🔥 WixT Hub";
    Text = "Interface Compacta v5.0 carregada!";
    Duration = 4;
})

print("🔥 WixT Hub - Mobile Compact v5.0 carregado!")
