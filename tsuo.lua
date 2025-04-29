-- Theus Hub v3.1
-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
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

-- ESP Containers
local ESP = {
    Boxes = {},
    Tracers = {}
}

-- Configurações
_G.Settings = {
    Aimbot = {
        Enabled = false,
        Key = "MouseButton1",
        Smoothness = 0.5,
        FOV = 250,
        ShowFOV = true,
        TeamCheck = true
    },
    ESP = {
        Enabled = false,
        TeamCheck = true,
        BoxESP = true,
        TracerESP = true
    }
}

-- Interface Setup
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

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

-- Criar Toggles
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

-- Criar Toggles na Interface
CreateToggle("Aimbot", UDim2.new(0, 10, 0, 10), function(enabled)
    _G.Settings.Aimbot.Enabled = enabled
end)

CreateToggle("Show FOV", UDim2.new(0, 10, 0, 50), function(enabled)
    _G.Settings.Aimbot.ShowFOV = enabled
end)

CreateToggle("ESP Box", UDim2.new(0, 10, 0, 90), function(enabled)
    _G.Settings.ESP.BoxESP = enabled
end)

CreateToggle("ESP Line", UDim2.new(0, 10, 0, 130), function(enabled)
    _G.Settings.ESP.TracerESP = enabled
end)

CreateToggle("Team Check", UDim2.new(0, 10, 0, 170), function(enabled)
    _G.Settings.ESP.TeamCheck = enabled
    _G.Settings.Aimbot.TeamCheck = enabled
end)

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
FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

-- Aimbot Functions
local function GetClosestPlayer()
    local MaxDist = _G.Settings.Aimbot.FOV
    local Target = nil
    local ScreenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            if _G.Settings.Aimbot.TeamCheck and v.Team == LocalPlayer.Team then continue end
            
            local HeadPos = Camera:WorldToViewportPoint(v.Character.Head.Position)
            if HeadPos.Z < 0 then continue end
            
            local Distance = (Vector2.new(HeadPos.X, HeadPos.Y) - ScreenCenter).Magnitude
            if Distance < MaxDist then
                MaxDist = Distance
                Target = v
            end
        end
    end
    return Target
end

-- ESP Functions
local function CreateESP()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer then
            -- Box ESP
            local BoxOutline = Drawing.new("Square")
            BoxOutline.Visible = false
            BoxOutline.Color = Color3.new(0, 0, 0)
            BoxOutline.Thickness = 3
            BoxOutline.Transparency = 1
            BoxOutline.Filled = false

            local Box = Drawing.new("Square")
            Box.Visible = false
            Box.Color = Color3.new(1, 1, 1)
            Box.Thickness = 1
            Box.Transparency = 1
            Box.Filled = false

            -- Tracer ESP
            local Tracer = Drawing.new("Line")
            Tracer.Visible = false
            Tracer.Color = Color3.new(1, 1, 1)
            Tracer.Thickness = 1
            Tracer.Transparency = 1

            ESP.Boxes[v] = {
                BoxOutline = BoxOutline,
                Box = Box,
                Tracer = Tracer
            }
        end
    end

    Players.PlayerAdded:Connect(function(player)
        -- Box ESP
        local BoxOutline = Drawing.new("Square")
        BoxOutline.Visible = false
        BoxOutline.Color = Color3.new(0, 0, 0)
        BoxOutline.Thickness = 3
        BoxOutline.Transparency = 1
        BoxOutline.Filled = false

        local Box = Drawing.new("Square")
        Box.Visible = false
        Box.Color = Color3.new(1, 1, 1)
        Box.Thickness = 1
        Box.Transparency = 1
        Box.Filled = false

        -- Tracer ESP
        local Tracer = Drawing.new("Line")
        Tracer.Visible = false
        Tracer.Color = Color3.new(1, 1, 1)
        Tracer.Thickness = 1
        Tracer.Transparency = 1

        ESP.Boxes[player] = {
            BoxOutline = BoxOutline,
            Box = Box,
            Tracer = Tracer
        }
    end)

    Players.PlayerRemoving:Connect(function(player)
        if ESP.Boxes[player] then
            ESP.Boxes[player].BoxOutline:Remove()
            ESP.Boxes[player].Box:Remove()
            ESP.Boxes[player].Tracer:Remove()
            ESP.Boxes[player] = nil
        end
    end)
end

-- Update ESP
local function UpdateESP()
    for player, drawings in pairs(ESP.Boxes) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local HRP = player.Character.HumanoidRootPart
            local Head = player.Character.Head
            local pos, onScreen = Camera:WorldToViewportPoint(HRP.Position)
            
            if onScreen then
                -- Team Check
                if _G.Settings.ESP.TeamCheck and player.Team == LocalPlayer.Team then
                    drawings.Box.Visible = false
                    drawings.BoxOutline.Visible = false
                    drawings.Tracer.Visible = false
                    continue
                end

                -- Box ESP
                if _G.Settings.ESP.BoxESP then
                    local TopY = Camera:WorldToViewportPoint(Head.Position + Vector3.new(0, 1, 0)).Y
                    local BottomY = Camera:WorldToViewportPoint(HRP.Position - Vector3.new(0, 3, 0)).Y
                    local Height = math.abs(TopY - BottomY)
                    local Width = Height * 0.6

                    drawings.BoxOutline.Size = Vector2.new(Width, Height)
                    drawings.BoxOutline.Position = Vector2.new(pos.X - Width / 2, pos.Y - Height / 2)
                    drawings.BoxOutline.Visible = true

                    drawings.Box.Size = Vector2.new(Width, Height)
                    drawings.Box.Position = Vector2.new(pos.X - Width / 2, pos.Y - Height / 2)
                    drawings.Box.Visible = true
                else
                    drawings.Box.Visible = false
                    drawings.BoxOutline.Visible = false
                end

                -- Tracer ESP
                if _G.Settings.ESP.TracerESP then
                    drawings.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    drawings.Tracer.To = Vector2.new(pos.X, pos.Y)
                    drawings.Tracer.Visible = true
                else
                    drawings.Tracer.Visible = false
                end
            else
                drawings.Box.Visible = false
                drawings.BoxOutline.Visible = false
                drawings.Tracer.Visible = false
            end
        else
            drawings.Box.Visible = false
            drawings.BoxOutline.Visible = false
            drawings.Tracer.Visible = false
        end
    end
end

-- No Recoil
local mt = getrawmetatable(game)
setreadonly(mt, false)
local old = mt.__namecall
mt.__namecall = newcclosure(function(...)
    local args = {...}
    local method = getnamecallmethod()
    
    if method == "FireServer" and args[1] == "RecoilFire" then
        return
    end
    
    return old(...)
end)

-- Main Loop
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Visible = _G.Settings.Aimbot.ShowFOV

    if _G.Settings.Aimbot.Enabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        local Target = GetClosestPlayer()
        if Target and Target.Character and Target.Character:FindFirstChild("Head") then
            local HeadPos = Target.Character.Head.Position
            local HeadScreenPos = Camera:WorldToViewportPoint(HeadPos)
            local ScreenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            local MousePos = Vector2.new(Mouse.X, Mouse.Y)
            local MoveAmount = (Vector2.new(HeadScreenPos.X, HeadScreenPos.Y) - MousePos) * _G.Settings.Aimbot.Smoothness
            mousemoverel(MoveAmount.X, MoveAmount.Y)
        end
    end

    UpdateESP()
end)

-- Minimizar/Maximizar
MinimizeBtn.MouseButton1Click:Connect(function()
    if Container.Visible then
        Container.Visible = false
        MainFrame:TweenSize(UDim2.new(0, 250, 0, 30), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.5, true)
    else
        Container.Visible = true
        MainFrame:TweenSize(UDim2.new(0, 250, 0, 300), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.5, true)
    end
end)

-- Inicialização
CreateESP()