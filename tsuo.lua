local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")

local flying = false
local flySpeed = 50
local dashSpeed = 100
local dashCooldown = 2
local lastDash = 0

local flyForce = Instance.new("BodyVelocity")
flyForce.Velocity = Vector3.new(0, 0, 0)
flyForce.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
flyForce.Parent = rootPart

local flyGyro = Instance.new("BodyGyro")
flyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
flyGyro.P = 10000
flyGyro.D = 100
flyGyro.Parent = rootPart

-- Cria a interface
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui

-- Analógico virtual
local joystickFrame = Instance.new("ImageLabel")
joystickFrame.Size = UDim2.new(0, 150, 0, 150)
joystickFrame.Position = UDim2.new(0, 20, 1, -170)
joystickFrame.Image = "rbxassetid://3570695787" -- Imagem do analógico (pode mudar)
joystickFrame.BackgroundTransparency = 1
joystickFrame.Parent = screenGui

local joystickButton = Instance.new("ImageButton")
joystickButton.Size = UDim2.new(0, 50, 0, 50)
joystickButton.Position = UDim2.new(0.5, -25, 0.5, -25)
joystickButton.Image = "rbxassetid://3570695787" -- Imagem do botão (pode mudar)
joystickButton.BackgroundTransparency = 1
joystickButton.Parent = joystickFrame

-- Botão On/Off
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0, 100, 0, 50)
flyButton.Position = UDim2.new(1, -110, 1, -60)
flyButton.Text = "Off"
flyButton.TextColor3 = Color3.new(1, 1, 1)
flyButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
flyButton.BorderSizePixel = 0
flyButton.Parent = screenGui

-- Botão Dash
local dashButton = Instance.new("TextButton")
dashButton.Size = UDim2.new(0, 100, 0, 50)
dashButton.Position = UDim2.new(1, -110, 1, -120)
dashButton.Text = "Dash"
dashButton.TextColor3 = Color3.new(1, 1, 1)
dashButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.8)
dashButton.BorderSizePixel = 0
dashButton.Parent = screenGui

-- Função para ativar/desativar o fly
local function toggleFly()
 flying = not flying
 if flying then
 humanoid:ChangeState(Enum.HumanoidStateType.Physics)
 flyForce.Velocity = Vector3.new(0, 0, 0)
 flyGyro.CFrame = rootPart.CFrame
 flyButton.Text = "On"
 flyButton.BackgroundColor3 = Color3.new(0, 0.5, 0)
 else
 humanoid:ChangeState(Enum.HumanoidStateType.Landed)
 flyForce.Velocity = Vector3.new(0, 0, 0)
 flyButton.Text = "Off"
 flyButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
 end
end

-- Função para dash
local function dash()
 if tick() - lastDash >= dashCooldown then
 lastDash = tick()
 local camera = workspace.CurrentCamera
 local forward = camera.CFrame.LookVector
 flyForce.Velocity = forward * dashSpeed
 wait(0.2)
 flyForce.Velocity = Vector3.new(0, 0, 0)
 end
end

-- Evento do botão On/Off
flyButton.MouseButton1Click:Connect(toggleFly)

-- Evento do botão Dash
dashButton.MouseButton1Click:Connect(dash)

-- Controle do analógico virtual
local joystickActive = false
local joystickPosition = Vector2.new(0, 0)
local moveDirection = Vector3.new(0, 0, 0)

joystickButton.MouseButton1Down:Connect(function()
 joystickActive = true
end)

joystickButton.MouseButton1Up:Connect(function()
 joystickActive = false
 joystickButton.Position = UDim2.new(0.5, -25, 0.5, -25)
 moveDirection = Vector3.new(0, 0, 0)
end)

userInputService.TouchMoved:Connect(function(touch)
 if joystickActive then
 local touchPosition = touch.Position
 local framePosition = joystickFrame.AbsolutePosition
 local frameSize = joystickFrame.AbsoluteSize
 local relativePosition = Vector2.new(
 (touchPosition.X - framePosition.X) / frameSize.X,
 (touchPosition.Y - framePosition.Y) / frameSize.Y
 )
 relativePosition = Vector2.new(
 math.clamp(relativePosition.X, 0, (touchPosition.X - framePosition.X) / frameSize.X,
 (touchPosition.Y - framePosition.Y) / frameSize.Y
 )
 relativePosition = Vector2.new(
 math.clamp(relativePosition.X, 0, 1),
 math.clamp(relativePosition.Y, 0, 1)
 )
 joystickPosition = Vector2.new(
 (relativePosition.X - 0.5) * 2,
 (relativePosition.Y - 0.5) * 2
 )
 joystickButton.Position = UDim2.new(
 relativePosition.X, -25,
 relativePosition.Y, -25
 )
 moveDirection = Vector3.new(joystickPosition.X, 0, joystickPosition.Y)
 end
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