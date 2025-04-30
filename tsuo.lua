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

local flyGyro = Instance.new("BodyGyro")
flyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
flyGyro.P = 10000
flyGyro.D = 100
flyGyro.Parent = rootPart

-- Cria a interface de botões
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui

-- Botão On/Off
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0, 100, 0, 50)
flyButton.Position = UDim2.new(1, -110, 1, -60)
flyButton.Text = "Off"
flyButton.Parent = screenGui

-- Função para ativar/desativar o fly
local function toggleFly()
 flying = not flying
 if flying then
 humanoid:ChangeState(Enum.HumanoidStateType.Physics)
 flyForce.Velocity = Vector3.new(0, 0, 0)
 flyGyro.CFrame = rootPart.CFrame
 flyButton.Text = "On"
 else
 humanoid:ChangeState(Enum.HumanoidStateType.Landed)
 flyForce.Velocity = Vector3.new(0, 0, 0)
 flyButton.Text = "Off"
 end
end

-- Evento do botão On/Off
flyButton.MouseButton1Click:Connect(toggleFly)

-- Controle do analógico do Roblox
local moveDirection = Vector3.new(0, 0, 0)

userInputService.TouchMoved:Connect(function(touch)
 if flying then
 local touchPosition = touch.Position
 local screenSize = workspace.CurrentCamera.ViewportSize
 local relativePosition = Vector2.new(
 touchPosition.X / screenSize.X,
 touchPosition.Y / screenSize.Y
 )
 moveDirection = Vector3.new(
 (relativePosition.X - 0.5) * 2,
 0,
 (relativePosition.Y - 0.5) * 2
 )
 end
end)

userInputService.TouchEnded:Connect(function()
 moveDirection = Vector3.new(0, 0, 0)
end)

-- Movimento de fly
runService.Heartbeat:Connect(function()
 if flying then
 -- Atualiza a direção do movimento
 local camera = workspace.CurrentCamera
 local forward = camera.CFrame.LookVector
 local right = camera.CFrame.RightVector
 local up = Vector3.new(0, 1, 0)

 local move = forward * moveDirection.Z + right * moveDirection.X + up * moveDirection.Y
 flyForce.Velocity = move * flySpeed

 -- Atualiza a rotação
 flyGyro.CFrame = CFrame.new(rootPart.Position, rootPart.Position + forward)
 end
end)
