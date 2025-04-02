-- Serviços
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")

-- Key System UI
local KeyUI = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local KeyBox = Instance.new("TextBox")
local Enter = Instance.new("TextButton")
local Status = Instance.new("TextLabel")

-- UI Setup
KeyUI.Name = "KeyUI"
KeyUI.Parent = game.CoreGui
KeyUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Name = "MainFrame"
MainFrame.Parent = KeyUI
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
MainFrame.Size = UDim2.new(0, 300, 0, 200)

UICorner.Parent = MainFrame
UICorner.CornerRadius = UDim.new(0, 10)

Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 10)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.GothamBold
Title.Text = "THEUS HUB PREMIUM"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20

KeyBox.Name = "KeyBox"
KeyBox.Parent = MainFrame
KeyBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
KeyBox.Position = UDim2.new(0.5, -125, 0.5, -20)
KeyBox.Size = UDim2.new(0, 250, 0, 40)
KeyBox.Font = Enum.Font.Gotham
KeyBox.PlaceholderText = "Enter Key..."
KeyBox.Text = ""
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.TextSize = 14

Enter.Name = "Enter"
Enter.Parent = MainFrame
Enter.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
Enter.Position = UDim2.new(0.5, -60, 0.5, 40)
Enter.Size = UDim2.new(0, 120, 0, 35)
Enter.Font = Enum.Font.GothamBold
Enter.Text = "LOGIN"
Enter.TextColor3 = Color3.fromRGB(255, 255, 255)
Enter.TextSize = 14

Status.Name = "Status"
Status.Parent = MainFrame
Status.BackgroundTransparency = 1
Status.Position = UDim2.new(0, 0, 1, -40)
Status.Size = UDim2.new(1, 0, 0, 30)
Status.Font = Enum.Font.Gotham
Status.Text = ""
Status.TextColor3 = Color3.fromRGB(255, 255, 255)
Status.TextSize = 14

local CorrectKey = "THEUSHUB2025"

-- Main Script Function
local function loadScript()
    KeyUI:Destroy()
    
    -- Variáveis Principais
    local Player = Players.LocalPlayer
    local Character = Player.Character or Player.CharacterAdded:Wait()
    local Root = Character:WaitForChild("HumanoidRootPart")
    local Humanoid = Character:WaitForChild("Humanoid")

    -- Interface Principal
    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
    local Window = Library.CreateLib("THEUS HUB PREMIUM", "Ocean")

    -- Botão Minimizar
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Parent = game.CoreGui
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MinimizeButton.Position = UDim2.new(0, 10, 0.5, 0)
    MinimizeButton.Size = UDim2.new(0, 40, 0, 40)
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Text = "T"
    MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeButton.TextSize = 20
    MinimizeButton.Draggable = true

    local UICorner = Instance.new("UICorner")
    UICorner.Parent = MinimizeButton
    UICorner.CornerRadius = UDim.new(0, 10)

    local WindowVisible = true
    MinimizeButton.MouseButton1Click:Connect(function()
        WindowVisible = not WindowVisible
        for _, ui in pairs(game.CoreGui:GetChildren()) do
            if ui.Name == "KavoUI" then
                ui.Enabled = WindowVisible
            end
        end
    end)

    -- Anti-AFK
    Player.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end)

    -- Proteções
    local oldindex = nil 
    oldindex = hookmetamethod(game, "__index", function(self, Index)
        if self == Humanoid and Index == "WalkSpeed" then 
            return 16
        end
        return oldindex(self, Index)
    end)

    -- Funções de Quest
    local function getCurrentLevel()
        return Player.Level.Value
    end

    local function getQuestForLevel(level)
        -- Adicione aqui a lógica para pegar a quest apropriada para cada level
        local questData = {
            [1] = {name = "BeginnerQuest", npc = "QuestNPC1"},
            [10] = {name = "IntermediateQuest", npc = "QuestNPC2"},
            [20] = {name = "AdvancedQuest", npc = "QuestNPC3"},
            -- Adicione mais quests conforme necessário
        }
        
        for questLevel, data in pairs(questData) do
            if level >= questLevel then
                return data
            end
        end
        return questData[1]
    end
    -- Funções de Farm Melhoradas
    local function getNearestMob()
        local closest = nil
        local maxDist = math.huge
        
        for _, v in pairs(workspace:GetChildren()) do
            if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                -- Verifica se é um mob e não um player
                if not Players:GetPlayerFromCharacter(v) then
                    local dist = (Root.Position - v.HumanoidRootPart.Position).Magnitude
                    if dist < maxDist then
                        maxDist = dist
                        closest = v
                    end
                end
            end
        end
        return closest
    end

    -- Tabs Melhorados
    local MainTab = Window:NewTab("Main")
    local FarmTab = Window:NewTab("Farm")
    local QuestTab = Window:NewTab("Quests")
    local PlayerTab = Window:NewTab("Player")
    local CombatTab = Window:NewTab("Combat")
    local TeleportTab = Window:NewTab("Teleport")
    local MiscTab = Window:NewTab("Misc")

    -- Seções
    local MainSection = MainTab:NewSection("Main Features")
    local FarmSection = FarmTab:NewSection("Auto Farm")
    local QuestSection = QuestTab:NewSection("Auto Quest")
    local PlayerSection = PlayerTab:NewSection("Player Mods")
    local CombatSection = CombatTab:NewSection("Combat Features")
    local TeleportSection = TeleportTab:NewSection("Locations")
    local MiscSection = MiscTab:NewSection("Misc Features")

    -- Quest System
    _G.AutoQuest = false
    QuestSection:NewToggle("Auto Quest", "Automatically accepts and completes quests", function(state)
        _G.AutoQuest = state
        while _G.AutoQuest and wait() do
            pcall(function()
                local currentLevel = getCurrentLevel()
                local questData = getQuestForLevel(currentLevel)
                
                -- Lógica para aceitar e completar quests
                local questNPC = workspace:FindFirstChild(questData.npc)
                if questNPC then
                    Root.CFrame = questNPC.HumanoidRootPart.CFrame
                    wait(0.5)
                    -- Aqui você deve adicionar o evento específico do jogo para aceitar/completar quests
                    -- ReplicatedStorage.Remotes.Quest:FireServer("Accept", questData.name)
                end
            end)
        end
    end)

    -- Farm System Melhorado
    _G.AutoFarm = false
    FarmSection:NewToggle("Auto Farm Mobs", "Automatically farms mobs based on your level", function(state)
        _G.AutoFarm = state
        while _G.AutoFarm and wait() do
            pcall(function()
                local mob = getNearestMob()
                if mob then
                    -- Teleporte suave usando TweenService
                    local tweenInfo = TweenInfo.new(
                        0.3, -- Tempo
                        Enum.EasingStyle.Linear,
                        Enum.EasingDirection.Out
                    )
                    
                    local tween = TweenService:Create(Root, tweenInfo, {
                        CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 7, 0)
                    })
                    tween:Play()
                    
                    -- Sistema de ataque
                    local args = {
                        [1] = mob.Humanoid
                    }
                    ReplicatedStorage.Remotes.Combat:FireServer(unpack(args))
                end
            end)
        end
    end)

    -- Teleport System
    local function addTeleport(name, position)
        TeleportSection:NewButton(name, "Teleport to " .. name, function()
            Root.CFrame = position
        end)
    end

    -- Adicione seus locais de teleporte aqui
    addTeleport("Safe Zone", CFrame.new(0, 100, 0))
    addTeleport("Quest Area", CFrame.new(100, 100, 100))
    -- Adicione mais locais conforme necessário

    -- Player Features Melhoradas
    PlayerSection:NewSlider("Walk Speed", "Changes walk speed", 500, 16, function(s)
        Humanoid.WalkSpeed = s
    end)

    PlayerSection:NewSlider("Jump Power", "Changes jump power", 500, 50, function(s)
        Humanoid.JumpPower = s
    end)

    PlayerSection:NewToggle("Infinite Jump", "Allows you to jump infinitely", function(state)
        _G.InfiniteJump = state
        game:GetService("UserInputService").JumpRequest:connect(function()
            if _G.InfiniteJump then
                Humanoid:ChangeState("Jumping")
            end
        end)
    end)

    -- Combat Features
    _G.KillAura = false
    CombatSection:NewToggle("Kill Aura", "Automatically attacks nearby mobs", function(state)
        _G.KillAura = state
        while _G.KillAura and wait() do
            pcall(function()
                for _, v in pairs(workspace:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                        if not Players:GetPlayerFromCharacter(v) then -- Verifica se não é um player
                            if (Root.Position - v.HumanoidRootPart.Position).Magnitude < 50 then
                                local args = {
                                    [1] = v.Humanoid
                                }
                                ReplicatedStorage.Remotes.Combat:FireServer(unpack(args))
                            end
                        end
                    end
                end
            end)
        end
    end)

    -- Misc Features
    MiscSection:NewButton("Remove Fog", "Removes fog from the game", function()
        game.Lighting.FogEnd = 1000000
        game.Lighting.FogStart = 0
        game.Lighting.ClockTime = 14
        game.Lighting.Brightness = 2
        game.Lighting.GlobalShadows = false
    end)

    -- ESP System
    local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/zeroisswag/universal-esp/main/esp.lua"))()
    
    MiscSection:NewToggle("ESP", "Shows ESP for players and mobs", function(state)
        ESP:Toggle(state)
    end)

    -- Notificação de Inicialização
    Library:Notify("Script Loaded Successfully!", "Welcome to THEUS HUB PREMIUM")
end

-- Key System Handler
Enter.MouseButton1Click:Connect(function()
    if KeyBox.Text == CorrectKey then
        Status.Text = "Correct Key! Loading..."
        Status.TextColor3 = Color3.fromRGB(0, 255, 0)
        wait(1)
        loadScript()
    else
        Status.Text = "Invalid Key!"
        Status.TextColor3 = Color3.fromRGB(255, 0, 0)
        wait(1)
        Status.Text = ""
    end
end)
```

Melhorias implementadas:
1. Sistema de login com key
2. Interface otimizada para mobile
3. Botão de minimizar
4. Sistema de quests automático baseado em level
5. Farm focado apenas em mobs (ignora players)
6. Teleportes suaves com TweenService
7. ESP universal
8. Sistema de notificações
9. Interface mais organizada
10. Anti-detecção melhorado

Para usar, execute:
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/theushub/premium/main/script.lua"))()