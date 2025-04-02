-- Serviços
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- Variáveis
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Remove GUIs antigas se existirem
local oldGui = CoreGui:FindFirstChild("THEUS_HUB")
if oldGui then oldGui:Destroy() end

-- Interface Principal
local THEUS_HUB = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local UICorner_Main = Instance.new("UICorner")
local Shadow = Instance.new("ImageLabel")
local TopBar = Instance.new("Frame")
local UICorner_Top = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local Minimize = Instance.new("TextButton")
local TabHolder = Instance.new("Frame")
local UICorner_Tab = Instance.new("UICorner")
local TabList = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")
local UIPadding = Instance.new("UIPadding")
local ContentContainer = Instance.new("Frame")

-- Propriedades GUI
THEUS_HUB.Name = "THEUS_HUB"
THEUS_HUB.Parent = CoreGui
THEUS_HUB.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Main.Name = "Main"
Main.Parent = THEUS_HUB
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.5, -300, 0.5, -200)
Main.Size = UDim2.new(0, 600, 0, 400)
Main.ClipsDescendants = true
Main.Active = true
Main.Draggable = true

Shadow.Name = "Shadow"
Shadow.Parent = Main
Shadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Shadow.BackgroundTransparency = 1
Shadow.Position = UDim2.new(0, -15, 0, -15)
Shadow.Size = UDim2.new(1, 30, 1, 30)
Shadow.Image = "rbxassetid://6015897843"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.5
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(49, 49, 450, 450)

TopBar.Name = "TopBar"
TopBar.Parent = Main
TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TopBar.Size = UDim2.new(1, 0, 0, 35)

Title.Name = "Title"
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "THEUS HUB PREMIUM"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

Minimize.Name = "Minimize"
Minimize.Parent = TopBar
Minimize.BackgroundTransparency = 1
Minimize.Position = UDim2.new(1, -30, 0, 5)
Minimize.Size = UDim2.new(0, 25, 0, 25)
Minimize.Font = Enum.Font.GothamBold
Minimize.Text = "-"
Minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
Minimize.TextSize = 20

TabHolder.Name = "TabHolder"
TabHolder.Parent = Main
TabHolder.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TabHolder.Position = UDim2.new(0, 10, 0, 45)
TabHolder.Size = UDim2.new(0, 130, 1, -55)

TabList.Name = "TabList"
TabList.Parent = TabHolder
TabList.Active = true
TabList.BackgroundTransparency = 1
TabList.Size = UDim2.new(1, 0, 1, 0)
TabList.ScrollBarThickness = 0

UIListLayout.Parent = TabList
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

UIPadding.Parent = TabList
UIPadding.PaddingTop = UDim.new(0, 5)
UIPadding.PaddingLeft = UDim.new(0, 5)
UIPadding.PaddingRight = UDim.new(0, 5)

ContentContainer.Name = "ContentContainer"
ContentContainer.Parent = Main
ContentContainer.BackgroundTransparency = 1
ContentContainer.Position = UDim2.new(0, 150, 0, 45)
ContentContainer.Size = UDim2.new(1, -160, 1, -55)

-- Funções da Interface
local Library = {}
Library.Tabs = {}
Library.CurrentTab = nil

function Library:CreateTab(name, icon)
    local Tab = Instance.new("TextButton")
    local TabContent = Instance.new("ScrollingFrame")
    local ContentLayout = Instance.new("UIListLayout")
    local ContentPadding = Instance.new("UIPadding")
    
    Tab.Name = name
    Tab.Parent = TabList
    Tab.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Tab.Size = UDim2.new(1, 0, 0, 32)
    Tab.Font = Enum.Font.GothamSemibold
    Tab.Text = name
    Tab.TextColor3 = Color3.fromRGB(255, 255, 255)
    Tab.TextSize = 12
    Tab.AutoButtonColor = false
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = Tab
    
    TabContent.Name = name.."Content"
    TabContent.Parent = ContentContainer
    TabContent.BackgroundTransparency = 1
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.ScrollBarThickness = 2
    TabContent.Visible = false
    
    ContentLayout.Parent = TabContent
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 5)
    
    ContentPadding.Parent = TabContent
    ContentPadding.PaddingTop = UDim.new(0, 5)
    ContentPadding.PaddingLeft = UDim.new(0, 5)
    ContentPadding.PaddingRight = UDim.new(0, 5)
    
    Tab.MouseButton1Click:Connect(function()
        if Library.CurrentTab then
            Library.CurrentTab.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Library.CurrentTab.Content.Visible = false
        end
        Library.CurrentTab = {Button = Tab, Content = TabContent}
        Tab.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        TabContent.Visible = true
    end)
    
    local TabFunctions = {}
    
    function TabFunctions:CreateToggle(name, callback)
        local Toggle = Instance.new("Frame")
        local ToggleButton = Instance.new("TextButton")
        local ToggleTitle = Instance.new("TextLabel")
        local ToggleIndicator = Instance.new("Frame")
        local UICorner = Instance.new("UICorner")
        
        Toggle.Name = "Toggle"
        Toggle.Parent = TabContent
        Toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        Toggle.Size = UDim2.new(1, 0, 0, 35)
        
        UICorner.CornerRadius = UDim.new(0, 6)
        UICorner.Parent = Toggle
        
        ToggleTitle.Name = "Title"
        ToggleTitle.Parent = Toggle
        ToggleTitle.BackgroundTransparency = 1
        ToggleTitle.Position = UDim2.new(0, 10, 0, 0)
        ToggleTitle.Size = UDim2.new(1, -60, 1, 0)
        ToggleTitle.Font = Enum.Font.Gotham
        ToggleTitle.Text = name
        ToggleTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        ToggleTitle.TextSize = 14
        ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
        
        ToggleIndicator.Name = "Indicator"
        ToggleIndicator.Parent = Toggle
        ToggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        ToggleIndicator.Position = UDim2.new(1, -40, 0.5, -10)
        ToggleIndicator.Size = UDim2.new(0, 20, 0, 20)
        
        local IndicatorCorner = Instance.new("UICorner")
        IndicatorCorner.CornerRadius = UDim.new(0, 4)
        IndicatorCorner.Parent = ToggleIndicator
        
        local enabled = false
        Toggle.MouseButton1Click:Connect(function()
            enabled = not enabled
            ToggleIndicator.BackgroundColor3 = enabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
            callback(enabled)
        end)
    end
    
    return TabFunctions
end

-- Criação das Tabs
local MainTab = Library:CreateTab("Main")
local FarmTab = Library:CreateTab("Farm")
local CombatTab = Library:CreateTab("Combat")
local TeleportTab = Library:CreateTab("Teleport")
local SettingsTab = Library:CreateTab("Settings")

-- Minimizar
local minimized = false
Minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        Main:TweenSize(UDim2.new(0, 600, 0, 35), "Out", "Quad", 0.3, true)
    else
        Main:TweenSize(UDim2.new(0, 600, 0, 400), "Out", "Quad", 0.3, true)
    end
end)

-- Seleciona a primeira tab por padrão
local firstTab = TabList:FindFirstChildWhichIsA("TextButton")
if firstTab then
    firstTab.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    ContentContainer:FindFirstChild(firstTab.Name.."Content").Visible = true
    Library.CurrentTab = {Button = firstTab, Content = ContentContainer:FindFirstChild(firstTab.Name.."Content")}
end

return Library