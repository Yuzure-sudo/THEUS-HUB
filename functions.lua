local Functions = {}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Função auxiliar para teleporte
local function Teleport(position)
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = position
    end
end

-- Função para atacar
local function Attack()
    local args = {
        [1] = "Combat",
        [2] = "M1"
    }
    ReplicatedStorage.Remotes.Functions:InvokeServer(unpack(args))
end

function Functions.AutoFarm()
    while getgenv().AutoFarm do
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            for _, mob in pairs(workspace.Mobs:GetChildren()) do
                if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                    repeat
                        character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
                        Attack()
                        wait(0.1)
                    until not getgenv().AutoFarm or not mob:FindFirstChild("Humanoid") or mob.Humanoid.Health <= 0
                end
            end
        end
        wait(0.1)
    end
end

function Functions.AutoSkills()
    while getgenv().AutoSkills do
        local skills = {"Z", "X", "C", "V", "B", "N"}
        for _, skill in pairs(skills) do
            game:GetService("VirtualInputManager"):SendKeyEvent(true, skill, false, game)
            wait(0.1)
            game:GetService("VirtualInputManager"):SendKeyEvent(false, skill, false, game)
        end
        wait(1)
    end
end

function Functions.AutoChest()
    while getgenv().AutoChest do
        for _, chest in pairs(workspace:GetChildren()) do
            if chest.Name:find("Chest") and chest:FindFirstChild("Interaction") then
                local character = player.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    character.HumanoidRootPart.CFrame = chest.PrimaryPart.CFrame
                    wait(0.5)
                    fireproximityprompt(chest.Interaction)
                end
            end
        end
        wait(1)
    end
end

function Functions.AutoFruit()
    while getgenv().AutoFruit do
        for _, fruit in pairs(workspace:GetChildren()) do
            if fruit.Name:find("Fruit") and fruit:FindFirstChild("Handle") then
                local character = player.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    character.HumanoidRootPart.CFrame = fruit.Handle.CFrame
                    wait(0.5)
                end
            end
        end
        wait(1)
    end
end

function Functions.AutoBossFarm()
    while getgenv().AutoBossFarm do
        for _, mob in pairs(workspace.Mobs:GetChildren()) do
            if mob.Name:find("Boss") and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                repeat
                    local character = player.Character
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
                        Attack()
                    end
                    wait(0.1)
                until not getgenv().AutoBossFarm or not mob:FindFirstChild("Humanoid") or mob.Humanoid.Health <= 0
            end
        end
        wait(1)
    end
end

function Functions.KillAura()
    while getgenv().KillAura do
        local character = player.Character
        if character then
            for _, mob in pairs(workspace.Mobs:GetChildren()) do
                if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                    local distance = (character.HumanoidRootPart.Position - mob.HumanoidRootPart.Position).Magnitude
                    if distance <= 10 then
                        Attack()
                    end
                end
            end
        end
        wait(0.1)
    end
end

function Functions.AutoStats()
    while getgenv().AutoStats do
        local args = {
            [1] = "Stats",
            [2] = getgenv().StatType
        }
        ReplicatedStorage.Remotes.Functions:InvokeServer(unpack(args))
        wait(0.5)
    end
end

function Functions.SpeedHack()
    while getgenv().SpeedHack do
        local character = player.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.WalkSpeed = 100
        end
        wait(0.1)
    end
end

function Functions.JumpHack()
    while getgenv().JumpHack do
        local character = player.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.JumpPower = 100
        end
        wait(0.1)
    end
end

function Functions.SafeZone()
    local safeZone = CFrame.new(1000, 100, 1000) -- Ajuste as coordenadas para uma área segura do jogo
    Teleport(safeZone)
end

function Functions.ServerHop()
    local TeleportService = game:GetService("TeleportService")
    local servers = {}
    local req = game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
    local data = game:GetService("HttpService"):JSONDecode(req)
    
    for _, v in pairs(data.data) do
        if v.playing < v.maxPlayers and v.id ~= game.JobId then
            table.insert(servers, v.id)
        end
    end
    
    if #servers > 0 then
        TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)])
    end
end

return Functions