local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

-- GUI Mobile
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local AimbotToggle = Instance.new("TextButton")
local ESPToggle = Instance.new("TextButton")
local FOVSlider = Instance.new("TextButton")
local FOVValue = Instance.new("TextLabel")
local SilentAimToggle = Instance.new("TextButton")
local WallbangToggle = Instance.new("TextButton")
local NoRecoilToggle = Instance.new("TextButton")
local InfiniteAmmoToggle = Instance.new("TextButton")
local RapidFireToggle = Instance.new("TextButton")
local SpeedHackToggle = Instance.new("TextButton")

-- Configurações
local Settings = {
    Aimbot = false,
    ESP = false,
    FOV = 100,
    TeamCheck = true,
    SilentAim = false,
    Wallbang = false,
    NoRecoil = false,
    InfiniteAmmo = false,
    RapidFire = false,
    SpeedHack = false,
    AimbotSmoothing = 0.5,
    AutoShoot = false,
    TriggerBot = false
}

-- Interface Mobile
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Frame.Position = UDim2.new(0.8, 0, 0.2, 0)
Frame.Size = UDim2.new(0, 200, 0, 400)
Frame.Active = true
Frame.Draggable = true

UICorner.Parent = Frame
UICorner.CornerRadius = UDim.new(0, 15)

Title.Parent = Frame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "Theus Aimbot"
Title.TextColor3 = Color3.fromRGB(255, 100, 100)
Title.TextSize = 22
Title.Font = Enum.Font.GothamBold

-- Função para criar botões
local function CreateToggleButton(name, position)
    local button = Instance.new("TextButton")
    button.Parent = Frame
    button.Position = position
    button.Size = UDim2.new(0.9, 0, 0, 35)
    button.AnchorPoint = Vector2.new(0.5, 0)
    button.Position = UDim2.new(0.5, 0, position, 0)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = name .. ": DESLIGADO"
    button.TextSize = 14
    button.Font = Enum.Font.GothamSemibold
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = button
    
    return button
end

-- Criando botões em português
AimbotToggle = CreateToggleButton("Mira Automática", 0.15)
SilentAimToggle = CreateToggleButton("Mira Silenciosa", 0.25)
ESPToggle = CreateToggleButton("Visão Raio-X", 0.35)
WallbangToggle = CreateToggleButton("Tiro Atravessa Parede", 0.45)
NoRecoilToggle = CreateToggleButton("Sem Recuo", 0.55)
RapidFireToggle = CreateToggleButton("Tiro Rápido", 0.65)
SpeedHackToggle = CreateToggleButton("Velocidade", 0.75)

-- Função para atualizar os botões
local function UpdateButton(button, setting)
    button.Text = button.Text:gsub(": .*", ": " .. (setting and "LIGADO" or "DESLIGADO"))
    button.BackgroundColor3 = setting and Color3.fromRGB(60, 179, 113) or Color3.fromRGB(40, 40, 60)
end

-- Event Handlers
AimbotToggle.MouseButton1Click:Connect(function()
    Settings.Aimbot = not Settings.Aimbot
    UpdateButton(AimbotToggle, Settings.Aimbot)
    
    if Settings.Aimbot then
        -- Ativar Aimbot
        local function aimbot()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character.Humanoid.Health > 0 then
                local closest = nil
                local maxDist = Settings.FOV
                local mousePos = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
                
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                        local pos = Camera:WorldToScreenPoint(player.Character.Head.Position)
                        local dist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                        if dist < maxDist then
                            closest = player.Character.Head
                            maxDist = dist
                        end
                    end
                end
                
                if closest then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, closest.Position)
                end
            end
        end
        
        RunService:BindToRenderStep("Aimbot", 1, aimbot)
    else
        RunService:UnbindFromRenderStep("Aimbot")
    end
end)

SilentAimToggle.MouseButton1Click:Connect(function()
    Settings.SilentAim = not Settings.SilentAim
    UpdateButton(SilentAimToggle, Settings.SilentAim)
    
    if Settings.SilentAim then
        -- Implementar Silent Aim
        local oldNameCall = nil
        oldNameCall = hookmetamethod(game, "__namecall", function(self, ...)
            local args = {...}
            local method = getnamecallmethod()
            
            if method == "FindPartOnRayWithIgnoreList" and Settings.SilentAim then
                local closest = nil
                local maxDist = Settings.FOV
                local mousePos = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
                
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                        local pos = Camera:WorldToScreenPoint(player.Character.Head.Position)
                        local dist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                        if dist < maxDist then
                            closest = player.Character.Head
                            maxDist = dist
                        end
                    end
                end
                
                if closest then
                    args[1] = Ray.new(Camera.CFrame.Position, (closest.Position - Camera.CFrame.Position).Unit * 1000)
                end
            end
            
            return oldNameCall(self, unpack(args))
        end)
    end
end)

ESPToggle.MouseButton1Click:Connect(function()
    Settings.ESP = not Settings.ESP
    UpdateButton(ESPToggle, Settings.ESP)
    
    if Settings.ESP then
        -- Implementar ESP
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local highlight = Instance.new("Highlight")
                highlight.Name = "ESP_Highlight"
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0
                highlight.Parent = player.Character
            end
        end
    else
        -- Remover ESP
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
                local highlight = player.Character:FindFirstChild("ESP_Highlight")
                if highlight then
                    highlight:Destroy()
                end
            end
        end
    end
end)

NoRecoilToggle.MouseButton1Click:Connect(function()
    Settings.NoRecoil = not Settings.NoRecoil
    UpdateButton(NoRecoilToggle, Settings.NoRecoil)
    
    if Settings.NoRecoil then
        -- Implementar No Recoil
        local mt = getrawmetatable(game)
        setreadonly(mt, false)
        local oldIndex = mt.__index
        
        mt.__index = newcclosure(function(self, k)
            if k == "Recoil" or k == "Spread" then
                return 0
            end
            return oldIndex(self, k)
        end)
    end
end)

RapidFireToggle.MouseButton1Click:Connect(function()
    Settings.RapidFire = not Settings.RapidFire
    UpdateButton(RapidFireToggle, Settings.RapidFire)
    
    if Settings.RapidFire then
        -- Implementar Rapid Fire
        local mt = getrawmetatable(game)
        setreadonly(mt, false)
        local oldIndex = mt.__index
        
        mt.__index = newcclosure(function(self, k)
            if k == "FireRate" then
                return 0.01
            end
            return oldIndex(self, k)
        end)
    end
end)

SpeedHackToggle.MouseButton1Click:Connect(function()
    Settings.SpeedHack = not Settings.SpeedHack
    UpdateButton(SpeedHackToggle, Settings.SpeedHack)
    
    if Settings.SpeedHack then
        -- Implementar Speed Hack
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 50
        end
    else
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end
end)

-- Proteção Anti-Kick
local oldNameCall = nil
oldNameCall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if method == "Kick" then
        return nil
    end
    return oldNameCall(self, ...)
end)

-- Atualização contínua
RunService.RenderStepped:Connect(function()
    if Settings.ESP then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local highlight = player.Character:FindFirstChild("ESP_Highlight")
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "ESP_Highlight"
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.5
                    highlight.OutlineTransparency = 0
                    highlight.Parent = player.Character
                end
            end
        end
    end
end)

-- Proteção adicional contra detecção
local function protectScript()
    local env = getfenv(2)
    local protected = {
        ["print"] = function() end,
        ["warn"] = function() end,
        ["error"] = function() end
    }
    setmetatable(protected, {__index = env})
    setfenv(2, protected)
end

protectScript()