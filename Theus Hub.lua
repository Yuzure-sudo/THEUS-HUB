local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/VisualUILibrary"))()

local Window = Library:CreateWindow("Theus Hub - Raid", "Mobile & PC", "All Raids")

-- Variables
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")

-- Settings (Configuráveis)
_G.Settings = {
    AutoRaid = false,
    AutoBuyChip = false,
    KillAura = false,
    AutoNextIsland = false,
    AutoCollectDrops = false,
    SelectedRaid = "Flame",
    KillAuraRange = 50,
    AttackSpeed = 0.1,
    FarmHeight = 5,
    AutoAbility = false,
    FastAttack = false
}

-- Funções Utilitárias
local function SaveSettings()
    local json = game:GetService("HttpService"):JSONEncode(_G.Settings)
    writefile("TheusHubRaid.json", json)
end

local function LoadSettings()
    if isfile("TheusHubRaid.json") then
        local json = readfile("TheusHubRaid.json")
        _G.Settings = game:GetService("HttpService"):JSONDecode(json)
    end
end

-- Kill Aura Aprimorado
local function GetClosestMob()
    local closest = nil
    local maxDistance = _G.Settings.KillAuraRange
    
    for _, mob in pairs(workspace.Enemies:GetChildren()) do
        if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
            local distance = (HumanoidRootPart.Position - mob.HumanoidRootPart.Position).magnitude
            if distance < maxDistance then
                closest = mob
                maxDistance = distance
            end
        end
    end
    return closest
end

local function Attack(mob)
    if mob and mob:FindFirstChild("HumanoidRootPart") then
        local args = {
            [1] = mob.HumanoidRootPart.Position
        }
        
        -- Multi-hit system
        for i = 1, 3 do
            local Tool = Character:FindFirstChildOfClass("Tool")
            if Tool and Tool:FindFirstChild("RemoteEvent") then
                Tool.RemoteEvent:FireServer(unpack(args))
            end
            
            -- Melee combat
            if Tool and Tool:FindFirstChild("Handle") then
                Tool:Activate()
            end
            
            -- Use abilities
            if _G.Settings.AutoAbility then
                local VirtualInputManager = game:GetService('VirtualInputManager')
                local keys = {'Z', 'X', 'C', 'V', 'F'}
                for _, key in ipairs(keys) do
                    VirtualInputManager:SendKeyEvent(true, key, false, game)
                    wait(0.1)
                    VirtualInputManager:SendKeyEvent(false, key, false, game)
                end
            end
            
            wait(_G.Settings.AttackSpeed)
        end
    end
end

-- Interface Principal
local Main = Window:CreateTab("Main")

-- Raid Selection
local RaidTypes = {"Flame", "Ice", "Quake", "Light", "Dark", "String", "Rumble", "Magma", "Human: Buddha", "Sand", "Bird: Phoenix", "Dough"}
Main:CreateDropdown("Select Raid", RaidTypes, function(value)
    _G.Settings.SelectedRaid = value
    SaveSettings()
end)

-- Toggles
Main:CreateToggle("Auto Buy Chip", function(value)
    _G.Settings.AutoBuyChip = value
    SaveSettings()
    
    while _G.Settings.AutoBuyChip do
        pcall(function()
            local args = {
                [1] = "RaidsNpc",
                [2] = "Select",
                [3] = _G.Settings.SelectedRaid
            }
            ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(args))
        end)
        wait(1)
    end
end)

Main:CreateToggle("Auto Start Raid", function(value)
    _G.Settings.AutoRaid = value
    SaveSettings()
    
    while _G.Settings.AutoRaid do
        pcall(function()
            if not LocalPlayer.PlayerGui.Main.Timer.Visible then
                local args = {
                    [1] = "RaidsNpc",
                    [2] = "Raid"
                }
                ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(args))
            end
        end)
        wait(1)
    end
end)

Main:CreateToggle("Kill Aura", function(value)
    _G.Settings.KillAura = value
    SaveSettings()
    
    while _G.Settings.KillAura do
        pcall(function()
            local mob = GetClosestMob()
            if mob then
                -- Smooth movement to mob
                local targetCFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, _G.Settings.FarmHeight, 0)
                local tween = TweenService:Create(HumanoidRootPart, 
                    TweenInfo.new(0.3, Enum.EasingStyle.Linear), 
                    {CFrame = targetCFrame}
                )
                tween:Play()
                tween.Completed:Wait()
                
                Attack(mob)
            end
        end)
        wait(_G.Settings.AttackSpeed)
    end
end)

Main:CreateToggle("Auto Next Island", function(value)
    _G.Settings.AutoNextIsland = value
    SaveSettings()
    
    while _G.Settings.AutoNextIsland do
        pcall(function()
            local islands = {"Island 5", "Island 4", "Island 3", "Island 2", "Island 1"}
            for _, island in ipairs(islands) do
                if workspace["_WorldOrigin"].Locations:FindFirstChild(island) then
                    local targetCFrame = workspace["_WorldOrigin"].Locations[island].CFrame
                    local tween = TweenService:Create(HumanoidRootPart,
                        TweenInfo.new(1, Enum.EasingStyle.Linear),
                        {CFrame = targetCFrame}
                    )
                    tween:Play()
                    tween.Completed:Wait()
                    break
                end
            end
        end)
        wait(1)
    end
end)

-- Combat Tab
local Combat = Window:CreateTab("Combat")

Combat:CreateToggle("Fast Attack", function(value)
    _G.Settings.FastAttack = value
    SaveSettings()
end)

Combat:CreateToggle("Auto Abilities", function(value)
    _G.Settings.AutoAbility = value
    SaveSettings()
end)

Combat:CreateSlider("Kill Aura Range", 10, 100, _G.Settings.KillAuraRange, function(value)
    _G.Settings.KillAuraRange = value
    SaveSettings()
end)

Combat:CreateSlider("Attack Speed", 1, 10, _G.Settings.AttackSpeed * 10, function(value)
    _G.Settings.AttackSpeed = value/10
    SaveSettings()
end)

-- Misc Tab
local Misc = Window:CreateTab("Misc")

Misc:CreateToggle("Auto Collect Drops", function(value)
    _G.Settings.AutoCollectDrops = value
    SaveSettings()
    
    while _G.Settings.AutoCollectDrops do
        pcall(function()
            for _, drop in pairs(workspace:GetDescendants()) do
                if drop:IsA("TouchTransmitter") then
                    firetouchinterest(HumanoidRootPart, drop.Parent, 0)
                    firetouchinterest(HumanoidRootPart, drop.Parent, 1)
                end
            end
        end)
        wait(1)
    end
end)

-- Settings Tab
local Settings = Window:CreateTab("Settings")

Settings:CreateButton("Save Settings", function()
    SaveSettings()
end)

Settings:CreateButton("Load Settings", function()
    LoadSettings()
end)

-- Mobile Support
local Mobile = Window:CreateTab("Mobile")

Mobile:CreateButton("Hide/Show UI", function()
    if game:GetService("CoreGui").VisualUILibrary.Main.Visible then
        game:GetService("CoreGui").VisualUILibrary.Main.Visible = false
    else
        game:GetService("CoreGui").VisualUILibrary.Main.Visible = true
    end
end)

-- Anti AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Error Protection
local function SafeExecute(callback)
    pcall(callback)
end

-- Initialize
LoadSettings()

-- Fast Attack Implementation
local CombatFramework = require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework)
local CombatFrameworkR = getupvalues(CombatFramework)[2]
local CameraShakerR = require(game.ReplicatedStorage.Util.CameraShaker)
CameraShakerR:Stop()

spawn(function()
    while true do
        if _G.Settings.FastAttack then
            pcall(function()
                CombatFrameworkR.activeController.timeToNextAttack = 0
                CombatFrameworkR.activeController.attacking = false
                CombatFrameworkR.activeController.increment = 3
                CombatFrameworkR.activeController.hitboxMagnitude = 100
            end)
        end
        task.wait()
    end
end)

-- Notification System
local function Notify(title, text, duration)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration or 3
    })
end

-- Level Check
if LocalPlayer.Data.Level.Value < 1100 then
    Notify("Warning", "Required Level: 1100+", 5)
end

-- Auto Rejoin on Kick
game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
    if child.Name == 'ErrorPrompt' then
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
    end
end)