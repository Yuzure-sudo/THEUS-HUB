-- ASTERSHUN HUB v2.0
-- Desenvolvido por: Astershun (Dev Oficial)

-- Carregar Kavo UI
local Kavo = loadstring(game:HttpGet("https://pastebin.com/raw/vff1bQ9F"))()
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

-- Criar notificação personalizada
local function Notify(title, content, duration)
    game.StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = content,
        Duration = duration or 5
    })
end

-- Interface Kavo UI
local function createUI()
    -- Criar janela principal
    local Window = Kavo.CreateLib("Astershun Hub v2.0", "BloodTheme")
    
    -- Abas
    local HomeTab = Window:NewTab("🏠 Home")
    local HitboxTab = Window:NewTab("🎯 Hitbox")
    local ESPTab = Window:NewTab("👁️ ESP")
    local ConfigTab = Window:NewTab("⚙️ Configurações")
    local InfoTab = Window:NewTab("ℹ️ Informações")
    
    -- Seção Home
    local HomeSection = HomeTab:NewSection("Bem-vindo ao Astershun Hub!")
    HomeSection:NewLabel("Sistema profissional desenvolvido por Astershun com foco em performance e usabilidade.")
    
    local StatusSection = HomeTab:NewSection("Status do Sistema")
    
    local hitboxStatusText = "Hitbox: " .. (Settings.HitboxEnabled and "ATIVADO" or "DESATIVADO")
    local HitboxStatus = StatusSection:NewLabel(hitboxStatusText)
    HitboxStatus.TextColor3 = Settings.HitboxEnabled and Color3.fromRGB(50, 255, 100) or Color3.fromRGB(255, 50, 50)
    
    local espStatusText = "ESP: " .. (Settings.ESPEnabled and "ATIVADO" or "DESATIVADO")
    local ESPStatus = StatusSection:NewLabel(espStatusText)
    ESPStatus.TextColor3 = Settings.ESPEnabled and Color3.fromRGB(50, 255, 100) or Color3.fromRGB(255, 50, 50)
    
    local ControlSection = HomeTab:NewSection("Controles Rápidos")
    
    ControlSection:NewButton("Abrir Configurações de Hitbox", "", function()
        Window:ChangeTab(HitboxTab)
    end)
    
    ControlSection:NewButton("Abrir Configurações de ESP", "", function()
        Window:ChangeTab(ESPTab)
    end)
    
    -- Seção Hitbox
    local HitboxMainSection = HitboxTab:NewSection("Configurações de Hitbox")
    
    local HitboxToggle = HitboxMainSection:NewToggle("Ativar Hitbox Expansível", "", function(value)
        Settings.HitboxEnabled = value
        HitboxStatus:Update("Hitbox: " .. (value and "ATIVADO" or "DESATIVADO"))
        HitboxStatus.TextColor3 = value and Color3.fromRGB(50, 255, 100) or Color3.fromRGB(255, 50, 50)
        
        if not value then
            restoreAll()
        end
    end)
    HitboxToggle:Set(Settings.HitboxEnabled)
    
    local SizeSlider = HitboxMainSection:NewSlider("Tamanho da Hitbox", "Estudos", 150, Settings.HeadSize, function(value)
        Settings.HeadSize = value
    end)
    
    local TransparencySlider = HitboxMainSection:NewSlider("Transparência", "%", 100, Settings.Transparency * 100, function(value)
        Settings.Transparency = value / 100
    end)
    
    HitboxMainSection:NewColorPicker("Cor da Hitbox", Settings.HitboxColor, function(color)
        Settings.HitboxColor = color
    end)
    
    HitboxMainSection:NewButton("Restaurar Todas as Hitboxes", "", function()
        restoreAll()
        Notify("Hitboxes Restauradas", "Todas as hitboxes foram resetadas para o estado original", 3)
    end)
    
    -- Seção ESP
    local ESPMainSection = ESPTab:NewSection("Configurações de ESP")
    
    local ESPToggle = ESPMainSection:NewToggle("Ativar Sistema de ESP", "", function(value)
        Settings.ESPEnabled = value
        ESPStatus:Update("ESP: " .. (value and "ATIVADO" or "DESATIVADO"))
        ESPStatus.TextColor3 = value and Color3.fromRGB(50, 255, 100) or Color3.fromRGB(255, 50, 50)
        
        if not value then
            clearESP()
        end
    end)
    ESPToggle:Set(Settings.ESPEnabled)
    
    ESPMainSection:NewColorPicker("Cor para Inimigos", Color3.fromRGB(255, 50, 50), function(color)
        -- Implementar na função updateESP
    end)
    
    ESPMainSection:NewColorPicker("Cor para Aliados", Color3.fromRGB(50, 255, 100), function(color)
        -- Implementar na função updateESP
    end)
    
    -- Seção Configurações
    local TargetSection = ConfigTab:NewSection("Configurações de Alvos")
    
    local PlayersToggle = TargetSection:NewToggle("Ativar para Players", "", function(value)
        Settings.TargetPlayers = value
    end)
    PlayersToggle:Set(Settings.TargetPlayers)
    
    local NPCsToggle = TargetSection:NewToggle("Ativar para NPCs", "", function(value)
        Settings.TargetNPCs = value
    end)
    NPCsToggle:Set(Settings.TargetNPCs)
    
    local FilterSection = ConfigTab:NewSection("Filtros Avançados")
    
    local TeamCheckToggle = FilterSection:NewToggle("Verificar Equipe", "", function(value)
        Settings.TeamCheck = value
    end)
    TeamCheckToggle:Set(Settings.TeamCheck)
    
    local FriendsToggle = FilterSection:NewToggle("Ignorar Amigos", "", function(value)
        Settings.FriendsCheck = value
        updateFriendList()
    end)
    FriendsToggle:Set(Settings.FriendsCheck)
    
    -- Seção Informações
    local DevSection = InfoTab:NewSection("Sobre o Desenvolvedor")
    DevSection:NewLabel("Nome: " .. DeveloperInfo.Name)
    DevSection:NewLabel("Experiência: " .. DeveloperInfo.Experience)
    
    local MessageSection = InfoTab:NewSection("Mensagem do Desenvolvedor")
    MessageSection:NewLabel(DeveloperInfo.Message)
    
    local PlansSection = InfoTab:NewSection("Planos Futuros")
    PlansSection:NewLabel(DeveloperInfo.FuturePlans)
    
    InfoTab:NewButton("Mostrar Créditos", "", function()
        Notify("Créditos", "Astershun Hub v2.0\n\nDesenvolvido por: Astershun\nDev Oficial\n\nTodos os direitos reservados", 8)
    end)
    
    -- Notificação de inicialização
    Notify("Astershun Hub Carregado", "Bem-vindo ao sistema profissional!\nDesenvolvido por Astershun com muito esforço", 6)
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

print("Astershun Hub carregado com sucesso usando Kavo UI!")