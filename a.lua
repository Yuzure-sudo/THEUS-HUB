-- Astershun Hub Professional - Volleyball Legends (Rayfield UI)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Estado global isolado
local state = getgenv().AstershunHubState or {}
if not state then state = {} end
getgenv().AstershunHubState = state

-- Inicialização das variáveis padrão
state.HitboxActive = false
state.HitboxLoop = false
state.OriginalBallProps = nil

state.AutoPlayActive = false
state.AutoBlockActive = false
state.AutoSetActive = false
state.AutoSpikeActive = false
state.PowerServeActive = false

state.FlyJumpActive = false
state.FlyJumpConnection = nil
state.FlyJumpBV = nil

state.WalkSpeed = 16
state.JumpPower = 50

state.Connections = state.Connections or {}

-- Funções utilitárias --

local function FindBall()
    return Workspace:FindFirstChild("Ball")
end

local function SaveBallProps(ball)
    if not ball then return end
    if state.OriginalBallProps == nil then
        state.OriginalBallProps = {
            Size = ball.Size,
            Transparency = ball.Transparency,
            Color = ball.Color,
            Material = ball.Material,
            CanCollide = ball.CanCollide,
        }
    end
end

local function ResetBall(ball)
    if not ball or not state.OriginalBallProps then return end
    pcall(function()
        ball.Size = state.OriginalBallProps.Size
        ball.Transparency = state.OriginalBallProps.Transparency
        ball.Color = state.OriginalBallProps.Color
        ball.Material = state.OriginalBallProps.Material
        ball.CanCollide = state.OriginalBallProps.CanCollide
    end)
end

local function ApplyHitbox(ball)
    if not ball or state.HitboxActive then return end
    SaveBallProps(ball)
    pcall(function()
        ball.Size = Vector3.new(12, 12, 12)
        ball.Transparency = 0.4
        ball.Color = Color3.fromRGB(255, 0, 80)
        ball.Material = Enum.Material.Neon
        ball.CanCollide = true
    end)
    state.HitboxActive = true
end

local function RemoveHitbox()
    local ball = FindBall()
    if ball and state.HitboxActive then
        ResetBall(ball)
        state.HitboxActive = false
        state.OriginalBallProps = nil
    end
end

local function EnableHitboxLoop(enable)
    state.HitboxLoop = enable
    if enable then
        if state.Connections.HitboxLoop then return end
        state.Connections.HitboxLoop = RunService.Heartbeat:Connect(function()
            local ball = FindBall()
            if ball then
                if not state.HitboxActive then
                    ApplyHitbox(ball)
                end
            else
                RemoveHitbox()
            end
        end)
    else
        if state.Connections.HitboxLoop then
            state.Connections.HitboxLoop:Disconnect()
            state.Connections.HitboxLoop = nil
        end
        RemoveHitbox()
    end
end

-- Power Serve ativado via tecla Z
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Z and state.PowerServeActive then
        local success, err = pcall(function()
            local ServeRemote = Workspace:FindFirstChild("ReplicatedStorage") and game:GetService("ReplicatedStorage"):FindFirstChild("Packages")
            -- Ajuste remoto real do saque (exemplo, deve ajustar conforme jogo real)
            local Knit = game:GetService("ReplicatedStorage"):FindFirstChild("Packages")
            if Knit then
                local GameService = Knit:FindFirstChild("knit") and Knit.knit.Services and Knit.knit.Services.GameService
                if GameService and GameService.RF and GameService.RF.Serve then
                    GameService.RF.Serve:InvokeServer(Vector3.new(0, 0, 0), math.huge)
                end
            end
        end)
        if not success then print("[Astershun Hub] Poderoso saque falhou: "..tostring(err)) end
    end
end)

-- Funções Auto Play baseadas em distância e altura da bola
local function AutoPlay()
    if not state.AutoPlayActive then return end
    local ball = FindBall()
    local char = LocalPlayer.Character
    if not ball or not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    local hrpPos = char.HumanoidRootPart.Position
    local ballPos = ball.Position
    local dist = (hrpPos - ballPos).Magnitude
    local targetPos = Vector3.new(ballPos.X, hrpPos.Y, ballPos.Z)

    if dist > 3 then
        humanoid:MoveTo(targetPos)
    else
        humanoid:MoveTo(hrpPos)
    end

    if ballPos.Y > hrpPos.Y + 8 and dist < 12 then
        humanoid.Jump = true
    end
end

-- Auto Block simples
local function AutoBlock()
    if not state.AutoBlockActive then return end
    local ball = FindBall()
    local char = LocalPlayer.Character
    if not ball or not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")

    local hrp = char.HumanoidRootPart.Position
    local ballPos = ball.Position
    local dist = (hrp - ballPos).Magnitude

    if dist < 10 and ballPos.Y > hrp.Y + 5 then
        humanoid:MoveTo(Vector3.new(ballPos.X, hrp.Y, ballPos.Z))
        if dist < 5 then
            humanoid.Jump = true
        end
    end
end

-- Auto Set simples
local function AutoSet()
    if not state.AutoSetActive then return end
    local ball = FindBall()
    local char = LocalPlayer.Character
    if not ball or not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local hrp = char.HumanoidRootPart.Position
    local ballPos = ball.Position
    local dist = (hrp - ballPos).Magnitude
    if dist > 3 and dist < 10 and ballPos.Y < hrp.Y + 7 then
        humanoid:MoveTo(Vector3.new(ballPos.X, hrp.Y, ballPos.Z))
        if dist < 5 then
            humanoid.Jump = true
        end
    end
end

-- Auto Spike simples
local function AutoSpike()
    if not state.AutoSpikeActive then return end
    local ball = FindBall()
    local char = LocalPlayer.Character
    if not ball or not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local hrp = char.HumanoidRootPart.Position
    local ballPos = ball.Position
    local dist = (hrp - ballPos).Magnitude

    if ballPos.Y > hrp.Y + 10 and dist < 15 then
        humanoid:MoveTo(Vector3.new(ballPos.X, hrp.Y, ballPos.Z))
        humanoid.Jump = true
    end
end

-- Fly Jump ativado/desativado
local function EnableFlyJump(enable)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not humanoid or not hrp then return end

    if state.FlyJumpConnection then
        state.FlyJumpConnection:Disconnect()
        state.FlyJumpConnection = nil
    end
    if state.FlyJumpBV then
        state.FlyJumpBV:Destroy()
        state.FlyJumpBV = nil
    end

    if enable then
        state.FlyJumpConnection = humanoid.StateChanged:Connect(function(_, newState)
            if newState == Enum.HumanoidStateType.Freefall then
                if not state.FlyJumpBV then
                    local bv = Instance.new("BodyVelocity")
                    bv.Name = "AstershunFlyBV"
                    bv.MaxForce = Vector3.new(0, math.huge, 0)
                    bv.Velocity = Vector3.new(0, -15, 0)
                    bv.Parent = hrp
                    state.FlyJumpBV = bv
                end
            else
                if state.FlyJumpBV then
                    state.FlyJumpBV:Destroy()
                    state.FlyJumpBV = nil
                end
            end
        end)
    end

    state.FlyJumpActive = enable
end

-- SuperJump temporário
local function SuperJump()
    local char = LocalPlayer.Character
    if not char then
        Rayfield:Notify({Title="Erro",Content="Personagem não encontrado",Duration=2})
        return
    end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        Rayfield:Notify({Title="Erro",Content="Humanoide não encontrado",Duration=2})
        return
    end
    if humanoid.FloorMaterial == Enum.Material.Air then
        Rayfield:Notify({Title="Aviso",Content="Você deve estar no chão para usar Super Pulo!",Duration=2})
        return
    end

    local originalJumpPower = humanoid.JumpPower
    humanoid.UseJumpPower = true
    humanoid.JumpPower = 160
    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    Rayfield:Notify({Title="Super Pulo",Content="Pulo ativado!",Duration=2})
    task.delay(1, function()
        if humanoid and humanoid.Parent then
            humanoid.JumpPower = originalJumpPower
        end
    end)
end

-- UI Setup Rayfield --

local Window = Rayfield:CreateWindow({
    Name = "Astershun Hub",
    LoadingTitle = "Carregando Hub...",
    LoadingSubtitle = "Volleyball Legends | by Astershun",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "AstershunHub",
        FileName = "Config",
    },
    Discord = { Enabled = false },
    KeySystem = false,
})

local MainTab = Window:CreateTab("🔥 Hacks", nil)

MainTab:CreateButton({
    Name = "Ativar Hitbox Ampliada",
    Callback = function()
        local ball = FindBall()
        if ball then
            ApplyHitbox(ball)
            Rayfield:Notify({Title="Hitbox",Content="Hitbox ampliada aplicada!",Duration=2})
        else
            Rayfield:Notify({Title="Erro",Content="Bola não encontrada!",Duration=2})
        end
    end,
})

MainTab:CreateButton({
    Name = "Resetar Hitbox",
    Callback = function()
        local ball = FindBall()
        if ball and state.HitboxActive then
            ResetBall(ball)
            state.HitboxActive = false
            state.OriginalBallProps = nil
            Rayfield:Notify({Title="Hitbox",Content="Hitbox resetada para padrão.",Duration=2})
        else
            Rayfield:Notify({Title="Aviso",Content="Nada a resetar.",Duration=2})
        end
    end,
})

MainTab:CreateToggle({
    Name = "Manter Hitbox Ativa (Loop)",
    CurrentValue = false,
    Flag = "HitboxLoopToggle",
    Callback = function(Value)
        EnableHitboxLoop(Value)
        Rayfield:Notify({Title="Hitbox Loop",Content=Value and "Ativado" or "Desativado",Duration=2})
    end,
})

MainTab:CreateToggle({
    Name = "Auto Play",
    CurrentValue = false,
    Flag = "AutoPlayToggle",
    Callback = function(Value)
        state.AutoPlayActive = Value
        Rayfield:Notify({Title="Auto Play",Content=Value and "Ativado" or "Desativado",Duration=2})
    end,
})

MainTab:CreateToggle({
    Name = "Auto Block",
    CurrentValue = false,
    Flag = "AutoBlockToggle",
    Callback = function(Value)
        state.AutoBlockActive = Value
        Rayfield:Notify({Title="Auto Block",Content=Value and "Ativado" or "Desativado",Duration=2})
    end,
})

MainTab:CreateToggle({
    Name = "Auto Set",
    CurrentValue = false,
    Flag = "AutoSetToggle",
    Callback = function(Value)
        state.AutoSetActive = Value
        Rayfield:Notify({Title="Auto Set",Content=Value and "Ativado" or "Desativado",Duration=2})
    end,
})

MainTab:CreateToggle({
    Name = "Auto Spike",
    CurrentValue = false,
    Flag = "AutoSpikeToggle",
    Callback = function(Value)
        state.AutoSpikeActive = Value
        Rayfield:Notify({Title="Auto Spike",Content=Value and "Ativado" or "Desativado",Duration=2})
    end,
})

MainTab:CreateToggle({
    Name = "Power Serve (Pressione Z)",
    CurrentValue = false,
    Flag = "PowerServeToggle",
    Callback = function(Value)
        state.PowerServeActive = Value
        Rayfield:Notify({Title="Power Serve",Content=Value and "Ativado" or "Desativado",Duration=2})
    end,
})

MainTab:CreateButton({
    Name = "Super Jump",
    Callback = SuperJump,
})

MainTab:CreateToggle({
    Name = "Fly Jump (Queda lenta)",
    CurrentValue = false,
    Flag = "FlyJumpToggle",
    Callback = function(Value)
        EnableFlyJump(Value)
        Rayfield:Notify({Title="Fly Jump",Content=Value and "Ativado" or "Desativado",Duration=2})
    end,
})

-- Aba Info

local InfoTab = Window:CreateTab("ℹ️ Info", nil)

InfoTab:CreateParagraph({
    Title = "Astershun Hub",
    Content = "Script profissional para Volleyball Legends.\n" ..
              "Inclui funções: Hitbox, Auto Play, Auto Block, Auto Set, Auto Spike, Power Serve, Super Jump e Fly Jump.\n" ..
              "Use com moderação para evitar punições."
})

InfoTab:CreateButton({
    Name = "Fechar Hub",
    Callback = function()
        if state.Connections.HitboxLoop then
            state.Connections.HitboxLoop:Disconnect()
            state.Connections.HitboxLoop = nil
        end
        if state.FlyJumpConnection then
            state.FlyJumpConnection:Disconnect()
            state.FlyJumpConnection = nil
        end
        if state.FlyJumpBV then
            state.FlyJumpBV:Destroy()
            state.FlyJumpBV = nil
        end
        RemoveHitbox()
        Rayfield:Destroy()
    end,
})

-- Loop principal para funções persistentes

state.Connections.MainLoop = RunService.RenderStepped:Connect(function()
    local success, err = pcall(function()
        if state.AutoPlayActive then
            AutoPlay()
        end
        if state.AutoBlockActive then
            AutoBlock()
        end
        if state.AutoSetActive then
            AutoSet()
        end
        if state.AutoSpikeActive then
            AutoSpike()
        end
    end)
    if not success then
        warn("[Astershun Hub] Erro: "..tostring(err))
    end
end)