-- Functions.lua para King Legacy

local Functions = {}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- Anti AFK
function Functions.AntiAFK()
    Player.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end

-- Auto Farm Levels
function Functions.AutoFarm()
    while getgenv().AutoFarm do
        pcall(function()
            local nearestMob = nil
            local shortestDistance = math.huge
            
            for _, mob in pairs(workspace.Mobs:GetChildren()) do
                if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                    local distance = (mob.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        nearestMob = mob
                    end
                end
            end
            
            if nearestMob then
                local targetPosition = nearestMob.HumanoidRootPart.Position + Vector3.new(0, 5, 0)
                local tweenInfo = TweenInfo.new(
                    (targetPosition - Character.HumanoidRootPart.Position).Magnitude/500,
                    Enum.EasingStyle.Linear
                )
                
                local tween = TweenService:Create(
                    Character.HumanoidRootPart,
                    tweenInfo,
                    {CFrame = CFrame.new(targetPosition, nearestMob.HumanoidRootPart.Position)}
                )
                tween:Play()
                
                -- Auto Attack
                local args = {
                    [1] = "Combat",
                    [2] = "M1"
                }
                ReplicatedStorage.Remotes.To_Server.Handle_Initiate_S:FireServer(unpack(args))
            end
        end)
        wait()
    end
end

-- Auto Skills
function Functions.AutoSkills()
    while getgenv().AutoSkills do
        pcall(function()
            local skills = {"Z", "X", "C", "V", "B", "N"}
            for _, skill in pairs(skills) do
                local args = {
                    [1] = "Combat",
                    [2] = skill
                }
                ReplicatedStorage.Remotes.To_Server.Handle_Initiate_S:FireServer(unpack(args))
                wait(0.5)
            end
        end)
        wait(1)
    end
end

-- Auto Collect Chests
function Functions.AutoChest()
    while getgenv().AutoChest do
        pcall(function()
            for _, chest in pairs(workspace.Chest:GetChildren()) do
                if chest:FindFirstChild("Interaction") then
                    Character.HumanoidRootPart.CFrame = chest.Interaction.CFrame
                    wait(0.5)
                    fireproximityprompt(chest.Interaction.ProximityPrompt)
                end
            end
        end)
        wait(1)
    end
end

-- Auto Collect Fruits
function Functions.AutoFruit()
    while getgenv().AutoFruit do
        pcall(function()
            for _, fruit in pairs(workspace:GetChildren()) do
                if fruit:IsA("Tool") and fruit:FindFirstChild("Handle") then
                    Character.HumanoidRootPart.CFrame = fruit.Handle.CFrame
                    wait(0.5)
                    fireproximityprompt(fruit.Handle.ProximityPrompt)
                end
            end
        end)
        wait(1)
    end
end

-- Auto Stat Points
function Functions.AutoStats()
    while getgenv().AutoStats do
        pcall(function()
            local args = {
                [1] = "Add_Point",
                [2] = getgenv().StatType -- "Melee", "Defense", "Sword", "Devil Fruit"
            }
            ReplicatedStorage.Remotes.To_Server.Handle_Initiate_S:FireServer(unpack(args))
        end)
        wait(0.1)
    end
end

-- God Mode (Semi)
function Functions.GodMode()
    while getgenv().GodMode do
        pcall(function()
            if Character.Humanoid.Health < Character.Humanoid.MaxHealth * 0.5 then
                local args = {
                    [1] = "Add_Point",
                    [2] = "Defense"
                }
                ReplicatedStorage.Remotes.To_Server.Handle_Initiate_S:FireServer(unpack(args))
            end
        end)
        wait(0.1)
    end
end

-- Auto Raid
function Functions.AutoRaid()
    while getgenv().AutoRaid do
        pcall(function()
            for _, npc in pairs(workspace.Raids:GetChildren()) do
                if npc:FindFirstChild("HumanoidRootPart") and npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                    Character.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                    -- Auto Attack
                    local args = {
                        [1] = "Combat",
                        [2] = "M1"
                    }
                    ReplicatedStorage.Remotes.To_Server.Handle_Initiate_S:FireServer(unpack(args))
                end
            end
        end)
        wait()
    end
end

-- Infinite Energy
function Functions.InfiniteEnergy()
    while getgenv().InfiniteEnergy do
        pcall(function()
            Player.Character.Energy.Value = Player.Character.Energy.MaxValue
        end)
        wait()
    end
end

-- Speed Hack
function Functions.SpeedHack()
    while getgenv().SpeedHack do
        pcall(function()
            Character.Humanoid.WalkSpeed = 100
        end)
        wait()
    end
end

-- Jump Hack
function Functions.JumpHack()
    while getgenv().JumpHack do
        pcall(function()
            Character.Humanoid.JumpPower = 100
        end)
        wait()
    end
end

return Functions
-- Auto Boss Farm
function Functions.AutoBossFarm()
    while getgenv().AutoBossFarm do
        pcall(function()
            for _, boss in pairs(workspace.Bosses:GetChildren()) do
                if boss:FindFirstChild("HumanoidRootPart") and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
                    local targetPos = boss.HumanoidRootPart.Position + Vector3.new(0, 10, 0)
                    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Linear)
                    local tween = TweenService:Create(
                        Character.HumanoidRootPart,
                        tweenInfo,
                        {CFrame = CFrame.new(targetPos, boss.HumanoidRootPart.Position)}
                    )
                    tween:Play()
                    tween.Completed:Wait()
                    
                    -- Combo Attack
                    for i = 1, 10 do
                        local args = {
                            [1] = "Combat",
                            [2] = "M1"
                        }
                        ReplicatedStorage.Remotes.To_Server.Handle_Initiate_S:FireServer(unpack(args))
                        wait(0.1)
                    end
                end
            end
        end)
        wait()
    end
end

-- Auto Quest
function Functions.AutoQuest()
    while getgenv().AutoQuest do
        pcall(function()
            for _, npc in pairs(workspace.NPCs:GetChildren()) do
                if npc:FindFirstChild("HumanoidRootPart") and npc:FindFirstChild("QuestCFrame") then
                    Character.HumanoidRootPart.CFrame = npc.QuestCFrame.Value
                    wait(1)
                    local args = {
                        [1] = "Quest",
                        [2] = "Accept"
                    }
                    ReplicatedStorage.Remotes.To_Server.Handle_Initiate_S:FireServer(unpack(args))
                end
            end
        end)
        wait(5)
    end
end

-- Auto Dodge
function Functions.AutoDodge()
    while getgenv().AutoDodge do
        pcall(function()
            for _, projectile in pairs(workspace.Projectiles:GetChildren()) do
                if projectile:IsA("Part") and (projectile.Position - Character.HumanoidRootPart.Position).Magnitude < 20 then
                    local dodgePos = Character.HumanoidRootPart.Position + Vector3.new(10, 0, 10)
                    Character.HumanoidRootPart.CFrame = CFrame.new(dodgePos)
                end
            end
        end)
        wait()
    end
end

-- Auto Rebirth
function Functions.AutoRebirth()
    while getgenv().AutoRebirth do
        pcall(function()
            if Player.PlayerStats.Level.Value >= 1000 then
                local args = {
                    [1] = "Rebirth"
                }
                ReplicatedStorage.Remotes.To_Server.Handle_Initiate_S:FireServer(unpack(args))
            end
        end)
        wait(5)
    end
end

-- Instant Kill
function Functions.InstantKill()
    while getgenv().InstantKill do
        pcall(function()
            for _, mob in pairs(workspace.Mobs:GetChildren()) do
                if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                    local args = {
                        [1] = "Combat",
                        [2] = "Special_Attack",
                        [3] = mob.Humanoid
                    }
                    ReplicatedStorage.Remotes.To_Server.Handle_Initiate_S:FireServer(unpack(args))
                end
            end
        end)
        wait()
    end
end

-- Auto Collect All
function Functions.AutoCollectAll()
    while getgenv().AutoCollectAll do
        pcall(function()
            -- Coleta Chests
            for _, chest in pairs(workspace.Chest:GetChildren()) do
                if chest:FindFirstChild("Interaction") then
                    Character.HumanoidRootPart.CFrame = chest.Interaction.CFrame
                    wait(0.1)
                    fireproximityprompt(chest.Interaction.ProximityPrompt)
                end
            end
            
            -- Coleta Fruits
            for _, fruit in pairs(workspace:GetChildren()) do
                if fruit:IsA("Tool") and fruit:FindFirstChild("Handle") then
                    Character.HumanoidRootPart.CFrame = fruit.Handle.CFrame
                    wait(0.1)
                    fireproximityprompt(fruit.Handle.ProximityPrompt)
                end
            end
            
            -- Coleta Drops
            for _, drop in pairs(workspace.Drops:GetChildren()) do
                if drop:FindFirstChild("Handle") then
                    Character.HumanoidRootPart.CFrame = drop.Handle.CFrame
                    wait(0.1)
                    fireproximityprompt(drop.Handle.ProximityPrompt)
                end
            end
        end)
        wait(1)
    end
end

-- Server Hop
function Functions.ServerHop()
    local PlaceId = game.PlaceId
    local servers = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
    for _, server in pairs(servers.data) do
        if server.playing < server.maxPlayers then
            game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceId, server.id)
            break
        end
    end
end

-- Auto Skill Combo
function Functions.AutoSkillCombo()
    while getgenv().AutoSkillCombo do
        pcall(function()
            local combos = {
                {"Z", "X", "C"},
                {"V", "B", "N"},
                {"Z", "X", "V"},
                {"C", "B", "N"}
            }
            
            for _, combo in pairs(combos) do
                for _, skill in pairs(combo) do
                    local args = {
                        [1] = "Combat",
                        [2] = skill
                    }
                    ReplicatedStorage.Remotes.To_Server.Handle_Initiate_S:FireServer(unpack(args))
                    wait(0.2)
                end
                wait(1)
            end
        end)
        wait(2)
    end
end

-- Auto Teleport to Safe Zone
function Functions.SafeZone()
    local safeSpots = {
        CFrame.new(1000, 100, 1000),
        CFrame.new(-1000, 100, -1000),
        CFrame.new(0, 1000, 0)
    }
    
    while getgenv().SafeZone do
        pcall(function()
            for _, spot in pairs(safeSpots) do
                Character.HumanoidRootPart.CFrame = spot
                wait(0.5)
            end
        end)
        wait(1)
    end
end

-- Auto Equip Best Tools
function Functions.AutoEquipBest()
    while getgenv().AutoEquipBest do
        pcall(function()
            for _, tool in pairs(Player.Backpack:GetChildren()) do
                if tool:IsA("Tool") and tool:FindFirstChild("Level") then
                    local currentEquipped = Character:FindFirstChildOfClass("Tool")
                    if not currentEquipped or (currentEquipped:FindFirstChild("Level") and tool.Level.Value > currentEquipped.Level.Value) then
                        Humanoid:EquipTool(tool)
                    end
                end
            end
        end)
        wait(1)
    end
end

-- Auto Use Buffs
function Functions.AutoBuffs()
    while getgenv().AutoBuffs do
        pcall(function()
            for _, item in pairs(Player.Backpack:GetChildren()) do
                if item:FindFirstChild("Buff") then
                    Humanoid:EquipTool(item)
                    wait(0.1)
                    local args = {
                        [1] = "UseItem",
                        [2] = item.Name
                    }
                    ReplicatedStorage.Remotes.To_Server.Handle_Initiate_S:FireServer(unpack(args))
                end
            end
        end)
        wait(30) -- Espera 30 segundos antes de usar buffs novamente
    end
end

-- Kill Aura
function Functions.KillAura()
    while getgenv().KillAura do
        pcall(function()
            for _, mob in pairs(workspace.Mobs:GetChildren()) do
                if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and 
                   mob.Humanoid.Health > 0 and 
                   (mob.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).Magnitude < 50 then
                    
                    local args = {
                        [1] = "Combat",
                        [2] = "M1",
                        [3] = mob.Humanoid
                    }
                    ReplicatedStorage.Remotes.To_Server.Handle_Initiate_S:FireServer(unpack(args))
                end
            end
        end)
        wait()
    end
end

-- Auto Detect and Farm Rare Mobs
function Functions.RareMobFarm()
    local rareMobs = {"Boss", "Elite", "Legendary"} -- Adicione os nomes dos mobs raros aqui
    
    while getgenv().RareMobFarm do
        pcall(function()
            for _, mob in pairs(workspace.Mobs:GetChildren()) do
                for _, rareName in pairs(rareMobs) do
                    if mob.Name:find(rareName) and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                        Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                        
                        -- Ataque completo
                        local skills = {"Z", "X", "C", "V", "B", "N", "M1"}
                        for _, skill in pairs(skills) do
                            local args = {
                                [1] = "Combat",
                                [2] = skill
                            }
                            ReplicatedStorage.Remotes.To_Server.Handle_Initiate_S:FireServer(unpack(args))
                            wait(0.1)
                        end
                    end
                end
            end
        end)
        wait()
    end
end

return Functions