-- Interface Mobile Otimizada
local UI = {}

function UI:CreateMainUI()
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local TitleBar = Instance.new("Frame")
    local TitleLabel = Instance.new("TextLabel")
    local MinimizeButton = Instance.new("TextButton")
    local ContentFrame = Instance.new("Frame")
    local TabContainer = Instance.new("Frame")
    local TabButtons = {}
    local TabContents = {}

    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 300, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    MainFrame.BackgroundColor3 = _G.TheusHub.Theme.Primary
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.BackgroundColor3 = _G.TheusHub.Theme.Secondary
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame

    TitleLabel.Name = "TitleLabel"
    TitleLabel.Text = "Theus Hub"
    TitleLabel.TextColor3 = _G.TheusHub.Theme.Text
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 16
    TitleLabel.Size = UDim2.new(1, 0, 1, 0)
    TitleLabel.Parent = TitleBar

    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Text = "-"
    MinimizeButton.TextColor3 = _G.TheusHub.Theme.Text
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.TextSize = 18
    MinimizeButton.Size = UDim2.new(0, 30, 1, 0)
    MinimizeButton.Position = UDim2.new(1, -30, 0, 0)
    MinimizeButton.BackgroundTransparency = 1
    MinimizeButton.Parent = TitleBar

    ContentFrame.Name = "ContentFrame"
    ContentFrame.Size = UDim2.new(1, 0, 1, -30)
    ContentFrame.Position = UDim2.new(0, 0, 0, 30)
    ContentFrame.BackgroundColor3 = _G.TheusHub.Theme.Secondary
    ContentFrame.BorderSizePixel = 0
    ContentFrame.Parent = MainFrame

    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, 0, 1, 0)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = ContentFrame

    -- Criação dos botões de aba
    for i, tab in pairs({
        "Aimbot",
        "ESP",
        "Combat",
        "Movement",
        "Misc"
    }) do
        local TabButton = UI:CreateButton(tab, function()
            for j, t in pairs(TabContents) do
                t.Visible = j == i
            end
        end)
        TabButton.Parent = TabContainer
        TabButton.Position = UDim2.new(0, (i - 1) * 60, 0, 0)
        table.insert(TabButtons, TabButton)

        local TabContent = Instance.new("Frame")
        TabContent.Name = tab .. "Tab"
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.Visible = i == 1
        TabContent.Parent = TabContainer
        table.insert(TabContents, TabContent)
    end

    -- Implementação dos conteúdos das abas
    self:CreateAimbotTab(TabContents[1])
    self:CreateESPTab(TabContents[2])
    self:CreateCombatTab(TabContents[3])
    self:CreateMovementTab(TabContents[4])
    self:CreateMiscTab(TabContents[5])

    -- Minimizar/Maximizar a janela
    MinimizeButton.MouseButton1Click:Connect(function()
        if MainFrame.Size == UDim2.new(0, 300, 0, 400) then
            MainFrame:TweenSize(UDim2.new(0, 300, 0, 30), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.5, true)
        else
            MainFrame:TweenSize(UDim2.new(0, 300, 0, 400), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.5, true)
        end
    end)

    return ScreenGui
end

function UI:CreateButton(text, callback)
    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.Text = text
    button.TextColor3 = _G.TheusHub.Theme.Text
    button.Font = Enum.Font.GothamBold
    button.TextSize = 12
    button.BackgroundColor3 = _G.TheusHub.Theme.Accent
    button.BackgroundTransparency = 0.5
    button.Size = UDim2.new(0, 100, 0, 25)
    button.BorderSizePixel = 0
    button.MouseButton1Click:Connect(callback)
    return button
end

function UI:CreateAimbotTab(tab)
    -- Implementação da aba de Aimbot
end

function UI:CreateESPTab(tab)
    -- Implementação da aba de ESP
end

function UI:CreateCombatTab(tab)
    -- Implementação da aba de Combat
end

function UI:CreateMovementTab(tab)
    -- Implementação da aba de Movement
end

function UI:CreateMiscTab(tab)
    -- Implementação da aba de Misc
end

-- Inicialização do Script
local mainUI = UI:CreateMainUI()