-- ASTERSHUN HUB v2.0
-- Desenvolvido por: Astershun (Dev Oficial)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
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

-- Informações sobre o desenvolvedor
local DeveloperInfo = {
    Name = "Astershun",
    Experience = "Novo com programação",
    Message = "Fiz este Hub com muito esforço, dando o meu melhor!",
    FuturePlans = "Em breve: Mais scripts e suporte para vários jogos"
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

-- Interface Rayfield com design personalizado
local function createUI()
    -- Tela de carregamento personalizada
    Rayfield:SetConfigurationSaving({
        Enabled = true,
        FolderName = "AstershunHub",
        FileName = "Config"
    })
    
    Rayfield:SetWatermark("Astershun Hub v2.0 | Desenvolvido por Astershun")
    
    -- Janela principal
    local Window = Rayfield:CreateWindow({
        Name = "Astershun Hub",
        LoadingTitle = "Carregando Astershun Hub...",
        LoadingSubtitle = "Desenvolvido por Astershun com muito esforço",
        ConfigurationSaving = {
            Enabled = true,
            FolderName = "AstershunHub",
            FileName = "Config"
        },
        Discord = {
            Enabled = false
        },
        KeySystem = {
            Enabled = true,
            Key = "teste",
            Title = "Astershun Hub - Autenticação",
            Subtitle = "Insira sua chave de acesso",
            Note = "Chave padrão: 'teste'",
            FileName = "AstershunKey",
            SaveKey = true,
            GrabKeyFromSite = false,
        }
    })
    
    -- Abas
    local HomeTab = Window:CreateTab("🏠  Home", 13337258670) -- Ícone de coroa
    local HitboxTab = Window:CreateTab("🎯  Hitbox", 13337258670)
    local ESPTab = Window:CreateTab("👁️  ESP", 13337258670)
    local ConfigTab = Window:CreateTab("⚙️  Configurações", 13337258670)
    local InfoTab = Window:CreateTab("ℹ️  Informações", 13337258670)
    
    -- Seção Home
    HomeTab:CreateSection("Bem-vindo ao Astershun Hub!")
    
    local Description = HomeTab:CreateLabel("Sistema profissional desenvolvido por Astershun com foco em performance e usabilidade.")
    Description:SetTextSize(14)
    
    HomeTab:CreateSection("Status do Sistema")
    
    local HitboxStatus = HomeTab:CreateLabel("Hitbox: " .. (Settings.HitboxEnabled and "ATIVADO" or "DESATIVADO"))
    HitboxStatus:SetTextColor(Settings.HitboxEnabled and Color3.fromRGB(50, 255, 100) or Color3.fromRGB(255, 50, 50))
    
    local ESPStatus = HomeTab:CreateLabel("ESP: " .. (Settings.ESPEnabled and "ATIVADO" or "DESATIVADO"))
    ESPStatus:SetTextColor(Settings.ESPEnabled and Color3.fromRGB(50, 255, 100) or Color3.fromRGB(255, 50, 50))
    
    HomeTab:CreateSection("Controles Rápidos")
    
    HomeTab:CreateButton({
        Name = "Abrir Configurações de Hitbox",
        Callback = function()
            Window:SelectTab(HitboxTab)
        end
    })
    
    HomeTab:CreateButton({
        Name = "Abrir Configurações de ESP",
        Callback = function()
            Window:SelectTab(ESPTab)
        end
    })
    
    -- Seção Hitbox
    HitboxTab:CreateSection("Configurações de Hitbox")
    
    local HitboxToggle = HitboxTab:CreateToggle({
        Name = "Ativar Hitbox Expansível",
        CurrentValue = Settings.HitboxEnabled,
        Flag = "HitboxToggle",
        Callback = function(value)
            Settings.HitboxEnabled = value
            HitboxStatus:Set("Hitbox: " .. (value and "ATIVADO" or "DESATIVADO"))
            HitboxStatus:SetTextColor(value and Color3.fromRGB(50, 255, 100) or Color3.fromRGB(255, 50, 50))
            
            if not value then
                restoreAll()
            end
        end,
    })
    
    local SizeSlider = HitboxTab:CreateSlider({
        Name = "Tamanho da Hitbox",
        Range = {1, 15},
        Increment = 0.5,
        Suffix = "Estudos",
        CurrentValue = Settings.HeadSize,
        Flag = "HeadSize",
        Callback = function(value)
            Settings.HeadSize = value
        end,
    })
    
    local TransparencySlider = HitboxTab:CreateSlider({
        Name = "Transparência",
        Range = {0, 1},
        Increment = 0.05,
        Suffix = "%",
        CurrentValue = Settings.Transparency,
        Flag = "Transparency",
        Callback = function(value)
            Settings.Transparency = value
        end,
    })
    
    local ColorPicker = HitboxTab:CreateColorPicker({
        Name = "Cor da Hitbox",
        Color = Settings.HitboxColor,
        Flag = "HitboxColor",
        Callback = function(value)
            Settings.HitboxColor = value
        end
    })
    
    HitboxTab:CreateButton({
        Name = "Restaurar Todas as Hitboxes",
        Callback = function()
            restoreAll()
            Rayfield:Notify({
                Title = "Hitboxes Restauradas",
                Content = "Todas as hitboxes foram resetadas para o estado original",
                Duration = 3,
                Image = 13337258670,
            })
        end
    })
    
    -- Seção ESP
    ESPTab:CreateSection("Configurações de ESP")
    
    local ESPToggle = ESPTab:CreateToggle({
        Name = "Ativar Sistema de ESP",
        CurrentValue = Settings.ESPEnabled,
        Flag = "ESPToggle",
        Callback = function(value)
            Settings.ESPEnabled = value
            ESPStatus:Set("ESP: " .. (value and "ATIVADO" or "DESATIVADO"))
            ESPStatus:SetTextColor(value and Color3.fromRGB(50, 255, 100) or Color3.fromRGB(255, 50, 50))
            
            if not value then
                clearESP()
            end
        end,
    })
    
    ESPTab:CreateColorPicker({
        Name = "Cor para Inimigos",
        Color = Color3.fromRGB(255, 50, 50),
        Flag = "ESPEnemyColor",
        Callback = function(value)
            -- Implementar na função updateESP
        end
    })
    
    ESPTab:CreateColorPicker({
        Name = "Cor para Aliados",
        Color = Color3.fromRGB(50, 255, 100),
        Flag = "ESPAllyColor",
        Callback = function(value)
            -- Implementar na função updateESP
        end
    })
    
    -- Seção Configurações
    ConfigTab:CreateSection("Configurações de Alvos")
    
    ConfigTab:CreateToggle({
        Name = "Ativar para Players",
        CurrentValue = Settings.TargetPlayers,
        Flag = "TargetPlayers",
        Callback = function(value)
            Settings.TargetPlayers = value
        end,
    })
    
    ConfigTab:CreateToggle({
        Name = "Ativar para NPCs",
        CurrentValue = Settings.TargetNPCs,
        Flag = "TargetNPCs",
        Callback = function(value)
            Settings.TargetNPCs = value
        end,
    })
    
    ConfigTab:CreateSection("Filtros Avançados")
    
    ConfigTab:CreateToggle({
        Name = "Verificar Equipe",
        CurrentValue = Settings.TeamCheck,
        Flag = "TeamCheck",
        Callback = function(value)
            Settings.TeamCheck = value
        end,
    })
    
    ConfigTab:CreateToggle({
        Name = "Ignorar Amigos",
        CurrentValue = Settings.FriendsCheck,
        Flag = "FriendsCheck",
        Callback = function(value)
            Settings.FriendsCheck = value
            updateFriendList()
        end,
    })
    
    -- Seção Informações
    InfoTab:CreateSection("Sobre o Desenvolvedor")
    
    InfoTab:CreateLabel("Nome: " .. DeveloperInfo.Name)
    InfoTab:CreateLabel("Experiência: " .. DeveloperInfo.Experience)
    
    InfoTab:CreateSection("Mensagem do Desenvolvedor")
    
    local DevMessage = InfoTab:CreateLabel(DeveloperInfo.Message)
    DevMessage:SetTextSize(14)
    
    InfoTab:CreateSection("Planos Futuros")
    
    local FuturePlans = InfoTab:CreateLabel(DeveloperInfo.FuturePlans)
    FuturePlans:SetTextSize(14)
    
    InfoTab:CreateButton({
        Name = "Mostrar Créditos",
        Callback = function()
            Rayfield:Notify({
                Title = "Créditos",
                Content = "Astershun Hub v2.0\n\nDesenvolvido por: Astershun\nDev Oficial\n\nTodos os direitos reservados",
                Duration = 8,
                Image = 13337258670,
            })
        end
    })
    
    -- Notificação de inicialização
    Rayfield:Notify({
        Title = "Astershun Hub Carregado",
        Content = "Bem-vindo ao sistema profissional!\nDesenvolvido por Astershun com muito esforço",
        Duration = 6,
        Image = 13337258670,
    })
end

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
updateFriendList()
createUI()

print("Astershun Hub carregado com sucesso!")