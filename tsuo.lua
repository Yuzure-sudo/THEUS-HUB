local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local ESPEnabled = false -- Variável para controlar o estado do ESP

-- Função para criar uma caixa de ESP ao redor do jogador
local function createESP(player)
 if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
 local espBox = Instance.new("BoxHandleAdornment")
 espBox.Size = Vector3.new(4, 6, 4) -- Tamanho da caixa
 espBox.Adornee = player.Character.HumanoidRootPart
 espBox.Color3 = Color3.new(1, 0, 0) -- Cor da caixa (vermelho)
 espBox.Transparency = 0.5 -- Transparência da caixa
 espBox.ZIndex = 10 -- Camada de visualização
 espBox.AlwaysOnTop = true -- Sempre visível
 espBox.Parent = player.Character.HumanoidRootPart
 return espBox
 end
 return nil
end

-- Função para atualizar o ESP para todos os jogadores
local function updateESP()
 for _, player in ipairs(Players:GetPlayers()) do
 if player ~= LocalPlayer then
 if ESPEnabled then
 -- Cria o ESP se não existir
 if not player:FindFirstChild("ESPBox") then
 local espBox = createESP(player)
 if espBox then
 espBox.Name = "ESPBox"
 end
 end
 else
 -- Remove o ESP se estiver desativado
 if player:FindFirstChild("ESPBox") then
 player.ESPBox:Destroy()
 end
 end
 end
 end
end

-- Função para exibir a distância
local function displayDistance()
 for _, player in ipairs(Players:GetPlayers()) do
 if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
 local distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).magnitude
 -- Criação de uma etiqueta de distância
 local distanceLabel = Instance.new("BillboardGui")
 distanceLabel.Size = UDim2.new(0, 100, 0, 50)
 distanceLabel.Adornee = player.Character.HumanoidRootPart
 distanceLabel.AlwaysOnTop = true

 local label = Instance.new("TextLabel")
 label.Size = UDim2.new(1, 0, 1, 0)
 label.BackgroundTransparency = 1
 label.Text = string.format("%.1f studs", distance)
 label.TextColor3 = Color3.new(1, 1, 0) -- boardGui")
 distanceLabel.Size = UDim2.new(0, 100, 0, 50)
 distanceLabel.Adornee = player.Character.HumanoidRootPart
 distanceLabel.AlwaysOnTop = true

 local label = Instance.new("TextLabel")
 label.Size = UDim2.new(1, 0, 1, 0)
 label.BackgroundTransparency = 1
 label.Text = string.format("%.1f studs", distance)
 label.TextColor3 = Color3.new(1, 1, 0) -- Cor do texto (amarelo)
 label.Parent = distanceLabel
 distanceLabel.Parent = workspace
 end
 end
end

-- Função para alternar o estado do ESP
local function toggleESP()
 ESPEnabled = not ESPEnabled
 updateESP() -- Atualiza o ESP conforme o novo estado
end

-- Criar uma interface simples para ativar/desativar o ESP
local function createESPInterface()
 local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
 local toggleButton = Instance.new("TextButton", ScreenGui)
 toggleButton.Size = UDim2.new(0, 200, 0, 50)
 toggleButton.Position = UDim2.new(0.5, -100, 0, 10)
 toggleButton.Text = "Toggle ESP"
 toggleButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
 toggleButton.TextColor3 = Color3.new(1, 1, 1)

 toggleButton.MouseButton1Click:Connect(toggleESP) -- Conecta o botão à função de alternar o ESP
end

-- Atualiza o ESP em intervalos regulares
while true do
 updateESP()
 displayDistance()
 wait(0.1) -- Atualiza a cada 0.1 segundos
end

-- Cria a interface do ESP
createESPInterface()