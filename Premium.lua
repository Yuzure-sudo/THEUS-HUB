--[[
    THEUS HUB PREMIUM | KING LEGACY
    Parte 1: Sistema Base e Funcionalidades Principais
]]

-- Serviços
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")

-- Variáveis Principais
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Interface
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- Sistema Anti-Detecção
local OldNameCall = nil
OldNameCall = hookmetamethod(game, "__namecall", function(...)
    local Args = {...}
    local Self = Args[1]
    local NamecallMethod = getnamecallmethod()
    
    if not checkcaller() then
        if typeof(Self) == "Instance" then
            if NamecallMethod == "FireServer" or NamecallMethod == "InvokeServer" then
                if Self.Name:match("Report") or Self.Name:match("Analytics") then
                    return wait(9e9)
                end
            end
        end
    end
    
    return OldNameCall(...)
end)

-- Window Principal
local Window = OrionLib:MakeWindow({
    Name = "THEUS HUB PREMIUM V2",
    HidePremium = false,
    SaveConfig = true,
    IntroText = "THEUS PREMIUM",
    IntroIcon = "rbxassetid://14476196659",
    Icon = "rbxassetid://14476196659",
    ConfigFolder = "THEUSHUB_PREMIUM"
})

-- Sistema de Login
_G.Key = "THEUSPREMIUMV2"
_G.KeyInput = "string"
_G.VIP = {
    "Player1",
    "Player2",
    "Player3"
}

local KeyTab = Window:MakeTab({
    Name = "🔐 Authentication",
    Icon = "rbxassetid://14476196659",
    PremiumOnly = false
})

KeyTab:AddTextbox({
    Name = "Enter Premium Key",
    Default = "",
    TextDisappear = true,
    Callback = function(Value)
        _G.KeyInput = Value
    end    
})

KeyTab:AddButton({
    Name = "Login System",
    Callback = function()
        if _G.KeyInput == _G.Key or table.find(_G.VIP, Player.Name) then
            OrionLib:MakeNotification({
                Name = "THEUS PREMIUM",
                Content = "Access Granted! Loading Premium Features...",
                Image = "rbxassetid://14476196659",
                Time = 5
            })
            wait(2)
            KeyTab:Destroy()
            loadPremiumFeatures()
        else
            OrionLib:MakeNotification({
                Name = "THEUS PREMIUM",
                Content = "Invalid Key! Please Try Again.",
                Image = "rbxassetid://14476196659",
                Time = 5
            })
        end
    end    
})

-- Funções Principais
function loadPremiumFeatures()
    -- Combat Tab
    local CombatTab = Window:MakeTab({
        Name = "⚔️ Combat",
        Icon = "rbxassetid://14476196659"
    })

    local CombatSection = CombatTab:AddSection({
        Name = "Combat Features"
    })

    -- Combat Variables
    _G.AutoFarm = false
    _G.InstantKill = false
    _G.KillAura = false
    _G.GodMode = false
    _G.AutoSkill = false
    _G.FastAttack = false

    -- Combat Functions
    local function getNearestMob()
        local nearest = nil
        local minDistance = math.huge
        
        for _, mob in pairs(workspace:GetChildren()) do
            if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                local distance = (HumanoidRootPart.Position - mob.HumanoidRootPart.Position).magnitude
                if distance < minDistance then
                    minDistance = distance
                    nearest = mob
                end
            end
        end
        return nearest
    end

    local function attackMob(mob)
        local args = {
            [1] = mob.Humanoid,
            [2] = {
                ["Type"] = "Normal",
                ["Damage"] = 999999
            }
        }
        ReplicatedStorage.Remotes.Combat:FireServer(unpack(args))
    end

    -- Combat Toggles
    CombatSection:AddToggle({
        Name = "Auto Farm",
        Default = false,
        Callback = function(Value)
            _G.AutoFarm = Value
            while _G.AutoFarm and wait() do
                pcall(function()
                    local mob = getNearestMob()
                    if mob then
                        local targetPosition = mob.HumanoidRootPart.Position + Vector3.new(0, 7, 0)
                        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Linear)
                        local tween = TweenService:Create(HumanoidRootPart, tweenInfo, {
                            CFrame = CFrame.new(targetPosition, mob.HumanoidRootPart.Position)
                        })
                        tween:Play()
                        attackMob(mob)
                    end
                end)
            end
        end    
    })

    CombatSection:AddToggle({
        Name = "Kill Aura",
        Default = false,
        Callback = function(Value)
            _G.KillAura = Value
            while _G.KillAura and wait() do
                pcall(function()
                    for _, mob in pairs(workspace:GetChildren()) do
                        if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") then
                            local distance = (HumanoidRootPart.Position - mob.HumanoidRootPart.Position).magnitude
                            if distance <= 50 and mob.Humanoid.Health > 0 then
                                attackMob(mob)
                            end
                        end
                    end
                end)
            end
        end    
    })

    CombatSection:AddToggle({
        Name = "God Mode",
        Default = false,
        Callback = function(Value)
            _G.GodMode = Value
            while _G.GodMode and wait() do
                pcall(function()
                    Humanoid.Health = Humanoid.MaxHealth
                end)
            end
        end    
    })

    -- Player Tab
    local PlayerTab = Window:MakeTab({
        Name = "👤 Player",
        Icon = "rbxassetid://14476196659"
    })

    local PlayerSection = PlayerTab:AddSection({
        Name = "Player Modifications"
    })

    PlayerSection:AddSlider({
        Name = "Walk Speed",
        Min = 16,
        Max = 500,
        Default = 16,
        Color = Color3.fromRGB(255,255,255),
        Increment = 1,
        ValueName = "Speed",
        Callback = function(Value)
            Humanoid.WalkSpeed = Value
        end    
    })

    PlayerSection:AddSlider({
        Name = "Jump Power",
        Min = 50,
        Max = 500,
        Default = 50,
        Color = Color3.fromRGB(255,255,255),
        Increment = 1,
        ValueName = "Power",
        Callback = function(Value)
            Humanoid.JumpPower = Value
        end    
    })

    -- Anti AFK
    Player.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end

OrionLib:Init()--[[
    THEUS HUB PREMIUM | KING LEGACY
    Parte 2: Sistemas Avançados e Recursos Premium
]]

-- Continuação das Funcionalidades Premium
function loadPremiumFeatures()
    -- Farm Tab Avançado
    local FarmTab = Window:MakeTab({
        Name = "🌟 Premium Farm",
        Icon = "rbxassetid://14476196659"
    })

    -- Variáveis de Farm
    _G.AutoQuest = false
    _G.BossFarm = false
    _G.AutoRaid = false
    _G.AutoChest = false
    _G.LootFarm = false
    _G.SelectedBoss = "All"
    _G.FarmMethod = "Above"
    _G.FarmDistance = 5

    -- Seção de Farm Principal
    local MainFarmSection = FarmTab:AddSection({
        Name = "Advanced Farming"
    })

    MainFarmSection:AddDropdown({
        Name = "Farm Method",
        Default = "Above",
        Options = {"Above", "Below", "Behind", "Front"},
        Callback = function(Value)
            _G.FarmMethod = Value
        end    
    })

    MainFarmSection:AddSlider({
        Name = "Farm Distance",
        Min = 3,
        Max = 15,
        Default = 5,
        Increment = 1,
        ValueName = "Studs",
        Callback = function(Value)
            _G.FarmDistance = Value
        end    
    })

    -- Sistema de Boss Farm
    local BossSection = FarmTab:AddSection({
        Name = "Boss Farm System"
    })

    local function getBossPosition(bossName)
        local boss = workspace:FindFirstChild(bossName)
        return boss and boss:FindFirstChild("HumanoidRootPart") and boss.HumanoidRootPart.Position
    end

    BossSection:AddToggle({
        Name = "Auto Boss Farm",
        Default = false,
        Callback = function(Value)
            _G.BossFarm = Value
            while _G.BossFarm and wait() do
                pcall(function()
                    if _G.SelectedBoss ~= "All" then
                        local bossPos = getBossPosition(_G.SelectedBoss)
                        if bossPos then
                            local targetPos = bossPos + Vector3.new(0, _G.FarmDistance, 0)
                            Player.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos)
                            attackBoss(_G.SelectedBoss)
                        end
                    end
                end)
            end
        end    
    })

    -- Sistema de Raids
    local RaidTab = Window:MakeTab({
        Name = "⚔️ Raids",
        Icon = "rbxassetid://14476196659"
    })

    _G.AutoStartRaid = false
    _G.AutoCompleteRaid = false
    _G.SelectedRaid = "None"

    local RaidSection = RaidTab:AddSection({
        Name = "Raid Automation"
    })

    RaidSection:AddToggle({
        Name = "Auto Complete Raid",
        Default = false,
        Callback = function(Value)
            _G.AutoCompleteRaid = Value
            while _G.AutoCompleteRaid and wait() do
                pcall(function()
                    -- Implementação do Auto Raid
                    for _, mob in pairs(workspace:GetChildren()) do
                        if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") then
                            if mob.Name:find("Raid") then
                                Player.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 7, 0)
                                attackMob(mob)
                            end
                        end
                    end
                end)
            end
        end    
    })

    -- Sistema de Skills
    local SkillTab = Window:MakeTab({
        Name = "🎯 Skills",
        Icon = "rbxassetid://14476196659"
    })

    _G.AutoSkill1 = false
    _G.AutoSkill2 = false
    _G.AutoSkill3 = false
    _G.AutoSkill4 = false
    _G.SkillDelay = 1

    local function useSkill(skillName)
        local args = {
            [1] = skillName,
            [2] = {
                ["MouseHit"] = Mouse.Hit,
                ["Type"] = "Normal"
            }
        }
        ReplicatedStorage.Remotes.Skills:FireServer(unpack(args))
    end

    local SkillSection = SkillTab:AddSection({
        Name = "Auto Skills"
    })

    SkillSection:AddToggle({
        Name = "Auto Skill 1",
        Default = false,
        Callback = function(Value)
            _G.AutoSkill1 = Value
            while _G.AutoSkill1 and wait(_G.SkillDelay) do
                pcall(function()
                    useSkill("Skill1")
                end)
            end
        end    
    })

    -- Sistema de Teleporte
    local TeleportTab = Window:MakeTab({
        Name = "🌍 Teleport",
        Icon = "rbxassetid://14476196659"
    })

    local function teleportTo(position)
        Player.Character.HumanoidRootPart.CFrame = position
    end

    local locations = {
        ["Spawn"] = CFrame.new(0, 100, 0),
        ["Boss Area"] = CFrame.new(100, 100, 100),
        ["Training Ground"] = CFrame.new(-100, 100, -100)
    }

    for locationName, position in pairs(locations) do
        TeleportTab:AddButton({
            Name = "Teleport to " .. locationName,
            Callback = function()
                teleportTo(position)
            end    
        })
    end

    -- Sistema de Misc
    local MiscTab = Window:MakeTab({
        Name = "⚙️ Misc",
        Icon = "rbxassetid://14476196659"
    })

    _G.AutoChest = false
    _G.AutoCollectDrops = false
    _G.NoClip = false

    MiscTab:AddToggle({
        Name = "Auto Collect Chests",
        Default = false,
        Callback = function(Value)
            _G.AutoChest = Value
            while _G.AutoChest and wait() do
                pcall(function()
                    for _, chest in pairs(workspace:GetChildren()) do
                        if chest.Name:find("Chest") then
                            local distance = (Player.Character.HumanoidRootPart.Position - chest.Position).magnitude
                            if distance < 50 then
                                fireproximityprompt(chest.ProximityPrompt)
                            end
                        end
                    end
                end)
            end
        end    
    })

    -- Sistema de Configurações
    local SettingsTab = Window:MakeTab({
        Name = "⚙️ Settings",
        Icon = "rbxassetid://14476196659"
    })

    local function saveSettings()
        local settings = {
            FarmMethod = _G.FarmMethod,
            FarmDistance = _G.FarmDistance,
            SkillDelay = _G.SkillDelay
        }
        writefile("THEUSHUB_SETTINGS.json", HttpService:JSONEncode(settings))
    end

    local function loadSettings()
        if isfile("THEUSHUB_SETTINGS.json") then
            local settings = HttpService:JSONDecode(readfile("THEUSHUB_SETTINGS.json"))
            _G.FarmMethod = settings.FarmMethod
            _G.FarmDistance = settings.FarmDistance
            _G.SkillDelay = settings.SkillDelay
        end
    end

    SettingsTab:AddButton({
        Name = "Save Settings",
        Callback = function()
            saveSettings()
        end    
    })

    SettingsTab:AddButton({
        Name = "Load Settings",
        Callback = function()
            loadSettings()
        end    
    })

    -- Anti AFK Aprimorado
    local function setupAntiAFK()
        local VirtualUser = game:GetService('VirtualUser')
        Player.Idled:connect(function()
            VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            wait(1)
            VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end)
    end
    
    setupAntiAFK()
end

-- Inicialização
OrionLib:Init()