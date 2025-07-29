--[[
    Astershun Hitbox v4.1
    Desenvolvido por: Astershun (Dev Oficial)
    Sistema premium de hitbox expansível com correção de interface
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
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
    OriginalSizes = {},
    KeySystem = {
        Enabled = true,
        Key = "teste",
        SavedKey = "",
        RememberKey = true
    },
    ExpansionParts = {
        Head = true,
        Torso = false,
        LeftArm = false,
        RightArm = false,
        LeftLeg = false,
        RightLeg = false
    },
    TargetHistory = {},
    Whitelist = {},
    Blacklist = {},
    UpdateRate = 0.1
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

-- Módulo de utilitários
local Utils = {}

function Utils.isValidTarget(player, character)
    if not character then return false end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    
    -- Não aplicar no próprio jogador
    if player == LocalPlayer then return false end
    
    -- Verificar Whitelist/Blacklist
    if player then
        for _, name in ipairs(Settings.Whitelist) do
            if player.Name == name then return false end
        end
        
        for _, name in ipairs(Settings.Blacklist) do
            if player.Name == name then return true end
        end
    end
    
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
    
    -- Verificar AFK (inativo)
    if character:FindFirstChild("HumanoidRootPart") then
        local velocity = character.HumanoidRootPart.Velocity
        if velocity.Magnitude < 0.1 then
            return false
        end
    end
    
    return true
end

function Utils.updateFriendList()
    Settings.FriendList = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if player:IsFriendsWith(LocalPlayer.UserId) then
                table.insert(Settings.FriendList, player.Name)
            end
        end
    end
end

function Utils.tweenPart(part, size, duration)
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(part, tweenInfo, {Size = size})
    tween:Play()
end

function Utils.addToHistory(targetName)
    table.insert(Settings.TargetHistory, 1, targetName)
    if #Settings.TargetHistory > 5 then
        table.remove(Settings.TargetHistory, 6)
    end
end

-- Sistema de Key
local KeySystem = {}

function KeySystem.authenticate(inputKey)
    if inputKey == Settings.KeySystem.Key then
        Settings.KeySystem.SavedKey = inputKey
        return true
    end
    return false
end

function KeySystem.saveSettings()
    if Settings.KeySystem.RememberKey then
        writefile("AstershunHitbox_Key.txt", Settings.KeySystem.SavedKey)
    end
end

function KeySystem.loadSettings()
    if isfile("AstershunHitbox_Key.txt") then
        Settings.KeySystem.SavedKey = readfile("AstershunHitbox_Key.txt")
    end
end

-- Função CRUCIAL: Expandir hitbox REALMENTE funcional
local function expandHitbox(character, player)
    if Settings.Affected[character] then return end
    
    Settings.Affected[character] = {}
    Settings.OriginalSizes[character] = {}
    
    for partName, shouldExpand in pairs(Settings.ExpansionParts) do
        if shouldExpand then
            local part = character:FindFirstChild(partName)
            if part then
                -- Salvar o tamanho original para restauração
                Settings.OriginalSizes[character][part] = part.Size
                
                -- Expandir a hitbox REAL (não apenas visual)
                Utils.tweenPart(part, Vector3.new(Settings.HeadSize, Settings.HeadSize, Settings.HeadSize), 0.3)
                
                -- Criar parte visual para representar a hitbox expandida
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
    
    -- Adicionar ao histórico
    if player then
        Utils.addToHistory(player.Name)
    else
        Utils.addToHistory("NPC: " .. character.Name)
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
                if Utils.isValidTarget(player, character) then
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
    for character, dataList in pairs(Settings.Affected) do
        if character.Parent then
            for _, data in ipairs(dataList) do
                if data.Part and data.Visual then
                    data.Visual.Size = Vector3.new(Settings.HeadSize, Settings.HeadSize, Settings.HeadSize)
                    data.Visual.Transparency = Settings.Transparency
                    data.Visual.Color = Settings.HitboxColor
                end
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
                    if Utils.isValidTarget(player, character) then
                        expandHitbox(character, player)
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
                if Utils.isValidTarget(nil, npc) then
                    expandHitbox(npc)
                end
                if Settings.ESPEnabled then
                    createESP(npc)
                end
            end
        end
    end
end

-- Função para restaurar tudo
local function restoreAll()
    for character in pairs(Settings.Affected) do
        restoreHitbox(character)
    end
    
    for _, folder in pairs(Settings.ESPFolders) do
        folder:Destroy()
    end
    
    Settings.Affected = {}
    Settings.ESPFolders = {}
end

-- Interface Rayfield principal
local Window
local MainTab, VisualTab, ESPTab, GameTab, InfoTab, HistoryTab

local function createMainUI()
    Window = Rayfield:CreateWindow({
        Name = "Astershun Hitbox v4.1",
        LoadingTitle = "Carregando sistema profissional...",
        LoadingSubtitle = "Desenvolvido por Astershun (Dev Oficial)",
        ConfigurationSaving = {
            Enabled = true,
            FolderName = "AstershunHitboxSystem",
            FileName = "ProConfig"
        },
        Discord = {
            Enabled = true,
            Invite = "discord.gg/astershun",
            RememberJoins = true
        },
        KeySystem = false,
    })

    MainTab = Window:CreateTab("Controles", 4483362458)
    VisualTab = Window:CreateTab("Hitbox", 9753762467)
    ESPTab = Window:CreateTab("ESP", 1234567890)
    GameTab = Window:CreateTab("Configurações", 9876543210)
    InfoTab = Window:CreateTab("Informações", 1122334455)
    HistoryTab = Window:CreateTab("Histórico", 5544332211)

    -- Contadores
    local playerCounter = MainTab:CreateLabel("Players Afetados: 0")
    local npcCounter = MainTab:CreateLabel("NPCs Afetados: 0")
    local espCounter = MainTab:CreateLabel("ESPs Ativos: 0")

    -- Atualizar contadores
    local function updateCounters()
        local players = 0
        local npcs = 0
        local esps = 0
        
        for character in pairs(Settings.Affected) do
            if Players:GetPlayerFromCharacter(character) then
                players = players + 1
            else
                npcs = npcs + 1
            end
        end
        
        for _ in pairs(Settings.ESPFolders) do
            esps = esps + 1
        end
        
        playerCounter:Set("Players Afetados: " .. players)
        npcCounter:Set("NPCs Afetados: " .. npcs)
        espCounter:Set("ESPs Ativos: " .. esps)
    end

    -- Controles principais
    local hitboxToggle = MainTab:CreateToggle({
        Name = "Ativar Hitbox Expansível",
        CurrentValue = false,
        Callback = function(value)
            Settings.HitboxEnabled = value
            if not value then
                restoreAll()
            else
                monitorCharacters()
            end
        end,
    })

    local espToggle = MainTab:CreateToggle({
        Name = "Ativar Sistema de ESP",
        CurrentValue = true,
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

    MainTab:CreateButton({
        Name = "Restaurar Tudo",
        Callback = function()
            restoreAll()
            Rayfield:Notify({
                Title = "Sistema Restaurado",
                Content = "Todas as hitboxes e ESPs foram resetados",
                Duration = 3,
                Image = 4483362458,
            })
        end
    })

    -- Configurações de hitbox
    VisualTab:CreateSlider({
        Name = "Tamanho da Hitbox",
        Range = {1, 15},
        Increment = 0.5,
        Suffix = "Estudos",
        CurrentValue = Settings.HeadSize,
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
        Callback = function(value)
            Settings.Transparency = value
            updateHitboxes()
        end,
    })

    VisualTab:CreateColorPicker({
        Name = "Cor da Hitbox",
        Color = Settings.HitboxColor,
        Callback = function(value)
            Settings.HitboxColor = value
            updateHitboxes()
        end
    })

    -- Seleção de partes
    VisualTab:CreateToggle({
        Name = "Cabeça",
        CurrentValue = true,
        Callback = function(value)
            Settings.ExpansionParts.Head = value
            monitorCharacters()
        end,
    })

    VisualTab:CreateToggle({
        Name = "Torso",
        CurrentValue = false,
        Callback = function(value)
            Settings.ExpansionParts.Torso = value
            monitorCharacters()
        end,
    })

    VisualTab:CreateToggle({
        Name = "Braço Esquerdo",
        CurrentValue = false,
        Callback = function(value)
            Settings.ExpansionParts.LeftArm = value
            monitorCharacters()
        end,
    })

    VisualTab:CreateToggle({
        Name = "Braço Direito",
        CurrentValue = false,
        Callback = function(value)
            Settings.ExpansionParts.RightArm = value
            monitorCharacters()
        end,
    })

    -- Configurações ESP
    ESPTab:CreateColorPicker({
        Name = "Cor para Inimigos",
        Color = Settings.ESPColorEnemy,
        Callback = function(value)
            Settings.ESPColorEnemy = value
        end
    })

    ESPTab:CreateColorPicker({
        Name = "Cor para Aliados",
        Color = Settings.ESPColorAlly,
        Callback = function(value)
            Settings.ESPColorAlly = value
        end
    })

    ESPTab:CreateColorPicker({
        Name = "Cor para Neutros",
        Color = Settings.ESPColorNeutral,
        Callback = function(value)
            Settings.ESPColorNeutral = value
        end
    })

    ESPTab:CreateSlider({
        Name = "Taxa de Atualização",
        Range = {0.05, 1},
        Increment = 0.05,
        Suffix = "segundos",
        CurrentValue = Settings.UpdateRate,
        Callback = function(value)
            Settings.UpdateRate = value
        end,
    })

    -- Configurações de equipe
    GameTab:CreateToggle({
        Name = "Verificar Equipe",
        CurrentValue = true,
        Callback = function(value)
            Settings.TeamCheck = value
            monitorCharacters()
        end,
    })

    GameTab:CreateToggle({
        Name = "Ignorar Amigos",
        CurrentValue = true,
        Callback = function(value)
            Settings.FriendsCheck = value
            Utils.updateFriendList()
            monitorCharacters()
        end,
    })

    GameTab:CreateToggle({
        Name = "Detecção Automática de Jogo",
        CurrentValue = true,
        Callback = function(value)
            Settings.AutoDetectGame = value
        end,
    })

    GameTab:CreateToggle({
        Name = "Aplicar em Players",
        CurrentValue = true,
        Callback = function(value)
            Settings.TargetPlayers = value
            monitorCharacters()
        end,
    })

    GameTab:CreateToggle({
        Name = "Aplicar em NPCs",
        CurrentValue = true,
        Callback = function(value)
            Settings.TargetNPCs = value
            monitorCharacters()
        end,
    })

    -- Whitelist/Blacklist
    local whitelistInput = GameTab:CreateInput({
        Name = "Adicionar à Whitelist",
        PlaceholderText = "Nome do jogador",
        RemoveTextAfterFocusLost = true,
        Callback = function(text)
            if text ~= "" then
                table.insert(Settings.Whitelist, text)
                Rayfield:Notify({
                    Title = "Whitelist Atualizada",
                    Content = text .. " adicionado à whitelist",
                    Duration = 3,
                })
            end
        end,
    })

    local blacklistInput = GameTab:CreateInput({
        Name = "Adicionar à Blacklist",
        PlaceholderText = "Nome do jogador",
        RemoveTextAfterFocusLost = true,
        Callback = function(text)
            if text ~= "" then
                table.insert(Settings.Blacklist, text)
                Rayfield:Notify({
                    Title = "Blacklist Atualizada",
                    Content = text .. " adicionado à blacklist",
                    Duration = 3,
                })
            end
        end,
    })

    -- Tab de Informações
    InfoTab:CreateLabel(DeveloperInfo.Message)
    InfoTab:CreateLabel("Experiência: " .. DeveloperInfo.Experience)
    InfoTab:CreateLabel("Planos Futuros: " .. DeveloperInfo.FuturePlans)

    InfoTab:CreateParagraph("Sobre o Sistema", [[
O Astershun Hitbox v4.1 é um sistema premium que modifica REALMENTE as hitboxes dos personagens.

Recursos principais:
✅ Expansão física real de hitboxes
✅ Sistema de ESP completo com barras de saúde
✅ Controle granular sobre partes do corpo
✅ Sistema de autenticação simplificado
✅ Histórico de alvos modificados
✅ Whitelist/Blacklist personalizada
]])

    InfoTab:CreateButton({
        Name = "Mostrar Créditos",
        Callback = function()
            Rayfield:Notify({
                Title = "Créditos",
                Content = "Astershun Hitbox v4.1\nDesenvolvido por: Astershun\nDev Oficial",
                Duration = 10,
                Image = 4483362458,
                Actions = {
                    Ignore = {
                        Name = "Fechar",
                        Callback = function() end
                    },
                },
            })
        end,
    })

    -- Tab de Histórico
    local historyLabels = {}
    for i = 1, 5 do
        historyLabels[i] = HistoryTab:CreateLabel(i .. ". Nenhum alvo registrado")
    end

    local function updateHistoryDisplay()
        for i = 1, 5 do
            if Settings.TargetHistory[i] then
                historyLabels[i]:Set(i .. ". " .. Settings.TargetHistory[i])
            else
                historyLabels[i]:Set(i .. ". Nenhum alvo registrado")
            end
        end
    end

    HistoryTab:CreateButton({
        Name = "Atualizar Histórico",
        Callback = updateHistoryDisplay
    })

    -- Atualizações otimizadas
    local updateConnection
    local function startUpdateLoop()
        if updateConnection then
            updateConnection:Disconnect()
        end
        
        updateConnection = RunService.Heartbeat:Connect(function()
            updateCounters()
            updateHistoryDisplay()
            
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
            
            -- Esperar o tempo configurado antes da próxima atualização
            wait(Settings.UpdateRate)
        end)
    end

    -- Inicialização
    Utils.updateFriendList()
    startUpdateLoop()
    
    Rayfield:Notify({
        Title = "Astershun Hitbox v4.1",
        Content = "Sistema ativado com sucesso!\nCriado por: Astershun",
        Duration = 8,
        Image = 4483362458,
    })

    print("Astershun Hitbox v4.1 by Astershun carregado!")
end

-- Sistema de autenticação simplificado
local function authenticate()
    -- Criar janela de autenticação temporária
    local AuthWindow = Rayfield:CreateWindow({
        Name = "Astershun Hitbox - Autenticação",
        LoadingTitle = "Verificando acesso...",
        LoadingSubtitle = "Sistema desenvolvido por Astershun",
        ConfigurationSaving = {Enabled = false},
        Discord = {Enabled = false},
        KeySystem = false,
    })
    
    local keyInput = AuthWindow:CreateInput({
        Name = "Chave de Acesso",
        PlaceholderText = "Insira 'teste' para continuar",
        RemoveTextAfterFocusLost = false,
        Callback = function() end
    })
    
    AuthWindow:CreateLabel("Chave padrão: 'teste'")
    
    AuthWindow:CreateButton({
        Name = "Verificar Chave",
        Callback = function()
            if keyInput.Text == "teste" then
                -- Fechar janela de autenticação
                Rayfield:Destroy()
                -- Criar UI principal
                createMainUI()
            else
                Rayfield:Notify({
                    Title = "Falha na Autenticação",
                    Content = "Chave inválida! Tente novamente",
                    Duration = 3,
                    Image = 4483362458,
                })
            end
        end
    })
end

-- Inicialização do sistema
if Settings.KeySystem.Enabled then
    authenticate()
else
    createMainUI()
end