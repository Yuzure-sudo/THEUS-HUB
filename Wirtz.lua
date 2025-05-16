-- Wirtz Script Premium for Blox Fruits
-- Created by Wirtz
-- Version 1.0.0

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")

-- Variables
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Handle character respawn
Player.CharacterAdded:Connect(function(NewCharacter)
    Character = NewCharacter
    Humanoid = NewCharacter:WaitForChild("Humanoid")
    HumanoidRootPart = NewCharacter:WaitForChild("HumanoidRootPart")
end)

-- GUI Elements
local GUI = {}
local PlayerConnections = {}
local IsExecuted = false
local CurrentVersion = "1.0.0"

-- Settings
local Settings = {
    AutoFarm = {
        Enabled = false,
        Type = "Level",
        DistanceFromMob = 5,
        AttackMethod = "Normal",
        AutoEquipWeapon = true,
        SafeMode = true,
        TweenSpeed = 150,
        HopIfServerLags = false,
        TargetBoss = "",
        TargetItem = ""
    },
    AutoRaid = {
        Enabled = false,
        SelectedRaids = {"Flame"},
        AutoBuyMicrochip = true,
        RaidMode = "Normal",
        EatFruits = false,
        StoreSpecificFruits = {"Dragon", "Dough", "Leopard", "Venom"}
    },
    PVP = {
        KillAura = {
            Enabled = false,
            Range = 20,
            TargetPlayer = true,
            TargetNPC = true,
            PreferredSkill = "Z"
        },
        AimBot = {
            Enabled = false,
            TargetPart = "HumanoidRootPart",
            FovSize = 30
        },
        SilentAim = false,
        ESP = {
            Enabled = false,
            ShowPlayers = true,
            ShowNPC = true,
            ShowChests = true,
            ESPColor = Color3.fromRGB(255, 0, 0)
        }
    },
    CharacterEnhancements = {
        WalkSpeed = 16,
        JumpPower = 50,
        InfiniteJump = false,
        NoClip = false,
        AutoHaki = false
    },
    Teleportation = {
        SelectedIsland = "",
        TeleportMethod = "Instant"
    },
    Miscellaneous = {
        FastAttack = {
            Enabled = true,
            AttackSpeed = 1.5
        },
        ChestFarm = false,
        FruitFinder = {
            Enabled = false,
            Notify = true,
            AutoPickup = true
        }
    },
    UISettings = {
        Theme = "Dark",
        Transparency = 0,
        UISize = "Normal",
        UIPosition = UDim2.new(0.5, 0, 0.5, 0),
        MinimizeKey = Enum.KeyCode.RightControl
    },
    Webhooks = {
        Enabled = false,
        URL = "",
        NotifyOnRareFruit = true,
        NotifyOnLevelUp = true,
        NotifyCooldown = 300,
        LastNotifyTime = 0
    }
}

-- Data Tables
local FruitsList = {
    Common = {"Bomb", "Spike", "Chop", "Spring", "Kilo", "Smoke", "Spin", "Flame", "Falcon", "Ice", "Sand", "Dark", "Diamond", "Light", "Love", "Rubber", "Barrier", "Ghost", "Magma", "Quake"},
    Uncommon = {"Buddha", "Phoenix", "Rumble", "Paw", "Gravity", "Dough", "Shadow", "Venom", "Control", "Spirit", "Dragon", "Leopard"}
}

local IslandLocations = {
    ["First Sea"] = {
        {Name = "Pirate Starter", Position = Vector3.new(1071.2832, 16.3085976, 1426.86792)},
        {Name = "Marine Starter", Position = Vector3.new(-2573.3374, 6.88881969, 2046.99817)},
        {Name = "Middle Town", Position = Vector3.new(-655.824158, 7.88708115, 1436.67908)},
        {Name = "Jungle", Position = Vector3.new(-1249.77222, 11.8870859, 341.356476)},
        {Name = "Pirate Village", Position = Vector3.new(-1122.34998, 4.78708982, 3855.91992)},
        {Name = "Desert", Position = Vector3.new(1094.14587, 6.47350502, 4192.88721)},
        {Name = "Frozen Village", Position = Vector3.new(1198.00928, 27.0074959, -1211.73376)},
        {Name = "MarineFord", Position = Vector3.new(-4505.375, 20.687294, 4260.55908)},
        {Name = "Colosseum", Position = Vector3.new(-1428.35474, 7.38933945, -3014.37305)},
        {Name = "Sky 1st Floor", Position = Vector3.new(-4970.21875, 717.707275, -2622.35449)},
        {Name = "Sky 2nd Floor", Position = Vector3.new(-4813.0249, 903.708557, -1912.69055)},
        {Name = "Sky 3rd Floor", Position = Vector3.new(-7952.31006, 5545.52832, -320.704956)},
        {Name = "Prison", Position = Vector3.new(4854.16455, 5.68742752, 740.194641)},
        {Name = "Magma Village", Position = Vector3.new(-5231.75879, 8.61593437, 8467.87695)},
        {Name = "Underwater City", Position = Vector3.new(61163.8516, 11.7796879, 1819.78418)},
        {Name = "Fountain City", Position = Vector3.new(5132.7124, 4.53632832, 4037.8562)},
        {Name = "House Cyborg's", Position = Vector3.new(6262.72559, 71.3003616, 3998.23047)},
        {Name = "Shank's Room", Position = Vector3.new(-1442.16553, 29.8788261, -28.3547478)},
        {Name = "Mob Island", Position = Vector3.new(-2850.20068, 7.39224768, 5354.99268)}
    },
    ["Second Sea"] = {
        {Name = "First Spot", Position = Vector3.new(82.9490662, 18.0710983, 2834.98779)},
        {Name = "Kingdom of Rose", Position = Vector3.new(-394.983521, 118.503128, 1245.8446)},
        {Name = "Dark Arena", Position = Vector3.new(3780.13184, 22.6939468, -3498.5498)},
        {Name = "Flamingo Mansion", Position = Vector3.new(-483.73712, 332.0383, 595.032166)},
        {Name = "Flamingo Room", Position = Vector3.new(2284.4873, 15.152037, 875.72998)},
        {Name = "Green Bit", Position = Vector3.new(-2297.40332, 73.1782455, -2151.3916)},
        {Name = "Cafe", Position = Vector3.new(-385.250916, 73.0458984, 297.388397)},
        {Name = "Factroy", Position = Vector3.new(430.42569, 210.019623, -432.504791)},
        {Name = "Colosseum", Position = Vector3.new(-1836.58191, 44.5890656, 1360.30652)},
        {Name = "Ghost Island", Position = Vector3.new(-5571.84424, 195.182297, -795.432922)},
        {Name = "Ghost Island 2nd", Position = Vector3.new(-5931.77979, 5.19957924, -1189.41437)},
        {Name = "Snow Mountain", Position = Vector3.new(1384.68298, 453.569031, -4990.09766)},
        {Name = "Hot and Cold", Position = Vector3.new(-6026.96484, 14.7461271, -5071.96338)},
        {Name = "Magma Side", Position = Vector3.new(-5478.39209, 15.9775667, -5246.9126)},
        {Name = "Cursed Ship", Position = Vector3.new(902.059143, 124.752518, 33071.8125)},
        {Name = "Frosted Island", Position = Vector3.new(5400.40381, 28.21698, -6236.99219)},
        {Name = "Forgotten Island", Position = Vector3.new(-3043.31543, 238.881271, -10191.5791)},
        {Name = "Usoapp Island", Position = Vector3.new(4748.78857, 8.35370827, 2849.57959)},
        {Name = "Minisky Island", Position = Vector3.new(-260.358917, 49325.7031, -35259.3008)}
    },
    ["Third Sea"] = {
        {Name = "Port Town", Position = Vector3.new(-275.21615, 43.755085, 5451.08984)},
        {Name = "Hydra Island", Position = Vector3.new(5228.8584, 604.391052, 345.0400)},
        {Name = "Great Tree", Position = Vector3.new(2174.94873, 28.7312393, -6728.83154)},
        {Name = "Castle on the Sea", Position = Vector3.new(-5477.62842, 313.794739, -2808.4585)},
        {Name = "Floating Turtle", Position = Vector3.new(-10919.2998, 331.788452, -8637.57227)},
        {Name = "Mansion", Position = Vector3.new(-12553.8125, 332.403961, -7621.91748)},
        {Name = "Secret Temple", Position = Vector3.new(5217.35693, 6.56511116, 1100.88159)},
        {Name = "Friendly Arena", Position = Vector3.new(5220.28955, 72.8193436, -1450.86304)},
        {Name = "Beautiful Pirate Domain", Position = Vector3.new(5310.8095703125, 21.594484329224, 129.39053344727)},
        {Name = "Teler Park", Position = Vector3.new(-9512.3623046875, 142.13258361816, 5548.845703125)},
        {Name = "Peanut Island", Position = Vector3.new(-2142, 48, -10031)},
        {Name = "Ice Cream Island", Position = Vector3.new(-949, 59, -10907)}
    }
}

local BossData = {
    ["First Sea"] = {
        {Name = "The Gorilla King", Position = Vector3.new(-1088.75977, 6.47350502, -488.559906)},
        {Name = "Bobby", Position = Vector3.new(-1117.72583, 14.8829851, 4017.2334)},
        {Name = "Yeti", Position = Vector3.new(1216.81824, 105.387039, -1305.66187)},
        {Name = "Vice Admiral", Position = Vector3.new(-5078.45898, 28.677835, 4354.505859)},
        {Name = "Warden", Position = Vector3.new(5278.04932, 1.7803750038147, 964.919861)},
        {Name = "Chief Warden", Position = Vector3.new(5206.95898, 1.7803750038147, 814.550171)},
        {Name = "Swan", Position = Vector3.new(5325.09619, 1.7803750038147, 719.466979)},
        {Name = "Magma Admiral", Position = Vector3.new(-5530.12646, 22.8623924, 8824.8125)},
        {Name = "Fishman Lord", Position = Vector3.new(61351.7773, 31.4706631, 1095.32288)},
        {Name = "Wysper", Position = Vector3.new(-4821.48438, 717.669617, -2637.82129)},
        {Name = "Thunder God", Position = Vector3.new(-7994.984375, 5751.46143, -2088.4563)}
    },
    ["Second Sea"] = {
        {Name = "Diamond", Position = Vector3.new(-1736.26587, 198.627731, -236.412857)},
        {Name = "Jeremy", Position = Vector3.new(2006.4728, 45.7377205, 565.587158)},
        {Name = "Fajita", Position = Vector3.new(-428.339508, 72.9495239, 355.756531)},
        {Name = "Don Swan", Position = Vector3.new(2288.802, 15.1870775, 863.034607)},
        {Name = "Smoke Admiral", Position = Vector3.new(-5115.72754, 23.7664986, 8466.59863)},
        {Name = "Cursed Captain", Position = Vector3.new(916.928589, 181.092773, 33422)},
        {Name = "Darkbeard", Position = Vector3.new(3876.42993, 5.4081192, -1908.2959)},
        {Name = "Order", Position = Vector3.new(-6221.15039, 16.2000656, -5045.23584)},
        {Name = "Awakened Ice Admiral", Position = Vector3.new(6407.33936, 340.223114, -6892.521)}
    },
    ["Third Sea"] = {
        {Name = "Stone", Position = Vector3.new(-1109.8833, 40.0002594, 6730.48926)},
        {Name = "Island Empress", Position = Vector3.new(5702.36572, 601.924438, 201.682297)},
        {Name = "Kilo Admiral", Position = Vector3.new(2861.53516, 423.584412, -7254.12256)},
        {Name = "Captain Elephant", Position = Vector3.new(-13376.9443, 331.788452, -8228.53027)},
        {Name = "Beautiful Pirate", Position = Vector3.new(5314.58203, 25.419569, 160.172607)},
        {Name = "Cake Queen", Position = Vector3.new(-819.376709, 64.9259796, -10965.5791)}
    }
}

local DevilFruitShops = {
    ["First Sea"] = {
        {Name = "Blox Fruits Dealer", Position = Vector3.new(6156.92285, 296.560211, -1191.7912)},
        {Name = "Blox Fruits Dealer", Position = Vector3.new(-12.3310547, 14.8263273, -384.697937)}
    },
    ["Second Sea"] = {
        {Name = "Blox Fruits Dealer", Position = Vector3.new(-1145.32727, 7.71678162, 4296.47168)},
        {Name = "Blox Fruits Dealer", Position = Vector3.new(4727.5957, 7.54383469, 2458.16675)}
    },
    ["Third Sea"] = {
        {Name = "Blox Fruits Dealer", Position = Vector3.new(-12493.1953, 336.436188, -7464.75928)},
        {Name = "Blox Fruits Dealer", Position = Vector3.new(-13931.5859, 351.577103, -8003.10449)}
    }
}

-- Utility Functions
local function GetCurrentSea()
    if game.PlaceId == 2753915549 then
        return "First Sea"
    elseif game.PlaceId == 4442272183 then
        return "Second Sea"
    elseif game.PlaceId == 7449423635 then
        return "Third Sea"
    else
        return "Unknown"
    end
end

local function GetPlayerLevel()
    return Player.Data.Level.Value
end

local function GetDistance(pos1, pos2)
    if typeof(pos1) == "Instance" then
        pos1 = pos1.Position
    end
    if typeof(pos2) == "Instance" then
        pos2 = pos2.Position
    end
    return (pos1 - pos2).Magnitude
end

local function IsRareFruit(FruitName)
    local CleanName = string.gsub(FruitName, "%-", "")
    CleanName = string.gsub(CleanName, "Fruit", "")
    CleanName = string.gsub(CleanName, " ", "")
    
    for _, Fruit in pairs(FruitsList.Uncommon) do
        if string.find(string.lower(CleanName), string.lower(Fruit)) then
            return true, "Uncommon"
        end
    end
    
    for _, Fruit in pairs(FruitsList.Common) do
        if string.find(string.lower(CleanName), string.lower(Fruit)) then
            return false, "Common"
        end
    end
    
    return false, "Unknown"
end

local function TeleportTo(Position, Method)
    Method = Method or "Instant"
    
    if Method == "Instant" then
        HumanoidRootPart.CFrame = CFrame.new(Position)
    else
        local Distance = GetDistance(HumanoidRootPart.Position, Position)
        local Speed = Settings.AutoFarm.TweenSpeed
        local Time = Distance / Speed
        
        local Tween = TweenService:Create(
            HumanoidRootPart,
            TweenInfo.new(Time, Enum.EasingStyle.Linear),
            {CFrame = CFrame.new(Position)}
        )
        
        Tween:Play()
        Tween.Completed:Wait()
    end
end

local function SendWebhook(Title, Description, Color, Fields)
    if not Settings.Webhooks.Enabled or Settings.Webhooks.URL == "" then return end
    
    local CurrentTime = os.time()
    if CurrentTime - Settings.Webhooks.LastNotifyTime < Settings.Webhooks.NotifyCooldown then
        return
    end
    
    Settings.Webhooks.LastNotifyTime = CurrentTime
    
    local Embed = {
        title = Title,
        description = Description,
        color = Color,
        fields = Fields,
        footer = {
            text = "Wirtz Script Premium • " .. os.date("%x %X")
        }
    }
    
    local Success, Error = pcall(function()
        HttpService:PostAsync(
            Settings.Webhooks.URL,
            HttpService:JSONEncode({
                username = "Wirtz Script",
                avatar_url = "https://i.imgur.com/8DKwbhj.png",
                embeds = {Embed}
            }),
            Enum.HttpContentType.ApplicationJson
        )
    end)
    
    if not Success then
        warn("Failed to send webhook: " .. Error)
    end
end

-- UI Functions
local function ShowNotification(Title, Message, Duration, Type)
    Duration = Duration or 3
    Type = Type or "Info"
    
    local TypeColors = {
        Info = Color3.fromRGB(0, 170, 255),
        Success = Color3.fromRGB(0, 200, 0),
        Warning = Color3.fromRGB(255, 200, 0),
        Error = Color3.fromRGB(255, 50, 50)
    }
    
    local NotificationFrame = Instance.new("Frame")
    NotificationFrame.Name = "Notification"
    NotificationFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    NotificationFrame.BorderSizePixel = 0
    NotificationFrame.Position = UDim2.new(1, 10, 0.8, 0)
    NotificationFrame.Size = UDim2.new(0, 250, 0, 80)
    NotificationFrame.AnchorPoint = Vector2.new(1, 1)
    NotificationFrame.Parent = GUI.NotificationContainer
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = NotificationFrame
    
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.BackgroundColor3 = TypeColors[Type](TopBar.BorderSizePixel) = 0
    TopBar.Size = UDim2.new(1, 0, 0, 24)
    TopBar.Parent = NotificationFrame
    
    local UICorner_TopBar = Instance.new("UICorner")
    UICorner_TopBar.CornerRadius = UDim.new(0, 8)
    UICorner_TopBar.Parent = TopBar
    
    local BottomCover = Instance.new("Frame")
    BottomCover.Name = "BottomCover"
    BottomCover.BackgroundColor3 = TypeColors[Type](BottomCover.BorderSizePixel) = 0
    BottomCover.Position = UDim2.new(0, 0, 0.5, 0)
    BottomCover.Size = UDim2.new(1, 0, 0.5, 0)
    BottomCover.Parent = TopBar
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.Size = UDim2.new(1, -20, 1, 0)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = Title
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TopBar
    
    local MessageLabel = Instance.new("TextLabel")
    MessageLabel.Name = "Message"
    MessageLabel.BackgroundTransparency = 1
    MessageLabel.Position = UDim2.new(0, 10, 0, 30)
    MessageLabel.Size = UDim2.new(1, -20, 0, 40)
    MessageLabel.Font = Enum.Font.Gotham
    MessageLabel.Text = Message
    MessageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    MessageLabel.TextSize = 14
    MessageLabel.TextWrapped = true
    MessageLabel.TextXAlignment = Enum.TextXAlignment.Left
    MessageLabel.TextYAlignment = Enum.TextYAlignment.Top
    MessageLabel.Parent = NotificationFrame
    
    -- Animate in
    NotificationFrame:TweenPosition(UDim2.new(1, -10, 0.8, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.5, true)
    
    -- Auto dismiss
    spawn(function()
        wait(Duration)
        
        -- Animate out
        NotificationFrame:TweenPosition(UDim2.new(1, 10, 0.8, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quart, 0.5, true)
        
        wait(0.5)
        NotificationFrame:Destroy()
    end)
end

-- Character Enhancement Functions
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

local function EnableInfiniteJump()
    if not PlayerConnections.InfiniteJump then
        PlayerConnections.InfiniteJump = UserInputService.JumpRequest:Connect(function()
            if Settings.CharacterEnhancements.InfiniteJump then
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

local function EnableNoClip()
    if not PlayerConnections.NoClip then
        PlayerConnections.NoClip = RunService.Stepped:Connect(function()
            if Settings.CharacterEnhancements.NoClip then
                for _, Part in pairs(Character:GetDescendants()) do
                    if Part:IsA("BasePart") and Part.CanCollide then
                        Part.CanCollide = false
                    end
                end
            end
        end)
    end
end

local function DisableNoClip()
    if PlayerConnections.NoClip then
        PlayerConnections.NoClip:Disconnect()
        PlayerConnections.NoClip = nil
        
        for _, Part in pairs(Character:GetDescendants()) do
            if Part:IsA("BasePart") and Part.Name ~= "HumanoidRootPart" then
                Part.CanCollide = true
            end
        end
    end
end

-- Combat Functions
local function FastAttack()
    if not Settings.Miscellaneous.FastAttack.Enabled then return end
    
    local CombatFramework = require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework)
    local CombatFrameworkR = getupvalues(CombatFramework)[2]
    local CameraShakerR = require(game.ReplicatedStorage.Util.CameraShaker)
    CameraShakerR:Stop()
    
    for i = 1, Settings.Miscellaneous.FastAttack.AttackSpeed do
        local FastAttackEvent = {
            [1] = "M1",
            [2] = 1
        }
        game:GetService("ReplicatedStorage").RigControllerEvent:FireServer(unpack(FastAttackEvent))
    end
end

local function AutoAttack()
    local args = {
        [1] = "M1",
        [2] = 1
    }
    game:GetService("ReplicatedStorage").RigControllerEvent:FireServer(unpack(args))
end

-- Auto Farm Functions
local function GetClosestMob()
    local ClosestMob = nil
    local ClosestDistance = math.huge
    
    for _, Mob in pairs(workspace.Enemies:GetChildren()) do
        if Mob:FindFirstChild("Humanoid") and Mob:FindFirstChild("HumanoidRootPart") and Mob.Humanoid.Health > 0 then
            local Distance = GetDistance(HumanoidRootPart.Position, Mob.HumanoidRootPart.Position)
            
            if Distance < ClosestDistance then
                ClosestDistance = Distance
                ClosestMob = Mob
            end
        end
    end
    
    return ClosestMob
end

local function GetQuestLevel()
    local PlayerLvl = GetPlayerLevel()
    
    -- First Sea Quests
    if GetCurrentSea() == "First Sea" then
        if PlayerLvl < 10 then
            return "BanditQuest1", "Bandit", CFrame.new(1060.0158691406, 16.424287796021, 1547.9769287109)
        elseif PlayerLvl < 15 then
            return "JungleQuest", "Monkey", CFrame.new(-1599.97, 36.8521, 153.452)
        elseif PlayerLvl < 30 then
            return "JungleQuest", "Gorilla", CFrame.new(-1599.97, 36.8521, 153.452)
        elseif PlayerLvl < 40 then
            return "BuggyQuest1", "Brute", CFrame.new(-1140.08, 4.7520356, 3827.36)
        elseif PlayerLvl < 60 then
            return "DesertQuest", "Desert Bandit", CFrame.new(895.393, 6.438, 4391.051)
        elseif PlayerLvl < 75 then
            return "DesertQuest", "Desert Officer", CFrame.new(895.393, 6.438, 4391.051)
        elseif PlayerLvl < 90 then
            return "SnowQuest", "Snow Bandit", CFrame.new(1386.8073, 87.272, -1298.3092)
        elseif PlayerLvl < 100 then
            return "SnowQuest", "Snowman", CFrame.new(1386.8073, 87.272, -1298.3092)
        elseif PlayerLvl < 120 then
            return "MarineQuest2", "Chief Petty Officer", CFrame.new(-5036.2, 28.652, 4324.4)
        elseif PlayerLvl < 150 then
            return "SkyQuest", "Sky Bandit", CFrame.new(-4841.2334, 718.106, -2619.0247)
        elseif PlayerLvl < 175 then
            return "SkyQuest", "Dark Master", CFrame.new(-4841.2334, 718.106, -2619.0247)
        elseif PlayerLvl < 250 then
            return "PrisonerQuest", "Prisoner", CFrame.new(5308.93115, 1.65517521, 475.120514)
        elseif PlayerLvl < 300 then
            return "PrisonerQuest", "Dangerous Prisoner", CFrame.new(5308.93115, 1.65517521, 475.120514)
        elseif PlayerLvl < 375 then
            return "MagmaQuest", "Military Soldier", CFrame.new(-5316.1157226563, 12.262831687927, 8517.00390625)
        elseif PlayerLvl < 450 then
            return "MagmaQuest", "Military Spy", CFrame.new(-5316.1157226563, 12.262831687927, 8517.00390625)
        elseif PlayerLvl < 625 then
            return "FishmanQuest", "Fishman Warrior", CFrame.new(61122.2109375, 18.4716377258301, 1568.84717)
        elseif PlayerLvl < 700 then
            return "FishmanQuest", "Fishman Commando", CFrame.new(61122.2109375, 18.4716377258301, 1568.84717)
        else
            return "SkyExp1Quest", "God's Guard", CFrame.new(-4721.8603515625, 845.30297851563, -1953.8489990234)
        end
    -- Second Sea Quests
    elseif GetCurrentSea() == "Second Sea" then
        if PlayerLvl < 800 then
            return "Area1Quest", "Raider", CFrame.new(-427.72567749023, 72.99634552002, 1835.8194580078)
        elseif PlayerLvl < 875 then
            return "Area1Quest", "Mercenary", CFrame.new(-427.72567749023, 72.99634552002, 1835.8194580078)
        elseif PlayerLvl < 950 then
            return "Area2Quest", "Swan Pirate", CFrame.new(635.61151123047, 73.096351623535, 917.81298828125)
        elseif PlayerLvl < 1000 then
            return "Area2Quest", "Factory Staff", CFrame.new(635.61151123047, 73.096351623535, 917.81298828125)
        elseif PlayerLvl < 1100 then
            return "MarineQuest3", "Marine Lieutenant", CFrame.new(-2440.9934082031, 73.04190826416, -3217.7082519531)
        elseif PlayerLvl < 1175 then
            return "MarineQuest3", "Marine Captain", CFrame.new(-2440.9934082031, 73.04190826416, -3217.7082519531)
        elseif PlayerLvl < 1250 then
            return "FrostQuest", "Snow Lurker", CFrame.new(5668.1372070313, 28.202531814575, -6484.6005859375)
        elseif PlayerLvl < 1350 then
            return "FrostQuest", "Arctic Warrior", CFrame.new(5668.1372070313, 28.202531814575, -6484.6005859375)
        elseif PlayerLvl < 1425 then
            return "FireSideQuest", "Fire User", CFrame.new(-5428.03174, 15.0622921, -5299.43457)
        elseif PlayerLvl < 1500 then
            return "FireSideQuest", "Lava Pirate", CFrame.new(-5428.03174, 15.0622921, -5299.43457)
        elseif PlayerLvl < 1575 then
            return "ShipQuest1", "Ship Deckhand", CFrame.new(1037.80127, 125.092171, 32911.6016)         
        elseif PlayerLvl < 1625 then
            return "ShipQuest1", "Ship Engineer", CFrame.new(1037.80127, 125.092171, 32911.6016)
        elseif PlayerLvl < 1700 then
            return "ShipQuest1", "Ship Steward", CFrame.new(1037.80127, 125.092171, 32911.6016)
        elseif PlayerLvl < 1775 then
            return "ShipQuest2", "Ship Officer", CFrame.new(968.80957, 125.092171, 33244.125)
        elseif PlayerLvl < 1850 then
            return "FrostQuest", "Arctic Warrior", CFrame.new(5668.1372070313, 28.202531814575, -6484.6005859375)
        elseif PlayerLvl < 1925 then
            return "IceSideQuest", "Ice Admiral", CFrame.new(-6223.3521, 15.1699457, -5077.96143)
        else
            return "ForgottenQuest", "Mythological Pirate", CFrame.new(-3053.9814453125, 236.87213134766, -10145.0390625)
        end
    -- Third Sea Quests
    elseif GetCurrentSea() == "Third Sea" then
        if PlayerLvl < 2025 then
            return "PiratePortQuest", "Jungle Pirate", CFrame.new(-290.074677, 42.9034653, 5581.58984)
        elseif PlayerLvl < 2100 then
            return "PiratePortQuest", "Pirate Millionaire", CFrame.new(-290.074677, 42.9034653, 5581.58984)
        elseif PlayerLvl < 2150 then
            return "DressrosaQuest1", "Pirate Recruit", CFrame.new(8373.9, 29.3953, 76.0284)
        elseif PlayerLvl < 2200 then
            return "DressrosaQuest1", "Pistol Billionaire", CFrame.new(8373.9, 29.3953, 76.0284)
        elseif PlayerLvl < 2250 then
            return "DressrosaQuest2", "Beast Pirate", CFrame.new(-201.75, 379.5, 7224.66)
        elseif PlayerLvl < 2300 then
            return "DressrosaQuest2", "Cake Guard", CFrame.new(-201.75, 379.5, 7224.66)
        elseif PlayerLvl < 2350 then
            return "DressrosaQuest2", "Sweet Executive", CFrame.new(-201.75, 379.5, 7224.66)
        else
            return "CandyQuest1", "Candy Rebel", CFrame.new(-244.258, 226.015, -12202.2)
        end
    else
        return nil, nil, nil
    end
end

local function GetQuest()
    local QuestName, MobName, QuestCFrame = GetQuestLevel()
    
    if QuestName and MobName then
        -- Check if we already have this quest
        if Player.PlayerGui.Main.Quest.Visible then
            local CurrentQuest = Player.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
            if string.find(CurrentQuest, MobName) then
                return true
            end
        end
        
        -- Get the quest
        TeleportTo(QuestCFrame.Position)
        wait(1)
        
        local args = {
            [1] = "StartQuest",
            [2] = QuestName,
            [3] = 1
        }
        
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
        wait(0.5)
        
        return true
    end
    
    return false
end

local function GetMobByName(Name)
    for _, Mob in pairs(workspace.Enemies:GetChildren()) do
        if Mob:FindFirstChild("Humanoid") and Mob:FindFirstChild("HumanoidRootPart") and Mob.Humanoid.Health > 0 and string.find(Mob.Name, Name) then
            return Mob
        end
    end
    
    return nil
end

local function GetBoss(BossName)
    for _, Mob in pairs(workspace.Enemies:GetChildren()) do
        if Mob:FindFirstChild("Humanoid") and Mob:FindFirstChild("HumanoidRootPart") and Mob.Humanoid.Health > 0 and string.find(Mob.Name, BossName) then
            return Mob
        end
    end
    
    -- Check if boss spawn part exists
    for _, Part in pairs(workspace:GetChildren()) do
        if string.find(Part.Name, BossName) and Part:IsA("BasePart") then
            return Part
        end
    end
    
    -- Find boss by position
    for _, Boss in pairs(BossData[GetCurrentSea()]) do
        if string.find(Boss.Name, BossName) then
            return Boss.Position
        end
    end
    
    return nil
end

local function GetFruit()
    for _, Fruit in pairs(workspace:GetChildren()) do
        if string.find(Fruit.Name, "Fruit") and Fruit:IsA("Tool") then
            return Fruit
        end
    end
    
    return nil
end

local function GetMaterial(MaterialName)
    for _, Material in pairs(workspace:GetChildren()) do
        if string.find(Material.Name, MaterialName) and Material:IsA("BasePart") then
            return Material
        end
    end
    
    return nil
end

local function AutoFarmLevel()
    local _, MobName = GetQuestLevel()
    
    if not Player.PlayerGui.Main.Quest.Visible then
        GetQuest()
    else
        local Target = GetMobByName(MobName)
        
        if Target then
            TeleportTo(Target.HumanoidRootPart.Position + Vector3.new(0, Settings.AutoFarm.DistanceFromMob, 0))
            FastAttack()
        else
            -- Look for mob spawn area
            local QuestMobs = {}
            for _, Mob in pairs(workspace.Enemies:GetChildren()) do
                if string.find(Mob.Name, MobName) then
                    table.insert(QuestMobs, Mob)
                end
            end
            
            if #QuestMobs > 0 then
                local RandomMob = QuestMobs[math.random(1, #QuestMobs)]
                TeleportTo(RandomMob.HumanoidRootPart.Position + Vector3.new(0, 30, 0))
            end
        end
    end
end

local function AutoFarmBoss()
    local BossName = Settings.AutoFarm.TargetBoss
    local Boss = GetBoss(BossName)
    
    if Boss then
        if typeof(Boss) == "Vector3" then
            TeleportTo(Boss)
        elseif Boss:IsA("BasePart") then
            TeleportTo(Boss.Position)
        else
            TeleportTo(Boss.HumanoidRootPart.Position + Vector3.new(0, Settings.AutoFarm.DistanceFromMob, 0))
            FastAttack()
        end
    else
        ShowNotification("Auto Farm", "Boss not found. Waiting for spawn...", 3, "Warning")
        wait(5)
    end
end

local function AutoFarmFruit()
    local Fruit = GetFruit()
    
    if Fruit and Fruit:FindFirstChild("Handle") then
        TeleportTo(Fruit.Handle.Position)
        wait(1)
        
        -- Try to pick up the fruit
        local args = {
            [1] = "CollectFruit",
            [2] = Fruit.Name
        }
        
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    else
        -- Look around the map for fruits
        local RandomIsland = IslandLocations[GetCurrentSea()][math.random(1, #IslandLocations[GetCurrentSea()])]
        TeleportTo(RandomIsland.Position)
        wait(3)
    end
end

local function AutoFarmMaterial()
    local MaterialName = Settings.AutoFarm.TargetItem
    local Material = GetMaterial(MaterialName)
    
    if Material then
        TeleportTo(Material.Position)
        wait(1)
    else
        -- Look for mobs that might drop the material
        local TargetMob = nil
        
        if MaterialName == "Angel Wings" then
            TargetMob = "Royal Squad"
        elseif MaterialName == "Leather" then
            TargetMob = "Pirate"
        elseif MaterialName == "Scrap Metal" then
            TargetMob = "Brute"
        elseif MaterialName == "Demonic Wisp" then
            TargetMob = "Demonic Soul"
        elseif MaterialName == "Conjured Cocoa" then
            TargetMob = "Chocolate Bar Battler"
        elseif MaterialName == "Dragon Scale" then
            TargetMob = "Dragon"
        elseif MaterialName == "Gunpowder" then
            TargetMob = "Pistol"
        elseif MaterialName == "Fish Tail" then
            TargetMob = "Fishman"
        elseif MaterialName == "Magma Ore" then
            TargetMob = "Magma"
        elseif MaterialName == "Vampire Fang" then
            TargetMob = "Vampire"
        end
        
        if TargetMob then
            local Mob = GetMobByName(TargetMob)
            
            if Mob then
                TeleportTo(Mob.HumanoidRootPart.Position + Vector3.new(0, Settings.AutoFarm.DistanceFromMob, 0))
                FastAttack()
            else
                -- Go to a random island to look for mobs
                local RandomIsland = IslandLocations[GetCurrentSea()][math.random(1, #IslandLocations[GetCurrentSea()])]
                TeleportTo(RandomIsland.Position)
                wait(3)
            end
        else
            -- Go to a random island to look for materials
            local RandomIsland = IslandLocations[GetCurrentSea()][math.random(1, #IslandLocations[GetCurrentSea()])]
            TeleportTo(RandomIsland.Position)
            wait(3)
        end
    end
end

local function StartAutoFarm()
    if Settings.AutoFarm.Enabled and not PlayerConnections.AutoFarm then
        ShowNotification("Auto Farm", "Starting auto farm...", 3, "Success")
        
        PlayerConnections.AutoFarm = RunService.Stepped:Connect(function()
            if not Settings.AutoFarm.Enabled then
                PlayerConnections.AutoFarm:Disconnect()
                PlayerConnections.AutoFarm = nil
                DisableNoClip()
                return
            end
            
            -- Enable noclip for auto farm
            EnableNoClip()
            
            -- Auto equip weapon if enabled
            if Settings.AutoFarm.AutoEquipWeapon then
                local Weapon = Player.Backpack:FindFirstChildOfClass("Tool")
                if Weapon and not Character:FindFirstChildOfClass("Tool") then
                    Weapon.Parent = Character
                end
            end
            
            -- Choose farm type
            if Settings.AutoFarm.Type == "Level" then
                AutoFarmLevel()
            elseif Settings.AutoFarm.Type == "Boss" then
                AutoFarmBoss()
            elseif Settings.AutoFarm.Type == "Fruit" then
                AutoFarmFruit()
            elseif Settings.AutoFarm.Type == "Material" then
                AutoFarmMaterial()
            end
        end)
    else
        ShowNotification("Auto Farm", "Auto farm is already running!", 3, "Warning")
    end
end

local function StopAutoFarm()
    if PlayerConnections.AutoFarm then
        PlayerConnections.AutoFarm:Disconnect()
        PlayerConnections.AutoFarm = nil
        DisableNoClip()
        ShowNotification("Auto Farm", "Auto farm stopped", 3, "Info")
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
        PlayerConnections["ESP_" .. Target.Name .. HttpService:GenerateGUID(false)] = RunService.Heartbeat:Connect(function()
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
        PlayerConnections["ESP_Chest" .. HttpService:GenerateGUID(false)] = RunService.Heartbeat:Connect(function()
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
        PlayerConnections["ESP_Chest" .. HttpService:GenerateGUID(false)] = RunService.Heartbeat:Connect(function()
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
        PlayerConnections["ESP_Fruit" .. HttpService:GenerateGUID(false)] = RunService.Heartbeat:Connect(function()
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
            GUI.ESP.Name = "ESP"
            GUI.ESP.Parent = game.CoreGui
        else
            -- Clear existing ESP items
            GUI.ESP:ClearAllChildren()
        end
        
        -- Create player ESP
        if Settings.PVP.ESP.ShowPlayers then
            for _, Player in pairs(Players:GetPlayers()) do
                if Player ~= game.Players.LocalPlayer and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                    pcall(function()
                        CreateESPItem(Player, "Player")
                    end)
                end
            end
        end
        
        -- Create NPC ESP
        if Settings.PVP.ESP.ShowNPC then
            for _, NPC in pairs(workspace.Enemies:GetChildren()) do
                if NPC:FindFirstChild("Humanoid") and NPC:FindFirstChild("HumanoidRootPart") and NPC.Humanoid.Health > 0 then
                    pcall(function()
                        CreateESPItem(NPC, "NPC")
                    end)
                end
            end
        end
        
        -- Create Chest ESP
        if Settings.PVP.ESP.ShowChests then
            for _, Chest in pairs(workspace:GetChildren()) do
                if Chest.Name:find("Chest") and Chest:IsA("BasePart") then
                    pcall(function()
                        CreateESPItem(Chest, "Chest")
                    end)
                end
            end
        end
        
        -- Create connection to handle new players and NPCs
        PlayerConnections.PlayerESP = Players.PlayerAdded:Connect(function(Player)
            if Settings.PVP.ESP.ShowPlayers and Player ~= game.Players.LocalPlayer then
                Player.CharacterAdded:Connect(function(Character)
                    wait(1) -- Wait for HumanoidRootPart to be added
                    if Character:FindFirstChild("HumanoidRootPart") and Settings.PVP.ESP.Enabled then
                        pcall(function()
                            CreateESPItem(Player, "Player")
                        end)
                    end
                end)
            end
        end)
        
        PlayerConnections.NPCESP = workspace.Enemies.ChildAdded:Connect(function(NPC)
            if Settings.PVP.ESP.ShowNPC then
                wait(1) -- Wait for components to be added
                if NPC:FindFirstChild("Humanoid") and NPC:FindFirstChild("HumanoidRootPart") and Settings.PVP.ESP.Enabled then
                    pcall(function()
                        CreateESPItem(NPC, "NPC")
                    end)
                end
            end
        end)
        
        PlayerConnections.ChestESP = workspace.ChildAdded:Connect(function(Child)
            if Settings.PVP.ESP.ShowChests and Child.Name:find("Chest") and Child:IsA("BasePart") and Settings.PVP.ESP.Enabled then
                pcall(function()
                    CreateESPItem(Child, "Chest")
                end)
            end
            
            if Child.Name:find("Fruit") and Child:IsA("Tool") and Settings.PVP.ESP.Enabled then
                pcall(function()
                    CreateESPItem(Child, "Fruit")
                end)
            end
        end)
    else
        -- Disable ESP
        if GUI.ESP then
            GUI.ESP:ClearAllChildren()
        end
        
        -- Disconnect connections
        if PlayerConnections.PlayerESP then
            PlayerConnections.PlayerESP:Disconnect()
            PlayerConnections.PlayerESP = nil
        end
        
        if PlayerConnections.NPCESP then
            PlayerConnections.NPCESP:Disconnect()
            PlayerConnections.NPCESP = nil
        end
        
        if PlayerConnections.ChestESP then
            PlayerConnections.ChestESP:Disconnect()
            PlayerConnections.ChestESP = nil
        end
    end
end

-- Kill Aura Function
local function ToggleKillAura()
    if Settings.PVP.KillAura.Enabled and not PlayerConnections.KillAura then
        PlayerConnections.KillAura = RunService.Heartbeat:Connect(function()
            if not Settings.PVP.KillAura.Enabled then
                PlayerConnections.KillAura:Disconnect()
                PlayerConnections.KillAura = nil
                return
            end
            
            local TargetsFound = false
            
            -- Target players if enabled
            if Settings.PVP.KillAura.TargetPlayer then
                for _, Target in pairs(Players:GetPlayers()) do
                    if Target ~= Player and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") and Target.Character:FindFirstChild("Humanoid") and Target.Character.Humanoid.Health > 0 then
                        local Distance = GetDistance(HumanoidRootPart.Position, Target.Character.HumanoidRootPart.Position)
                        
                        if Distance <= Settings.PVP.KillAura.Range then
                            TargetsFound = true
                            FastAttack()
                            
                            -- Use selected skills
                            if Settings.PVP.KillAura.PreferredSkill == "Z" and Character:FindFirstChildOfClass("Tool") then
                                local args = {
                                    [1] = "Z"
                                }
                                game:GetService("ReplicatedStorage").RigControllerEvent:FireServer(unpack(args))
                            end
                        end
                    end
                end
            end
            
            -- Target NPCs if enabled
            if Settings.PVP.KillAura.TargetNPC then
                for _, Target in pairs(workspace.Enemies:GetChildren()) do
                    if Target:FindFirstChild("Humanoid") and Target:FindFirstChild("HumanoidRootPart") and Target.Humanoid.Health > 0 then
                        local Distance = GetDistance(HumanoidRootPart.Position, Target.HumanoidRootPart.Position)
                        
                        if Distance <= Settings.PVP.KillAura.Range then
                            TargetsFound = true
                            FastAttack()
                            
                            -- Use selected skills
                            if Settings.PVP.KillAura.PreferredSkill == "Z" and Character:FindFirstChildOfClass("Tool") then
                                local args = {
                                    [1] = "Z"
                                }
                                game:GetService("ReplicatedStorage").RigControllerEvent:FireServer(unpack(args))
                            end
                        end
                    end
                end
            end
        end)
    else
        if PlayerConnections.KillAura then
            PlayerConnections.KillAura:Disconnect()
            PlayerConnections.KillAura = nil
        end
    end
end

-- Server Functions
local function ServerHop()
    local Servers = {}
    local CurrentRegion = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("GetRegion")
    
    local function GetServerFromRegion(Region)
        local ServersAsset = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        
        for _, Server in pairs(ServersAsset.data) do
            if Server.playing and Server.playing < Server.maxPlayers and Server.id ~= game.JobId then
                table.insert(Servers, Server)
            end
        end
        
        -- Try to get more servers if first page is not enough
        if #Servers < 10 and ServersAsset.nextPageCursor then
            ServersAsset = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100&cursor=" .. ServersAsset.nextPageCursor))
            
            for _, Server in pairs(ServersAsset.data) do
                if Server.playing and Server.playing < Server.maxPlayers and Server.id ~= game.JobId then
                    table.insert(Servers, Server)
                end
            end
        end
        
        if #Servers > 0 then
            -- Try to join a server with few players first for less lag
            table.sort(Servers, function(a, b)
                return a.playing < b.playing
            end)
            
            for _, Server in pairs(Servers) do
                TeleportService:TeleportToPlaceInstance(game.PlaceId, Server.id, Player)
                wait(1)
            end
            
            -- If all preferred servers fail, try any server
            for _, Server in pairs(Servers) do
                TeleportService:TeleportToPlaceInstance(game.PlaceId, Server.id, Player)
                wait(1)
            end
        else
            ShowNotification("Server Hop", "No available servers found. Try again later.", 3, "Error")
        end
    end
    
    ShowNotification("Server Hop", "Looking for servers...", 3, "Info")
    GetServerFromRegion(CurrentRegion)
end

-- GUI Creation Function
local function CreateMainGUI()
    -- Create main GUI elements
    local WirtzScript = Instance.new("ScreenGui")
    WirtzScript.Name = "WirtzScript"
    WirtzScript.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    WirtzScript.ResetOnSpawn = false
    
    -- Try to use CoreGui for better persistence
    local success, error = pcall(function()
        WirtzScript.Parent = game:GetService("CoreGui")
    end)
    
    if not success then
        WirtzScript.Parent = Player:WaitForChild("PlayerGui")
    end
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -350, 0.5, -225)
    MainFrame.Size = UDim2.new(0, 700, 0, 450)
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = WirtzScript
    
    local OriginalSize = MainFrame.Size
    local Minimized = false
    
    -- Add rounded corners
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = MainFrame
    
    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TopBar.BorderSizePixel = 0
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.Parent = MainFrame
    
    -- Rounded corners for top bar with fix for bottom corners
    local UICorner_TopBar = Instance.new("UICorner")
    UICorner_TopBar.CornerRadius = UDim.new(0, 10)
    UICorner_TopBar.Parent = TopBar
    
    local TopBarBottomCover = Instance.new("Frame")
    TopBarBottomCover.Name = "BottomCover"
    TopBarBottomCover.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TopBarBottomCover.BorderSizePixel = 0
    TopBarBottomCover.Position = UDim2.new(0, 0, 0.5, 0)
    TopBarBottomCover.Size = UDim2.new(1, 0, 0.5, 0)
    TopBarBottomCover.Parent = TopBar
    
    -- Title
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 15, 0, 5)
    TitleLabel.Size = UDim2.new(0, 200, 0, 30)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = "Wirtz Script Premium v" .. CurrentVersion
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 18
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TopBar
    
    -- Minimize button
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.BackgroundTransparency = 1
    MinimizeButton.Position = UDim2.new(1, -80, 0, 0)
    MinimizeButton.Size = UDim2.new(0, 40, 0, 40)
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Text = "−"
    MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeButton.TextSize = 25
    MinimizeButton.Parent = TopBar
    
    -- Close button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(1, -40, 0, 0)
    CloseButton.Size = UDim2.new(0, 40, 0, 40)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Color3.fromRGB(255, 0, 0)
    CloseButton.TextSize = 25
    CloseButton.Parent = TopBar
    
    -- Main Content Divider
    local ContentHolder = Instance.new("Frame")
    ContentHolder.Name = "ContentHolder"
    ContentHolder.BackgroundTransparency = 1
    ContentHolder.Position = UDim2.new(0, 0, 0, 40)
    ContentHolder.Size = UDim2.new(1, 0, 1, -40)
    ContentHolder.Parent = MainFrame
    
    -- Tab Buttons Area
    local TabButtons = Instance.new("Frame")
    TabButtons.Name = "TabButtons"
    TabButtons.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TabButtons.BorderSizePixel = 0
    TabButtons.Position = UDim2.new(0, 10, 0, 10)
    TabButtons.Size = UDim2.new(0, 150, 1, -20)
    TabButtons.Parent = ContentHolder
    
    local UICorner_TabButtons = Instance.new("UICorner")
    UICorner_TabButtons.CornerRadius = UDim.new(0, 8)
    UICorner_TabButtons.Parent = TabButtons
    
    -- Make tab buttons scrollable
    local TabButtonsScroll = Instance.new("ScrollingFrame")
    TabButtonsScroll.Name = "TabButtonsScroll"
    TabButtonsScroll.BackgroundTransparency = 1
    TabButtonsScroll.Position = UDim2.new(0, 0, 0, 0)
    TabButtonsScroll.Size = UDim2.new(1, 0, 1, 0)
    TabButtonsScroll.CanvasSize = UDim2.new(0, 0, 0, 0) -- Will be adjusted based on content
    TabButtonsScroll.ScrollBarThickness = 4
    TabButtonsScroll.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
    TabButtonsScroll.Parent = TabButtons
    
    -- Add padding and layout
    local TabButtonsPadding = Instance.new("UIPadding")
    TabButtonsPadding.PaddingTop = UDim.new(0, 10)
    TabButtonsPadding.PaddingLeft = UDim.new(0, 10)
    TabButtonsPadding.PaddingRight = UDim.new(0, 10)
    TabButtonsPadding.PaddingBottom = UDim.new(0, 10)
    TabButtonsPadding.Parent = TabButtonsScroll
    
    local TabButtonsList = Instance.new("UIListLayout")
    TabButtonsList.Padding = UDim.new(0, 8)
    TabButtonsList.SortOrder = Enum.SortOrder.LayoutOrder
    TabButtonsList.Parent = TabButtonsScroll
    
    -- Tab Content Area
    local TabContent = Instance.new("Frame")
    TabContent.Name = "TabContent"
    TabContent.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TabContent.BorderSizePixel = 0
    TabContent.Position = UDim2.new(0, 170, 0, 10)
    TabContent.Size = UDim2.new(1, -180, 1, -20)
    TabContent.Parent = ContentHolder
    
    local UICorner_TabContent = Instance.new("UICorner")
    UICorner_TabContent.CornerRadius = UDim.new(0, 8)
    UICorner_TabContent.Parent = TabContent
    
    -- Button functionality
    MinimizeButton.MouseButton1Click:Connect(function()
        Minimized = not Minimized
        
        if Minimized then
            MainFrame:TweenSize(UDim2.new(0, MainFrame.Size.X.Offset, 0, TopBar.Size.Y.Offset), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.5, true)
        else
            MainFrame:TweenSize(OriginalSize, Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.5, true)
        end
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        WirtzScript:Destroy()
        
        -- Clean up connections
        for _, Connection in pairs(PlayerConnections) do
            if typeof(Connection) == "RBXScriptConnection" then
                Connection:Disconnect()
            end
        end
        PlayerConnections = {}
    end)
    
    -- Store important GUI elements for later access
    GUI.MainFrame = MainFrame
    GUI.TabButtons = TabButtons
    GUI.TabContent = TabContent
    GUI.MinimizeButton = MinimizeButton
    GUI.TopBar = TopBar
    
    -- Tab and Sections
    local Tabs = {}
    local TabObjects = {}
    local CurrentTab = nil
    
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
                ToggleCircle:TweenPosition(UDim2.new(0, 27, 0.5, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.2, true)
            else
                ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                ToggleCircle:TweenPosition(UDim2.new(0, 5, 0.5, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.2, true)
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
        ValueLabel.Text = tostring(Default or Min)
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
        SliderKnob.Position = UDim2.new(1, 0, 0.5, 0)
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
            SliderFill:TweenSize(UDim2.new(Percent, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.2, true)
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
        Dropdown.Size = UDim2.new(1, 0, 0, 70) -- Initial size, will adjust
        Dropdown.ClipsDescendants = true
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
        DropdownButton.AutoButtonColor = false
        DropdownButton.Parent = Dropdown
        
        local UICorner_DropdownButton = Instance.new("UICorner")
        UICorner_DropdownButton.CornerRadius = UDim.new(0, 6)
        UICorner_DropdownButton.Parent = DropdownButton
        
        local DropdownArrow = Instance.new("TextLabel")
        DropdownArrow.Name = "Arrow"
        DropdownArrow.BackgroundTransparency = 1
        DropdownArrow.Position = UDim2.new(1, -25, 0, 0)
        DropdownArrow.Size = UDim2.new(0, 20, 0, 30)
        DropdownArrow.Font = Enum.Font.GothamBold
        DropdownArrow.Text = "▼"
        DropdownArrow.TextColor3 = Color3.fromRGB(255, 255, 255)
        DropdownArrow.TextSize = 14
        DropdownArrow.Parent = DropdownButton
        
        local OptionsFrame = Instance.new("Frame")
        OptionsFrame.Name = "Options"
        OptionsFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        OptionsFrame.Position = UDim2.new(0, 0, 0, 60)
        OptionsFrame.Size = UDim2.new(1, 0, 0, 0) -- Will be adjusted
        OptionsFrame.Visible = false
        OptionsFrame.Parent = Dropdown
        
        local UICorner_OptionsFrame = Instance.new("UICorner")
        UICorner_OptionsFrame.CornerRadius = UDim.new(0, 6)
        UICorner_OptionsFrame.Parent = OptionsFrame
        
        local OptionsList = Instance.new("UIListLayout")
        OptionsList.Padding = UDim.new(0, 2)
        OptionsList.SortOrder = Enum.SortOrder.LayoutOrder
        OptionsList.Parent = OptionsFrame
        
        -- Add options
        for i, Option in ipairs(Options) do
            local OptionButton = Instance.new("TextButton")
            OptionButton.Name = Option
            OptionButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            OptionButton.BackgroundTransparency = 1
            OptionButton.Size = UDim2.new(1, 0, 0, 30)
            OptionButton.Font = Enum.Font.Gotham
            OptionButton.Text = Option
            OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            OptionButton.TextSize = 14
            OptionButton.AutoButtonColor = false
            OptionButton.Parent = OptionsFrame
            
            -- Hover effect
            OptionButton.MouseEnter:Connect(function()
                OptionButton.BackgroundTransparency = 0.5
            end)
            
            OptionButton.MouseLeave:Connect(function()
                OptionButton.BackgroundTransparency = 1
            end)
            
            -- Click to select
            OptionButton.MouseButton1Click:Connect(function()
                DropdownButton.Text = Option
                OptionsFrame.Visible = false
                Dropdown.Size = UDim2.new(1, 0, 0, 60)
                DropdownArrow.Text = "▼"
                
                if Callback then
                    Callback(Option)
                end
            end)
        end
        
        -- Adjust options frame size
        OptionsList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            OptionsFrame.Size = UDim2.new(1, 0, 0, OptionsList.AbsoluteContentSize.Y)
        end)
        
        -- Toggle dropdown
        local DropdownOpen = false
        
        DropdownButton.MouseButton1Click:Connect(function()
            DropdownOpen = not DropdownOpen
            OptionsFrame.Visible = DropdownOpen
            
            if DropdownOpen then
                DropdownArrow.Text = "▲"
                Dropdown.Size = UDim2.new(1, 0, 0, 65 + OptionsFrame.Size.Y.Offset)
            else
                DropdownArrow.Text = "▼"
                Dropdown.Size = UDim2.new(1, 0, 0, 60)
            end
        end)
        
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
            end
        }
    end
    
    -- Function to create a button
    local function CreateButton(Parent, Text, Callback)
        local Button = Instance.new("TextButton")
        Button.Name = Text .. "Button"
        Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        Button.BorderSizePixel = 0
        Button.Size = UDim2.new(1, 0, 0, 36)
        Button.Font = Enum.Font.GothamSemibold
        Button.Text = Text
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.TextSize = 14
        Button.AutoButtonColor = false
        Button.Parent = Parent
        
        local UICorner_Button = Instance.new("UICorner")
        UICorner_Button.CornerRadius = UDim.new(0, 6)
        UICorner_Button.Parent = Button
        
        -- Hover and click effects
        Button.MouseEnter:Connect(function()
            Button:TweenBackgroundColor3(Color3.fromRGB(80, 80, 80), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.2, true)
        end)
        
        Button.MouseLeave:Connect(function()
            Button:TweenBackgroundColor3(Color3.fromRGB(60, 60, 60), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.2, true)
        end)
        
        Button.MouseButton1Down:Connect(function()
            Button:TweenBackgroundColor3(Color3.fromRGB(40, 40, 40), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.1, true)
        end)
        
        Button.MouseButton1Up:Connect(function()
            Button:TweenBackgroundColor3(Color3.fromRGB(80, 80, 80), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.1, true)
            
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
    GUI.NotificationContainer.Position = UDim2.new(1, -10, 0, 10)
    GUI.NotificationContainer.Size = UDim2.new(0, 250, 1, -20)
    GUI.NotificationContainer.Parent = WirtzScript
    
    -- Create tabs
    local MainTab = CreateTab("Main", "rbxassetid://4034483344")
    local AutoFarmTab = CreateTab("Auto Farm", "rbxassetid://4035936146")
    local TeleportTab = CreateTab("Teleport", "rbxassetid://4700684605")
    local RaidTab = CreateTab("Raid", "rbxassetid://4546784573")
    local PVPTab = CreateTab("PVP", "rbxassetid://4506900952")
    local FruitTab = CreateTab("Fruit", "rbxassetid://4276930769")
    local ShopTab = CreateTab("Shop", "rbxassetid://4034275796")
    local MiscTab = CreateTab("Misc", "rbxassetid://4034275726")
    local SettingsTab = CreateTab("Settings", "rbxassetid://3926307971")
    
    -- Select default tab
    MainTab.Button.MouseButton1Click:Fire()
    
    -- Main Tab Content
    local MainInfoSection = CreateSection(MainTab, "Information")
    
    local InfoText = Instance.new("TextLabel")
    InfoText.BackgroundTransparency = 1
    InfoText.Size = UDim2.new(1, 0, 0, 80)
    InfoText.Font = Enum.Font.Gotham
    InfoText.Text = "Welcome to Wirtz Script Premium v" .. CurrentVersion .. "\nCreated by Wirtz\n\nGame: " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
    InfoText.TextColor3 = Color3.fromRGB(255, 255, 255)
    InfoText.TextSize = 14
    InfoText.TextWrapped = true
    InfoText.TextXAlignment = Enum.TextXAlignment.Left
    InfoText.Parent = MainInfoSection
    
    local PlayerInfoSection = CreateSection(MainTab, "Player Info")
    
    local PlayerInfoText = Instance.new("TextLabel")
    PlayerInfoText.Name = "PlayerInfo"
    PlayerInfoText.BackgroundTransparency = 1
    PlayerInfoText.Size = UDim2.new(1, 0, 0, 120)
    PlayerInfoText.Font = Enum.Font.Gotham
    PlayerInfoText.Text = "Loading player info..."
    PlayerInfoText.TextColor3 = Color3.fromRGB(255, 255, 255)
    PlayerInfoText.TextSize = 14
    PlayerInfoText.TextWrapped = true
    PlayerInfoText.TextXAlignment = Enum.TextXAlignment.Left
    PlayerInfoText.Parent = PlayerInfoSection
    
    -- Update player info every 2 seconds
    spawn(function()
        while wait(2) do
            if PlayerInfoText and PlayerInfoText.Parent then
                local Level = GetPlayerLevel()
                local Beli = Player.Data.Beli.Value
                local Fragments = Player.Data.Fragments.Value
                local DevilFruit = ""
                
                if Player.Data.DevilFruit.Value ~= "" then
                    DevilFruit = Player.Data.DevilFruit.Value
                else
                    DevilFruit = "None"
                end
                
                local CurrentSea = GetCurrentSea()
                
                PlayerInfoText.Text = "Player: " .. Player.Name ..
                    "\nLevel: " .. Level ..
                    "\nBeli: " .. Beli ..
                    "\nFragments: " .. Fragments ..
                    "\nFruit: " .. DevilFruit ..
                    "\nCurrent Sea: " .. CurrentSea
            end
        end
    end)
    
    local QuickActionsSection = CreateSection(MainTab, "Quick Actions")
    
    local NoClipToggle = CreateToggle(QuickActionsSection, "No Clip", Settings.CharacterEnhancements.NoClip, function(Value)
        Settings.CharacterEnhancements.NoClip = Value
        
        if Value then
            EnableNoClip()
        else
            DisableNoClip()
        end
    end)
    
    local InfJumpToggle = CreateToggle(QuickActionsSection, "Infinite Jump", Settings.CharacterEnhancements.InfiniteJump, function(Value)
        Settings.CharacterEnhancements.InfiniteJump = Value
        
        if Value then
            EnableInfiniteJump()
        else
            DisableInfiniteJump()
        end
    end)
    
    local AutoHakiToggle = CreateToggle(QuickActionsSection, "Auto Buso Haki", Settings.CharacterEnhancements.AutoHaki, function(Value)
        Settings.CharacterEnhancements.AutoHaki = Value
        
        if Value then
            -- Start auto haki
            PlayerConnections.AutoHaki = RunService.Stepped:Connect(function()
                if not Player.Character:FindFirstChild("HasBuso") then
                    local args = {
                        [1] = "Buso"
                    }
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                end
            end)
        else
            -- Stop auto haki
            if PlayerConnections.AutoHaki then
                PlayerConnections.AutoHaki:Disconnect()
                PlayerConnections.AutoHaki = nil
            end
        end
    end)
    
    local WalkSpeedSlider = CreateSlider(QuickActionsSection, "Walk Speed", 16, 300, Settings.CharacterEnhancements.WalkSpeed, function(Value)
        Settings.CharacterEnhancements.WalkSpeed = Value
        UpdatePlayerSpeed()
    end)
    
    local JumpPowerSlider = CreateSlider(QuickActionsSection, "Jump Power", 50, 300, Settings.CharacterEnhancements.JumpPower, function(Value)
        Settings.CharacterEnhancements.JumpPower = Value
        UpdatePlayerJump()
    end)
    
    -- Auto Farm Tab
    local AutoFarmSection = CreateSection(AutoFarmTab, "Auto Farm Settings")
    
    local AutoFarmToggle = CreateToggle(AutoFarmSection, "Enable Auto Farm", Settings.AutoFarm.Enabled, function(Value)
        Settings.AutoFarm.Enabled = Value
        
        if Value then
            StartAutoFarm()
        else
            StopAutoFarm()
        end
    end)
    
    local AutoFarmTypeDropdown = CreateDropdown(AutoFarmSection, "Farm Type", {"Level", "Boss", "Fruit", "Material"}, Settings.AutoFarm.Type, function(Value)
        Settings.AutoFarm.Type = Value
    end)
    
    local TweenSpeedSlider = CreateSlider(AutoFarmSection, "Tween Speed", 50, 400, Settings.AutoFarm.TweenSpeed, function(Value)
        Settings.AutoFarm.TweenSpeed = Value
    end)
    
    local DistanceSlider = CreateSlider(AutoFarmSection, "Distance From Mob", 0, 20, Settings.AutoFarm.DistanceFromMob, function(Value)
        Settings.AutoFarm.DistanceFromMob = Value
    end)
    
    local AutoEquipToggle = CreateToggle(AutoFarmSection, "Auto Equip Weapon", Settings.AutoFarm.AutoEquipWeapon, function(Value)
        Settings.AutoFarm.AutoEquipWeapon = Value
    end)
    
    local SafeModeToggle = CreateToggle(AutoFarmSection, "Safe Mode", Settings.AutoFarm.SafeMode, function(Value)
        Settings.AutoFarm.SafeMode = Value
    end)
    
    local HopIfLagToggle = CreateToggle(AutoFarmSection, "Hop If Server Lags", Settings.AutoFarm.HopIfServerLags, function(Value)
        Settings.AutoFarm.HopIfServerLags = Value
    end)
    
    -- Boss Farm Section
    local BossFarmSection = CreateSection(AutoFarmTab, "Boss Farm")
    
    -- Get available bosses for current sea
    local AvailableBosses = {}
    for _, Boss in pairs(BossData[GetCurrentSea()]) do
        table.insert(AvailableBosses, Boss.Name)
    end
    
    local BossDropdown = CreateDropdown(BossFarmSection, "Select Boss", AvailableBosses, Settings.AutoFarm.TargetBoss, function(Value)
        Settings.AutoFarm.TargetBoss = Value
    end)
    
    CreateButton(BossFarmSection, "Teleport To Boss", function()
        local Boss = GetBoss(Settings.AutoFarm.TargetBoss)
        
        if Boss then
            if typeof(Boss) == "Vector3" then
                TeleportTo(Boss)
            elseif Boss:IsA("BasePart") then
                TeleportTo(Boss.Position)
            else
                TeleportTo(Boss.HumanoidRootPart.Position)
            end
            
            ShowNotification("Teleport", "Teleported to " .. Settings.AutoFarm.TargetBoss, 3, "Success")
        else
            ShowNotification("Teleport", "Boss not found or not spawned", 3, "Error")
        end
    end)
    
    CreateButton(BossFarmSection, "Start Boss Farm", function()
        Settings.AutoFarm.Type = "Boss"
        Settings.AutoFarm.Enabled = true
        StartAutoFarm()
    end)
    
    -- Material Farm Section
    local MaterialFarmSection = CreateSection(AutoFarmTab, "Material Farm")
    
    local MaterialDropdown = CreateDropdown(MaterialFarmSection, "Select Material", {"Angel Wings", "Leather", "Scrap Metal", "Demonic Wisp", "Conjured Cocoa", "Dragon Scale", "Gunpowder", "Fish Tail", "Magma Ore", "Vampire Fang"}, Settings.AutoFarm.TargetItem, function(Value)
        Settings.AutoFarm.TargetItem = Value
    end)
    
    CreateButton(MaterialFarmSection, "Start Material Farm", function()
        Settings.AutoFarm.Type = "Material"
        Settings.AutoFarm.Enabled = true
        StartAutoFarm()
    end)
    
    -- Teleport Tab
    local IslandSection = CreateSection(TeleportTab, "Islands")
    
    local SeaLocations = IslandLocations[GetCurrentSea()]
    local IslandNames = {}
    
    for _, Island in pairs(SeaLocations) do
        table.insert(IslandNames, Island.Name)
    end
    
    local IslandDropdown = CreateDropdown(IslandSection, "Select Island", IslandNames, Settings.Teleportation.SelectedIsland, function(Value)
        Settings.Teleportation.SelectedIsland = Value
    end)
    
    local TeleportMethodDropdown = CreateDropdown(IslandSection, "Teleport Method", {"Instant", "Tween"}, Settings.Teleportation.TeleportMethod, function(Value)
        Settings.Teleportation.TeleportMethod = Value
    end)
    
    CreateButton(IslandSection, "Teleport To Island", function()
        for _, Island in pairs(SeaLocations) do
            if Island.Name == Settings.Teleportation.SelectedIsland then
                TeleportTo(Island.Position, Settings.Teleportation.TeleportMethod)
                ShowNotification("Teleport", "Teleported to " .. Island.Name, 3, "Success")
                break
            end
        end
    end)
    
    local SeaSection = CreateSection(TeleportTab, "Sea Travel")
    
    local CurrentSeaLabel = Instance.new("TextLabel")
    CurrentSeaLabel.BackgroundTransparency = 1
    CurrentSeaLabel.Size = UDim2.new(1, 0, 0, 30)
    CurrentSeaLabel.Font = Enum.Font.Gotham
    CurrentSeaLabel.Text = "Current Sea: " .. GetCurrentSea()
    CurrentSeaLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    CurrentSeaLabel.TextSize = 14
    CurrentSeaLabel.Parent = SeaSection
    
    CreateButton(SeaSection, "Travel to First Sea", function()
        local args = {
            [1] = "TravelMain"
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    end)
    
    CreateButton(SeaSection, "Travel to Second Sea", function()
        local args = {
            [1] = "TravelDressrosa"
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    end)
    
    CreateButton(SeaSection, "Travel to Third Sea", function()
        local args = {
            [1] = "TravelZou"
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    end)
    
    -- Raid Tab
    local RaidSection = CreateSection(RaidTab, "Auto Raid")
    
    local RaidToggle = CreateToggle(RaidSection, "Auto Raid", Settings.AutoRaid.Enabled, function(Value)
        Settings.AutoRaid.Enabled = Value
        ToggleAutoRaid()
    end)
    
    local RaidTypes = {"Flame", "Ice", "Quake", "Light", "Dark", "String", "Rumble", "Magma", "Human: Buddha", "Sand", "Bird: Phoenix", "Dough"}
    
    local RaidTypeDropdown = CreateDropdown(RaidSection, "Select Raid", RaidTypes, Settings.AutoRaid.SelectedRaids[1], function(Value)
        Settings.AutoRaid.SelectedRaids = {Value}
    end)
    
    local BuyChipToggle = CreateToggle(RaidSection, "Auto Buy Microchip", Settings.AutoRaid.AutoBuyMicrochip, function(Value)
        Settings.AutoRaid.AutoBuyMicrochip = Value
    end)
    
    local RaidModeDropdown = CreateDropdown(RaidSection, "Raid Mode", {"Normal", "Hub", "Hop"}, Settings.AutoRaid.RaidMode, function(Value)
        Settings.AutoRaid.RaidMode = Value
    end)
    
    local FruitStorage = CreateSection(RaidTab, "Devil Fruit Storage")
    
    local EatFruitsToggle = CreateToggle(FruitStorage, "Auto Eat Fruits", Settings.AutoRaid.EatFruits, function(Value)
        Settings.AutoRaid.EatFruits = Value
    end)
    
    local PreserveFruitsLabel = Instance.new("TextLabel")
    PreserveFruitsLabel.BackgroundTransparency = 1
    PreserveFruitsLabel.Size = UDim2.new(1, 0, 0, 30)
    PreserveFruitsLabel.Font = Enum.Font.Gotham
    PreserveFruitsLabel.Text = "Preserved Fruits (will not be eaten):"
    PreserveFruitsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    PreserveFruitsLabel.TextSize = 14
    PreserveFruitsLabel.TextXAlignment = Enum.TextXAlignment.Left
    PreserveFruitsLabel.Parent = FruitStorage
    
    local PreserveFruits = {"Dragon", "Dough", "Leopard", "Venom"}
    
    for _, Fruit in pairs(PreserveFruits) do
        CreateToggle(FruitStorage, Fruit, table.find(Settings.AutoRaid.StoreSpecificFruits, Fruit) ~= nil, function(Value)
            if Value then
                table.insert(Settings.AutoRaid.StoreSpecificFruits, Fruit)
            else
                for i, StoredFruit in pairs(Settings.AutoRaid.StoreSpecificFruits) do
                    if StoredFruit == Fruit then
                        table.remove(Settings.AutoRaid.StoreSpecificFruits, i)
                        break
                    end
                end
            end
        end)
    end
    
    -- PVP Tab
    local KillAuraSection = CreateSection(PVPTab, "Kill Aura")
    
    local KillAuraToggle = CreateToggle(KillAuraSection, "Enable Kill Aura", Settings.PVP.KillAura.Enabled, function(Value)
        Settings.PVP.KillAura.Enabled = Value
        ToggleKillAura()
    end)
    
    local KillAuraRangeSlider = CreateSlider(KillAuraSection, "Range", 5, 50, Settings.PVP.KillAura.Range, function(Value)
        Settings.PVP.KillAura.Range = Value
    end)
    
    local TargetPlayerToggle = CreateToggle(KillAuraSection, "Target Players", Settings.PVP.KillAura.TargetPlayer, function(Value)
        Settings.PVP.KillAura.TargetPlayer = Value
    end)
    
    local TargetNPCToggle = CreateToggle(KillAuraSection, "Target NPCs", Settings.PVP.KillAura.TargetNPC, function(Value)
        Settings.PVP.KillAura.TargetNPC = Value
    end)
    
    local PreferredSkillDropdown = CreateDropdown(KillAuraSection, "Preferred Skill", {"Z", "X", "C", "V", "F"}, Settings.PVP.KillAura.PreferredSkill, function(Value)
        Settings.PVP.KillAura.PreferredSkill = Value
    end)
    
    local ESPSection = CreateSection(PVPTab, "ESP")
    
    local ESPToggle = CreateToggle(ESPSection, "Enable ESP", Settings.PVP.ESP.Enabled, function(Value)
        Settings.PVP.ESP.Enabled = Value
        ToggleESP()
    end)
    
    local ESPPlayersToggle = CreateToggle(ESPSection, "Show Players", Settings.PVP.ESP.ShowPlayers, function(Value)
        Settings.PVP.ESP.ShowPlayers = Value
        if Settings.PVP.ESP.Enabled then
            ToggleESP() -- Refresh ESP
        end
    end)
    
    local ESPNPCToggle = CreateToggle(ESPSection, "Show NPCs", Settings.PVP.ESP.ShowNPC, function(Value)
        Settings.PVP.ESP.ShowNPC = Value
        if Settings.PVP.ESP.Enabled then
            ToggleESP() -- Refresh ESP
        end
    end)
    
    local ESPChestsToggle = CreateToggle(ESPSection, "Show Chests", Settings.PVP.ESP.ShowChests, function(Value)
        Settings.PVP.ESP.ShowChests = Value
        if Settings.PVP.ESP.Enabled then
            ToggleESP() -- Refresh ESP
        end
    end)
    
    -- Fruit Tab
    local FruitFinderSection = CreateSection(FruitTab, "Fruit Finder")
    
    local FruitFinderToggle = CreateToggle(FruitFinderSection, "Enable Fruit Finder", Settings.Miscellaneous.FruitFinder.Enabled, function(Value)
        Settings.Miscellaneous.FruitFinder.Enabled = Value
        
        if Value then
            PlayerConnections.FruitFinder = RunService.Heartbeat:Connect(function()
                if not Settings.Miscellaneous.FruitFinder.Enabled then
                    PlayerConnections.FruitFinder:Disconnect()
                    PlayerConnections.FruitFinder = nil
                    return
                end
                
                local Fruit = GetFruit()
                if Fruit and Fruit:FindFirstChild("Handle") then
                    local IsRare, RarityType = IsRareFruit(Fruit.Name)
                    
                    if Settings.Miscellaneous.FruitFinder.Notify then
                        ShowNotification("Fruit Found", Fruit.Name .. " found!\nRarity: " .. RarityType, 5, IsRare and "Warning" or "Info")
                        
                        -- Send webhook if enabled and it's a rare fruit
                        if Settings.Webhooks.Enabled and Settings.Webhooks.NotifyOnRareFruit and IsRare then
                            SendWebhook(
                                "Rare Fruit Found",
                                "A rare fruit has been found in your server!",
                                65280, -- Green color
                                {
                                    {name = "Fruit Name", value = Fruit.Name, inline = true},
                                    {name = "Rarity", value = RarityType, inline = true},
                                    {name = "Server", value = game.JobId, inline = false}
                                }
                            )
                        end
                    end
                    
                    if Settings.Miscellaneous.FruitFinder.AutoPickup then
                        TeleportTo(Fruit.Handle.Position)
                        wait(1)
                        
                        -- Try to pick up the fruit
                        local args = {
                            [1] = "CollectFruit",
                            [2] = Fruit.Name
                        }
                        
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                    end
                end
            end)
        else
            if PlayerConnections.FruitFinder then
                PlayerConnections.FruitFinder:Disconnect()
                PlayerConnections.FruitFinder = nil
            end
        end
    end)
    
    local AutoPickupToggle = CreateToggle(FruitFinderSection, "Auto Pickup Fruits", Settings.Miscellaneous.FruitFinder.AutoPickup, function(Value)
        Settings.Miscellaneous.FruitFinder.AutoPickup = Value
    end)
    
    local NotifyFruitsToggle = CreateToggle(FruitFinderSection, "Notify When Found", Settings.Miscellaneous.FruitFinder.Notify, function(Value)
        Settings.Miscellaneous.FruitFinder.Notify = Value
    end)
    
    local FruitShopSection = CreateSection(FruitTab, "Fruit Shop")
    
    -- Get all fruits from the shop
    local ShopFruits = {"Bomb-Bomb", "Spike-Spike", "Chop-Chop", "Spring-Spring", "Kilo-Kilo", "Smoke-Smoke", "Spin-Spin", "Flame-Flame", "Bird-Bird: Falcon", "Ice-Ice", "Sand-Sand", "Dark-Dark", "Diamond-Diamond", "Light-Light", "Love-Love", "Rubber-Rubber", "Barrier-Barrier", "Ghost-Ghost", "Magma-Magma", "Quake-Quake"}
    
    local FruitDropdown = CreateDropdown(FruitShopSection, "Select Fruit", ShopFruits, "", function(Value)
        -- Just store the selection
    end)
    
    CreateButton(FruitShopSection, "Buy Selected Fruit", function()
        local SelectedFruit = FruitDropdown.GetValue()
        if SelectedFruit ~= "" then
            local args = {
                [1] = "BuyFruit",
                [2] = SelectedFruit
            }
            
            local Success = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
            
            if Success then
                ShowNotification("Fruit Shop", "Successfully purchased " .. SelectedFruit, 3, "Success")
            else
                ShowNotification("Fruit Shop", "Failed to purchase " .. SelectedFruit, 3, "Error")
            end
        else
            ShowNotification("Fruit Shop", "Please select a fruit first", 3, "Warning")
        end
    end)
    
    CreateButton(FruitShopSection, "Random Fruit", function()
        local args = {
            [1] = "Cousin",
            [2] = "Buy"
        }
        
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    end)
    
    local StoreFruitSection = CreateSection(FruitTab, "Fruit Storage")
    
    CreateButton(StoreFruitSection, "Store Fruit", function()
        local args = {
            [1] = "StoreFruit",
            [2] = "Fruit Storage",
            [3] = game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Tool")
        }
        
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    end)
    
    CreateButton(StoreFruitSection, "Check Stored Fruits", function()
        local args = {
            [1] = "GetFruits"
        }
        
        local AllFruits = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
        local StoredFruits = ""
        
        for i, v in pairs(AllFruits) do
            if v.OnStore then
                StoredFruits = StoredFruits .. v.Name .. "\n"
            end
        end
        
        if StoredFruits ~= "" then
            ShowNotification("Stored Fruits", StoredFruits, 5, "Info")
        else
            ShowNotification("Stored Fruits", "No fruits in storage", 3, "Warning")
        end
    end)
    
    -- Shop Tab
    local FightingStyleSection = CreateSection(ShopTab, "Fighting Styles")
    
    local FightingStyles = {
        {Name = "Black Leg", Price = 150000, Arg = "BuyBlackLeg"},
        {Name = "Electro", Price = 550000, Arg = "BuyElectro"},
        {Name = "Fishman Karate", Price = 750000, Arg = "BuyFishmanKarate"},
        {Name = "Dragon Claw", Price = 1500000, Arg = "BlackbeardReward", Special = true},
        {Name = "Superhuman", Price = 3000000, Arg = "BuySuperhuman"},
        {Name = "Death Step", Price = 5000000, Arg = "BuyDeathStep"},
        {Name = "Sharkman Karate", Price = 5000000, Arg = "BuySharkmanKarate"},
        {Name = "Electric Claw", Price = 3000000, Arg = "BuyElectricClaw"},
        {Name = "Dragon Talon", Price = 3000000, Arg = "BuyDragonTalon"}
    }
    
    for _, Style in pairs(FightingStyles) do
        CreateButton(FightingStyleSection, Style.Name .. " ($" .. Style.Price .. ")", function()
            if Style.Special then
                ShowNotification("Fighting Style", Style.Name .. " requires special conditions", 3, "Warning")
            else
                local args = {
                    [1] = Style.Arg
                }
                
                local Success = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                
                if Success then
                    ShowNotification("Fighting Style", "Successfully purchased " .. Style.Name, 3, "Success")
                else
                    ShowNotification("Fighting Style", "Failed to purchase " .. Style.Name, 3, "Error")
                end
            end
        end)
    end
    
    local WeaponSection = CreateSection(ShopTab, "Weapons")
    
    local CommonWeapons = {
        {Name = "Cutlass", Price = 1000, Arg = "BuyItem", Item = "Cutlass"},
        {Name = "Katana", Price = 1000, Arg = "BuyItem", Item = "Katana"},
        {Name = "Iron Mace", Price = 25000, Arg = "BuyItem", Item = "Iron Mace"},
        {Name = "Dual Katana", Price = 12000, Arg = "BuyItem", Item = "Dual Katana"},
        {Name = "Triple Katana", Price = 60000, Arg = "BuyItem", Item = "Triple Katana"},
        {Name = "Pipe", Price = 100000, Arg = "BuyItem", Item = "Pipe"},
        {Name = "Dual-Headed Blade", Price = 400000, Arg = "BuyItem", Item = "Dual-Headed Blade"},
        {Name = "Bisento", Price = 1200000, Arg = "BuyItem", Item = "Bisento"},
        {Name = "Soul Cane", Price = 750000, Arg = "BuyItem", Item = "Soul Cane"}
    }
    
    for _, Weapon in pairs(CommonWeapons) do
        CreateButton(WeaponSection, Weapon.Name .. " ($" .. Weapon.Price .. ")", function()
            local args = {
                [1] = Weapon.Arg,
                [2] = Weapon.Item
            }
            
            local Success = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
            
            if Success then
                ShowNotification("Weapon Shop", "Successfully purchased " .. Weapon.Name, 3, "Success")
            else
                ShowNotification("Weapon Shop", "Failed to purchase " .. Weapon.Name, 3, "Error")
            end
        end)
    end
    
    local AbilitySection = CreateSection(ShopTab, "Abilities")
    
    local Abilities = {
        {Name = "Geppo", Price = 10000, Arg = "BuyHaki", Ability = "Geppo"},
        {Name = "Buso Haki", Price = 25000, Arg = "BuyHaki", Ability = "Buso"},
        {Name = "Soru", Price = 25000, Arg = "BuyHaki", Ability = "Soru"},
        {Name = "Observation Haki", Price = 750000, Arg = "BuyHaki", Ability = "Ken"},
        {Name = "Random Race", Price = 3000000, Arg = "BlackbeardReward", Special = true},
        {Name = "Reset Stats", Price = 2500000, Arg = "ResetStats"}
    }
    
    for _, Ability in pairs(Abilities) do
        CreateButton(AbilitySection, Ability.Name .. " ($" .. Ability.Price .. ")", function()
            if Ability.Special then
                ShowNotification("Ability Shop", Ability.Name .. " requires special conditions", 3, "Warning")
            else
                local args
                
                if Ability.Ability then
                    args = {
                        [1] = Ability.Arg,
                        [2] = Ability.Ability
                    }
                else
                    args = {
                        [1] = Ability.Arg
                    }
                end
                
                local Success = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                
                if Success then
                    ShowNotification("Ability Shop", "Successfully purchased " .. Ability.Name, 3, "Success")
                else
                    ShowNotification("Ability Shop", "Failed to purchase " .. Ability.Name, 3, "Error")
                end
            end
        end)
    end
    
    -- Misc Tab
    local ServerSection = CreateSection(MiscTab, "Server")
    
    CreateButton(ServerSection, "Server Hop", function()
        ServerHop()
    end)
    
    CreateButton(ServerSection, "Rejoin Server", function()
        TeleportService:Teleport(game.PlaceId, Player)
    end)
    
    local FastAttackSection = CreateSection(MiscTab, "Fast Attack")
    
    local FastAttackToggle = CreateToggle(FastAttackSection, "Enable Fast Attack", Settings.Miscellaneous.FastAttack.Enabled, function(Value)
        Settings.Miscellaneous.FastAttack.Enabled = Value
    end)
    
    local FastAttackSpeedSlider = CreateSlider(FastAttackSection, "Attack Speed", 1, 5, Settings.Miscellaneous.FastAttack.AttackSpeed, function(Value)
        Settings.Miscellaneous.FastAttack.AttackSpeed = Value
    end)
    
    local ChestFarmSection = CreateSection(MiscTab, "Chest Farm")
    
    local ChestFarmToggle = CreateToggle(ChestFarmSection, "Auto Collect Chests", Settings.Miscellaneous.ChestFarm, function(Value)
        Settings.Miscellaneous.ChestFarm = Value
        
        if Value then
            PlayerConnections.ChestFarm = RunService.Heartbeat:Connect(function()
                if not Settings.Miscellaneous.ChestFarm then
                    PlayerConnections.ChestFarm:Disconnect()
                    PlayerConnections.ChestFarm = nil
                    return
                end
                
                local ClosestChest = nil
                local ClosestDistance = math.huge
                
                for _, Chest in pairs(workspace:GetChildren()) do
                    if Chest.Name:find("Chest") and Chest:IsA("BasePart") then
                        local Distance = GetDistance(HumanoidRootPart.Position, Chest.Position)
                        
                        if Distance < ClosestDistance then
                            ClosestDistance = Distance
                            ClosestChest = Chest
                        end
                    end
                end
                
                if ClosestChest then
                    TeleportTo(ClosestChest.Position)
                    wait(1)
                    
                    -- Try to collect the chest by touching it
                    firetouchinterest(HumanoidRootPart, ClosestChest, 0)
                    wait(0.1)
                    firetouchinterest(HumanoidRootPart, ClosestChest, 1)
                else
                    -- No chests found, try a different location
                    local RandomIsland = IslandLocations[GetCurrentSea()][math.random(1, #IslandLocations[GetCurrentSea()])]
                    TeleportTo(RandomIsland.Position)
                    wait(3)
                end
            end)
        else
            if PlayerConnections.ChestFarm then
                PlayerConnections.ChestFarm:Disconnect()
                PlayerConnections.ChestFarm = nil
            end
        end
    end)
    
    -- Settings Tab
    local UISection = CreateSection(SettingsTab, "UI Settings")
    
    local ThemeDropdown = CreateDropdown(UISection, "Theme", {"Dark", "Light", "Ocean", "Blood", "Grape"}, Settings.UISettings.Theme, function(Value)
        Settings.UISettings.Theme = Value
        
        -- Apply theme changes
        if Value == "Dark" then
            MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            TopBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            TopBarBottomCover.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            TabButtons.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            TabContent.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        elseif Value == "Light" then
            MainFrame.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
            TopBar.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
            TopBarBottomCover.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
            TabButtons.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
            TabContent.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
            
            -- Update text colors
            TitleLabel.TextColor3 = Color3.fromRGB(30, 30, 30)
            MinimizeButton.TextColor3 = Color3.fromRGB(30, 30, 30)
        elseif Value == "Ocean" then
            MainFrame.BackgroundColor3 = Color3.fromRGB(20, 40, 60)
            TopBar.BackgroundColor3 = Color3.fromRGB(30, 60, 90)
            TopBarBottomCover.BackgroundColor3 = Color3.fromRGB(30, 60, 90)
            TabButtons.BackgroundColor3 = Color3.fromRGB(30, 60, 90)
            TabContent.BackgroundColor3 = Color3.fromRGB(30, 60, 90)
        elseif Value == "Blood" then
            MainFrame.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
            TopBar.BackgroundColor3 = Color3.fromRGB(90, 30, 30)
            TopBarBottomCover.BackgroundColor3 = Color3.fromRGB(90, 30, 30)
            TabButtons.BackgroundColor3 = Color3.fromRGB(90, 30, 30)
            TabContent.BackgroundColor3 = Color3.fromRGB(90, 30, 30)
        elseif Value == "Grape" then
            MainFrame.BackgroundColor3 = Color3.fromRGB(40, 20, 60)
            TopBar.BackgroundColor3 = Color3.fromRGB(60, 30, 90)
            TopBarBottomCover.BackgroundColor3 = Color3.fromRGB(60, 30, 90)
            TabButtons.BackgroundColor3 = Color3.fromRGB(60, 30, 90)
            TabContent.BackgroundColor3 = Color3.fromRGB(60, 30, 90)
        end
    end)
    
    local TransparencySlider = CreateSlider(UISection, "Transparency", 0, 0.9, Settings.UISettings.Transparency, function(Value)
        Settings.UISettings.Transparency = Value
        
        -- Apply transparency
        MainFrame.BackgroundTransparency = Value
        TopBar.BackgroundTransparency = Value
        TopBarBottomCover.BackgroundTransparency = Value
        TabButtons.BackgroundTransparency = Value
        TabContent.BackgroundTransparency = Value
    end)
    
    local SizeDropdown = CreateDropdown(UISection, "UI Size", {"Small", "Normal", "Large"}, Settings.UISettings.UISize, function(Value)
        Settings.UISettings.UISize = Value
        
        -- Apply size changes
        if Value == "Small" then
            MainFrame:TweenSize(UDim2.new(0, 600, 0, 400), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.5, true)
        elseif Value == "Normal" then
            MainFrame:TweenSize(UDim2.new(0, 700, 0, 450), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.5, true)
        elseif Value == "Large" then
            MainFrame:TweenSize(UDim2.new(0, 800, 0, 500), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.5, true)
        end
        
        OriginalSize = MainFrame.Size
    end)
    
    local WebhookSection = CreateSection(SettingsTab, "Webhook Settings")
    
    local WebhookToggle = CreateToggle(WebhookSection, "Enable Webhook", Settings.Webhooks.Enabled, function(Value)
        Settings.Webhooks.Enabled = Value
    end)
    
    local WebhookURLLabel = Instance.new("TextLabel")
    WebhookURLLabel.BackgroundTransparency = 1
    WebhookURLLabel.Size = UDim2.new(1, 0, 0, 20)
    WebhookURLLabel.Font = Enum.Font.Gotham
    WebhookURLLabel.Text = "Discord Webhook URL:"
    WebhookURLLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    WebhookURLLabel.TextSize = 14
    WebhookURLLabel.TextXAlignment = Enum.TextXAlignment.Left
    WebhookURLLabel.Parent = WebhookSection
    
    local WebhookURLBox = Instance.new("TextBox")
    WebhookURLBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    WebhookURLBox.BorderSizePixel = 0
    WebhookURLBox.Size = UDim2.new(1, 0, 0, 30)
    WebhookURLBox.Font = Enum.Font.Gotham
    WebhookURLBox.PlaceholderText = "Enter Discord webhook URL here..."
    WebhookURLBox.Text = Settings.Webhooks.URL
    WebhookURLBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    WebhookURLBox.TextSize = 14
    WebhookURLBox.Parent = WebhookSection
    
    local UICorner_WebhookURLBox = Instance.new("UICorner")
    UICorner_WebhookURLBox.CornerRadius = UDim.new(0, 6)
    UICorner_WebhookURLBox.Parent = WebhookURLBox
    
    WebhookURLBox.FocusLost:Connect(function()
        Settings.Webhooks.URL = WebhookURLBox.Text
    end)
    
    local NotifyRareFruitToggle = CreateToggle(WebhookSection, "Notify on Rare Fruit", Settings.Webhooks.NotifyOnRareFruit, function(Value)
        Settings.Webhooks.NotifyOnRareFruit = Value
    end)
    
    local NotifyLevelUpToggle = CreateToggle(WebhookSection, "Notify on Level Up", Settings.Webhooks.NotifyOnLevelUp, function(Value)
        Settings.Webhooks.NotifyOnLevelUp = Value
    end)
    
    local WebhookCooldownSlider = CreateSlider(WebhookSection, "Notification Cooldown (s)", 60, 600, Settings.Webhooks.NotifyCooldown, function(Value)
        Settings.Webhooks.NotifyCooldown = Value
    end)
    
    CreateButton(WebhookSection, "Test Webhook", function()
        if Settings.Webhooks.URL ~= "" then
            SendWebhook(
                "Webhook Test",
                "This is a test notification from Wirtz Script Premium",
                65280, -- Green color
                {
                    {name = "Player", value = Player.Name, inline = true},
                    {name = "Level", value = GetPlayerLevel(), inline = true},
                    {name = "Current Sea", value = GetCurrentSea(), inline = false}
                }
            )
            ShowNotification("Webhook", "Test notification sent!", 3, "Success")
        else
            ShowNotification("Webhook", "Please enter a webhook URL first", 3, "Error")
        end
    end)
    
    -- Credits Section
    local CreditsSection = CreateSection(SettingsTab, "Credits")
    
    local CreditsText = Instance.new("TextLabel")
    CreditsText.BackgroundTransparency = 1
    CreditsText.Size = UDim2.new(1, 0, 0, 60)
    CreditsText.Font = Enum.Font.Gotham
    CreditsText.Text = "Wirtz Script Premium v" .. CurrentVersion .. "\nCreated by Wirtz\n\nThanks for using Wirtz Script!"
    CreditsText.TextColor3 = Color3.fromRGB(255, 255, 255)
    CreditsText.TextSize = 14
    CreditsText.Parent = CreditsSection
    
    -- Show welcome notification
    ShowNotification("Wirtz Script Premium", "Script loaded successfully!\nVersion: " .. CurrentVersion .. "\nCreated by Wirtz", 5, "Success")
end

-- Initialize the script
local function Initialize()
    if IsExecuted then
        return
    end
    
    IsExecuted = true
    
    -- Create GUI
    CreateMainGUI()
    
    -- Set up anti-AFK
    local VirtualUser = game:GetService("VirtualUser")
    Player.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        wait(1)
        VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    end)
    
    -- Apply initial character enhancements
    UpdatePlayerSpeed()
    UpdatePlayerJump()
    
    if Settings.CharacterEnhancements.InfiniteJump then
        EnableInfiniteJump()
    end
    
    if Settings.CharacterEnhancements.NoClip then
        EnableNoClip()
    end
    
    -- Start auto features if enabled
    if Settings.AutoFarm.Enabled then
        StartAutoFarm()
    end
    
    if Settings.AutoRaid.Enabled then
        StartAutoRaid()
    end
    
    if Settings.PVP.KillAura.Enabled then
        ToggleKillAura()
    end
    
    if Settings.PVP.ESP.Enabled then
        ToggleESP()
    end
    
    -- Level up detection for webhook notifications
    local CurrentLevel = GetPlayerLevel()
    
    spawn(function()
        while wait(5) do
            local NewLevel = GetPlayerLevel()
            
            if NewLevel > CurrentLevel and Settings.Webhooks.Enabled and Settings.Webhooks.NotifyOnLevelUp then
                SendWebhook(
                    "Level Up",
                    Player.Name .. " has leveled up!",
                    16776960, -- Yellow color
                    {
                        {name = "Previous Level", value = CurrentLevel, inline = true},
                        {name = "New Level", value = NewLevel, inline = true},
                        {name = "Current Sea", value = GetCurrentSea(), inline = false}
                    }
                )
                
                CurrentLevel = NewLevel
            end
        end
    end)
end

-- Run the script
Initialize()