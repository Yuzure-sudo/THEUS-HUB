--[[
    HoHo Hub Premium - Ultimate Blox Fruits Script
    Developed by LuaXpert Team
    Version: 3.5.2
    Last Update: 2023-07-15
    
    Features:
    - Auto Farm (All Levels, Bosses, Items)
    - Player Enhancement (Speed, Jump, ESP)
    - PvP Enhancements
    - Raid Helper
    - Teleportation System
    - Item & Fruit Finder
    - Anti-Ban Systems
    - Material Auto-Farm
    - Custom UI with Themes
    - Auto-Quest System
    - Boss Timer Notifications
    - Auto-Skill and Combo System
]]

-- Configuration & Settings
local Settings = {
    AutoFarm = {
        Enabled = false,
        Type = "Level", -- Level, Mob, Boss, Item, Fruit, Material
        TargetLevel = nil,
        TargetMob = nil,
        TargetBoss = nil,
        TargetItem = nil,
        DistanceFromMob = 5,
        AttackMethod = "Normal", -- Normal, Skill, Fruit, Gun, Sword
        SkillsToUse = {"Z", "X", "C", "V", "F"},
        AutoEquipWeapon = true,
        PreferredWeapon = "Melee", -- Melee, Sword, Gun, Fruit
        SafeMode = true,
        TweenSpeed = 150,
        HopIfServerLags = true
    },
    
    AutoRaid = {
        Enabled = false,
        SelectedRaids = {"Flame", "Ice", "Quake", "Light", "Dark", "String", "Rumble", "Magma", "Human: Buddha", "Sand", "Bird: Phoenix", "Dough"},
        AutoBuyMicrochip = true,
        AutoSelectDungeon = true,
        RaidMode = "Normal", -- Normal, Private
        EatFruits = false,
        StoreSpecificFruits = {"Dragon", "Dough", "Leopard", "Venom"}
    },
    
    CharacterEnhancements = {
        WalkSpeed = 16,
        JumpPower = 50,
        InfiniteJump = false,
        NoClip = false,
        NoStun = false,
        AutoHaki = true,
        AutoKen = true,
        InfiniteStamina = false,
        InfiniteAbility = false
    },
    
    PVP = {
        Enabled = false,
        AimBot = {
            Enabled = false,
            TargetPart = "HumanoidRootPart",
            TeamCheck = true,
            VisibilityCheck = true,
            Sensitivity = 0.5,
            FovSize = 250
        },
        KillAura = {
            Enabled = false,
            Range = 15,
            TargetPlayer = true,
            TargetNPC = false,
            HitCooldown = 0.1,
            PreferredSkill = "Z"
        },
        SilentAim = false,
        ESP = {
            Enabled = false,
            ShowPlayers = true,
            ShowNPC = false,
            ShowChests = true,
            ShowDistance = true,
            ShowHealth = true,
            ShowNames = true,
            ShowBoxes = true,
            ShowTracers = false,
            ESPColor = Color3.fromRGB(255, 0, 0)
        }
    },
    
    Teleportation = {
        IslandTP = false,
        SelectedIsland = "Starter Island",
        TeleportMethod = "Smooth", -- Instant, Smooth
        SafeTeleport = true
    },
    
    Miscellaneous = {
        HideName = false,
        HideLevel = false,
        FruitFinder = {
            Enabled = false,
            Notify = true,
            AutoPickup = false,
            PreferredFruits = {"Dragon", "Dough", "Leopard", "Venom", "Shadow"}
        },
        ChestFarm = false,
        ServerHopper = false,
        FastAttack = {
            Enabled = true,
            AttackSpeed = 2, -- 1 = Normal, 2 = Fast, 3 = Super Fast
            UseNoclip = false
        }
    },
    
    UISettings = {
        Theme = "Dark", -- Dark, Light, Blue, Red, Green, Purple
        Transparency = 0.8,
        UISize = "Normal", -- Small, Normal, Large
        MinimizeKey = Enum.KeyCode.RightControl,
        UIPosition = UDim2.new(0.5, 0, 0.5, 0)
    },
    
    Webhooks = {
        Enabled = false,
        URL = "",
        SendLogs = false,
        NotifyOnRareFruit = true,
        NotifyOnLevelUp = false,
        NotifyCooldown = 300 -- in seconds
    }
}

-- Local Variables
local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local BloxFruits = require(Modules.BloxFruits)

local CurrentVersion = "3.5.2"
local IsExecuted = false
local IsWebhookValid = false
local WebhookLastSent = 0
local OriginalWalkSpeed = Humanoid.WalkSpeed
local OriginalJumpPower = Humanoid.JumpPower
local CurrentFarmingTarget = nil
local ActiveTween = nil
local ActiveToasts = {}
local AttackMethods = {}
local TargetFruits = {}
local FoundFruits = {}
local Locations = {}
local Islands = {}
local NPCs = {}
local Mobs = {}
local Bosses = {}
local QuestNPCs = {}
local ChestLocations = {}
local CurrentWebhooks = {}
local PlayerConnections = {}
local CurrentAutoFarm = nil
local QuestData = nil
local GUI = {}

-- Data Tables
local FruitsList = {
    Common = {"Bomb", "Spike", "Chop", "Spring", "Kilo", "Smoke", "Spin", "Flame", "Falcon"},
    Uncommon = {"Diamond", "Light", "Love", "Rubber", "Barrier", "Rocket", "Ghost"},
    Rare = {"Sand", "Ice", "Snow", "Quake", "Buddha", "Phoenix", "Portal", "Rumble"},
    Legendary = {"Magma", "Human: Buddha", "Dough", "Control", "Venom", "Shadow", "Dragon", "Gravity"},
    Mythical = {"Leopard", "T-Rex", "Kitsune"}
}

local BossData = {
    ["First Sea"] = {
        {Name = "Saber Expert", Level = 200, Drops = {"Saber"}, Location = "Middle Town", SpawnTime = 300, Position = Vector3.new(-910, 7, 1370)},
        {Name = "The Gorilla King", Level = 25, Drops = {"Key"}, Location = "Jungle", SpawnTime = 240, Position = Vector3.new(-1324, 6, 120)},
        {Name = "Bobby", Level = 55, Drops = {"Shotgun"}, Location = "Marine Town", SpawnTime = 180, Position = Vector3.new(-970, 7, 1440)},
        {Name = "Yeti", Level = 105, Drops = {"Yeti's Coat"}, Location = "Cold Island", SpawnTime = 300, Position = Vector3.new(1232, 105, -1515)}
    },
    ["Second Sea"] = {
        {Name = "Don Swan", Level = 1000, Drops = {"Bisento"}, Location = "Green Island", SpawnTime = 900, Position = Vector3.new(2288, 15, -2474)},
        {Name = "Darkbeard", Level = 1000, Drops = {"Soul Cane"}, Location = "Haunted Castle", SpawnTime = 600, Position = Vector3.new(-9530, 142, 5500)},
        {Name = "Order", Level = 1250, Drops = {"Rengoku"}, Location = "Green Zone", SpawnTime = 600, Position = Vector3.new(-5418, 313, -2828)},
        {Name = "Cursed Captain", Level = 1325, Drops = {"Cursed Dual Katana"}, Location = "Ship Fortress", SpawnTime = 1200, Position = Vector3.new(916, 125, 32841)}
    },
    ["Third Sea"] = {
        {Name = "Stone", Level = 1550, Drops = {"Valkyrie Helm"}, Location = "Stone Arena", SpawnTime = 300, Position = Vector3.new(-1109, 14, -3927)},
        {Name = "Island Empress", Level = 1675, Drops = {"Mace"}, Location = "Floating Turtle", SpawnTime = 900, Position = Vector3.new(5720, 602, -282)},
        {Name = "Kilo Admiral", Level = 1750, Drops = {"Admiral Coat"}, Location = "Marine Tree", SpawnTime = 900, Position = Vector3.new(2893, 423, -7130)},
        {Name = "Captain Elephant", Level = 1875, Drops = {"Hallow Scythe"}, Location = "Haunted Island", SpawnTime = 600, Position = Vector3.new(-13376, 332, -8074)},
        {Name = "Beautiful Pirate", Level = 1950, Drops = {"Pretty Wand"}, Location = "Beautiful Pirate Island", SpawnTime = 900, Position = Vector3.new(5314, 22, -76)},
        {Name = "Cake Queen", Level = 2175, Drops = {"Soul Cake"}, Location = "Cake Island", SpawnTime = 1200, Position = Vector3.new(-672, 632, -12144)},
        {Name = "Dough King", Level = 2300, Drops = {"Sweet Chalice"}, Location = "Sweet Island", SpawnTime = 1200, Position = Vector3.new(-1751.8, 38.6, -12287.3)}
    }
}

local DevilFruitShops = {
    ["First Sea"] = {
        {Name = "Fruit Dealer", Location = "Jungle", Position = Vector3.new(-236, 6, 112)},
        {Name = "Blox Fruits Dealer", Location = "Middle Town", Position = Vector3.new(-908, 14, 4078)}
    },
    ["Second Sea"] = {
        {Name = "Blox Fruits Dealer", Location = "Floating Turtle", Position = Vector3.new(-1646, 139, 505)},
        {Name = "Blox Fruits Dealer", Location = "Mansion", Position = Vector3.new(-12462, 374, -7451)}
    },
    ["Third Sea"] = {
        {Name = "Blox Fruits Dealer", Location = "Port Town", Position = Vector3.new(-330, 7, 5443)},
        {Name = "Blox Fruits Dealer", Location = "Great Tree", Position = Vector3.new(2955, 2282, -7214)},
        {Name = "Blox Fruits Dealer", Location = "Castle On The Sea", Position = Vector3.new(-12111, 332, -10517)}
    }
}

local IslandLocations = {
    ["First Sea"] = {
        {Name = "Starter Island", Position = Vector3.new(-55, 7, 56)},
        {Name = "Marine Starter", Position = Vector3.new(-2566, 6, 2047)},
        {Name = "Middle Town", Position = Vector3.new(-655, 7, 1437)},
        {Name = "Jungle", Position = Vector3.new(-1609, 36, 149)},
        {Name = "Pirate Village", Position = Vector3.new(-1122, 4, 3907)},
        {Name = "Desert", Position = Vector3.new(954, 6, 4236)},
        {Name = "Snow Island", Position = Vector3.new(1347, 104, -1327)},
        {Name = "Marine Fortress", Position = Vector3.new(-4936, 20, 4158)},
        {Name = "Sky Island 1", Position = Vector3.new(-4970, 718, -2621)},
        {Name = "Sky Island 2", Position = Vector3.new(-7894, 5545, -380)},
        {Name = "Prison", Position = Vector3.new(4857, 5, 743)},
        {Name = "Colosseum", Position = Vector3.new(-1427, 7, -2797)},
        {Name = "Underwater City", Position = Vector3.new(61163, 11, 1819)},
        {Name = "Fountain City", Position = Vector3.new(5173, 4, 4072)}
    },
    ["Second Sea"] = {
        {Name = "Dock", Position = Vector3.new(-12, 7, 2828)},
        {Name = "Mansion", Position = Vector3.new(-12548, 337, -7481)},
        {Name = "Floating Turtle", Position = Vector3.new(-13970, 261, -9)},
        {Name = "Green Zone", Position = Vector3.new(-2372, 72, -3005)},
        {Name = "Hot and Cold", Position = Vector3.new(-6744, 15, -5823)},
        {Name = "Cursed Ship", Position = Vector3.new(923, 125, 32852)},
        {Name = "Ice Castle", Position = Vector3.new(5400, 28, -6100)},
        {Name = "Forgotten Island", Position = Vector3.new(-3051, 238, -10019)},
        {Name = "Usoap's Island", Position = Vector3.new(4735, 8, 2880)},
        {Name = "Raid Lab", Position = Vector3.new(-6503, 60, -132)}
    },
    ["Third Sea"] = {
        {Name = "Port Town", Position = Vector3.new(-224, 6, 5300)},
        {Name = "Hydra Island", Position = Vector3.new(5229, 602, 345)},
        {Name = "Great Tree", Position = Vector3.new(2177, 24, -6728)},
        {Name = "Castle on the Sea", Position = Vector3.new(-11993, 334, -8844)},
        {Name = "Haunted Castle", Position = Vector3.new(-9503, 142, 5518)},
        {Name = "Cake Loaf", Position = Vector3.new(-2099, 13, -11554)},
        {Name = "Pirate Port", Position = Vector3.new(-290, 44, 5948)},
        {Name = "Sea of Treats", Position = Vector3.new(-899, 7, -11040)},
        {Name = "Tiki Outpost", Position = Vector3.new(-16207, 9, 495)},
        {Name = "Floating Turtle", Position = Vector3.new(-13234, 332, -7748)},
        {Name = "Mansion", Position = Vector3.new(-12468, 374, -7551)},
        {Name = "Secret Temple", Position = Vector3.new(5232, 4, 1105)},
        {Name = "Jungle Pirate", Position = Vector3.new(-11993, 331, -8834)},
        {Name = "Frozen Village", Position = Vector3.new(1394, 37, -1325)}
    }
}

-- Utility Functions
local function CreateTween(Object, Time, Style, Direction, Properties)
    Style = Style or Enum.EasingStyle.Quad
    Direction = Direction or Enum.EasingDirection.Out
    
    local Tween = TweenService:Create(
        Object,
        TweenInfo.new(Time, Style, Direction),
        Properties
    )
    
    return Tween
end

local function GetCurrentSea()
    if game.PlaceId == 2753915549 then
        return "First Sea"
    elseif game.PlaceId == 4442272183 then
        return "Second Sea"
    elseif game.PlaceId == 7449423635 then
        return "Third Sea"
    end
    return "Unknown"
end

local function TeleportTo(Target, Method, Speed)
    if typeof(Target) == "CFrame" then
        Target = Target.Position
    elseif typeof(Target) == "Instance" then
        Target = Target.CFrame.Position
    end
    
    Method = Method or Settings.Teleportation.TeleportMethod
    Speed = Speed or Settings.AutoFarm.TweenSpeed
    
    if Method == "Instant" then
        HumanoidRootPart.CFrame = CFrame.new(Target)
        return
    end
    
    if ActiveTween then
        ActiveTween:Cancel()
    end
    
    local Distance = (Target - HumanoidRootPart.Position).Magnitude
    local TweenTime = Distance / Speed
    
    ActiveTween = CreateTween(
        HumanoidRootPart,
        TweenTime,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.Out,
        {CFrame = CFrame.new(Target)}
    )
    
    ActiveTween:Play()
    return ActiveTween
end

local function ShowNotification(Title, Message, Duration, NotificationType)
    Duration = Duration or 5
    NotificationType = NotificationType or "Info" -- Info, Success, Warning, Error
    
    local Colors = {
        Info = Color3.fromRGB(0, 150, 255),
        Success = Color3.fromRGB(0, 200, 0),
        Warning = Color3.fromRGB(255, 150, 0),
        Error = Color3.fromRGB(255, 50, 50)
    }
    
    local Notification = Instance.new("Frame")
    local UICorner = Instance.new("UICorner", Notification)
    local TopBar = Instance.new("Frame", Notification)
    local UICorner_2 = Instance.new("UICorner", TopBar)
    local Title_2 = Instance.new("TextLabel", TopBar)
    local Icon = Instance.new("ImageLabel", TopBar)
    local Message_2 = Instance.new("TextLabel", Notification)
    local Progress = Instance.new("Frame", Notification)
    local UICorner_3 = Instance.new("UICorner", Progress)
    
    Notification.Name = "Notification"
    Notification.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Notification.Position = UDim2.new(1, -20, 0.9, -25 - (#ActiveToasts * 100))
    Notification.Size = UDim2.new(0, 300, 0, 90)
    Notification.AnchorPoint = Vector2.new(1, 1)
    UICorner.CornerRadius = UDim.new(0, 10)
    
    TopBar.Name = "TopBar"
    TopBar.BackgroundColor3 = Colors[NotificationType](TopBar.Size) = UDim2.new(1, 0, 0, 30)
    UICorner_2.CornerRadius = UDim.new(0, 10)
    
    Title_2.Name = "Title"
    Title_2.BackgroundTransparency = 1
    Title_2.Position = UDim2.new(0, 35, 0, 0)
    Title_2.Size = UDim2.new(0, 260, 0, 30)
    Title_2.Font = Enum.Font.GothamBold
    Title_2.Text = Title
    Title_2.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title_2.TextSize = 16
    Title_2.TextXAlignment = Enum.TextXAlignment.Left
    
    Icon.Name = "Icon"
    Icon.BackgroundTransparency = 1
    Icon.Position = UDim2.new(0, 5, 0, 5)
    Icon.Size = UDim2.new(0, 20, 0, 20)
    Icon.Image = "rbxassetid://7072978559" -- Icon corresponding to notification type
    
    Message_2.Name = "Message"
    Message_2.BackgroundTransparency = 1
    Message_2.Position = UDim2.new(0, 10, 0, 35)
    Message_2.Size = UDim2.new(0, 280, 0, 40)
    Message_2.Font = Enum.Font.Gotham
    Message_2.Text = Message
    Message_2.TextColor3 = Color3.fromRGB(255, 255, 255)
    Message_2.TextSize = 14
    Message_2.TextWrapped = true
    Message_2.TextXAlignment = Enum.TextXAlignment.Left
    Message_2.TextYAlignment = Enum.TextYAlignment.Top
    
    Progress.Name = "Progress"
    Progress.BackgroundColor3 = Colors[NotificationType](Progress.Position) = UDim2.new(0, 0, 0.95, 0)
    Progress.Size = UDim2.new(1, 0, 0, 5)
    UICorner_3.CornerRadius = UDim.new(0, 10)
    
    Notification.Parent = GUI.NotificationContainer
    
    table.insert(ActiveToasts, Notification)
    
    -- Animate entrance
    Notification.Position = UDim2.new(1, 300, 0.9, -25 - ((#ActiveToasts-1) * 100))
    local Tween1 = CreateTween(Notification, 0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, {
        Position = UDim2.new(1, -20, 0.9, -25 - ((#ActiveToasts-1) * 100))
    })
    Tween1:Play()
    
    -- Animate progress bar
    local Tween2 = CreateTween(Progress, Duration, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, {
        Size = UDim2.new(0, 0, 0, 5)
    })
    Tween2:Play()
    
    -- Remove notification after duration
    game:GetService("Debris"):AddItem(Notification, Duration + 0.5)
    
    task.delay(Duration, function()
        local index = table.find(ActiveToasts, Notification)
        if index then
            table.remove(ActiveToasts, index)
            
            -- Update positions of remaining notifications
            for i, Toast in ipairs(ActiveToasts) do
                local NewPos = UDim2.new(1, -20, 0.9, -25 - ((i-1) * 100))
                CreateTween(Toast, 0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, {
                    Position = NewPos
                }):Play()
            end
        end
        
        local Tween3 = CreateTween(Notification, 0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, {
            Position = UDim2.new(1, 300, 0.9, Notification.Position.Y.Offset)
        })
        Tween3:Play()
    end)
end

local function GetDistance(Position1, Position2)
    if typeof(Position1) == "Instance" then
        Position1 = Position1.Position
    end
    if typeof(Position2) == "Instance" then
        Position2 = Position2.Position
    end
    
    return (Position1 - Position2).Magnitude
end

local function SendWebhook(Title, Description, Color, Fields)
    if not Settings.Webhooks.Enabled or Settings.Webhooks.URL == "" then
        return
    end
    
    -- Check cooldown
    local CurrentTime = os.time()
    if CurrentTime - WebhookLastSent < Settings.Webhooks.NotifyCooldown then
        return
    end
    
    WebhookLastSent = CurrentTime
    
    local Embed = {
        title = Title,
        description = Description,
        color = Color or 65280, -- Default: Green
        fields = Fields or {},
        footer = {
            text = "HoHo Hub Premium | " .. os.date("%Y-%m-%d %H:%M:%S")
        }
    }
    
    local Data = {
        embeds = {Embed}
    }
    
    local Success, Error = pcall(function()
        local Response = request({
            Url = Settings.Webhooks.URL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode(Data)
        })
        
        if Response.StatusCode ~= 204 then
            warn("Failed to send webhook: " .. Response.StatusCode)
        end
    end)
    
    if not Success then
        warn("Webhook error: " .. Error)
    end
end

local function IsRareFruit(FruitName)
    FruitName = string.lower(FruitName):gsub("%-", ""):gsub(" ", "")
    
    for _, Fruit in ipairs(FruitsList.Legendary) do
        if string.lower(Fruit):gsub("%-", ""):gsub(" ", "") == FruitName then
            return true, "Legendary"
        end
    end
    
    for _, Fruit in ipairs(FruitsList.Mythical) do
        if string.lower(Fruit):gsub("%-", ""):gsub(" ", "") == FruitName then
            return true, "Mythical"
        end
    end
    
    return false, "Common"
end

local function DisableCollisions()
    if not Character then return end
    
    for _, Part in pairs(Character:GetDescendants()) do
        if Part:IsA("BasePart") then
            Part.CanCollide = false
        end
    end
end

local function EnableCollisions()
    if not Character then return end
    
    for _, Part in pairs(Character:GetDescendants()) do
        if Part:IsA("BasePart") and Part.Name ~= "HumanoidRootPart" then
            Part.CanCollide = true
        end
    end
end

local function GetClosestMob()
    local ClosestDistance = math.huge
    local ClosestMob = nil
    
    for _, Mob in pairs(workspace.Enemies:GetChildren()) do
        if Mob:FindFirstChild("Humanoid") and Mob.Humanoid.Health > 0 and Mob:FindFirstChild("HumanoidRootPart") then
            local Distance = GetDistance(HumanoidRootPart.Position, Mob.HumanoidRootPart.Position)
            
            if Distance < ClosestDistance then
                ClosestDistance = Distance
                ClosestMob = Mob
            end
        end
    end
    
    return ClosestMob, ClosestDistance
end

local function GetPlayerLevel()
    return Player.Data.Level.Value
end

local function FindQuest()
    local PlayerLevel = GetPlayerLevel()
    local ClosestQuestNPC = nil
    local ClosestDistance = math.huge
    
    for _, QuestNPC in pairs(workspace.NPCs:GetChildren()) do
        if QuestNPC:FindFirstChild("QuestLevel") and QuestNPC.QuestLevel.Value <= PlayerLevel then
            local Distance = GetDistance(HumanoidRootPart.Position, QuestNPC.HumanoidRootPart.Position)
            
            if Distance < ClosestDistance then
                ClosestDistance = Distance
                ClosestQuestNPC = QuestNPC
            end
        end
    end
    
    return ClosestQuestNPC
end

local function AcceptQuest()
    local QuestNPC = FindQuest()
    
    if QuestNPC then
        TeleportTo(QuestNPC.HumanoidRootPart.Position)
        task.wait(0.5)
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", QuestNPC.Name, QuestNPC.QuestLevel.Value)
        return true
    end
    
    return false
end

local function AutoEquipBestWeapon()
    local ToolsFolder = Player.Backpack
    local EquippedTool = Character:FindFirstChildOfClass("Tool")
    
    if EquippedTool then
        return EquippedTool
    end
    
    local BestTool = nil
    local HighestDamage = 0
    
    for _, Tool in pairs(ToolsFolder:GetChildren()) do
        if Tool:IsA("Tool") and Tool:FindFirstChild("ToolTip") then
            local Damage = 0
            
            if Tool.ToolTip:find("Damage:") then
                Damage = tonumber(Tool.ToolTip:match("Damage: (%d+)")) or 0
            end
            
            if Damage > HighestDamage then
                HighestDamage = Damage
                BestTool = Tool
            end
        end
    end
    
    if BestTool then
        BestTool.Parent = Character
        return BestTool
    end
    
    return nil
end

local function AutoAttack()
    local Tool = AutoEquipBestWeapon()
    
    if Tool then
        Tool:Activate()
    end
end

local function FastAttack()
    if not Settings.Miscellaneous.FastAttack.Enabled then
        return
    end
    
    for i = 1, Settings.Miscellaneous.FastAttack.AttackSpeed do
        local Tool = Character:FindFirstChildOfClass("Tool")
        
        if Tool and Tool:FindFirstChild("Attack") then
            Tool.Attack:FireServer()
        elseif Tool then
            Tool:Activate()
        end
    end
end

local function EnableNoClip()
    if not Settings.CharacterEnhancements.NoClip then
        return
    end
    
    DisableCollisions()
    
    if not PlayerConnections.NoClip then
        PlayerConnections.NoClip = RunService.Stepped:Connect(function()
            DisableCollisions()
        end)
    end
end

local function DisableNoClip()
    if PlayerConnections.NoClip then
        PlayerConnections.NoClip:Disconnect()
        PlayerConnections.NoClip = nil
    end
    
    EnableCollisions()
end

local function EnableInfiniteJump()
    if not Settings.CharacterEnhancements.InfiniteJump then
        return
    end
    
    if not PlayerConnections.InfiniteJump then
        PlayerConnections.InfiniteJump = UserInputService.JumpRequest:Connect(function()
            if Humanoid and Humanoid.Health > 0 then
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end

local function DisableInfiniteJump()
    if PlayerConnections.InfiniteJump then
        PlayerConnections.InfiniteJump:Disconnect()
        PlayerConnections.InfiniteJump = nil
    end
end

local function UpdatePlayerSpeed()
    if Humanoid then
        Humanoid.WalkSpeed = Settings.CharacterEnhancements.WalkSpeed
    end
end

local function UpdatePlayerJump()
    if Humanoid then
        Humanoid.JumpPower = Settings.CharacterEnhancements.JumpPower
    end
end

-- Auto Farm Functions
local function StartAutoFarm()
    if Settings.AutoFarm.Enabled and not CurrentAutoFarm then
        ShowNotification("Auto Farm", "Starting auto farm...", 3, "Success")
        
        CurrentAutoFarm = RunService.Stepped:Connect(function()
            if not Settings.AutoFarm.Enabled then
                CurrentAutoFarm:Disconnect()
                CurrentAutoFarm = nil
                return
            end
            
            if Settings.AutoFarm.Type == "Level" then
                -- Level farming logic
                local CurrentQuest = Player.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
                
                if CurrentQuest == "" then
                    -- No active quest, get one
                    if AcceptQuest() then
                        ShowNotification("Auto Farm", "Accepted new quest", 2, "Info")
                    end
                else
                    -- Find mob to kill
                    local QuestMobName = CurrentQuest:match("Defeat (%d+) (.+)")
                    
                    if QuestMobName then
                        -- Find and kill mobs
                        local ClosestMob, Distance = GetClosestMob()
                        
                        if ClosestMob and Distance < 300 then
                            EnableNoClip()
                            TeleportTo(ClosestMob.HumanoidRootPart.Position + Vector3.new(0, Settings.AutoFarm.DistanceFromMob, 0))
                            FastAttack()
                        else
                            -- No mobs found, search for them
                            for _, IslandData in pairs(IslandLocations[GetCurrentSea()]) do
                                TeleportTo(IslandData.Position)
                                task.wait(1)
                                
                                local NewClosestMob = GetClosestMob()
                                if NewClosestMob then
                                    break
                                end
                            end
                        end
                    end
                end
            elseif Settings.AutoFarm.Type == "Boss" then
                -- Boss farming logic
                local BossList = BossData[GetCurrentSea()]
                local TargetBoss = Settings.AutoFarm.TargetBoss
                
                local BossInfo = nil
                for _, Boss in pairs(BossList) do
                    if Boss.Name == TargetBoss then
                        BossInfo = Boss
                        break
                    end
                end
                
                if BossInfo then
                    -- Check if boss exists in workspace
                    local BossFound = false
                    for _, NPC in pairs(workspace.Enemies:GetChildren()) do
                        if NPC.Name == BossInfo.Name and NPC:FindFirstChild("Humanoid") and NPC.Humanoid.Health > 0 then
                            BossFound = true
                            EnableNoClip()
                            TeleportTo(NPC.HumanoidRootPart.Position + Vector3.new(0, Settings.AutoFarm.DistanceFromMob, 0))
                            FastAttack()
                            break
                        end
                    end
                    
                    if not BossFound then
                        -- Teleport to boss location and wait
                        TeleportTo(BossInfo.Position)
                        task.wait(1)
                    end
                end
            elseif Settings.AutoFarm.Type == "Fruit" then
                -- Devil Fruit farming logic
                for _, Fruit in pairs(workspace:GetChildren()) do
                    if Fruit.Name:find("Fruit") and Fruit:FindFirstChild("Handle") then
                        TeleportTo(Fruit.Handle.Position)
                        task.wait(0.5)
                        
                        -- Pick up fruit
                        if GetDistance(HumanoidRootPart, Fruit.Handle) < 10 then
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CollectFruit", Fruit.Name)
                            
                            -- Check if it's a rare fruit
                            local IsRare, Rarity = IsRareFruit(Fruit.Name)
                            if IsRare and Settings.Webhooks.Enabled and Settings.Webhooks.NotifyOnRareFruit then
                                SendWebhook(
                                    "Rare Fruit Found!",
                                    "HoHo Hub found a rare fruit: " .. Fruit.Name,
                                    65280, -- Green
                                    {
                                        {name = "Fruit", value = Fruit.Name, inline = true},
                                        {name = "Rarity", value = Rarity, inline = true},
                                        {name = "Player", value = Player.Name, inline = true},
                                        {name = "Level", value = GetPlayerLevel(), inline = true}
                                    }
                                )
                            end
                        end
                    end
                end
            end
        end)
    else
        ShowNotification("Auto Farm", "Auto farm is already running!", 3, "Warning")
    end
end

local function StopAutoFarm()
    if CurrentAutoFarm then
        CurrentAutoFarm:Disconnect()
        CurrentAutoFarm = nil
        DisableNoClip()
        ShowNotification("Auto Farm", "Auto farm stopped", 3, "Info")
    end
end

local function ToggleAutoFarm()
    Settings.AutoFarm.Enabled = not Settings.AutoFarm.Enabled
    
    if Settings.AutoFarm.Enabled then
        StartAutoFarm()
    else
        StopAutoFarm()
    end
end

-- Auto Raid Functions
local function GetChips()
    for _, NPC in pairs(workspace.NPCs:GetChildren()) do
        if NPC.Name:find("Raid") or NPC.Name:find("Dealer") then
            TeleportTo(NPC.HumanoidRootPart.Position)
            task.wait(1)
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaidsNpc", "Select", Settings.AutoRaid.SelectedRaids[1])
            task.wait(0.5)
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyChip", Settings.AutoRaid.SelectedRaids[1], 1)
            return true
        end
    end
    return false
end

local function StartRaid()
    for _, NPC in pairs(workspace.NPCs:GetChildren()) do
        if NPC.Name:find("Raid") then
            TeleportTo(NPC.HumanoidRootPart.Position)
            task.wait(1)
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaidsNpc", "Select", Settings.AutoRaid.SelectedRaids[1])
            task.wait(0.5)
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartRaid", Settings.AutoRaid.SelectedRaids[1])
            return true
        end
    end
    return false
end

local function AutoCollectFragments()
    for _, Fragment in pairs(workspace:GetChildren()) do
        if Fragment.Name == "Fragment" and Fragment:IsA("BasePart") then
            TeleportTo(Fragment.Position)
            task.wait(0.5)
        end
    end
end

local function AutoKillRaidBoss()
    local ClosestEnemy = nil
    local ClosestDistance = math.huge
    
    for _, Enemy in pairs(workspace.Enemies:GetChildren()) do
        if Enemy:FindFirstChild("Humanoid") and Enemy.Humanoid.Health > 0 and Enemy:FindFirstChild("HumanoidRootPart") then
            local Distance = GetDistance(HumanoidRootPart.Position, Enemy.HumanoidRootPart.Position)
            
            if Distance < ClosestDistance then
                ClosestDistance = Distance
                ClosestEnemy = Enemy
            end
        end
    end
    
    if ClosestEnemy and ClosestDistance < 300 then
        EnableNoClip()
        TeleportTo(ClosestEnemy.HumanoidRootPart.Position + Vector3.new(0, 10, 0))
        FastAttack()
        return true
    end
    
    return false
end

local function HandleRaidState()
    local RaidState = Player.PlayerGui.Main.Timer.Visible
    
    if RaidState then
        -- We're in a raid
        if not AutoKillRaidBoss() then
            AutoCollectFragments()
        end
    else
        -- Not in raid, check if we have a chip
        local HasChip = false
        
        for _, Item in pairs(Player.Backpack:GetChildren()) do
            if Item.Name:find("Microchip") or Item.Name:find("Raid") then
                HasChip = true
                break
            end
        end
        
        if HasChip then
            StartRaid()
        else
            if Settings.AutoRaid.AutoBuyMicrochip then
                GetChips()
            end
        end
    end
end

local function StartAutoRaid()
    if Settings.AutoRaid.Enabled and not PlayerConnections.AutoRaid then
        ShowNotification("Auto Raid", "Starting auto raid...", 3, "Success")
        
        PlayerConnections.AutoRaid = RunService.Stepped:Connect(function()
            if not Settings.AutoRaid.Enabled then
                PlayerConnections.AutoRaid:Disconnect()
                PlayerConnections.AutoRaid = nil
                DisableNoClip()
                return
            end
            
            HandleRaidState()
        end)
    else
        ShowNotification("Auto Raid", "Auto raid is already running!", 3, "Warning")
    end
end

local function StopAutoRaid()
    if PlayerConnections.AutoRaid then
        PlayerConnections.AutoRaid:Disconnect()
        PlayerConnections.AutoRaid = nil
        DisableNoClip()
        ShowNotification("Auto Raid", "Auto raid stopped", 3, "Info")
    end
end

local function ToggleAutoRaid()
    Settings.AutoRaid.Enabled = not Settings.AutoRaid.Enabled
    
    if Settings.AutoRaid.Enabled then
        StartAutoRaid()
    else
        StopAutoRaid()
    end
end

-- ESP Functions
local function CreateESPItem(Target, Type)
    if not GUI.ESP then return end
    
    local ESP = Instance.new("BillboardGui")
    local Frame = Instance.new("Frame", ESP)
    local Header = Instance.new("TextLabel", Frame)
    local Info = Instance.new("TextLabel", Frame)
    
    ESP.Name = "ESP_" .. Target.Name
    ESP.AlwaysOnTop = true
    ESP.Size = UDim2.new(0, 200, 0, 50)
    ESP.StudsOffset = Vector3.new(0, 3, 0)
    ESP.MaxDistance = 200
    
    Frame.BackgroundTransparency = 0.5
    Frame.BackgroundColor3 = Settings.PVP.ESP.ESPColor
    Frame.BorderSizePixel = 0
    Frame.Size = UDim2.new(1, 0, 1, 0)
    
    Header.BackgroundTransparency = 1
    Header.Position = UDim2.new(0, 0, 0, 0)
    Header.Size = UDim2.new(1, 0, 0.5, 0)
    Header.Font = Enum.Font.GothamBold
    Header.TextColor3 = Color3.fromRGB(255, 255, 255)
    Header.TextSize = 14
    Header.TextStrokeTransparency = 0.5
    Header.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    
    Info.BackgroundTransparency = 1
    Info.Position = UDim2.new(0, 0, 0.5, 0)
    Info.Size = UDim2.new(1, 0, 0.5, 0)
    Info.Font = Enum.Font.Gotham
    Info.TextColor3 = Color3.fromRGB(255, 255, 255)
    Info.TextSize = 12
    Info.TextStrokeTransparency = 0.5
    Info.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    
    if Type == "Player" then
        Header.Text = Target.Name
        ESP.Adornee = Target.Character.HumanoidRootPart
        
        -- Update info with health and level
        PlayerConnections["ESP_" .. Target.Name] = RunService.Heartbeat:Connect(function()
            if not Target or not Target.Character or not Target.Character:FindFirstChild("Humanoid") then
                if PlayerConnections["ESP_" .. Target.Name] then
                    PlayerConnections["ESP_" .. Target.Name]:Disconnect()
                    PlayerConnections["ESP_" .. Target.Name] = nil
                end
                ESP:Destroy()
                return
            end
            
            local TargetHumanoid = Target.Character:FindFirstChild("Humanoid")
            local Distance = "??"
            
            if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Target.Character:FindFirstChild("HumanoidRootPart") then
                Distance = math.floor(GetDistance(Player.Character.HumanoidRootPart, Target.Character.HumanoidRootPart))
            end
            
            Info.Text = "HP: " .. math.floor(TargetHumanoid.Health) .. "/" .. math.floor(TargetHumanoid.MaxHealth) .. " | Dist: " .. Distance
        end)
    elseif Type == "NPC" then
        Header.Text = Target.Name
        ESP.Adornee = Target.HumanoidRootPart
        
        -- Update info with health
        PlayerConnections["ESP_" .. Target.Name .. game:GetService("HttpService"):GenerateGUID(false)] = RunService.Heartbeat:Connect(function()
            if not Target or not Target:FindFirstChild("Humanoid") or not Target:FindFirstChild("HumanoidRootPart") then
                if PlayerConnections["ESP_" .. Target.Name] then
                    PlayerConnections["ESP_" .. Target.Name]:Disconnect()
                    PlayerConnections["ESP_" .. Target.Name] = nil
                end
                ESP:Destroy()
                return
            end
            
            local TargetHumanoid = Target:FindFirstChild("Humanoid")
            local Distance = "??"
            
            if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                Distance = math.floor(GetDistance(Player.Character.HumanoidRootPart, Target.HumanoidRootPart))
            end
            
            Info.Text = "HP: " .. math.floor(TargetHumanoid.Health) .. "/" .. math.floor(TargetHumanoid.MaxHealth) .. " | Dist: " .. Distance
        end)
    elseif Type == "Chest" then
        Header.Text = "Chest"
        ESP.Adornee = Target
        
        -- Update info with distance
        PlayerConnections["ESP_Chest" .. game:GetService("HttpService"):GenerateGUID(false)] = RunService.Heartbeat:Connect(function()
            if not Target or Target.Parent == nil then
                if PlayerConnections["ESP_Chest"] then
                    PlayerConnections["ESP_Chest"]:Disconnect()
                    PlayerConnections["ESP_Chest"] = nil
                end
                ESP:Destroy()
                return
            end
            
            local Distance = "??"
            
            if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                Distance = math.floor(GetDistance(Player.Character.HumanoidRootPart, Target))
            end
            
            Info.Text = "Distance: " .. Distance
        end)
    elseif Type == "Fruit" then
        Header.Text = Target.Name
        ESP.Adornee = Target
        
        local Rarity = "Common"
        local IsRare, RarityType = IsRareFruit(Target.Name)
        if IsRare then
            Rarity = RarityType
            Frame.BackgroundColor3 = Color3.fromRGB(255, 0, 255) -- Purple for rare fruits
        end
        
        -- Update info with distance
        PlayerConnections["ESP_Fruit" .. game:GetService("HttpService"):GenerateGUID(false)] = RunService.Heartbeat:Connect(function()
            if not Target or Target.Parent == nil then
                if PlayerConnections["ESP_Fruit"] then
                    PlayerConnections["ESP_Fruit"]:Disconnect()
                    PlayerConnections["ESP_Fruit"] = nil
                end
                ESP:Destroy()
                return
            end
            
            local Distance = "??"
            
            if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                Distance = math.floor(GetDistance(Player.Character.HumanoidRootPart, Target))
            end
            
            Info.Text = "Rarity: " .. Rarity .. " | Dist: " .. Distance
        end)
    end
    
    ESP.Parent = GUI.ESP
    return ESP
end

local function ToggleESP()
    Settings.PVP.ESP.Enabled = not Settings.PVP.ESP.Enabled
    
    if Settings.PVP.ESP.Enabled then
        -- Create ESP container if it doesn't exist
        if not GUI.ESP then
            GUI.ESP = Instance.new("Folder")
            GUI.ESP.Name = "ESP_Items"
            GUI.ESP.Parent = game:GetService("CoreGui")
        end
        
        -- Apply ESP to all players
        if Settings.PVP.ESP.ShowPlayers then
            for _, Target in pairs(game:GetService("Players"):GetPlayers()) do
                if Target ~= Player and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
                    CreateESPItem(Target, "Player")
                end
            end
        end
        
        -- Apply ESP to NPCs
        if Settings.PVP.ESP.ShowNPC then
            for _, Target in pairs(workspace.Enemies:GetChildren()) do
                if Target:FindFirstChild("Humanoid") and Target:FindFirstChild("HumanoidRootPart") then
                    CreateESPItem(Target, "NPC")
                end
            end
        end
        
        -- Apply ESP to chests
        if Settings.PVP.ESP.ShowChests then
            for _, Target in pairs(workspace:GetChildren()) do
                if Target.Name:find("Chest") and Target:IsA("BasePart") then
                    CreateESPItem(Target, "Chest")
                end
            end
        end
        
        -- Setup connections for new players and NPCs
        if not PlayerConnections.PlayerESP then
            PlayerConnections.PlayerESP = game:GetService("Players").PlayerAdded:Connect(function(PlayerAdded)
                if Settings.PVP.ESP.ShowPlayers and Settings.PVP.ESP.Enabled then
                    PlayerAdded.CharacterAdded:Connect(function(Character)
                        task.wait(1) -- Wait for character to fully load
                        if Character:FindFirstChild("HumanoidRootPart") then
                            CreateESPItem(PlayerAdded, "Player")
                        end
                    end)
                end
            end)
        end
        
        if not PlayerConnections.NpcESP then
            PlayerConnections.NpcESP = workspace.Enemies.ChildAdded:Connect(function(Child)
                if Settings.PVP.ESP.ShowNPC and Settings.PVP.ESP.Enabled then
                    task.wait(1) -- Wait for NPC to fully load
                    if Child:FindFirstChild("Humanoid") and Child:FindFirstChild("HumanoidRootPart") then
                        CreateESPItem(Child, "NPC")
                    end
                end
            end)
        end
        
        if not PlayerConnections.ChestESP then
            PlayerConnections.ChestESP = workspace.ChildAdded:Connect(function(Child)
                if Settings.PVP.ESP.ShowChests and Settings.PVP.ESP.Enabled then
                    if Child.Name:find("Chest") and Child:IsA("BasePart") then
                        CreateESPItem(Child, "Chest")
                    end
                end
            end)
        end
        
        ShowNotification("ESP", "ESP Enabled", 3, "Success")
    else
        -- Destroy ESP
        if GUI.ESP then
            GUI.ESP:Destroy()
            GUI.ESP = nil
        end
        
        -- Clear connections
        if PlayerConnections.PlayerESP then
            PlayerConnections.PlayerESP:Disconnect()
            PlayerConnections.PlayerESP = nil
        end
        
        if PlayerConnections.NpcESP then
            PlayerConnections.NpcESP:Disconnect()
            PlayerConnections.NpcESP = nil
        end
        
        if PlayerConnections.ChestESP then
            PlayerConnections.ChestESP:Disconnect()
            PlayerConnections.ChestESP = nil
        end
        
        -- Clean up ESP update connections
        for Key, Connection in pairs(PlayerConnections) do
            if type(Key) == "string" and Key:sub(1, 4) == "ESP_" then
                Connection:Disconnect()
                PlayerConnections[Key] = nil
            end
        end
        
        ShowNotification("ESP", "ESP Disabled", 3, "Info")
    end
end

-- Kill Aura Functions
local function ToggleKillAura()
    Settings.PVP.KillAura.Enabled = not Settings.PVP.KillAura.Enabled
    
    if Settings.PVP.KillAura.Enabled then
        if not PlayerConnections.KillAura then
            PlayerConnections.KillAura = RunService.Heartbeat:Connect(function()
                if not Settings.PVP.KillAura.Enabled then
                    PlayerConnections.KillAura:Disconnect()
                    PlayerConnections.KillAura = nil
                    return
                end
                
                local TargetsHit = 0
                
                -- Attack NPCs
                if Settings.PVP.KillAura.TargetNPC then
                    for _, Enemy in pairs(workspace.Enemies:GetChildren()) do
                        if Enemy:FindFirstChild("Humanoid") and Enemy.Humanoid.Health > 0 and Enemy:FindFirstChild("HumanoidRootPart") then
                            local Distance = GetDistance(HumanoidRootPart.Position, Enemy.HumanoidRootPart.Position)
                            
                            if Distance <= Settings.PVP.KillAura.Range then
                                TargetsHit = TargetsHit + 1
                                AutoAttack()
                                
                                -- Use skill if specified
                                local Tool = Character:FindFirstChildOfClass("Tool")
                                if Tool and Tool:FindFirstChild(Settings.PVP.KillAura.PreferredSkill) then
                                    Tool[Settings.PVP.KillAura.PreferredSkill]:Activate()
                                end
                            end
                        end
                    end
                end
                
                -- Attack Players
                if Settings.PVP.KillAura.TargetPlayer then
                    for _, PlayerTarget in pairs(game:GetService("Players"):GetPlayers()) do
                        if PlayerTarget ~= Player and PlayerTarget.Character and 
                           PlayerTarget.Character:FindFirstChild("Humanoid") and 
                           PlayerTarget.Character.Humanoid.Health > 0 and 
                           PlayerTarget.Character:FindFirstChild("HumanoidRootPart") then
                            
                            local Distance = GetDistance(HumanoidRootPart.Position, PlayerTarget.Character.HumanoidRootPart.Position)
                            
                            if Distance <= Settings.PVP.KillAura.Range then
                                TargetsHit = TargetsHit + 1
                                AutoAttack()
                                
                                -- Use skill if specified
                                local Tool = Character:FindFirstChildOfClass("Tool")
                                if Tool and Tool:FindFirstChild(Settings.PVP.KillAura.PreferredSkill) then
                                    Tool[Settings.PVP.KillAura.PreferredSkill]:Activate()
                                end
                            end
                        end
                    end
                end
                
                if TargetsHit > 0 then
                    FastAttack()
                end
            end)
        end
        
        ShowNotification("Kill Aura", "Kill Aura Enabled", 3, "Success")
    else
        if PlayerConnections.KillAura then
            PlayerConnections.KillAura:Disconnect()
            PlayerConnections.KillAura = nil
        end
        
        ShowNotification("Kill Aura", "Kill Aura Disabled", 3, "Info")
    end
end

-- Server Hopper
local function ServerHop()
    local PlaceId = game.PlaceId
    local Servers = {}
    
    local Success, Error = pcall(function()
        local Page = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        
        for _, Server in ipairs(Page.data) do
            if Server.playing < Server.maxPlayers then
                table.insert(Servers, {
                    id = Server.id,
                    players = Server.playing,
                    ping = Server.ping
                })
            end
        end
        
        -- Sort by player count
        table.sort(Servers, function(a, b)
            return a.players < b.players
        end)
        
        -- Try to join server with lowest player count
        if #Servers > 0 then
            ShowNotification("Server Hopper", "Joining server with " .. Servers[1].players .. " players", 5, "Info")
            game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceId, Servers[1].id)
        else
            ShowNotification("Server Hopper", "No available servers found", 5, "Error")
        end
    end)
    
    if not Success then
        ShowNotification("Server Hopper", "Error finding servers: " .. Error, 5, "Error")
    end
end

-- Build Main GUI
local function CreateMainGUI()
    -- Create ScreenGui
    local HoHoHub = Instance.new("ScreenGui")
    HoHoHub.Name = "HoHoHub"
    HoHoHub.ResetOnSpawn = false
    HoHoHub.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Apply appropriate parent based on environment
    if syn and syn.protect_gui then
        syn.protect_gui(HoHoHub)
        HoHoHub.Parent = game:GetService("CoreGui")
    elseif gethui then
        HoHoHub.Parent = gethui()
    else
        HoHoHub.Parent = game:GetService("CoreGui")
    end
    
    -- Create Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = Settings.UISettings.UIPosition
    MainFrame.Size = UDim2.new(0, 700, 0, 450)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Parent = HoHoHub
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = MainFrame
    
    -- Create Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TopBar.BorderSizePixel = 0
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.Parent = MainFrame
    
    local UICorner_TopBar = Instance.new("UICorner")
    UICorner_TopBar.CornerRadius = UDim.new(0, 10)
    UICorner_TopBar.Parent = TopBar
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.Size = UDim2.new(0, 200, 1, 0)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = "HoHo Hub Premium - Blox Fruits"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 18
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TopBar
    
    local Version = Instance.new("TextLabel")
    Version.Name = "Version"
    Version.BackgroundTransparency = 1
    Version.Position = UDim2.new(0, 0, 0, 0)
    Version.Size = UDim2.new(0, 100, 1, 0)
    Version.AnchorPoint = Vector2.new(1, 0)
    Version.Position = UDim2.new(1, -50, 0, 0)
    Version.Font = Enum.Font.Gotham
    Version.Text = "v" .. CurrentVersion
    Version.TextColor3 = Color3.fromRGB(200, 200, 200)
    Version.TextSize = 14
    Version.Parent = TopBar
    
    local CloseButton = Instance.new("ImageButton")
    CloseButton.Name = "CloseButton"
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(1, -35, 0, 8)
    CloseButton.Size = UDim2.new(0, 24, 0, 24)
    CloseButton.Image = "rbxassetid://6031094678"
    CloseButton.ImageColor3 = Color3.fromRGB(255, 80, 80)
    CloseButton.Parent = TopBar
    
    local MinimizeButton = Instance.new("ImageButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.BackgroundTransparency = 1
    MinimizeButton.Position = UDim2.new(1, -65, 0, 8)
    MinimizeButton.Size = UDim2.new(0, 24, 0, 24)
    MinimizeButton.Image = "rbxassetid://6031090990"
    MinimizeButton.ImageColor3 = Color3.fromRGB(255, 255, 120)
    MinimizeButton.Parent = TopBar
    
    -- Make the TopBar draggable
    local Dragging = false
    local DragStart = nil
    local StartPos = nil
    
    TopBar.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            DragStart = Input.Position
            StartPos = MainFrame.Position
        end
    end)
    
    TopBar.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = false
            DragStart = nil
            StartPos = nil
        end
    end)
    
    UserInputService.InputChanged:Connect(function(Input)
        if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
            local Delta = Input.Position - DragStart
            MainFrame.Position = UDim2.new(
                StartPos.X.Scale,
                StartPos.X.Offset + Delta.X,
                StartPos.Y.Scale,
                StartPos.Y.Offset + Delta.Y
            )
        end
    end)
    
    -- Handle Close Button
    CloseButton.MouseButton1Click:Connect(function()
        HoHoHub:Destroy()
        
        -- Clean up connections
        for _, Connection in pairs(PlayerConnections) do
            if typeof(Connection) == "RBXScriptConnection" then
                Connection:Disconnect()
            end
        end
        
        -- Stop running features
        StopAutoFarm()
        StopAutoRaid()
        DisableNoClip()
        DisableInfiniteJump()
        
        IsExecuted = false
    end)
    
    -- Handle Minimize Button
    local Minimized = false
    local OriginalSize = MainFrame.Size
    
    MinimizeButton.MouseButton1Click:Connect(function()
        Minimized = not Minimized
        
        if Minimized then
            MainFrame.Size = UDim2.new(0, MainFrame.Size.X.Offset, 0, TopBar.Size.Y.Offset)
        else
            MainFrame.Size = OriginalSize
        end
    end)
    
    -- Create Tab Buttons Frame
    local TabButtons = Instance.new("Frame")
    TabButtons.Name = "TabButtons"
    TabButtons.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TabButtons.BorderSizePixel = 0
    TabButtons.Position = UDim2.new(0, 10, 0, 50)
    TabButtons.Size = UDim2.new(0, 150, 0, 390)
    TabButtons.Parent = MainFrame
    
    local UICorner_TabButtons = Instance.new("UICorner")
    UICorner_TabButtons.CornerRadius = UDim.new(0, 10)
    UICorner_TabButtons.Parent = TabButtons
    
    -- Create Tab Content Frame
    local TabContent = Instance.new("Frame")
    TabContent.Name = "TabContent"
    TabContent.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TabContent.BorderSizePixel = 0
    TabContent.Position = UDim2.new(0, 170, 0, 50)
    TabContent.Size = UDim2.new(0, 520, 0, 390)
    TabContent.Parent = MainFrame
    
    local UICorner_TabContent = Instance.new("UICorner")
    UICorner_TabContent.CornerRadius = UDim.new(0, 10)
    UICorner_TabContent.Parent = TabContent
    
    -- Create a ScrollingFrame for the TabButtons to handle many tabs
    local TabButtonsScroll = Instance.new("ScrollingFrame")
    TabButtonsScroll.Name = "TabButtonsScroll"
    TabButtonsScroll.BackgroundTransparency = 1
    TabButtonsScroll.BorderSizePixel = 0
    TabButtonsScroll.Position = UDim2.new(0, 0, 0, 0)
    TabButtonsScroll.Size = UDim2.new(1, 0, 1, 0)
    TabButtonsScroll.CanvasSize = UDim2.new(0, 0, 0, 0) -- Will be updated as we add buttons
    TabButtonsScroll.ScrollBarThickness = 4
    TabButtonsScroll.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
    TabButtonsScroll.Parent = TabButtons
    
    -- Create a UIListLayout for the tab buttons
    local TabButtonsList = Instance.new("UIListLayout")
    TabButtonsList.Name = "TabButtonsList"
    TabButtonsList.Padding = UDim.new(0, 5)
    TabButtonsList.SortOrder = Enum.SortOrder.LayoutOrder
    TabButtonsList.Parent = TabButtonsScroll
    
    -- Add some padding
    local TabButtonsPadding = Instance.new("UIPadding")
    TabButtonsPadding.PaddingTop = UDim.new(0, 10)
    TabButtonsPadding.PaddingLeft = UDim.new(0, 10)
    TabButtonsPadding.PaddingRight = UDim.new(0, 10)
    TabButtonsPadding.PaddingBottom = UDim.new(0, 10)
    TabButtonsPadding.Parent = TabButtonsScroll
    
    -- Tab Management
    local Tabs = {}
    local CurrentTab = nil
    local TabObjects = {}
    
    -- Function to create a tab
    local function CreateTab(Name, Icon)
        -- Create Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = Name .. "Button"
        TabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        TabButton.BorderSizePixel = 0
        TabButton.Size = UDim2.new(1, 0, 0, 40)
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.Text = Name
        TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabButton.TextSize = 14
        TabButton.AutoButtonColor = false
        TabButton.Parent = TabButtonsScroll
        
        local UICorner_TabButton = Instance.new("UICorner")
        UICorner_TabButton.CornerRadius = UDim.new(0, 8)
        UICorner_TabButton.Parent = TabButton
        
        -- Add icon if provided
        if Icon then
            local IconImage = Instance.new("ImageLabel")
            IconImage.Name = "Icon"
            IconImage.BackgroundTransparency = 1
            IconImage.Position = UDim2.new(0, 10, 0.5, 0)
            IconImage.Size = UDim2.new(0, 20, 0, 20)
            IconImage.AnchorPoint = Vector2.new(0, 0.5)
            IconImage.Image = Icon
            IconImage.Parent = TabButton
            
            -- Adjust text position
            TabButton.TextXAlignment = Enum.TextXAlignment.Right
        end
        
        -- Create Tab Content Frame
        local TabFrame = Instance.new("ScrollingFrame")
        TabFrame.Name = Name .. "Tab"
        TabFrame.BackgroundTransparency = 1
        TabFrame.BorderSizePixel = 0
        TabFrame.Position = UDim2.new(0, 0, 0, 0)
        TabFrame.Size = UDim2.new(1, 0, 1, 0)
        TabFrame.ScrollBarThickness = 4
        TabFrame.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
        TabFrame.Visible = false
        TabFrame.Parent = TabContent
        
        -- Add padding and layout to tab content
        local TabPadding = Instance.new("UIPadding")
        TabPadding.PaddingTop = UDim.new(0, 10)
        TabPadding.PaddingLeft = UDim.new(0, 10)
        TabPadding.PaddingRight = UDim.new(0, 10)
        TabPadding.PaddingBottom = UDim.new(0, 10)
        TabPadding.Parent = TabFrame
        
        local TabLayout = Instance.new("UIListLayout")
        TabLayout.Padding = UDim.new(0, 10)
        TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabLayout.Parent = TabFrame
        
        -- Auto-adjust canvas size
        TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabFrame.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 20)
        end)
        
        -- Store tab data
        local Tab = {
            Button = TabButton,
            Frame = TabFrame,
            Name = Name
        }
        
        table.insert(Tabs, Tab)
        TabObjects[Name] = Tab
        
        -- Tab button click handler
        TabButton.MouseButton1Click:Connect(function()
            if CurrentTab then
                CurrentTab.Frame.Visible = false
                CurrentTab.Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                CurrentTab.Button.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
            
            Tab.Frame.Visible = true
            Tab.Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            Tab.Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            CurrentTab = Tab
        end)
        
        -- Update TabButtonsScroll canvas size
        TabButtonsScroll.CanvasSize = UDim2.new(0, 0, 0, TabButtonsList.AbsoluteContentSize.Y + 20)
        
        return Tab
    end
    
    -- Function to create a section in a tab
    local function CreateSection(Tab, Title)
        local Section = Instance.new("Frame")
        Section.Name = Title .. "Section"
        Section.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Section.BorderSizePixel = 0
        Section.Size = UDim2.new(1, -20, 0, 40) -- Initial size, will be adjusted
        Section.Parent = Tab.Frame
        
        local UICorner_Section = Instance.new("UICorner")
        UICorner_Section.CornerRadius = UDim.new(0, 8)
        UICorner_Section.Parent = Section
        
        local SectionTitle = Instance.new("TextLabel")
        SectionTitle.Name = "Title"
        SectionTitle.BackgroundTransparency = 1
        SectionTitle.Position = UDim2.new(0, 10, 0, 5)
        SectionTitle.Size = UDim2.new(1, -20, 0, 30)
        SectionTitle.Font = Enum.Font.GothamBold
        SectionTitle.Text = Title
        SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        SectionTitle.TextSize = 16
        SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
        SectionTitle.Parent = Section
        
        local ContentFrame = Instance.new("Frame")
        ContentFrame.Name = "Content"
        ContentFrame.BackgroundTransparency = 1
        ContentFrame.Position = UDim2.new(0, 10, 0, 40)
        ContentFrame.Size = UDim2.new(1, -20, 0, 0) -- Will be adjusted as elements are added
        ContentFrame.Parent = Section
        
        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Padding = UDim.new(0, 8)
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Parent = ContentFrame
        
        -- Auto-adjust section size based on content
        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            ContentFrame.Size = UDim2.new(1, -20, 0, ContentLayout.AbsoluteContentSize.Y)
            Section.Size = UDim2.new(1, -20, 0, ContentFrame.Size.Y.Offset + 50)
        end)
        
        return ContentFrame
    end
    
    -- Function to create a toggle button
    local function CreateToggle(Parent, Text, Default, Callback)
        local Toggle = Instance.new("Frame")
        Toggle.Name = Text .. "Toggle"
        Toggle.BackgroundTransparency = 1
        Toggle.Size = UDim2.new(1, 0, 0, 30)
        Toggle.Parent = Parent
        
        local ToggleLabel = Instance.new("TextLabel")
        ToggleLabel.Name = "Label"
        ToggleLabel.BackgroundTransparency = 1
        ToggleLabel.Position = UDim2.new(0, 0, 0, 0)
        ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
        ToggleLabel.Font = Enum.Font.Gotham
        ToggleLabel.Text = Text
        ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        ToggleLabel.TextSize = 14
        ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        ToggleLabel.Parent = Toggle
        
        local ToggleButton = Instance.new("Frame")
        ToggleButton.Name = "Button"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        ToggleButton.Position = UDim2.new(1, -50, 0.5, 0)
        ToggleButton.Size = UDim2.new(0, 50, 0, 24)
        ToggleButton.AnchorPoint = Vector2.new(0, 0.5)
        ToggleButton.Parent = Toggle
        
        local UICorner_ToggleButton = Instance.new("UICorner")
        UICorner_ToggleButton.CornerRadius = UDim.new(0, 12)
        UICorner_ToggleButton.Parent = ToggleButton
        
        local ToggleCircle = Instance.new("Frame")
        ToggleCircle.Name = "Circle"
        ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ToggleCircle.Position = UDim2.new(0, 5, 0.5, 0)
        ToggleCircle.Size = UDim2.new(0, 18, 0, 18)
        ToggleCircle.AnchorPoint = Vector2.new(0, 0.5)
        ToggleCircle.Parent = ToggleButton
        
        local UICorner_ToggleCircle = Instance.new("UICorner")
        UICorner_ToggleCircle.CornerRadius = UDim.new(1, 0)
        UICorner_ToggleCircle.Parent = ToggleCircle
        
        -- Set initial state
        local Enabled = Default or false
        
        local function UpdateToggle()
            if Enabled then
                ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
                ToggleCircle.Position = UDim2.new(0, 27, 0.5, 0)
            else
                ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                ToggleCircle.Position = UDim2.new(0, 5, 0.5, 0)
            end
            
            if Callback then
                Callback(Enabled)
            end
        end
        
        UpdateToggle()
        
        -- Make the toggle clickable
        ToggleButton.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                Enabled = not Enabled
                UpdateToggle()
            end
        end)
        
        -- Also make the label clickable
        ToggleLabel.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                Enabled = not Enabled
                UpdateToggle()
            end
        end)
        
        return {
            Instance = Toggle,
            SetValue = function(Value)
                Enabled = Value
                UpdateToggle()
            end,
            GetValue = function()
                return Enabled
            end
        }
    end
    
    -- Function to create a slider
    local function CreateSlider(Parent, Text, Min, Max, Default, Callback)
        local Slider = Instance.new("Frame")
        Slider.Name = Text .. "Slider"
        Slider.BackgroundTransparency = 1
        Slider.Size = UDim2.new(1, 0, 0, 50)
        Slider.Parent = Parent
        
        local SliderLabel = Instance.new("TextLabel")
        SliderLabel.Name = "Label"
        SliderLabel.BackgroundTransparency = 1
        SliderLabel.Position = UDim2.new(0, 0, 0, 0)
        SliderLabel.Size = UDim2.new(1, 0, 0, 20)
        SliderLabel.Font = Enum.Font.Gotham
        SliderLabel.Text = Text
        SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        SliderLabel.TextSize = 14
        SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
        SliderLabel.Parent = Slider
        
        local ValueLabel = Instance.new("TextLabel")
        ValueLabel.Name = "Value"
        ValueLabel.BackgroundTransparency = 1
        ValueLabel.Position = UDim2.new(1, -40, 0, 0)
        ValueLabel.Size = UDim2.new(0, 40, 0, 20)
        ValueLabel.Font = Enum.Font.Gotham
        ValueLabel.Text = tostring(Default)
        ValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        ValueLabel.TextSize = 14
        ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
        ValueLabel.Parent = Slider
        
        local SliderBG = Instance.new("Frame")
        SliderBG.Name = "Background"
        SliderBG.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        SliderBG.Position = UDim2.new(0, 0, 0, 25)
        SliderBG.Size = UDim2.new(1, 0, 0, 10)
        SliderBG.Parent = Slider
        
        local UICorner_SliderBG = Instance.new("UICorner")
        UICorner_SliderBG.CornerRadius = UDim.new(0, 5)
        UICorner_SliderBG.Parent = SliderBG
        
        local SliderFill = Instance.new("Frame")
        SliderFill.Name = "Fill"
        SliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        SliderFill.Size = UDim2.new(0, 0, 1, 0)
        SliderFill.Parent = SliderBG
        
        local UICorner_SliderFill = Instance.new("UICorner")
        UICorner_SliderFill.CornerRadius = UDim.new(0, 5)
        UICorner_SliderFill.Parent = SliderFill
        
        local SliderKnob = Instance.new("Frame")
        SliderKnob.Name = "Knob"
        SliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        SliderKnob.Position = UDim2.new(0, 0, 0.5, 0)
        SliderKnob.Size = UDim2.new(0, 16, 0, 16)
        SliderKnob.AnchorPoint = Vector2.new(0.5, 0.5)
        SliderKnob.Parent = SliderFill
        
        local UICorner_SliderKnob = Instance.new("UICorner")
        UICorner_SliderKnob.CornerRadius = UDim.new(1, 0)
        UICorner_SliderKnob.Parent = SliderKnob
        
        -- Set initial value
        local Value = Default or Min
        
        local function UpdateSlider()
            local Percent = (Value - Min) / (Max - Min)
            SliderFill.Size = UDim2.new(Percent, 0, 1, 0)
            ValueLabel.Text = tostring(Value)
            
            if Callback then
                Callback(Value)
            end
        end
        
        UpdateSlider()
        
        -- Slider functionality
        local Dragging = false
        
        SliderBG.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                Dragging = true
                
                -- Update on initial click
                local MousePos = UserInputService:GetMouseLocation().X
                local SliderPos = SliderBG.AbsolutePosition.X
                local SliderSize = SliderBG.AbsoluteSize.X
                local Percent = math.clamp((MousePos - SliderPos) / SliderSize, 0, 1)
                
                Value = Min + (Max - Min) * Percent
                if Max - Min < 1 then
                    Value = math.floor(Value * 100) / 100 -- Round to 2 decimal places for small ranges
                else
                    Value = math.floor(Value) -- Round to integer for larger ranges
                end
                
                UpdateSlider()
            end
        end)
        
        SliderBG.InputEnded:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                Dragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(Input)
            if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
                local MousePos = UserInputService:GetMouseLocation().X
                local SliderPos = SliderBG.AbsolutePosition.X
                local SliderSize = SliderBG.AbsoluteSize.X
                local Percent = math.clamp((MousePos - SliderPos) / SliderSize, 0, 1)
                
                Value = Min + (Max - Min) * Percent
                if Max - Min < 1 then
                    Value = math.floor(Value * 100) / 100 -- Round to 2 decimal places for small ranges
                else
                    Value = math.floor(Value) -- Round to integer for larger ranges
                end
                
                UpdateSlider()
            end
        end)
        
        return {
            Instance = Slider,
            SetValue = function(NewValue)
                Value = math.clamp(NewValue, Min, Max)
                UpdateSlider()
            end,
            GetValue = function()
                return Value
            end
        }
    end
    
    -- Function to create a dropdown
    local function CreateDropdown(Parent, Text, Options, Default, Callback)
        local Dropdown = Instance.new("Frame")
        Dropdown.Name = Text .. "Dropdown"
        Dropdown.BackgroundTransparency = 1
        Dropdown.Size = UDim2.new(1, 0, 0, 30)
        Dropdown.Parent = Parent
        
        local DropdownLabel = Instance.new("TextLabel")
        DropdownLabel.Name = "Label"
        DropdownLabel.BackgroundTransparency = 1
        DropdownLabel.Position = UDim2.new(0, 0, 0, 0)
        DropdownLabel.Size = UDim2.new(1, 0, 0, 20)
        DropdownLabel.Font = Enum.Font.Gotham
        DropdownLabel.Text = Text
        DropdownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        DropdownLabel.TextSize = 14
        DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
        DropdownLabel.Parent = Dropdown
        
        local DropdownButton = Instance.new("TextButton")
        DropdownButton.Name = "Button"
        DropdownButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        DropdownButton.Position = UDim2.new(0, 0, 0, 25)
        DropdownButton.Size = UDim2.new(1, 0, 0, 30)
        DropdownButton.Font = Enum.Font.Gotham
        DropdownButton.Text = Default or "Select..."
        DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        DropdownButton.TextSize = 14
        DropdownButton.Parent = Dropdown
        
        local UICorner_DropdownButton = Instance.new("UICorner")
        UICorner_DropdownButton.CornerRadius = UDim.new(0, 6)
        UICorner_DropdownButton.Parent = DropdownButton
        
        local DropdownIcon = Instance.new("ImageLabel")
        DropdownIcon.Name = "Icon"
        DropdownIcon.BackgroundTransparency = 1
        DropdownIcon.Position = UDim2.new(1, -25, 0.5, 0)
        DropdownIcon.Size = UDim2.new(0, 15, 0, 15)
        DropdownIcon.AnchorPoint = Vector2.new(0, 0.5)
        DropdownIcon.Image = "rbxassetid://6031091004" -- Down arrow icon
        DropdownIcon.Parent = DropdownButton
        
        local DropdownMenu = Instance.new("Frame")
        DropdownMenu.Name = "Menu"
        DropdownMenu.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        DropdownMenu.Position = UDim2.new(0, 0, 1, 5)
        DropdownMenu.Size = UDim2.new(1, 0, 0, 0) -- Will be adjusted based on options
        DropdownMenu.Visible = false
        DropdownMenu.ZIndex = 10
        DropdownMenu.Parent = DropdownButton
        
        local UICorner_DropdownMenu = Instance.new("UICorner")
        UICorner_DropdownMenu.CornerRadius = UDim.new(0, 6)
        UICorner_DropdownMenu.Parent = DropdownMenu
        
        local OptionsList = Instance.new("UIListLayout")
        OptionsList.Padding = UDim.new(0, 2)
        OptionsList.SortOrder = Enum.SortOrder.LayoutOrder
        OptionsList.Parent = DropdownMenu
        
        -- Add options to the dropdown
        for i, Option in ipairs(Options) do
            local OptionButton = Instance.new("TextButton")
            OptionButton.Name = Option
            OptionButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            OptionButton.Size = UDim2.new(1, 0, 0, 25)
            OptionButton.Font = Enum.Font.Gotham
            OptionButton.Text = Option
            OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            OptionButton.TextSize = 14
            OptionButton.ZIndex = 11
            OptionButton.Parent = DropdownMenu
            
            -- Option selection
            OptionButton.MouseButton1Click:Connect(function()
                DropdownButton.Text = Option
                DropdownMenu.Visible = false
                
                if Callback then
                    Callback(Option)
                end
            end)
        end
        
        -- Adjust menu size based on options
        DropdownMenu.Size = UDim2.new(1, 0, 0, #Options * 27)
        
        -- Toggle dropdown menu
        local MenuOpen = false
        
        DropdownButton.MouseButton1Click:Connect(function()
            MenuOpen = not MenuOpen
            DropdownMenu.Visible = MenuOpen
            
            if MenuOpen then
                DropdownIcon.Rotation = 180
            else
                DropdownIcon.Rotation = 0
            end
        end)
        
        -- Close dropdown when clicking elsewhere
        UserInputService.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                local MousePos = UserInputService:GetMouseLocation()
                local InDropdown = false
                
                -- Check if mouse is within dropdown button or menu
                if DropdownButton.AbsolutePosition.X <= MousePos.X and 
                   MousePos.X <= DropdownButton.AbsolutePosition.X + DropdownButton.AbsoluteSize.X and
                   DropdownButton.AbsolutePosition.Y <= MousePos.Y and
                   MousePos.Y <= DropdownButton.AbsolutePosition.Y + DropdownButton.AbsoluteSize.Y then
                    InDropdown = true
                end
                
                if DropdownMenu.Visible and not InDropdown then
                    if not (DropdownMenu.AbsolutePosition.X <= MousePos.X and 
                           MousePos.X <= DropdownMenu.AbsolutePosition.X + DropdownMenu.AbsoluteSize.X and
                           DropdownMenu.AbsolutePosition.Y <= MousePos.Y and
                           MousePos.Y <= DropdownMenu.AbsolutePosition.Y + DropdownMenu.AbsoluteSize.Y) then
                        MenuOpen = false
                        DropdownMenu.Visible = false
                        DropdownIcon.Rotation = 0
                    end
                end
            end
        end)
        
        -- Adjust parent frame size
        Dropdown.Size = UDim2.new(1, 0, 0, 60)
        
        return {
            Instance = Dropdown,
            SetValue = function(Value)
                if table.find(Options, Value) then
                    DropdownButton.Text = Value
                    
                    if Callback then
                        Callback(Value)
                    end
                end
            end,
            GetValue = function()
                return DropdownButton.Text
            end,
            AddOption = function(Option)
                if not table.find(Options, Option) then
                    table.insert(Options, Option)
                    
                    local OptionButton = Instance.new("TextButton")
                    OptionButton.Name = Option
                    OptionButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                    OptionButton.Size = UDim2.new(1, 0, 0, 25)
                    OptionButton.Font = Enum.Font.Gotham
                    OptionButton.Text = Option
                    OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    OptionButton.TextSize = 14
                    OptionButton.ZIndex = 11
                    OptionButton.Parent = DropdownMenu
                    
                    -- Option selection
                    OptionButton.MouseButton1Click:Connect(function()
                        DropdownButton.Text = Option
                        DropdownMenu.Visible = false
                        
                        if Callback then
                            Callback(Option)
                        end
                    end)
                    
                    -- Adjust menu size
                    DropdownMenu.Size = UDim2.new(1, 0, 0, #Options * 27)
                end
            end,
            RemoveOption = function(Option)
                local Index = table.find(Options, Option)
                if Index then
                    table.remove(Options, Index)
                    
                    if DropdownMenu:FindFirstChild(Option) then
                        DropdownMenu[Option]:Destroy()
                    end
                    
                    -- Adjust menu size
                    DropdownMenu.Size = UDim2.new(1, 0, 0, #Options * 27)
                    
                    -- Reset selection if current selection was removed
                    if DropdownButton.Text == Option then
                        DropdownButton.Text = "Select..."
                    end
                end
            end
        }
    end
    
    -- Function to create a button
    local function CreateButton(Parent, Text, Callback)
        local Button = Instance.new("TextButton")
        Button.Name = Text .. "Button"
        Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        Button.Size = UDim2.new(1, 0, 0, 35)
        Button.Font = Enum.Font.GothamSemibold
        Button.Text = Text
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.TextSize = 14
        Button.Parent = Parent
        
        local UICorner_Button = Instance.new("UICorner")
        UICorner_Button.CornerRadius = UDim.new(0, 6)
        UICorner_Button.Parent = Button
        
        -- Button hover effect
        Button.MouseEnter:Connect(function()
            Button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        end)
        
        Button.MouseLeave:Connect(function()
            Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        end)
        
        -- Button click effect
        Button.MouseButton1Down:Connect(function()
            Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end)
        
        Button.MouseButton1Up:Connect(function()
            Button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        end)
        
        -- Button callback
        Button.MouseButton1Click:Connect(function()
            if Callback then
                Callback()
            end
        end)
        
        return Button
    end
    
    -- Create notification container
    GUI.NotificationContainer = Instance.new("Frame")
    GUI.NotificationContainer.Name = "NotificationContainer"
    GUI.NotificationContainer.BackgroundTransparency = 1
    GUI.NotificationContainer.Size = UDim2.new(1, 0, 1, 0)
    GUI.NotificationContainer.Parent = HoHoHub
    
    -- Create tabs
    local MainTab = CreateTab("Main", "rbxassetid://7059346373")
    local AutoFarmTab = CreateTab("Auto Farm", "rbxassetid://7059291427")
    local TeleportTab = CreateTab("Teleport", "rbxassetid://7059285430")
    local RaidTab = CreateTab("Raids", "rbxassetid://7059280799")
    local CombatTab = CreateTab("Combat", "rbxassetid://7059288897")
    local MiscTab = CreateTab("Misc", "rbxassetid://7059286934")
    local SettingsTab = CreateTab("Settings", "rbxassetid://7059279452")
    
    -- Select the first tab by default
    MainTab.Button.MouseButton1Click:Fire()
    
