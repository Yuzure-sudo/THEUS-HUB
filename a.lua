--[[
    Astershun Hitbox v3.0
    Desenvolvido por: Astershun (Dev Oficial)
    Sistema avançado de hitbox expansível com detecção real de colisões
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local CurrentGame = game.PlaceId

-- Configurações avançadas
local Settings = {
    HitboxEnabled = false,
    HeadSize = 6,
    Transparency = 0.5,
    HitboxColor = Color3.fromRGB(255, 50, 50),
    TeamCheck = true,
    FriendsCheck = true,
    ESPEnabled = true,
    ESPColorEnemy = Color3.fromRGB(255, 50, 50),
    ESPColorAlly = Color3.fromRGB(50, 255, 100),
    ESPColorNeutral = Color3.fromRGB(200, 200, 200),
    TargetPlayers = true,
    TargetNPCs = true,
    AutoDetectGame = true,
    Affected = {},
    FriendList = {},
    ESPFolders = {},
    OriginalSizes = {}
}

-- Informações sobre o desenvolvedor
local DeveloperInfo = {
    Name = "Astershun",
    Experience = "Novo com programação",
    Message = "Fiz este Hub com muito esforço, dando o meu melhor!",
    FuturePlans = "Em breve: Mais scripts e suporte para vários jogos"
}

-- Detecção automática de jogos populares
local GamePresets = {
    [2753915549] = {HeadSize = 8, HitboxColor = Color3.fromRGB(255, 150, 50)}, -- Blox Fruits
    [292439477] = {HeadSize = 7, HitboxColor = Color3.fromRGB(50, 150, 255)}, -- Phantom Forces
    [142823291] = {HeadSize = 10, Transparency = 0.3}, -- MM2
    [2788229376] = {HeadSize = 9, ESPColorEnemy = Color3.fromRGB(255, 0, 0)}, -- Da Hood
    [5602055394] = {HeadSize = 12, Transparency = 0.4} -- Anime Dimensions
}

-- Aplicar preset se detectado
if Settings.AutoDetectGame and GamePresets[CurrentGame] then
    local preset = GamePresets[CurrentGame]
    for setting, value in pairs(preset) do
        Settings[setting] = value
    end
end

-- Sistema de amigos
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

-- Verificar se é alvo válido
local function isValidTarget(player, character)
    if not character then return false end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    
    -- Não aplicar no próprio jogador
    if player == LocalPlayer then return false end
    
    -- Verificar time
    if Settings.TeamCheck then
        if player.Team and LocalPlayer.Team then
            if player.Team == LocalPlayer.Team then
                return false
            end
        end
    end
    
    -- Verificar amigos
    if Settings.FriendsCheck then
        for _, friendName in ipairs(Settings.FriendList) do
            if player.Name == friendName then
                return false
            end
        end
    end
    
    return true
end

-- Função CRUCIAL: Expandir hitbox REALMENTE funcional
local function expandHitbox(character)
    if Settings.Affected[character] then return end
    
    local head = character:FindFirstChild("Head")
    if head then
        -- Salvar o tamanho original para restauração
        Settings.OriginalSizes[character] = head.Size
        
        -- Expandir a hitbox REAL (não apenas visual)
        head.Size = Vector3.new(Settings.HeadSize, Settings.HeadSize, Settings.HeadSize)
        
        -- Criar parte visual para representar a hitbox expandida
        local hitboxVisual = Instance.new("Part")
        hitboxVisual.Name = "AstershunHitboxVisual"
        hitboxVisual.Shape = Enum.PartType.Ball
        hitboxVisual.Size = Vector3.new(Settings.HeadSize, Settings.HeadSize, Settings.HeadSize)
        hitboxVisual.Transparency = Settings.Transparency
        hitboxVisual.Color = Settings.HitboxColor
        hitboxVisual.Material = Enum.Material.Neon
        hitboxVisual.CanCollide = false
        hitboxVisual.Anchored = false
        hitboxVisual.Massless = true
        
        local weld = Instance.new("Weld")
        weld.Part0 = head
        weld.Part1 = hitboxVisual
        weld.C0 = CFrame.new(0, 0.2, 0)
        
        hitboxVisual.Parent = character
        weld.Parent = hitboxVisual
        
        Settings.Affected[character] = {
            Visual = hitboxVisual,
            Weld = weld,
            OriginalSize = Settings.OriginalSizes[character]
        }
    end
end

-- Restaurar hitbox original
local function restoreHitbox(character)
    if Settings.Affected[character] then
        local head = character:FindFirstChild("Head")
        if head and Settings.OriginalSizes[character] then
            head.Size = Settings.OriginalSizes[character]
        end
        
        if Settings.Affected[character].Visual then
            Settings.Affected[character].Visual:Destroy()
        end
        
        Settings.Affected[character] = nil
    end
end

-- Sistema ESP
local function createESP(character, player)
    if not character:FindFirstChild("HumanoidRootPart") then return end
    if Settings.ESPFolders[character] then return end
    
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
    espBox.Color3 = Settings.ESPColorNeutral
    espBox.Parent = espFolder
    
    -- Nome do jogador
    local espName = Instance.new("TextLabel")
    espName.Name = "ESPName"
    espName.Text = player and player.Name or "NPC"
    espName.TextColor3 = Settings.ESPColorNeutral
    espName.TextStrokeTransparency = 0
    espName.TextSize = 14
    espName.Font = Enum.Font.GothamBold
    espName.BackgroundTransparency = 1
    espName.Visible = false
    espName.Parent = espFolder
    
    -- Barra de saúde
    local healthBar = Instance.new("Frame")
    healthBar.Name = "HealthBar"
    healthBar.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    healthBar.BorderSizePixel = 0
    healthBar.Size = UDim2.new(0, 50, 0, 3)
    healthBar.Visible = false
    healthBar.Parent = espFolder
    
    local healthFill = Instance.new("Frame")
    healthFill.Name = "HealthFill"
    healthFill.BackgroundColor3 = Color3.new(0, 1, 0)
    healthFill.BorderSizePixel = 0
    healthFill.Size = UDim2.new(1, 0, 1, 0)
    healthFill.Parent = healthBar
    
    Settings.ESPFolders[character] = espFolder
end

-- Atualizar ESP
local function updateESP()
    for character, espFolder in pairs(Settings.ESPFolders) do
        if character.Parent and character:FindFirstChild("HumanoidRootPart") then
            local espBox = espFolder:FindFirstChild("ESPBox")
            local espName = espFolder:FindFirstChild("ESPName")
            local healthBar = espFolder:FindFirstChild("HealthBar")
            local healthFill = healthBar and healthBar:FindFirstChild("HealthFill")
            
            -- Atualizar cor baseado na relação
            local player = Players:GetPlayerFromCharacter(character)
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            
            if player then
                if isValidTarget(player, character) then
                    espBox.Color3 = Settings.ESPColorEnemy
                    espName.TextColor3 = Settings.ESPColorEnemy
                else
                    espBox.Color3 = Settings.ESPColorAlly
                    espName.TextColor3 = Settings.ESPColorAlly
                end
            else
                espBox.Color3 = Settings.ESPColorNeutral
                espName.TextColor3 = Settings.ESPColorNeutral
            end
            
            -- Atualizar posição do nome e barra de saúde
            local rootPos = character.HumanoidRootPart.Position
            local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(rootPos + Vector3.new(0, 3, 0))
            
            if onScreen then
                espName.Visible = true
                espName.Position = UDim2.new(0, screenPos.X, 0, screenPos.Y)
                
                if healthBar then
                    healthBar.Visible = true
                    healthBar.Position = UDim2.new(0, screenPos.X - 25, 0, screenPos.Y + 15)
                    
                    -- Atualizar barra de saúde
                    if humanoid then
                        local healthPercent = humanoid.Health / humanoid.MaxHealth
                        healthFill.Size = UDim2.new(healthPercent, 0, 1, 0)
                        healthFill.BackgroundColor3 = Color3.new(1 - healthPercent, healthPercent, 0)
                    end
                end
            else
                espName.Visible = false
                if healthBar then healthBar.Visible = false end
            end
        else
            espFolder:Destroy()
            Settings.ESPFolders[character] = nil
        end
    end
end

-- Atualizar hitboxes
local function updateHitboxes()
    for character, data in pairs(Settings.Affected) do
        if character.Parent and character:FindFirstChild("Head") then
            local head = character.Head
            head.Size = Vector3.new(Settings.HeadSize, Settings.HeadSize, Settings.HeadSize)
            
            if data.Visual then
                data.Visual.Size = Vector3.new(Settings.HeadSize, Settings.HeadSize, Settings.HeadSize)
                data.Visual.Transparency = Settings.Transparency
                data.Visual.Color = Settings.HitboxColor
            end
        else
            restoreHitbox(character)
        end
    end
end

-- Monitorar personagens
local function monitorCharacters()
    -- Players
    if Settings.TargetPlayers then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local character = player.Character
                if character then
                    if isValidTarget(player, character) then
                        expandHitbox(character)
                    end
                    if Settings.ESPEnabled then
                        createESP(character, player)
                    end
                end
            end
        end
    end
    
    -- NPCs
    if Settings.TargetNPCs then
        for _, npc in ipairs(workspace:GetChildren()) do
            if npc:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(npc) then
                if isValidTarget(nil, npc) then
                    expandHitbox(npc)
                end
                if Settings.ESPEnabled then
                    createESP(npc)
                end
            end
        end
    end
end

-- Interface Rayfield
local Window = Rayfield:CreateWindow({
    Name = "Astershun Hitbox",
    LoadingTitle = "Carregando sistema profissional...",
    LoadingSubtitle = "Desenvolvido por Astershun (Dev Oficial)",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "AstershunHitboxSystem",
        FileName = "ProConfig"
    },
    Discord = {
        Enabled = true,
        Invite = "discord.gg/astershun", -- Link personalizado para você
        RememberJoins = true
    },
    KeySystem = false,
})

local MainTab = Window:CreateTab("Controles", 4483362458)
local VisualTab = Window:CreateTab("Visual", 9753762467)
local ESPTab = Window:CreateTab("ESP", 1234567890)
local GameTab = Window:CreateTab("Configurações", 9876543210)
local InfoTab = Window:CreateTab("Informações", 1122334455)

-- Controles principais
MainTab:CreateToggle({
    Name = "Ativar Hitbox Expansível",
    CurrentValue = false,
    Flag = "HitboxToggle",
    Callback = function(value)
        Settings.HitboxEnabled = value
        if not value then
            for char in pairs(Settings.Affected) do
                restoreHitbox(char)
            end
        else
            monitorCharacters()
        end
    end,
})

MainTab:CreateToggle({
    Name = "Ativar Sistema de ESP",
    CurrentValue = true,
    Flag = "ESPToggle",
    Callback = function(value)
        Settings.ESPEnabled = value
        if not value then
            for _, folder in pairs(Settings.ESPFolders) do
                folder:Destroy()
            end
            Settings.ESPFolders = {}
        else
            monitorCharacters()
        end
    end,
})

-- Configurações visuais
VisualTab:CreateSlider({
    Name = "Tamanho da Hitbox",
    Range = {1, 15},
    Increment = 0.5,
    Suffix = "Estudos",
    CurrentValue = Settings.HeadSize,
    Flag = "HeadSize",
    Callback = function(value)
        Settings.HeadSize = value
        updateHitboxes()
    end,
})

VisualTab:CreateSlider({
    Name = "Transparência",
    Range = {0, 1},
    Increment = 0.05,
    Suffix = "%",
    CurrentValue = Settings.Transparency,
    Flag = "Transparency",
    Callback = function(value)
        Settings.Transparency = value
        updateHitboxes()
    end,
})

VisualTab:CreateColorPicker({
    Name = "Cor da Hitbox",
    Color = Settings.HitboxColor,
    Flag = "HitboxColor",
    Callback = function(value)
        Settings.HitboxColor = value
        updateHitboxes()
    end
})

-- Configurações ESP
ESPTab:CreateColorPicker({
    Name = "Cor para Inimigos",
    Color = Settings.ESPColorEnemy,
    Flag = "ESPColorEnemy",
    Callback = function(value)
        Settings.ESPColorEnemy = value
    end
})

ESPTab:CreateColorPicker({
    Name = "Cor para Aliados",
    Color = Settings.ESPColorAlly,
    Flag = "ESPColorAlly",
    Callback = function(value)
        Settings.ESPColorAlly = value
    end
})

ESPTab:CreateColorPicker({
    Name = "Cor para Neutros",
    Color = Settings.ESPColorNeutral,
    Flag = "ESPColorNeutral",
    Callback = function(value)
        Settings.ESPColorNeutral = value
    end
})

-- Configurações de equipe
GameTab:CreateToggle({
    Name = "Verificar Equipe",
    CurrentValue = true,
    Flag = "TeamCheck",
    Callback = function(value)
        Settings.TeamCheck = value
        monitorCharacters()
    end,
})

GameTab:CreateToggle({
    Name = "Ignorar Amigos",
    CurrentValue = true,
    Flag = "FriendsCheck",
    Callback = function(value)
        Settings.FriendsCheck = value
        updateFriendList()
        monitorCharacters()
    end,
})

GameTab:CreateToggle({
    Name = "Detecção Automática de Jogo",
    CurrentValue = true,
    Flag = "AutoDetectGame",
    Callback = function(value)
        Settings.AutoDetectGame = value
    end,
})

GameTab:CreateToggle({
    Name = "Aplicar em Players",
    CurrentValue = true,
    Flag = "TargetPlayers",
    Callback = function(value)
        Settings.TargetPlayers = value
        monitorCharacters()
    end,
})

GameTab:CreateToggle({
    Name = "Aplicar em NPCs",
    CurrentValue = true,
    Flag = "TargetNPCs",
    Callback = function(value)
        Settings.TargetNPCs = value
        monitorCharacters()
    end,
})

-- Tab de Informações
InfoTab:CreateLabel(DeveloperInfo.Message)
InfoTab:CreateLabel("Experiência: " .. DeveloperInfo.Experience)
InfoTab:CreateLabel("Planos Futuros: " .. DeveloperInfo.FuturePlans)

InfoTab:CreateParagraph("Sobre o Sistema", [[
O Astershun Hitbox é um sistema avançado que modifica REALMENTE as hitboxes dos personagens, não apenas visualmente.

Quando você ativa o sistema:
1. A hitbox da cabeça é expandida FISICAMENTE
2. Uma representação visual transparente é criada
3. Seus tiros e ataques acertarão a hitbox expandida
]])

InfoTab:CreateButton({
    Name = "Mostrar Créditos",
    Callback = function()
        Rayfield:Notify({
            Title = "Créditos",
            Content = "Astershun Hitbox v3.0\nDesenvolvido por: Astershun\nDev Oficial",
            Duration = 10,
            Image = 4483362458,
            Actions = {
                Ignore = {
                    Name = "Fechar",
                    Callback = function()
                    end
                },
            },
        })
    end,
})

-- Atualizações em tempo real
RunService.Heartbeat:Connect(function()
    updateFriendList()
    
    if Settings.HitboxEnabled then
        for char in pairs(Settings.Affected) do
            if not char.Parent then
                restoreHitbox(char)
            end
        end
        monitorCharacters()
    end
    
    if Settings.ESPEnabled then
        updateESP()
    end
end)

-- Inicialização
updateFriendList()
Rayfield:Notify({
    Title = "Astershun Hitbox",
    Content = "Sistema ativado com sucesso!\nCriado por: Astershun",
    Duration = 8,
    Image = 4483362458,
})

print("Astershun Hitbox by Astershun carregado!")