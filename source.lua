-- THEUS HUB - King Legacy Ultimate
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- Configurações
local Config = {
    AutoFarm = false,
    AutoQuest = false,
    AutoRaid = false,
    AutoSkill = false,
    AutoBoss = false,
    WalkSpeed = 100,
    JumpPower = 100
}

-- Interface
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("THEUS HUB | King Legacy", "Midnight") -- Tema alterado para Midnight

-- Logo e Créditos
local CreditTab = Window:NewTab("💎 THEUS HUB")
local CreditSection = CreditTab:NewSection("Bem-vindo ao THEUS HUB")
CreditSection:NewLabel("Desenvolvido por THEUS")
CreditSection:NewLabel("Versão: 1.0.0")
CreditSection:NewLabel("Premium Script")

-- Tabs principais com ícones
local FarmTab = Window:NewTab("🌟 Farming")
local CombatTab = Window:NewTab("⚔️ Combat")
local TeleportTab = Window:NewTab("🌐 Teleport")
local MiscTab = Window:NewTab("⚙️ Misc")

-- Funções de Farm
local function AutoFarm()
    while Config.AutoFarm do
        pcall(function()
            for _, v in pairs(workspace.Enemies:GetChildren()) do
                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                    repeat
                        Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 7, 0)
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton1(Vector2.new())
                        wait()
                    until not v:FindFirstChild("Humanoid") or v.Humanoid.Health <= 0 or not Config.AutoFarm
                end
            end
        end)
        wait()
    end
end

-- Funções de Combate
local function AutoSkill()
    while Config.AutoSkill do
        pcall(function()
            local Skills = {"Z", "X", "C", "V", "B"}
            for _, skill in ipairs(Skills) do
                VirtualUser:CaptureController()
                VirtualUser:SetKeyDown(skill)
                wait(0.1)
                VirtualUser:SetKeyUp(skill)
            end
        end)
        wait(1)
    end
end

-- Interface de Farm
local FarmSection = FarmTab:NewSection("🎯 Auto Farm")
FarmSection:NewToggle("Auto Farm", "Ativa/Desativa o farm automático", function(state)
    Config.AutoFarm = state
    if state then
        AutoFarm()
    end
end)

-- Interface de Combate
local CombatSection = CombatTab:NewSection("⚔️ Sistema de Combate")
CombatSection:NewToggle("Auto Skill", "Usa skills automaticamente", function(state)
    Config.AutoSkill = state
    if state then
        AutoSkill()
    end
end)

CombatSection:NewToggle("Auto Boss", "Farm automático de bosses", function(state)
    Config.AutoBoss = state
    if state then
        AutoBoss()
    end
end)

-- Sistema de Teleporte Aprimorado
local TeleportSection = TeleportTab:NewSection("🌍 Localizações")
local Locations = {
    ["Spawn Island"] = CFrame.new(0, 100, 0),
    ["Marine Base"] = CFrame.new(100, 100, 100),
    ["Desert Island"] = CFrame.new(-100, 100, -100),
    ["Snow Island"] = CFrame.new(200, 100, 200),
    ["Sky Island"] = CFrame.new(0, 500, 0)
}

for name, position in pairs(Locations) do
    TeleportSection:NewButton(name, "Teleporta para " .. name, function()
        Character.HumanoidRootPart.CFrame = position
    end)
end

-- Configurações Avançadas
local MiscSection = MiscTab:NewSection("🛠️ Configurações")
MiscSection:NewSlider("WalkSpeed", "Ajusta a velocidade", 500, 16, function(value)
    Config.WalkSpeed = value
    Humanoid.WalkSpeed = value
end)

MiscSection:NewSlider("JumpPower", "Ajusta o pulo", 500, 50, function(value)
    Config.JumpPower = value
    Humanoid.JumpPower = value
end)

-- Sistema de Notificações Personalizado
local function TheusNotify(title, text, duration)
    Library:MakeNotification({
        Name = "THEUS HUB | " .. title,
        Content = text,
        Image = "rbxassetid://4483345998",
        Time = duration or 5
    })
end

-- Anti AFK Aprimorado
local VirtualUser = game:GetService('VirtualUser')
Players.LocalPlayer.Idled:connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    TheusNotify("Anti AFK", "Sistema Anti AFK ativado", 3)
end)

-- Proteções e Otimizações
local function SafetyChecks()
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then
        Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        Humanoid = Character:WaitForChild("Humanoid")
    end
end

game:GetService("RunService").Heartbeat:Connect(SafetyChecks)

-- Inicialização
TheusNotify("Script Carregado", "THEUS HUB iniciado com sucesso!", 5)