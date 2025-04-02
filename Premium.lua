-- THEUS HUB DEVELOPER | KING LEGACY
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Sistema de Login
local Window = OrionLib:MakeWindow({
    Name = "THEUS HUB DEVELOPER",
    HidePremium = false,
    SaveConfig = true,
    IntroText = "THEUS HUB",
    IntroIcon = "rbxassetid://14476196659",
    Icon = "rbxassetid://14476196659"
})

-- Key System
_G.Key = "THEUSDEV"
_G.KeyInput = "string"

local KeyTab = Window:MakeTab({
    Name = "🔑 Key System",
    Icon = "rbxassetid://14476196659",
    PremiumOnly = false
})

KeyTab:AddTextbox({
    Name = "Digite sua Key",
    Default = "",
    TextDisappear = true,
    Callback = function(Value)
        _G.KeyInput = Value
    end    
})

KeyTab:AddButton({
    Name = "Verificar Key",
    Callback = function()
        if _G.KeyInput == _G.Key then
            OrionLib:MakeNotification({
                Name = "THEUS HUB",
                Content = "Key Correta! Carregando...",
                Image = "rbxassetid://14476196659",
                Time = 5
            })
            wait(2)
            KeyTab:Destroy()
            loadMain()
        else
            OrionLib:MakeNotification({
                Name = "THEUS HUB",
                Content = "Key Incorreta!",
                Image = "rbxassetid://14476196659",
                Time = 5
            })
        end
    end    
})

-- Função Principal
function loadMain()
    -- Main Farm Tab
    local FarmTab = Window:MakeTab({
        Name = "🌟 Auto Farm",
        Icon = "rbxassetid://14476196659",
        PremiumOnly = false
    })

    local MainSection = FarmTab:AddSection({
        Name = "Farm Principal"
    })

    -- Configurações do Farm
    _G.AutoFarm = false
    _G.FarmMethod = "Above" -- Above, Behind, Front
    _G.FarmDistance = 5
    _G.AutoAttack = false
    _G.TargetMob = "All" -- Nome do mob ou "All"

    -- Funções de Farm
    local function getNearestMob()
        local nearestMob = nil
        local shortestDistance = math.huge

        for _, mob in pairs(workspace:GetChildren()) do
            if mob:IsA("Model") and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                if _G.TargetMob == "All" or mob.Name == _G.TargetMob then
                    local distance = (mob.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        nearestMob = mob
                    end
                end
            end
        end
        return nearestMob
    end

    local function attackMob()
        if _G.AutoAttack then
            local args = {
                [1] = "M1",
                [2] = {
                    ["Type"] = "Normal",
                    ["Damage"] = 99999
                }
            }
            ReplicatedStorage.Remotes.Combat:FireServer(unpack(args))
        end
    end

    -- Toggle Auto Farm
    MainSection:AddToggle({
        Name = "Auto Farm",
        Default = false,
        Callback = function(Value)
            _G.AutoFarm = Value
            
            while _G.AutoFarm and wait() do
                pcall(function()
                    local mob = getNearestMob()
                    if mob then
                        local mobCFrame = mob.HumanoidRootPart.CFrame
                        local farmPosition = mobCFrame
                        
                        if _G.FarmMethod == "Above" then
                            farmPosition = mobCFrame * CFrame.new(0, _G.FarmDistance, 0)
                        elseif _G.FarmMethod == "Behind" then
                            farmPosition = mobCFrame * CFrame.new(0, 0, _G.FarmDistance)
                        elseif _G.FarmMethod == "Front" then
                            farmPosition = mobCFrame * CFrame.new(0, 0, -_G.FarmDistance)
                        end
                        
                        Player.Character.HumanoidRootPart.CFrame = farmPosition
                        attackMob()
                    end
                end)
            end
        end    
    })

    -- Farm Settings
    MainSection:AddDropdown({
        Name = "Farm Method",
        Default = "Above",
        Options = {"Above", "Behind", "Front"},
        Callback = function(Value)
            _G.FarmMethod = Value
        end    
    })

    MainSection:AddSlider({
        Name = "Farm Distance",
        Min = 3,
        Max = 10,
        Default = 5,
        Color = Color3.fromRGB(255,255,255),
        Increment = 1,
        ValueName = "Distance",
        Callback = function(Value)
            _G.FarmDistance = Value
        end    
    })

    MainSection:AddToggle({
        Name = "Auto Attack",
        Default = false,
        Callback = function(Value)
            _G.AutoAttack = Value
        end    
    })

    -- Combat Tab
    local CombatTab = Window:MakeTab({
        Name = "⚔️ Combat",
        Icon = "rbxassetid://14476196659",
        PremiumOnly = false
    })

    local CombatSection = CombatTab:AddSection({
        Name = "Combat Settings"
    })

    -- Kill Aura
    _G.KillAura = false
    _G.KillAuraRange = 10

    CombatSection:AddToggle({
        Name = "Kill Aura",
        Default = false,
        Callback = function(Value)
            _G.KillAura = Value
            
            while _G.KillAura and wait() do
                pcall(function()
                    for _, mob in pairs(workspace:GetChildren()) do
                        if mob:IsA("Model") and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") then
                            local distance = (mob.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).magnitude
                            if distance <= _G.KillAuraRange and mob.Humanoid.Health > 0 then
                                local args = {
                                    [1] = mob.Humanoid,
                                    [2] = {
                                        ["Type"] = "Normal",
                                        ["Damage"] = 99999
                                    }
                                }
                                ReplicatedStorage.Remotes.Combat:FireServer(unpack(args))
                            end
                        end
                    end
                end)
            end
        end    
    })

    CombatSection:AddSlider({
        Name = "Kill Aura Range",
        Min = 5,
        Max = 20,
        Default = 10,
        Color = Color3.fromRGB(255,255,255),
        Increment = 1,
        ValueName = "Range",
        Callback = function(Value)
            _G.KillAuraRange = Value
        end    
    })

    -- Player Tab
    local PlayerTab = Window:MakeTab({
        Name = "👤 Player",
        Icon = "rbxassetid://14476196659",
        PremiumOnly = false
    })

    local PlayerSection = PlayerTab:AddSection({
        Name = "Player Mods"
    })

    -- Player Speed
    PlayerSection:AddSlider({
        Name = "Walk Speed",
        Min = 16,
        Max = 500,
        Default = 16,
        Color = Color3.fromRGB(255,255,255),
        Increment = 1,
        ValueName = "Speed",
        Callback = function(Value)
            Player.Character.Humanoid.WalkSpeed = Value
        end    
    })

    -- Jump Power
    PlayerSection:AddSlider({
        Name = "Jump Power",
        Min = 50,
        Max = 500,
        Default = 50,
        Color = Color3.fromRGB(255,255,255),
        Increment = 1,
        ValueName = "Power",
        Callback = function(Value)
            Player.Character.Humanoid.JumpPower = Value
        end    
    })

    -- Anti AFK
    local VirtualUser = game:GetService('VirtualUser')
    Player.Idled:connect(function()
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end

OrionLib:Init()