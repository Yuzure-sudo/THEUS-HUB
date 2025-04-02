--[[
    THEUS HUB PREMIUM | KING LEGACY
    Versão: 2.0
    Anti-Ban & Full Features
]]

-- Serviços Principais
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Variáveis Locais
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Mouse = Player:GetMouse()

-- Anti-Detection & Bypass
local OldNameCall = nil
OldNameCall = hookmetamethod(game, "__namecall", function(self, ...)
    local Args = {...}
    local Method = getnamecallmethod()
    
    if Method == "FireServer" or Method == "InvokeServer" then
        if tostring(self):find("Report") or tostring(self):find("Ban") or tostring(self):find("Analytics") then
            return wait(9e9)
        end
    end
    
    return OldNameCall(self, ...)
end)

-- Interface Setup
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({
    Name = "THEUS HUB PREMIUM V2",
    HidePremium = false,
    SaveConfig = true,
    IntroText = "THEUS PREMIUM",
    ConfigFolder = "THEUSHUB"
})

-- Key System
_G.Key = "THEUSHUBPREMIUM"
_G.KeyInput = "string"

local KeyTab = Window:MakeTab({
    Name = "🔑 Key System",
    Icon = "rbxassetid://14476196659"
})

KeyTab:AddTextbox({
    Name = "Enter Key",
    Default = "",
    TextDisappear = true,
    Callback = function(Value)
        _G.KeyInput = Value
    end    
})

KeyTab:AddButton({
    Name = "Check Key",
    Callback = function()
        if _G.KeyInput == _G.Key then
            KeyTab:Destroy()
            loadMainScript()
            OrionLib:MakeNotification({
                Name = "THEUS HUB",
                Content = "Premium Access Granted!",
                Image = "rbxassetid://14476196659",
                Time = 5
            })
        else
            OrionLib:MakeNotification({
                Name = "THEUS HUB",
                Content = "Invalid Key!",
                Image = "rbxassetid://14476196659",
                Time = 5
            })
        end
    end    
})

-- Main Script Function
function loadMainScript()
    -- Combat Variables
    _G.AutoFarm = false
    _G.InstantKill = false
    _G.KillAura = false
    _G.AutoRaid = false
    _G.FastAttack = false
    _G.GodMode = false
    _G.NoClip = false
    _G.AutoQuest = false
    _G.MobAura = false
    _G.BringMob = false

    -- Combat Functions
    local function getNearestMob()
        local nearestMob = nil
        local shortestDistance = math.huge
        
        for _, v in pairs(workspace:GetChildren()) do
            if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                if v.Name:find("Mob") or v.Name:find("Boss") then
                    local distance = (HumanoidRootPart.Position - v.HumanoidRootPart.Position).magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        nearestMob = v
                    end
                end
            end
        end
        return nearestMob
    end

    local function attackMob()
        local args = {
            [1] = "Combat",
            [2] = {
                ["Type"] = "Normal",
                ["Damage"] = 9999999
            }
        }
        ReplicatedStorage.Remotes.Combat:FireServer(unpack(args))
    end

    -- Combat Tab
    local CombatTab = Window:MakeTab({
        Name = "⚔️ Combat",
        Icon = "rbxassetid://14476196659"
    })

    CombatTab:AddToggle({
        Name = "Auto Farm",
        Default = false,
        Callback = function(Value)
            _G.AutoFarm = Value
            while _G.AutoFarm and task.wait() do
                pcall(function()
                    local mob = getNearestMob()
                    if mob then
                        local targetPosition = mob.HumanoidRootPart.Position + Vector3.new(0, 7, 0)
                        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Linear)
                        local tween = TweenService:Create(HumanoidRootPart, tweenInfo, {
                            CFrame = CFrame.new(targetPosition, mob.HumanoidRootPart.Position)
                        })
                        tween:Play()
                        attackMob()
                    end
                end)
            end
        end    
    })

    CombatTab:AddToggle({
        Name = "Kill Aura",
        Default = false,
        Callback = function(Value)
            _G.KillAura = Value
            while _G.KillAura and task.wait() do
                pcall(function()
                    for _, mob in pairs(workspace:GetChildren()) do
                        if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") then
                            if (HumanoidRootPart.Position - mob.HumanoidRootPart.Position).magnitude <= 50 then
                                attackMob()
                            end
                        end
                    end
                end)
            end
        end    
    })

    CombatTab:AddToggle({
        Name = "God Mode",
        Default = false,
        Callback = function(Value)
            _G.GodMode = Value
            while _G.GodMode and task.wait() do
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

    PlayerTab:AddSlider({
        Name = "Walk Speed",
        Min = 16,
        Max = 500,
        Default = 16,
        Increment = 1,
        ValueName = "Speed",
        Callback = function(Value)
            Humanoid.WalkSpeed = Value
        end    
    })

    PlayerTab:AddSlider({
        Name = "Jump Power",
        Min = 50,
        Max = 500,
        Default = 50,
        Increment = 1,
        ValueName = "Power",
        Callback = function(Value)
            Humanoid.JumpPower = Value
        end    
    })

    PlayerTab:AddToggle({
        Name = "Noclip",
        Default = false,
        Callback = function(Value)
            _G.NoClip = Value
        end    
    })

    RunService.Stepped:Connect(function()
        if _G.NoClip then
            for _, part in pairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
    -- Farm Tab
    local FarmTab = Window:MakeTab({
        Name = "🌟 Farm",
        Icon = "rbxassetid://14476196659"
    })

    -- Farm Variables
    _G.AutoQuest = false
    _G.QuestMob = "None"
    _G.BringMob = false
    _G.FarmMethod = "Above"
    _G.FarmDistance = 5

    FarmTab:AddDropdown({
        Name = "Farm Method",
        Default = "Above",
        Options = {"Above", "Below", "Behind"},
        Callback = function(Value)
            _G.FarmMethod = Value
        end    
    })

    FarmTab:AddToggle({
        Name = "Bring Mob",
        Default = false,
        Callback = function(Value)
            _G.BringMob = Value
            while _G.BringMob and task.wait() do
                pcall(function()
                    for _, mob in pairs(workspace:GetChildren()) do
                        if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") then
                            if mob.Name:find("Mob") or mob.Name:find("Boss") then
                                mob.HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
                            end
                        end
                    end
                end)
            end
        end    
    })

    -- Skills Tab
    local SkillsTab = Window:MakeTab({
        Name = "🎯 Skills",
        Icon = "rbxassetid://14476196659"
    })

    _G.AutoSkill = false
    _G.SkillDelay = 1

    local function useSkill(skill)
        local args = {
            [1] = skill,
            [2] = {
                ["MouseHit"] = Mouse.Hit,
                ["Type"] = "Normal"
            }
        }
        ReplicatedStorage.Remotes.Skills:FireServer(unpack(args))
    end

    SkillsTab:AddToggle({
        Name = "Auto Skills",
        Default = false,
        Callback = function(Value)
            _G.AutoSkill = Value
            while _G.AutoSkill and task.wait(_G.SkillDelay) do
                pcall(function()
                    useSkill("Skill1")
                    wait(0.1)
                    useSkill("Skill2")
                    wait(0.1)
                    useSkill("Skill3")
                    wait(0.1)
                    useSkill("Skill4")
                end)
            end
        end    
    })

    -- Teleport Tab
    local TeleportTab = Window:MakeTab({
        Name = "🌍 Teleport",
        Icon = "rbxassetid://14476196659"
    })

    local function teleportTo(position)
        HumanoidRootPart.CFrame = position
    end

    TeleportTab:AddButton({
        Name = "Teleport to Safe Zone",
        Callback = function()
            teleportTo(CFrame.new(0, 100, 0))
        end    
    })

    -- Misc Tab
    local MiscTab = Window:MakeTab({
        Name = "⚙️ Misc",
        Icon = "rbxassetid://14476196659"
    })

    _G.AutoCollectChest = false
    _G.AutoCollectDrops = false

    MiscTab:AddToggle({
        Name = "Auto Collect Chests",
        Default = false,
        Callback = function(Value)
            _G.AutoCollectChest = Value
            while _G.AutoCollectChest and task.wait() do
                pcall(function()
                    for _, chest in pairs(workspace:GetChildren()) do
                        if chest.Name:find("Chest") then
                            chest.CFrame = HumanoidRootPart.CFrame
                        end
                    end
                end)
            end
        end    
    })

    -- Raid Tab
    local RaidTab = Window:MakeTab({
        Name = "⚔️ Raid",
        Icon = "rbxassetid://14476196659"
    })

    _G.AutoRaid = false

    RaidTab:AddToggle({
        Name = "Auto Raid",
        Default = false,
        Callback = function(Value)
            _G.AutoRaid = Value
            while _G.AutoRaid and task.wait() do
                pcall(function()
                    for _, mob in pairs(workspace:GetChildren()) do
                        if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") then
                            if mob.Name:find("Raid") then
                                HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 7, 0)
                                attackMob()
                            end
                        end
                    end
                end)
            end
        end    
    })

    -- Anti AFK
    local VirtualUser = game:GetService('VirtualUser')
    Player.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)

    -- Anti Ban Features
    local function setupAntiBan()
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            if method == "FireServer" or method == "InvokeServer" then
                local args = {...}
                if args[1] == "Ban" or args[1] == "Kick" then
                    return wait(9e9)
                end
            end
            return oldNamecall(self, ...)
        end)
    end

    setupAntiBan()

    -- Extra Protection
    local mt = getrawmetatable(game)
    local old = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(...)
        local args = {...}
        local method = getnamecallmethod()
        if method == "Kick" then
            return wait(9e9)
        end
        return old(...)
    end)
    setreadonly(mt, true)
end

-- Initialize
OrionLib:Init()