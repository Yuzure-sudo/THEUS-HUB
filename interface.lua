-- Serviços
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")

-- Variáveis principais
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Remove GUIs antigas
if CoreGui:FindFirstChild("THEUS_PREMIUM") then
    CoreGui:FindFirstChild("THEUS_PREMIUM"):Destroy()
end

-- Interface principal
local GUI = Instance.new("ScreenGui")
GUI.Name = "THEUS_PREMIUM"
GUI.Parent = CoreGui
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Frame principal
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Parent = GUI
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.Position = UDim2.new(0.5, -300, 0.5, -200)
Main.Size = UDim2.new(0, 600, 0, 400)
Main.Active = true
Main.Draggable = true

-- Arredondamento do frame principal
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = Main

-- Barra superior
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = Main
TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TopBar.Size = UDim2.new(1, 0, 0, 40)

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 10)
TopBarCorner.Parent = TopBar

-- Título
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "THEUS HUB PREMIUM"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Botão minimizar
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Parent = TopBar
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Position = UDim2.new(1, -40, 0, 5)
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 20

-- Container das tabs
local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Parent = Main
TabContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TabContainer.Position = UDim2.new(0, 10, 0, 50)
TabContainer.Size = UDim2.new(0, 150, 1, -60)

local TabContainerCorner = Instance.new("UICorner")
TabContainerCorner.CornerRadius = UDim.new(0, 10)
TabContainerCorner.Parent = TabContainer

-- Lista de tabs
local TabList = Instance.new("ScrollingFrame")
TabList.Name = "TabList"
TabList.Parent = TabContainer
TabList.Active = true
TabList.BackgroundTransparency = 1
TabList.Position = UDim2.new(0, 5, 0, 5)
TabList.Size = UDim2.new(1, -10, 1, -10)
TabList.ScrollBarThickness = 2

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Parent = TabList
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 5)

-- Área de conteúdo
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Parent = Main
ContentContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ContentContainer.Position = UDim2.new(0, 170, 0, 50)
ContentContainer.Size = UDim2.new(1, -180, 1, -60)

local ContentContainerCorner = Instance.new("UICorner")
ContentContainerCorner.CornerRadius = UDim.new(0, 10)
ContentContainerCorner.Parent = ContentContainer-- Funções da interface
local Library = {}
Library.Tabs = {}
Library.SelectedTab = nil

function Library:CreateTab(name)
    -- Botão da tab
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name
    TabButton.Parent = TabList
    TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TabButton.Size = UDim2.new(1, 0, 0, 35)
    TabButton.Font = Enum.Font.GothamSemibold
    TabButton.Text = name
    TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.TextSize = 14
    TabButton.AutoButtonColor = false

    local TabButtonCorner = Instance.new("UICorner")
    TabButtonCorner.CornerRadius = UDim.new(0, 6)
    TabButtonCorner.Parent = TabButton

    -- Conteúdo da tab
    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Name = name.."Content"
    TabContent.Parent = ContentContainer
    TabContent.BackgroundTransparency = 1
    TabContent.Size = UDim2.new(1, -10, 1, -10)
    TabContent.Position = UDim2.new(0, 5, 0, 5)
    TabContent.ScrollBarThickness = 2
    TabContent.Visible = false
    TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)

    local ContentPadding = Instance.new("UIPadding")
    ContentPadding.Parent = TabContent
    ContentPadding.PaddingLeft = UDim.new(0, 5)
    ContentPadding.PaddingRight = UDim.new(0, 5)
    ContentPadding.PaddingTop = UDim.new(0, 5)
    ContentPadding.PaddingBottom = UDim.new(0, 5)

    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.Parent = TabContent
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 5)

    ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 10)
    end)

    -- Sistema de seleção de tab
    TabButton.MouseButton1Click:Connect(function()
        if Library.SelectedTab then
            Library.SelectedTab.Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Library.SelectedTab.Content.Visible = false
        end
        Library.SelectedTab = {Button = TabButton, Content = TabContent}
        TabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        TabContent.Visible = true
    end)

    local TabFunctions = {}
    
    -- Criar toggle
    function TabFunctions:CreateToggle(name, callback)
        local Toggle = Instance.new("Frame")
        Toggle.Name = "Toggle"
        Toggle.Parent = TabContent
        Toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        Toggle.Size = UDim2.new(1, 0, 0, 40)

        local ToggleCorner = Instance.new("UICorner")
        ToggleCorner.CornerRadius = UDim.new(0, 6)
        ToggleCorner.Parent = Toggle

        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Name = "ToggleButton"
        ToggleButton.Parent = Toggle
        ToggleButton.BackgroundTransparency = 1
        ToggleButton.Size = UDim2.new(1, 0, 1, 0)
        ToggleButton.Font = Enum.Font.Gotham
        ToggleButton.Text = "    " .. name
        ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        ToggleButton.TextSize = 14
        ToggleButton.TextXAlignment = Enum.TextXAlignment.Left

        local ToggleIndicator = Instance.new("Frame")
        ToggleIndicator.Name = "Indicator"
        ToggleIndicator.Parent = Toggle
        ToggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        ToggleIndicator.Position = UDim2.new(1, -50, 0.5, -10)
        ToggleIndicator.Size = UDim2.new(0, 40, 0, 20)

        local IndicatorCorner = Instance.new("UICorner")
        IndicatorCorner.CornerRadius = UDim.new(0, 10)
        IndicatorCorner.Parent = ToggleIndicator

        local enabled = false
        ToggleButton.MouseButton1Click:Connect(function()
            enabled = not enabled
            ToggleIndicator.BackgroundColor3 = enabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
            callback(enabled)
        end)
    end

    -- Criar dropdown
    function TabFunctions:CreateDropdown(name, options, callback)
        local Dropdown = Instance.new("Frame")
        Dropdown.Name = "Dropdown"
        Dropdown.Parent = TabContent
        Dropdown.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        Dropdown.Size = UDim2.new(1, 0, 0, 40)

        local DropdownCorner = Instance.new("UICorner")
        DropdownCorner.CornerRadius = UDim.new(0, 6)
        DropdownCorner.Parent = Dropdown

        local DropdownButton = Instance.new("TextButton")
        DropdownButton.Name = "DropdownButton"
        DropdownButton.Parent = Dropdown
        DropdownButton.BackgroundTransparency = 1
        DropdownButton.Size = UDim2.new(1, 0, 1, 0)
        DropdownButton.Font = Enum.Font.Gotham
        DropdownButton.Text = "    " .. name
        DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        DropdownButton.TextSize = 14
        DropdownButton.TextXAlignment = Enum.TextXAlignment.Left

        local SelectedOption = Instance.new("TextLabel")
        SelectedOption.Name = "SelectedOption"
        SelectedOption.Parent = Dropdown
        SelectedOption.BackgroundTransparency = 1
        SelectedOption.Position = UDim2.new(1, -150, 0, 0)
        SelectedOption.Size = UDim2.new(0, 140, 1, 0)
        SelectedOption.Font = Enum.Font.Gotham
        SelectedOption.Text = options[1]
        SelectedOption.TextColor3 = Color3.fromRGB(200, 200, 200)
        SelectedOption.TextSize = 12
        SelectedOption.TextXAlignment = Enum.TextXAlignment.Right

        local OptionsFrame = Instance.new("Frame")
        OptionsFrame.Name = "Options"
        OptionsFrame.Parent = Dropdown
        OptionsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        OptionsFrame.Position = UDim2.new(0, 0, 1, 5)
        OptionsFrame.Size = UDim2.new(1, 0, 0, #options * 30)
        OptionsFrame.Visible = false
        OptionsFrame.ZIndex = 2

        local OptionsCorner = Instance.new("UICorner")
        OptionsCorner.CornerRadius = UDim.new(0, 6)
        OptionsCorner.Parent = OptionsFrame

        for i, option in ipairs(options) do
            local OptionButton = Instance.new("TextButton")
            OptionButton.Name = option
            OptionButton.Parent = OptionsFrame
            OptionButton.BackgroundTransparency = 1
            OptionButton.Position = UDim2.new(0, 0, 0, (i-1) * 30)
            OptionButton.Size = UDim2.new(1, 0, 0, 30)
            OptionButton.Font = Enum.Font.Gotham
            OptionButton.Text = "    " .. option
            OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            OptionButton.TextSize = 12
            OptionButton.TextXAlignment = Enum.TextXAlignment.Left
            OptionButton.ZIndex = 2

            OptionButton.MouseButton1Click:Connect(function()
                SelectedOption.Text = option
                OptionsFrame.Visible = false
                callback(option)
            end)
        end

        DropdownButton.MouseButton1Click:Connect(function()
            OptionsFrame.Visible = not OptionsFrame.Visible
        end)
    end

    -- Criar botão
    function TabFunctions:CreateButton(name, callback)
        local Button = Instance.new("Frame")
        Button.Name = "Button"
        Button.Parent = TabContent
        Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        Button.Size = UDim2.new(1, 0, 0, 40)

        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 6)
        ButtonCorner.Parent = Button

        local ButtonInstance = Instance.new("TextButton")
        ButtonInstance.Name = "ButtonInstance"
        ButtonInstance.Parent = Button
        ButtonInstance.BackgroundTransparency = 1
        ButtonInstance.Size = UDim2.new(1, 0, 1, 0)
        ButtonInstance.Font = Enum.Font.Gotham
        ButtonInstance.Text = "    " .. name
        ButtonInstance.TextColor3 = Color3.fromRGB(255, 255, 255)
        ButtonInstance.TextSize = 14
        ButtonInstance.TextXAlignment = Enum.TextXAlignment.Left

        ButtonInstance.MouseButton1Click:Connect(callback)
    end

    return TabFunctions
end-- Criar tabs principais
local MainTab = Library:CreateTab("Main")
local FarmTab = Library:CreateTab("Farm")
local CombatTab = Library:CreateTab("Combat")
local StatsTab = Library:CreateTab("Stats")
local RaidTab = Library:CreateTab("Raid")
local MiscTab = Library:CreateTab("Misc")
local TeleportTab = Library:CreateTab("Teleport")

-- Main Tab
MainTab:CreateToggle("Auto Farm", function(state)
    getgenv().AutoFarm = state
    if state then
        Functions.AutoFarm()
    end
end)

MainTab:CreateToggle("Auto Skills", function(state)
    getgenv().AutoSkills = state
    if state then
        Functions.AutoSkills()
    end
end)

MainTab:CreateToggle("Auto Chest", function(state)
    getgenv().AutoChest = state
    if state then
        Functions.AutoChest()
    end
end)

MainTab:CreateToggle("Auto Fruit", function(state)
    getgenv().AutoFruit = state
    if state then
        Functions.AutoFruit()
    end
end)

-- Farm Tab
FarmTab:CreateToggle("Auto Boss Farm", function(state)
    getgenv().AutoBossFarm = state
    if state then
        Functions.AutoBossFarm()
    end
end)

FarmTab:CreateToggle("Auto Quest", function(state)
    getgenv().AutoQuest = state
    if state then
        Functions.AutoQuest()
    end
end)

FarmTab:CreateToggle("Auto Collect All", function(state)
    getgenv().AutoCollectAll = state
    if state then
        Functions.AutoCollectAll()
    end
end)

FarmTab:CreateToggle("Rare Mob Farm", function(state)
    getgenv().RareMobFarm = state
    if state then
        Functions.RareMobFarm()
    end
end)

-- Combat Tab
CombatTab:CreateToggle("Kill Aura", function(state)
    getgenv().KillAura = state
    if state then
        Functions.KillAura()
    end
end)

CombatTab:CreateToggle("Auto Skill Combo", function(state)
    getgenv().AutoSkillCombo = state
    if state then
        Functions.AutoSkillCombo()
    end
end)

CombatTab:CreateToggle("Instant Kill", function(state)
    getgenv().InstantKill = state
    if state then
        Functions.InstantKill()
    end
end)

CombatTab:CreateToggle("Auto Dodge", function(state)
    getgenv().AutoDodge = state
    if state then
        Functions.AutoDodge()
    end
end)

-- Stats Tab
StatsTab:CreateDropdown("Select Stat", {"Melee", "Defense", "Sword", "Devil Fruit"}, function(selected)
    getgenv().StatType = selected
end)

StatsTab:CreateToggle("Auto Stats", function(state)
    getgenv().AutoStats = state
    if state then
        Functions.AutoStats()
    end
end)

StatsTab:CreateToggle("Auto Equip Best", function(state)
    getgenv().AutoEquipBest = state
    if state then
        Functions.AutoEquipBest()
    end
end)

StatsTab:CreateToggle("Auto Buffs", function(state)
    getgenv().AutoBuffs = state
    if state then
        Functions.AutoBuffs()
    end
end)

-- Raid Tab
RaidTab:CreateToggle("Auto Raid", function(state)
    getgenv().AutoRaid = state
    if state then
        Functions.AutoRaid()
    end
end)

RaidTab:CreateToggle("Auto Rebirth", function(state)
    getgenv().AutoRebirth = state
    if state then
        Functions.AutoRebirth()
    end
end)

-- Misc Tab
MiscTab:CreateToggle("Speed Hack", function(state)
    getgenv().SpeedHack = state
    if state then
        Functions.SpeedHack()
    end
end)

MiscTab:CreateToggle("Jump Hack", function(state)
    getgenv().JumpHack = state
    if state then
        Functions.JumpHack()
    end
end)

MiscTab:CreateToggle("Infinite Energy", function(state)
    getgenv().InfiniteEnergy = state
    if state then
        Functions.InfiniteEnergy()
    end
end)

MiscTab:CreateToggle("God Mode", function(state)
    getgenv().GodMode = state
    if state then
        Functions.GodMode()
    end
end)

-- Teleport Tab
TeleportTab:CreateButton("Safe Zone", function()
    Functions.SafeZone()
end)

TeleportTab:CreateButton("Server Hop", function()
    Functions.ServerHop()
end)

-- Sistema de minimizar
local minimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        Main:TweenSize(UDim2.new(0, 600, 0, 40), "Out", "Quad", 0.3, true)
    else
        Main:TweenSize(UDim2.new(0, 600, 0, 400), "Out", "Quad", 0.3, true)
    end
end)

-- Selecionar primeira tab por padrão
local firstTab = TabList:FindFirstChildWhichIsA("TextButton")
if firstTab then
    firstTab.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    ContentContainer:FindFirstChild(firstTab.Name.."Content").Visible = true
    Library.SelectedTab = {Button = firstTab, Content = ContentContainer:FindFirstChild(firstTab.Name.."Content")}
end

return Library