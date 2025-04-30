--[[
    King Legacy Script v3.2
    Compatível com Mobile e PC
    Atualizado em: 2023
]]--

local Config = {
    Aimbot = {
        Enabled = true,
        Keybind = Enum.KeyCode.Q, -- Pressione Q para travar no alvo
        FOV = 100,
        Smoothness = 0.4,
        Priority = "Closest", -- Closest/Weakest/Strongest
        IgnoreTeam = true,
    },
    ESP = {
        Enabled = true,
        Players = {
            Box = true,
            Name = true,
            Health = true,
            Level = true,
            DevilFruit = true,
            Distance = true,
        },
        NPCs = {
            Enabled = true,
            Name = true,
            Level = true,
            Quest = true,
        },
        MaxDistance = 2000,
    },
    AutoFarm = {
        Enabled = true,
        Range = 500,
        AttackSpeed = 0.2,
        Priority = "Weakest", -- Weakest/Closest/Strongest
    },
    Hacks = {
        Flight = true,
        NoClip = false,
        InfiniteEnergy = true,
        GodMode = false,
        DamageMultiplier = 1, -- 1 = normal, 5 = 5x mais dano
    },
    Safety = {
        AntiKick = true,
        AntiBan = true,
        Randomization = true,
    }
}

-- 🔧 Variáveis Globais
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

-- 🎯 Funções do Aimbot
local function GetClosestTarget()
    local closestTarget = nil
    local closestDistance = Config.Aimbot.FOV
    local currentPos = Camera.CFrame.Position

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if Config.Aimbot.IgnoreTeam and player.Team == LocalPlayer.Team then
                continue
            end

            local rootPart = player.Character.HumanoidRootPart
            local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)

            if onScreen then
                local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude

                if distance < closestDistance then
                    closestDistance = distance
                    closestTarget = player.Character
                end
            end
        end
    end

    -- Verifica NPCs também
    for _, npc in ipairs(workspace.NPCs:GetChildren()) do
        if npc:FindFirstChild("HumanoidRootPart") then
            local screenPos, onScreen = Camera:WorldToViewportPoint(npc.HumanoidRootPart.Position)

            if onScreen then
                local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude

                if distance < closestDistance then
                    closestDistance = distance
                    closestTarget = npc
                end
            end
        end
    end

    return closestTarget
end

local function AimAt(target)
    if not target or not target:FindFirstChild("HumanoidRootPart") then return end

    local rootPart = target.HumanoidRootPart
    local cameraPos = Camera.CFrame.Position
    local targetPos = rootPart.Position + (rootPart.Velocity * 0.15) -- Pequena previsão

    local direction = (targetPos - cameraPos).Unit
    local currentDirection = Camera.CFrame.LookVector
    local smoothedDirection = currentDirection:Lerp(direction, Config.Aimbot.Smoothness)

    Camera.CFrame = CFrame.new(cameraPos, cameraPos + smoothedDirection)
end

-- 👁️🗨️ Funções do ESP
local ESPObjects = {}

local function CreateESP(target, isPlayer)
    if ESPObjects[target] then return end

    local drawings = {
        BoxOutline = Drawing.new("Square"),
        Box = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        HealthBar = Drawing.new("Line"),
        HealthText = Drawing.new("Text"),
        Level = Drawing.new("Text"),
        DevilFruit = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
    }

    for _, drawing in pairs(drawings) do
        drawing.Visible = false
        drawing.ZIndex = 2
        if drawing.ClassName == "Text" then
            drawing.Outline = true
            drawing.Font = 2
            drawing.Size = 13
        end
    end

    ESPObjects[target] = {
        Drawings = drawings,
        IsPlayer = isPlayer
    }
end

local function UpdateESP()
    for target, data in pairs(ESPObjects) do
        if not target or not target.Parent then
            for _, drawing in pairs(data.Drawings) do
                drawing:Remove()
            end
            ESPObjects[target] = nil
        else
            local rootPart = target:FindFirstChild("HumanoidRootPart")
            local humanoid = target:FindFirstChildOfClass("Humanoid")

            if rootPart and humanoid then
                local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                
                if onScreen then
                    local distance = (LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                    if distance > Config.ESP.MaxDistance then
                        for _, drawing in pairs(data.Drawings) do
                            drawing.Visible = false
                        end
                        continue
                    end

                    local headPos = target:FindFirstChild("Head") and Camera:WorldToViewportPoint(target.Head.Position) or screenPos + Vector3.new(0, -2, 0)
                    local boxSize = Vector2.new(
                        math.abs(headPos.X - screenPos.X) * 2,
                        (headPos.Y - screenPos.Y) * 1.5
                    )
                    local boxPos = Vector2.new(
                        screenPos.X - boxSize.X / 2,
                        screenPos.Y - boxSize.Y
                    )

                    -- Caixa do ESP
                    if Config.ESP.Players.Box and data.IsPlayer or Config.ESP.NPCs.Enabled and not data.IsPlayer then
                        data.Drawings.BoxOutline.Size = boxSize
                        data.Drawings.BoxOutline.Position = boxPos
                        data.Drawings.BoxOutline.Color = Color3.new(0, 0, 0)
                        data.Drawings.BoxOutline.Thickness = 2
                        data.Drawings.BoxOutline.Visible = true

                        data.Drawings.Box.Size = boxSize
                        data.Drawings.Box.Position = boxPos
                        data.Drawings.Box.Color = data.IsPlayer and (target.Team == LocalPlayer.Team and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)) or Color3.new(1, 0.5, 0)
                        data.Drawings.Box.Thickness = 1
                        data.Drawings.Box.Visible = true
                    else
                        data.Drawings.BoxOutline.Visible = false
                        data.Drawings.Box.Visible = false
                    end

                    -- Nome
                    if (Config.ESP.Players.Name and data.IsPlayer) or (Config.ESP.NPCs.Name and not data.IsPlayer) then
                        data.Drawings.Name.Text = target.Name
                        data.Drawings.Name.Position = Vector2.new(boxPos.X + boxSize.X / 2, boxPos.Y - 15)
                        data.Drawings.Name.Color = Color3.new(1, 1, 1)
                        data.Drawings.Name.Visible = true
                    else
                        data.Drawings.Name.Visible = false
                    end

                    -- Vida (apenas para jogadores)
                    if Config.ESP.Players.Health and data.IsPlayer and humanoid then
                        local healthPercent = humanoid.Health / humanoid.MaxHealth
                        local barWidth = boxSize.X * healthPercent

                        data.Drawings.HealthBar.From = Vector2.new(boxPos.X - 6, boxPos.Y + boxSize.Y)
                        data.Drawings.HealthBar.To = Vector2.new(boxPos.X - 6, boxPos.Y + boxSize.Y * (1 - healthPercent))
                        data.Drawings.HealthBar.Color = Color3.new(1 - healthPercent, healthPercent, 0)
                        data.Drawings.HealthBar.Thickness = 2
                        data.Drawings.HealthBar.Visible = true

                        data.Drawings.HealthText.Text = math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
                        data.Drawings.HealthText.Position = Vector2.new(boxPos.X + boxSize.X + 5, boxPos.Y + boxSize.Y / 2)
                        data.Drawings.HealthText.Color = Color3.new(1, 1, 1)
                        data.Drawings.HealthText.Visible = true
                    else
                        data.Drawings.HealthBar.Visible = false
                        data.Drawings.HealthText.Visible = false
                    end

                    -- Nível (King Legacy)
                    if Config.ESP.Players.Level and data.IsPlayer then
                        -- Implementar detecção de nível
                        data.Drawings.Level.Text = "Lv. ?"
                        data.Drawings.Level.Position = Vector2.new(boxPos.X + boxSize.X / 2, boxPos.Y + boxSize.Y + 2)
                        data.Drawings.Level.Color = Color3.new(1, 1, 0)
                        data.Drawings.Level.Visible = true
                    else
                        data.Drawings.Level.Visible = false
                    end

                    -- Fruta do Diabo
                    if Config.ESP.Players.DevilFruit and data.IsPlayer then
                        -- Implementar detecção de fruta
                        data.Drawings.DevilFruit.Text = "Fruta: ?"
                        data.Drawings.DevilFruit.Position = Vector2.new(boxPos.X + boxSize.X / 2, boxPos.Y + boxSize.Y + 15)
                        data.Drawings.DevilFruit.Color = Color3.new(0.8, 0, 0.8)
                        data.Drawings.DevilFruit.Visible = true
                    else
                        data.Drawings.DevilFruit.Visible = false
                    end

                    -- Distância
                    if Config.ESP.Players.Distance and data.IsPlayer or Config.ESP.NPCs.Enabled and not data.IsPlayer then
                        data.Drawings.Distance.Text = string.format("[%dm]", math.floor(distance))
                        data.Drawings.Distance.Position = Vector2.new(boxPos.X + boxSize.X / 2, boxPos.Y + boxSize.Y + 30)
                        data.Drawings.Distance.Color = Color3.new(1, 1, 1)
                        data.Drawings.Distance.Visible = true
                    else
                        data.Drawings.Distance.Visible = false
                    end
                else
                    for _, drawing in pairs(data.Drawings) do
                        drawing.Visible = false
                    end
                end
            end
        end
    end
end

-- ⚔️ Auto Farm
local function AutoFarm()
    if not Config.AutoFarm.Enabled or not LocalPlayer.Character then return end

    local closestEnemy = nil
    local closestDistance = Config.AutoFarm.Range

    for _, npc in ipairs(workspace.NPCs:GetChildren()) do
        if npc:FindFirstChild("HumanoidRootPart") and npc:FindFirstChildOfClass("Humanoid") and npc.Humanoid.Health > 0 then
            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - npc.HumanoidRootPart.Position).Magnitude

            if distance < closestDistance then
                closestDistance = distance
                closestEnemy = npc
            end
        end
    end

    if closestEnemy then
        AimAt(closestEnemy)
        -- Simula clique para atacar
        if LocalPlayer.Character:FindFirstChildOfClass("Tool") then
            LocalPlayer.Character:FindFirstChildOfClass("Tool"):Activate()
        end
    end
end

-- 🚀 Flight Hack
local function FlightHack()
    if not Config.Hacks.Flight or not LocalPlayer.Character then return end

    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.FlyingNoPhysics)
    end
end

-- ⚡ Infinite Energy
local function InfiniteEnergy()
    if not Config.Hacks.InfiniteEnergy or not LocalPlayer.Character then return end

    local stats = LocalPlayer.Character:FindFirstChild("Stats")
    if stats and stats:FindFirstChild("Energy") then
        stats.Energy.Value = stats.Energy.MaxValue
    end
end

-- 🛡️ Anti-Kick
local function AntiKick()
    if Config.Safety.AntiKick then
        LocalPlayer.OnClientEvent:Connect(function(event, ...)
            if event == "Kick" or event == "Teleport" then
                return nil
            end
        end)
    end
end

-- 🔄 Loop Principal
local function Main()
    AntiKick()

    -- Cria ESP para jogadores existentes
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            CreateESP(player.Character, true)
        end
    end

    -- Cria ESP para NPCs
    for _, npc in ipairs(workspace.NPCs:GetChildren()) do
        if npc:FindFirstChild("HumanoidRootPart") then
            CreateESP(npc, false)
        end
    end

    -- Detecta novos jogadores
    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(character)
            CreateESP(character, true)
        end)
    end)

    -- Detecta novos NPCs
    workspace.NPCs.ChildAdded:Connect(function(npc)
        if npc:FindFirstChild("HumanoidRootPart") then
            CreateESP(npc, false)
        end
    end)

    -- Loop de atualização
    RunService.Heartbeat:Connect(function()
        if Config.Aimbot.Enabled and UserInputService:IsKeyDown(Config.Aimbot.Keybind) then
            AimAt(GetClosestTarget())
        end

        if Config.ESP.Enabled then
            UpdateESP()
        end

        if Config.AutoFarm.Enabled then
            AutoFarm()
        end

        if Config.Hacks.Flight then
            FlightHack()
        end

        if Config.Hacks.InfiniteEnergy then
            InfiniteEnergy()
        end
    end)
end

-- ▶️ Inicialização
Main()