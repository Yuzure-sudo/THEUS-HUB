-- Primeiro a tela de carregamento
local LoadingScreen = Instance.new("ScreenGui")
LoadingScreen.Name = "LoadingScreen"
LoadingScreen.Parent = game:GetService("CoreGui")
LoadingScreen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Background = Instance.new("Frame")
Background.Name = "Background"
Background.Parent = LoadingScreen
Background.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Background.Position = UDim2.new(0, 0, 0, 0)
Background.Size = UDim2.new(1, 0, 1, 0)

local LogoImage = Instance.new("ImageLabel")
LogoImage.Name = "Logo"
LogoImage.Parent = Background
LogoImage.BackgroundTransparency = 1
LogoImage.Position = UDim2.new(0.5, -150, 0.5, -150)
LogoImage.Size = UDim2.new(0, 300, 0, 300)
LogoImage.Image = "rbxassetid://15157261880"

local TextLabel = Instance.new("TextLabel")
TextLabel.Parent = Background
TextLabel.BackgroundTransparency = 1
TextLabel.Position = UDim2.new(0.5, -100, 0.7, 0)
TextLabel.Size = UDim2.new(0, 200, 0, 50)
TextLabel.Font = Enum.Font.GothamBold
TextLabel.Text = "THEUS PREMIUM"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextSize = 24

local LoadingBar = Instance.new("Frame")
LoadingBar.Name = "LoadingBar"
LoadingBar.Parent = Background
LoadingBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
LoadingBar.BorderSizePixel = 0
LoadingBar.Position = UDim2.new(0.5, -150, 0.8, 0)
LoadingBar.Size = UDim2.new(0, 300, 0, 10)
LoadingBar.ClipsDescendants = true

local Fill = Instance.new("Frame")
Fill.Name = "Fill"
Fill.Parent = LoadingBar
Fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Fill.BorderSizePixel = 0
Fill.Size = UDim2.new(0, 0, 1, 0)

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 0, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 255))
})
UIGradient.Parent = Fill

-- Animação de carregamento
local TweenService = game:GetService("TweenService")
local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Linear)
local tween = TweenService:Create(Fill, tweenInfo, {Size = UDim2.new(1, 0, 1, 0)})
tween:Play()

local gradient = game:GetService("TweenService"):Create(UIGradient, TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1), {Offset = Vector2.new(1, 0)})
gradient:Play()

wait(3)
LoadingScreen:Destroy()

-- Agora a interface principal
local Library = {}

-- Criar ScreenGui principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TheusHub"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Frame principal
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Parent = ScreenGui
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Main.Position = UDim2.new(0.5, -300, 0.5, -200)
Main.Size = UDim2.new(0, 600, 0, 400)
Main.ClipsDescendants = true

-- Arredondamento do frame principal
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = Main

-- Barra superior
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = Main
TopBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TopBar.Size = UDim2.new(1, 0, 0, 40)

-- Arredondamento da barra superior
local UICorner_2 = Instance.new("UICorner")
UICorner_2.CornerRadius = UDim.new(0, 10)
UICorner_2.Parent = TopBar

-- Título
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "THEUS PREMIUM"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 22
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Logo na barra superior
local Logo = Instance.new("ImageLabel")
Logo.Name = "Logo"
Logo.Parent = TopBar
Logo.BackgroundTransparency = 1
Logo.Position = UDim2.new(0, 560, 0, 5)
Logo.Size = UDim2.new(0, 30, 0, 30)
Logo.Image = "rbxassetid://15157261880"

-- Botão de minimizar
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Parent = TopBar
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Position = UDim2.new(1, -70, 0, 0)
MinimizeBtn.Size = UDim2.new(0, 40, 1, 0)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 30

-- Container das tabs
local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Parent = Main
TabContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TabContainer.Position = UDim2.new(0, 0, 0, 40)
TabContainer.Size = UDim2.new(0, 150, 1, -40)

-- Arredondamento do container das tabs
local UICorner_3 = Instance.new("UICorner")
UICorner_3.CornerRadius = UDim.new(0, 10)
UICorner_3.Parent = TabContainer

-- Lista de tabs
local TabList = Instance.new("ScrollingFrame")
TabList.Name = "TabList"
TabList.Parent = TabContainer
TabList.Active = true
TabList.BackgroundTransparency = 1
TabList.Position = UDim2.new(0, 0, 0, 10)
TabList.Size = UDim2.new(1, 0, 1, -20)
TabList.ScrollBarThickness = 0
TabList.CanvasSize = UDim2.new(0, 0, 0, 0)

-- Layout da lista de tabs
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = TabList
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

-- Container do conteúdo
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Parent = Main
ContentContainer.BackgroundTransparency = 1
ContentContainer.Position = UDim2.new(0, 160, 0, 50)
ContentContainer.Size = UDim2.new(1, -170, 1, -60)

-- Funções da biblioteca
function Library:CreateTab(name)
    local tab = {}
    
    -- Botão da tab
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name.."Tab"
    TabButton.Parent = TabList
    TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TabButton.Size = UDim2.new(1, -10, 0, 40)
    TabButton.Font = Enum.Font.GothamSemibold
    TabButton.Text = name
    TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.TextSize = 14
    TabButton.AutoButtonColor = false
    
    -- Arredondamento do botão
    local UICorner_4 = Instance.new("UICorner")
    UICorner_4.CornerRadius = UDim.new(0, 8)
    UICorner_4.Parent = TabButton
    
    -- Container do conteúdo da tab
    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Name = name.."Content"
    TabContent.Parent = ContentContainer
    TabContent.Active = true
    TabContent.BackgroundTransparency = 1
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.ScrollBarThickness = 4
    TabContent.Visible = false
    
    -- Layout do conteúdo
    local UIListLayout_2 = Instance.new("UIListLayout")
    UIListLayout_2.Parent = TabContent
    UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout_2.Padding = UDim.new(0, 10)
    
    -- Padding do conteúdo
    local UIPadding = Instance.new("UIPadding")
    UIPadding.Parent = TabContent
    UIPadding.PaddingLeft = UDim.new(0, 10)
    UIPadding.PaddingTop = UDim.new(0, 10)
    
    -- Sistema de seleção de tabs
    TabButton.MouseButton1Click:Connect(function()
        if Library.SelectedTab then
            Library.SelectedTab.Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Library.SelectedTab.Content.Visible = false
        end
        Library.SelectedTab = {Button = TabButton, Content = TabContent}
        TabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        TabContent.Visible = true
    end)
    
    -- Funções da tab
    function tab:CreateToggle(text, callback)
        local toggle = {}
        
        -- Container do toggle
        local ToggleContainer = Instance.new("Frame")
        ToggleContainer.Name = "ToggleContainer"
        ToggleContainer.Parent = TabContent
        ToggleContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        ToggleContainer.Size = UDim2.new(1, -20, 0, 40)
        
        -- Arredondamento do container
        local UICorner_5 = Instance.new("UICorner")
        UICorner_5.CornerRadius = UDim.new(0, 8)
        UICorner_5.Parent = ToggleContainer
        
        -- Texto do toggle
        local ToggleText = Instance.new("TextLabel")
        ToggleText.Name = "ToggleText"
        ToggleText.Parent = ToggleContainer
        ToggleText.BackgroundTransparency = 1
        ToggleText.Position = UDim2.new(0, 15, 0, 0)
        ToggleText.Size = UDim2.new(1, -55, 1, 0)
        ToggleText.Font = Enum.Font.GothamSemibold
        ToggleText.Text = text
        ToggleText.TextColor3 = Color3.fromRGB(255, 255, 255)
        ToggleText.TextSize = 14
        ToggleText.TextXAlignment = Enum.TextXAlignment.Left
        
        -- Botão do toggle
        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Name = "ToggleButton"
        ToggleButton.Parent = ToggleContainer
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        ToggleButton.Position = UDim2.new(1, -40, 0.5, -10)
        ToggleButton.Size = UDim2.new(0, 20, 0, 20)
        ToggleButton.Font = Enum.Font.SourceSans
        ToggleButton.Text = ""
        ToggleButton.AutoButtonColor = false
        
        -- Arredondamento do botão
        local UICorner_6 = Instance.new("UICorner")
        UICorner_6.CornerRadius = UDim.new(0, 4)
        UICorner_6.Parent = ToggleButton
        
        -- Estado do toggle
        local enabled = false
        
        -- Função de clique
        ToggleButton.MouseButton1Click:Connect(function()
            enabled = not enabled
            ToggleButton.BackgroundColor3 = enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            if callback then
                callback(enabled)
            end
        end)
        
        return toggle
    end
    
    function tab:CreateDropdown(text, options, callback)
        local dropdown = {}
        
        -- Container do dropdown
        local DropdownContainer = Instance.new("Frame")
        DropdownContainer.Name = "DropdownContainer"
        DropdownContainer.Parent = TabContent
        DropdownContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        DropdownContainer.Size = UDim2.new(1, -20, 0, 40)
        
        -- Arredondamento do container
        local UICorner_7 = Instance.new("UICorner")
        UICorner_7.CornerRadius = UDim.new(0, 8)
        UICorner_7.Parent = DropdownContainer
        
        -- Texto do dropdown
        local DropdownText = Instance.new("TextLabel")
        DropdownText.Name = "DropdownText"
        DropdownText.Parent = DropdownContainer
        DropdownText.BackgroundTransparency = 1
        DropdownText.Position = UDim2.new(0, 15, 0, 0)
        DropdownText.Size = UDim2.new(1, -35, 1, 0)
        DropdownText.Font = Enum.Font.GothamSemibold
        DropdownText.Text = text
        DropdownText.TextColor3 = Color3.fromRGB(255, 255, 255)
        DropdownText.TextSize = 14
        DropdownText.TextXAlignment = Enum.TextXAlignment.Left
        
        -- Lista do dropdown
        local DropdownList = Instance.new("Frame")
        DropdownList.Name = "DropdownList"
        DropdownList.Parent = DropdownContainer
        DropdownList.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        DropdownList.Position = UDim2.new(0, 0, 1, 5)
        DropdownList.Size = UDim2.new(1, 0, 0, 0)
        DropdownList.Visible = false
        DropdownList.ClipsDescendants = true
        
        -- Arredondamento da lista
        local UICorner_8 = Instance.new("UICorner")
        UICorner_8.CornerRadius = UDim.new(0, 8)
        UICorner_8.Parent = DropdownList
        
        -- Layout da lista
        local UIListLayout_3 = Instance.new("UIListLayout")
        UIListLayout_3.Parent = DropdownList
        UIListLayout_3.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout_3.Padding = UDim.new(0, 5)
        
        -- Padding da lista
        local UIPadding_2 = Instance.new("UIPadding")
        UIPadding_2.Parent = DropdownList
        UIPadding_2.PaddingLeft = UDim.new(0, 5)
        UIPadding_2.PaddingRight = UDim.new(0, 5)
        UIPadding_2.PaddingTop = UDim.new(0, 5)
        UIPadding_2.PaddingBottom = UDim.new(0, 5)
        
        -- Estado do dropdown
        local open = false
        
        -- Adicionar opções
        for _, option in ipairs(options) do
            local OptionButton = Instance.new("TextButton")
            OptionButton.Name = option
            OptionButton.Parent = DropdownList
            OptionButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            OptionButton.Size = UDim2.new(1, 0, 0, 30)
            OptionButton.Font = Enum.Font.GothamSemibold
            OptionButton.Text = option
            OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            OptionButton.TextSize = 14
            
            -- Arredondamento da opção
            local UICorner_9 = Instance.new("UICorner")
            UICorner_9.CornerRadius = UDim.new(0, 6)
            UICorner_9.Parent = OptionButton
            
            -- Clique na opção
            OptionButton.MouseButton1Click:Connect(function()
                if callback then
                    callback(option)
                end
                DropdownText.Text = text..": "..option
                open = false
                DropdownList.Visible = false
                DropdownList:TweenSize(UDim2.new(1, 0, 0, 0), "Out", "Quad", 0.2, true)
            end)
        end
        
        -- Clique no dropdown
        DropdownContainer.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                open = not open
                if open then
                    DropdownList.Visible = true
                    DropdownList:TweenSize(UDim2.new(1, 0, 0, UIListLayout_3.AbsoluteContentSize.Y + 10), "Out", "Quad", 0.2, true)
                else
                    DropdownList:TweenSize(UDim2.new(1, 0, 0, 0), "Out", "Quad", 0.2, true)
                    wait(0.2)
                    DropdownList.Visible = false
                end
            end
        end)
        
        return dropdown
    end
    
    function tab:CreateButton(text, callback)
        local button = {}
        
        -- Container do botão
        local ButtonContainer = Instance.new("Frame")
        ButtonContainer.Name = "ButtonContainer"
        ButtonContainer.Parent = TabContent
        ButtonContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        ButtonContainer.Size = UDim2.new(1, -20, 0, 40)
        
        -- Arredondamento do container
        local UICorner_10 = Instance.new("UICorner")
        UICorner_10.CornerRadius = UDim.new(0, 8)
        UICorner_10.Parent = ButtonContainer
        
        -- Botão
        local Button = Instance.new("TextButton")
        Button.Name = "Button"
        Button.Parent = ButtonContainer
        Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        Button.Size = UDim2.new(1, 0, 1, 0)
        Button.Font = Enum.Font.GothamSemibold
        Button.Text = text
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.TextSize = 14
        Button.AutoButtonColor = false
        
        -- Arredondamento do botão
        local UICorner_11 = Instance.new("UICorner")
        UICorner_11.CornerRadius = UDim.new(0, 8)
        UICorner_11.Parent = Button
        
        -- Clique no botão
        Button.MouseButton1Click:Connect(function()
            if callback then
                callback()
            end
        end)
        
        -- Efeitos do botão
        Button.MouseEnter:Connect(function()
            Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end)
        
        Button.MouseLeave:Connect(function()
            Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        end)
        
        Button.MouseButton1Down:Connect(function()
            Button.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
        end)
        
        Button.MouseButton1Up:Connect(function()
            Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end)
        
        return button
    end
    
    return tab
end

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

-- Tornar a interface arrastável
local UserInputService = game:GetService("UserInputService")
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    Main:TweenPosition(UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y), "Out", "Quad", 0.1, true)
end

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

return Library
```

Para usar a interface, você pode criar as tabs e elementos assim:

```lua
-- Exemplo de uso
local Library = loadstring(game:HttpGet("SEU_LINK_AQUI"))()

-- Criar tabs
local MainTab = Library:CreateTab("Main")
local FarmTab = Library:CreateTab("Farm")
local CombatTab = Library:CreateTab("Combat")
local StatsTab = Library:CreateTab("Stats")
local RaidTab = Library:CreateTab("Raid")
local MiscTab = Library:CreateTab("Misc")
local TeleportTab = Library:CreateTab("Teleport")

-- Adicionar elementos às tabs
MainTab:CreateToggle("Auto Farm", function(state)
    getgenv().AutoFarm = state
    if state then
        Functions.AutoFarm()
    end
end)
-- Carrega a biblioteca e as funções
local Library = loadstring(game:HttpGet("SEU_LINK_DA_LIBRARY"))()
local Functions = loadstring(game:HttpGet("SEU_LINK_DAS_FUNCTIONS"))()

-- Main Tab
local MainTab = Library:CreateTab("Main")
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
local FarmTab = Library:CreateTab("Farm")
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
local CombatTab = Library:CreateTab("Combat")
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
local StatsTab = Library:CreateTab("Stats")
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

-- Raid Tab
local RaidTab = Library:CreateTab("Raid")
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
local MiscTab = Library:CreateTab("Misc")
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
local TeleportTab = Library:CreateTab("Teleport")

-- Lista de ilhas do King Legacy
local islands = {
    "Starter Island",
    "Marine Island",
    "Desert Island",
    "Shark Island",
    "Snow Island",
    "Sky Island",
    "Punk Hazard",
    "Cursed Island",
    "Gravito's Island"
}

TeleportTab:CreateDropdown("Select Island", islands, function(selected)
    Functions.TeleportToIsland(selected)
end)

-- Lista de NPCs importantes
local npcs = {
    "Quest NPC",
    "Shop NPC",
    "Skills NPC",
    "Devil Fruit Dealer",
    "Sword Dealer",
    "Stats Reset"
}

TeleportTab:CreateDropdown("Select NPC", npcs, function(selected)
    Functions.TeleportToNPC(selected)
end)

TeleportTab:CreateButton("Safe Zone", function()
    Functions.SafeZone()
end)

TeleportTab:CreateButton("Server Hop", function()
    Functions.ServerHop()
end)

-- Config Tab
local ConfigTab = Library:CreateTab("Config")
ConfigTab:CreateDropdown("Select Farm Method", {"Above", "Behind", "Below"}, function(selected)
    getgenv().FarmMethod = selected
end)

ConfigTab:CreateDropdown("Select Farm Distance", {"Near", "Medium", "Far"}, function(selected)
    getgenv().FarmDistance = selected
end)

ConfigTab:CreateToggle("Auto Attack", function(state)
    getgenv().AutoAttack = state
end)

ConfigTab:CreateToggle("Auto Collect Drops", function(state)
    getgenv().AutoCollectDrops = state
end)

-- Adiciona keybinds para funções importantes
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.RightControl then
            Library:ToggleUI() -- Toggle da interface
        end
    end
end)

-- Inicialização
print("Theus Premium carregado com sucesso!")