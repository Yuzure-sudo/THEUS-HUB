-- Script FPS Mobile Avançado
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Interface Moderna
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TopBar = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local MinimizeBtn = Instance.new("ImageButton")
local Container = Instance.new("Frame")
local UICorner_Main = Instance.new("UICorner")
local UICorner_Top = Instance.new("UICorner")
local Shadow = Instance.new("ImageLabel")

-- Configurações Avançadas
_G.Settings = {
    Aimbot = {
        Enabled = false,
        TeamCheck = true,
        TargetPart = "Head",
        Smoothness = 0.25,
        FOV = 400,
        AutoShoot = false,
        PredictMovement = true,
        VisibilityCheck = true,
        HitboxExpander = false,
        HitboxSize = 5
    },
    ESP = {
        Enabled = false,
        TeamCheck = true,
        BoxesEnabled = true,
        NamesEnabled = true,
        HealthEnabled = true,
        DistanceEnabled = true,
        TracersEnabled = true,
        ChamsEnabled = false,
        RainbowMode = false
    },
    AutoFarm = {
        Enabled = false,
        Range = 15,
        TargetClosest = true,
        AutoHeal = true,
        SafeMode = true
    }
}

-- Interface Setup Moderna
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Active = true
MainFrame.Draggable = true

Shadow.Name = "Shadow"
Shadow.Parent = MainFrame
Shadow.BackgroundTransparency = 1
Shadow.Position = UDim2.new(0, -15, 0, -15)
Shadow.Size = UDim2.new(1, 30, 1, 30)
Shadow.Image = "rbxassetid://5028857084"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.6
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(24, 24, 276, 276)

TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

Title.Name = "Title"
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "Ultimate Combat Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Parent = TopBar

MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -35, 0.5, -15)
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Image = "rbxassetid://7072718362"
MinimizeBtn.Parent = TopBar

Container.Name = "Container"
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

UICorner_Main.CornerRadius = UDim.new(0, 10)
UICorner_Main.Parent = MainFrame

UICorner_Top.CornerRadius = UDim.new(0, 10)
UICorner_Top.Parent = TopBar

-- Funções de Criação de Elementos
local function CreateButton(text, position)
    local Button = Instance.new("TextButton")
    local UICorner = Instance.new("UICorner")
    local StatusDot = Instance.new("Frame")
    local UICorner_Dot = Instance.new("UICorner")
    
    Button.Size = UDim2.new(1, 0, 0, 40)
    Button.Position = position
    Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 16
    Button.Font = Enum.Font.GothamSemibold
    Button.Parent = Container
    
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = Button
    
    StatusDot.Size = UDim2.new(0, 10, 0, 10)
    StatusDot.Position = UDim2.new(1, -20, 0.5, -5)
    StatusDot.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    StatusDot.Parent = Button
    
    UICorner_Dot.CornerRadius = UDim.new(1, 0)
    UICorner_Dot.Parent = StatusDot
    
    return Button, StatusDot
end

-- Criar Botões
local AimbotButton, AimbotStatus = CreateButton("Aimbot", UDim2.new(0, 0, 0, 0))
local ESPButton, ESPStatus = CreateButton("ESP", UDim2.new(0, 0, 0, 50))
local AutoFarmButton, AutoFarmStatus = CreateButton("Auto Farm", UDim2.new(0, 0, 0, 100))

-- Funções de Animação
local function AnimateButton(button, enabled)
    local goal = {
        BackgroundColor3 = enabled and Color3.fromRGB(45, 45, 45) or Color3.fromRGB(35, 35, 35)
    }
    
    local tween = TweenService:Create(button, TweenInfo.new(0.3), goal)
    tween:Play()
end

-- Funções Principais
local function UpdateAimbot()
    if not _G.Settings.Aimbot.Enabled then return end
    
    local closest = nil
    local maxDistance = _G.Settings.Aimbot.FOV
    local targetPart = _G.Settings.Aimbot.TargetPart
    
    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if _G.Settings.Aimbot.TeamCheck and player.Team == LocalPlayer.Team then continue end
        
        if player.Character and player.Character:FindFirstChild(targetPart) then
            local part = player.Character[targetPart]
            local partPos = part.Position
            
            if _G.Settings.Aimbot.PredictMovement then
                local velocity = player.Character.HumanoidRootPart.Velocity
                partPos = partPos + (velocity * 0.165)
            end
            
            local screenPos, onScreen = Camera:WorldToScreenPoint(partPos)
            if not onScreen then continue end
            
            local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
            
            if distance < maxDistance then
                closest = player
                maxDistance = distance
            end
        end
    end
    
    if closest then
        local part = closest.Character[targetPart]
        local partPos = part.Position
        
        if _G.Settings.Aimbot.PredictMovement then
            local velocity = closest.Character.HumanoidRootPart.Velocity
            partPos = partPos + (velocity * 0.165)
        end
        
        local screenPos = Camera:WorldToScreenPoint(partPos)
        local moveVector = Vector2.new(
            (screenPos.X - Camera.ViewportSize.X/2) * _G.Settings.Aimbot.Smoothness,
            (screenPos.Y - Camera.ViewportSize.Y/2) * _G.Settings.Aimbot.Smoothness
        )
        
        mousemoverel(moveVector.X, moveVector.Y)
    end
end

-- ESP Function
local function CreateESP(player)
    local esp = {
        Box = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Health = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
        Tracer = Drawing.new("Line")
    }
    
    RunService.RenderStepped:Connect(function()
        if not _G.Settings.ESP.Enabled then
            for _, element in pairs(esp) do
                element.Visible = false
            end
            return
        end
        
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local pos = player.Character.HumanoidRootPart.Position
            local screenPos, onScreen = Camera:WorldToScreenPoint(pos)
            
            if onScreen and player ~= LocalPlayer then
                -- Update ESP elements
                local distance = (LocalPlayer.Character.HumanoidRootPart.Position - pos).Magnitude
                local size = 1000 / distance
                
                esp.Box.Size = Vector2.new(size, size * 1.5)
                esp.Box.Position = Vector2.new(screenPos.X - size/2, screenPos.Y - size * 0.75)
                esp.Box.Color = _G.Settings.ESP.TeamCheck and player.Team == LocalPlayer.Team and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
                esp.Box.Visible = _G.Settings.ESP.BoxesEnabled
                
                esp.Name.Position = Vector2.new(screenPos.X, screenPos.Y - size * 0.9)
                esp.Name.Text = player.Name
                esp.Name.Color = esp.Box.Color
                esp.Name.Visible = _G.Settings.ESP.NamesEnabled
                
                -- Additional ESP features...
            else
                for _, element in pairs(esp) do
                    element.Visible = false
                end
            end
        end
    end)
end

-- Button Click Events
AimbotButton.MouseButton1Click:Connect(function()
    _G.Settings.Aimbot.Enabled = not _G.Settings.Aimbot.Enabled
    AnimateButton(AimbotButton, _G.Settings.Aimbot.Enabled)
    AimbotStatus.BackgroundColor3 = _G.Settings.Aimbot.Enabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
end)

ESPButton.MouseButton1Click:Connect(function()
    _G.Settings.ESP.Enabled = not _G.Settings.ESP.Enabled
    AnimateButton(ESPButton, _G.Settings.ESP.Enabled)
    ESPStatus.BackgroundColor3 = _G.Settings.ESP.Enabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
end)

AutoFarmButton.MouseButton1Click:Connect(function()
    _G.Settings.AutoFarm.Enabled = not _G.Settings.AutoFarm.Enabled
    AnimateButton(AutoFarmButton, _G.Settings.AutoFarm.Enabled)
    AutoFarmStatus.BackgroundColor3 = _G.Settings.AutoFarm.Enabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
end)

-- Minimize Button
local minimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    local goal = {
        Size = minimized and UDim2.new(0, 300, 0, 40) or UDim2.new(0, 300, 0, 400)
    }
    
    local tween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), goal)
    tween:Play()
    
    Container.Visible = not minimized
    MinimizeBtn.Rotation = minimized and 180 or 0
end)

-- Initialize
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end

Players.PlayerAdded:Connect(CreateESP)

-- Main Loop
RunService.RenderStepped:Connect(function()
    if _G.Settings.Aimbot.Enabled then
        UpdateAimbot()
    end
end)

-- Mobile Touch Controls
local TouchEnabled = false
UserInputService.TouchStarted:Connect(function(touch, gameProcessed)
    if not gameProcessed then
        TouchEnabled = true
    end
end)

UserInputService.TouchEnded:Connect(function(touch, gameProcessed)
    if not gameProcessed then
        TouchEnabled = false
    end
end)

-- Notificação de Inicialização
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Script Carregado",
    Text = "Pressione o botão para minimizar/maximizar",
    Duration = 5
})