local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Interface
local ScreenGui = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local TopBar = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local MinimizeBtn = Instance.new("TextButton")
local Container = Instance.new("Frame")

ScreenGui.Parent = game.CoreGui
Main.Name = "Main"
Main.Parent = ScreenGui
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.Position = UDim2.new(0.5, -150, 0.5, -175)
Main.Size = UDim2.new(0, 300, 0, 350)
Main.Active = true
Main.Draggable = true

TopBar.Name = "TopBar"
TopBar.Parent = Main
TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
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

MinimizeBtn.Parent = TopBar
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MinimizeBtn.Position = UDim2.new(1, -30, 0.5, -10)
MinimizeBtn.Size = UDim2.new(0, 20, 0, 20)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 14

Container.Name = "Container"
Container.Parent = Main
Container.BackgroundTransparency = 1
Container.Position = UDim2.new(0, 10, 0, 45)
Container.Size = UDim2.new(1, -20, 1, -55)

-- Configurações Avançadas
local Settings = {
    Aimbot = {
        Enabled = false,
        Key = Enum.KeyCode.E,
        TeamCheck = true,
        VisibilityCheck = true,
        Smoothness = 0.25,
        PredictionAmount = 0.15,
        TargetPart = "Head",
        FOV = 250,
        ShowFOV = true,
        IgnoreWalls = true
    },
    ESP = {
        Enabled = false,
        TeamCheck = true,
        ShowHealth = true,
        ShowDistance = true,
        ShowName = true,
        ShowBox = true,
        ShowTracer = true,
        TeamColor = Color3.fromRGB(0, 255, 0),
        EnemyColor = Color3.fromRGB(255, 0, 0),
        TracerOrigin = "Bottom" -- Bottom, Mouse, Top
    },
    Combat = {
        NoRecoil = false,
        NoSpread = true,
        RapidFire = false,
        InstantHit = true,
        WallBang = true
    }
}

-- Funções Utilitárias
local function IsVisible(part)
    local ray = Ray.new(Camera.CFrame.Position, part.Position - Camera.CFrame.Position)
    local hit, position = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character, part.Parent})
    return not hit
end

local function GetDistanceFromCharacter(part)
    return (part.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
end

-- ESP Avançado
local function CreateESP(player)
    local ESP = {
        Box = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
        Tracer = Drawing.new("Line"),
        Health = Drawing.new("Text")
    }
    
    ESP.Box.Thickness = 1
    ESP.Box.Filled = false
    ESP.Box.Transparency = 1
    
    ESP.Name.Size = 13
    ESP.Name.Center = true
    ESP.Name.Outline = true
    
    ESP.Distance.Size = 12
    ESP.Distance.Center = true
    ESP.Distance.Outline = true
    
    ESP.Tracer.Thickness = 1
    ESP.Tracer.Transparency = 1
    
    ESP.Health.Size = 12
    ESP.Health.Center = true
    ESP.Health.Outline = true

    local function UpdateESP()
        if not Settings.ESP.Enabled then
            ESP.Box.Visible = false
            ESP.Name.Visible = false
            ESP.Distance.Visible = false
            ESP.Tracer.Visible = false
            ESP.Health.Visible = false
            return
        end

        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") or not player.Character:FindFirstChild("Humanoid") then
            ESP.Box.Visible = false
            ESP.Name.Visible = false
            ESP.Distance.Visible = false
            ESP.Tracer.Visible = false
            ESP.Health.Visible = false
            return
        end

        local isTeammate = player.Team == LocalPlayer.Team
        if Settings.ESP.TeamCheck and isTeammate then
            ESP.Box.Visible = false
            ESP.Name.Visible = false
            ESP.Distance.Visible = false
            ESP.Tracer.Visible = false
            ESP.Health.Visible = false
            return
        end

        local Vector, OnScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
        if not OnScreen then
            ESP.Box.Visible = false
            ESP.Name.Visible = false
            ESP.Distance.Visible = false
            ESP.Tracer.Visible = false
            ESP.Health.Visible = false
            return
        end

        local Color = isTeammate and Settings.ESP.TeamColor or Settings.ESP.EnemyColor
        local Distance = GetDistanceFromCharacter(player.Character.HumanoidRootPart)
        local Scale = 1 / (Distance * math.tan(math.rad(Camera.FieldOfView * 0.5)) * 2) * 100

        -- Box ESP
        if Settings.ESP.ShowBox then
            ESP.Box.Size = Vector2.new(Scale * 30, Scale * 60)
            ESP.Box.Position = Vector2.new(Vector.X - ESP.Box.Size.X / 2, Vector.Y - ESP.Box.Size.Y / 2)
            ESP.Box.Color = Color
            ESP.Box.Visible = true
        else
            ESP.Box.Visible = false
        end

        -- Name ESP
        if Settings.ESP.ShowName then
            ESP.Name.Position = Vector2.new(Vector.X, Vector.Y - ESP.Box.Size.Y / 2 - 15)
            ESP.Name.Text = player.Name
            ESP.Name.Color = Color
            ESP.Name.Visible = true
        else
            ESP.Name.Visible = false
        end

        -- Distance ESP
        if Settings.ESP.ShowDistance then
            ESP.Distance.Position = Vector2.new(Vector.X, Vector.Y + ESP.Box.Size.Y / 2 + 5)
            ESP.Distance.Text = math.floor(Distance) .. " studs"
            ESP.Distance.Color = Color
            ESP.Distance.Visible = true
        else
            ESP.Distance.Visible = false
        end

        -- Health ESP
        if Settings.ESP.ShowHealth then
            local Health = player.Character.Humanoid.Health
            local MaxHealth = player.Character.Humanoid.MaxHealth
            ESP.Health.Position = Vector2.new(Vector.X + ESP.Box.Size.X / 2 + 5, Vector.Y)
            ESP.Health.Text = math.floor(Health) .. "/" .. math.floor(MaxHealth)
            ESP.Health.Color = Color3.fromRGB(255 * (1 - Health/MaxHealth), 255 * (Health/MaxHealth), 0)
            ESP.Health.Visible = true
        else
            ESP.Health.Visible = false
        end

        -- Tracer ESP
        if Settings.ESP.ShowTracer then
            local TracerStart
            if Settings.ESP.TracerOrigin == "Bottom" then
                TracerStart = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
            elseif Settings.ESP.TracerOrigin == "Mouse" then
                TracerStart = Vector2.new(Mouse.X, Mouse.Y)
            else
                TracerStart = Vector2.new(Camera.ViewportSize.X / 2, 0)
            end
            
            ESP.Tracer.From = TracerStart
            ESP.Tracer.To = Vector2.new(Vector.X, Vector.Y)
            ESP.Tracer.Color = Color
            ESP.Tracer.Visible = true
        else
            ESP.Tracer.Visible = false
        end
    end

    RunService:BindToRenderStep(player.Name .. "_ESP", 1, UpdateESP)

    player.CharacterRemoving:Connect(function()
        ESP.Box.Visible = false
        ESP.Name.Visible = false
        ESP.Distance.Visible = false
        ESP.Tracer.Visible = false
        ESP.Health.Visible = false
    end)
end

-- Aimbot Avançado
local function GetClosestPlayer()
    local ClosestPlayer = nil
    local ShortestDistance = Settings.Aimbot.FOV

    local function IsValidTarget(player)
        if not player.Character or not player.Character:FindFirstChild(Settings.Aimbot.TargetPart) then
            return false
        end
        
        if Settings.Aimbot.TeamCheck and player.Team == LocalPlayer.Team then
            return false
        end
        
        if Settings.Aimbot.VisibilityCheck and not Settings.Aimbot.IgnoreWalls then
            if not IsVisible(player.Character[Settings.Aimbot.TargetPart]) then
                return false
            end
        end
        
        return true
    end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsValidTarget(player) then
            local ScreenPoint = Camera:WorldToScreenPoint(player.Character[Settings.Aimbot.TargetPart].Position)
            local VectorDistance = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude
            
            if VectorDistance < ShortestDistance then
                ClosestPlayer = player
                ShortestDistance = VectorDistance
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

-- Atualizar FOV Circle
RunService.RenderStepped:Connect(function()
    if Settings.Aimbot.ShowFOV then
        FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
        FOVCircle.Visible = true
    else
        FOVCircle.Visible = false
    end
end)

-- Combat Loop
RunService.RenderStepped:Connect(function()
    if Settings.Aimbot.Enabled and UserInputService:IsKeyDown(Settings.Aimbot.Key) then
        local Target = GetClosestPlayer()
        if Target and Target.Character then
            local TargetPart = Target.Character[Settings.Aimbot.TargetPart]
            local Prediction = TargetPart.Position + (TargetPart.Velocity * Settings.Aimbot.PredictionAmount)
            
            local ScreenPoint = Camera:WorldToScreenPoint(Prediction)
            local MousePos = Vector2.new(Mouse.X, Mouse.Y)
            local MoveAmount = (Vector2.new(ScreenPoint.X, ScreenPoint.Y) - MousePos) * Settings.Aimbot.Smoothness
            
            mousemoverel(MoveAmount.X, MoveAmount.Y)
        end
    end
end)

-- No Recoil e Combat Mods
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldNamecall = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    if method == "FireServer" then
        if Settings.Combat.NoRecoil and args[1] == "Recoil" then
            return
        end
        if Settings.Combat.NoSpread and args[1] == "Spread" then
            return
        end
    end
    
    return oldNamecall(self, unpack(args))
end)

-- Criar Botões
local function CreateButton(name, position)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 35)
    Button.Position = position
    Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
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

-- Botões
local AimbotBtn = CreateButton("Aimbot: OFF", UDim2.new(0, 0, 0, 0))
local ESPBtn = CreateButton("ESP: OFF", UDim2.new(0, 0, 0, 45))
local TeamCheckBtn = CreateButton("Team Check: ON", UDim2.new(0, 0, 0, 90))
local NoRecoilBtn = CreateButton("Combat Mods: OFF", UDim2.new(0, 0, 0, 135))

-- Eventos dos Botões
local function UpdateButton(button, enabled)
    button.Text = button.Text:gsub("ON", "OFF"):gsub("OFF", "ON")
    button.BackgroundColor3 = enabled and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(35, 35, 35)
end

AimbotBtn.MouseButton1Click:Connect(function()
    Settings.Aimbot.Enabled = not Settings.Aimbot.Enabled
    UpdateButton(AimbotBtn, Settings.Aimbot.Enabled)
end)

ESPBtn.MouseButton1Click:Connect(function()
    Settings.ESP.Enabled = not Settings.ESP.Enabled
    UpdateButton(ESPBtn, Settings.ESP.Enabled)
end)

TeamCheckBtn.MouseButton1Click:Connect(function()
    Settings.Aimbot.TeamCheck = not Settings.Aimbot.TeamCheck
    Settings.ESP.TeamCheck = Settings.Aimbot.TeamCheck
    UpdateButton(TeamCheckBtn, Settings.Aimbot.TeamCheck)
end)

NoRecoilBtn.MouseButton1Click:Connect(function()
    Settings.Combat.NoRecoil = not Settings.Combat.NoRecoil
    Settings.Combat.NoSpread = Settings.Combat.NoRecoil
    UpdateButton(NoRecoilBtn, Settings.Combat.NoRecoil)
end)

-- Sistema de Minimizar
MinimizeBtn.MouseButton1Click:Connect(function()
    if Main.Size == UDim2.new(0, 300, 0, 350) then
        Main:TweenSize(UDim2.new(0, 300, 0, 35), "Out", "Quad", 0.3, true)
        MinimizeBtn.Text = "+"
    else
        Main:TweenSize(UDim2.new(0, 300, 0, 350), "Out", "Quad", 0.3, true)
        MinimizeBtn.Text = "-"
    end
end)

-- Inicializar ESP para jogadores existentes
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end

-- ESP para novos jogadores
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end)