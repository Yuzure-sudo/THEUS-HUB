local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local IMAGE_ID = "rbxassetid://119139554769198"

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Theus_i_os_amigos"
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 600, 0, 360)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -180)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BackgroundTransparency = 0.18

local mainCorner = Instance.new("UICorner", mainFrame)
mainCorner.CornerRadius = UDim.new(0, 16)

local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Color = Color3.fromRGB(0, 132, 255)
mainStroke.Thickness = 1.5
mainStroke.Transparency = 0.3

local logo = Instance.new("ImageLabel")
logo.Name = "Logo"
logo.Parent = mainFrame
logo.BackgroundTransparency = 1
logo.Position = UDim2.new(0, 20, 0, 20)
logo.Size = UDim2.new(0, 50, 0, 50)
logo.Image = IMAGE_ID

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Parent = mainFrame
title.Text = "Theus i os amigos"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.fromRGB(200, 220, 255)
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, -100, 0, 38)
title.Position = UDim2.new(0, 80, 0, 20)
title.TextXAlignment = Enum.TextXAlignment.Left

local minimize = Instance.new("ImageButton")
minimize.Name = "Minimize"
minimize.Parent = mainFrame
minimize.Size = UDim2.new(0, 34, 0, 34)
minimize.Position = UDim2.new(1, -44, 0, 16)
minimize.BackgroundTransparency = 1
minimize.Image = IMAGE_ID
minimize.ImageColor3 = Color3.fromRGB(180, 180, 255)

local tabPanel = Instance.new("Frame")
tabPanel.Name = "TabPanel"
tabPanel.Parent = mainFrame
tabPanel.Size = UDim2.new(0, 110, 1, -70)
tabPanel.Position = UDim2.new(0, 0, 0, 70)
tabPanel.BackgroundTransparency = 0.22
tabPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 40)

local tabCorner = Instance.new("UICorner", tabPanel)
tabCorner.CornerRadius = UDim.new(0, 12)

local tabList = Instance.new("UIListLayout", tabPanel)
tabList.SortOrder = Enum.SortOrder.LayoutOrder
tabList.Padding = UDim.new(0, 12)

local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Parent = mainFrame
contentFrame.Position = UDim2.new(0, 120, 0, 70)
contentFrame.Size = UDim2.new(1, -130, 1, -80)
contentFrame.BackgroundTransparency = 1

local menuTab = Instance.new("Frame")
menuTab.Name = "MenuTab"
menuTab.Parent = contentFrame
menuTab.Size = UDim2.new(1, 0, 1, 0)
menuTab.BackgroundTransparency = 1
menuTab.Visible = true

local menuButton = Instance.new("ImageButton")
menuButton.Name = "MenuButton"
menuButton.Parent = tabPanel
menuButton.Size = UDim2.new(1, -20, 0, 44)
menuButton.BackgroundTransparency = 0.1
menuButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
menuButton.Image = IMAGE_ID

local menuBtnCorner = Instance.new("UICorner", menuButton)
menuBtnCorner.CornerRadius = UDim.new(0, 8)

local menuBtnLabel = Instance.new("TextLabel")
menuBtnLabel.Parent = menuButton
menuBtnLabel.Size = UDim2.new(1, 0, 1, 0)
menuBtnLabel.BackgroundTransparency = 1
menuBtnLabel.Text = "Menu"
menuBtnLabel.Font = Enum.Font.GothamBold
menuBtnLabel.TextSize = 16
menuBtnLabel.TextColor3 = Color3.fromRGB(220, 220, 255)

menuButton.MouseButton1Click:Connect(function()
    for _, frame in pairs(contentFrame:GetChildren()) do
        if frame:IsA("Frame") then
            frame.Visible = false
        end
    end
    menuTab.Visible = true
end)

local dragging, dragInput, dragStart, startPos
title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

local minimized = false
minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
        Size = minimized and UDim2.new(0, 120, 0, 54) or UDim2.new(0, 600, 0, 360)
    }):Play()
end)
