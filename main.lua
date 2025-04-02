-- THEUS HUB - King Legacy Ultimate
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- Interface Principal
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("THEUS HUB | PREMIUM", "Midnight")

-- Configurações Avançadas
local Config = {
    AutoFarm = false,
    KillAura = false,
    AutoQuest = false,
    GodMode = false,
    InstantKill = false,
    WalkSpeed = 100,
    JumpPower = 100,
    Range = 15
}

-- Funções Apelona
local function KillAura()
    while Config.KillAura do
        pcall(function()
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                    if v.Name ~= LocalPlayer.Name and (v.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).Magnitude <= Config.Range then
                        local args = {
                            [1] = v.Humanoid,
                            [2] = {
                                ["Type"] = "Normal",
                                ["Hit"] = v.HumanoidRootPart,
                                ["HitPosition"] = v.HumanoidRootPart.Position,
                                ["Damage"] = 9999
                            }
                        }
                        ReplicatedStorage.Remotes.Combat:FireServer(unpack(args))
                    end
                end
            end
        end)
        wait()
    end
end

local function GodMode()
    while Config.GodMode do
        pcall(function()
            if Character.Humanoid.Health < Character.Humanoid.MaxHealth then
                Character.Humanoid.Health = Character.Humanoid.MaxHealth
            end
        end)
        wait()
    end
end

-- Tabs
local MainTab = Window:NewTab("🌟 Principal")
local CombatTab = Window:NewTab("⚔️ Combate")
local TeleportTab = Window:NewTab("🌐 Teleporte")
local PlayerTab = Window:NewTab("👤 Jogador")

-- Seções
local MainSection = MainTab:NewSection("Farm Automático")
local CombatSection = CombatTab:NewSection("Combate Apelão")
local PlayerSection = PlayerTab:NewSection("Modificações")

-- Main Tab
MainSection:NewToggle("Auto Farm", "Farm ultra rápido", function(state)
    Config.AutoFarm = state
    if state then
        while Config.AutoFarm do
            pcall(function()
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                        if v.Humanoid.Health > 0 then
                            repeat
                                Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 7, 0)
                                local args = {
                                    [1] = v.Humanoid,
                                    [2] = {
                                        ["Type"] = "Normal",
                                        ["Hit"] = v.HumanoidRootPart,
                                        ["HitPosition"] = v.HumanoidRootPart.Position,
                                        ["Damage"] = 9999
                                    }
                                }
                                ReplicatedStorage.Remotes.Combat:FireServer(unpack(args))
                                wait()
                            until not v:FindFirstChild("Humanoid") or v.Humanoid.Health <= 0 or not Config.AutoFarm
                        end
                    end
                end
            end)
            wait()
        end
    end
end)

-- Combat Tab
CombatSection:NewToggle("Kill Aura", "Mata tudo próximo", function(state)
    Config.KillAura = state
    if state then
        KillAura()
    end
end)

CombatSection:NewToggle("God Mode", "Vida infinita", function(state)
    Config.GodMode = state
    if state then
        GodMode()
    end
end)

CombatSection:NewSlider("Range", "Alcance do Kill Aura", 50, 5, function(value)
    Config.Range = value
end)

-- Player Tab
PlayerSection:NewSlider("Velocidade", "Ajusta velocidade", 500, 16, function(value)
    Character.Humanoid.WalkSpeed = value
end)

PlayerSection:NewSlider("Pulo", "Ajusta força do pulo", 500, 50, function(value)
    Character.Humanoid.JumpPower = value
end)

PlayerSection:NewButton("Reset", "Reseta o personagem", function()
    Character.Humanoid.Health = 0
end)

-- Anti AFK
local VirtualUser = game:GetService('VirtualUser')
Players.LocalPlayer.Idled:connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- Notificação de Inicialização
Library:MakeNotification({
    Name = "THEUS HUB PREMIUM",
    Content = "Script carregado com sucesso!",
    Image = "rbxassetid://4483345998",
    Time = 5
})