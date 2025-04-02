local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("THEUS PREMIUM", "Ocean")

-- MAIN
local Main = Window:NewTab("Main")
local MainSection = Main:NewSection("Main")

MainSection:NewToggle("Auto Farm", "Liga/Desliga Auto Farm", function(state)
    getgenv().AutoFarm = state
    while getgenv().AutoFarm do
        -- Código do Auto Farm aqui
        wait()
    end
end)

MainSection:NewToggle("Auto Skills", "Liga/Desliga Auto Skills", function(state)
    getgenv().AutoSkills = state
    while getgenv().AutoSkills do
        -- Código do Auto Skills aqui
        wait()
    end
end)

-- FARM
local Farm = Window:NewTab("Farm")
local FarmSection = Farm:NewSection("Farm")

FarmSection:NewToggle("Auto Boss", "Liga/Desliga Auto Boss", function(state)
    getgenv().AutoBoss = state
    while getgenv().AutoBoss do
        -- Código do Auto Boss aqui
        wait()
    end
end)

FarmSection:NewToggle("Auto Chest", "Liga/Desliga Auto Chest", function(state)
    getgenv().AutoChest = state
    while getgenv().AutoChest do
        -- Código do Auto Chest aqui
        wait()
    end
end)

-- STATS
local Stats = Window:NewTab("Stats")
local StatsSection = Stats:NewSection("Stats")

StatsSection:NewDropdown("Select Stat", "Selecione o stat para upar", {"Melee", "Defense", "Sword", "Devil Fruit"}, function(currentOption)
    getgenv().SelectedStat = currentOption
end)

StatsSection:NewToggle("Auto Stats", "Liga/Desliga Auto Stats", function(state)
    getgenv().AutoStats = state
    while getgenv().AutoStats do
        -- Código do Auto Stats aqui
        wait()
    end
end)

-- TELEPORT
local Teleport = Window:NewTab("Teleport")
local TeleportSection = Teleport:NewSection("Teleport")

TeleportSection:NewDropdown("Select Island", "Selecione a ilha", {
    "Starter Island",
    "Marine Island",
    "Desert Island",
    "Shark Island",
    "Snow Island",
    "Sky Island"
}, function(currentOption)
    -- Código do teleporte aqui
end)

-- MISC
local Misc = Window:NewTab("Misc")
local MiscSection = Misc:NewSection("Misc")

MiscSection:NewToggle("Speed Hack", "Liga/Desliga Speed Hack", function(state)
    getgenv().SpeedHack = state
    while getgenv().SpeedHack do
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100
        wait()
    end
end)

MiscSection:NewToggle("Jump Hack", "Liga/Desliga Jump Hack", function(state)
    getgenv().JumpHack = state
    while getgenv().JumpHack do
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = 100
        wait()
    end
end)

MiscSection:NewButton("Server Hop", "Troca de servidor", function()
    local TeleportService = game:GetService("TeleportService")
    local PlaceId = game.PlaceId
    local Player = game.Players.LocalPlayer
    
    local Servers = {}
    local req = game:HttpGet("https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
    local data = game:GetService("HttpService"):JSONDecode(req)
    
    for i,v in pairs(data.data) do
        if v.playing ~= v.maxPlayers then
            table.insert(Servers, v.id)
        end
    end
    
    if #Servers > 0 then
        TeleportService:TeleportToPlaceInstance(PlaceId, Servers[math.random(1, #Servers)])
    end
end)

-- CONFIG
local Config = Window:NewTab("Config")
local ConfigSection = Config:NewSection("Config")

ConfigSection:NewKeybind("Toggle UI", "Tecla para mostrar/esconder UI", Enum.KeyCode.RightControl, function()
    Library:ToggleUI()
end)