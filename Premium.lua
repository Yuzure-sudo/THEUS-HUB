local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")

-- Anti Detection
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    if method == "FireServer" or method == "InvokeServer" then
        if tostring(self):find("Report") or tostring(self):find("Analytics") then
            return wait(9e9)
        end
    end
    return oldNamecall(self, ...)
end)

-- Window Setup
local Window = OrionLib:MakeWindow({
    Name = "THEUS HUB PREMIUM",
    HidePremium = false,
    SaveConfig = true,
    IntroText = "THEUS PREMIUM",
    ConfigFolder = "THEUSHUB"
})

-- Key System
_G.Key = "THEUSPREMIUM2025"
_G.KeyInput = "string"
_G.FriendsList = {
    "Friend1",
    "Friend2",
    "Friend3"
}

local KeyTab = Window:MakeTab({
    Name = "🔐 Login",
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
    Name = "Login",
    Callback = function()
        if _G.KeyInput == _G.Key or table.find(_G.FriendsList, Player.Name) then
            OrionLib:MakeNotification({
                Name = "THEUS HUB",
                Content = "Access Granted! Loading...",
                Image = "rbxassetid://14476196659",
                Time = 5
            })
            wait(1)
            KeyTab:Destroy()
            loadMain()
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

function loadMain()
    -- Farm Tab
    local FarmTab = Window:MakeTab({
        Name = "⚔️ Farm",
        Icon = "rbxassetid://14476196659"
    })

    _G.AutoFarm = false
    _G.InstantKill = false
    _G.AutoQuest = false
    _G.FarmAll = false
    _G.BossRaid = false

    local function getNearestMob()
        local nearest = nil
        local minDist = math.huge
        
        for _, mob in pairs(workspace:GetChildren()) do
            if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                local dist = (Player.Character.HumanoidRootPart.Position - mob.HumanoidRootPart.Position).magnitude
                if dist < minDist then
                    minDist = dist
                    nearest = mob
                end
            end
        end
        return nearest
    end

    FarmTab:AddToggle({
        Name = "Auto Farm",
        Default = false,
        Callback = function(Value)
            _G.AutoFarm = Value
            while _G.AutoFarm and wait() do
                pcall(function()
                    local mob = getNearestMob()
                    if mob then
                        Player.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0,7,0)
                        local args = {
                            [1] = mob.Humanoid,
                            [2] = {
                                ["Type"] = "Normal",
                                ["Damage"] = 999999
                            }
                        }
                        ReplicatedStorage.Remotes.Combat:FireServer(unpack(args))
                    end
                end)
            end
        end    
    })

    FarmTab:AddToggle({
        Name = "Instant Kill",
        Default = false,
        Callback = function(Value)
            _G.InstantKill = Value
            while _G.InstantKill and wait() do
                pcall(function()
                    for _, mob in pairs(workspace:GetChildren()) do
                        if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") then
                            mob.Humanoid.Health = 0
                        end
                    end
                end)
            end
        end    
    })

    -- Combat Tab
    local CombatTab = Window:MakeTab({
        Name = "🗡️ Combat",
        Icon = "rbxassetid://14476196659"
    })

    _G.GodMode = false
    _G.InfiniteStamina = false
    _G.OneShot = false
    _G.AutoSkills = false

    CombatTab:AddToggle({
        Name = "God Mode",
        Default = false,
        Callback = function(Value)
            _G.GodMode = Value
            while _G.GodMode and wait() do
                pcall(function()
                    Player.Character.Humanoid.Health = Player.Character.Humanoid.MaxHealth
                end)
            end
        end    
    })

    CombatTab:AddToggle({
        Name = "One Shot Kill",
        Default = false,
        Callback = function(Value)
            _G.OneShot = Value
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
        Max = 1000,
        Default = 16,
        Increment = 1,
        Callback = function(Value)
            Player.Character.Humanoid.WalkSpeed = Value
        end    
    })

    PlayerTab:AddSlider({
        Name = "Jump Power",
        Min = 50,
        Max = 1000,
        Default = 50,
        Increment = 1,
        Callback = function(Value)
            Player.Character.Humanoid.JumpPower = Value
        end    
    })

    -- Misc Tab
    local MiscTab = Window:MakeTab({
        Name = "🎮 Misc",
        Icon = "rbxassetid://14476196659"
    })

    _G.AutoChest = false
    _G.CollectDrops = false
    _G.AutoRaid = false

    MiscTab:AddToggle({
        Name = "Auto Collect Chests",
        Default = false,
        Callback = function(Value)
            _G.AutoChest = Value
            while _G.AutoChest and wait() do
                pcall(function()
                    for _, chest in pairs(workspace:GetChildren()) do
                        if chest.Name:find("Chest") then
                            chest:Destroy()
                        end
                    end
                end)
            end
        end    
    })

    MiscTab:AddToggle({
        Name = "Auto Collect Drops",
        Default = false,
        Callback = function(Value)
            _G.CollectDrops = Value
            while _G.CollectDrops and wait() do
                pcall(function()
                    for _, drop in pairs(workspace:GetChildren()) do
                        if drop:IsA("BasePart") and drop.Name:find("Drop") then
                            drop.CFrame = Player.Character.HumanoidRootPart.CFrame
                        end
                    end
                end)
            end
        end    
    })

    -- Anti AFK
    Player.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end

OrionLib:Init()