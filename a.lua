-- ASTERSHUN HUB v2.0
-- Desenvolvido por: Astershun (Dev Oficial)

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Configurações principais
local Settings = {
    HitboxEnabled = false,
    ESPEnabled = true,
    HeadSize = 6,
    Transparency = 0.5,
    HitboxColor = Color3.fromRGB(255, 215, 0), -- Dourado
    TeamCheck = true,
    FriendsCheck = true,
    TargetPlayers = true,
    TargetNPCs = true,
    ExpansionParts = {Head = true},
    Affected = {},
    OriginalSizes = {},
    FriendList = {}
}

-- Sistema de estado da UI
local UI = {
    Loaded = false,
    CurrentTab = "Home",
    Elements = {}
}

-- Função para verificar se é um alvo válido
local function isValidTarget(player, character)
    if not character then return false end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    
    if player == LocalPlayer then return false end
    
    if Settings.TeamCheck then
        if player.Team and LocalPlayer.Team then
            if player.Team == LocalPlayer.Team then
                return false
            end
        end
    end
    
    if Settings.FriendsCheck then
        for _, friendName in ipairs(Settings.FriendList) do
            if player.Name == friendName then
                return false
            end
        end
    end
    
    return true
end

-- Atualizar lista de amigos
local function updateFriendList()
    Settings.FriendList = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if player:IsFriendsWith(LocalPlayer.UserId) then
                table.insert(Settings.FriendList, player.Name)
            end
        end
    end
end

-- Função para expandir hitbox
local function expandHitbox(character, player)
    if Settings.Affected[character] then return end
    
    Settings.Affected[character] = {}
    Settings.OriginalSizes[character] = {}
    
    for partName, shouldExpand in pairs(Settings.ExpansionParts) do
        if shouldExpand then
            local part = character:FindFirstChild(partName)
            if part then
                -- Salvar tamanho original
                Settings.OriginalSizes[character][part] = part.Size
                
                -- Expandir hitbox REAL
                part.Size = Vector3.new(Settings.HeadSize, Settings.HeadSize, Settings.HeadSize)
                
                -- Criar parte visual
                local hitboxVisual = Instance.new("Part")
                hitboxVisual.Name = "AstershunHitboxVisual_" .. partName
                hitboxVisual.Shape = Enum.PartType.Ball
                hitboxVisual.Size = Vector3.new(Settings.HeadSize, Settings.HeadSize, Settings.HeadSize)
                hitboxVisual.Transparency = Settings.Transparency
                hitboxVisual.Color = Settings.HitboxColor
                hitboxVisual.Material = Enum.Material.Neon
                hitboxVisual.CanCollide = false
                hitboxVisual.Anchored = false
                hitboxVisual.Massless = true
                
                local weld = Instance.new("Weld")
                weld.Part0 = part
                weld.Part1 = hitboxVisual
                weld.C0 = CFrame.new(0, 0.2, 0)
                
                hitboxVisual.Parent = character
                weld.Parent = hitboxVisual
                
                table.insert(Settings.Affected[character], {
                    Part = part,
                    Visual = hitboxVisual,
                    Weld = weld,
                    OriginalSize = Settings.OriginalSizes[character][part]
                })
            end
        end
    end
end

-- Restaurar hitbox original
local function restoreHitbox(character)
    if Settings.Affected[character] then
        for _, data in ipairs(Settings.Affected[character]) do
            if data.Part and Settings.OriginalSizes[character][data.Part] then
                data.Part.Size = Settings.OriginalSizes[character][data.Part]
            end
            
            if data.Visual then
                data.Visual:Destroy()
            end
        end
        
        Settings.Affected[character] = nil
    end
end

-- Função para restaurar tudo
local function restoreAll()
    for character in pairs(Settings.Affected) do
        restoreHitbox(character)
    end
    Settings.Affected = {}
end

-- Monitorar personagens
local function monitorCharacters()
    -- Players
    if Settings.TargetPlayers then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local character = player.Character
                if character and isValidTarget(player, character) then
                    expandHitbox(character, player)
                end
            end
        end
    end
    
    -- NPCs
    if Settings.TargetNPCs then
        for _, npc in ipairs(workspace:GetChildren()) do
            if npc:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(npc) then
                expandHitbox(npc)
            end
        end
    end
end

-- Sistema de ESP
local ESPFolders = {}

local function createESP(character, player)
    if not character:FindFirstChild("HumanoidRootPart") then return end
    if ESPFolders[character] then return end
    
    local espFolder = Instance.new("Folder")
    espFolder.Name = "AstershunESP"
    espFolder.Parent = character
    
    -- Caixa do ESP
    local espBox = Instance.new("BoxHandleAdornment")
    espBox.Name = "ESPBox"
    espBox.Adornee = character.HumanoidRootPart
    espBox.AlwaysOnTop = true
    espBox.ZIndex = 5
    espBox.Size = character.HumanoidRootPart.Size + Vector3.new(0.5, 1.5, 0.5)
    espBox.Transparency = 0.7
    espBox.Color3 = Color3.fromRGB(200, 200, 200)
    espBox.Parent = espFolder
    
    -- Nome do jogador
    local espName = Instance.new("TextLabel")
    espName.Name = "ESPName"
    espName.Text = player and player.Name or "NPC"
    espName.TextColor3 = Color3.fromRGB(200, 200, 200)
    espName.TextStrokeTransparency = 0
    espName.TextSize = 14
    espName.Font = Enum.Font.GothamBold
    espName.BackgroundTransparency = 1
    espName.Visible = false
    espName.Parent = espFolder
    
    ESPFolders[character] = espFolder
end

local function updateESP()
    for character, espFolder in pairs(ESPFolders) do
        if character.Parent and character:FindFirstChild("HumanoidRootPart") then
            local espBox = espFolder:FindFirstChild("ESPBox")
            local espName = espFolder:FindFirstChild("ESPName")
            
            -- Atualizar cor
            local player = Players:GetPlayerFromCharacter(character)
            if player then
                if isValidTarget(player, character) then
                    espBox.Color3 = Color3.fromRGB(255, 50, 50)
                    espName.TextColor3 = Color3.fromRGB(255, 50, 50)
                else
                    espBox.Color3 = Color3.fromRGB(50, 255, 100)
                    espName.TextColor3 = Color3.fromRGB(50, 255, 100)
                end
            end
            
            -- Atualizar posição
            local rootPos = character.HumanoidRootPart.Position
            local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(rootPos + Vector3.new(0, 3, 0))
            
            if onScreen then
                espName.Visible = true
                espName.Position = UDim2.new(0, screenPos.X, 0, screenPos.Y)
            else
                espName.Visible = false
            end
        else
            espFolder:Destroy()
            ESPFolders[character] = nil
        end
    end
end

local function clearESP()
    for _, folder in pairs(ESPFolders) do
        folder:Destroy()
    end
    ESPFolders = {}
end

-- Interface do Usuário
local function createBaseUI()
    -- Tela de carregamento
    UI.LoadingScreen = Instance.new("ScreenGui")
    UI.LoadingScreen.Name = "AstershunHubLoading"
    UI.LoadingScreen.ResetOnSpawn = false
    UI.LoadingScreen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local loadingFrame = Instance.new("Frame")
    loadingFrame.Size = UDim2.new(1, 0, 1, 0)
    loadingFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    loadingFrame.BorderSizePixel = 0
    loadingFrame.Parent = UI.LoadingScreen
    
    local crown = Instance.new("ImageLabel")
    crown.Name = "Crown"
    crown.Image = "rbxassetid://13337258670"
    crown.BackgroundTransparency = 1
    crown.Size = UDim2.new(0, 100, 0, 100)
    crown.Position = UDim2.new(0.5, -50, 0.4, -50)
    crown.Parent = loadingFrame
    
    local hubName = Instance.new("TextLabel")
    hubName.Text = "ASTERSHUN HUB"
    hubName.Font = Enum.Font.GothamBold
    hubName.TextSize = 28
    hubName.TextColor3 = Color3.fromRGB(255, 215, 0)
    hubName.BackgroundTransparency = 1
    hubName.Size = UDim2.new(1, 0, 0, 40)
    hubName.Position = UDim2.new(0, 0, 0.5, 0)
    hubName.Parent = loadingFrame
    
    local loadingText = Instance.new("TextLabel")
    loadingText.Text = "Carregando... ⏳"
    loadingText.Font = Enum.Font.Gotham
    loadingText.TextSize = 18
    loadingText.TextColor3 = Color3.fromRGB(200, 200, 200)
    loadingText.BackgroundTransparency = 1
    loadingText.Size = UDim2.new(1, 0, 0, 30)
    loadingText.Position = UDim2.new(0, 0, 0.55, 0)
    loadingText.Parent = loadingFrame
    
    UI.LoadingScreen.Parent = game.CoreGui
    
    -- Interface principal
    UI.MainScreen = Instance.new("ScreenGui")
    UI.MainScreen.Name = "AstershunHub"
    UI.MainScreen.ResetOnSpawn = false
    UI.MainScreen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    UI.MainScreen.Enabled = false
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 600, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = UI.MainScreen
    
    -- Barra de título
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local crownIcon = Instance.new("ImageLabel")
    crownIcon.Name = "CrownIcon"
    crownIcon.Image = "rbxassetid://13337258670"
    crownIcon.BackgroundTransparency = 1
    crownIcon.Size = UDim2.new(0, 30, 0, 30)
    crownIcon.Position = UDim2.new(0, 10, 0.5, -15)
    crownIcon.Parent = titleBar
    
    local titleText = Instance.new("TextLabel")
    titleText.Name = "Title"
    titleText.Text = "ASTERSHUN HUB"
    titleText.Font = Enum.Font.GothamBold
    titleText.TextSize = 18
    titleText.TextColor3 = Color3.fromRGB(255, 215, 0)
    titleText.BackgroundTransparency = 1
    titleText.Size = UDim2.new(0, 200, 1, 0)
    titleText.Position = UDim2.new(0, 50, 0, 0)
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar
    
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Text = "✕"
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 20
    closeButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    closeButton.BackgroundTransparency = 1
    closeButton.Size = UDim2.new(0, 40, 1, 0)
    closeButton.Position = UDim2.new(1, -40, 0, 0)
    closeButton.Parent = titleBar
    
    -- Sidebar
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 150, 1, -40)
    sidebar.Position = UDim2.new(0, 0, 0, 40)
    sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    sidebar.BorderSizePixel = 0
    sidebar.Parent = mainFrame
    
    -- Conteúdo principal
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "Content"
    contentFrame.Size = UDim2.new(1, -150, 1, -40)
    contentFrame.Position = UDim2.new(0, 150, 0, 40)
    contentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    contentFrame.BorderSizePixel = 0
    contentFrame.ClipsDescendants = true
    contentFrame.Parent = mainFrame
    
    -- Botões da sidebar
    local tabButtons = {
        {Name = "Home", Icon = "🏠"},
        {Name = "Hitbox", Icon = "🎯"},
        {Name = "ESP", Icon = "👁"},
        {Name = "Config", Icon = "⚙"},
        {Name = "Info", Icon = "ℹ"}
    }
    
    for i, tab in ipairs(tabButtons) do
        local button = Instance.new("TextButton")
        button.Name = tab.Name .. "Button"
        button.Text = tab.Icon .. "  " .. tab.Name
        button.Font = Enum.Font.Gotham
        button.TextSize = 16
        button.TextColor3 = Color3.fromRGB(180, 180, 180)
        button.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        button.BorderSizePixel = 0
        button.Size = UDim2.new(1, 0, 0, 40)
        button.Position = UDim2.new(0, 0, 0, (i-1)*40)
        button.Parent = sidebar
        
        button.MouseEnter:Connect(function()
            if UI.CurrentTab ~= tab.Name then
                button.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            end
        end)
        
        button.MouseLeave:Connect(function()
            if UI.CurrentTab ~= tab.Name then
                button.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            end
        end)
        
        button.MouseButton1Click:Connect(function()
            UI.CurrentTab = tab.Name
            updateContent()
        end)
    end
    
    -- Função para fechar
    closeButton.MouseButton1Click:Connect(function()
        UI.MainScreen.Enabled = false
    end)
    
    -- Função para arrastar a janela
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    local function updateInput(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            updateInput(input)
        end
    end)
    
    UI.MainScreen.Parent = game.CoreGui
end

-- Atualizar conteúdo da aba selecionada
local function updateContent()
    -- Limpar conteúdo anterior
    if UI.Elements.Content then
        UI.Elements.Content:Destroy()
    end
    
    local contentFrame = UI.MainScreen.MainFrame.Content
    UI.Elements.Content = Instance.new("Frame")
    UI.Elements.Content.Name = "TabContent"
    UI.Elements.Content.Size = UDim2.new(1, 0, 1, 0)
    UI.Elements.Content.BackgroundTransparency = 1
    UI.Elements.Content.Parent = contentFrame
    
    -- Atualizar botões da sidebar
    for _, button in ipairs(UI.MainScreen.MainFrame.Sidebar:GetChildren()) do
        if button:IsA("TextButton") then
            if button.Name == UI.CurrentTab .. "Button" then
                button.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                button.TextColor3 = Color3.fromRGB(255, 215, 0)
            else
                button.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
                button.TextColor3 = Color3.fromRGB(180, 180, 180)
            end
        end
    end
    
    -- Conteúdo específico da aba
    if UI.CurrentTab == "Home" then
        local welcomeLabel = Instance.new("TextLabel")
        welcomeLabel.Text = "Bem-vindo ao Astershun Hub!"
        welcomeLabel.Font = Enum.Font.GothamBold
        welcomeLabel.TextSize = 24
        welcomeLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
        welcomeLabel.BackgroundTransparency = 1
        welcomeLabel.Size = UDim2.new(1, 0, 0, 40)
        welcomeLabel.Position = UDim2.new(0, 20, 0, 20)
        welcomeLabel.TextXAlignment = Enum.TextXAlignment.Left
        welcomeLabel.Parent = UI.Elements.Content
        
        local description = Instance.new("TextLabel")
        description.Text = "Sistema profissional desenvolvido por Astershun\ncom foco em performance e usabilidade."
        description.Font = Enum.Font.Gotham
        description.TextSize = 16
        description.TextColor3 = Color3.fromRGB(200, 200, 200)
        description.BackgroundTransparency = 1
        description.Size = UDim2.new(1, -40, 0, 60)
        description.Position = UDim2.new(0, 20, 0, 70)
        description.TextXAlignment = Enum.TextXAlignment.Left
        description.TextYAlignment = Enum.TextYAlignment.Top
        description.Parent = UI.Elements.Content
        
        local statusLabel = Instance.new("TextLabel")
        statusLabel.Text = "Status do Sistema:"
        statusLabel.Font = Enum.Font.GothamBold
        statusLabel.TextSize = 18
        statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        statusLabel.BackgroundTransparency = 1
        statusLabel.Size = UDim2.new(1, -40, 0, 30)
        statusLabel.Position = UDim2.new(0, 20, 0, 150)
        statusLabel.TextXAlignment = Enum.TextXAlignment.Left
        statusLabel.Parent = UI.Elements.Content
        
        local hitboxStatus = Instance.new("TextLabel")
        hitboxStatus.Text = "Hitbox: " .. (Settings.HitboxEnabled and "ATIVADO" or "DESATIVADO")
        hitboxStatus.Font = Enum.Font.Gotham
        hitboxStatus.TextSize = 16
        hitboxStatus.TextColor3 = Settings.HitboxEnabled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
        hitboxStatus.BackgroundTransparency = 1
        hitboxStatus.Size = UDim2.new(0.5, -10, 0, 25)
        hitboxStatus.Position = UDim2.new(0, 20, 0, 190)
        hitboxStatus.TextXAlignment = Enum.TextXAlignment.Left
        hitboxStatus.Parent = UI.Elements.Content
        
        local espStatus = Instance.new("TextLabel")
        espStatus.Text = "ESP: " .. (Settings.ESPEnabled and "ATIVADO" or "DESATIVADO")
        espStatus.Font = Enum.Font.Gotham
        espStatus.TextSize = 16
        espStatus.TextColor3 = Settings.ESPEnabled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
        espStatus.BackgroundTransparency = 1
        espStatus.Size = UDim2.new(0.5, -10, 0, 25)
        espStatus.Position = UDim2.new(0.5, 10, 0, 190)
        espStatus.TextXAlignment = Enum.TextXAlignment.Left
        espStatus.Parent = UI.Elements.Content
        
    elseif UI.CurrentTab == "Hitbox" then
        local title = Instance.new("TextLabel")
        title.Text = "Configurações de Hitbox"
        title.Font = Enum.Font.GothamBold
        title.TextSize = 20
        title.TextColor3 = Color3.fromRGB(255, 215, 0)
        title.BackgroundTransparency = 1
        title.Size = UDim2.new(1, 0, 0, 40)
        title.Position = UDim2.new(0, 20, 0, 20)
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = UI.Elements.Content
        
        -- Toggle de ativação
        local hitboxToggle = Instance.new("TextButton")
        hitboxToggle.Name = "HitboxToggle"
        hitboxToggle.Text = Settings.HitboxEnabled and "DESATIVAR HITBOX" or "ATIVAR HITBOX"
        hitboxToggle.Font = Enum.Font.GothamBold
        hitboxToggle.TextSize = 16
        hitboxToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        hitboxToggle.BackgroundColor3 = Settings.HitboxEnabled and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(50, 200, 50)
        hitboxToggle.BorderSizePixel = 0
        hitboxToggle.Size = UDim2.new(0.8, 0, 0, 40)
        hitboxToggle.Position = UDim2.new(0.1, 0, 0, 70)
        hitboxToggle.Parent = UI.Elements.Content
        
        hitboxToggle.MouseButton1Click:Connect(function()
            Settings.HitboxEnabled = not Settings.HitboxEnabled
            hitboxToggle.Text = Settings.HitboxEnabled and "DESATIVAR HITBOX" or "ATIVAR HITBOX"
            hitboxToggle.BackgroundColor3 = Settings.HitboxEnabled and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(50, 200, 50)
            
            if not Settings.HitboxEnabled then
                restoreAll()
            end
        end)
        
        -- Slider de tamanho
        local sizeLabel = Instance.new("TextLabel")
        sizeLabel.Text = "Tamanho: " .. Settings.HeadSize
        sizeLabel.Font = Enum.Font.Gotham
        sizeLabel.TextSize = 16
        sizeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        sizeLabel.BackgroundTransparency = 1
        sizeLabel.Size = UDim2.new(1, -40, 0, 30)
        sizeLabel.Position = UDim2.new(0, 20, 0, 130)
        sizeLabel.TextXAlignment = Enum.TextXAlignment.Left
        sizeLabel.Parent = UI.Elements.Content
        
        local sizeSlider = Instance.new("Frame")
        sizeSlider.Name = "SizeSlider"
        sizeSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        sizeSlider.BorderSizePixel = 0
        sizeSlider.Size = UDim2.new(0.8, 0, 0, 10)
        sizeSlider.Position = UDim2.new(0.1, 0, 0, 165)
        sizeSlider.Parent = UI.Elements.Content
        
        local fill = Instance.new("Frame")
        fill.Name = "Fill"
        fill.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
        fill.BorderSizePixel = 0
        fill.Size = UDim2.new((Settings.HeadSize - 1) / 14, 0, 1, 0)
        fill.Parent = sizeSlider
        
        local handle = Instance.new("Frame")
        handle.Name = "Handle"
        handle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        handle.BorderSizePixel = 0
        handle.Size = UDim2.new(0, 20, 0, 20)
        handle.Position = UDim2.new((Settings.HeadSize - 1) / 14, -10, 0.5, -10)
        handle.Parent = sizeSlider
        
        -- Função para atualizar slider
        local function updateSizeSlider(value)
            local size = math.clamp(value, 1, 15)
            Settings.HeadSize = size
            sizeLabel.Text = "Tamanho: " .. string.format("%.1f", size)
            fill.Size = UDim2.new((size - 1) / 14, 0, 1, 0)
            handle.Position = UDim2.new((size - 1) / 14, -10, 0.5, -10)
        end
        
        -- Interação com o slider
        local dragging = false
        
        handle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local mousePos = UserInputService:GetMouseLocation()
                local sliderPos = sizeSlider.AbsolutePosition
                local sliderSize = sizeSlider.AbsoluteSize
                local relativeX = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
                updateSizeSlider(1 + relativeX * 14)
            end
        end)
        
        -- Seletor de cor
        local colorLabel = Instance.new("TextLabel")
        colorLabel.Text = "Cor da Hitbox:"
        colorLabel.Font = Enum.Font.Gotham
        colorLabel.TextSize = 16
        colorLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        colorLabel.BackgroundTransparency = 1
        colorLabel.Size = UDim2.new(1, -40, 0, 30)
        colorLabel.Position = UDim2.new(0, 20, 0, 200)
        colorLabel.TextXAlignment = Enum.TextXAlignment.Left
        colorLabel.Parent = UI.Elements.Content
        
        local colorPreview = Instance.new("Frame")
        colorPreview.Name = "ColorPreview"
        colorPreview.BackgroundColor3 = Settings.HitboxColor
        colorPreview.BorderSizePixel = 0
        colorPreview.Size = UDim2.new(0, 100, 0, 30)
        colorPreview.Position = UDim2.new(0.1, 0, 0, 235)
        colorPreview.Parent = UI.Elements.Content
        
        -- Botão para restaurar tudo
        local restoreButton = Instance.new("TextButton")
        restoreButton.Text = "RESTAURAR TUDO"
        restoreButton.Font = Enum.Font.GothamBold
        restoreButton.TextSize = 16
        restoreButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        restoreButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        restoreButton.BorderSizePixel = 0
        restoreButton.Size = UDim2.new(0.8, 0, 0, 40)
        restoreButton.Position = UDim2.new(0.1, 0, 0, 280)
        restoreButton.Parent = UI.Elements.Content
        
        restoreButton.MouseButton1Click:Connect(function()
            restoreAll()
        end)
        
    elseif UI.CurrentTab == "ESP" then
        local title = Instance.new("TextLabel")
        title.Text = "Configurações de ESP"
        title.Font = Enum.Font.GothamBold
        title.TextSize = 20
        title.TextColor3 = Color3.fromRGB(255, 215, 0)
        title.BackgroundTransparency = 1
        title.Size = UDim2.new(1, 0, 0, 40)
        title.Position = UDim2.new(0, 20, 0, 20)
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = UI.Elements.Content
        
        -- Toggle de ativação
        local espToggle = Instance.new("TextButton")
        espToggle.Name = "ESPToggle"
        espToggle.Text = Settings.ESPEnabled and "DESATIVAR ESP" or "ATIVAR ESP"
        espToggle.Font = Enum.Font.GothamBold
        espToggle.TextSize = 16
        espToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        espToggle.BackgroundColor3 = Settings.ESPEnabled and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(50, 200, 50)
        espToggle.BorderSizePixel = 0
        espToggle.Size = UDim2.new(0.8, 0, 0, 40)
        espToggle.Position = UDim2.new(0.1, 0, 0, 70)
        espToggle.Parent = UI.Elements.Content
        
        espToggle.MouseButton1Click:Connect(function()
            Settings.ESPEnabled = not Settings.ESPEnabled
            espToggle.Text = Settings.ESPEnabled and "DESATIVAR ESP" or "ATIVAR ESP"
            espToggle.BackgroundColor3 = Settings.ESPEnabled and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(50, 200, 50)
            
            if not Settings.ESPEnabled then
                clearESP()
            end
        end)
        
    elseif UI.CurrentTab == "Config" then
        local title = Instance.new("TextLabel")
        title.Text = "Configurações Gerais"
        title.Font = Enum.Font.GothamBold
        title.TextSize = 20
        title.TextColor3 = Color3.fromRGB(255, 215, 0)
        title.BackgroundTransparency = 1
        title.Size = UDim2.new(1, 0, 0, 40)
        title.Position = UDim2.new(0, 20, 0, 20)
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = UI.Elements.Content
        
        -- Configurações de alvo
        local targetLabel = Instance.new("TextLabel")
        targetLabel.Text = "Alvos:"
        targetLabel.Font = Enum.Font.GothamBold
        targetLabel.TextSize = 16
        targetLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        targetLabel.BackgroundTransparency = 1
        targetLabel.Size = UDim2.new(1, -40, 0, 30)
        targetLabel.Position = UDim2.new(0, 20, 0, 70)
        targetLabel.TextXAlignment = Enum.TextXAlignment.Left
        targetLabel.Parent = UI.Elements.Content
        
        local playersToggle = Instance.new("TextButton")
        playersToggle.Text = "Players: " .. (Settings.TargetPlayers and "ON" or "OFF")
        playersToggle.Font = Enum.Font.Gotham
        playersToggle.TextSize = 14
        playersToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        playersToggle.BackgroundColor3 = Settings.TargetPlayers and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
        playersToggle.BorderSizePixel = 0
        playersToggle.Size = UDim2.new(0.35, 0, 0, 30)
        playersToggle.Position = UDim2.new(0.1, 0, 0, 110)
        playersToggle.Parent = UI.Elements.Content
        
        playersToggle.MouseButton1Click:Connect(function()
            Settings.TargetPlayers = not Settings.TargetPlayers
            playersToggle.Text = "Players: " .. (Settings.TargetPlayers and "ON" or "OFF")
            playersToggle.BackgroundColor3 = Settings.TargetPlayers and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
        end)
        
        local npcsToggle = Instance.new("TextButton")
        npcsToggle.Text = "NPCs: " .. (Settings.TargetNPCs and "ON" or "OFF")
        npcsToggle.Font = Enum.Font.Gotham
        npcsToggle.TextSize = 14
        npcsToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        npcsToggle.BackgroundColor3 = Settings.TargetNPCs and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
        npcsToggle.BorderSizePixel = 0
        npcsToggle.Size = UDim2.new(0.35, 0, 0, 30)
        npcsToggle.Position = UDim2.new(0.55, 0, 0, 110)
        npcsToggle.Parent = UI.Elements.Content
        
        npcsToggle.MouseButton1Click:Connect(function()
            Settings.TargetNPCs = not Settings.TargetNPCs
            npcsToggle.Text = "NPCs: " .. (Settings.TargetNPCs and "ON" or "OFF")
            npcsToggle.BackgroundColor3 = Settings.TargetNPCs and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
        end)
        
        -- Configurações de equipe
        local teamLabel = Instance.new("TextLabel")
        teamLabel.Text = "Filtros:"
        teamLabel.Font = Enum.Font.GothamBold
        teamLabel.TextSize = 16
        teamLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        teamLabel.BackgroundTransparency = 1
        teamLabel.Size = UDim2.new(1, -40, 0, 30)
        teamLabel.Position = UDim2.new(0, 20, 0, 160)
        teamLabel.TextXAlignment = Enum.TextXAlignment.Left
        teamLabel.Parent = UI.Elements.Content
        
        local teamToggle = Instance.new("TextButton")
        teamToggle.Text = "Verificar Equipe: " .. (Settings.TeamCheck and "ON" or "OFF")
        teamToggle.Font = Enum.Font.Gotham
        teamToggle.TextSize = 14
        teamToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        teamToggle.BackgroundColor3 = Settings.TeamCheck and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
        teamToggle.BorderSizePixel = 0
        teamToggle.Size = UDim2.new(0.8, 0, 0, 30)
        teamToggle.Position = UDim2.new(0.1, 0, 0, 200)
        teamToggle.Parent = UI.Elements.Content
        
        teamToggle.MouseButton1Click:Connect(function()
            Settings.TeamCheck = not Settings.TeamCheck
            teamToggle.Text = "Verificar Equipe: " .. (Settings.TeamCheck and "ON" or "OFF")
            teamToggle.BackgroundColor3 = Settings.TeamCheck and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
        end)
        
        local friendsToggle = Instance.new("TextButton")
        friendsToggle.Text = "Ignorar Amigos: " .. (Settings.FriendsCheck and "ON" or "OFF")
        friendsToggle.Font = Enum.Font.Gotham
        friendsToggle.TextSize = 14
        friendsToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        friendsToggle.BackgroundColor3 = Settings.FriendsCheck and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
        friendsToggle.BorderSizePixel = 0
        friendsToggle.Size = UDim2.new(0.8, 0, 0, 30)
        friendsToggle.Position = UDim2.new(0.1, 0, 0, 240)
        friendsToggle.Parent = UI.Elements.Content
        
        friendsToggle.MouseButton1Click:Connect(function()
            Settings.FriendsCheck = not Settings.FriendsCheck
            friendsToggle.Text = "Ignorar Amigos: " .. (Settings.FriendsCheck and "ON" or "OFF")
            friendsToggle.BackgroundColor3 = Settings.FriendsCheck and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
            updateFriendList()
        end)
        
    elseif UI.CurrentTab == "Info" then
        local title = Instance.new("TextLabel")
        title.Text = "Sobre o Astershun Hub"
        title.Font = Enum.Font.GothamBold
        title.TextSize = 20
        title.TextColor3 = Color3.fromRGB(255, 215, 0)
        title.BackgroundTransparency = 1
        title.Size = UDim2.new(1, 0, 0, 40)
        title.Position = UDim2.new(0, 20, 0, 20)
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = UI.Elements.Content
        
        local devInfo = Instance.new("TextLabel")
        devInfo.Text = "Desenvolvedor: Astershun\nExperiência: Novo com programação\n\nFiz este Hub com muito esforço,\ndando o meu melhor!"
        devInfo.Font = Enum.Font.Gotham
        devInfo.TextSize = 16
        devInfo.TextColor3 = Color3.fromRGB(200, 200, 200)
        devInfo.BackgroundTransparency = 1
        devInfo.Size = UDim2.new(1, -40, 0, 120)
        devInfo.Position = UDim2.new(0, 20, 0, 70)
        devInfo.TextXAlignment = Enum.TextXAlignment.Left
        devInfo.TextYAlignment = Enum.TextYAlignment.Top
        devInfo.Parent = UI.Elements.Content
        
        local plans = Instance.new("TextLabel")
        plans.Text = "Planos Futuros:\n- Mais scripts para diversos jogos\n- Sistema de perfis personalizados\n- Suporte para dispositivos móveis\n- Integração com Discord"
        plans.Font = Enum.Font.Gotham
        plans.TextSize = 16
        plans.TextColor3 = Color3.fromRGB(200, 200, 200)
        plans.BackgroundTransparency = 1
        plans.Size = UDim2.new(1, -40, 0, 120)
        plans.Position = UDim2.new(0, 20, 0, 210)
        plans.TextXAlignment = Enum.TextXAlignment.Left
        plans.TextYAlignment = Enum.TextYAlignment.Top
        plans.Parent = UI.Elements.Content
        
        local creditsButton = Instance.new("TextButton")
        creditsButton.Text = "CRÉDITOS"
        creditsButton.Font = Enum.Font.GothamBold
        creditsButton.TextSize = 16
        creditsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        creditsButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
        creditsButton.BorderSizePixel = 0
        creditsButton.Size = UDim2.new(0.8, 0, 0, 40)
        creditsButton.Position = UDim2.new(0.1, 0, 0, 340)
        creditsButton.Parent = UI.Elements.Content
        
        creditsButton.MouseButton1Click:Connect(function()
            local notification = Instance.new("ScreenGui")
            notification.Name = "CreditsNotification"
            notification.Parent = game.CoreGui
            
            local notifFrame = Instance.new("Frame")
            notifFrame.Size = UDim2.new(0, 300, 0, 150)
            notifFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
            notifFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            notifFrame.BorderSizePixel = 0
            notifFrame.Parent = notification
            
            local title = Instance.new("TextLabel")
            title.Text = "Créditos"
            title.Font = Enum.Font.GothamBold
            title.TextSize = 20
            title.TextColor3 = Color3.fromRGB(255, 215, 0)
            title.BackgroundTransparency = 1
            title.Size = UDim2.new(1, 0, 0, 40)
            title.Position = UDim2.new(0, 0, 0, 10)
            title.Parent = notifFrame
            
            local message = Instance.new("TextLabel")
            message.Text = "Astershun Hub v2.0\n\nDesenvolvido por: Astershun\nDev Oficial\n\nTodos os direitos reservados"
            message.Font = Enum.Font.Gotham
            message.TextSize = 16
            message.TextColor3 = Color3.fromRGB(200, 200, 200)
            message.BackgroundTransparency = 1
            message.Size = UDim2.new(1, -20, 1, -60)
            message.Position = UDim2.new(0, 10, 0, 50)
            message.TextYAlignment = Enum.TextYAlignment.Top
            message.Parent = notifFrame
            
            local closeButton = Instance.new("TextButton")
            closeButton.Text = "FECHAR"
            closeButton.Font = Enum.Font.GothamBold
            closeButton.TextSize = 16
            closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            closeButton.BorderSizePixel = 0
            closeButton.Size = UDim2.new(0.8, 0, 0, 30)
            closeButton.Position = UDim2.new(0.1, 0, 0, 110)
            closeButton.Parent = notifFrame
            
            closeButton.MouseButton1Click:Connect(function()
                notification:Destroy()
            end)
        end)
    end
end

-- Função para mostrar/ocultar a interface
local function toggleUI()
    UI.MainScreen.Enabled = not UI.MainScreen.Enabled
    if UI.MainScreen.Enabled then
        updateContent()
    end
end

-- Simular carregamento
local function simulateLoading()
    for i = 1, 10 do
        wait(0.1)
    end
    
    UI.LoadingScreen:Destroy()
    UI.MainScreen.Enabled = true
    UI.Loaded = true
    updateContent()
    
    -- Notificação de boas-vindas
    local notification = Instance.new("ScreenGui")
    notification.Name = "WelcomeNotification"
    notification.Parent = game.CoreGui
    
    local notifFrame = Instance.new("Frame")
    notifFrame.Size = UDim2.new(0, 300, 0, 80)
    notifFrame.Position = UDim2.new(1, -320, 1, -100)
    notifFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    notifFrame.BorderSizePixel = 0
    notifFrame.Parent = notification
    
    local title = Instance.new("TextLabel")
    title.Text = "Astershun Hub"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextColor3 = Color3.fromRGB(255, 215, 0)
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 10, 0, 5)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = notifFrame
    
    local message = Instance.new("TextLabel")
    message.Text = "Sistema carregado com sucesso!\nPressione F5 para abrir/fechar o menu."
    message.Font = Enum.Font.Gotham
    message.TextSize = 14
    message.TextColor3 = Color3.fromRGB(200, 200, 200)
    message.BackgroundTransparency = 1
    message.Size = UDim2.new(1, -20, 1, -40)
    message.Position = UDim2.new(0, 10, 0, 35)
    message.TextXAlignment = Enum.TextXAlignment.Left
    message.TextYAlignment = Enum.TextYAlignment.Top
    message.Parent = notifFrame
    
    wait(5)
    notification:Destroy()
end

-- Atalho para abrir/fechar a interface (F5)
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.F5 then
        toggleUI()
    end
end)

-- Loop principal
RunService.Heartbeat:Connect(function()
    -- Atualizar hitboxes
    if Settings.HitboxEnabled then
        monitorCharacters()
    end
    
    -- Atualizar ESP
    if Settings.ESPEnabled then
        updateESP()
    end
end)

-- Inicialização
createBaseUI()
updateFriendList()
spawn(simulateLoading)

print("Astershun Hub carregado com sucesso!")