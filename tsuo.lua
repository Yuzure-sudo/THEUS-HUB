-- THEUS HUB [DESTRUIÇÃO TOTAL]
-- SISTEMA COMPLETO PRA DOMINAR QUALQUER JOGO MLK

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wally2"))()
local Window = Library:CreateWindow("THEUS HUB - DOMINAÇÃO TOTAL")

-- SERVIÇOS E OTIMIZAÇÃO
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- CONFIGS PESADAS
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
        NearestPoint = true
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
            DirectionArrow = true
        },
        
        World = {
            FullBright = false,
            NoFog = false,
            ThirdPerson = false,
            FOVChanger = false,
            CustomSky = false,
            AmbientColor = false,
            NoShadows = false,
            BetterGraphics = false
        }
    },
    
    Combat = {
        InfiniteAmmo = false,
        NoRecoil = false,
        NoSpread = false,
        RapidFire = false,
        AutoReload = false,
        OneShot = false,
        GunMods = false,
        HeadshotOnly = false
    },
    
    Movement = {
        SpeedHack = false,
        SpeedValue = 100,
        JumpPower = false,
        JumpValue = 100,
        InfiniteJump = false,
        BunnyHop = false,
        NoClip = false,
        Flight = false,
        FlightSpeed = 50,
        AutoJump = false
    },
    
    Exploits = {
        GodMode = false,
        AntiAim = false,
        NoFallDamage = false,
        NoStun = false,
        InstantRespawn = false,
        AntiKick = false,
        AntiBan = false,
        AntiReport = false
    }
}

-- INTERFACE CRIMINOSA
local CombatTab = Window:NewTab("COMBATE")
local VisualsTab = Window:NewTab("VISUAL")
local MovementTab = Window:NewTab("MOVIMENTO")
local ExploitsTab = Window:NewTab("EXPLOITS")
local SettingsTab = Window:NewTab("CONFIG")

-- SEÇÕES
local AimbotSection = CombatTab:NewSection("AIMBOT DESTRUTIVO")
local WeaponSection = CombatTab:NewSection("MODIFICAÇÃO DE ARMAS")
local ESPSection = VisualsTab:NewSection("ESP MALANDRO")
local WorldSection = VisualsTab:NewSection("MUNDO")
local MovementSection = MovementTab:NewSection("MOVIMENTO")
local ExploitsSection = ExploitsTab:NewSection("EXPLOITS")
local SettingsSection = SettingsTab:NewSection("CONFIGURAÇÕES")

-- FUNÇÕES PRINCIPAIS
local function GetClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") 
        and player.Character.Humanoid.Health > 0 and player.Character:FindFirstChild(Config.Aimbot.TargetPart) then
            
            if Config.Aimbot.TeamCheck and player.Team == LocalPlayer.Team then continue end
            
            local pos = Camera:WorldToViewportPoint(player.Character[Config.Aimbot.TargetPart].Position)
            local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).magnitude
            
            if magnitude < shortestDistance and magnitude <= Config.Aimbot.FOV then
                if Config.Aimbot.VisibilityCheck then
                    local ray = Ray.new(Camera.CFrame.Position, (player.Character[Config.Aimbot.TargetPart].Position - Camera.CFrame.Position).unit * 2000)
                    local hit = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character, Camera})
                    if hit and hit:IsDescendantOf(player.Character) then
                        closestPlayer = player
                        shortestDistance = magnitude
                    end
                else
                    closestPlayer = player
                    shortestDistance = magnitude
                end
            end
        end
    end
    return closestPlayer
end

-- AIMBOT SISTEMA
AimbotSection:NewToggle("AIMBOT", "", function(state)
    Config.Aimbot.Enabled = state
end)

AimbotSection:NewToggle("TIRO SILENCIOSO", "", function(state)
    Config.Aimbot.Silent = state
end)

AimbotSection:NewToggle("TIRO ATRAVÉS DA PAREDE", "", function(state)
    Config.Aimbot.WallBang = state
end)

AimbotSection:NewToggle("MORTE INSTANTÂNEA", "", function(state)
    Config.Aimbot.InstantKill = state
end)

AimbotSection:NewSlider("FOV", "", 1000, 10, function(value)
    Config.Aimbot.FOV = value
end)

-- MODIFICAÇÃO DE ARMAS
WeaponSection:NewToggle("MUNIÇÃO INFINITA", "", function(state)
    Config.Combat.InfiniteAmmo = state
end)

WeaponSection:NewToggle("SEM RECUO", "", function(state)
    Config.Combat.NoRecoil = state
end)

WeaponSection:NewToggle("TIRO RÁPIDO", "", function(state)
    Config.Combat.RapidFire = state
end)

-- ESP SISTEMA
ESPSection:NewToggle("ESP", "", function(state)
    Config.Visuals.ESP.Enabled = state
end)

ESPSection:NewToggle("CAIXAS", "", function(state)
    Config.Visuals.ESP.Boxes = state
end)

ESPSection:NewToggle("TRAÇOS", "", function(state)
    Config.Visuals.ESP.Tracers = state
end)

-- MOVIMENTO
MovementSection:NewToggle("SPEED HACK", "", function(state)
    Config.Movement.SpeedHack = state
end)

MovementSection:NewToggle("PULO INFINITO", "", function(state)
    Config.Movement.InfiniteJump = state
end)

MovementSection:NewToggle("VOAR", "", function(state)
    Config.Movement.Flight = state
end)

-- EXPLOITS
ExploitsSection:NewToggle("MODO DEUS", "", function(state)
    Config.Exploits.GodMode = state
end)

ExploitsSection:NewToggle("ANTI KICK", "", function(state)
    Config.Exploits.AntiKick = state
end)

-- PROTEÇÃO CONTRA DETECÇÃO
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(...)
    local args = {...}
    local method = getnamecallmethod()
    
    if method == "FireServer" then
        if args[1].Name:match("Anti") or args[1].Name:match("Detection") then
            return wait(9e9)
        end
    end
    
    return old(...)
end)

-- LOOP PRINCIPAL
RunService.RenderStepped:Connect(function()
    if Config.Aimbot.Enabled then
        local target = GetClosestPlayer()
        if target then
            local targetPart = target.Character[Config.Aimbot.TargetPart]
            local prediction = Config.Aimbot.Prediction and 
                (targetPart.Position + targetPart.Velocity * 0.165)
                or targetPart.Position
                
            if Config.Aimbot.Silent then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, prediction)
            end
            
            if Config.Aimbot.AutoShoot then
                mouse1click()
            end
        end
    end
end)

-- NOTIFICAÇÃO
game.StarterGui:SetCore("SendNotification", {
    Title = "THEUS HUB CARREGADO",
    Text = "PRONTO PRA DESTRUIR TUDO MLK!",
    Duration = 5
})

-- TECLAS DE ATALHO
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightAlt then
        Library:ToggleUI()
    end
end)

-- PROTEÇÃO EXTRA
game:GetService("ScriptContext").Error:Connect(function()
    return nil
end)

-- ANTI KICK/BAN
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    if method == "Kick" or method == "kick" then
        return wait(9e9)
    end
    
    return oldNamecall(self, ...)
end)