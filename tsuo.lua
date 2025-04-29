-- Serviços necessários
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Configurações do Script
local Settings = {
    Aimbot = {
        Enabled = false,
        Key = Enum.KeyCode.E,
        TeamCheck = true,
        Smoothness = 0.2,
        TargetPart = "Head",
        FOV = 150,
        ShowFOV = true
    },
    ESP = {
        Enabled = false,
        TeamCheck = true,
        Box = true,
        Name = true,
        Distance = true,
        Health = true,
        TeamColor = Color3.fromRGB(0, 255, 0),
        EnemyColor = Color3.fromRGB(255, 0, 0)
    },
    Combat = {
        NoRecoil = true
    },
    Autofarm = {
        Enabled = false
    }
}

-- Função utilitária para verificar visibilidade (opcional para in-game)
local function IsPlayerVisible(player)
    local character = player.Character
    local head = character and character:FindFirstChild("Head")
    if head then
        local origin = Camera.CFrame.Position
        local direction = (head.Position - origin).unit
        local ray = Ray.new(origin, direction * 500)
        local hit, pos = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character, character})
        return hit and hit:IsDescendantOf(character)
    end
    return false
end

-- Função para calcular a distância de um jogador
local function GetDistanceFromPlayer(part)
    return (part.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
end

-- Função de ESP
local function CreateESP(player)
    local DrawingObjects = {
        Box = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
        Health = Drawing.new("Text")
    }

    DrawingObjects.Box.Thickness = 1
    DrawingObjects.Box.Filled = false

    DrawingObjects.Name.Size = 14
    DrawingObjects.Name.Center = true
    DrawingObjects.Name.Outline = true

    DrawingObjects.Distance.Size = 12
    DrawingObjects.Distance.Center = true
    DrawingObjects.Distance.Outline = true

    DrawingObjects.Health.Size = 12
    DrawingObjects.Health.Center = true
    DrawingObjects.Health.Outline = true

    local function UpdateESP()
        if not Settings.ESP.Enabled then
            for _, obj in pairs(DrawingObjects) do obj.Visible = false end
            return
        end

        local character = player.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") or not character:FindFirstChild("Humanoid") then
            for _, obj in pairs(DrawingObjects) do obj.Visible = false end
            return
        end

        local isTeammate = player.Team == LocalPlayer.Team
        if Settings.ESP.TeamCheck and isTeammate then
            for _, obj in pairs(DrawingObjects) do obj.Visible = false end
            return
        end

        local Vector, OnScreen = Camera:WorldToViewportPoint(character.HumanoidRootPart.Position)
        if not OnScreen then
            for _, obj in pairs(DrawingObjects) do obj.Visible = false end
            return
        end

        local Color = isTeammate and Settings.ESP.TeamColor or Settings.ESP.EnemyColor
        local Distance = GetDistanceFromPlayer(character.HumanoidRootPart)
        local Scale = 1 / (Distance * math.tan(math.rad(Camera.FieldOfView * 0.5)) * 2) * 100

        -- Box ESP
        if Settings.ESP.Box then
            DrawingObjects.Box.Size = Vector2.new(Scale * 4, Scale * 7)
            DrawingObjects.Box.Position = Vector2.new(Vector.X - DrawingObjects.Box.Size.X / 2, Vector.Y - DrawingObjects.Box.Size.Y / 2)
            DrawingObjects.Box.Color = Color
            DrawingObjects.Box.Visible = true
        else
            DrawingObjects.Box.Visible = false
        end

        -- Name ESP
        if Settings.ESP.Name then
            DrawingObjects.Name.Position = Vector2.new(Vector.X, Vector.Y - DrawingObjects.Box.Size.Y / 2 - 15)
            DrawingObjects.Name.Text = player.Name
            DrawingObjects.Name.Color = Color
            DrawingObjects.Name.Visible = true
        else
            DrawingObjects.Name.Visible = false
        end

        -- Distance ESP
        if Settings.ESP.Distance then
            DrawingObjects.Distance.Position = Vector2.new(Vector.X, Vector.Y + DrawingObjects.Box.Size.Y / 2 + 5)
            DrawingObjects.Distance.Text = string.format("%.0f studs", Distance)
            DrawingObjects.Distance.Color = Color
            DrawingObjects.Distance.Visible = true
        else
            DrawingObjects.Distance.Visible = false
        end

        -- Health ESP
        if Settings.ESP.Health then
            local Humanoid = character:FindFirstChild("Humanoid")
            local Health = Humanoid.Health
            local MaxHealth = Humanoid.MaxHealth
            DrawingObjects.Health.Position = Vector2.new(Vector.X + DrawingObjects.Box.Size.X / 2 + 5, Vector.Y)
            DrawingObjects.Health.Text = string.format("%d / %d", Health, MaxHealth)
            DrawingObjects.Health.Color = Color3.fromRGB(255 * (1 - Health/MaxHealth), 255 * (Health/MaxHealth), 0)
            DrawingObjects.Health.Visible = true
        else
            DrawingObjects.Health.Visible = false
        end
    end

    RunService.RenderStepped:Connect(UpdateESP)

    player.CharacterRemoving:Connect(function()
        for _, obj in pairs(DrawingObjects) do obj.Visible = false end
    end)
end

-- Função de Aimbot
local function GetClosestPlayer()
    local ClosestPlayer = nil
    local ShortestDistance = Settings.Aimbot.FOV

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(Settings.Aimbot.TargetPart) then
            local isTeammate = player.Team == LocalPlayer.Team
            if Settings.Aimbot.TeamCheck and isTeammate then
                continue
            end

            local PartPosition = Camera:WorldToViewportPoint(player.Character[Settings.Aimbot.TargetPart].Position)
            local Distance = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(PartPosition.X, PartPosition.Y)).Magnitude

            if Distance < ShortestDistance then
                ClosestPlayer = player
                ShortestDistance = Distance
            end
        end
    end

    return ClosestPlayer
end

-- Círculo de FOV
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.NumSides = 100
FOVCircle.Radius = Settings.Aimbot.FOV
FOVCircle.Filled = false
FOVCircle.Visible = Settings.Aimbot.ShowFOV
FOVCircle.Color = Color3.fromRGB(255, 255, 255)

RunService.RenderStepped:Connect(function()
    if Settings.Aimbot.ShowFOV then
        FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
        FOVCircle.Visible = true
    else
        FOVCircle.Visible = false
    end
end)

-- Lógica de Combate
RunService.RenderStepped:Connect(function()
    if Settings.Aimbot.Enabled and UserInputService:IsKeyDown(Settings.Aimbot.Key) then
        local Target = GetClosestPlayer()
        if Target and Target.Character then
            local TargetPart = Target.Character[Settings.Aimbot.TargetPart]
            local AimPosition = Camera:WorldToViewportPoint(TargetPart.Position)
            local MousePosition = Vector2.new(Mouse.X, Mouse.Y)
            local MoveVector = (Vector2.new(AimPosition.X, AimPosition.Y) - MousePosition) * Settings.Aimbot.Smoothness

            mousemoverel(MoveVector.X, MoveVector.Y)
        end
    end
end)

-- No Recoil
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldNamecall = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    if method == "FireServer" and Settings.Combat.NoRecoil and args[1] == "Recoil" then
        return
    end

    return oldNamecall(self, ...)
end)

-- Função de Autofarm
local function AutofarmPlayers()
    if not Settings.Autofarm.Enabled then return end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
            local isTeammate = player.Team == LocalPlayer.Team
            if Settings.Aimbot.TeamCheck and not isTeammate and player.Character.Humanoid.Health > 0 then
                LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
                -- Ataca o jogador rival
                -- Adicione aqui o método de ataque
                wait(0.5) -- Ajuste conforme necessário para ataque
            end
        end
    end
end

RunService.Stepped:Connect(function()
    if Settings.Autofarm.Enabled then
        AutofarmPlayers()
    end
end)

-- Inicializa ESP para jogadores existentes
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end

-- ESP para novos jogadores
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end)

-- Interface Avaco (exemplo simplificado)
-- Note: Avaco é uma biblioteca fictícia para este exemplo; você deve substituí-la por uma real ou criar uma interface customizada
local AvacoUI = require(game.ReplicatedStorage:WaitForChild("Avaco")) -- Supondo que Avaco esteja em ReplicatedStorage

local window = AvacoUI:CreateWindow("Theus Hub")
window:AddToggle("Aimbot", Settings.Aimbot.Enabled, function(value)
    Settings.Aimbot.Enabled = value
end)
window:AddToggle("ESP", Settings.ESP.Enabled, function(value)
    Settings.ESP.Enabled = value
end)
window:AddToggle("Autofarm", Settings.Autofarm.Enabled, function(value)
    Settings.Autofarm.Enabled = value
end)