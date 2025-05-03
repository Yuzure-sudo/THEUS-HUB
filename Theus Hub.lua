-- Theus Hub - Legends of Speed Script
local TheusHub = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local MinimizeBtn = Instance.new("TextButton")
local TabHolder = Instance.new("Frame")
local ScrollingFrame = Instance.new("ScrollingFrame")
local AutoFarmBtn = Instance.new("TextButton")
local SpeedHackBtn = Instance.new("TextButton")
local TeleportBtn = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

-- GUI Setup
TheusHub.Name = "TheusHub"
TheusHub.Parent = game:GetService("CoreGui")

MainFrame.Name = "MainFrame"
MainFrame.Parent = TheusHub
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Active = true
MainFrame.Draggable = true

UICorner.Parent = MainFrame

Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.GothamBold
Title.Text = "Theus Hub v2.0"
Title.TextColor3 = Color3.fromRGB(255, 85, 0)
Title.TextSize = 14.000

MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Parent = Title
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
MinimizeBtn.Position = UDim2.new(0.9, 0, 0, 0)
MinimizeBtn.Size = UDim2.new(0.1, 0, 1, 0)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Text = "_"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 14.000

TabHolder.Name = "TabHolder"
TabHolder.Parent = MainFrame
TabHolder.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TabHolder.Position = UDim2.new(0, 0, 0.075, 0)
TabHolder.Size = UDim2.new(1, 0, 0.925, 0)

ScrollingFrame.Parent = TabHolder
ScrollingFrame.Active = true
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 2, 0)

-- Functions
local minimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        MainFrame.Size = UDim2.new(0, 300, 0, 30)
        MinimizeBtn.Text = "+"
    else
        MainFrame.Size = UDim2.new(0, 300, 0, 400)
        MinimizeBtn.Text = "_"
    end
end)

-- Auto Farm
AutoFarmBtn.Name = "AutoFarmBtn"
AutoFarmBtn.Parent = ScrollingFrame
AutoFarmBtn.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
AutoFarmBtn.Position = UDim2.new(0.1, 0, 0, 10)
AutoFarmBtn.Size = UDim2.new(0.8, 0, 0, 40)
AutoFarmBtn.Font = Enum.Font.GothamBold
AutoFarmBtn.Text = "Auto Farm [ON]"
AutoFarmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoFarmBtn.TextSize = 14.000

local farming = false
AutoFarmBtn.MouseButton1Click:Connect(function()
    farming = not farming
    AutoFarmBtn.Text = farming and "Auto Farm [OFF]" or "Auto Farm [ON]"
    
    while farming do
        -- Farming logic here
        wait(0.1)
        if not farming then break end
    end
end)

-- Speed Hack
SpeedHackBtn.Name = "SpeedHackBtn"
SpeedHackBtn.Parent = ScrollingFrame
SpeedHackBtn.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
SpeedHackBtn.Position = UDim2.new(0.1, 0, 0, 60)
SpeedHackBtn.Size = UDim2.new(0.8, 0, 0, 40)
SpeedHackBtn.Font = Enum.Font.GothamBold
SpeedHackBtn.Text = "Speed Hack [OFF]"
SpeedHackBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedHackBtn.TextSize = 14.000

SpeedHackBtn.MouseButton1Click:Connect(function()
    -- Speed hack logic here
end)

-- Teleport
TeleportBtn.Name = "TeleportBtn"
TeleportBtn.Parent = ScrollingFrame
TeleportBtn.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
TeleportBtn.Position = UDim2.new(0.1, 0, 0, 110)
TeleportBtn.Size = UDim2.new(0.8, 0, 0, 40)
TeleportBtn.Font = Enum.Font.GothamBold
TeleportBtn.Text = "Teleport to Zone"
TeleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportBtn.TextSize = 14.000

TeleportBtn.MouseButton1Click:Connect(function()
    -- Teleport logic here
end)

-- Additional styling
local UICorner2 = Instance.new("UICorner")
UICorner2.Parent = AutoFarmBtn
local UICorner3 = Instance.new("UICorner")
UICorner3.Parent = SpeedHackBtn
local UICorner4 = Instance.new("UICorner")
UICorner4.Parent = TeleportBtn