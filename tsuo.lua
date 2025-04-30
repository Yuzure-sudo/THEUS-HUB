local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local ESPEnabled = false -- Variável para controlar o estado do ESP
local AimbotEnabled = false -- Variável para controlar o estado do Aimbot

-- Função para criar uma linha de ESP ao redor do jogador
local function createESPLine(player)
 if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
 local line = Instance.new("LineHandleAdornment")
 line.Length = 1 -- Largura da linha
 line.Color3 = Color3.new(1, 0, 0) -- Cor da linha (vermelho)
 line.Transparency = 0.5 -- Transparência da linha
 line.ZIndex = 10 -- Camada de visualização
 line.AlwaysOnTop = true -- Sempre visível
 line.Parent = player.Character.HumanoidRootPart
 return line
 end
 return nil
end

-- Função para atualizar o ESP para todos os jogadores
local function updateESP()
 for _, player in ipairs(Players:GetPlayers()) do
 if player ~= LocalPlayer then
 -- Cria o ESP se não existir
 if ESPEnabled then
 if not player:FindFirstChild("ESPLine") then
 local espLine = createESPLine(player)
 if espLine then
 espLine.Name = "ESPLine"
 end
 end
 else
 -- Remove o ESP se estiver desativado
 if player:FindFirstChild("ESPLine") then
 player.ESPLine:Destroy()
 end
 end
 end
 end
end

-- Função para alternar o estado do ESP
local function toggleESP()
 ESPEnabled = not ESPEnabled
 updateESP() -- Atualiza o ESP conforme o novo estado
end

-- Função para o Aimbot
local function aimbot()
 if AimbotEnabled then
 local closestPlayer = nil
 local closestDistance = math.huge

 for _, player in ipairs(Players:GetPlayers()) do
 if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
 local distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).magnitude
 if distance < closestDistance then
 closestDistance = distance
 closestPlayer = player
 end
 end
 end

 if closestPlayer then
 local targetPosition = closestPlayer.Character.HumanoidRootPart.Position
 local lookAt = CFrame.new(Camera.CFrame.Position, targetPosition)
 Camera.CFrame = lookAt -- Mira automaticamente no jogador mais próximo
 end
 end
end

-- Criar uma interface bonita para dispositivos móveis
local function createESPInterface()
 local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
 end
 end

 if closestPlayer then
 local targetPosition = closestPlayer.Character.HumanoidRootPart.Position
 local lookAt = CFrame.new(Camera.CFrame.Position, targetPosition)
 Camera.CFrame = lookAt -- Mira automaticamente no jogador mais próximo
 end
 end
end

-- Criar uma interface bonita para dispositivos móveis
local function createESPInterface()
 local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
 
 local espButton = Instance.new("TextButton", ScreenGui)
 espButton.Size = UDim2.new(0, 200, 0, 50)
 espButton.Position = UDim2.new(0.5, -105, 0.9, 0)
 espButton.Text = "Toggle ESP"
 espButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
 espButton.TextColor3 = Color3.new(1, 1, 1)
 espButton.AnchorPoint = Vector2.new(0.5, 0.5)
 espButton.Font = Enum.Font.SourceSans
 espButton.TextSize = 24

 espButton.MouseButton1Click:Connect(toggleESP) -- Conecta o botão à função de alternar o ESP

 local aimbotButton = Instance.new("TextButton", ScreenGui)
 aimbotButton.Size = UDim2.new(0, 200, 0, 50)
 aimbotButton.Position = UDim2.new(0.5, -105, 0.8, 0)
 aimbotButton.Text = "Toggle Aimbot"
 aimbotButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
 aimbotButton.TextColor3 = Color3.new(1, 1, 1)
 aimbotButton.AnchorPoint = Vector2.new(0.5, 0.5)
 aimbotButton.Font = Enum.Font.SourceSans
 aimbotButton.TextSize = 24

 aimbotButton.MouseButton1Click:Connect(function()
 AimbotEnabled = not AimbotEnabled
 aimbotButton.Text = AimbotEnabled and "Aimbot On" or "Aimbot Off"
 end) -- Alterna o estado do Aimbot e atualiza o texto do botão
end

-- Atualiza o ESP e verifica novos jogadores
Players.PlayerAdded:Connect(function(player)
 player.CharacterAdded:Connect(function()
 updateESP() -- Atualiza o ESP quando um novo jogador é adicionado
 end)
end)

-- Atualiza o ESP em intervalos regulares e ativa o Aimbot
while true do
 updateESP()
 aimbot() -- Chama o Aimbot a cada iteração
 wait(0.1) -- Atualiza a cada 0.1 segundos
end

-- Cria a interface do ESP
createESPInterface()