-- THEUS-HUB Básico Mobile
-- Script ultra simplificado para executores mobile limitados

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Remove GUI anterior se existir
if game:GetService("CoreGui"):FindFirstChild("TheusHUB") then
    game:GetService("CoreGui"):FindFirstChild("TheusHUB"):Destroy()
end

-- Criar GUI simples
local gui = Instance.new("ScreenGui")
gui.Name = "TheusHUB"
gui.ResetOnSpawn = false
gui.Parent = game:GetService("CoreGui")

-- Configurações
local flyEnabled = false
local espEnabled = false
local aimbotEnabled = false

-- Frame principal
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 200)
frame.Position = UDim2.new(0.1, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
title.BorderSizePixel = 0
title.Text = "THEUS-HUB"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.SourceSansBold
title.Parent = frame

-- Botão Fly
local flyButton = Instance.new("TextButton")
flyButton.Position = UDim2.new(0, 10, 0, 40)
flyButton.Size = UDim2.new(1, -20, 0, 40)
flyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 180)
flyButton.BorderSizePixel = 0
flyButton.Text = "FLY"
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255) 
flyButton.TextSize = 18
flyButton.Font = Enum.Font.SourceSansBold
flyButton.Parent = frame

-- Botão ESP
local espButton = Instance.new("TextButton")
espButton.Position = UDim2.new(0, 10, 0, 90)
espButton.Size = UDim2.new(1, -20, 0, 40)
espButton.BackgroundColor3 = Color3.fromRGB(120, 60, 180)
espButton.BorderSizePixel = 0
espButton.Text = "ESP"
espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
espButton.TextSize = 18
espButton.Font = Enum.Font.SourceSansBold
espButton.Parent = frame

-- Botão Aimbot
local aimbotButton = Instance.new("TextButton")
aimbotButton.Position = UDim2.new(0, 10, 0, 140)
aimbotButton.Size = UDim2.new(1, -20, 0, 40)
aimbotButton.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
aimbotButton.BorderSizePixel = 0
aimbotButton.Text = "AIMBOT"
aimbotButton.TextColor3 = Color3.fromRGB(255, 255, 255)
aimbotButton.TextSize = 18
aimbotButton.Font = Enum.Font.SourceSansBold
aimbotButton.Parent = frame

-- Controles para subir/descer (Fly)
local upButton = Instance.new("TextButton")
upButton.Size = UDim2.new(0, 60, 0, 60)
upButton.Position = UDim2.new(0, 220, 0, 40)
upButton.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
upButton.BorderSizePixel = 0
upButton.Text = "SUBIR"
upButton.TextColor3 = Color3.fromRGB(255, 255, 255)
upButton.TextSize = 14
upButton.Font = Enum.Font.SourceSansBold
upButton.Visible = false
upButton.Parent = gui

local downButton = Instance.new("TextButton")
downButton.Size = UDim2.new(0, 60, 0, 60)
downButton.Position = UDim2.new(0, 220, 0, 110)
downButton.BackgroundColor3 = Color3.fromRGB(150, 70, 30)
downButton.BorderSizePixel = 0
downButton.Text = "DESCER"
downButton.TextColor3 = Color3.fromRGB(255, 255, 255)
downButton.TextSize = 14
downButton.Font = Enum.Font.SourceSansBold
downButton.Visible = false
downButton.Parent = gui

-- Variáveis para as funções
local flyGyro, flyVel
local espFolder = Instance.new("Folder", gui)
espFolder.Name = "ESPItems"

-- Função FLY
local function enableFly()
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    
    flyGyro = Instance.new("BodyGyro")
    flyGyro.P = 9e4
    flyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    flyGyro.CFrame = hrp.CFrame
    flyGyro.Parent = hrp
    
    flyVel = Instance.new("BodyVelocity")
    flyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    flyVel.Velocity = Vector3.new(0, 0.1, 0)
    flyVel.Parent = hrp
    
    upButton.Visible = true
    downButton.Visible = true
    
    -- Variáveis para controle
    local isUp = false
    local isDown = false
    
    upButton.MouseButton1Down:Connect(function()
        isUp = true
    end)
    
    upButton.MouseButton1Up:Connect(function()
        isUp = false
    end)
    
    downButton.MouseButton1Down:Connect(function()
        isDown = true
    end)
    
    downButton.MouseButton1Up:Connect(function()
        isDown = false
    end)
    
    -- Loop do voo
    RunService:BindToRenderStep("FlyLoop", 1, function()
        if not flyEnabled then return end
        
        local character = LocalPlayer.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then
            disableFly()
            return
        end
        
        local hrp = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        
        -- Orientação
        flyGyro.CFrame = CFrame.new(hrp.Position, hrp.Position + Camera.CFrame.LookVector)
        
        -- Movimento
        local moveDir = humanoid.MoveDirection
        
        -- Vertical
        local ySpeed = 0
        if isUp then
            ySpeed = 50
        elseif isDown then
            ySpeed = -50
        end
        
        -- Aplicar
        flyVel.Velocity = Vector3.new(
            moveDir.X * 50,
            ySpeed,
            moveDir.Z * 50
        )
    end)
end

local function disableFly()
    RunService:UnbindFromRenderStep("FlyLoop")
    
    if flyGyro then flyGyro:Destroy() end
    if flyVel then flyVel:Destroy() end
    
    flyGyro = nil
    flyVel = nil
    
    upButton.Visible = false
    downButton.Visible = false
end

-- Função ESP
local function enableESP()
    -- Limpar ESP anterior
    espFolder:ClearAllChildren()
    
    -- ESP para jogadores existentes
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            createPlayerESP(player)
        end
    end
    
    -- ESP para novos jogadores
    Players.PlayerAdded:Connect(function(player)
        if espEnabled then
            createPlayerESP(player)
        end
    end)
    
    -- Atualizar ESP
    RunService:BindToRenderStep("ESPLoop", 5, function()
        if not espEnabled then return end
        
        for _, esp in pairs(espFolder:GetChildren()) do
            updateESP(esp)
        end
    end)
end

local function disableESP()
    RunService:UnbindFromRenderStep("ESPLoop")
    espFolder:ClearAllChildren()
end

function createPlayerESP(player)
    local esp = Instance.new("BillboardGui")
    esp.Name = "ESP_" .. player.Name
    esp.AlwaysOnTop = true
    esp.Size = UDim2.new(0, 100, 0, 40)
    esp.StudsOffset = Vector3.new(0, 3, 0)
    esp.Player = player.Name
    esp.Parent = espFolder
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.BackgroundTransparency = 1
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.TextSize = 12
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.Parent = esp
    
    local distLabel = Instance.new("TextLabel")
    distLabel.Name = "DistLabel"
    distLabel.BackgroundTransparency = 1
    distLabel.Position = UDim2.new(0, 0, 0.5, 0)
    distLabel.Size = UDim2.new(1, 0, 0.5, 0)
    distLabel.Text = "0m"
    distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    distLabel.TextStrokeTransparency = 0.5
    distLabel.TextSize = 10
    distLabel.Font = Enum.Font.SourceSans
    distLabel.Parent = esp
end

function updateESP(esp)
    local playerName = esp.Player
    local player = Players:FindFirstChild(playerName)
    
    if not player then
        esp.Enabled = false
        return
    end
    
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        esp.Enabled = false
        return
    end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    
    -- Distância
    local distance = (hrp.Position - Camera.CFrame.Position).Magnitude
    if distance > 1000 then
        esp.Enabled = false
        return
    end
    
    esp.Enabled = true
    esp.Adornee = hrp
    
    -- Atualizar distância
    local distLabel = esp:FindFirstChild("DistLabel")
    if distLabel then
        distLabel.Text = math.floor(distance) .. "m"
    end
    
    -- Atualizar cor
    local nameLabel = esp:FindFirstChild("NameLabel")
    if nameLabel and player.Team then
        nameLabel.TextColor3 = player.TeamColor.Color
    end
end

-- Função Aimbot
local isAiming = false

local function enableAimbot()
    -- Evento para toques
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            isAiming = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            isAiming = false
        end
    end)
    
    -- Loop do aimbot
    RunService:BindToRenderStep("AimbotLoop", 1, function()
        if not aimbotEnabled or not isAiming then return end
        
        local target = getClosestPlayer()
        if not target then return end
        
        local character = target.Character
        if not character or not character:FindFirstChild("Head") then return end
        
        local head = character:FindFirstChild("Head")
        
        -- Mirar no alvo
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position)
    end)
end

local function disableAimbot()
    RunService:UnbindFromRenderStep("AimbotLoop")
end

function getClosestPlayer()
    local closest = nil
    local maxDist = 500
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = player.Character
            if character and character:FindFirstChild("Head") then
                local head = character:FindFirstChild("Head")
                local pos, onScreen = Camera:WorldToScreenPoint(head.Position)
                
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                    
                    if dist < maxDist then
                        maxDist = dist
                        closest = player
                    end
                end
            end
        end
    end
    
    return closest
end

-- Conectar botões
flyButton.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    
    if flyEnabled then
        flyButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        flyButton.Text = "FLY [ON]"
        enableFly()
    else
        flyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 180)
        flyButton.Text = "FLY"
        disableFly()
    end
end)

espButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    
    if espEnabled then
        espButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        espButton.Text = "ESP [ON]"
        enableESP()
    else
        espButton.BackgroundColor3 = Color3.fromRGB(120, 60, 180)
        espButton.Text = "ESP"
        disableESP()
    end
end)

aimbotButton.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    
    if aimbotEnabled then
        aimbotButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        aimbotButton.Text = "AIMBOT [ON]"
        enableAimbot()
    else
        aimbotButton.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
        aimbotButton.Text = "AIMBOT"
        disableAimbot()
    end
end)

-- Mensagem de carregamento
local status = Instance.new("TextLabel")
status.Position = UDim2.new(0, 0, 1, 5)
status.Size = UDim2.new(1, 0, 0, 20)
status.BackgroundTransparency = 1
status.Text = "Script Carregado!"
status.TextColor3 = Color3.fromRGB(100, 255, 100)
status.TextSize = 14
status.Font = Enum.Font.SourceSans
status.Parent = frame

-- Mensagem sobre o autor no canto da tela
local watermark = Instance.new("TextLabel")
watermark.Position = UDim2.new(0, 5, 1, -25)
watermark.Size = UDim2.new(0, 150, 0, 20)
watermark.BackgroundTransparency = 1
watermark.Text = "THEUS-HUB Mobile v1.0"
watermark.TextColor3 = Color3.fromRGB(200, 200, 200)
watermark.TextSize = 12
watermark.TextXAlignment = Enum.TextXAlignment.Left
watermark.Font = Enum.Font.SourceSans
watermark.Parent = gui
