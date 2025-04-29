--[[
    Theus Aimbot v3.0 (Universal)
    Dev: TheusHss
    Discord: @theushss
    GitHub: github.com/theushss
    
    Changelog v3.0:
    - Interface redesenhada
    - Novos recursos adicionados
    - Otimizações de performance
    - Sistema de configuração
    - Melhorias no aimbot
]]

-- Services
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- Variables
local plr = Players.LocalPlayer
local mouse = plr:GetMouse()
local camera = workspace.CurrentCamera

-- Interface
local TheusUI = {}

-- UI Config
local config = {
    main_color = Color3.fromRGB(30, 30, 35),
    accent_color = Color3.fromRGB(45, 45, 50),
    highlight = Color3.fromRGB(255, 71, 71),
    text_color = Color3.fromRGB(255, 255, 255),
    font = Enum.Font.GothamBold,
    text_size = 14
}

-- Settings
local settings = {
    aimbot = {
        enabled = false,
        fov = 100,
        smoothness = 0.5,
        prediction = 0.15,
        target_part = "Head",
        team_check = true,
        visible_check = true,
        lock_type = "Camera",
        trigger_key = Enum.KeyCode.E
    },
    visuals = {
        enabled = false,
        box = true,
        name = true,
        health = true,
        distance = true,
        tracer = true,
        chams = false,
        rgb_mode = false
    },
    misc = {
        no_recoil = false,
        rapid_fire = false,
        instant_hit = false,
        wall_penetration = false,
        speed_multiplier = 1,
        jump_power = 50
    }
}

-- Interface Creation
function TheusUI:Create()
    -- Main GUI
    local gui = Instance.new("ScreenGui")
    gui.Name = "TheusAimbot"
    gui.Parent = CoreGui
    
    -- Main Frame
    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.new(0, 300, 0, 400)
    main.Position = UDim2.new(0.5, -150, 0.5, -200)
    main.BackgroundColor3 = config.main_color
    main.BorderSizePixel = 0
    main.Parent = gui
    
    -- Make Draggable
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    main.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    
    -- Corner Rounding
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = main
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = config.accent_color
    titleBar.BorderSizePixel = 0
    titleBar.Parent = main
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = titleBar
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -20, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Theus Aimbot v3.0"
    title.TextColor3 = config.highlight
    title.TextSize = 20
    title.Font = config.font
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = titleBar
    
    -- Tabs
    local tabButtons = Instance.new("Frame")
    tabButtons.Name = "TabButtons"
    tabButtons.Size = UDim2.new(1, -20, 0, 30)
    tabButtons.Position = UDim2.new(0, 10, 0, 50)
    tabButtons.BackgroundTransparency = 1
    tabButtons.Parent = main
    
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(1, -20, 1, -90)
    tabContainer.Position = UDim2.new(0, 10, 0, 90)
    tabContainer.BackgroundTransparency = 1
    tabContainer.Parent = main
    
    -- Create Tabs
    local tabs = {
        {name = "Aimbot", icon = "🎯"},
        {name = "Visuals", icon = "👁"},
        {name = "Misc", icon = "⚙"}
    }
    
    local function createTab(data, index)
        local button = Instance.new("TextButton")
        button.Name = data.name
        button.Size = UDim2.new(1/3, -7, 1, 0)
        button.Position = UDim2.new((index-1)/3, (index-1)*7, 0, 0)
        button.BackgroundColor3 = config.accent_color
        button.Text = data.icon .. " " .. data.name
        button.TextColor3 = config.text_color
        button.TextSize = config.text_size
        button.Font = config.font
        button.Parent = tabButtons
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = button
        
        local container = Instance.new("ScrollingFrame")
        container.Name = data.name .. "Container"
        container.Size = UDim2.new(1, 0, 1, 0)
        container.BackgroundTransparency = 1
        container.ScrollBarThickness = 2
        container.Visible = index == 1
        container.Parent = tabContainer
        
        button.MouseButton1Click:Connect(function()
            for _, tab in pairs(tabContainer:GetChildren()) do
                tab.Visible = tab.Name == data.name .. "Container"
            end
            
            for _, btn in pairs(tabButtons:GetChildren()) do
                if btn:IsA("TextButton") then
                    btn.BackgroundColor3 = btn == button and config.highlight or config.accent_color
                end
            end
        end)
        
        if index == 1 then
            button.BackgroundColor3 = config.highlight
        end
        
        return container
    end
    
    local tabFrames = {}
    for i, tab in ipairs(tabs) do
        tabFrames[tab.name] = createTab(tab, i)
    end
    
    -- Create Controls
    local function createToggle(name, parent, callback)
        local toggle = Instance.new("Frame")
        toggle.Name = name
        toggle.Size = UDim2.new(1, 0, 0, 30)
        toggle.BackgroundTransparency = 1
        toggle.Parent = parent
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -50, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = config.text_color
        label.TextSize = config.text_size
        label.Font = config.font
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = toggle
        
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0, 40, 0, 20)
        button.Position = UDim2.new(1, -40, 0.5, -10)
        button.BackgroundColor3 = config.accent_color
        button.Text = ""
        button.Parent = toggle
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = button
        
        local indicator = Instance.new("Frame")
        indicator.Size = UDim2.new(0, 16, 0, 16)
        indicator.Position = UDim2.new(0, 2, 0.5, -8)
        indicator.BackgroundColor3 = config.text_color
        indicator.Parent = button
        
        local indicatorCorner = Instance.new("UICorner")
        indicatorCorner.CornerRadius = UDim.new(1, 0)
        indicatorCorner.Parent = indicator
        
        local enabled = false
        button.MouseButton1Click:Connect(function()
            enabled = not enabled
            
            TS:Create(indicator, TweenInfo.new(0.2), {
                Position = enabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
                BackgroundColor3 = enabled and config.highlight or config.text_color
            }):Play()
            
            if callback then
                callback(enabled)
            end
        end)
        
        return toggle
    end
    
    -- Populate Tabs
    -- Aimbot Tab
    local aimbotTab = tabFrames.Aimbot
    createToggle("Aimbot Enabled", aimbotTab, function(enabled)
        settings.aimbot.enabled = enabled
    end)
    
    -- More controls and functionality here...
    
    return gui
end

-- Core Functions
local function getClosestPlayer()
    local closest = nil
    local maxDist = settings.aimbot.fov
    local mousePos = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= plr and player.Character and player.Character:FindFirstChild(settings.aimbot.target_part) then
            if not (settings.aimbot.team_check and player.Team == plr.Team) then
                local pos = camera:WorldToScreenPoint(player.Character[settings.aimbot.target_part].Position)
                local dist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                
                if dist < maxDist then
                    closest = player
                    maxDist = dist
                end
            end
        end
    end
    
    return closest
end

-- Main Loop
RS.RenderStepped:Connect(function()
    if settings.aimbot.enabled then
        local target = getClosestPlayer()
        if target then
            local targetPart = target.Character[settings.aimbot.target_part]
            local prediction = targetPart.Position + (targetPart.Velocity * settings.aimbot.prediction)
            
            if settings.aimbot.lock_type == "Camera" then
                camera.CFrame = camera.CFrame:Lerp(
                    CFrame.new(camera.CFrame.Position, prediction),
                    settings.aimbot.smoothness
                )
            end
        end
    end
end)

-- Initialize
TheusUI:Create()