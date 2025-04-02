-- THEUS HUB DEVELOPER
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Player = game:GetService("Players").LocalPlayer

-- Interface de Login Elegante
local LoginWindow = OrionLib:MakeWindow({
    Name = "THEUS HUB | DEVELOPER",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "THEUSHUB_DEV",
    IntroEnabled = true,
    IntroText = "THEUS HUB DEVELOPER",
    IntroIcon = "rbxassetid://14476196659",
    Icon = "rbxassetid://14476196659"
})

-- Sistema de Key Aprimorado
_G.Key = "THEUSDEV"
_G.KeyInput = ""
_G.CheckKey = false

local KeyTab = LoginWindow:MakeTab({
    Name = "🔒 Autenticação",
    Icon = "rbxassetid://14476196659",
    PremiumOnly = false
})

local Section = KeyTab:AddSection({
    Name = "💎 Sistema de Login Premium"
})

KeyTab:AddTextbox({
    Name = "🔑 Insira sua Key",
    Default = "",
    TextDisappear = true,
    Callback = function(Value)
        _G.KeyInput = Value
    end    
})

KeyTab:AddButton({
    Name = "✨ Verificar Key",
    Callback = function()
        if _G.KeyInput == _G.Key then
            LoginWindow:Destroy()
            loadMainHub()
            OrionLib:MakeNotification({
                Name = "THEUS HUB DEVELOPER",
                Content = "Login realizado com sucesso! Bem-vindo desenvolvedor!",
                Image = "rbxassetid://14476196659",
                Time = 5
            })
        else
            OrionLib:MakeNotification({
                Name = "THEUS HUB DEVELOPER",
                Content = "Key inválida! Tente novamente.",
                Image = "rbxassetid://14476196659",
                Time = 5
            })
        end
    end    
})

KeyTab:AddLabel("📱 Otimizado para Mobile")
KeyTab:AddLabel("⭐ Developer Build")

-- Função Principal do Hub
function loadMainHub()
    local Window = OrionLib:MakeWindow({
        Name = "THEUS HUB DEVELOPER",
        HidePremium = false,
        SaveConfig = true,
        ConfigFolder = "THEUSHUB_DEV",
        IntroEnabled = false
    })

    -- Tabs Principais
    local FarmTab = Window:MakeTab({
        Name = "🌟 Farm",
        Icon = "rbxassetid://14476196659",
        PremiumOnly = false
    })

    local CombatTab = Window:MakeTab({
        Name = "⚔️ Combat",
        Icon = "rbxassetid://14476196659",
        PremiumOnly = false
    })

    local TeleportTab = Window:MakeTab({
        Name = "🌐 Teleport",
        Icon = "rbxassetid://14476196659",
        PremiumOnly = false
    })

    local PlayerTab = Window:MakeTab({
        Name = "👤 Player",
        Icon = "rbxassetid://14476196659",
        PremiumOnly = false
    })

    local VisualsTab = Window:MakeTab({
        Name = "👁️ Visual",
        Icon = "rbxassetid://14476196659",
        PremiumOnly = false
    })

    -- Farm Section
    local FarmSection = FarmTab:AddSection({
        Name = "💫 Farm Automático"
    })

    FarmTab:AddToggle({
        Name = "🎯 Auto Farm Mobs",
        Default = false,
        Callback = function(Value)
            _G.AutoFarm = Value
            while _G.AutoFarm do
                pcall(function()
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                            if v.Humanoid.Health > 0 then
                                repeat
                                    Player.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 7, 0)
                                    local args = {
                                        [1] = v.Humanoid,
                                        [2] = {
                                            ["Type"] = "Normal",
                                            ["Hit"] = v.HumanoidRootPart,
                                            ["HitPosition"] = v.HumanoidRootPart.Position,
                                            ["Damage"] = 99999
                                        }
                                    }
                                    game:GetService("ReplicatedStorage").Remotes.Combat:FireServer(unpack(args))
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

    FarmTab:AddToggle({
        Name = "💰 Auto Collect Items",
        Default = false,
        Callback = function(Value)
            _G.AutoCollect = Value
            while _G.AutoCollect do
                pcall(function()
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v:IsA("TouchTransmitter") then
                            firetouchinterest(Player.Character.HumanoidRootPart, v.Parent, 0)
                            wait()
                            firetouchinterest(Player.Character.HumanoidRootPart, v.Parent, 1)
                        end
                    end
                end)
                wait()
            end
        end    
    })

    -- Combat Section
    local CombatSection = CombatTab:AddSection({
        Name = "⚡ Combate Apelão"
    })

    CombatTab:AddToggle({
        Name = "🗡️ Kill Aura Pro",
        Default = false,
        Callback = function(Value)
            _G.KillAura = Value
            while _G.KillAura do
                pcall(function()
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                            if v.Humanoid.Health > 0 and v.Name ~= Player.Name then
                                local args = {
                                    [1] = v.Humanoid,
                                    [2] = {
                                        ["Type"] = "Normal",
                                        ["Hit"] = v.HumanoidRootPart,
                                        ["HitPosition"] = v.HumanoidRootPart.Position,
                                        ["Damage"] = 99999
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
        Name = "🛡️ God Mode",
        Default = false,
        Callback = function(Value)
            _G.GodMode = Value
            while _G.GodMode do
                pcall(function()
                    Player.Character.Humanoid.Health = Player.Character.Humanoid.MaxHealth
                end)
                wait()
            end
        end    
    })

    -- Player Section
    local PlayerSection = PlayerTab:AddSection({
        Name = "🎮 Modificações do Jogador"
    })

    PlayerTab:AddSlider({
        Name = "🏃 Velocidade",
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

    PlayerTab:AddSlider({
        Name = "⬆️ Força do Pulo",
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

    -- Visuals Section
    local VisualsSection = VisualsTab:AddSection({
        Name = "🎨 Visuais"
    })

    VisualsTab:AddToggle({
        Name = "🌞 Full Bright",
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

    -- Anti AFK Aprimorado
    local VirtualUser = game:GetService('VirtualUser')
    Player.Idled:connect(function()
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end

OrionLib:Init()