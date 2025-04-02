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