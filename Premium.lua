-- THEUS HUB PREMIUM V2
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Player = game:GetService("Players").LocalPlayer
local Window = OrionLib:MakeWindow({
    Name = "THEUS HUB PREMIUM 👑",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "THEUSHUB",
    IntroEnabled = true,
    IntroText = "THEUS HUB PREMIUM",
    IntroIcon = "rbxassetid://7733658504",
    Icon = "rbxassetid://7733658504"
})

-- Key System
local KeyWindow = OrionLib:MakeWindow({
    Name = "THEUS HUB | LOGIN",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "THEUSHUB_LOGIN",
    IntroEnabled = false
})

local Key = "sougostoso"
local KeyTab = KeyWindow:MakeTab({
    Name = "🔑 Key System",
    Icon = "rbxassetid://7733674158",
    PremiumOnly = false
})

KeyTab:AddTextbox({
    Name = "Insira sua Key",
    Default = "",
    TextDisappear = true,
    Callback = function(Value)
        _G.KeyInput = Value
    end	  
})

KeyTab:AddButton({
    Name = "Verificar Key",
    Callback = function()
        if _G.KeyInput == Key then
            KeyWindow:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Yuzure-sudo/THEUS-HUB/main/premium.lua"))()
            OrionLib:MakeNotification({
                Name = "THEUS HUB",
                Content = "Key correta! Bem-vindo ao THEUS HUB Premium!",
                Image = "rbxassetid://7733658504",
                Time = 5
            })
        else
            OrionLib:MakeNotification({
                Name = "THEUS HUB",
                Content = "Key incorreta!",
                Image = "rbxassetid://7733658504",
                Time = 5
            })
        end
    end    
})

KeyTab:AddLabel("📌 Key: sougostoso")
KeyTab:AddLabel("💎 Premium Access")

-- Main Tabs
local FarmTab = Window:MakeTab({
    Name = "🌟 Farm",
    Icon = "rbxassetid://7743878358",
    PremiumOnly = false
})

local CombatTab = Window:MakeTab({
    Name = "⚔️ Combat",
    Icon = "rbxassetid://7743878358",
    PremiumOnly = false
})

local PlayerTab = Window:MakeTab({
    Name = "👤 Player",
    Icon = "rbxassetid://7743878358",
    PremiumOnly = false
})

local TeleportTab = Window:MakeTab({
    Name = "🌐 Teleport",
    Icon = "rbxassetid://7743878358",
    PremiumOnly = false
})

local VisualsTab = Window:MakeTab({
    Name = "👁️ Visuals",
    Icon = "rbxassetid://7743878358",
    PremiumOnly = false
})

-- Farm Section
FarmTab:AddToggle({
    Name = "Auto Farm",
    Default = false,
    Callback = function(Value)
        _G.AutoFarm = Value
        while _G.AutoFarm do
            pcall(function()
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                        if v.Humanoid.Health > 0 then
                            repeat
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = 
                                    v.HumanoidRootPart.CFrame * CFrame.new(0, 7, 0)
                                wait()
                            until not v:FindFirstChild("Humanoid") or v.Humanoid.Health <= 0 or not _G.AutoFarm
                        end
                    end
                end
            end)
            wait()
        end
    end    
})

-- Combat Section
CombatTab:AddToggle({
    Name = "Kill Aura",
    Default = false,
    Callback = function(Value)
        _G.KillAura = Value
        while _G.KillAura do
            pcall(function()
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                        if v.Humanoid.Health > 0 and v.Name ~= game.Players.LocalPlayer.Name then
                            local args = {
                                [1] = v.Humanoid,
                                [2] = {
                                    ["Type"] = "Normal",
                                    ["Hit"] = v.HumanoidRootPart,
                                    ["HitPosition"] = v.HumanoidRootPart.Position,
                                    ["Damage"] = 9999
                                }
                            }
                            game:GetService("ReplicatedStorage").Remotes.Combat:FireServer(unpack(args))
                        end
                    end
                end
            end)
            wait()
        end
    end    
})

CombatTab:AddToggle({
    Name = "God Mode",
    Default = false,
    Callback = function(Value)
        _G.GodMode = Value
        while _G.GodMode do
            pcall(function()
                game.Players.LocalPlayer.Character.Humanoid.Health = 
                    game.Players.LocalPlayer.Character.Humanoid.MaxHealth
            end)
            wait()
        end
    end    
})

-- Player Section
PlayerTab:AddSlider({
    Name = "Walk Speed",
    Min = 16,
    Max = 500,
    Default = 16,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end    
})

PlayerTab:AddSlider({
    Name = "Jump Power",
    Min = 50,
    Max = 500,
    Default = 50,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "Power",
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
    end    
})

-- Visuals Section
VisualsTab:AddToggle({
    Name = "Full Bright",
    Default = false,
    Callback = function(Value)
        if Value then
            game:GetService("Lighting").Brightness = 2
            game:GetService("Lighting").ClockTime = 14
            game:GetService("Lighting").FogEnd = 100000
            game:GetService("Lighting").GlobalShadows = false
            game:GetService("Lighting").OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        else
            game:GetService("Lighting").Brightness = 1
            game:GetService("Lighting").ClockTime = 14
            game:GetService("Lighting").FogEnd = 9000
            game:GetService("Lighting").GlobalShadows = true
            game:GetService("Lighting").OutdoorAmbient = Color3.fromRGB(127, 127, 127)
        end
    end    
})

-- Anti AFK
local VirtualUser = game:GetService('VirtualUser')
Player.Idled:connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

OrionLib:Init()