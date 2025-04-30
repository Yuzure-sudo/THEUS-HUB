--[[ 
    AIMBOT NEAREST (TEAMCHECK) + GUI MINIMIZAR
    Theus Script By Theus (2024)
    Cola no executor e domina o lobby.
--]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

-- ESTADO
local aimbotEnabled = true
local minimized = false

-- CHECA TIME
local function isEnemy(player)
    if not player.Team or not LocalPlayer.Team then return false end
    return player.Team ~= LocalPlayer.Team and player ~= LocalPlayer
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

-- GUI MOBILE/PC COM MINIMIZAR
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "TheusScript"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 260, 0, 70)
mainFrame.Position = UDim2.new(0, 15, 0, 70)
mainFrame.BackgroundColor3 = Color3.fromRGB(25,25,38)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0.5, 0)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Theus Script By Theus"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(0,200,255)
title.TextSize = 22
title.TextStrokeTransparency = 0.6

local status = Instance.new("TextLabel", mainFrame)
status.Size = UDim2.new(0.7, 0, 0.5, 0)
status.Position = UDim2.new(0, 10, 0.5, -7)
status.BackgroundTransparency = 1
status.Text = "Aimbot: ON"
status.Font = Enum.Font.Gotham
status.TextColor3 = Color3.fromRGB(0,255,110)
status.TextSize = 20
status.TextStrokeTransparency = 0.8
status.TextXAlignment = Enum.TextXAlignment.Left

local minimizeBtn = Instance.new("TextButton", mainFrame)
minimizeBtn.Size = UDim2.new(0, 40, 0, 30)
minimizeBtn.Position = UDim2.new(1, -48, 0, 9)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(90, 30, 30)
minimizeBtn.Text = "_"
minimizeBtn.Font = Enum.Font.GothamBlack
minimizeBtn.TextColor3 = Color3.fromRGB(255,255,255)
minimizeBtn.TextSize = 26
minimizeBtn.BorderSizePixel = 0

local function setMinimized(state)
    minimized = state
    if minimized then
        mainFrame.Size = UDim2.new(0, 120, 0, 36)
        status.Visible = false
        title.Text = "Theus Script"
        minimizeBtn.Text = "□"
    else
        mainFrame.Size = UDim2.new(0, 260, 0, 70)
        status.Visible = true
        title.Text = "Theus Script By Theus"
        minimizeBtn.Text = "_"
    end
end

minimizeBtn.MouseButton1Click:Connect(function()
    setMinimized(not minimized)
end)

-- Ativação/desativação do aimbot com clique duplo no título
title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local t = tick()
        if title._lastClick and t - title._lastClick < 0.4 then
            aimbotEnabled = not aimbotEnabled
            status.Text = "Aimbot: " .. (aimbotEnabled and "ON" or "OFF")
            status.TextColor3 = aimbotEnabled and Color3.fromRGB(0,255,110) or Color3.fromRGB(255,0,0)
        end
        title._lastClick = t
    end
end)

-- LOOP PRINCIPAL
RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        local target = getNearestEnemy()
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        end
    end
end)

print("[Theus Script] Aimbot NEAREST ativado. Clique duplo no título para ligar/desligar. Botão minimiza interface. Só os atentos vencem.")