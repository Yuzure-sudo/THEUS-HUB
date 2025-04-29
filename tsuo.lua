-- Carregando a biblioteca Avaco
local Avaco = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Avaco/main/Library.lua"))()

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Configurações Principais
local Settings = {
    Aimbot = {
        Enabled = false,
        Key = Enum.KeyCode.E,
        TeamCheck = true,
        Smoothness = 0.25,
        TargetPart = "Head",
        PredictMovement = true,
        PredictionStrength = 0.15
    },
    FOV = {
        Enabled = true,
        Centered = true,
        Size = 250,
        Color = Color3.fromRGB(255, 255, 255),
        Thickness = 1,
        Filled = false,
        Transparency = 1,
        Rainbow = false
    },
    ESP = {
        Enabled = false,
        TeamCheck = true,
        Box = true,
        Name = true,
        Distance = true,
        Health = true,
        TeamColor = Color3.fromRGB(0, 255, 0),
        EnemyColor = Color3.fromRGB(255, 0, 0)
    },
    Combat = {
        NoRecoil = true,
        AutoShoot = false,
        RapidFire = false
    },
    Autofarm = {
        Enabled = false,
        KillAura = true,
        TeleportDelay = 0.1,
        SafeDistance = 5
    }
}

-- Interface Avaco
local Window = Avaco:CreateWindow({
    Title = "Theus Hub | Flag War",
    Theme = "Dark",
    SizeX = 400,
    SizeY = 500,
    Position = UDim2.new(0.5, -200, 0.5, -250)
})

-- Criando Tabs
local CombatTab = Window:CreateTab("Combat")
local VisualTab = Window:CreateTab("Visuals")
local AutofarmTab = Window:CreateTab("Autofarm")
local SettingsTab = Window:CreateTab("Settings")

-- Combat Tab
local AimbotSection = CombatTab:CreateSection("Aimbot")

AimbotSection:CreateToggle({
    Name = "Enable Aimbot",
    Default = Settings.Aimbot.Enabled,
    Callback = function(Value)
        Settings.Aimbot.Enabled = Value
    end
})

AimbotSection:CreateSlider({
    Name = "Aimbot Smoothness",
    Min = 0.01,
    Max = 1,
    Default = Settings.Aimbot.Smoothness,
    Increment = 0.01,
    Callback = function(Value)
        Settings.Aimbot.Smoothness = Value
    end
})

AimbotSection:CreateDropdown({
    Name = "Target Part",
    Options = {"Head", "HumanoidRootPart", "Torso"},
    Default = Settings.Aimbot.TargetPart,
    Callback = function(Value)
        Settings.Aimbot.TargetPart = Value
    end
})

local CombatModsSection = CombatTab:CreateSection("Combat Mods")

CombatModsSection:CreateToggle({
    Name = "No Recoil",
    Default = Settings.Combat.NoRecoil,
    Callback = function(Value)
        Settings.Combat.NoRecoil = Value
    end
})

CombatModsSection:CreateToggle({
    Name = "Auto Shoot",
    Default = Settings.Combat.AutoShoot,
    Callback = function(Value)
        Settings.Combat.AutoShoot = Value
    end
})

-- Visual Tab
local ESPSection = VisualTab:CreateSection("ESP")

ESPSection:CreateToggle({
    Name = "Enable ESP",
    Default = Settings.ESP.Enabled,
    Callback = function(Value)
        Settings.ESP.Enabled = Value
    end
})

ESPSection:CreateToggle({
    Name = "Team Check",
    Default = Settings.ESP.TeamCheck,
    Callback = function(Value)
        Settings.ESP.TeamCheck = Value
    end
})

ESPSection:CreateToggle({
    Name = "Show Boxes",
    Default = Settings.ESP.Box,
    Callback = function(Value)
        Settings.ESP.Box = Value
    end
})

ESPSection:CreateToggle({
    Name = "Show Names",
    Default = Settings.ESP.Name,
    Callback = function(Value)
        Settings.ESP.Name = Value
    end
})

ESPSection:CreateToggle({
    Name = "Show Health",
    Default = Settings.ESP.Health,
    Callback = function(Value)
        Settings.ESP.Health = Value
    end
})

-- FOV Circle Section
local FOVSection = VisualTab:CreateSection("FOV Circle")

FOVSection:CreateToggle({
    Name = "Show FOV Circle",
    Default = Settings.FOV.Enabled,
    Callback = function(Value)
        Settings.FOV.Enabled = Value
    end
})

FOVSection:CreateToggle({
    Name = "Centered FOV",
    Default = Settings.FOV.Centered,
    Callback = function(Value)
        Settings.FOV.Centered = Value
    end
})

FOVSection:CreateSlider({
    Name = "FOV Size",
    Min = 50,
    Max = 500,
    Default = Settings.FOV.Size,
    Increment = 5,
    Callback = function(Value)
        Settings.FOV.Size = Value
    end
})

FOVSection:CreateSlider({
    Name = "FOV Thickness",
    Min = 1,
    Max = 5,
    Default = Settings.FOV.Thickness,
    Increment = 0.1,
    Callback = function(Value)
        Settings.FOV.Thickness = Value
    end
})

FOVSection:CreateColorPicker({
    Name = "FOV Color",
    Default = Settings.FOV.Color,
    Callback = function(Value)
        if not Settings.FOV.Rainbow then
            Settings.FOV.Color = Value
        end
    end
})

FOVSection:CreateToggle({
    Name = "Rainbow FOV",
    Default = Settings.FOV.Rainbow,
    Callback = function(Value)
        Settings.FOV.Rainbow = Value
    end
})

-- Autofarm Tab
local AutofarmSection = AutofarmTab:CreateSection("Autofarm")

AutofarmSection:CreateToggle({
    Name = "Enable Autofarm",
    Default = Settings.Autofarm.Enabled,
    Callback = function(Value)
        Settings.Autofarm.Enabled = Value
    end
})

AutofarmSection:CreateToggle({
    Name = "Kill Aura",
    Default = Settings.Autofarm.KillAura,
    Callback = function(Value)
        Settings.Autofarm.KillAura = Value
    end
})

AutofarmSection:CreateSlider({
    Name = "Teleport Delay",
    Min = 0.1,
    Max = 1,
    Default = Settings.Autofarm.TeleportDelay,
    Increment = 0.1,
    Callback = function(Value)
        Settings.Autofarm.TeleportDelay = Value
    end
})

-- FOV Circle Implementation
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = Settings.FOV.Thickness
FOVCircle.Color = Settings.FOV.Color
FOVCircle.Transparency = Settings.FOV.Transparency
FOVCircle.Filled = Settings.FOV.Filled
FOVCircle.NumSides = 60

-- Função para atualizar o FOV Circle
local function UpdateFOVCircle()
    if Settings.FOV.Enabled then
        FOVCircle.Radius = Settings.FOV.Size
        FOVCircle.Visible = true
        
        if Settings.FOV.Centered then
            FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        else
            FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
        end
        
        if Settings.FOV.Rainbow then
            FOVCircle.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
        end
    else
        FOVCircle.Visible = false
    end
end

-- ESP Implementation
local function CreateESP(player)
    local ESP = {
        Box = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Health = Drawing.new("Text"),
        Distance = Drawing.new("Text")
    }
    
    -- Configure ESP elements
    for _, drawing in pairs(ESP) do
        drawing.Visible = false
        drawing.Color = Color3.new(1, 1, 1)
        drawing.Transparency = 1
    end
    
    -- Update ESP
    RunService.RenderStepped:Connect(function()
        if not Settings.ESP.Enabled then
            for _, drawing in pairs(ESP) do
                drawing.Visible = false
            end
            return
        end
        
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            for _, drawing in pairs(ESP) do
                drawing.Visible = false
            end
            return
        end
        
        local humanoidRootPart = player.Character.HumanoidRootPart
        local vector, onScreen = Camera:WorldToViewportPoint(humanoidRootPart.Position)
        
        if not onScreen then
            for _, drawing in pairs(ESP) do
                drawing.Visible = false
            end
            return
        end
        
        -- Update ESP elements
        -- (Implementação do ESP aqui)
    end)
end

-- Autofarm Implementation
local function AutofarmPlayers()
    if not Settings.Autofarm.Enabled then return end
    
    local function GetClosestEnemy()
        local closest = nil
        local maxDistance = math.huge
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Team ~= LocalPlayer.Team then
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local distance = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                    if distance < maxDistance then
                        closest = player
                        maxDistance = distance
                    end
                end
            end
        end
        
        return closest
    end
    
    RunService.Heartbeat:Connect(function()
        if Settings.Autofarm.Enabled then
            local target = GetClosestEnemy()
            if target and target.Character then
                LocalPlayer.Character.HumanoidRootPart.CFrame = 
                    target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, Settings.Autofarm.SafeDistance)
                
                if Settings.Autofarm.KillAura then
                    -- Implementar lógica de ataque aqui
                end
                
                wait(Settings.Autofarm.TeleportDelay)
            end
        end
    end)
end

-- Inicialização
RunService.RenderStepped:Connect(UpdateFOVCircle)

for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end)

AutofarmPlayers()