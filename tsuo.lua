
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")

local flying = false
local flySpeed = 50

-- Função para ativar/desativar o fly
local function toggleFly()
    flying = not flying
    if flying then
        humanoid:ChangeState(Enum.HumanoidStateType.Flying)
    else
        humanoid:ChangeState(Enum.HumanoidStateType.Landed)
    end
end

-- Controle de toque para mobile
local touchStartPosition = nil
local touchEndPosition = nil
local isFlyingButtonHeld = false

userInputService.TouchStarted:Connect(function(touch)
    touchStartPosition = touch.Position
    -- Verifica se o toque foi em uma área específica (botão de fly)
    if touchStartPosition.X < 100 and touchStartPosition.Y > 500 then
        isFlyingButtonHeld = true
        toggleFly()
    end
end)

userInputService.TouchEnded:Connect(function(touch)
    touchEndPosition = touch.Position
    if isFlyingButtonHeld then
        isFlyingButtonHeld = false
        toggleFly()
    end
end)

-- Movimento de fly
runService.Heartbeat:Connect(function()
    if flying then
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            local moveDirection = Vector3.new(0, 0, 0)

            -- Controles de movimento (exemplo: touch ou teclado)
            if userInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDirection = moveDirection + Vector3.new(0, 0, -1)
            end
            if userInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDirection = moveDirection + Vector3.new(0, 0, 1)
            end
            if userInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDirection = moveDirection + Vector3.new(-1, 0, 0)
            end
            if userInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDirection = moveDirection + Vector3.new(1, 0, 0)
            end

            -- Aplica o movimento
            if moveDirection.Magnitude > 0 then
                rootPart.Velocity = moveDirection.Unit * flySpeed
            else
                rootPart.Velocity = Vector3.new(0, 0, 0)
            end
        end
    end
end)
