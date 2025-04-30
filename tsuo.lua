local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local ESPEnabled = false -- Variável para controlar o estado do ESP

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