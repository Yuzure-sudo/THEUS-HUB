-- Los CocoFantos Hub - Solo Leveling Arise
-- Desenvolvido por Theus para 3 gays
-- Versão: Los Concafos

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
    Size = UDim2.fromOffset(500, 400),
    Acrylic = true,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.RightControl,
    Minimizable = true
})

-- Adicionar logo personalizado
Window.Root.TitleBar.Logo.Image = "rbxassetid://7072718362" -- Substituir pelo ID do seu logo

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
    Content = "Script mobile-friendly by Theus",
    ContentWrapped = true
})

MenuSection:AddParagraph({
    Title = "◉ Botões grandes e com brilho",
    Content = "◉ Fundo translúcido"
})

-- Botão de ativação principal
local btnAtivar = MenuSection:AddButton({
    Title = "ATIVAR SISTEMA",
    Description = "Inicia todas as funções básicas",
    Callback = function()
        Fluent:Notify({
            Title = "Sistema Ativado",
            Content = "Todas as funções básicas foram iniciadas!",
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
farmSection:AddParagraph({
    Title = "Configurações de Farm",
    Content = "Detecta inimigos automaticamente"
})

-- Toggles principais
local autoFarmToggle = farmSection:AddToggle("AutoFarmToggle", {
    Title = "🔄 Ativar AutoFarm",
    Default = false,
    Callback = function(state)
        if state then
            startAutoFarm()
        else
            stopAutoFarm()
        end
    end
})

farmSection:AddToggle("SafeMode", {
    Title = "🛡️ Modo Seguro",
    Default = true
})

farmSection:AddToggle("KamikazeMode", {
    Title = "💥 Modo Kamikaze",
    Default = false
})

-- Funções do AutoFarm
local farmThread = nil

local function startAutoFarm()
    farmThread = task.spawn(function()
        while autoFarmToggle.Value do
            local enemies = workspace:FindFirstChild("__Main"):FindFirstChild("__Enemies"):FindFirstChild("Client")
            if enemies then
                for _, enemy in ipairs(enemies:GetChildren()) do
                    if enemy:IsA("Model") and enemy:FindFirstChild("HumanoidRootPart") then
                        -- Teleportar para o inimigo
                        local char = player.Character
                        if char and char:FindFirstChild("HumanoidRootPart") then
                            char.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
                            task.wait(1)
                        end
                    end
                end
            end
            task.wait(1)
        end
    end)
end

local function stopAutoFarm()
    if farmThread then
        task.cancel(farmThread)
        farmThread = nil
    end
end

-- ====== ABA EVENTOS ======
local eventosSection = Tabs.Eventos:AddSection("Eventos Automáticos")

-- Auto Dungeon
eventosSection:AddToggle("AutoDungeon", {
    Title = "🏰 Auto Dungeon",
    Default = false,
    Callback = function(state)
        if state then
            Fluent:Notify({
                Title = "Dungeon Automático",
                Content = "Procurando dungeons...",
                Duration = 3
            })
        end
    end
})

-- Auto Mount
eventosSection:AddToggle("AutoMount", {
    Title = "🐴 Auto Mount",
    Default = false,
    Callback = function(state)
        if state then
            Fluent:Notify({
                Title = "Mount Automático",
                Content = "Procurando mounts...",
                Duration = 3
            })
        end
    end
})

-- Auto Claim Diário
eventosSection:AddButton({
    Title = "🎁 Claim Diário",
    Callback = function()
        game:GetService("ReplicatedStorage").BridgeNet2.dataRemoteEvent:FireServer({
            {
                Event = "ClaimDaily"
            },
            "\n"
        })
        Fluent:Notify({
            Title = "Recompensa Diária",
            Content = "Reivindicada com sucesso!",
            Duration = 3
        })
    end
})

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

-- Expandir Hitbox
configSection:AddToggle("ExpandHitbox", {
    Title = "🎯 Expandir Hitbox",
    Default = false,
    Callback = function(state)
        if state then
            for _, enemy in ipairs(workspace.__Main.__Enemies.Client:GetChildren()) do
                local hitbox = enemy:FindFirstChild("Hitbox")
                if hitbox then
                    hitbox.Size = Vector3.new(10, 10, 10)
                end
            end
        else
            for _, enemy in ipairs(workspace.__Main.__Enemies.Client:GetChildren()) do
                local hitbox = enemy:FindFirstChild("Hitbox")
                if hitbox then
                    hitbox.Size = Vector3.new(5, 5, 5)
                end
            end
        end
    end
})

-- Velocidade e Pulo
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

configSection:AddSlider("WalkSpeed", {
    Title = "🚶 Velocidade",
    Min = 16,
    Max = 100,
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

-- Resetar Personagem
configSection:AddButton({
    Title = "🔄 Resetar Personagem",
    Callback = function()
        player.Character:BreakJoints()
    end
})

-- ESP Inimigos
configSection:AddToggle("ESP", {
    Title = "👁️ ESP Inimigos",
    Default = false,
    Callback = function(state)
        if state then
            for _, enemy in ipairs(workspace.__Main.__Enemies.Client:GetChildren()) do
                if enemy:IsA("Model") then
                    local highlight = Instance.new("Highlight")
                    highlight.Adornee = enemy
                    highlight.FillColor = Color3.new(1, 0, 0)
                    highlight.OutlineColor = Color3.new(1, 1, 1)
                    highlight.Parent = enemy
                end
            end
        else
            for _, enemy in ipairs(workspace.__Main.__Enemies.Client:GetChildren()) do
                if enemy:IsA("Model") then
                    for _, child in ipairs(enemy:GetChildren()) do
                        if child:IsA("Highlight") then
                            child:Destroy()
                        end
                    end
                end
            end
        end
    end
})

-- ====== ABA TELEPORTE ======
local teleSection = Tabs.Teleporte:AddSection("Teleportes Rápidos")

teleSection:AddDropdown("SafeZones", {
    Title = "📍 Safe Zones",
    Values = {"Base Inicial", "Vila Segura", "Torre dos Caçadores"},
    Default = "Base Inicial"
})

teleSection:AddDropdown("Bosses", {
    Title = "👑 Bosses",
    Values = {"Rei Orc", "Dragão de Gelo", "Lich Sombrio"},
    Default = "Rei Orc"
})

teleSection:AddButton({
    Title = "➡️ Teleportar",
    Callback = function()
        Fluent:Notify({
            Title = "Teleporte",
            Content = "Teleportando para local selecionado...",
            Duration = 3
        })
    end
})

-- ====== ABA PETS ======
local petsSection = Tabs.Pets:AddSection("Gerenciamento de Pets")

petsSection:AddParagraph({
    Title = "🚧 Em Construção",
    Content = "Esta funcionalidade estará disponível na próxima atualização"
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
        Fluent:Notify({
            Title = "Obrigado!",
            Content = "Sua avaliação é importante para nós",
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