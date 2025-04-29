-- Theus Hub Aimbot Script para Dispositivos Móveis
-- Aimbot Universal para Roblox

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")

-- Configurações do Aimbot
local aimbotEnabled = true
local aimPart = "Head" -- Parte do corpo que o aimbot vai mirar
local fovCircle = 100 -- Raio do círculo de FOV

-- Função para calcular a distância
local function getDistance(position1, position2)
    return (position1 - position2).magnitude
end

-- Função principal do Aimbot
local function aimbot()
    if not aimbotEnabled then return end

    local closestPlayer = nil
    local closestDistance = fovCircle

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(aimPart) then
            local targetPosition = player.Character[aimPart].Position
            local screenPoint = workspace.CurrentCamera:WorldToScreenPoint(targetPosition)

            local distance = getDistance(Mouse.Hit.p, targetPosition)

            if distance < closestDistance then
                closestDistance = distance
                closestPlayer = player
            end
        end
    end

    if closestPlayer then
        local targetPosition = closestPlayer.Character[aimPart].Position
        local camera = workspace.CurrentCamera
        local direction = (targetPosition - camera.CFrame.Position).unit

        camera.CFrame = CFrame.new(camera.CFrame.Position, camera.CFrame.Position + direction * 10)
    end
end

-- Conectar a função ao RenderStepped para atualização contínua
RunService.RenderStepped:Connect(aimbot)

-- Função para alternar o Aimbot
local function toggleAimbot()
    aimbotEnabled = not aimbotEnabled
end

-- Detectar toques na tela para ativar/desativar o Aimbot
local UserInputService = game:GetService("UserInputService")

UserInputService.TouchTap:Connect(function()
    toggleAimbot()
end)

print("Theus Hub Aimbot para Móveis ativado. Toque na tela para alternar.")
