
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local players = game:GetService("Players")
local camera = workspace.CurrentCamera


local aimbotRange = 1000
local aimbotSmoothness = 0.1


local espBoxColor = Color3.new(1, 0, 0)
local espTextColor = Color3.new(1, 1, 1)
local espTextSize = 14
local espTextFont = Enum.Font.SourceSansBold


    return (position1 - position2).Magnitude
end


    local closestPlayer = nil
    local closestDistance = aimbotRange

    for _, player in pairs(players:GetPlayers()) do
        if player ~= player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = calculateDistance(rootPart.Position, player.Character.HumanoidRootPart.Position)
            if distance < closestDistance then
                closestPlayer = player
                closestDistance = distance
            end
        end
    end

    return closestPlayer
end


    aimbotActive = not aimbotActive
end

local function toggleESP()
    espActive = not espActive
end


    if aimbotActive then
        local closestPlayer = findClosestPlayer()
        if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local targetPosition = closestPlayer.Character.HumanoidRootPart.Position
            local direction = (targetPosition - rootPart.Position).Unit
            local currentCFrame = rootPart.CFrame
            local targetCFrame = CFrame.new(rootPart.Position, rootPart.Position + direction)
            rootPart.CFrame = currentCFrame:Lerp(targetCFrame, aimbotSmoothness)
        end
    end
end)


    if espActive then
        for _, player in pairs(players:GetPlayers()) do
            if player ~= player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local distance = calculateDistance(rootPart.Position, player.Character.HumanoidRootPart.Position)
                local screenPosition, onScreen = camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)

                if onScreen then
                    -- Desenha uma caixa ao redor do jogador
                    local box = Instance.new("Frame")
                    box.Size = UDim2.new(0, 50, 0, 50)
                    box.Position = UDim2.new(0, screenPosition.X, 0, screenPosition.Y)
                    box.BackgroundColor3 = espBoxColor
                    box.BorderSizePixel = 0
                    box.Parent = camera:WaitForChild("Viewport")

                    -- Exibe a distância do jogador
                    local distanceLabel = Instance.new("TextLabel")
                    distanceLabel.Size = UDim2.new(0, 50, 0, 20)
                    distanceLabel.Position = UDim2.new(0, screenPosition.X, 0, screenPosition.Y - 30)
                    distanceLabel.Text = string.format("%.1f", distance)
                    distanceLabel.TextColor3 = espTextColor
                    distanceLabel.TextSize = espTextSize
                    distanceLabel.Font = espTextFont
                    distanceLabel.BackgroundColor3 = Color3.new(0, 0, 0)
                    distanceLabel.BorderSizePixel = 0
                    distanceLabel.Parent = camera:WaitForChild("Viewport")
                end
            end
        end
    end
end)


local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui


-- Botão de Aimbot
local aimButton = Instance.new("TextButton")
aimButton.Size = UDim2.new(0, 100, 0, 50)
aimButton.Position = UDim2.new(1, -110, 1, -60)
aimButton.Text = "Aimbot"
aimButton.TextColor3 = Color3.new(1, 1, 1)
aimButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.8)
aimButton.BorderSizePixel = 0
aimButton.Parent = screenGui

-- Botão de ESP
local espButton = Instance.new("TextButton")
espButton.Size = UDim2.new(0, 100, 0, 50)
espButton.Position = UDim2.new(1, -110, 1, -120)
espButton.Text = "ESP"
espButton.TextColor3 = Color3.new(1, 1, 1)
espButton.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
espButton.BorderSizePixel = 0
espButton.Parent = screenGui

-- Eventos dos botões
aimButton.MouseButton1Click:Connect(toggleAimbot)
espButton.MouseButton1Click:Connect(toggleESP)
