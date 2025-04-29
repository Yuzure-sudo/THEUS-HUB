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

-- Configurações
local Settings = {
    Aimbot = false,
    ESP = false,
    NoRecoil = false,
    TeamCheck = true,
    Smoothness = 0.25
}

-- Funções
local function CreateButton(name)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 35)
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
local AimbotBtn = CreateButton("Aimbot: OFF")
local ESPBtn = CreateButton("ESP: OFF")
local NoRecoilBtn = CreateButton("No Recoil: OFF")
local TeamCheckBtn = CreateButton("Team Check: ON")

AimbotBtn.Position = UDim2.new(0, 0, 0, 0)
ESPBtn.Position = UDim2.new(0, 0, 0, 45)
NoRecoilBtn.Position = UDim2.new(0, 0, 0, 90)
TeamCheckBtn.Position = UDim2.new(0, 0, 0, 135)

-- Aimbot
local function GetClosestPlayer()
    local MaxDist = math.huge
    local Target = nil
    
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            if not Settings.TeamCheck or v.Team ~= LocalPlayer.Team then
                local Point, OnScreen = Camera:WorldToViewportPoint(v.Character.Head.Position)
                if OnScreen then
                    local Dist = (Vector2.new(Point.X, Point.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                    if Dist < MaxDist then
                        MaxDist = Dist
                        Target = v
                    end
                end
            end
        end
    end
    return Target
end

-- ESP
local function CreateESP(plr)
    local Box = Instance.new("BoxHandleAdornment")
    Box.Name = "ESP"
    Box.Size = Vector3.new(4, 5, 2)
    Box.Color3 = Settings.TeamCheck and plr.Team == LocalPlayer.Team and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    Box.Transparency = 0.5
    Box.AlwaysOnTop = true
    Box.Adornee = plr.Character
    Box.ZIndex = 5
    Box.Parent = plr.Character
end

-- NoRecoil
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldindex = mt.__index
local oldnamecall = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    if Settings.NoRecoil then
        if method == "FireServer" and args[1] == "Recoil" then
            return wait(9e9)
        end
    end
    
    return oldnamecall(self, unpack(args))
end)

-- Eventos
RunService.RenderStepped:Connect(function()
    if Settings.Aimbot and UserInputService:IsKeyDown(Enum.KeyCode.E) then
        local Target = GetClosestPlayer()
        if Target and Target.Character then
            local Head = Target.Character.Head
            local HeadPos = Head.Position + Head.Velocity * Settings.Smoothness
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, HeadPos), Settings.Smoothness)
        end
    end
    
    if Settings.ESP then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and not plr.Character:FindFirstChild("ESP") then
                if not Settings.TeamCheck or plr.Team ~= LocalPlayer.Team then
                    CreateESP(plr)
                end
            end
        end
    end
end)

-- Botões Eventos
local function UpdateButton(button, enabled)
    button.Text = button.Text:gsub("ON", "OFF"):gsub("OFF", "ON")
    button.BackgroundColor3 = enabled and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(35, 35, 35)
end

AimbotBtn.MouseButton1Click:Connect(function()
    Settings.Aimbot = not Settings.Aimbot
    UpdateButton(AimbotBtn, Settings.Aimbot)
end)

ESPBtn.MouseButton1Click:Connect(function()
    Settings.ESP = not Settings.ESP
    UpdateButton(ESPBtn, Settings.ESP)
    if not Settings.ESP then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("ESP") then
                plr.Character.ESP:Destroy()
            end
        end
    end
end)

NoRecoilBtn.MouseButton1Click:Connect(function()
    Settings.NoRecoil = not Settings.NoRecoil
    UpdateButton(NoRecoilBtn, Settings.NoRecoil)
end)

TeamCheckBtn.MouseButton1Click:Connect(function()
    Settings.TeamCheck = not Settings.TeamCheck
    UpdateButton(TeamCheckBtn, Settings.TeamCheck)
end)

-- Minimizar
MinimizeBtn.MouseButton1Click:Connect(function()
    if Main.Size == UDim2.new(0, 300, 0, 350) then
        Main:TweenSize(UDim2.new(0, 300, 0, 35), "Out", "Quad", 0.3, true)
        MinimizeBtn.Text = "+"
    else
        Main:TweenSize(UDim2.new(0, 300, 0, 350), "Out", "Quad", 0.3, true)
        MinimizeBtn.Text = "-"
    end
end)