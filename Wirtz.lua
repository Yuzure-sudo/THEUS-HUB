-- 🔥 WIXT HUB ULTIMATE - MOBILE PERFECT v3.0
-- 🚀 FEITO DO ZERO PARA FUNCIONAR 100%

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
screenGui.Name = "WixtHubUltimatev3"
screenGui.Parent = game.CoreGui
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- 🌟 FRAME PRINCIPAL
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 600)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -300)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- 🎨 CANTOS ARREDONDADOS
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = mainFrame

-- ✨ SOMBRA
local shadow = Instance.new("Frame")
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.5
shadow.ZIndex = mainFrame.ZIndex - 1
shadow.Parent = mainFrame

local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 20)
shadowCorner.Parent = shadow

-- 🎯 HEADER
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 60)
header.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 15)
headerCorner.Parent = header

-- 🔥 TÍTULO
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🔥 WixT Hub Ultimate"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.Parent = header

-- ❌ BOTÃO FECHAR
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -50, 0, 10)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 18
closeButton.Font = Enum.Font.GothamBold
closeButton.BorderSizePixel = 0
closeButton.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

-- 📂 CONTAINER DE CONTEÚDO
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Size = UDim2.new(1, -20, 1, -80)
contentFrame.Position = UDim2.new(0, 10, 0, 70)
contentFrame.BackgroundTransparency = 1
contentFrame.ScrollBarThickness = 8
contentFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
contentFrame.Parent = mainFrame

-- 📐 LAYOUT
local layout = Instance.new("UIListLayout")
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 10)
layout.Parent = contentFrame

-- 🎨 FUNÇÕES DE CRIAÇÃO DE ELEMENTOS

-- 📋 CRIAR SEÇÃO
local function createSection(name)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, 0, 0, 40)
    section.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    section.BorderSizePixel = 0
    section.Parent = contentFrame
    
    local sectionCorner = Instance.new("UICorner")
    sectionCorner.CornerRadius = UDim.new(0, 8)
    sectionCorner.Parent = section
    
    local sectionLabel = Instance.new("TextLabel")
    sectionLabel.Size = UDim2.new(1, -20, 1, 0)
    sectionLabel.Position = UDim2.new(0, 10, 0, 0)
    sectionLabel.BackgroundTransparency = 1
    sectionLabel.Text = name
    sectionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    sectionLabel.TextSize = 16
    sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    sectionLabel.Font = Enum.Font.GothamBold
    sectionLabel.Parent = section
    
    return section
end

-- 🔘 CRIAR TOGGLE
local function createToggle(name, defaultValue, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 45)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = contentFrame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 8)
    toggleCorner.Parent = toggleFrame
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Size = UDim2.new(1, -80, 1, 0)
    toggleLabel.Position = UDim2.new(0, 10, 0, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = name
    toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleLabel.TextSize = 14
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Font = Enum.Font.Gotham
    toggleLabel.Parent = toggleFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 60, 0, 25)
    toggleButton.Position = UDim2.new(1, -70, 0.5, -12.5)
    toggleButton.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 100)
    toggleButton.Text = defaultValue and "ON" or "OFF"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.TextSize = 12
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.BorderSizePixel = 0
    toggleButton.Parent = toggleFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = toggleButton
    
    local isToggled = defaultValue
    
    toggleButton.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        toggleButton.BackgroundColor3 = isToggled and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 100)
        toggleButton.Text = isToggled and "ON" or "OFF"
        callback(isToggled)
    end)
    
    return toggleFrame
end

-- 📊 CRIAR SLIDER
local function createSlider(name, min, max, default, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 60)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = contentFrame
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 8)
    sliderCorner.Parent = sliderFrame
    
    local sliderLabel = Instance.new("TextLabel")
    sliderLabel.Size = UDim2.new(1, -20, 0, 20)
    sliderLabel.Position = UDim2.new(0, 10, 0, 5)
    sliderLabel.BackgroundTransparency = 1
    sliderLabel.Text = name .. ": " .. default
    sliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    sliderLabel.TextSize = 14
    sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    sliderLabel.Font = Enum.Font.Gotham
    sliderLabel.Parent = sliderFrame
    
    local sliderBackground = Instance.new("Frame")
    sliderBackground.Size = UDim2.new(1, -20, 0, 15)
    sliderBackground.Position = UDim2.new(0, 10, 0, 35)
    sliderBackground.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    sliderBackground.BorderSizePixel = 0
    sliderBackground.Parent = sliderFrame
    
    local sliderBgCorner = Instance.new("UICorner")
    sliderBgCorner.CornerRadius = UDim.new(0, 7)
    sliderBgCorner.Parent = sliderBackground
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBackground
    
    local sliderFillCorner = Instance.new("UICorner")
    sliderFillCorner.CornerRadius = UDim.new(0, 7)
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
    buttonFrame.Size = UDim2.new(1, 0, 0, 45)
    buttonFrame.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    buttonFrame.Text = name
    buttonFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
    buttonFrame.TextSize = 14
    buttonFrame.Font = Enum.Font.GothamBold
    buttonFrame.BorderSizePixel = 0
    buttonFrame.Parent = contentFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = buttonFrame
    
    buttonFrame.MouseButton1Click:Connect(function()
        buttonFrame.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
        wait(0.1)
        buttonFrame.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        callback()
    end)
    
    return buttonFrame
end

-- 🎯 SISTEMA AIMBOT SIMPLES
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

-- 🎯 LOOP DO AIMBOT
RunService.Heartbeat:Connect(function()
    if aimbotEnabled then
        local target = getClosestPlayer()
        if target then
            aimAt(target.Character)
        end
    end
end)

-- 👁️ SISTEMA ESP SIMPLES
local espEnabled = false
local espObjects = {}

local function createESP(player)
    local esp = {}
    
    -- Nome
    esp.nameLabel = Drawing.new("Text")
    esp.nameLabel.Size = 16
    esp.nameLabel.Color = Color3.fromRGB(255, 255, 255)
    esp.nameLabel.Center = true
    esp.nameLabel.Outline = true
    esp.nameLabel.OutlineColor = Color3.fromRGB(0, 0, 0)
    
    -- Box
    esp.box = Drawing.new("Square")
    esp.box.Color = Color3.fromRGB(255, 255, 255)
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
                -- Nome
                esp.nameLabel.Position = Vector2.new(headPos.X, headPos.Y - 30)
                esp.nameLabel.Text = player.Name
                esp.nameLabel.Visible = true
                
                -- Box
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

-- 👁️ LOOP DO ESP
RunService.Heartbeat:Connect(function()
    if espEnabled then
        updateESP()
    end
end)

-- 👥 GERENCIAR PLAYERS
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

-- Criar ESP para players existentes
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        espObjects[player] = createESP(player)
    end
end

-- 🏃 SISTEMA DE MOVIMENTO
local originalSpeed = 16
local originalJump = 50

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

-- 🎯 SEÇÃO AIMBOT
createSection("🎯 AIMBOT")

createToggle("🔥 Aimbot Ativado", false, function(enabled)
    aimbotEnabled = enabled
end)

createSlider("🎯 FOV", 50, 500, 100, function(value)
    aimbotFOV = value
end)

createSlider("⚡ Suavidade", 1, 100, 10, function(value)
    aimbotSmoothing = value / 100
end)

-- 👁️ SEÇÃO ESP
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

-- 🏃 SEÇÃO MOVIMENTO
createSection("🏃 MOVIMENTO")

createSlider("🚀 Velocidade", 1, 500, 16, function(value)
    setSpeed(value)
end)

createSlider("🦘 Altura Pulo", 1, 200, 50, function(value)
    setJump(value)
end)

createButton("🔄 Reset Movimento", function()
    setSpeed(originalSpeed)
    setJump(originalJump)
end)

-- 👤 SEÇÃO JOGADOR
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

-- ⚙️ SEÇÃO CONFIGURAÇÕES
createSection("⚙️ CONFIGURAÇÕES")

createButton("📋 Copiar Discord", function()
    setclipboard("https://discord.gg/wixt")
    game.StarterGui:SetCore("SendNotification", {
        Title = "📋 WixT Hub";
        Text = "Discord copiado para área de transferência!";
        Duration = 3;
    })
end)

createButton("🔄 Recarregar Hub", function()
    screenGui:Destroy()
    wait(1)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Yuzure-sudo/THEUS-HUB/main/Wirtz.lua"))()
end)

-- ❌ FECHAR HUB
closeButton.MouseButton1Click:Connect(function()
    -- Animação de saída
    TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    
    wait(0.5)
    screenGui:Destroy()
end)

-- 🚀 ANIMAÇÃO DE ENTRADA
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

TweenService:Create(mainFrame, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 400, 0, 600),
    Position = UDim2.new(0.5, -200, 0.5, -300)
}):Play()

-- 🎉 NOTIFICAÇÃO DE SUCESSO
game.StarterGui:SetCore("SendNotification", {
    Title = "🔥 WixT Hub Ultimate";
    Text = "Carregado com sucesso! Mobile Perfect v3.0";
    Duration = 5;
})

print("🔥 WixT Hub Ultimate - Mobile Perfect v3.0 carregado com sucesso!")
