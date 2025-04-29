-- Theus Hub v3.2 (Universal)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Interface
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

-- Settings
_G.Settings = {
    Aimbot = {
        Enabled = false,
        Smoothness = 0.25,
        FOV = 250,
        ShowFOV = true,
        TeamCheck = true
    },
    ESP = {
        Enabled = false,
        TeamCheck = true
    }
}

-- ESP Container
local ESPContainer = {}

-- Interface Setup
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -100)
MainFrame.Size = UDim2.new(0, 250, 0, 200)
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

-- FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.NumSides = 100
FOVCircle.Radius = _G.Settings.Aimbot.FOV
FOVCircle.Filled = false
FOVCircle.Visible = false
FOVCircle.ZIndex = 999
FOVCircle.Transparency = 1
FOVCircle.Color = Color3.fromRGB(255, 255, 255)

-- ESP Function
local function CreateESP(plr)
    local Box = Drawing.new("Square")
    local Tracer = Drawing.new("Line")
    
    Box.Visible = false
    Box.Color = Color3.new(1,1,1)
    Box.Thickness = 1
    Box.Transparency = 1
    Box.Filled = false
    
    Tracer.Visible = false
    Tracer.Color = Color3.new(1,1,1)
    Tracer.Thickness = 1
    Tracer.Transparency = 1
    
    ESPContainer[plr] = {
        Box = Box,
        Tracer = Tracer
    }
end

-- Get Closest Player Function
local function GetClosestPlayer()
    local MaxDist = _G.Settings.Aimbot.FOV
    local Target = nil
    
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            if _G.Settings.Aimbot.TeamCheck and v.Team == LocalPlayer.Team then continue end
            
            local pos = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).magnitude
            
            if magnitude < MaxDist then
                MaxDist = magnitude
                Target = v
            end
        end
    end
    
    return Target
end

-- Create Toggle Function
local function CreateToggle(name, position, callback)
    local Toggle = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local Title = Instance.new("TextLabel")
    local Button = Instance.new("TextButton")
    local UICorner_2 = Instance.new("UICorner")

    Toggle.Name = name
    Toggle.Parent = Container
    Toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Toggle.Position = position
    Toggle.Size = UDim2.new(1, -20, 0, 30)

    UICorner.Parent = Toggle
    UICorner.CornerRadius = UDim.new(0, 6)

    Title.Name = "Title"
    Title.Parent = Toggle
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.Size = UDim2.new(1, -50, 1, 0)
    Title.Font = Enum.Font.GothamSemibold
    Title.Text = name
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 12
    Title.TextXAlignment = Enum.TextXAlignment.Left

    Button.Name = "Button"
    Button.Parent = Toggle
    Button.BackgroundColor3 = Color3.fromRGB(255, 75, 75)
    Button.Position = UDim2.new(1, -35, 0.5, -10)
    Button.Size = UDim2.new(0, 20, 0, 20)
    Button.Font = Enum.Font.SourceSans
    Button.Text = ""
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)

    UICorner_2.Parent = Button
    UICorner_2.CornerRadius = UDim.new(0, 4)

    local enabled = false
    Button.MouseButton1Click:Connect(function()
        enabled = not enabled
        Button.BackgroundColor3 = enabled and Color3.fromRGB(75, 255, 75) or Color3.fromRGB(255, 75, 75)
        callback(enabled)
    end)
end

-- Create Toggles
CreateToggle("Aimbot", UDim2.new(0, 10, 0, 10), function(enabled)
    _G.Settings.Aimbot.Enabled = enabled
end)

CreateToggle("Show FOV", UDim2.new(0, 10, 0, 50), function(enabled)
    _G.Settings.Aimbot.ShowFOV = enabled
end)

CreateToggle("ESP", UDim2.new(0, 10, 0, 90), function(enabled)
    _G.Settings.ESP.Enabled = enabled
end)

CreateToggle("Team Check", UDim2.new(0, 10, 0, 130), function(enabled)
    _G.Settings.ESP.TeamCheck = enabled
    _G.Settings.Aimbot.TeamCheck = enabled
end)

-- Initialize ESP
for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
        CreateESP(plr)
    end
end

Players.PlayerAdded:Connect(function(plr)
    CreateESP(plr)
end)

Players.PlayerRemoving:Connect(function(plr)
    if ESPContainer[plr] then
        ESPContainer[plr].Box:Remove()
        ESPContainer[plr].Tracer:Remove()
        ESPContainer[plr] = nil
    end
end)

-- Main Loop
RunService.RenderStepped:Connect(function()
    -- Update FOV Circle
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Visible = _G.Settings.Aimbot.ShowFOV

    -- Aimbot
    if _G.Settings.Aimbot.Enabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        local Target = GetClosestPlayer()
        if Target and Target.Character and Target.Character:FindFirstChild("Head") then
            local HeadPos = Camera:WorldToViewportPoint(Target.Character.Head.Position)
            local MoveTo = Vector2.new(
                (HeadPos.X - Mouse.X) * _G.Settings.Aimbot.Smoothness,
                (HeadPos.Y - Mouse.Y) * _G.Settings.Aimbot.Smoothness
            )
            mousemoverel(MoveTo.X, MoveTo.Y)
        end
    end

    -- ESP
    for plr, drawings in pairs(ESPContainer) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
            
            if onScreen and _G.Settings.ESP.Enabled then
                if _G.Settings.ESP.TeamCheck and plr.Team == LocalPlayer.Team then
                    drawings.Box.Visible = false
                    drawings.Tracer.Visible = false
                    continue
                end

                -- Box ESP
                local RootPosition = plr.Character.HumanoidRootPart.Position
                local CamPosition = Camera.CFrame.Position
                local Distance = (RootPosition - CamPosition).Magnitude
                local Size = math.clamp(100 / Distance, 8, 20)

                drawings.Box.Size = Vector2.new(Size * 1.5, Size * 2)
                drawings.Box.Position = Vector2.new(pos.X - Size * 1.5 / 2, pos.Y - Size * 2 / 2)
                drawings.Box.Visible = true

                -- Tracer ESP
                drawings.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                drawings.Tracer.To = Vector2.new(pos.X, pos.Y)
                drawings.Tracer.Visible = true
            else
                drawings.Box.Visible = false
                drawings.Tracer.Visible = false
            end
        else
            drawings.Box.Visible = false
            drawings.Tracer.Visible = false
        end
    end
end)

-- Minimize Button
MinimizeBtn.MouseButton1Click:Connect(function()
    if Container.Visible then
        Container.Visible = false
        MainFrame:TweenSize(UDim2.new(0, 250, 0, 30), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.5, true)
    else
        Container.Visible = true
        MainFrame:TweenSize(UDim2.new(0, 250, 0, 200), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.5, true)
    end
end)