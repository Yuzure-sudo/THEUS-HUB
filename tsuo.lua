
    ESP + AIMBOT NEAREST (TEAMCHECK)
    by Lek do Black (2024)
    Cola isso no executor e já era.
--]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- CONFIG
local ESP_COLOR = Color3.fromRGB(255,0,0)
local ESP_TRANSPARENCY = 0.7

-- CONTROLE
local aiming = false
local espActive = true

-- CHECA SE É INIMIGO
local function isEnemy(player)
    return player.Team ~= LocalPlayer.Team and player ~= LocalPlayer
end

-- CRIA ESP NO PLAYER
local function createESP(part)
    if part:FindFirstChild("LekESP") then return end
    local espBox = Instance.new("BoxHandleAdornment")
    espBox.Name = "LekESP"
    espBox.Size = part.Size
    espBox.Color3 = ESP_COLOR
    espBox.AlwaysOnTop = true
    espBox.Adornee = part
    espBox.Parent = part
    espBox.Transparency = ESP_TRANSPARENCY
    espBox.ZIndex = 10
end

-- LIMPA ESP DOS PLAYERS
local function clearESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            for _, v in pairs(hrp:GetChildren()) do
                if v:IsA("BoxHandleAdornment") and v.Name == "LekESP" then
                    v:Destroy()
                end
            end
        end
    end
end

-- ATUALIZA ESP
local function updateESP()
    if not espActive then clearESP() return end
    for _, player in pairs(Players:GetPlayers()) do
        if isEnemy(player) and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            createESP(player.Character.HumanoidRootPart)
        end
    end
end

-- AIMBOT: PEGA O INIMIGO MAIS PRÓXIMO DO CENTRO DA TELA
local function getNearestEnemy()
    local closest = nil
    local shortest = math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if isEnemy(player) and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X,pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if dist < shortest then
                    shortest = dist
                    closest = player.Character.HumanoidRootPart
                end
            end
        end
    end
    return closest
end

-- TOGGLE AIMBOT (MOUSE2)
UIS.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        aiming = true
    elseif input.KeyCode == Enum.KeyCode.F4 then
        espActive = not espActive
        if not espActive then
            clearESP()
        end
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        aiming = false
    end
end)

-- LOOP PRINCIPAL
RunService.RenderStepped:Connect(function()
    updateESP()
    if aiming then
        local target = getNearestEnemy()
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        end
    end
end)

print("[Lek do Black] ESP + Aimbot ativado. F4 desliga/ativa ESP. Segura botão direito pra mirar automático. Ficar parado é ser cúmplice da própria miséria.")
