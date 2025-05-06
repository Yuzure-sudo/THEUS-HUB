local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Theus Hub - Raid", "Midnight")

-- Main
local Main = Window:NewTab("Main")
local MainSection = Main:NewSection("Raid Selection")

-- Variables
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Raid Types
local raidTypes = {
    "Flame",
    "Ice",
    "Quake",
    "Light",
    "Dark",
    "String",
    "Rumble",
    "Magma",
    "Human: Buddha",
    "Sand",
    "Bird: Phoenix",
    "Dough"
}

-- Dropdown for Raid Selection
local selectedRaid = "Flame"
MainSection:NewDropdown("Select Raid", "Choose your raid type", raidTypes, function(value)
    selectedRaid = value
end)

-- Auto Functions
MainSection:NewToggle("Auto Buy Chip", "Automatically buys raid chip", function(state)
    getgenv().AutoBuyChip = state
    while getgenv().AutoBuyChip do
        local args = {
            [1] = "RaidsNpc",
            [2] = "Select",
            [3] = selectedRaid
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
        wait(1)
    end
end)

MainSection:NewToggle("Auto Start Raid", "Automatically starts raid", function(state)
    getgenv().AutoStartRaid = state
    while getgenv().AutoStartRaid do
        if game:GetService("Players")["LocalPlayer"].PlayerGui.Main.Timer.Visible == false then
            local args = {
                [1] = "RaidsNpc",
                [2] = "Raid"
            }
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
        end
        wait(1)
    end
end)

-- Kill Aura with Advanced Features
local CombatSection = Main:NewSection("Combat")

local function GetClosestMob()
    local closestMob = nil
    local shortestDistance = math.huge
    
    for _, mob in pairs(workspace.Enemies:GetChildren()) do
        if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
            local distance = (HumanoidRootPart.Position - mob.HumanoidRootPart.Position).magnitude
            if distance < shortestDistance then
                closestMob = mob
                shortestDistance = distance
            end
        end
    end
    
    return closestMob
end

-- Enhanced Kill Aura
CombatSection:NewToggle("Kill Aura", "Advanced kill aura with multiple attack patterns", function(state)
    getgenv().KillAura = state
    while getgenv().KillAura do
        local mob = GetClosestMob()
        if mob then
            -- Dynamic positioning
            local randomOffset = Vector3.new(
                math.random(-2, 2),
                math.random(3, 5),
                math.random(-2, 2)
            )
            HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(randomOffset)
            
            -- Multi-hit system
            for i = 1, 3 do
                local args = {
                    [1] = mob.HumanoidRootPart.Position
                }
                local Tool = Character:FindFirstChildOfClass("Tool")
                if Tool and Tool:FindFirstChild("RemoteEvent") then
                    Tool.RemoteEvent:FireServer(unpack(args))
                end
                wait(0.1)
            end
        end
        wait(0.1)
    end
end)

-- Auto Next Island with Visual Feedback
local TeleportSection = Main:NewSection("Auto Island")

TeleportSection:NewToggle("Auto Next Island", "Automatically moves to next island with improved pathfinding", function(state)
    getgenv().AutoNextIsland = state
    while getgenv().AutoNextIsland do
        local islands = {"Island 5", "Island 4", "Island 3", "Island 2", "Island 1"}
        for _, island in ipairs(islands) do
            if game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild(island) then
                local islandCFrame = game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild(island).CFrame
                
                -- Smooth teleportation
                local steps = 10
                local startPos = HumanoidRootPart.Position
                local endPos = islandCFrame.Position
                
                for i = 1, steps do
                    local progress = i / steps
                    local newPos = startPos:Lerp(endPos, progress)
                    HumanoidRootPart.CFrame = CFrame.new(newPos)
                    wait(0.03)
                end
                
                break
            end
        end
        wait(1)
    end
end)

-- Settings Tab
local Settings = Window:NewTab("Settings")
local SettingsSection = Settings:NewSection("Configuration")

-- Kill Aura Settings
SettingsSection:NewSlider("Kill Aura Range", "Adjust the kill aura range", 100, 10, function(value)
    getgenv().KillAuraRange = value
end)

SettingsSection:NewSlider("Attack Speed", "Adjust attack speed", 10, 1, function(value)
    getgenv().AttackSpeed = value/10
end)

-- Auto Farm Height
SettingsSection:NewSlider("Farm Height", "Adjust farming height", 20, 1, function(value)
    getgenv().FarmHeight = value
end)

-- Misc Features
local Misc = Window:NewTab("Misc")
local MiscSection = Misc:NewSection("Extra Features")

MiscSection:NewToggle("Auto Collect Drops", "Automatically collects drops", function(state)
    getgenv().AutoCollect = state
    while getgenv().AutoCollect do
        for _, drop in pairs(workspace.Map:GetDescendants()) do
            if drop:IsA("TouchTransmitter") then
                firetouchinterest(HumanoidRootPart, drop.Parent, 0)
                firetouchinterest(HumanoidRootPart, drop.Parent, 1)
            end
        end
        wait(1)
    end
end)

-- Stats Display
local Stats = Window:NewTab("Stats")
local StatsSection = Stats:NewSection("Raid Information")

local function UpdateStats()
    while wait(1) do
        if game:GetService("Players")["LocalPlayer"].PlayerGui.Main.Timer.Visible then
            local timeLeft = game:GetService("Players")["LocalPlayer"].PlayerGui.Main.Timer.Text
            StatsSection:UpdateLabel("Time Left: " .. timeLeft)
        end
    end
end
coroutine.wrap(UpdateStats)()

-- Anti AFK and Protection
local VirtualUser = game:GetService('VirtualUser')
Players.LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Error Handling
local function SafeExecute(callback)
    local success, error = pcall(callback)
    if not success then
        warn("Error: " .. error)
    end
end

-- Initialize Protection
SafeExecute(function()
    -- Anti Cheat Bypass
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local old = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local args = {...}
        if getnamecallmethod() == "FireServer" then
            if tostring(self) == "Banned" then
                return
            end
        end
        return old(self, ...)
    end)
    setreadonly(mt, true)
end)