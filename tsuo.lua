
    ESP + AIMBOT NEAREST (TEAMCHECK) MOBILE
    by Lek do Black (2024)
    Cola no executor mobile e domina o lobby.
--]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

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

-- BOTÕES MOBILE (ScreenGui)
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.IgnoreGuiInset = true
ScreenGui.Name = "LekHaxGui"

-- BOTÃO ESP
local espBtn = Instance.new("TextButton")
espBtn.Parent = ScreenGui
espBtn.Size = UDim2.new(0, 100, 0, 40)
espBtn.Position = UDim2.new(0, 10, 0.85, 0)
espBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
espBtn.TextColor3 = Color3.new(1, 1, 1)
espBtn.TextScaled = true
espBtn.Text = "ESP: ON"
espBtn.BackgroundTransparency = 0.2
espBtn.BorderSizePixel = 0

espBtn.MouseButton1Click:Connect(function()
    espActive = not espActive
    espBtn.Text = espActive and "ESP: ON" or "ESP: OFF"
    if not espActive then clearESP() end
end)

-- BOTÃO AIMBOT
local aimBtn = Instance.new("TextButton")
aimBtn.Parent = ScreenGui
aimBtn.Size = UDim2.new(0, 120, 0, 40)
aimBtn.Position = UDim2.new(0, 120, 0.85, 0)
aimBtn.BackgroundColor3 = Color3.fromRGB(25,40,80)
aimBtn.TextColor3 = Color3.new(1, 1, 1)
aimBtn.TextScaled = true
aimBtn.Text = "AIMBOT (segura)"
aimBtn.BackgroundTransparency = 0.2
aimBtn.BorderSizePixel = 0

aimBtn.MouseButton1Down:Connect(function()
    aiming = true
end)
aimBtn.MouseButton1Up:Connect(function()
    aiming = false
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

print("[Lek do Black] ESP + Aimbot MOBILE ativado. Usa os botões flutuantes pra ligar/desligar. Ficar distraído não é opção, irmão!")
