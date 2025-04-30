--[[ THEUS PREMIUM MOBILE v2 ]]--

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Configurações do Aimbot
local AimbotConfig = {
    Enabled = false,
    TargetPart = "Head", 
    FOV = 500,
    Smoothness = 0.5,
    TeamCheck = false,
    VisibilityCheck = true,
    AutoFire = false,
    ShowFOV = true,
    Prediction = {
        Enabled = true,
        Multiplier = 0.165
    }
}

-- Interface Visual
local Library = {}

local ThemeColors = {
    Background = Color3.fromRGB(25, 25, 25),
    DarkContrast = Color3.fromRGB(15, 15, 15),
    LightContrast = Color3.fromRGB(35, 35, 35),
    TextColor = Color3.fromRGB(255, 255, 255),
    AccentColor = Color3.fromRGB(0, 170, 255)
}

-- Funções Utilitárias
local function Create(instance, properties)
    local obj = Instance.new(instance)
    for i, v in pairs(properties) do
        obj[i] = v
    end
    return obj
end

-- FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.NumSides = 100
FOVCircle.Radius = AimbotConfig.FOV
FOVCircle.Filled = false
FOVCircle.Visible = false
FOVCircle.ZIndex = 999
FOVCircle.Transparency = 1
FOVCircle.Color = Color3.fromRGB(255, 255, 255)

-- Aimbot Functions
local function GetClosestPlayer()
    local MaxDist = AimbotConfig.FOV
    local Target = nil
    
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild(AimbotConfig.TargetPart) then
            if AimbotConfig.TeamCheck and v.Team == LocalPlayer.Team then continue end
            
            local HRP = v.Character.HumanoidRootPart
            local Humanoid = v.Character:FindFirstChild("Humanoid")
            
            if not HRP or not Humanoid or Humanoid.Health <= 0 then continue end
            
            local ScreenPos, OnScreen = Camera:WorldToViewportPoint(v.Character[AimbotConfig.TargetPart].Position)
            local Distance = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(ScreenPos.X, ScreenPos.Y)).Magnitude
            
            if Distance < MaxDist and OnScreen then
                if AimbotConfig.VisibilityCheck then
                    local Ray = Ray.new(Camera.CFrame.Position, (v.Character[AimbotConfig.TargetPart].Position - Camera.CFrame.Position).Unit * 2000)
                    local Hit = workspace:FindPartOnRayWithIgnoreList(Ray, {LocalPlayer.Character, Camera})
                    
                    if not Hit or not Hit:IsDescendantOf(v.Character) then continue end
                end
                
                MaxDist = Distance
                Target = v
            end
        end
    end
    return Target
end

-- Mobile Touch Button
local TouchButton = Create("ImageButton", {
    Parent = game.CoreGui,
    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
    BackgroundTransparency = 0.5,
    Position = UDim2.new(0.8, 0, 0.5, 0),
    Size = UDim2.new(0, 50, 0, 50),
    Image = "",
    Active = true,
    Draggable = true
})

local TouchActive = false

TouchButton.MouseButton1Down:Connect(function()
    TouchActive = true
end)

TouchButton.MouseButton1Up:Connect(function()
    TouchActive = false
end)

-- Main Aimbot Loop
RunService.RenderStepped:Connect(function()
    if AimbotConfig.ShowFOV then
        FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
        FOVCircle.Radius = AimbotConfig.FOV
        FOVCircle.Visible = true
    else
        FOVCircle.Visible = false
    end
    
    if AimbotConfig.Enabled and TouchActive then
        local Target = GetClosestPlayer()
        if Target then
            local TargetPos = Target.Character[AimbotConfig.TargetPart].Position
            
            if AimbotConfig.Prediction.Enabled then
                local Velocity = Target.Character[AimbotConfig.TargetPart].Velocity
                TargetPos = TargetPos + (Velocity * AimbotConfig.Prediction.Multiplier)
            end
            
            local ScreenPos = Camera:WorldToScreenPoint(TargetPos)
            local MousePos = Vector2.new(Mouse.X, Mouse.Y)
            local MovePos = Vector2.new(ScreenPos.X, ScreenPos.Y)
            
            if AimbotConfig.Smoothness > 0 then
                mousemoverel(
                    (MovePos.X - MousePos.X) * AimbotConfig.Smoothness,
                    (MovePos.Y - MousePos.Y) * AimbotConfig.Smoothness
                )
            else
                mousemoverel(
                    (MovePos.X - MousePos.X),
                    (MovePos.Y - MousePos.Y)
                )
            end
            
            if AimbotConfig.AutoFire then
                mouse1click()
            end
        end
    end
end)

-- Interface
local Window = Create("ScreenGui", {
    Parent = game.CoreGui,
    Name = "TheusAimbot"
})

local Main = Create("Frame", {
    Parent = Window,
    BackgroundColor3 = ThemeColors.Background,
    BorderSizePixel = 0,
    Position = UDim2.new(0.5, -150, 0.5, -200),
    Size = UDim2.new(0, 300, 0, 400),
    Active = true,
    Draggable = true
})

local Title = Create("TextLabel", {
    Parent = Main,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 10, 0, 5),
    Size = UDim2.new(1, -20, 0, 30),
    Font = Enum.Font.GothamBold,
    Text = "THEUS PREMIUM",
    TextColor3 = ThemeColors.TextColor,
    TextSize = 18
})

local Container = Create("ScrollingFrame", {
    Parent = Main,
    BackgroundColor3 = ThemeColors.LightContrast,
    BorderSizePixel = 0,
    Position = UDim2.new(0, 5, 0, 40),
    Size = UDim2.new(1, -10, 1, -45),
    ScrollBarThickness = 2,
    CanvasSize = UDim2.new(0, 0, 0, 400)
})

-- Toggle Function
local function CreateToggle(text, default, y, callback)
    local Toggle = Create("Frame", {
        Parent = Container,
        BackgroundColor3 = ThemeColors.DarkContrast,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 5, 0, y),
        Size = UDim2.new(1, -10, 0, 30)
    })
    
    local Label = Create("TextLabel", {
        Parent = Toggle,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 5, 0, 0),
        Size = UDim2.new(1, -35, 1, 0),
        Font = Enum.Font.Gotham,
        Text = text,
        TextColor3 = ThemeColors.TextColor,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local Button = Create("TextButton", {
        Parent = Toggle,
        BackgroundColor3 = default and ThemeColors.AccentColor or ThemeColors.LightContrast,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -30, 0.5, -10),
        Size = UDim2.new(0, 20, 0, 20),
        Text = "",
        AutoButtonColor = false
    })
    
    local Enabled = default
    Button.MouseButton1Click:Connect(function()
        Enabled = not Enabled
        Button.BackgroundColor3 = Enabled and ThemeColors.AccentColor or ThemeColors.LightContrast
        callback(Enabled)
    end)
end

-- Slider Function
local function CreateSlider(text, min, max, default, y, callback)
    local Slider = Create("Frame", {
        Parent = Container,
        BackgroundColor3 = ThemeColors.DarkContrast,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 5, 0, y),
        Size = UDim2.new(1, -10, 0, 45)
    })
    
    local Label = Create("TextLabel", {
        Parent = Slider,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 5, 0, 0),
        Size = UDim2.new(1, -10, 0, 20),
        Font = Enum.Font.Gotham,
        Text = text,
        TextColor3 = ThemeColors.TextColor,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local SliderFrame = Create("Frame", {
        Parent = Slider,
        BackgroundColor3 = ThemeColors.LightContrast,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 5, 0, 25),
        Size = UDim2.new(1, -10, 0, 10)
    })
    
    local Fill = Create("Frame", {
        Parent = SliderFrame,
        BackgroundColor3 = ThemeColors.AccentColor,
        BorderSizePixel = 0,
        Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    })
    
    local Value = Create("TextLabel", {
        Parent = SliderFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, 5, 0, -5),
        Size = UDim2.new(0, 30, 0, 20),
        Font = Enum.Font.Gotham,
        Text = tostring(default),
        TextColor3 = ThemeColors.TextColor,
        TextSize = 12
    })
    
    local IsDragging = false
    
    SliderFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            IsDragging = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            IsDragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if IsDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local AbsolutePos = SliderFrame.AbsolutePosition
            local AbsoluteSize = SliderFrame.AbsoluteSize
            local Position = input.Position
            
            local Percentage = math.clamp((Position.X - AbsolutePos.X) / AbsoluteSize.X, 0, 1)
            local Value = math.floor(min + (max - min) * Percentage)
            
            Fill.Size = UDim2.new(Percentage, 0, 1, 0)
            Value.Text = tostring(Value)
            callback(Value)
        end
    end)
end

-- Create Controls
CreateToggle("Enable Aimbot", false, 5, function(state)
    AimbotConfig.Enabled = state
end)

CreateToggle("Show FOV", true, 40, function(state)
    AimbotConfig.ShowFOV = state
end)

CreateToggle("Team Check", false, 75, function(state)
    AimbotConfig.TeamCheck = state
end)

CreateToggle("Visibility Check", true, 110, function(state)
    AimbotConfig.VisibilityCheck = state
end)

CreateToggle("Auto Fire", false, 145, function(state)
    AimbotConfig.AutoFire = state
end)

CreateSlider("FOV", 10, 1000, 500, 180, function(value)
    AimbotConfig.FOV = value
end)

CreateSlider("Smoothness", 0, 1, 0.5, 230, function(value)
    AimbotConfig.Smoothness = value
end)

CreateSlider("Prediction", 0, 1, 0.165, 280, function(value)
    AimbotConfig.Prediction.Multiplier = value
end)

-- Notification
local function CreateNotification(text)
    local Notification = Create("Frame", {
        Parent = Window,
        BackgroundColor3 = ThemeColors.Background,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -220, 1, -60),
        Size = UDim2.new(0, 200, 0, 50),
        AnchorPoint = Vector2.new(1, 1)
    })
    
    local Label = Create("TextLabel", {
        Parent = Notification,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(1, -20, 1, 0),
        Font = Enum.Font.Gotham,
        Text = text,
        TextColor3 = ThemeColors.TextColor,
        TextSize = 14
    })
    
    game.Debris:AddItem(Notification, 3)
end

CreateNotification("THEUS PREMIUM carregado com sucesso!")