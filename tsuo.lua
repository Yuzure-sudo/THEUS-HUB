--[[
    Theus Script By Theus - ESP Universal (TeamCheck)
    Funciona em KRNL, PC e Mobile
    Interface: Ativar/Desativar e Minimizar
--]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local Drawing = Drawing or getgenv().Drawing

local espEnabled = true
local minimized = false
local espObjects = {}

function isEnemy(plr)
    return plr ~= LocalPlayer and plr.Team ~= LocalPlayer.Team
end

function createESP(plr)
    if espObjects[plr] then return end
    espObjects[plr] = {
        box = Drawing.new("Square"),
        name = Drawing.new("Text"),
        dist = Drawing.new("Text")
    }
    local box = espObjects[plr].box
    box.Thickness = 2
    box.Color = Color3.fromRGB(255,0,0)
    box.Filled = false
    box.Transparency = 1

    local name = espObjects[plr].name
    name.Size = 16
    name.Color = Color3.fromRGB(0,255,255)
    name.Center = true
    name.Outline = true

    local dist = espObjects[plr].dist
    dist.Size = 14
    dist.Color = Color3.fromRGB(0,255,80)
    dist.Center = true
    dist.Outline = true
end

function removeESP(plr)
    if not espObjects[plr] then return end
    for _,v in pairs(espObjects[plr]) do pcall(function() v:Remove() end) end
    espObjects[plr] = nil
end

Players.PlayerRemoving:Connect(removeESP)
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        if isEnemy(plr) then createESP(plr) end
    end)
end)

for _,plr in ipairs(Players:GetPlayers()) do
    if isEnemy(plr) then createESP(plr) end
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui
gui.Name = "TheusESP"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 260, 0, 66)
frame.Position = UDim2.new(0, 15, 0, 65)
frame.BackgroundColor3 = Color3.fromRGB(25,25,38)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0.45, 0)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Theus Script By Theus"
title.TextColor3 = Color3.fromRGB(0,200,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 22

local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(0.9, 0, 0.36, 0)
status.Position = UDim2.new(0.05, 0, 0.5, 0)
status.BackgroundTransparency = 1
status.Text = "ESP: ON"
status.Font = Enum.Font.Gotham
status.TextColor3 = Color3.fromRGB(0,255,110)
status.TextSize = 19
status.TextXAlignment = Enum.TextXAlignment.Left

local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(0, 74, 0, 30)
toggle.Position = UDim2.new(1, -78, 0.52, 0)
toggle.BackgroundColor3 = Color3.fromRGB(35, 120, 80)
toggle.Text = "DESLIGAR"
toggle.Font = Enum.Font.GothamBold
toggle.TextColor3 = Color3.fromRGB(255,255,255)
toggle.TextSize = 16
toggle.BorderSizePixel = 0

local minimize = Instance.new("TextButton", frame)
minimize.Size = UDim2.new(0, 40, 0, 30)
minimize.Position = UDim2.new(1, -48, 0, 9)
minimize.BackgroundColor3 = Color3.fromRGB(60, 30, 30)
minimize.Text = "_"
minimize.Font = Enum.Font.GothamBlack
minimize.TextColor3 = Color3.fromRGB(255,255,255)
minimize.TextSize = 26
minimize.BorderSizePixel = 0

local function updateGUI()
    status.Text = "ESP: " .. (espEnabled and "ON" or "OFF")
    status.TextColor3 = espEnabled and Color3.fromRGB(0,255,110) or Color3.fromRGB(255,60,60)
    toggle.Text = espEnabled and "DESLIGAR" or "LIGAR"
    toggle.BackgroundColor3 = espEnabled and Color3.fromRGB(35, 120, 80) or Color3.fromRGB(140, 35, 35)
end

toggle.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    updateGUI()
    if not espEnabled then
        for _,objs in pairs(espObjects) do
            for _,v in pairs(objs) do pcall(function() v.Visible = false end) end
        end
    else
        for _,objs in pairs(espObjects) do
            for _,v in pairs(objs) do pcall(function() v.Visible = true end) end
        end
    end
end)

local function setMinimized(state)
    minimized = state
    if minimized then
        frame.Size = UDim2.new(0, 120, 0, 36)
        status.Visible = false
        title.Text = "Theus Script"
        minimize.Text = "□"
        toggle.Visible = false
    else
        frame.Size = UDim2.new(0, 260, 0, 66)
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

-- LOOP
RunService.RenderStepped:Connect(function()
    if not espEnabled then return end
    for plr,objs in pairs(espObjects) do
        local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if hrp and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
                local sizeY = math.clamp(50 * (Camera.CFrame.Position - hrp.Position).Magnitude / 50, 30, 350)
                local sizeX = sizeY/2
                objs.box.Visible = true
                objs.box.Size = Vector2.new(sizeX, sizeY)
                objs.box.Position = Vector2.new(pos.X - sizeX/2, pos.Y - sizeY/2)
                objs.name.Visible = true
                objs.name.Position = Vector2.new(pos.X, pos.Y - sizeY/2 - 15)
                objs.name.Text = plr.Name
                objs.dist.Visible = true
                local dist = math.floor((Camera.CFrame.Position - hrp.Position).Magnitude)
                objs.dist.Position = Vector2.new(pos.X, pos.Y + sizeY/2 + 2)
                objs.dist.Text = tostring(dist).."m"
            else
                for _,v in pairs(objs) do v.Visible = false end
            end
        else
            for _,v in pairs(objs) do v.Visible = false end
        end
    end
end)

print("[Theus Script By Theus] ESP ON! Só pega inimigo. Minimiza e ativa/desativa do jeito que tu quiser.")