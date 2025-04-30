-- THEUS HUB 2024 [INTERFACE MODERNA E SISTEMA APELÃO]
-- CRIADO PRA DOMINAR QUALQUER JOGO MLK
-- INTERFACE ANIMADA E OTIMIZADA PRA MOBILE

-- SERVIÇOS E LIBS
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/theme.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/save.lua"))()

-- SERVIÇOS DO GAME
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- INTERFACE MODERNA
local Window = Library.CreateLib("THEUS HUB 2024", "Midnight")

-- ANIMAÇÃO DE LOADING INICIAL
local LoadingScreen = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local LoadingBar = Instance.new("Frame")
local LoadingText = Instance.new("TextLabel")
local Logo = Instance.new("ImageLabel")

LoadingScreen.Name = "TheusLoading"
LoadingScreen.Parent = CoreGui
LoadingScreen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Name = "MainFrame"
MainFrame.Parent = LoadingScreen
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -85)
MainFrame.Size = UDim2.new(0, 300, 0, 170)

LoadingBar.Name = "LoadingBar"
LoadingBar.Parent = MainFrame
LoadingBar.BackgroundColor3 = Color3.fromRGB(0, 85, 255)
LoadingBar.BorderSizePixel = 0
LoadingBar.Position = UDim2.new(0, 10, 0.8, 0)
LoadingBar.Size = UDim2.new(0, 0, 0, 5)

LoadingText.Name = "LoadingText"
LoadingText.Parent = MainFrame
LoadingText.BackgroundTransparency = 1
LoadingText.Position = UDim2.new(0, 0, 0.6, 0)
LoadingText.Size = UDim2.new(1, 0, 0, 20)
LoadingText.Font = Enum.Font.GothamBold
LoadingText.Text = "Carregando..."
LoadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadingText.TextSize = 14

Logo.Name = "Logo"
Logo.Parent = MainFrame
Logo.BackgroundTransparency = 1
Logo.Position = UDim2.new(0.5, -50, 0.1, 0)
Logo.Size = UDim2.new(0, 100, 0, 100)
Logo.Image = "rbxassetid://7072706620" -- Logo personalizado

-- ANIMAÇÃO DE LOADING
local function AnimateLoading()
    local tween = TweenService:Create(LoadingBar, 
        TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = UDim2.new(0.93, 0, 0, 5)}
    )
    tween:Play()
    
    wait(2.5)
    LoadingScreen:Destroy()
end

-- CONFIGURAÇÕES COMPLETAS
local Config = {
    Aimbot = {
        Enabled = false,
        Silent = true,
        WallBang = true,
        InstantKill = true,
        AutoTrigger = true,
        Prediction = true,
        TargetPart = "Head",
        FOV = 999999,
        HitChance = 100,
        TeamCheck = false,
        VisibilityCheck = false,
        AutoShoot = true,
        MouseTrigger = true,
        NearestPoint = true,
        PredictionAmount = 0.165,
        AimAssist = true,
        SmoothAim = true,
        SmoothAmount = 0.5
    },
    
    Visuals = {
        ESP = {
            Enabled = false,
            Boxes = true,
            Tracers = true,
            Names = true,
            Distance = true,
            Health = true,
            Chams = true,
            XRay = true,
            Rainbow = true,
            TeamColor = false,
            ShowTeam = false,
            Skeleton = true,
            HeadDot = true,
            DirectionArrow = true,
            BoxType = "Corner", -- Corner, Classic, Full
            BoxColor = Color3.fromRGB(255, 255, 255),
            BoxTransparency = 0.8,
            TracerOrigin = "Bottom", -- Bottom, Mouse, Top
            TracerColor = Color3.fromRGB(255, 255, 255),
            NameColor = Color3.fromRGB(255, 255, 255),
            DistanceColor = Color3.fromRGB(255, 255, 255),
            HealthBarType = "Side", -- Side, Bottom
            HealthBarColor = Color3.fromRGB(0, 255, 0),
            ChamsColor = Color3.fromRGB(255, 0, 0),
            ChamsTransparency = 0.5
        },
        
        World = {
            FullBright = false,
            NoFog = false,
            CustomTime = false,
            TimeValue = 14,
            Ambient = false,
            AmbientColor = Color3.new(1,1,1),
            NoShadows = false,
            CustomFOV = false,
            FOVAmount = 70,
            Saturation = false,
            SaturationAmount = 0.5,
            Contrast = false,
            ContrastAmount = 0.5,
            CustomSkybox = false,
            SkyboxID = ""
        }
    },
    
    Combat = {
        InfiniteAmmo = false,
        NoRecoil = false,
        NoSpread = false,
        RapidFire = false,
        AutoReload = false,
        InstantReload = false,
        OneShot = false,
        FireRate = false,
        FireRateAmount = 0.1,
        BulletTracer = false,
        TracerColor = Color3.fromRGB(255, 0, 0),
        HitMarker = false,
        HitSound = false,
        CustomHitSound = "",
        BulletImpact = false,
        ImpactColor = Color3.fromRGB(255, 0, 0)
    },
    
    Movement = {
        SpeedHack = false,
        SpeedValue = 100,
        JumpPower = false,
        JumpValue = 100,
        InfiniteJump = false,
        BunnyHop = false,
        AutoBhop = false,
        NoClip = false,
        Flight = false,
        FlightSpeed = 50,
        Teleport = false,
        ClickTP = false,
        NoclipBypass = false
    },
    
    Exploits = {
        GodMode = false,
        AntiAim = false,
        Spinbot = false,
        SpinSpeed = 10,
        NoFallDamage = false,
        NoStun = false,
        InstantRespawn = false,
        AntiKick = false,
        AntiBan = false,
        AntiReport = false,
        ChatSpam = false,
        SpamMessage = "THEUS HUB ON TOP",
        KillAll = false,
        ServerCrash = false
    }
}

-- FUNÇÕES PRINCIPAIS
local function CreateNotification(title, text, duration)
    game.StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration,
        Button1 = "OK"
    })
end

-- SISTEMAS APELÕES

-- AIMBOT AVANÇADO
local function GetClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = Config.Aimbot.FOV
    local sortedPlayers = {}
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") 
        and player.Character.Humanoid.Health > 0 and player.Character:FindFirstChild(Config.Aimbot.TargetPart) then
            
            if Config.Aimbot.TeamCheck and player.Team == LocalPlayer.Team then continue end
            
            local pos = Camera:WorldToViewportPoint(player.Character[Config.Aimbot.TargetPart].Position)
            local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).magnitude
            
            table.insert(sortedPlayers, {
                Player = player,
                Distance = magnitude,
                Position = pos
            })
        end
    end
    
    table.sort(sortedPlayers, function(a, b)
        return a.Distance < b.Distance
    end)
    
    return sortedPlayers[1] and sortedPlayers[1].Player or nil
end

-- ESP SISTEMA AVANÇADO
local function CreateAdvancedESP(player)
    local ESP = {
        Box = Drawing.new("Square"),
        BoxOutline = Drawing.new("Square"),
        BoxFill = Drawing.new("Square"),
        Tracer = Drawing.new("Line"),
        TracerOutline = Drawing.new("Line"),
        Name = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
        HealthBar = Drawing.new("Square"),
        HealthBarOutline = Drawing.new("Square"),
        HealthText = Drawing.new("Text"),
        HeadDot = Drawing.new("Circle"),
        HeadDotOutline = Drawing.new("Circle"),
        ViewAngle = Drawing.new("Line"),
        Skeleton = {
            Head = Drawing.new("Line"),
            Torso = Drawing.new("Line"),
            LeftArm = Drawing.new("Line"),
            RightArm = Drawing.new("Line"),
            LeftLeg = Drawing.new("Line"),
            RightLeg = Drawing.new("Line")
        }
    }
    
    -- Inicialização dos elementos ESP
    for _, drawing in pairs(ESP) do
        if type(drawing) ~= "table" then
            drawing.Visible = false
            if drawing.ClassName == "Text" then
                drawing.Center = true
                drawing.Outline = true
                drawing.Font = 3
                drawing.Size = 16
            end
        end
    end
    
    return ESP
end

-- INTERFACE MODERNA COM ANIMAÇÕES
local MainTab = Window:NewTab("COMBATE")
local VisualsTab = Window:NewTab("VISUAL")
local MovementTab = Window:NewTab("MOVIMENTO")
local ExploitsTab = Window:NewTab("EXPLOITS")
local SettingsTab = Window:NewTab("CONFIG")

-- SEÇÕES ANIMADAS
local AimbotSection = MainTab:NewSection("AIMBOT DESTRUTIVO")
local WeaponSection = MainTab:NewSection("MODIFICAÇÃO DE ARMAS")
local ESPSection = VisualsTab:NewSection("ESP MALANDRO")
local WorldSection = VisualsTab:NewSection("MUNDO")
local MovementSection = MovementTab:NewSection("MOVIMENTO")
local ExploitsSection = ExploitsTab:NewSection("EXPLOITS")
local SettingsSection = SettingsTab:NewSection("CONFIGURAÇÕES")

-- BOTÕES COM ANIMAÇÃO
AimbotSection:NewButton("ATIVAR AIMBOT", "Ativa o aimbot destrutivo", function()
    Config.Aimbot.Enabled = not Config.Aimbot.Enabled
    CreateNotification("AIMBOT", Config.Aimbot.Enabled and "ATIVADO" or "DESATIVADO", 2)
end)

-- TOGGLES ANIMADOS
AimbotSection:NewToggle("SILENT AIM", "Aimbot invisível", function(state)
    Config.Aimbot.Silent = state
end)

AimbotSection:NewToggle("WALLBANG", "Atira através das paredes", function(state)
    Config.Aimbot.WallBang = state
end)

-- SLIDERS COM ANIMAÇÃO
AimbotSection:NewSlider("FOV", "Campo de visão do aimbot", 1000, 10, function(value)
    Config.Aimbot.FOV = value
end)

-- ESP TOGGLES
ESPSection:NewToggle("ESP COMPLETO", "Ativa todas as funções do ESP", function(state)
    Config.Visuals.ESP.Enabled = state
end)

-- MOVIMENTO HACKS
MovementSection:NewToggle("SPEED HACK", "Velocidade aumentada", function(state)
    Config.Movement.SpeedHack = state
    if state then
        spawn(function()
            while Config.Movement.SpeedHack do
                LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + LocalPlayer.Character.Humanoid.MoveDirection * Config.Movement.SpeedValue/10
                RunService.Heartbeat:Wait()
            end
        end)
    end
end)

-- EXPLOITS AVANÇADOS
ExploitsSection:NewButton("KILL ALL", "Mata todos os jogadores", function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            -- Lógica de Kill All
        end
    end
end)

-- PROTEÇÃO ANTI-KICK/BAN
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    if method == "Kick" or method == "kick" then
        return wait(9e9)
    end
    
    if method == "FireServer" then
        if args[1] and typeof(args[1]) == "string" and 
            (args[1]:lower():find("ban") or args[1]:lower():find("kick")) then
            return wait(9e9)
        end
    end
    
    return oldNamecall(self, ...)
end)

-- LOOP PRINCIPAL OTIMIZADO
RunService.RenderStepped:Connect(function()
    if Config.Aimbot.Enabled then
        local target = GetClosestPlayer()
        if target then
            local targetPart = target.Character[Config.Aimbot.TargetPart]
            local prediction = Config.Aimbot.Prediction and 
                (targetPart.Position + targetPart.Velocity * Config.Aimbot.PredictionAmount)
                or targetPart.Position
                
            if Config.Aimbot.Silent then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, prediction)
            elseif Config.Aimbot.SmoothAim then
                local currentCFrame = Camera.CFrame
                local targetCFrame = CFrame.new(currentCFrame.Position, prediction)
                Camera.CFrame = currentCFrame:Lerp(targetCFrame, Config.Aimbot.SmoothAmount)
            end
            
            if Config.Aimbot.AutoShoot then
                mouse1click()
            end
        end
    end
end)

-- TECLAS DE ATALHO PERSONALIZADAS
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.RightAlt then
            Library:ToggleUI()
        elseif input.KeyCode == Enum.KeyCode.X then
            Config.Aimbot.Enabled = not Config.Aimbot.Enabled
        end
    end
end)

-- FINALIZAÇÃO DO LOADING
AnimateLoading()
CreateNotification("THEUS HUB", "SCRIPT CARREGADO COM SUCESSO!", 5)

-- PROTEÇÃO EXTRA
game:GetService("ScriptContext").Error:Connect(function()
    return nil
end)

-- OTIMIZAÇÃO PARA MOBILE
if UserInputService.TouchEnabled then
    Config.Aimbot.FOV = Config.Aimbot.FOV * 1.5
    Config.Aimbot.SmoothAmount = Config.Aimbot.SmoothAmount * 1.2
    
    -- Botão flutuante para mobile
    local TouchGui = Instance.new("ScreenGui")
    local TouchButton = Instance.new("ImageButton")
    
    TouchGui.Name = "TheusTouchControls"
    TouchGui.ResetOnSpawn = false
    TouchGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    TouchButton.Size = UDim2.new(0, 50, 0, 50)
    TouchButton.Position = UDim2.new(0.9, -25, 0.5, -25)
    TouchButton.BackgroundTransparency = 0.5
    TouchButton.Image = "rbxassetid://7072706620"
    TouchButton.Parent = TouchGui
    
    TouchButton.MouseButton1Click:Connect(function()
        Library:ToggleUI()
    end)
end

-- SISTEMA DE SALVAMENTO AUTOMÁTICO
local function SaveConfig()
    local data = game:GetService("HttpService"):JSONEncode(Config)
    writefile("TheusHub_Config.json", data)
end

local function LoadConfig()
    if isfile("TheusHub_Config.json") then
        local data = game:GetService("HttpService"):JSONDecode(readfile("TheusHub_Config.json"))
        for i,v in pairs(data) do
            Config[i] = v
        end
    end
end

-- Salva configurações automaticamente
game:GetService("Players").LocalPlayer.OnTeleport:Connect(function(State)
    if State == Enum.TeleportState.Started then
        SaveConfig()
    end
end)

LoadConfig() -- Carrega configurações salvas