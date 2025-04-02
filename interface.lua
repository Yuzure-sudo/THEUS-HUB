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
ContentContainerCorner.Parent = ContentContainer

-- Funções da interface
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
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.ScrollBarThickness = 2
    TabContent.Visible = false

    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.Parent = TabContent
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 5)

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
        Toggle.Size = UDim2.new(1, -10, 0, 40)

        local ToggleCorner = Instance.new("UICorner")
        ToggleCorner.CornerRadius = UDim.new(0, 6)
        ToggleCorner.Parent = Toggle

        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Name = "ToggleButton"
        ToggleButton.Parent = Toggle
        ToggleButton.BackgroundTransparency = 1
        ToggleButton.Size = UDim2.new(1, 0, 1, 0)
        ToggleButton.Font = Enum.Font.Gotham
        ToggleButton.Text = name
        ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        ToggleButton.TextSize = 14
        ToggleButton.TextXAlignment = Enum.TextXAlignment.Left
        ToggleButton.TextTransparency = 0

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

    return TabFunctions
end

-- Criar tabs principais
local MainTab = Library:CreateTab("Main")
local FarmTab = Library:CreateTab("Farm")
local CombatTab = Library:CreateTab("Combat")
local TeleportTab = Library:CreateTab("Teleport")
local SettingsTab = Library:CreateTab("Settings")

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