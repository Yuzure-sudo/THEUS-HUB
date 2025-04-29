-- Services
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- Variables
local plr = Players.LocalPlayer
local mouse = plr:GetMouse()
local camera = workspace.CurrentCamera

-- Interface Principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TheusHub"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Frame Principal
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 250, 0, 350)
Main.Position = UDim2.new(0.5, -125, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui
Main.Active = true
Main.Draggable = true

-- Arredondamento do Frame Principal
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = Main

-- Barra Superior
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TopBar.BorderSizePixel = 0
TopBar.Parent = Main

-- Arredondamento da Barra Superior
local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 8)
TopBarCorner.Parent = TopBar

-- Título
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -35, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Theus Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Botão de Minimizar
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Size = UDim2.new(0, 25, 0, 25)
MinimizeBtn.Position = UDim2.new(1, -30, 0, 5)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 16
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Parent = TopBar

-- Arredondamento do Botão de Minimizar
local MinimizeBtnCorner = Instance.new("UICorner")
MinimizeBtnCorner.CornerRadius = UDim.new(0, 6)
MinimizeBtnCorner.Parent = MinimizeBtn

-- Container das Abas
local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Size = UDim2.new(1, -20, 1, -45)
TabContainer.Position = UDim2.new(0, 10, 0, 40)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = Main

-- Botões das Abas
local TabButtons = Instance.new("Frame")
TabButtons.Name = "TabButtons"
TabButtons.Size = UDim2.new(1, 0, 0, 30)
TabButtons.BackgroundTransparency = 1
TabButtons.Parent = TabContainer

-- Função para criar botões das abas
local function CreateTab(name)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name.."Tab"
    TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TabButton.Size = UDim2.new(0.33, -3, 1, 0)
    TabButton.Text = name
    TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.TextSize = 14
    TabButton.Font = Enum.Font.GothamSemibold
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 6)
    TabCorner.Parent = TabButton
    
    return TabButton
end

-- Criando as Abas
local CombatTab = CreateTab("Combat")
CombatTab.Position = UDim2.new(0, 0, 0, 0)
CombatTab.Parent = TabButtons

local VisualsTab = CreateTab("Visuals")
VisualsTab.Position = UDim2.new(0.33, 3, 0, 0)
VisualsTab.Parent = TabButtons

local MiscTab = CreateTab("Misc")
MiscTab.Position = UDim2.new(0.66, 6, 0, 0)
MiscTab.Parent = TabButtons

-- Conteúdo das Abas
local TabContent = Instance.new("Frame")
TabContent.Name = "TabContent"
TabContent.Size = UDim2.new(1, 0, 1, -40)
TabContent.Position = UDim2.new(0, 0, 0, 35)
TabContent.BackgroundTransparency = 1
TabContent.Parent = TabContainer

-- Sistema de Minimizar
local minimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        Main:TweenSize(UDim2.new(0, 250, 0, 35), "Out", "Quad", 0.3, true)
        MinimizeBtn.Text = "+"
    else
        Main:TweenSize(UDim2.new(0, 250, 0, 350), "Out", "Quad", 0.3, true)
        MinimizeBtn.Text = "-"
    end
end)

-- Sistema de Abas
local function SwitchTab(tab)
    for _, button in pairs(TabButtons:GetChildren()) do
        if button:IsA("TextButton") then
            button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        end
    end
    tab.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
end

CombatTab.MouseButton1Click:Connect(function()
    SwitchTab(CombatTab)
    -- Mostrar conteúdo da aba Combat
end)

VisualsTab.MouseButton1Click:Connect(function()
    SwitchTab(VisualsTab)
    -- Mostrar conteúdo da aba Visuals
end)

MiscTab.MouseButton1Click:Connect(function()
    SwitchTab(MiscTab)
    -- Mostrar conteúdo da aba Misc
end)

-- Inicializar na primeira aba
SwitchTab(CombatTab)

-- Configurações
local Settings = {
    Aimbot = {
        Enabled = false,
        Key = "E",
        Smoothness = 0.5,
        TeamCheck = true,
        TargetPart = "Head"
    },
    ESP = {
        Enabled = false,
        TeamCheck = true,
        BoxESP = true,
        NameESP = true,
        HealthESP = true,
        TracerESP = false,
        TeamColor = Color3.fromRGB(0, 255, 0),
        EnemyColor = Color3.fromRGB(255, 0, 0)
    },
    Misc = {
        NoRecoil = false,
        InfiniteJump = false,
        SpeedHack = false,
        SpeedValue = 50
    }
}

-- Funções de Utilidade
local function CreateToggle(parent, name, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = name.."Toggle"
    ToggleFrame.Size = UDim2.new(1, 0, 0, 30)
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Parent = parent

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 40, 0, 20)
    ToggleButton.Position = UDim2.new(1, -45, 0.5, -10)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ToggleButton.Text = ""
    ToggleButton.Parent = ToggleFrame

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(1, 0)
    ToggleCorner.Parent = ToggleButton

    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
    ToggleCircle.Position = UDim2.new(0, 2, 0.5, -8)
    ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ToggleCircle.Parent = ToggleButton

    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = ToggleCircle

    local ToggleText = Instance.new("TextLabel")
    ToggleText.Size = UDim2.new(1, -55, 1, 0)
    ToggleText.BackgroundTransparency = 1
    ToggleText.Text = name
    ToggleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleText.TextSize = 14
    ToggleText.Font = Enum.Font.GothamSemibold
    ToggleText.TextXAlignment = Enum.TextXAlignment.Left
    ToggleText.Parent = ToggleFrame

    local enabled = false
    ToggleButton.MouseButton1Click:Connect(function()
        enabled = not enabled
        TS:Create(ToggleCircle, TweenInfo.new(0.2), {
            Position = enabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
            BackgroundColor3 = enabled and Color3.fromRGB(0, 255, 140) or Color3.fromRGB(255, 255, 255)
        }):Play()
        callback(enabled)
    end)
end

-- ESP Melhorado
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "ESPFolder"
ESPFolder.Parent = game.CoreGui

local function CreateESPBox(player)
    local Box = Instance.new("BoxHandleAdornment")
    Box.Name = "ESP"
    Box.Size = Vector3.new(4, 5, 2)
    Box.Color3 = Settings.ESP.TeamCheck and 
        (player.Team == plr.Team and Settings.ESP.TeamColor or Settings.ESP.EnemyColor) or
        Settings.ESP.EnemyColor
    Box.Transparency = 0.5
    Box.AlwaysOnTop = true
    Box.ZIndex = 5
    Box.Visible = Settings.ESP.Enabled and Settings.ESP.BoxESP
    
    local Name = Instance.new("BillboardGui")
    Name.Name = "NameESP"
    Name.Size = UDim2.new(0, 200, 0, 50)
    Name.AlwaysOnTop = true
    Name.StudsOffset = Vector3.new(0, 2, 0)
    
    local NameLabel = Instance.new("TextLabel")
    NameLabel.Size = UDim2.new(1, 0, 1, 0)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = player.Name
    NameLabel.TextColor3 = Box.Color3
    NameLabel.TextSize = 14
    NameLabel.Font = Enum.Font.GothamSemibold
    NameLabel.Parent = Name
    
    local Health = Instance.new("BillboardGui")
    Health.Name = "HealthESP"
    Health.Size = UDim2.new(0, 200, 0, 50)
    Health.AlwaysOnTop = true
    Health.StudsOffset = Vector3.new(0, -2, 0)
    
    local HealthLabel = Instance.new("TextLabel")
    HealthLabel.Size = UDim2.new(1, 0, 1, 0)
    HealthLabel.BackgroundTransparency = 1
    HealthLabel.TextColor3 = Box.Color3
    HealthLabel.TextSize = 14
    HealthLabel.Font = Enum.Font.GothamSemibold
    HealthLabel.Parent = Health
    
    local function UpdateESP()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            Box.Adornee = player.Character
            Box.Parent = ESPFolder
            
            Name.Adornee = player.Character.Head
            Name.Parent = ESPFolder
            Name.Enabled = Settings.ESP.Enabled and Settings.ESP.NameESP
            
            Health.Adornee = player.Character.Head
            Health.Parent = ESPFolder
            Health.Enabled = Settings.ESP.Enabled and Settings.ESP.HealthESP
            
            if player.Character:FindFirstChild("Humanoid") then
                HealthLabel.Text = math.floor(player.Character.Humanoid.Health).."/"..math.floor(player.Character.Humanoid.MaxHealth)
            end
        end
    end
    
    RS.RenderStepped:Connect(UpdateESP)
end

-- Aimbot
local function GetClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= plr and player.Character and player.Character:FindFirstChild(Settings.Aimbot.TargetPart) then
            if not Settings.Aimbot.TeamCheck or player.Team ~= plr.Team then
                local pos = camera:WorldToViewportPoint(player.Character[Settings.Aimbot.TargetPart].Position)
                local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(mouse.X, mouse.Y)).magnitude
                
                if magnitude < shortestDistance then
                    closestPlayer = player
                    shortestDistance = magnitude
                end
            end
        end
    end
    
    return closestPlayer
end

-- Criar conteúdo das abas
local CombatContent = Instance.new("Frame")
CombatContent.Name = "CombatContent"
CombatContent.Size = UDim2.new(1, 0, 1, 0)
CombatContent.BackgroundTransparency = 1
CombatContent.Parent = TabContent

local VisualsContent = Instance.new("Frame")
VisualsContent.Name = "VisualsContent"
VisualsContent.Size = UDim2.new(1, 0, 1, 0)
VisualsContent.BackgroundTransparency = 1
VisualsContent.Visible = false
VisualsContent.Parent = TabContent

local MiscContent = Instance.new("Frame")
MiscContent.Name = "MiscContent"
MiscContent.Size = UDim2.new(1, 0, 1, 0)
MiscContent.BackgroundTransparency = 1
MiscContent.Visible = false
MiscContent.Parent = TabContent

-- Adicionar Toggles
CreateToggle(CombatContent, "Aimbot", function(enabled)
    Settings.Aimbot.Enabled = enabled
end)

CreateToggle(VisualsContent, "ESP", function(enabled)
    Settings.ESP.Enabled = enabled
end)

CreateToggle(VisualsContent, "Box ESP", function(enabled)
    Settings.ESP.BoxESP = enabled
end)

CreateToggle(VisualsContent, "Name ESP", function(enabled)
    Settings.ESP.NameESP = enabled
end)

CreateToggle(VisualsContent, "Health ESP", function(enabled)
    Settings.ESP.HealthESP = enabled
end)

CreateToggle(VisualsContent, "Team Check", function(enabled)
    Settings.ESP.TeamCheck = enabled
end)

CreateToggle(MiscContent, "No Recoil", function(enabled)
    Settings.Misc.NoRecoil = enabled
end)

CreateToggle(MiscContent, "Speed Hack", function(enabled)
    Settings.Misc.SpeedHack = enabled
    if enabled then
        plr.Character.Humanoid.WalkSpeed = Settings.Misc.SpeedValue
    else
        plr.Character.Humanoid.WalkSpeed = 16
    end
end)

-- Main Loop
RS.RenderStepped:Connect(function()
    if Settings.Aimbot.Enabled and UIS:IsKeyDown(Enum.KeyCode[Settings.Aimbot.Key]) then
        local target = GetClosestPlayer()
        if target then
            local pos = camera:WorldToViewportPoint(target.Character[Settings.Aimbot.TargetPart].Position)
            mousemoverel((pos.X - mouse.X) * Settings.Aimbot.Smoothness, (pos.Y - mouse.Y) * Settings.Aimbot.Smoothness)
        end
    end
end)

-- Player Handlers
Players.PlayerAdded:Connect(function(player)
    if Settings.ESP.Enabled then
        CreateESPBox(player)
    end
end)

for _, player in pairs(Players:GetPlayers()) do
    if player ~= plr then
        CreateESPBox(player)
    end
end

-- No Recoil
local mt = getrawmetatable(game)
setreadonly(mt, false)
local old = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    if Settings.Misc.NoRecoil and method == "FireServer" and args[1] == "Recoil" then
        return
    end
    
    return old(self, ...)
end)