-- SCRIPT THEUS PREMIUM V5 [VERSÃO MALOQUEIRA]
-- SCRIPT FEITO PRA DESTRUIR GERAL MLK

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wally2"))()
local Window = Library:CreateWindow("THEUS PREMIUM - DESTRUIÇÃO TOTAL")

-- SERVIÇOS PRA DESTRUIR
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- CONFIGURAÇÃO PESADA
local Config = {
    Aimbot = {
        Enabled = false,
        Silent = true, -- MIRA INVISÍVEL PRA NINGUÉM TE PEGAR
        AutoWall = true, -- ATIRA ATRAVÉS DA PAREDE
        Prediction = true,
        HitChance = 100,
        HitPart = "Head",
        FOV = 500, -- FOV GIGANTE PRA PEGAR TODO MUNDO
        AutoShoot = true,
        WallCheck = false -- FODA-SE A PAREDE
    },
    
    ESP = {
        Enabled = false,
        ShowTeam = false, -- NÃO MOSTRA TIME PRA TU MATAR GERAL
        Boxes = true,
        Tracers = true,
        Names = true,
        Distance = true,
        Health = true,
        Chams = true,
        XRay = true -- VÊ ATRAVÉS DAS PAREDES
    }
}

-- INTERFACE CRIMINOSA
local MainTab = Window:CreateTab("DESTRUIÇÃO")
local VisualTab = Window:CreateTab("VISUAL")
local ExtraTab = Window:CreateTab("EXTRA")

-- AIMBOT DESTRUTIVO
MainTab:CreateToggle("AIMBOT DESTRUTIVO", function(state)
    Config.Aimbot.Enabled = state
    if state then
        CreateNotification("ATIVADO", "MODO DESTRUIÇÃO LIGADO", 3)
    end
end)

MainTab:CreateToggle("TIRO ATRAVÉS DA PAREDE", function(state)
    Config.Aimbot.AutoWall = state
end)

MainTab:CreateSlider("CHANCE DE ACERTO", 0, 100, 100, function(value)
    Config.Aimbot.HitChance = value
end)

-- ESP MALANDRO
VisualTab:CreateToggle("ESP MALOQUEIRO", function(state)
    Config.ESP.Enabled = state
end)

VisualTab:CreateToggle("RAIO-X", function(state)
    Config.ESP.XRay = state
    if state then
        for _,v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                v.LocalTransparencyModifier = 0.5
            end
        end
    end
end)

-- FUNÇÕES PESADAS
local function GetClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") 
        and player.Character.Humanoid.Health > 0 and player.Character:FindFirstChild(Config.Aimbot.HitPart) then
            
            local pos = Camera:WorldToViewportPoint(player.Character[Config.Aimbot.HitPart].Position)
            local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).magnitude
            
            if magnitude < shortestDistance then
                closestPlayer = player
                shortestDistance = magnitude
            end
        end
    end
    return closestPlayer
end

-- ESP SISTEMA MALANDRO
local function CreateESP(player)
    local ESP = {
        Box = Drawing.new("Square"),
        Tracer = Drawing.new("Line"),
        Name = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
        HealthBar = Drawing.new("Square")
    }
    
    RunService.RenderStepped:Connect(function()
        if Config.ESP.Enabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local Vector, OnScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            
            -- ATUALIZA ESP EM TEMPO REAL
            if OnScreen then
                -- Box ESP
                if Config.ESP.Boxes then
                    ESP.Box.Size = Vector2.new(2000 / Vector.Z, 2500 / Vector.Z)
                    ESP.Box.Position = Vector2.new(Vector.X - ESP.Box.Size.X / 2, Vector.Y - ESP.Box.Size.Y / 2)
                    ESP.Box.Visible = true
                    ESP.Box.Color = Color3.fromRGB(255, 0, 0)
                    ESP.Box.Thickness = 2
                end
                
                -- Tracer ESP
                if Config.ESP.Tracers then
                    ESP.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    ESP.Tracer.To = Vector2.new(Vector.X, Vector.Y)
                    ESP.Tracer.Visible = true
                    ESP.Tracer.Color = Color3.fromRGB(255, 0, 0)
                    ESP.Tracer.Thickness = 2
                end
            end
        end
    end)
end

-- LOOP PRINCIPAL DO SCRIPT
RunService.RenderStepped:Connect(function()
    if Config.Aimbot.Enabled then
        local target = GetClosestPlayer()
        if target then
            local targetPart = target.Character[Config.Aimbot.HitPart]
            local prediction = Config.Aimbot.Prediction and 
                (targetPart.Position + targetPart.Velocity * 0.165)
                or targetPart.Position
                
            if Config.Aimbot.Silent then
                -- AIMBOT SILENCIOSO PRA NINGUÉM PERCEBER
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, prediction)
            end
            
            if Config.Aimbot.AutoShoot then
                mouse1click()
            end
        end
    end
end)

-- NOTIFICAÇÃO BRABÍSSIMA
game.StarterGui:SetCore("SendNotification", {
    Title = "SCRIPT ATIVADO",
    Text = "MODO DESTRUIÇÃO TOTAL LIBERADO",
    Duration = 5
})

-- PROTEÇÃO CONTRA DETECÇÃO
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(...)
    local args = {...}
    if getnamecallmethod() == "FireServer" and args[1] == "RemoteEvent" then
        return wait(9e9)
    end
    return old(...)
end)

-- EXTRAS DESTRUTIVOS
ExtraTab:CreateButton("CRASH SERVER", function()
    while true do
        spawn(function()
            while true do end
        end)
    end
end)

ExtraTab:CreateButton("REMOVER ANTI-CHEAT", function()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("LocalScript") and v.Name:lower():match("anti") then
            v:Destroy()
        end
    end
end)

-- TECLAS DE ATALHO PRA DESTRUIR MAIS RÁPIDO
local function BindKey(key, func)
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == key then
            func()
        end
    end)
end

BindKey(Enum.KeyCode.X, function()
    Config.Aimbot.Enabled = not Config.Aimbot.Enabled
end)

BindKey(Enum.KeyCode.C, function()
    Config.ESP.Enabled = not Config.ESP.Enabled
end)

-- PROTEÇÃO EXTRA PRA NÃO SER PEGO
game:GetService("ScriptContext").Error:Connect(function()
    return nil
end)