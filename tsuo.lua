--[[
    Theus Script By Theus - AIMBOT NEAREST (TeamCheck)
    Só mira automático no inimigo mais próximo do centro da tela.
    Interface com botão LIGAR/DESLIGAR e MINIMIZAR.
--]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

-- ESTADO
local aimbotEnabled = true
local minimized = false

-- CHECA INIMIGO
local function isEnemy(player)
    if not player.Team or not LocalPlayer.Team then return false end
    return player.Team ~= LocalPlayer.Team and player ~= LocalPlayer
end

-- PEGA O INIMIGO MAIS PERTO DO CENTRO DA TELA
local function getNearestEnemy()
    local closest, shortest = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if isEnemy(player) and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if dist < shortest then
                    shortest = dist
                    closest = player.Character.HumanoidRootPart
                end
            end
        end
    end
    return closest
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "TheusScriptAimbot"
gui.Parent = game.CoreGui
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 260, 0, 68)
main.Position = UDim2.new(0, 15, 0, 70)
main.BackgroundColor3 = Color3.fromRGB(20, 25, 38)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0.45, 0)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Theus Script By Theus"
title.TextColor3 = Color3.fromRGB(0,200,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 22

local status = Instance.new("TextLabel", main)
status.Size = UDim2.new(0.9, 0, 0.35, 0)
status.Position = UDim2.new(0.05, 0, 0.48, 0)
status.BackgroundTransparency = 1
status.Text = "Aimbot: ON"
status.Font = Enum.Font.Gotham
status.TextColor3 = Color3.fromRGB(0,255,110)
status.TextSize = 19
status.TextXAlignment = Enum.TextXAlignment.Left

local toggle = Instance.new("TextButton", main)
toggle.Size = UDim2.new(0, 74, 0, 30)
toggle.Position = UDim2.new(1, -78, 0.52, 0)
toggle.BackgroundColor3 = Color3.fromRGB(35, 120, 80)
toggle.Text = "DESLIGAR"
toggle.Font = Enum.Font.GothamBold
toggle.TextColor3 = Color3.fromRGB(255,255,255)
toggle.TextSize = 16
toggle.BorderSizePixel = 0

local minimize = Instance.new("TextButton", main)
minimize.Size = UDim2.new(0, 40, 0, 30)
minimize.Position = UDim2.new(1, -48, 0, 9)
minimize.BackgroundColor3 = Color3.fromRGB(60, 30, 30)
minimize.Text = "_"
minimize.Font = Enum.Font.GothamBlack
minimize.TextColor3 = Color3.fromRGB(255,255,255)
minimize.TextSize = 26
minimize.BorderSizePixel = 0

local function updateGUI()
    status.Text = "Aimbot: " .. (aimbotEnabled and "ON" or "OFF")
    status.TextColor3 = aimbotEnabled and Color3.fromRGB(0,255,110) or Color3.fromRGB(255,60,60)
    toggle.Text = aimbotEnabled and "DESLIGAR" or "LIGAR"
    toggle.BackgroundColor3 = aimbotEnabled and Color3.fromRGB(35, 120, 80) or Color3.fromRGB(140, 35, 35)
end

toggle.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    updateGUI()
end)

local function setMinimized(state)
    minimized = state
    if minimized then
        main.Size = UDim2.new(0, 120, 0, 36)
        status.Visible = false
        title.Text = "Theus Script"
        minimize.Text = "□"
        toggle.Visible = false
    else
        main.Size = UDim2.new(0, 260, 0, 68)
        status.Visible = true
        title.Text = "Theus Script By Theus"
        minimize.Text = "_"
        toggle.Visible = true
    end
end

minimize.MouseButton1Click:Connect(function()
    setMinimized(not minimized)
end)

updateGUI()

-- LOOP AIMBOT
RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        local target = getNearestEnemy()
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        end
    end
end)

print("[Theus Script By Theus] Aimbot NEAREST 100% FUNCIONAL! Só mira no inimigo mais próximo do centro. Interface tunada. Só vitória, irmão!")