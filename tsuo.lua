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
 (relativePosition.Y - nSize.Y
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
 flyForce.Velocity = moveDirection * flySpeed
 end
end)
