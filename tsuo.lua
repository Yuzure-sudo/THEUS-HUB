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

-- Configurações Avançadas
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
    HitboxExpander = false,
    HitboxSize = Vector3.new(10, 10, 10),
    AutoShoot = false,
    TriggerBot = false,
    PredictionLevel = 1,
    VisibilityCheck = true
}

-- Interface Mobile (Melhorada)
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

-- Função para criar botões estilizados
local function CreateToggleButton(name, position)
    local button = Instance.new("TextButton")
    button.Parent = Frame
    button.Position = position
    button.Size = UDim2.new(0.9, 0, 0, 35)
    button.AnchorPoint = Vector2.new(0.5, 0)
    button.Position = UDim2.new(0.5, 0, position, 0)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = name .. ": OFF"
    button.TextSize = 14
    button.Font = Enum.Font.GothamSemibold
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = button
    
    return button
end

-- Criando botões
AimbotToggle = CreateToggleButton("Aimbot", 0.15)
SilentAimToggle = CreateToggleButton("Silent Aim", 0.25)
ESPToggle = CreateToggleButton("ESP", 0.35)
WallbangToggle = CreateToggleButton("Wallbang", 0.45)
NoRecoilToggle = CreateToggleButton("No Recoil", 0.55)
RapidFireToggle = CreateToggleButton("Rapid Fire", 0.65)
SpeedHackToggle = CreateToggleButton("Speed Hack", 0.75)

-- Funções Avançadas
local function ModifyWeapon(weapon)
    if weapon and weapon:FindFirstChild("Configuration") then
        local config = weapon.Configuration
        
        if Settings.NoRecoil then
            for _, v in pairs(config:GetDescendants()) do
                if v.Name:match("Recoil") or v.Name:match("Spread") then
                    v.Value = 0
                end
            end
        end
        
        if Settings.RapidFire then
            for _, v in pairs(config:GetDescendants()) do
                if v.Name:match("FireRate") then
                    v.Value = 0.05
                end
            end
        end
        
        if Settings.InfiniteAmmo then
            for _, v in pairs(config:GetDescendants()) do
                if v.Name:match("Ammo") or v.Name:match("Magazine") then
                    v.Value = 9999
                end
            end
        end
    end
end

local function PredictPosition(player)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        return hrp.Position + (hrp.Velocity * Settings.PredictionLevel)
    end
    return nil
end

local function IsVisible(position)
    if not Settings.VisibilityCheck then return true end
    
    local ray = Ray.new(Camera.CFrame.Position, position - Camera.CFrame.Position)
    local hit, _ = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character})
    return hit == nil
end

local function GetClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = Settings.FOV
    local mousePos = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            if not (Settings.TeamCheck and player.Team == LocalPlayer.Team) then
                local predictedPos = PredictPosition(player)
                if predictedPos and IsVisible(predictedPos) then
                    local vector, onScreen = Camera:WorldToScreenPoint(predictedPos)
                    if onScreen then
                        local distance = (Vector2.new(vector.X, vector.Y) - mousePos).Magnitude
                        if distance < shortestDistance then
                            closestPlayer = player
                            shortestDistance = distance
                        end
                    end
                end
            end
        end
    end
    return closestPlayer
end

-- ESP Avançado
local function CreateAdvancedESP(player)
    local esp = Instance.new("BillboardGui")
    esp.Name = "ESP"
    esp.AlwaysOnTop = true
    esp.Size = UDim2.new(0, 200, 0, 50)
    esp.StudsOffset = Vector3.new(0, 2, 0)
    esp.Parent = player.Character.Head

    local name = Instance.new("TextLabel")
    name.BackgroundTransparency = 1
    name.Size = UDim2.new(1, 0, 0.5, 0)
    name.Text = player.Name
    name.TextColor3 = Color3.fromRGB(255, 255, 255)
    name.TextScaled = true
    name.Parent = esp

    local health = Instance.new("TextLabel")
    health.BackgroundTransparency = 1
    health.Position = UDim2.new(0, 0, 0.5, 0)
    health.Size = UDim2.new(1, 0, 0.5, 0)
    health.Text = "HP: " .. player.Character.Humanoid.Health
    health.TextColor3 = Color3.fromRGB(255, 0, 0)
    health.TextScaled = true
    health.Parent = esp
end

-- Event Handlers Melhorados
local function UpdateButton(button, setting)
    button.Text = button.Text:gsub(": .*", ": " .. (setting and "ON" or "OFF"))
    button.BackgroundColor3 = setting and Color3.fromRGB(60, 179, 113) or Color3.fromRGB(40, 40, 60)
end

AimbotToggle.MouseButton1Click:Connect(function()
    Settings.Aimbot = not Settings.Aimbot
    UpdateButton(AimbotToggle, Settings.Aimbot)
end)

SilentAimToggle.MouseButton1Click:Connect(function()
    Settings.SilentAim = not Settings.SilentAim
    UpdateButton(SilentAimToggle, Settings.SilentAim)
end)

ESPToggle.MouseButton1Click:Connect(function()
    Settings.ESP = not Settings.ESP
    UpdateButton(ESPToggle, Settings.ESP)
    
    if Settings.ESP then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                CreateAdvancedESP(player)
            end
        end
    else
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
                local esp = player.Character:FindFirstChild("ESP")
                if esp then esp:Destroy() end
            end
        end
    end
end)

WallbangToggle.MouseButton1Click:Connect(function()
    Settings.Wallbang = not Settings.Wallbang
    UpdateButton(WallbangToggle, Settings.Wallbang)
end)

NoRecoilToggle.MouseButton1Click:Connect(function()
    Settings.NoRecoil = not Settings.NoRecoil
    UpdateButton(NoRecoilToggle, Settings.NoRecoil)
end)

RapidFireToggle.MouseButton1Click:Connect(function()
    Settings.RapidFire = not Settings.RapidFire
    UpdateButton(RapidFireToggle, Settings.RapidFire)
end)

SpeedHackToggle.MouseButton1Click:Connect(function()
    Settings.SpeedHack = not Settings.SpeedHack
    UpdateButton(SpeedHackToggle, Settings.SpeedHack)
    
    if Settings.SpeedHack and LocalPlayer.Character then
        LocalPlayer.Character.Humanoid.WalkSpeed = 50
    else
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

-- Main Loop Melhorado
RunService.RenderStepped:Connect(function()
    if Settings.Aimbot then
        local target = GetClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            local targetPos = target.Character.Head.Position
            if Settings.SilentAim then
                -- Implementação do Silent Aim
                local oldPos = Camera.CFrame
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
                task.wait()
                Camera.CFrame = oldPos
            else
                -- Aimbot suave
                local targetCFrame = CFrame.new(Camera.CFrame.Position, targetPos)
                Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, Settings.AimbotSmoothing)
            end
        end
    end
    
    -- Atualizar ESP
    if Settings.ESP then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local esp = player.Character:FindFirstChild("ESP")
                if esp and esp:FindFirstChild("Health") then
                    esp.Health.Text = "HP: " .. math.floor(player.Character.Humanoid.Health)
                end
            end
        end
    end
end)

-- Hook de armas
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldNamecall = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    if method == "FireServer" then
        if Settings.NoRecoil or Settings.RapidFire then
            ModifyWeapon(LocalPlayer.Character:FindFirstChildOfClass("Tool"))
        end
    end
    
    return oldNamecall(self, ...)
end)

-- Anti-Kick (Use com cautela)
local OldNameCall = nil
OldNameCall = hookmetamethod(game, "__namecall", function(Self, ...)
    local Args = {...}
    local NamecallMethod = getnamecallmethod()
    
    if not checkcaller() and NamecallMethod == "Kick" then
        return nil
    end
    
    return OldNameCall(Self, ...)
end)