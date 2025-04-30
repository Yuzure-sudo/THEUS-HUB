--[[
    ESP + AIMBOT NEAREST (TEAMCHECK) MOBILE FUNCIONAL
    by Lek do Black (2024)
    Cola no executor mobile e domina geral.
--]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

-- CONFIGS
local ESP_COLOR = Color3.fromRGB(255,0,0)
local ESP_TRANSPARENCY = 0.75

-- ESTADO
local espActive = true
local aiming = false

-- CHECA TIME
local function isEnemy(player)
    if not player.Team or not LocalPlayer.Team then return false end
    return player.Team ~= LocalPlayer.Team and player ~= LocalPlayer
end

-- CRIA ESP
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

-- LIMPA ESP
local function clearESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            for _, v in ipairs(hrp:GetChildren()) do
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
    for _, player in ipairs(Players:GetPlayers()) do
        if isEnemy(player) and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            createESP(player.Character.HumanoidRootPart)
        end
    end
end

-- PEGA O INIMIGO MAIS PRÓXIMO DO CENTRO DA TELA
local function getNearestEnemy()
    local closest = nil
    local shortest = math.huge
    for _, player in ipairs(Players:GetPlayers()) do
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

-- GUI MOBILE: Botões flutuantes
local function makeBtn(txt, pos, color)
    local gui = Instance.new("ScreenGui")
    gui.Parent = game.CoreGui
    gui.ResetOnSpawn = false
    gui.Name = "LekGui_"..txt

    local btn = Instance.new("TextButton")
    btn.Parent = gui
    btn.Size = UDim2.new(0, 120, 0, 46)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBlack
    btn.Text = txt
    btn.BackgroundTransparency = 0.17
    btn.BorderSizePixel = 0
    btn.AnchorPoint = Vector2.new(0,0)
    btn.AutoButtonColor = true
    return btn
end

-- BOTÃO ESP
local espBtn = makeBtn("ESP: ON", UDim2.new(0,12, 0.85,0), Color3.fromRGB(190,55,55))
espBtn.MouseButton1Click:Connect(function()
    espActive = not espActive
    espBtn.Text = espActive and "ESP: ON" or "ESP: OFF"
    if not espActive then clearESP() end
end)

-- BOTÃO AIMBOT
local aimBtn = makeBtn("AIMBOT (Segura)", UDim2.new(0,142, 0.85,0), Color3.fromRGB(40,80,200))
aimBtn.MouseButton1Down:Connect(function()
    aiming = true
end)
aimBtn.MouseButton1Up:Connect(function()
    aiming = false
end)

-- ATUALIZA LOOP
RunService.RenderStepped:Connect(function()
    updateESP()
    if aiming then
        local target = getNearestEnemy()
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        end
    end
end)

print("[Lek do Black] ESP + Aimbot MOBILE FUNCIONANDO. Usa os botões flutuantes. Distraído não fica rico!")
