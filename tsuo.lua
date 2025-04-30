
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")

local flying = false
local flySpeed = 50
local flyForce = Instance.new("BodyVelocity")
flyForce.Velocity = Vector3.new(0, 0, 0)
flyForce.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
flyForce.Parent = rootPart

-- Cria a interface de botões
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui

local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0, 100, 0, 50)
flyButton.Position = UDim2.new(0, 10, 1, -60)
flyButton.Text = "Fly"
flyButton.Parent = screenGui

local moveUpButton = Instance.new("TextButton")
moveUpButton.Size = UDim2.new(0, 50, 0, 50)
moveUpButton.Position = UDim2.new(0, 120, 1, -60)
moveUpButton.Text = "↑"
moveUpButton.Parent = screenGui

local moveDownButton = Instance.new("TextButton")
moveDownButton.Size = UDim2.new(0, 50, 0, 50)
moveDownButton.Position = UDim2.new(0, 180, 1, -60)
moveDownButton.Text = "↓"
moveDownButton.Parent = screenGui

local moveLeftButton = Instance.new("TextButton")
moveLeftButton.Size = UDim2.new(0, 50, 0, 50)
moveLeftButton.Position = UDim2.new(0, 240, 1, -60)
moveLeftButton.Text = "←"
moveLeftButton.Parent = screenGui

local moveRightButton = Instance.new("TextButton")
moveRightButton.Size = UDim2.new(0, 50, 0, 50)
moveRightButton.Position = UDim2.new(0, 300, 1, -60)
moveRightButton.Text = "→"
moveRightButton.Parent = screenGui

-- Função para ativar/desativar o fly
local function toggleFly()
    flying = not flying
    if flying then
        humanoid:ChangeState(Enum.HumanoidStateType.Physics)
        flyForce.Velocity = Vector3.new(0, 0, 0)
    else
        humanoid:ChangeState(Enum.HumanoidStateType.Landed)
        flyForce.Velocity = Vector3.new(0, 0, 0)
    end
end

-- Eventos dos botões
flyButton.MouseButton1Click:Connect(toggleFly)

local moveDirection = Vector3.new(0, 0, 0)

moveUpButton.MouseButton1Down:Connect(function()
    moveDirection = Vector3.new(0, 0, -1)
end)

moveUpButton.MouseButton1Up:Connect(function()
    moveDirection = Vector3.new(0, 0, 0)
end)

moveDownButton.MouseButton1Down:Connect(function()
    moveDirection = Vector3.new(0, 0, 1)
end)

moveDownButton.MouseButton1Up:Connect(function()
    moveDirection = Vector3.new(0, 0, 0)
end)

moveLeftButton.MouseButton1Down:Connect(function()
    moveDirection = Vector3.new(-1, 0, 0)
end)

moveLeftButton.MouseButton1Up:Connect(function()
    moveDirection = Vector3.new(0, 0, 0)
end)

moveRightButton.MouseButton1Down:Connect(function()
    moveDirection = Vector3.new(1, 0, 0)
end)

moveRightButton.MouseButton1Up:Connect(function()
    moveDirection = Vector3.new(0, 0, 0)
end)

-- Movimento de fly
runService.Heartbeat:Connect(function()
    if flying then
        flyForce.Velocity = moveDirection * flySpeed
    end
end)
