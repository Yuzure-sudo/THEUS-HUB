-- Los CocoFantos Hub - Solo Leveling Arise
-- Desenvolvido por Theus para 3 gays
-- Versão: Los Concafos Premium

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- ====== SISTEMA DE SEGURANÇA ======
local Banidos = {548245499, 2318524722, 3564923852}
local player = game.Players.LocalPlayer

for _, id in ipairs(Banidos) do
    if player.UserId == id then
        player:Kick("Você está banido de usar este script")
        return
    end
end

-- ====== CONFIGURAÇÃO DA JANELA PRINCIPAL ======
local Window = Fluent:CreateWindow({
    Title = "🌀 Los CocoFantos",
    SubTitle = "Solo Leveling Arise",
    TabWidth = 100,
    Size = UDim2.fromOffset(500, 450),
    Acrylic = true,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.RightControl,
    Minimizable = true
})

-- Adicionar logo personalizado
Window.Root.TitleBar.Logo.Image = "rbxassetid://7072718362"

-- ====== ABAS PRINCIPAIS ======
local Tabs = {
    Menu = Window:AddTab({ Title = "Menu", Icon = "home" }),
    Autofarm = Window:AddTab({ Title = "AutoFarm", Icon = "repeat" }),
    Teleporte = Window:AddTab({ Title = "Teleporte", Icon = "map-pin" }),
    Pets = Window:AddTab({ Title = "Pets", Icon = "paw-print" }),
    Eventos = Window:AddTab({ Title = "Eventos", Icon = "calendar" }),
    Configs = Window:AddTab({ Title = "Configurações", Icon = "settings" }),
    Creditos = Window:AddTab({ Title = "Créditos", Icon = "book" })
}

-- ====== ABA MENU ======
local MenuSection = Tabs.Menu:AddSection("Bem-vindo", {
    Title = "🌀 Los CocoFantos Hub Premium",
    Content = "Script mobile-friendly by Theus"
})

local btnAtivar = MenuSection:AddButton({
    Title = "ATIVAR TODAS AS FUNÇÕES",
    Description = "Inicia todos os sistemas automáticos",
    Callback = function()
        -- Ativar funções principais
        getgenv().AutoFarmBoss = true
        getgenv().AutoFarmMobs = true
        getgenv().AutoDungeon = true
        getgenv().AutoMount = true
        
        Fluent:Notify({
            Title = "Sistema Ativado",
            Content = "Todas as funções premium foram iniciadas!",
            Duration = 3
        })
    end
})

-- Estilização especial do botão
btnAtivar.Button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
btnAtivar.Button.BackgroundTransparency = 0.2
local glow = Instance.new("UIStroke", btnAtivar.Button)
glow.Color = Color3.fromRGB(0, 255, 255)
glow.Thickness = 2
glow.Transparency = 0.5

-- ====== ABA AUTOFARM ======
local farmSection = Tabs.Autofarm:AddSection("Farm Automático")

-- AutoFarm Boss
farmSection:AddToggle("AutoFarmBoss", {
    Title = "👑 AutoFarm Boss",
    Default = false,
    Callback = function(state)
        getgenv().AutoFarmBoss = state
        if state then startBossFarm() end
    end
})

-- AutoFarm Mobs
farmSection:AddToggle("AutoFarmMobs", {
    Title = "👾 AutoFarm Mobs",
    Default = false,
    Callback = function(state)
        getgenv().AutoFarmMobs = state
        if state then startMobFarm() end
    end
})

-- Kill Aura
farmSection:AddToggle("KillAura", {
    Title = "⚔️ Kill Aura",
    Default = false,
    Callback = function(state)
        getgenv().KillAura = state
        if state then activateKillAura() end
    end
})

-- Auto Arise
farmSection:AddToggle("AutoArise", {
    Title = "✨ Auto Arise",
    Default = false,
    Callback = function(state)
        getgenv().AutoArise = state
        if state then startAutoArise() end
    end
})

-- Auto Destroy
farmSection:AddToggle("AutoDestroy", {
    Title = "💥 Auto Destroy",
    Default = false,
    Callback = function(state)
        getgenv().AutoDestroy = state
        if state then startAutoDestroy() end
    end
})

-- Farm Evento
farmSection:AddToggle("FarmEvento", {
    Title = "🎪 Farm Evento",
    Default = false,
    Callback = function(state)
        getgenv().FarmEvento = state
        if state then startEventFarm() end
    end
})

-- ====== FUNÇÕES AUTOFARM ======
function startBossFarm()
    spawn(function()
        while getgenv().AutoFarmBoss do
            local bosses = workspace.__Main.__Enemies.Client:GetChildren()
            for _, boss in ipairs(bosses) do
                if boss.Name:find("Boss") and boss:FindFirstChild("HumanoidRootPart") then
                    -- Teleportar para o boss
                    player.Character.HumanoidRootPart.CFrame = boss.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
                    task.wait(1)
                    -- Atacar o boss
                    game:GetService("ReplicatedStorage").BridgeNet2.dataRemoteEvent:FireServer({
                        {Event = "PunchAttack", Enemy = boss.Name},
                        "\4"
                    })
                end
            end
            task.wait(2)
        end
    end)
end

function startMobFarm()
    spawn(function()
        while getgenv().AutoFarmMobs do
            local enemies = workspace.__Main.__Enemies.Client:GetChildren()
            for _, enemy in ipairs(enemies) do
                if enemy:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                    task.wait(0.5)
                    game:GetService("ReplicatedStorage").BridgeNet2.dataRemoteEvent:FireServer({
                        {Event = "PunchAttack", Enemy = enemy.Name},
                        "\4"
                    })
                end
            end
            task.wait(1)
        end
    end)
end

function activateKillAura()
    spawn(function()
        while getgenv().KillAura do
            local enemies = workspace.__Main.__Enemies.Client:GetChildren()
            for _, enemy in ipairs(enemies) do
                if (enemy.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude < 30 then
                    game:GetService("ReplicatedStorage").BridgeNet2.dataRemoteEvent:FireServer({
                        {Event = "PunchAttack", Enemy = enemy.Name},
                        "\4"
                    })
                end
            end
            task.wait(0.2)
        end
    end)
end

function startAutoArise()
    spawn(function()
        while getgenv().AutoArise do
            local enemies = workspace.__Main.__Enemies.Client:GetChildren()
            for _, enemy in ipairs(enemies) do
                local healthBar = enemy:FindFirstChild("HealthBar")
                if healthBar and healthBar.Main.Bar.Amount.Text == "0" then
                    game:GetService("ReplicatedStorage").BridgeNet2.dataRemoteEvent:FireServer({
                        {Event = "EnemyCapture", Enemy = enemy.Name},
                        "\4"
                    })
                end
            end
            task.wait(1)
        end
    end)
end

function startAutoDestroy()
    spawn(function()
        while getgenv().AutoDestroy do
            local enemies = workspace.__Main.__Enemies.Client:GetChildren()
            for _, enemy in ipairs(enemies) do
                game:GetService("ReplicatedStorage").BridgeNet2.dataRemoteEvent:FireServer({
                    {Event = "EnemyDestroy", Enemy = enemy.Name},
                    "\4"
                })
            end
            task.wait(1)
        end
    end)
end

-- ====== ABA TELEPORTE ======
local teleSection = Tabs.Teleporte:AddSection("Teleportes Rápidos")

-- Lista de locais para teleporte
local locations = {
    ["👑 Bosses"] = {
        "Rei Orc",
        "Dragão de Gelo",
        "Lich Sombrio"
    },
    ["🛡️ SafeZones"] = {
        "Base Inicial",
        "Vila Segura",
        "Torre dos Caçadores"
    },
    ["🏰 Especiais"] = {
        "Guild Hall",
        "Jeju Island",
        "Castelo Negro"
    },
    ["📍 Spawns"] = {
        "Spawn Norte",
        "Spawn Sul",
        "Spawn Central"
    }
}

-- Dropdown para seleção de categoria
teleSection:AddDropdown("Categoria", {
    Title = "Selecionar Categoria",
    Values = {"👑 Bosses", "🛡️ SafeZones", "🏰 Especiais", "📍 Spawns"},
    Default = "👑 Bosses",
    Callback = function(value)
        teleSection.DropdownLoc:SetValues(locations[value])
    end
})

-- Dropdown para seleção de local
local locDropdown = teleSection:AddDropdown("Loc", {
    Title = "Selecionar Local",
    Values = locations["👑 Bosses"],
    Default = "Rei Orc"
})

-- Botão de teleporte
teleSection:AddButton({
    Title = "➡️ TELEPORTAR",
    Callback = function()
        local selectedLocation = locDropdown.Value
        Fluent:Notify({
            Title = "Teleportando",
            Content = "Indo para: " .. selectedLocation,
            Duration = 3
        })
        
        -- Lógica de teleporte seria implementada aqui
        -- Exemplo: TeleportToLocation(selectedLocation)
    end
})

-- ====== ABA PETS ======
local petsSection = Tabs.Pets:AddSection("Gerenciamento de Pets")

petsSection:AddToggle("AutoEquipBest", {
    Title = "⭐ Auto Equipar Melhor Pet",
    Default = false,
    Callback = function(state)
        getgenv().AutoEquipBest = state
        if state then equipBestPet() end
    end
})

petsSection:AddToggle("AutoEquipOnDeath", {
    Title = "💀 Auto Equipar ao Morrer",
    Default = false
})

petsSection:AddToggle("AutoAttackPet", {
    Title = "⚔️ Auto Attack com Pet",
    Default = false,
    Callback = function(state)
        getgenv().AutoAttackPet = state
        if state then startPetAttack() end
    end
})

petsSection:AddToggle("AutoClaimPets", {
    Title = "🎁 Auto Claim de Pets",
    Default = false
})

-- Funções de Pets
function equipBestPet()
    spawn(function()
        while getgenv().AutoEquipBest do
            -- Lógica para encontrar e equipar o melhor pet
            game:GetService("ReplicatedStorage").BridgeNet2.dataRemoteEvent:FireServer({
                {Event = "EquipBestPet"},
                "\n"
            })
            task.wait(10) -- Verificar a cada 10 segundos
        end
    end)
end

function startPetAttack()
    spawn(function()
        while getgenv().AutoAttackPet do
            local enemies = workspace.__Main.__Enemies.Client:GetChildren()
            for _, enemy in ipairs(enemies) do
                game:GetService("ReplicatedStorage").BridgeNet2.dataRemoteEvent:FireServer({
                    {Event = "PetAttack", Enemy = enemy.Name},
                    "\t"
                })
            end
            task.wait(1)
        end
    end)
end

-- ====== ABA EVENTOS ======
local eventosSection = Tabs.Eventos:AddSection("Eventos Automáticos")

eventosSection:AddToggle("AutoDungeon", {
    Title = "🏰 Auto Dungeon",
    Default = false,
    Callback = function(state)
        getgenv().AutoDungeon = state
        if state then startAutoDungeon() end
    end
})

eventosSection:AddToggle("AutoMount", {
    Title = "🐴 Auto Mount",
    Default = false,
    Callback = function(state)
        getgenv().AutoMount = state
        if state then startAutoMount() end
    end
})

eventosSection:AddToggle("AutoClaimEvent", {
    Title = "🎁 Auto Claim Evento",
    Default = false
})

eventosSection:AddToggle("AutoDaily", {
    Title = "📅 Auto Daily",
    Default = false,
    Callback = function(state)
        getgenv().AutoDaily = state
        if state then claimDaily() end
    end
})

eventosSection:AddToggle("AutoRaid", {
    Title = "⚔️ Auto Raid",
    Default = false,
    Callback = function(state)
        getgenv().AutoRaid = state
        if state then startAutoRaid() end
    end
})

-- Funções de Eventos
function startAutoDungeon()
    spawn(function()
        while getgenv().AutoDungeon do
            local dungeons = workspace.__Main.__Dungeon:GetChildren()
            for _, dungeon in ipairs(dungeons) do
                if dungeon:IsA("Model") then
                    -- Entrar na dungeon
                    game:GetService("ReplicatedStorage").BridgeNet2.dataRemoteEvent:FireServer({
                        {Event = "JoinDungeon", Dungeon = dungeon.Name},
                        "\n"
                    })
                    task.wait(5)
                end
            end
            task.wait(10)
        end
    end)
end

function startAutoMount()
    spawn(function()
        while getgenv().AutoMount do
            local mounts = workspace.__Extra.__Appear:GetChildren()
            if #mounts > 0 then
                local mount = mounts[1]
                if mount:FindFirstChild("HumanoidRootPart") then
                    -- Teleportar para a montaria
                    player.Character.HumanoidRootPart.CFrame = mount.HumanoidRootPart.CFrame
                    task.wait(1)
                    -- Montar
                    fireproximityprompt(mount:FindFirstChildWhichIsA("ProximityPrompt"))
                end
            end
            task.wait(10)
        end
    end)
end

function claimDaily()
    spawn(function()
        while getgenv().AutoDaily do
            game:GetService("ReplicatedStorage").BridgeNet2.dataRemoteEvent:FireServer({
                {Event = "ClaimDaily"},
                "\n"
            })
            task.wait(86400) -- 24 horas
        end
    end)
end

-- ====== ABA CONFIGURAÇÕES ======
local configSection = Tabs.Configs:AddSection("Configurações Gerais")

-- Anti-AFK
configSection:AddToggle("AntiAFK", {
    Title = "🔒 Anti-AFK",
    Default = true,
    Callback = function(state)
        if state then
            local vu = game:GetService("VirtualUser")
            game:GetService("Players").LocalPlayer.Idled:Connect(function()
                vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end)
        end
    end
})

-- Hitbox Expander
configSection:AddToggle("ExpandHitbox", {
    Title = "🎯 Expandir Hitbox",
    Default = false,
    Callback = function(state)
        local newSize = state and Vector3.new(15, 15, 15) or Vector3.new(5, 5, 5)
        for _, enemy in ipairs(workspace.__Main.__Enemies.Client:GetChildren()) do
            local hitbox = enemy:FindFirstChild("Hitbox")
            if hitbox then hitbox.Size = newSize end
        end
    end
})

-- Velocidade e Pulo
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

configSection:AddSlider("WalkSpeed", {
    Title = "🚶 Velocidade",
    Min = 16,
    Max = 200,
    Default = 60,
    Callback = function(value)
        humanoid.WalkSpeed = value
    end
})

configSection:AddSlider("JumpPower", {
    Title = "🦘 Pulo",
    Min = 50,
    Max = 200,
    Default = 100,
    Callback = function(value)
        humanoid.JumpPower = value
    end
})

-- ESP
configSection:AddToggle("ESP", {
    Title = "👁️ ESP (Inimigos/Bosses/Pets)",
    Default = false,
    Callback = function(state)
        if state then
            for _, enemy in ipairs(workspace.__Main.__Enemies.Client:GetChildren()) do
                local highlight = Instance.new("Highlight")
                highlight.Adornee = enemy
                highlight.FillColor = Color3.new(1, 0, 0)
                highlight.OutlineColor = Color3.new(1, 1, 1)
                highlight.Parent = enemy
            end
        else
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("Highlight") then obj:Destroy() end
            end
        end
    end
})

-- Botões adicionais
configSection:AddButton({
    Title = "🛡️ Teleportar para SafeZone",
    Callback = function()
        -- Lógica para teleporte seguro
        Fluent:Notify({
            Title = "Teleporte Seguro",
            Content = "Indo para área segura...",
            Duration = 3
        })
    end
})

configSection:AddButton({
    Title = "🔄 Resetar Personagem",
    Callback = function()
        player.Character:BreakJoints()
    end
})

-- ====== ABA CRÉDITOS ======
local creditosSection = Tabs.Creditos:AddSection("Créditos")

creditosSection:AddParagraph({
    Title = "Desenvolvedor: Theus",
    Content = "Criado exclusivamente para 3 gays"
})

creditosSection:AddParagraph({
    Title = "Script mobile-friendly",
    Content = "by wrdyz.94"
})

creditosSection:AddButton({
    Title = "⭐ Avaliar Script",
    Callback = function()
        setclipboard("https://discord.gg/loscocofantos")
        Fluent:Notify({
            Title = "Obrigado!",
            Content = "Link do Discord copiado para avaliação",
            Duration = 3
        })
    end
})

-- ====== SISTEMA DE MINIMIZAÇÃO ======
local minimized = false
local minimizedFrame = nil

local function ToggleMinimize()
    minimized = not minimized
    if minimized then
        Window:Hide()
        if not minimizedFrame then
            minimizedFrame = Instance.new("Frame")
            minimizedFrame.Size = UDim2.new(0, 60, 0, 60)
            minimizedFrame.Position = UDim2.new(0.9, -30, 0.05, 0)
            minimizedFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            minimizedFrame.BackgroundTransparency = 0.3
            minimizedFrame.BorderSizePixel = 0
            
            local glowEffect = Instance.new("UIStroke", minimizedFrame)
            glowEffect.Color = Color3.fromRGB(0, 200, 255)
            glowEffect.Thickness = 2
            glowEffect.Transparency = 0.7
            
            local icon = Instance.new("ImageLabel")
            icon.Image = "rbxassetid://7072718362"
            icon.Size = UDim2.new(0.7, 0, 0.7, 0)
            icon.Position = UDim2.new(0.15, 0, 0.15, 0)
            icon.BackgroundTransparency = 1
            icon.Parent = minimizedFrame
            
            minimizedFrame.Parent = game.CoreGui
            minimizedFrame.Active = true
            minimizedFrame.Draggable = true
            
            icon.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    ToggleMinimize()
                end
            end)
        end
        minimizedFrame.Visible = true
    else
        Window:Show()
        if minimizedFrame then
            minimizedFrame.Visible = false
        end
    end
end

Window.MinimizeButton.Callback = ToggleMinimize

-- ====== INICIALIZAÇÃO ======
-- Ativar tema e carregar configurações
Fluent:ApplyTheme(Window.Options.Theme)
SaveManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
InterfaceManager:SetFolder("LosCocoFantos")
SaveManager:SetFolder("LosCocoFantos/config")
SaveManager:LoadAutoloadConfig()

-- Notificação inicial
Fluent:Notify({
    Title = "Los CocoFantos Carregado!",
    Content = "Sistema premium ativado com sucesso",
    Duration = 5
})

-- Configurar para mobile
if not game:GetService("UserInputService").KeyboardEnabled then
    Window.Root.Size = UDim2.fromScale(0.9, 0.8)
    Window.Root.Position = UDim2.fromScale(0.05, 0.1)
end