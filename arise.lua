-- Interface transparente "Theus i os amigos" com imagem padrão

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local IMAGE_ID = "rbxassetid://119139554769198"

-- Protege a GUI caso esteja usando executor compatível
local function ProtectGui(gui)
    local HIDEUI = get_hidden_gui or gethui
    if HIDEUI then
        gui.Parent = HIDEUI()
    else
        gui.Parent = CoreGui
    end
end

-- Cria ScreenGui principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Theus_i_os_amigos"
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ProtectGui(screenGui)

-- Janela principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 420, 0, 280)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -140)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BackgroundTransparency = 0.25
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner", mainFrame)
corner.CornerRadius = UDim.new(0, 14)

local stroke = Instance.new("UIStroke", mainFrame)
stroke.Color = Color3.fromRGB(0, 132, 255)
stroke.Thickness = 1.5
stroke.Transparency = 0.3

-- Logo (imagem grande no canto)
local logo = Instance.new("ImageLabel")
logo.Name = "Logo"
logo.Parent = mainFrame
logo.BackgroundTransparency = 1
logo.Position = UDim2.new(0, 15, 0, 15)
logo.Size = UDim2.new(0, 48, 0, 48)
logo.Image = IMAGE_ID

-- Título
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Parent = mainFrame
title.Text = "Theus i os amigos"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.fromRGB(200, 220, 255)
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, 0, 0, 38)
title.Position = UDim2.new(0, 0, 0, 0)

-- Ícone do usuário (direita do título)
local userIcon = Instance.new("ImageLabel")
userIcon.Name = "UserIcon"
userIcon.Parent = mainFrame
userIcon.BackgroundTransparency = 1
userIcon.Position = UDim2.new(1, -58, 0, 6)
userIcon.Size = UDim2.new(0, 26, 0, 26)
userIcon.Image = IMAGE_ID

local userCorner = Instance.new("UICorner", userIcon)
userCorner.CornerRadius = UDim.new(0, 100)

-- Botão de minimizar
local minimize = Instance.new("ImageButton")
minimize.Name = "Minimize"
minimize.Parent = mainFrame
minimize.Size = UDim2.new(0, 26, 0, 26)
minimize.Position = UDim2.new(1, -34, 0, 6)
minimize.BackgroundTransparency = 1
minimize.Image = IMAGE_ID
minimize.ImageColor3 = Color3.fromRGB(180, 180, 255)

-- Drag funcionalidade
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

-- Minimizar/Restaurar
local minimized = false
minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
        Size = minimized and UDim2.new(0, 120, 0, 38) or UDim2.new(0, 420, 0, 280)
    }):Play()
end)

-- Área para adicionar botões/abas depois:
local contentFrame = Instance.new("Frame")
contentFrame.Name = "Content"
contentFrame.Parent = mainFrame
contentFrame.Position = UDim2.new(0, 0, 0, 54)
contentFrame.Size = UDim2.new(1, 0, 1, -54)
contentFrame.BackgroundTransparency = 1

local menuTab = Instance.new("Frame")
menuTab.Name = "MenuTab"
menuTab.Parent = Main
menuTab.Size = UDim2.new(1, 0, 1, 0)
menuTab.BackgroundTransparency = 1
menuTab.Visible = true

local tabPanel = Instance.new("Frame")
tabPanel.Name = "TabPanel"
tabPanel.Parent = Main
tabPanel.Size = UDim2.new(0, 110, 1, 0)
tabPanel.Position = UDim2.new(0, 0, 0, 0)
tabPanel.BackgroundTransparency = 0.3
tabPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 40)

local tabCorner = Instance.new("UICorner", tabPanel)
tabCorner.CornerRadius = UDim.new(0, 12)

local menuButton = Instance.new("ImageButton")
menuButton.Name = "MenuButton"
menuButton.Parent = tabPanel
menuButton.Size = UDim2.new(0, 80, 0, 40)
menuButton.Position = UDim2.new(0, 15, 0, 30)
menuButton.BackgroundTransparency = 0.1
menuButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
menuButton.Image = "rbxassetid://119139554769198"

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
    menuTab.Visible = true
end)


-- Exemplo de botão usando a imagem padrão:
local exampleButton = Instance.new("ImageButton")
exampleButton.Name = "ExampleButton"
exampleButton.Parent = contentFrame
exampleButton.Size = UDim2.new(0, 60, 0, 60)
exampleButton.Position = UDim2.new(0, 30, 0, 20)
exampleButton.BackgroundTransparency = 0.4
exampleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 80)
exampleButton.Image = IMAGE_ID

local btnCorner = Instance.new("UICorner", exampleButton)
btnCorner.CornerRadius = UDim.new(0, 12)

-- Pronto! Tudo usa o id 119139554769198 como imagem.
-- Para adicionar mais botões, abas, sliders, etc, basta criar dentro de contentFrame.
