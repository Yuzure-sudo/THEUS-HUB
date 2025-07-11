local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Criar ScreenGui
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

-- Cantos arredondados do frame
local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 12)
frameCorner.Parent = frame

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 36)
title.Text = "⚙️  AOTR AUTO FARM GUI"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = frame

-- Cantos arredondados do título
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = title

-- Área de conteúdo com scroll (para os toggles)
local scroll = Instance.new("ScrollingFrame")
scroll.Name = "Conteudo"
scroll.Size = UDim2.new(1, -20, 1, -50)
scroll.Position = UDim2.new(0, 10, 0, 46)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 4
scroll.Parent = frame

-- Layout automático dos botões
local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder



-- === TOGGLES ===
addToggle("ESP Titan", false, function() end)

local toggles = {}

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



--LOoops -+
task.spawn(function()
    while true do
        task.wait(0.5)
        if toggles["ESP Titan"]() then
            for _, titan in pairs(workspace:GetChildren()) do
                if titan:FindFirstChild("Nape") then
                    createESP(titan)
                end
            end
        end
    end
end)



-- Esp nape Implementacao --
function createESP(target)
    local nape = target:FindFirstChild("Nape")
    if nape and not nape:FindFirstChild("ESPBox") then
        local box = Instance.new("BillboardGui", nape)
        box.Name = "ESPBox"
        box.AlwaysOnTop = true
        box.Size = UDim2.new(8, 0, 8, 0) -- Hitbox grande
        box.Adornee = nape

        local frame = Instance.new("Frame", box)
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundColor3 = Color3.new(1, 1, 1) -- Branco
        frame.BackgroundTransparency = 0.3
        frame.BorderSizePixel = 0
    end
end
