-- Configurações iniciais
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Criação da GUI
local gui = Instance.new("ScreenGui")
gui.Name = "AOTR_GUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Frame principal
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 460)
frame.Position = UDim2.new(0.05, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
frame.BackgroundTransparency = 0.05
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 12)
frameCorner.Parent = frame

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 36)
title.Text = "⚙️ AOTR AUTO FARM GUI"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = title

-- Área de conteúdo
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 1, -50)
scroll.Position = UDim2.new(0, 10, 0, 46)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 4
scroll.Parent = frame

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Variáveis globais
local titanESP = {}
local toggles = {}
local running = false

-- Função para criar toggles
function addToggle(name, default, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 36)
    button.Text = name .. (default and " [ON]" or " [OFF]")
    button.BackgroundColor3 = default and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(150, 50, 50)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.Parent = scroll

    local state = default
    button.MouseButton1Click:Connect(function()
        state = not state
        button.Text = name .. (state and " [ON]" or " [OFF]")
        button.BackgroundColor3 = state and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(150, 50, 50)
        callback(state)
    end)

    toggles[name] = function() return state end
    return button
end

-- Função para criar ESP na nuca do titã
local function createESP(target)
    if not target then return end
    local nape = target:FindFirstChild("Nape")
    if nape and not titanESP[nape] then
        local box = Instance.new("BillboardGui")
        box.Name = "ESPBox"
        box.AlwaysOnTop = true
        box.Size = UDim2.new(8, 0, 8, 0)
        box.Adornee = nape
        box.Parent = nape
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        frame.BackgroundTransparency = 0.7
        frame.BorderSizePixel = 0
        frame.Parent = box
        
        local outline = Instance.new("UIStroke")
        outline.Thickness = 2
        outline.Color = Color3.new(1, 1, 1)
        outline.Parent = frame
        
        titanESP[nape] = box
    end
end

-- Função para remover ESP
local function clearESP()
    for part, esp in pairs(titanESP) do
        if esp then
            esp:Destroy()
        end
    end
    titanESP = {}
end

-- Sistema de ESP para titãs
local function titanESPHandler()
    while running and toggles["ESP Titan"]() do
        for _, obj in ipairs(workspace:GetChildren()) do
            if obj.Name:find("Titan") and obj:FindFirstChild("HumanoidRootPart") then
                createESP(obj)
            end
        end
        task.wait(2)
    end
end

-- Auto Attack Titan
local function autoAttack()
    while running and toggles["Auto Attack"]() do
        local closestTitan, minDistance = nil, math.huge
        local character = LocalPlayer.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        
        if rootPart then
            for _, titan in ipairs(workspace:GetChildren()) do
                if titan.Name:find("Titan") and titan:FindFirstChild("HumanoidRootPart") then
                    local distance = (rootPart.Position - titan.HumanoidRootPart.Position).Magnitude
                    if distance < minDistance then
                        closestTitan = titan
                        minDistance = distance
                    end
                end
            end
            
            if closestTitan and minDistance < 100 then
                -- Simulação de ataque (ajuste para o sistema de combate do jogo)
                game:GetService("ReplicatedStorage").CombatEvents.TitanHit:FireServer(closestTitan, "Nape")
            end
        end
        task.wait(0.5)
    end
end

-- Auto Loot
local function autoLoot()
    while running and toggles["Auto Loot"]() do
        local character = LocalPlayer.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        
        if rootPart then
            for _, item in ipairs(workspace:GetChildren()) do
                if item.Name:find("Loot") and item:FindFirstChild("MainPart") then
                    local distance = (rootPart.Position - item.MainPart.Position).Magnitude
                    if distance < 30 then
                        -- Simulação de coleta
                        firetouchinterest(rootPart, item.MainPart, 0)
                        firetouchinterest(rootPart, item.MainPart, 1)
                    end
                end
            end
        end
        task.wait(1)
    end
end

-- Adicionar toggles
addToggle("ESP Titan", false, function(state)
    if not state then
        clearESP()
    end
end)

addToggle("Auto Attack", false, function(state)
    if state and not running then
        running = true
        autoAttack()
    end
end)

addToggle("Auto Loot", false, function(state)
    if state and not running then
        running = true
        autoLoot()
    end
end)

-- Atualizar tamanho do canvas
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end)

-- Iniciar loop principal
task.spawn(function()
    while task.wait(1) do
        if toggles["ESP Titan"] and toggles["ESP Titan"]() then
            titanESPHandler()
        end
    end
end)

-- Fechar GUI com tecla (opcional)
LocalPlayer:GetMouse().KeyDown:Connect(function(key)
    if key == "p" then
        gui.Enabled = not gui.Enabled
    end
end)