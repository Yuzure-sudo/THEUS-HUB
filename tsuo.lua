-- Mega Script FPS Aimbot
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")

-- Interface Principal
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local TopBar = Instance.new("Frame")
local UICorner_2 = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local MinimizeBtn = Instance.new("TextButton")
local UICorner_3 = Instance.new("UICorner")
local Container = Instance.new("Frame")
local UICorner_4 = Instance.new("UICorner")

-- Interface Setup
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Name = HttpService:GenerateGUID(false)
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
MainFrame.Size = UDim2.new(0, 250, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true

UICorner.Parent = MainFrame
UICorner.CornerRadius = UDim.new(0, 10)

TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TopBar.Size = UDim2.new(1, 0, 0, 30)

UICorner_2.Parent = TopBar
UICorner_2.CornerRadius = UDim.new(0, 10)

Title.Name = "Title"
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "Theus Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Parent = TopBar
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 75, 75)
MinimizeBtn.Position = UDim2.new(1, -25, 0.5, -5)
MinimizeBtn.Size = UDim2.new(0, 10, 0, 10)
MinimizeBtn.Font = Enum.Font.SourceSans
MinimizeBtn.Text = ""
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

UICorner_3.Parent = MinimizeBtn
UICorner_3.CornerRadius = UDim.new(1, 0)

Container.Name = "Container"
Container.Parent = MainFrame
Container.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Container.Position = UDim2.new(0, 5, 0, 35)
Container.Size = UDim2.new(1, -10, 1, -40)

UICorner_4.Parent = Container
UICorner_4.CornerRadius = UDim.new(0, 10)

-- Configurações Globais
_G.Settings = {
    Aimbot = {
        Enabled = false,
        TargetPart = "Head",
        TeamCheck = true,
        VisibilityCheck = true,
        Smoothness = 0.25,
        FOV = 250,
        ShowFOV = true,
        TargetLock = false,
        AutoShoot = false,
        PredictMovement = true,
        WallCheck = true,
        RapidFire = false,
        NoRecoil = true,
        AutoReload = true,
        SilentAim = false,
        TriggerBot = false,
        AimAssist = true,
        HeadshotPercentage = 80,
        MaxDistance = 1000,
        MinDistance = 10,
        RecoilControl = true,
        BulletDrop = true,
        SpreadControl = true,
        AimKey = Enum.KeyCode.E,
        AimAssistKey = Enum.KeyCode.LeftShift,
        TriggerKey = Enum.KeyCode.X
    },
    ESP = {
        Enabled = false,
        TeamCheck = true,
        ShowHealth = true,
        ShowDistance = true,
        ShowName = true,
        ShowBox = true,
        ShowTracer = true,
        ShowChams = true,
        RainbowChams = false,
        ChamsTransparency = 0.5,
        ChamsColor = Color3.fromRGB(255, 0, 0),
        BoxColor = Color3.fromRGB(255, 255, 255),
        TracerColor = Color3.fromRGB(255, 255, 255),
        TextColor = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        TextFont = Enum.Font.SourceSansBold,
        MaxDistance = 2000,
        MinDistance = 5
    },
    Misc = {
        NoClip = false,
        SpeedHack = false,
        JumpHack = false,
        InfiniteJump = false,
        BunnyHop = false,
        AutoStrafe = false,
        SpeedMultiplier = 2,
        JumpMultiplier = 2,
        ThirdPerson = false,
        FreeCam = false,
        FullBright = false,
        NoFog = false,
        CustomFOV = false,
        FOVValue = 90,
        CrosshairEnabled = true,
        CrosshairSize = 5,
        CrosshairThickness = 2,
        CrosshairColor = Color3.fromRGB(255, 255, 255)
    }
}

-- Variáveis Locais
local ESPContainer = {}
local TargetPlayer = nil
local IsAiming = false
local IsShooting = false
local LastShot = 0
local ShootCooldown = 0.1
local PredictionMultiplier = 1
local AimbotConnection = nil
local ESPConnection = nil
local WallCheckParams = RaycastParams.new()
WallCheckParams.FilterType = Enum.RaycastFilterType.Blacklist
WallCheckParams.FilterDescendantsInstances = {LocalPlayer.Character}

-- FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.NumSides = 100
FOVCircle.Radius = _G.Settings.Aimbot.FOV
FOVCircle.Filled = false
FOVCircle.Visible = _G.Settings.Aimbot.ShowFOV
FOVCircle.ZIndex = 999
FOVCircle.Transparency = 1
FOVCircle.Color = Color3.fromRGB(255, 255, 255)

-- Crosshair
local CrosshairHorizontal = Drawing.new("Line")
local CrosshairVertical = Drawing.new("Line")

-- Funções Utilitárias
local function IsAlive(player)
    local character = player.Character
    return character and character:FindFirstChild("Humanoid") 
           and character:FindFirstChild("Head")
           and character.Humanoid.Health > 0
end

local function IsTeammate(player)
    if not _G.Settings.Aimbot.TeamCheck then return false end
    return player.Team == LocalPlayer.Team
end

local function IsVisible(character, part)
    if not _G.Settings.Aimbot.WallCheck then return true end
    
    local origin = Camera.CFrame.Position
    local direction = (part.Position - origin).Unit
    local distance = (part.Position - origin).Magnitude
    
    local ray = workspace:Raycast(origin, direction * distance, WallCheckParams)
    return not ray or ray.Instance:IsDescendantOf(character)
end

local function CalculatePrediction(player)
    if not _G.Settings.Aimbot.PredictMovement then return Vector3.new(0, 0, 0) end
    
    local character = player.Character
    if not character then return Vector3.new(0, 0, 0) end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return Vector3.new(0, 0, 0) end
    
    return humanoidRootPart.Velocity * PredictionMultiplier
end

local function GetTargetPart(character)
    return character:FindFirstChild(_G.Settings.Aimbot.TargetPart) or 
           character:FindFirstChild("Head") or 
           character:FindFirstChild("HumanoidRootPart")
end

local function GetClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = _G.Settings.Aimbot.FOV
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsAlive(player) and not IsTeammate(player) then
            local character = player.Character
            local targetPart = GetTargetPart(character)
            
            if targetPart then
                local screenPoint = Camera:WorldToScreenPoint(targetPart.Position)
                local vectorDistance = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(screenPoint.X, screenPoint.Y)).Magnitude
                
                if vectorDistance < shortestDistance then
                    local distance = (character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                    
                    if distance <= _G.Settings.Aimbot.MaxDistance and distance >= _G.Settings.Aimbot.MinDistance and IsVisible(character, targetPart) then
                        closestPlayer = player
                        shortestDistance = vectorDistance
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

-- ESP Functions
local function CreateESPElements(player)
    local esp = {
        Box = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
        Tracer = Drawing.new("Line"),
        HealthBar = Drawing.new("Square"),
        HealthBarBackground = Drawing.new("Square")
    }
    
    esp.Box.Thickness = 1
    esp.Box.Filled = false
    esp.Box.Color = _G.Settings.ESP.BoxColor
    esp.Box.Visible = false
    esp.Box.ZIndex = 1
    
    esp.Name.Font = _G.Settings.ESP.TextFont
    esp.Name.Size = _G.Settings.ESP.TextSize
    esp.Name.Color = _G.Settings.ESP.TextColor
    esp.Name.Center = true
    esp.Name.Outline = true
    esp.Name.Visible = false
    
    esp.Distance.Font = _G.Settings.ESP.TextFont
    esp.Distance.Size = _G.Settings.ESP.TextSize
    esp.Distance.Color = _G.Settings.ESP.TextColor
    esp.Distance.Center = true
    esp.Distance.Outline = true
    esp.Distance.Visible = false
    
    esp.Tracer.Thickness = 1
    esp.Tracer.Color = _G.Settings.ESP.TracerColor
    esp.Tracer.Visible = false
    
    esp.HealthBar.Thickness = 1
    esp.HealthBar.Filled = true
    esp.HealthBar.Color = Color3.fromRGB(0, 255, 0)
    esp.HealthBar.Visible = false
    
    esp.HealthBarBackground.Thickness = 1
    esp.HealthBarBackground.Filled = true
    esp.HealthBarBackground.Color = Color3.fromRGB(255, 0, 0)
    esp.HealthBarBackground.Visible = false
    
    ESPContainer[player] = esp
end

local function RemoveESPElements(player)
    local esp = ESPContainer[player]
    if esp then
        for _, element in pairs(esp) do
            element:Remove()
        end
        ESPContainer[player] = nil
    end
end

local function UpdateESP()
    for player, esp in pairs(ESPContainer) do
        if not player.Parent or not IsAlive(player) or (IsTeammate(player) and _G.Settings.ESP.TeamCheck) then
            esp.Box.Visible = false
            esp.Name.Visible = false
            esp.Distance.Visible = false
            esp.Tracer.Visible = false
            esp.HealthBar.Visible = false
            esp.HealthBarBackground.Visible = false
            continue
        end
        
        local character = player.Character
        local cframe = character:GetPivot()
        local position = cframe.Position
        
        local screenPosition, onScreen = Camera:WorldToScreenPoint(position)
        local distance = (position - Camera.CFrame.Position).Magnitude
        
        if not onScreen or distance > _G.Settings.ESP.MaxDistance then
            esp.Box.Visible = false
            esp.Name.Visible = false
            esp.Distance.Visible = false
            esp.Tracer.Visible = false
            esp.HealthBar.Visible = false
            esp.HealthBarBackground.Visible = false
            continue
        end
        
        local size = Vector2.new(2000 / distance, 2500 / distance)
        local boxPosition = Vector2.new(screenPosition.X - size.X / 2, screenPosition.Y - size.Y / 2)
        
        esp.Box.Size = size
        esp.Box.Position = boxPosition
        esp.Box.Visible = _G.Settings.ESP.ShowBox
        
        esp.Name.Position = Vector2.new(screenPosition.X, boxPosition.Y - esp.Name.TextBounds.Y - 2)
        esp.Name.Text = player.Name
        esp.Name.Visible = _G.Settings.ESP.ShowName
        
        esp.Distance.Position = Vector2.new(screenPosition.X, boxPosition.Y + size.Y + 2)
        esp.Distance.Text = string.format("%.0f studs", distance)
        esp.Distance.Visible = _G.Settings.ESP.ShowDistance
        
        if _G.Settings.ESP.ShowTracer then
            esp.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
            esp.Tracer.To = Vector2.new(screenPosition.X, screenPosition.Y)
            esp.Tracer.Visible = true
        else
            esp.Tracer.Visible = false
        end
        
        if _G.Settings.ESP.ShowHealth then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                local health = humanoid.Health
                local maxHealth = humanoid.MaxHealth
                local healthPercentage = health / maxHealth
                
                local healthBarSize = Vector2.new(2, size.Y)
                local healthBarPosition = Vector2.new(boxPosition.X - healthBarSize.X * 2, boxPosition.Y)
                
                esp.HealthBarBackground.Size = healthBarSize
                esp.HealthBarBackground.Position = healthBarPosition
                esp.HealthBarBackground.Visible = true
                
                esp.HealthBar.Size = Vector2.new(healthBarSize.X, healthBarSize.Y * healthPercentage)
                esp.HealthBar.Position = Vector2.new(healthBarPosition.X, healthBarPosition.Y + healthBarSize.Y * (1 - healthPercentage))
                esp.HealthBar.Color = Color3.fromRGB(255 - 255 * healthPercentage, 255 * healthPercentage, 0)
                esp.HealthBar.Visible = true
            end
        else
            esp.HealthBar.Visible = false
            esp.HealthBarBackground.Visible = false
        end
    end
end

-- Aimbot Functions
local function UpdateFOVCircle()
    FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
    FOVCircle.Radius = _G.Settings.Aimbot.FOV
    FOVCircle.Visible = _G.Settings.Aimbot.ShowFOV and _G.Settings.Aimbot.Enabled
end

local function UpdateCrosshair()
    if not _G.Settings.Misc.CrosshairEnabled then
        CrosshairHorizontal.Visible = false
        CrosshairVertical.Visible = false
        return
    end
    
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local size = _G.Settings.Misc.CrosshairSize
    
    CrosshairHorizontal.From = Vector2.new(center.X - size, center.Y)
    CrosshairHorizontal.To = Vector2.new(center.X + size, center.Y)
    CrosshairHorizontal.Thickness = _G.Settings.Misc.CrosshairThickness
    CrosshairHorizontal.Color = _G.Settings.Misc.CrosshairColor
    CrosshairHorizontal.Visible = true
    
    CrosshairVertical.From = Vector2.new(center.X, center.Y - size)
    CrosshairVertical.To = Vector2.new(center.X, center.Y + size)
    CrosshairVertical.Thickness = _G.Settings.Misc.CrosshairThickness
    CrosshairVertical.Color = _G.Settings.Misc.CrosshairColor
    CrosshairVertical.Visible = true
end

local function AimAt(targetPosition)
    local mousePosition = Vector2.new(Mouse.X, Mouse.Y)
    local aimPosition = Camera:WorldToScreenPoint(targetPosition)
    local moveVector = Vector2.new(aimPosition.X - mousePosition.X, aimPosition.Y - mousePosition.Y)
    
    if _G.Settings.Aimbot.Smoothness > 0 then
        moveVector = moveVector * _G.Settings.Aimbot.Smoothness
    end
    
    mousemoverel(moveVector.X, moveVector.Y)
end

-- Main Loop Functions
local function UpdateAimbot()
    if not _G.Settings.Aimbot.Enabled or not IsAiming then return end
    
    local target = GetClosestPlayer()
    if not target then return end
    
    local character = target.Character
    local targetPart = GetTargetPart(character)
    if not targetPart then return end
    
    local prediction = CalculatePrediction(target)
    local targetPosition = targetPart.Position + prediction
    
    AimAt(targetPosition)
    
    if _G.Settings.Aimbot.AutoShoot and tick() - LastShot >= ShootCooldown then
        mouse1press()
        LastShot = tick()
        task.wait(0.1)
        mouse1release()
    end
end

-- Event Connections
local function SetupConnections()
    -- Player Connections
    Players.PlayerAdded:Connect(function(player)
        CreateESPElements(player)
    end)
    
    Players.PlayerRemoving:Connect(function(player)
        RemoveESPElements(player)
    end)
    
    -- Input Connections
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == _G.Settings.Aimbot.AimKey then
            IsAiming = true
        elseif input.KeyCode == Enum.KeyCode.End then
            _G.Settings.Aimbot.Enabled = not _G.Settings.Aimbot.Enabled
            FOVCircle.Visible = _G.Settings.Aimbot.Enabled and _G.Settings.Aimbot.ShowFOV
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == _G.Settings.Aimbot.AimKey then
            IsAiming = false
        end
    end)
    
    -- RunService Connections
    RunService.RenderStepped:Connect(function()
        UpdateFOVCircle()
        UpdateCrosshair()
        UpdateESP()
        UpdateAimbot()
    end)
end

-- Interface Elements
local function CreateToggle(parent, text, default, callback)
    local ToggleFrame = Instance.new("Frame")
    local ToggleButton = Instance.new("TextButton")
    local UICorner = Instance.new("UICorner")
    local ToggleInner = Instance.new("Frame")
    local UICorner_2 = Instance.new("UICorner")
    local ToggleLabel = Instance.new("TextLabel")
    
    ToggleFrame.Name = "ToggleFrame"
    ToggleFrame.Parent = parent
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Size = UDim2.new(1, 0, 0, 30)
    
    ToggleButton.Name = "ToggleButton"
    ToggleButton.Parent = ToggleFrame
    ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ToggleButton.Position = UDim2.new(0, 5, 0.5, -10)
    ToggleButton.Size = UDim2.new(0, 40, 0, 20)
    ToggleButton.AutoButtonColor = false
    ToggleButton.Text = ""
    
    UICorner.Parent = ToggleButton
    UICorner.CornerRadius = UDim.new(1, 0)
    
    ToggleInner.Name = "ToggleInner"
    ToggleInner.Parent = ToggleButton
    ToggleInner.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ToggleInner.Position = UDim2.new(0, 2, 0.5, -8)
    ToggleInner.Size = UDim2.new(0, 16, 0, 16)
    
    UICorner_2.Parent = ToggleInner
    UICorner_2.CornerRadius = UDim.new(1, 0)
    
    ToggleLabel.Name = "ToggleLabel"
    ToggleLabel.Parent = ToggleFrame
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Position = UDim2.new(0, 50, 0, 0)
    ToggleLabel.Size = UDim2.new(1, -55, 1, 0)
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.Text = text
    ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleLabel.TextSize = 14
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local toggled = default
    
    local function UpdateToggle()
        TweenService:Create(ToggleInner, TweenInfo.new(0.2), {
            Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
            BackgroundColor3 = toggled and Color3.fromRGB(0, 255, 128) or Color3.fromRGB(255, 255, 255)
        }):Play()
        
        callback(toggled)
    end
    
    ToggleButton.MouseButton1Click:Connect(function()
        toggled = not toggled
        UpdateToggle()
    end)
    
    UpdateToggle()
    return ToggleFrame
end

local function CreateSlider(parent, text, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    local SliderLabel = Instance.new("TextLabel")
    local SliderValue = Instance.new("TextLabel")
    local SliderBackground = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local SliderFill = Instance.new("Frame")
    local UICorner_2 = Instance.new("UICorner")
    local SliderButton = Instance.new("TextButton")
    
    SliderFrame.Name = "SliderFrame"
    SliderFrame.Parent = parent
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Size = UDim2.new(1, 0, 0, 50)
    
    SliderLabel.Name = "SliderLabel"
    SliderLabel.Parent = SliderFrame
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Position = UDim2.new(0, 5, 0, 0)
    SliderLabel.Size = UDim2.new(1, -10, 0, 20)
    SliderLabel.Font = Enum.Font.Gotham
    SliderLabel.Text = text
    SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SliderLabel.TextSize = 14
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    SliderValue.Name = "SliderValue"
    SliderValue.Parent = SliderFrame
    SliderValue.BackgroundTransparency = 1
    SliderValue.Position = UDim2.new(1, -45, 0, 0)
    SliderValue.Size = UDim2.new(0, 40, 0, 20)
    SliderValue.Font = Enum.Font.Gotham
    SliderValue.Text = tostring(default)
    SliderValue.TextColor3 = Color3.fromRGB(255, 255, 255)
    SliderValue.TextSize = 14
    
    SliderBackground.Name = "SliderBackground"
    SliderBackground.Parent = SliderFrame
    SliderBackground.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    SliderBackground.Position = UDim2.new(0, 5, 0, 25)
    SliderBackground.Size = UDim2.new(1, -10, 0, 10)
    
    UICorner.Parent = SliderBackground
    UICorner.CornerRadius = UDim.new(1, 0)
    
    SliderFill.Name = "SliderFill"
    SliderFill.Parent = SliderBackground
    SliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 128)
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    
    UICorner_2.Parent = SliderFill
    UICorner_2.CornerRadius = UDim.new(1, 0)
    
    SliderButton.Name = "SliderButton"
    SliderButton.Parent = SliderBackground
    SliderButton.BackgroundTransparency = 1
    SliderButton.Size = UDim2.new(1, 0, 1, 0)
    SliderButton.Text = ""
    
    local function UpdateSlider(input)
        local pos = UDim2.new(math.clamp((input.Position.X - SliderBackground.AbsolutePosition.X) / SliderBackground.AbsoluteSize.X, 0, 1), 0, 1, 0)
        SliderFill.Size = pos
        
        local value = math.floor(min + ((max - min) * pos.X.Scale))
        SliderValue.Text = tostring(value)
        callback(value)
    end
    
    SliderButton.MouseButton1Down:Connect(function()
        local connection
        connection = RunService.RenderStepped:Connect(function()
            if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                UpdateSlider(UserInputService:GetMouseLocation())
            else
                connection:Disconnect()
            end
        end)
    end)
end

-- Create Interface Elements
local function CreateInterface()
    -- Create Tabs
    local TabButtons = Instance.new("Frame")
    TabButtons.Name = "TabButtons"
    TabButtons.Parent = Container
    TabButtons.BackgroundTransparency = 1
    TabButtons.Size = UDim2.new(1, 0, 0, 30)
    
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = Container
    TabContainer.BackgroundTransparency = 1
    TabContainer.Position = UDim2.new(0, 0, 0, 35)
    TabContainer.Size = UDim2.new(1, 0, 1, -35)
    
    local function CreateTab(name)
        local TabButton = Instance.new("TextButton")
        local TabPage = Instance.new("ScrollingFrame")
        
        TabButton.Name = name .. "Button"
        TabButton.Parent = TabButtons
        TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        TabButton.Size = UDim2.new(0.333, -2, 1, 0)
        TabButton.Font = Enum.Font.Gotham
        TabButton.Text = name
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.TextSize = 14
        
        local UICorner = Instance.new("UICorner")
        UICorner.Parent = TabButton
        UICorner.CornerRadius = UDim.new(0, 5)
        
        TabPage.Name = name .. "Page"
        TabPage.Parent = TabContainer
        TabPage.BackgroundTransparency = 1
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.ScrollBarThickness = 4
TabPage.ScrollingEnabled = true
TabPage.Visible = false

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = TabPage
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

return TabButton, TabPage
end

-- Create Tabs
local AimbotButton, AimbotPage = CreateTab("Aimbot")
local ESPButton, ESPPage = CreateTab("ESP")
local MiscButton, MiscPage = CreateTab("Misc")

-- Position Tab Buttons
AimbotButton.Position = UDim2.new(0, 1, 0, 0)
ESPButton.Position = UDim2.new(0.333, 1, 0, 0)
MiscButton.Position = UDim2.new(0.666, 1, 0, 0)

-- Show First Tab
AimbotPage.Visible = true
AimbotButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

-- Tab Button Functionality
local function SwitchTab(button, page)
    AimbotButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ESPButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    MiscButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    
    AimbotPage.Visible = false
    ESPPage.Visible = false
    MiscPage.Visible = false
    
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    page.Visible = true
end

AimbotButton.MouseButton1Click:Connect(function()
    SwitchTab(AimbotButton, AimbotPage)
end)

ESPButton.MouseButton1Click:Connect(function()
    SwitchTab(ESPButton, ESPPage)
end)

MiscButton.MouseButton1Click:Connect(function()
    SwitchTab(MiscButton, MiscPage)
end)

-- Create Aimbot Settings
CreateToggle(AimbotPage, "Enable Aimbot", _G.Settings.Aimbot.Enabled, function(value)
    _G.Settings.Aimbot.Enabled = value
end)

CreateToggle(AimbotPage, "Show FOV", _G.Settings.Aimbot.ShowFOV, function(value)
    _G.Settings.Aimbot.ShowFOV = value
end)

CreateToggle(AimbotPage, "Team Check", _G.Settings.Aimbot.TeamCheck, function(value)
    _G.Settings.Aimbot.TeamCheck = value
end)

CreateSlider(AimbotPage, "FOV", 50, 500, _G.Settings.Aimbot.FOV, function(value)
    _G.Settings.Aimbot.FOV = value
end)

CreateSlider(AimbotPage, "Smoothness", 0, 1, _G.Settings.Aimbot.Smoothness, function(value)
    _G.Settings.Aimbot.Smoothness = value
end)

-- Create ESP Settings
CreateToggle(ESPPage, "Enable ESP", _G.Settings.ESP.Enabled, function(value)
    _G.Settings.ESP.Enabled = value
end)

CreateToggle(ESPPage, "Show Names", _G.Settings.ESP.ShowName, function(value)
    _G.Settings.ESP.ShowName = value
end)

CreateToggle(ESPPage, "Show Boxes", _G.Settings.ESP.ShowBox, function(value)
    _G.Settings.ESP.ShowBox = value
end)

CreateToggle(ESPPage, "Show Health", _G.Settings.ESP.ShowHealth, function(value)
    _G.Settings.ESP.ShowHealth = value
end)

CreateToggle(ESPPage, "Show Distance", _G.Settings.ESP.ShowDistance, function(value)
    _G.Settings.ESP.ShowDistance = value
end)

-- Create Misc Settings
CreateToggle(MiscPage, "No Recoil", _G.Settings.Aimbot.NoRecoil, function(value)
    _G.Settings.Aimbot.NoRecoil = value
end)

CreateToggle(MiscPage, "Infinite Jump", _G.Settings.Misc.InfiniteJump, function(value)
    _G.Settings.Misc.InfiniteJump = value
end)

CreateToggle(MiscPage, "Speed Hack", _G.Settings.Misc.SpeedHack, function(value)
    _G.Settings.Misc.SpeedHack = value
end)

CreateSlider(MiscPage, "Speed Multiplier", 1, 10, _G.Settings.Misc.SpeedMultiplier, function(value)
    _G.Settings.Misc.SpeedMultiplier = value
end)
end

-- Initialize
do
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            CreateESPElements(player)
        end
    end
    
    CreateInterface()
    SetupConnections()
    
    -- Cleanup
    ScreenGui.Parent = game:GetService("CoreGui")
end

-- Anti Cheat Bypass
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    if method == "FireServer" or method == "InvokeServer" then
        local name = self.Name
        if name:match("Report") or name:match("Anti") or name:match("Detect") then
            return
        end
    end
    
    return oldNamecall(self, ...)
end)

-- Final Setup
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.RightAlt then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Notification
StarterGui:SetCore("SendNotification", {
    Title = "Script Loaded",
    Text = "Press Right Alt to toggle GUI",
    Duration = 5
})