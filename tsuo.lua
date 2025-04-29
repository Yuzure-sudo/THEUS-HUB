-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- UI Setup
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TopBar = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local MinimizeButton = Instance.new("TextButton")
local Container = Instance.new("Frame")

ScreenGui.Parent = game.CoreGui
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
MainFrame.Size = UDim2.new(0, 300, 0, 350)
MainFrame.Active = true
MainFrame.Draggable = true

TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TopBar.Size = UDim2.new(1, 0, 0, 35)

Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "Theus Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

MinimizeButton.Parent = TopBar
MinimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MinimizeButton.Position = UDim2.new(1, -30, 0.5, -10)
MinimizeButton.Size = UDim2.new(0, 20, 0, 20)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 14

Container.Name = "Container"
Container.Parent = MainFrame
Container.BackgroundTransparency = 1
Container.Position = UDim2.new(0, 10, 0, 45)
Container.Size = UDim2.new(1, -20, 1, -55)

-- Advanced Settings
local Settings = {
    Aimbot = {
        Enabled = false,
        Key = Enum.KeyCode.E,
        TeamCheck = true,
        Smoothness = 0.2,
        TargetPart = "Head",
        FOV = 150,
        ShowFOV = true
    },
    ESP = {
        Enabled = false,
        TeamCheck = true,
        Box = true,
        Name = true,
        Distance = true,
        Health = true,
        Tracer = true,
        TeamColor = Color3.fromRGB(0, 255, 0),
        EnemyColor = Color3.fromRGB(255, 0, 0),
        TracerFrom = "Bottom"
    },
    Combat = {
        NoRecoil = true
    }
}

-- Utility Functions
local function IsPlayerVisible(player)
    local character = player.Character
    local head = character and character:FindFirstChild("Head")
    if head then
        local origin = Camera.CFrame.Position
        local direction = (head.Position - origin).unit
        local ray = Ray.new(origin, direction * 500)
        local hit, pos = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character, character})
        return hit and hit:IsDescendantOf(character)
    end
    return false
end

local function GetDistanceFromPlayer(part)
    return (part.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
end

-- ESP Functionality
local function CreateESP(player)
    local DrawingObjects = {
        Box = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
        Tracer = Drawing.new("Line"),
        Health = Drawing.new("Text")
    }

    DrawingObjects.Box.Thickness = 1
    DrawingObjects.Box.Filled = false
    DrawingObjects.Box.Transparency = 1

    DrawingObjects.Name.Size = 14
    DrawingObjects.Name.Center = true
    DrawingObjects.Name.Outline = true

    DrawingObjects.Distance.Size = 12
    DrawingObjects.Distance.Center = true
    DrawingObjects.Distance.Outline = true

    DrawingObjects.Tracer.Thickness = 1
    DrawingObjects.Tracer.Transparency = 1

    DrawingObjects.Health.Size = 12
    DrawingObjects.Health.Center = true
    DrawingObjects.Health.Outline = true

    local function UpdateESP()
        if not Settings.ESP.Enabled then
            for _, obj in pairs(DrawingObjects) do obj.Visible = false end
            return
        end

        local character = player.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") or not character:FindFirstChild("Humanoid") then
            for _, obj in pairs(DrawingObjects) do obj.Visible = false end
            return
        end

        local isTeammate = player.Team == LocalPlayer.Team
        if Settings.ESP.TeamCheck and isTeammate then
            for _, obj in pairs(DrawingObjects) do obj.Visible = false end
            return
        end

        local Vector, OnScreen = Camera:WorldToViewportPoint(character.HumanoidRootPart.Position)
        if not OnScreen then
            for _, obj in pairs(DrawingObjects) do obj.Visible = false end
            return
        end

        local Color = isTeammate and Settings.ESP.TeamColor or Settings.ESP.EnemyColor
        local Distance = GetDistanceFromPlayer(character.HumanoidRootPart)
        local Scale = 1 / (Distance * math.tan(math.rad(Camera.FieldOfView * 0.5)) * 2) * 100

        -- Box ESP
        if Settings.ESP.Box then
            DrawingObjects.Box.Size = Vector2.new(Scale * 4, Scale * 7)
            DrawingObjects.Box.Position = Vector2.new(Vector.X - DrawingObjects.Box.Size.X / 2, Vector.Y - DrawingObjects.Box.Size.Y / 2)
            DrawingObjects.Box.Color = Color
            DrawingObjects.Box.Visible = true
        else
            DrawingObjects.Box.Visible = false
        end

        -- Name ESP
        if Settings.ESP.Name then
            DrawingObjects.Name.Position = Vector2.new(Vector.X, Vector.Y - DrawingObjects.Box.Size.Y / 2 - 15)
            DrawingObjects.Name.Text = player.Name
            DrawingObjects.Name.Color = Color
            DrawingObjects.Name.Visible = true
        else
            DrawingObjects.Name.Visible = false
        end

        -- Distance ESP
        if Settings.ESP.Distance then
            DrawingObjects.Distance.Position = Vector2.new(Vector.X, Vector.Y + DrawingObjects.Box.Size.Y / 2 + 5)
            DrawingObjects.Distance.Text = string.format("%.0f studs", Distance)
            DrawingObjects.Distance.Color = Color
            DrawingObjects.Distance.Visible = true
        else
            DrawingObjects.Distance.Visible = false
        end

        -- Health ESP
        if Settings.ESP.Health then
            local Humanoid = character:FindFirstChild("Humanoid")
            local Health = Humanoid.Health
            local MaxHealth = Humanoid.MaxHealth
            DrawingObjects.Health.Position = Vector2.new(Vector.X + DrawingObjects.Box.Size.X / 2 + 5, Vector.Y)
            DrawingObjects.Health.Text = string.format("%d / %d", Health, MaxHealth)
            DrawingObjects.Health.Color = Color3.fromRGB(255 * (1 - Health/MaxHealth), 255 * (Health/MaxHealth), 0)
            DrawingObjects.Health.Visible = true
        else
            DrawingObjects.Health.Visible = false
        end

        -- Tracer ESP
        if Settings.ESP.Tracer then
            local TracerOrigin
            if Settings.ESP.TracerFrom == "Bottom" then
                TracerOrigin = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
            elseif Settings.ESP.TracerFrom == "Mouse" then
                TracerOrigin = Vector2.new(Mouse.X, Mouse.Y)
            else
                TracerOrigin = Vector2.new(Camera.ViewportSize.X / 2, 0)
            end

            DrawingObjects.Tracer.From = TracerOrigin
            DrawingObjects.Tracer.To = Vector2.new(Vector.X, Vector.Y)
            DrawingObjects.Tracer.Color = Color
            DrawingObjects.Tracer.Visible = true
        else
            DrawingObjects.Tracer.Visible = false
        end
    end

    RunService.RenderStepped:Connect(UpdateESP)

    player.CharacterRemoving:Connect(function()
        for _, obj in pairs(DrawingObjects) do obj.Visible = false end
    end)
end

-- Aimbot Functionality
local function GetClosestPlayer()
    local ClosestPlayer = nil
    local ShortestDistance = Settings.Aimbot.FOV

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(Settings.Aimbot.TargetPart) then
            local isTeammate = player.Team == LocalPlayer.Team
            if Settings.Aimbot.TeamCheck and isTeammate then
                continue
            end

            local PartPosition = Camera:WorldToViewportPoint(player.Character[Settings.Aimbot.TargetPart].Position)
            local Distance = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(PartPosition.X, PartPosition.Y)).Magnitude

            if Distance < ShortestDistance then
                ClosestPlayer = player
                ShortestDistance = Distance
            end
        end
    end

    return ClosestPlayer
end

-- FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.NumSides = 100
FOVCircle.Radius = Settings.Aimbot.FOV
FOVCircle.Filled = false
FOVCircle.Visible = Settings.Aimbot.ShowFOV
FOVCircle.ZIndex = 999
FOVCircle.Transparency = 1
FOVCircle.Color = Color3.fromRGB(255, 255, 255)

RunService.RenderStepped:Connect(function()
    if Settings.Aimbot.ShowFOV then
        FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
        FOVCircle.Visible = true
    else
        FOVCircle.Visible = false
    end
end)

-- Combat Logic
RunService.RenderStepped:Connect(function()
    if Settings.Aimbot.Enabled and UserInputService:IsKeyDown(Settings.Aimbot.Key) then
        local Target = GetClosestPlayer()
        if Target and Target.Character then
            local TargetPart = Target.Character[Settings.Aimbot.TargetPart]
            local AimPosition = Camera:WorldToViewportPoint(TargetPart.Position)
            local MousePosition = Vector2.new(Mouse.X, Mouse.Y)
            local MoveVector = (Vector2.new(AimPosition.X, AimPosition.Y) - MousePosition) * Settings.Aimbot.Smoothness

            mousemoverel(MoveVector.X, MoveVector.Y)
        end
    end
end)

-- No Recoil
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldNamecall = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    if method == "FireServer" and Settings.Combat.NoRecoil and args[1] == "Recoil" then
        return
    end

    return oldNamecall(self, ...)
end)

-- Create Buttons
local function CreateButton(name, position)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 35)
    Button.Position = position
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Button.Text = name
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 14
    Button.Font = Enum.Font.GothamSemibold
    Button.Parent = Container

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = Button

    return Button
end

local AimbotButton = CreateButton("Aimbot: OFF", UDim2.new(0, 0, 0, 0))
local ESPButton = CreateButton("ESP: OFF", UDim2.new(0, 0, 0, 45))
local TeamCheckButton = CreateButton("Team Check: ON", UDim2.new(0, 0, 0, 90))
local NoRecoilButton = CreateButton("Combat Mods: OFF", UDim2.new(0, 0, 0, 135))

-- Button Events
local function ToggleButton(button, setting)
    setting = not setting
    button.Text = button.Text:gsub("ON", "OFF"):gsub("OFF", "ON")
    button.BackgroundColor3 = setting and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(50, 50, 50)
    return setting
end

AimbotButton.MouseButton1Click:Connect(function()
    Settings.Aimbot.Enabled = ToggleButton(AimbotButton, Settings.Aimbot.Enabled)
end)

ESPButton.MouseButton1Click:Connect(function()
    Settings.ESP.Enabled = ToggleButton(ESPButton, Settings.ESP.Enabled)
end)

TeamCheckButton.MouseButton1Click:Connect(function()
    Settings.Aimbot.TeamCheck = not Settings.Aimbot.TeamCheck
    Settings.ESP.TeamCheck = Settings.Aimbot.TeamCheck
    ToggleButton(TeamCheckButton, Settings.Aimbot.TeamCheck)
end)

NoRecoilButton.MouseButton1Click:Connect(function()
    Settings.Combat.NoRecoil = ToggleButton(NoRecoilButton, Settings.Combat.NoRecoil)
end)

-- Minimize System
MinimizeButton.MouseButton1Click:Connect(function()
    if MainFrame.Size == UDim2.new(0, 300, 0, 350) then
        MainFrame:TweenSize(UDim2.new(0, 300, 0, 35), "Out", "Quad", 0.3, true)
        MinimizeButton.Text = "+"
    else
        MainFrame:TweenSize(UDim2.new(0, 300, 0, 350), "Out", "Quad", 0.3, true)
        MinimizeButton.Text = "-"
    end
end)

-- Initialize ESP for existing players
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end

-- ESP for new players
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end)