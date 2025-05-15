--// Wirtz Script V3 - Development Build
--// Coded by: wirtz.dev

local Services = {
    Players = game:GetService("Players"),
    RunService = game:GetService("RunService"),
    UIS = game:GetService("UserInputService"),
    TweenService = game:GetService("TweenService"),
    Workspace = game:GetService("Workspace")
}

local LocalPlayer = Services.Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local WirtzUI = {}
local Features = {}
local Config = {
    ESP = {enabled=false, showBox=true, showInfo=true, maxDistance=2000, teamCheck=true},
    Aimbot = {enabled=false, strength=1, part="Head", teamCheck=true, prediction=true},
    Fly = {enabled=false, speed=80, vSpeed=70}
}

--// Core UI System
WirtzUI.create = function()
    pcall(function() if game.CoreGui:FindFirstChild("WirtzScript") then game.CoreGui:FindFirstChild("WirtzScript"):Destroy() end end)
    
    local gui = Instance.new("ScreenGui")
    gui.Name = "WirtzScript"
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() gui.Parent = game:GetService("CoreGui") end)
    if not gui.Parent then gui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
    
    --// Master Frame
    local master = Instance.new("Frame")
    master.Name = "Master"
    master.Size = UDim2.new(0, 320, 0, 420)
    master.Position = UDim2.new(0.5, -160, 0.5, -210)
    master.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    master.BorderSizePixel = 0
    master.Parent = gui
    
    --// UI Elements (Optimized for mobile)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = master
    
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.Size = UDim2.new(1, 40, 1, 40)
    shadow.ZIndex = 0
    shadow.Image = "rbxassetid://6014054464"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(128, 128, 128, 128)
    shadow.Parent = master
    
    --// Top Bar
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 42)
    topBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    topBar.BorderSizePixel = 0
    topBar.Parent = master
    
    local topCorner = Instance.new("UICorner")
    topCorner.CornerRadius = UDim.new(0, 10)
    topCorner.Parent = topBar
    
    local topStroke = Instance.new("UIStroke")
    topStroke.Color = Color3.fromRGB(50, 50, 70)
    topStroke.Thickness = 1
    topStroke.Parent = topBar
    
    local topCover = Instance.new("Frame")
    topCover.Size = UDim2.new(1, 0, 0.5, 0)
    topCover.Position = UDim2.new(0, 0, 0.5, 0)
    topCover.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    topCover.BorderSizePixel = 0
    topCover.ZIndex = 0
    topCover.Parent = topBar
    
    --// Title
    local logo = Instance.new("ImageLabel")
    logo.Name = "Logo"
    logo.Size = UDim2.new(0, 28, 0, 28)
    logo.Position = UDim2.new(0, 12, 0, 7)
    logo.BackgroundTransparency = 1
    logo.Image = "rbxassetid://8177705335" -- Target icon
    logo.ImageColor3 = Color3.fromRGB(90, 90, 255)
    logo.Parent = topBar
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(0, 150, 0, 25)
    title.Position = UDim2.new(0, 48, 0, 7)
    title.BackgroundTransparency = 1
    title.Text = "WIRTZ"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 20
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = topBar
    
    local subtitle = Instance.new("TextLabel")
    subtitle.Name = "Subtitle"
    subtitle.Size = UDim2.new(0, 150, 0, 20)
    subtitle.Position = UDim2.new(0, 110, 0, 9)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "SCRIPT"
    subtitle.TextColor3 = Color3.fromRGB(90, 90, 255)
    subtitle.TextSize = 18
    subtitle.Font = Enum.Font.GothamBold
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.Parent = topBar
    
    --// Make Top Bar Draggable
    local dragging, dragInput, dragStart, startPos
    
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = master.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    topBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    Services.UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            master.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    --// Close Button
    local closeBtn = Instance.new("ImageButton")
    closeBtn.Name = "CloseBtn"
    closeBtn.Size = UDim2.new(0, 24, 0, 24)
    closeBtn.Position = UDim2.new(1, -32, 0, 9)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Image = "rbxassetid://6031094678"
    closeBtn.ImageColor3 = Color3.fromRGB(255, 90, 90)
    closeBtn.Parent = topBar
    
    closeBtn.MouseButton1Click:Connect(function()
        Features.DisableAll()
        gui:Destroy()
    end)
    
    --// Content Area
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -20, 1, -52)
    content.Position = UDim2.new(0, 10, 0, 47)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.Parent = master
    
    --// Tabs
    local function createTab(name, icon, color)
        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = name.."Tab"
        tabBtn.Size = UDim2.new(1/3, -4, 0, 35)
        tabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        tabBtn.BorderSizePixel = 0
        tabBtn.Text = ""
        tabBtn.Parent = content
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 6)
        tabCorner.Parent = tabBtn
        
        local tabIcon = Instance.new("ImageLabel")
        tabIcon.Name = "Icon"
        tabIcon.Size = UDim2.new(0, 20, 0, 20)
        tabIcon.Position = UDim2.new(0, 10, 0.5, -10)
        tabIcon.BackgroundTransparency = 1
        tabIcon.Image = icon
        tabIcon.ImageColor3 = color
        tabIcon.Parent = tabBtn
        
        local tabLabel = Instance.new("TextLabel")
        tabLabel.Name = "Label"
        tabLabel.Size = UDim2.new(1, -40, 1, 0)
        tabLabel.Position = UDim2.new(0, 35, 0, 0)
        tabLabel.BackgroundTransparency = 1
        tabLabel.Text = name
        tabLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabLabel.TextSize = 14
        tabLabel.Font = Enum.Font.GothamSemibold
        tabLabel.TextXAlignment = Enum.TextXAlignment.Left
        tabLabel.Parent = tabBtn
        
        return tabBtn
    end
    
    --// Tab Container
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(1, 0, 0, 35)
    tabContainer.BackgroundTransparency = 1
    tabContainer.Parent = content
    
    local espTab = createTab("ESP", "rbxassetid://6026568240", Color3.fromRGB(90, 90, 255))
    espTab.Position = UDim2.new(0, 0, 0, 0)
    espTab.Parent = tabContainer
    
    local aimbotTab = createTab("Aimbot", "rbxassetid://6026568229", Color3.fromRGB(255, 90, 90))
    aimbotTab.Position = UDim2.new(1/3, 2, 0, 0)
    aimbotTab.Parent = tabContainer
    
    local flyTab = createTab("Fly", "rbxassetid://6022668898", Color3.fromRGB(90, 255, 90))
    flyTab.Position = UDim2.new(2/3, 4, 0, 0)
    flyTab.Parent = tabContainer
    
    --// Feature Pages
    local pages = Instance.new("Frame")
    pages.Name = "Pages"
    pages.Size = UDim2.new(1, 0, 1, -45)
    pages.Position = UDim2.new(0, 0, 0, 45)
    pages.BackgroundTransparency = 1
    pages.Parent = content
    
    --// Create Pages
    local espPage = Instance.new("Frame")
    espPage.Name = "ESPPage"
    espPage.Size = UDim2.new(1, 0, 1, 0)
    espPage.BackgroundTransparency = 1
    espPage.Visible = true
    espPage.Parent = pages
    
    local aimbotPage = Instance.new("Frame")
    aimbotPage.Name = "AimbotPage"
    aimbotPage.Size = UDim2.new(1, 0, 1, 0)
    aimbotPage.BackgroundTransparency = 1
    aimbotPage.Visible = false
    aimbotPage.Parent = pages
    
    local flyPage = Instance.new("Frame")
    flyPage.Name = "FlyPage"
    flyPage.Size = UDim2.new(1, 0, 1, 0)
    flyPage.BackgroundTransparency = 1
    flyPage.Visible = false
    flyPage.Parent = pages
    
    --// Tab Switching
    espTab.MouseButton1Click:Connect(function()
        espPage.Visible = true
        aimbotPage.Visible = false
        flyPage.Visible = false
        
        espTab.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        aimbotTab.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        flyTab.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    end)
    
    aimbotTab.MouseButton1Click:Connect(function()
        espPage.Visible = false
        aimbotPage.Visible = true
        flyPage.Visible = false
        
        espTab.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        aimbotTab.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        flyTab.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    end)
    
    flyTab.MouseButton1Click:Connect(function()
        espPage.Visible = false
        aimbotPage.Visible = false
        flyPage.Visible = true
        
        espTab.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        aimbotTab.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        flyTab.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    end)
    
    --// Create Toggle Function
    local function createToggle(parent, text, position, defaultState, onToggle)
        local toggle = Instance.new("Frame")
        toggle.Name = text.."Toggle"
        toggle.Size = UDim2.new(1, 0, 0, 45)
        toggle.Position = position
        toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        toggle.BorderSizePixel = 0
        toggle.Parent = parent
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 6)
        toggleCorner.Parent = toggle
        
        local toggleLabel = Instance.new("TextLabel")
        toggleLabel.Name = "Label"
        toggleLabel.Size = UDim2.new(1, -60, 1, 0)
        toggleLabel.Position = UDim2.new(0, 12, 0, 0)
        toggleLabel.BackgroundTransparency = 1
        toggleLabel.Text = text
        toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggleLabel.TextSize = 15
        toggleLabel.Font = Enum.Font.GothamSemibold
        toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        toggleLabel.Parent = toggle
        
        local toggleBtn = Instance.new("Frame")
        toggleBtn.Name = "ToggleBtn"
        toggleBtn.Size = UDim2.new(0, 50, 0, 26)
        toggleBtn.Position = UDim2.new(1, -60, 0.5, -13)
        toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        toggleBtn.BorderSizePixel = 0
        toggleBtn.Parent = toggle
        
        local toggleBtnCorner = Instance.new("UICorner")
        toggleBtnCorner.CornerRadius = UDim.new(0, 13)
        toggleBtnCorner.Parent = toggleBtn
        
        local toggleCircle = Instance.new("Frame")
        toggleCircle.Name = "Circle"
        toggleCircle.Size = UDim2.new(0, 20, 0, 20)
        toggleCircle.Position = UDim2.new(0, 3, 0.5, -10)
        toggleCircle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        toggleCircle.BorderSizePixel = 0
        toggleCircle.Parent = toggleBtn
        
        local toggleCircleCorner = Instance.new("UICorner")
        toggleCircleCorner.CornerRadius = UDim.new(0, 10)
        toggleCircleCorner.Parent = toggleCircle
        
        local toggleClick = Instance.new("TextButton")
        toggleClick.Name = "ClickArea"
        toggleClick.Size = UDim2.new(1, 0, 1, 0)
        toggleClick.BackgroundTransparency = 1
        toggleClick.Text = ""
        toggleClick.Parent = toggle
        
        local toggled = defaultState or false
        
        local function updateToggle()
            if toggled then
                Services.TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(90, 90, 255)}):Play()
                Services.TweenService:Create(toggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, 27, 0.5, -10)}):Play()
            else
                Services.TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 55)}):Play()
                Services.TweenService:Create(toggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -10)}):Play()
            end
            
            if onToggle then onToggle(toggled) end
        end
        
        toggleClick.MouseButton1Click:Connect(function()
            toggled = not toggled
            updateToggle()
        end)
        
        toggleClick.MouseEnter:Connect(function()
            Services.TweenService:Create(toggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 50)}):Play()
        end)
        
        toggleClick.MouseLeave:Connect(function()
            Services.TweenService:Create(toggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 40)}):Play()
        end)
        
        updateToggle() -- Set initial state
        return toggle, function() return toggled end, function(v) toggled = v; updateToggle() end
    end
    
    --// Create Slider Function
    local function createSlider(parent, text, position, min, max, default, onChanged)
        local slider = Instance.new("Frame")
        slider.Name = text.."Slider"
        slider.Size = UDim2.new(1, 0, 0, 70)
        slider.Position = position
        slider.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        slider.BorderSizePixel = 0
        slider.Parent = parent
        
        local sliderCorner = Instance.new("UICorner")
        sliderCorner.CornerRadius = UDim.new(0, 6)
        sliderCorner.Parent = slider
        
        local sliderLabel = Instance.new("TextLabel")
        sliderLabel.Name = "Label"
        sliderLabel.Size = UDim2.new(1, -20, 0, 25)
        sliderLabel.Position = UDim2.new(0, 12, 0, 5)
        sliderLabel.BackgroundTransparency = 1
        sliderLabel.Text = text
        sliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        sliderLabel.TextSize = 15
        sliderLabel.Font = Enum.Font.GothamSemibold
        sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
        sliderLabel.Parent = slider
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Name = "Value"
        valueLabel.Size = UDim2.new(0, 50, 0, 25)
        valueLabel.Position = UDim2.new(1, -60, 0, 5)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = tostring(default)
        valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        valueLabel.TextSize = 15
        valueLabel.Font = Enum.Font.GothamSemibold
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.Parent = slider
        
        local sliderBar = Instance.new("Frame")
        sliderBar.Name = "Bar"
        sliderBar.Size = UDim2.new(1, -24, 0, 8)
        sliderBar.Position = UDim2.new(0, 12, 0, 40)
        sliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        sliderBar.BorderSizePixel = 0
        sliderBar.Parent = slider
        
        local sliderBarCorner = Instance.new("UICorner")
        sliderBarCorner.CornerRadius = UDim.new(0, 4)
        sliderBarCorner.Parent = sliderBar
        
        local sliderFill = Instance.new("Frame")
        sliderFill.Name = "Fill"
        sliderFill.BackgroundColor3 = Color3.fromRGB(90, 90, 255)
        sliderFill.BorderSizePixel = 0
        sliderFill.Parent = sliderBar
        
        local sliderFillCorner = Instance.new("UICorner")
        sliderFillCorner.CornerRadius = UDim.new(0, 4)
        sliderFillCorner.Parent = sliderFill
        
        local sliderDrag = Instance.new("TextButton")
        sliderDrag.Name = "Drag"
        sliderDrag.Size = UDim2.new(1, 0, 1, 0)
        sliderDrag.BackgroundTransparency = 1
        sliderDrag.Text = ""
        sliderDrag.Parent = sliderBar
        
        local value = default or min
        local percent = (value - min) / (max - min)
        
        local function updateSlider()
            valueLabel.Text = tostring(math.floor(value * 10) / 10)
            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
            if onChanged then onChanged(value) end
        end
        
        local dragging = false
        
        sliderDrag.MouseButton1Down:Connect(function()
            dragging = true
        end)
        
        sliderDrag.MouseEnter:Connect(function()
            Services.TweenService:Create(slider, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 50)}):Play()
        end)
        
        sliderDrag.MouseLeave:Connect(function()
            Services.TweenService:Create(slider, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 40)}):Play()
        end)
        
        Services.UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        Services.UIS.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local absPos = sliderBar.AbsolutePosition.X
                local absSize = sliderBar.AbsoluteSize.X
                
                local pos = math.clamp(input.Position.X - absPos, 0, absSize)
                percent = pos / absSize
                value = min + (max - min) * percent
                
                updateSlider()
            end
        end)
        
        updateSlider() -- Set initial state
        return slider, function() return value end
    end
    
    --// Create Feature Pages Content
    --// ESP Page
    local espToggle, getESPEnabled, setESPEnabled = createToggle(espPage, "ESP Master", UDim2.new(0, 0, 0, 10), false, function(state)
        Config.ESP.enabled = state
        if state then Features.EnableESP() else Features.DisableESP() end
    end)
    
    local espTeamToggle = createToggle(espPage, "Team Check", UDim2.new(0, 0, 0, 65), true, function(state)
        Config.ESP.teamCheck = state
    end)
    
    local espBoxToggle = createToggle(espPage, "Show Boxes", UDim2.new(0, 0, 0, 120), true, function(state)
        Config.ESP.showBox = state
    end)
    
    local espInfoToggle = createToggle(espPage, "Show Info", UDim2.new(0, 0, 0, 175), true, function(state)
        Config.ESP.showInfo = state
    end)
    
    local espDistanceSlider = createSlider(espPage, "Max Distance", UDim2.new(0, 0, 0, 230), 100, 5000, 2000, function(value)
        Config.ESP.maxDistance = value
    end)
    
    --// Aimbot Page
    local aimbotToggle, getAimbotEnabled, setAimbotEnabled = createToggle(aimbotPage, "Aimbot Master", UDim2.new(0, 0, 0, 10), false, function(state)
        Config.Aimbot.enabled = state
        if state then Features.EnableAimbot() else Features.DisableAimbot() end
    end)
    
    local aimbotTeamToggle = createToggle(aimbotPage, "Team Check", UDim2.new(0, 0, 0, 65), true, function(state)
        Config.Aimbot.teamCheck = state
    end)
    
    local aimbotPredToggle = createToggle(aimbotPage, "Prediction", UDim2.new(0, 0, 0, 120), true, function(state)
        Config.Aimbot.prediction = state
    end)
    
    local aimbotStrengthSlider = createSlider(aimbotPage, "Aim Strength", UDim2.new(0, 0, 0, 175), 0.1, 1, 0.8, function(value)
        Config.Aimbot.strength = value
    end)
    
    --// Fly Page
    local flyToggle, getFlyEnabled, setFlyEnabled = createToggle(flyPage, "Fly Master", UDim2.new(0, 0, 0, 10), false, function(state)
        Config.Fly.enabled = state
        if state then Features.EnableFly() else Features.DisableFly() end
    end)
    
    local flySpeedSlider = createSlider(flyPage, "Fly Speed", UDim2.new(0, 0, 0, 65), 10, 150, 80, function(value)
        Config.Fly.speed = value
    end)
    
    local flyVSpeedSlider = createSlider(flyPage, "Vertical Speed", UDim2.new(0, 0, 0, 145), 10, 150, 70, function(value)
        Config.Fly.vSpeed = value
    end)
    
    --// Status Bar
    local statusBar = Instance.new("Frame")
    statusBar.Name = "StatusBar"
    statusBar.Size = UDim2.new(1, 0, 0, 30)
    statusBar.Position = UDim2.new(0, 0, 1, -30)
    statusBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    statusBar.BorderSizePixel = 0
    statusBar.Parent = content
    
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(0, 6)
    statusCorner.Parent = statusBar
    
    local statusText = Instance.new("TextLabel")
    statusText.Name = "StatusText"
    statusText.Size = UDim2.new(1, -20, 1, 0)
    statusText.Position = UDim2.new(0, 10, 0, 0)
    statusText.BackgroundTransparency = 1
    statusText.Text = "Wirtz Script Ready"
    statusText.TextColor3 = Color3.fromRGB(90, 255, 90)
    statusText.TextSize = 14
    statusText.Font = Enum.Font.GothamSemibold
    statusText.TextXAlignment = Enum.TextXAlignment.Left
    statusText.Parent = statusBar
    
    --// Show Status Function
    local function showStatus(text, color)
        statusText.Text = text
        statusText.TextColor3 = color or Color3.fromRGB(90, 255, 90)
    end
    
        --// Fly Controls
    local flyControls = Instance.new("Frame")
    flyControls.Name = "FlyControls"
    flyControls.Size = UDim2.new(0, 100, 0, 210)
    flyControls.Position = UDim2.new(0, 10, 0.5, -105)
    flyControls.BackgroundTransparency = 1
    flyControls.Visible = false
    flyControls.Parent = gui
    
    local upButton = Instance.new("TextButton")
    upButton.Name = "UpButton"
    upButton.Size = UDim2.new(1, 0, 0, 100)
    upButton.Position = UDim2.new(0, 0, 0, 0)
    upButton.BackgroundColor3 = Color3.fromRGB(60, 170, 60)
    upButton.BorderSizePixel = 0
    upButton.Text = "UP"
    upButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    upButton.TextSize = 18
    upButton.Font = Enum.Font.GothamBold
    upButton.Parent = flyControls
    
    local upCorner = Instance.new("UICorner")
    upCorner.CornerRadius = UDim.new(0, 8)
    upCorner.Parent = upButton
    
    local upStroke = Instance.new("UIStroke")
    upStroke.Color = Color3.fromRGB(40, 120, 40)
    upStroke.Thickness = 2
    upStroke.Parent = upButton
    
    local downButton = Instance.new("TextButton")
    downButton.Name = "DownButton"
    downButton.Size = UDim2.new(1, 0, 0, 100)
    downButton.Position = UDim2.new(0, 0, 0, 110)
    downButton.BackgroundColor3 = Color3.fromRGB(170, 60, 60)
    downButton.BorderSizePixel = 0
    downButton.Text = "DOWN"
    downButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    downButton.TextSize = 18
    downButton.Font = Enum.Font.GothamBold
    downButton.Parent = flyControls
    
    local downCorner = Instance.new("UICorner")
    downCorner.CornerRadius = UDim.new(0, 8)
    downCorner.Parent = downButton
    
    local downStroke = Instance.new("UIStroke")
    downStroke.Color = Color3.fromRGB(120, 40, 40)
    downStroke.Thickness = 2
    downStroke.Parent = downButton
    
    --// ESP Items Folder
    local espFolder = Instance.new("Folder")
    espFolder.Name = "ESPItems"
    espFolder.Parent = gui
    
    return {
        gui = gui,
        master = master,
        content = content,
        showStatus = showStatus,
        flyControls = {
            frame = flyControls,
            upButton = upButton,
            downButton = downButton
        },
        espFolder = espFolder,
        toggles = {
            esp = setESPEnabled,
            aimbot = setAimbotEnabled,
            fly = setFlyEnabled
        }
    }
end

--// Create ESP System
Features.CreateESP = function(player)
    if player == LocalPlayer then return end
    
    local esp = Instance.new("BillboardGui")
    esp.Name = "ESP_" .. player.Name
    esp.AlwaysOnTop = true
    esp.Size = UDim2.new(0, 200, 0, 50)
    esp.StudsOffset = Vector3.new(0, 3, 0)
    esp.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    esp.Parent = WirtzUI.espFolder
    
    --// Name Label
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1, 0, 0, 20)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.TextSize = 14
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = esp
    
    --// Distance Label
    local distLabel = Instance.new("TextLabel")
    distLabel.Name = "DistLabel"
    distLabel.Size = UDim2.new(1, 0, 0, 15)
    distLabel.Position = UDim2.new(0, 0, 0, 20)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = "0m"
    distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    distLabel.TextStrokeTransparency = 0.5
    distLabel.TextSize = 12
    distLabel.Font = Enum.Font.Gotham
    distLabel.Parent = esp
    
    --// Health Label
    local healthLabel = Instance.new("TextLabel")
    healthLabel.Name = "HealthLabel"
    healthLabel.Size = UDim2.new(1, 0, 0, 15)
    healthLabel.Position = UDim2.new(0, 0, 0, 35)
    healthLabel.BackgroundTransparency = 1
    healthLabel.Text = "100 HP"
    healthLabel.TextColor3 = Color3.fromRGB(90, 255, 90)
    healthLabel.TextStrokeTransparency = 0.5
    healthLabel.TextSize = 12
    healthLabel.Font = Enum.Font.Gotham
    healthLabel.Parent = esp
    
    return esp
end

--// Update ESP
Features.UpdateESP = function()
    for _, player in pairs(Services.Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local espItem = WirtzUI.espFolder:FindFirstChild("ESP_" .. player.Name)
            
            if not espItem and Config.ESP.enabled then
                espItem = Features.CreateESP(player)
            end
            
            if espItem then
                local character = player.Character
                if character and character:FindFirstChild("HumanoidRootPart") and Config.ESP.enabled then
                    local hrp = character:FindFirstChild("HumanoidRootPart")
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    
                    --// Team Check
                    if Config.ESP.teamCheck and player.Team == LocalPlayer.Team then
                        espItem.Enabled = false
                        continue
                    end
                    
                    --// Distance Check
                    local distance = (hrp.Position - Camera.CFrame.Position).Magnitude
                    if distance > Config.ESP.maxDistance then
                        espItem.Enabled = false
                        continue
                    end
                    
                    espItem.Adornee = hrp
                    espItem.Enabled = true
                    
                    --// Update Name
                    local nameLabel = espItem:FindFirstChild("NameLabel")
                    if nameLabel and player.Team then
                        nameLabel.TextColor3 = player.TeamColor.Color
                    end
                    
                    --// Update Distance
                    local distLabel = espItem:FindFirstChild("DistLabel")
                    if distLabel and Config.ESP.showInfo then
                        distLabel.Text = math.floor(distance) .. "m"
                        distLabel.Visible = true
                    elseif distLabel then
                        distLabel.Visible = false
                    end
                    
                    --// Update Health
                    local healthLabel = espItem:FindFirstChild("HealthLabel")
                    if healthLabel and humanoid and Config.ESP.showInfo then
                        local health = math.floor(humanoid.Health)
                        local maxHealth = math.floor(humanoid.MaxHealth)
                        healthLabel.Text = health .. " HP"
                        
                        --// Health Color
                        local healthRatio = health / maxHealth
                        healthLabel.TextColor3 = Color3.fromRGB(
                            255 * (1 - healthRatio),
                            255 * healthRatio,
                            50
                        )
                        
                        healthLabel.Visible = true
                    elseif healthLabel then
                        healthLabel.Visible = false
                    end
                else
                    espItem.Enabled = false
                end
            end
        end
    end
end

--// Enable ESP
Features.EnableESP = function()
    for _, player in pairs(Services.Players:GetPlayers()) do
        if player ~= LocalPlayer then
            Features.CreateESP(player)
        end
    end
    
    --// Track new players
    Services.Players.PlayerAdded:Connect(function(player)
        if player ~= LocalPlayer and Config.ESP.enabled then
            Features.CreateESP(player)
        end
    end)
    
    --// Update ESP
    Services.RunService:BindToRenderStep("UpdateESP", 5, Features.UpdateESP)
    
    WirtzUI.showStatus("ESP Enabled", Color3.fromRGB(90, 255, 90))
end

--// Disable ESP
Features.DisableESP = function()
    Services.RunService:UnbindFromRenderStep("UpdateESP")
    WirtzUI.espFolder:ClearAllChildren()
    
    WirtzUI.showStatus("ESP Disabled", Color3.fromRGB(255, 90, 90))
end

--// Aimbot Functions
Features.GetClosestPlayer = function()
    local closestPlayer = nil
    local shortestDistance = math.huge
    
    for _, player in pairs(Services.Players:GetPlayers()) do
        if player ~= LocalPlayer then
            --// Team Check
            if Config.Aimbot.teamCheck and player.Team == LocalPlayer.Team then
                continue
            end
            
            local character = player.Character
            if character and character:FindFirstChild(Config.Aimbot.part) and character:FindFirstChildOfClass("Humanoid") then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                
                --// Health Check
                if humanoid.Health <= 0 then continue end
                
                --// Visibility Check
                local targetPart = character[Config.Aimbot.part]
                local screenPos, onScreen = Camera:WorldToScreenPoint(targetPart.Position)
                
                if onScreen then
                    --// Distance Check
                    local screenCenter = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
                    local screenDistance = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                    
                    if screenDistance < shortestDistance then
                        shortestDistance = screenDistance
                        closestPlayer = player
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

--// Predict Position
Features.PredictPosition = function(player)
    local character = player.Character
    if not character or not character:FindFirstChild(Config.Aimbot.part) then return nil end
    
    local targetPart = character[Config.Aimbot.part]
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    if not humanoid then return targetPart.Position end
    
    --// Basic Prediction
    if Config.Aimbot.prediction and humanoid.MoveDirection.Magnitude > 0 then
        local velocity = humanoid.MoveDirection * humanoid.WalkSpeed
        return targetPart.Position + (velocity * 0.1)
    else
        return targetPart.Position
    end
end

--// Enable Aimbot
Features.EnableAimbot = function()
    --// Aiming State
    local isAiming = false
    
    --// Mobile Input
    Services.UIS.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            isAiming = true
        end
    end)
    
    Services.UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            isAiming = false
        end
    end)
    
    --// Main Aimbot Loop
    Services.RunService:BindToRenderStep("AimbotLoop", 1, function()
        if not Config.Aimbot.enabled then return end
        
        --// Check Aiming
        if not isAiming then return end
        
        --// Get Target
        local target = Features.GetClosestPlayer()
        if not target then return end
        
        --// Aim at Target
        local character = target.Character
        if not character or not character:FindFirstChild(Config.Aimbot.part) then return end
        
        --// Predict Movement
        local predictedPosition = Features.PredictPosition(target)
        if not predictedPosition then return end
        
        --// Apply Aim with Strength
        local cameraPos = Camera.CFrame.Position
        local newCFrame = CFrame.new(cameraPos, predictedPosition)
        
        --// Ultra strong aim lock ("gruda" no alvo)
        Camera.CFrame = Camera.CFrame:Lerp(newCFrame, Config.Aimbot.strength)
    end)
    
    WirtzUI.showStatus("Aimbot Enabled", Color3.fromRGB(90, 255, 90))
end

--// Disable Aimbot
Features.DisableAimbot = function()
    Services.RunService:UnbindFromRenderStep("AimbotLoop")
    WirtzUI.showStatus("Aimbot Disabled", Color3.fromRGB(255, 90, 90))
end

--// Fly Variables
local FlyGyro, FlyVel

--// Enable Fly
Features.EnableFly = function()
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        WirtzUI.showStatus("Error: Character not found", Color3.fromRGB(255, 90, 90))
        WirtzUI.toggles.fly(false)
        return
    end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    
    FlyGyro = Instance.new("BodyGyro")
    FlyGyro.P = 9e4
    FlyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    FlyGyro.CFrame = hrp.CFrame
    FlyGyro.Parent = hrp
    
    FlyVel = Instance.new("BodyVelocity")
    FlyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    FlyVel.Velocity = Vector3.new(0, 0.1, 0)
    FlyVel.Parent = hrp
    
    --// Show Controls
    WirtzUI.flyControls.frame.Visible = true
    
    --// Control States
    local isUp, isDown = false, false
    
    --// Button Events
    WirtzUI.flyControls.upButton.MouseButton1Down:Connect(function()
        isUp = true
    end)
    
    WirtzUI.flyControls.upButton.MouseButton1Up:Connect(function()
        isUp = false
    end)
    
    WirtzUI.flyControls.downButton.MouseButton1Down:Connect(function()
        isDown = true
    end)
    
    WirtzUI.flyControls.downButton.MouseButton1Up:Connect(function()
        isDown = false
    end)
    
    --// Main Fly Loop
    Services.RunService:BindToRenderStep("FlyLoop", 1, function()
        if not Config.Fly.enabled then return end
        
        local character = LocalPlayer.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then
            Features.DisableFly()
            return
        end
        
        local hrp = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        
        --// Update Orientation
        FlyGyro.CFrame = CFrame.new(hrp.Position, hrp.Position + Camera.CFrame.LookVector)
        
        --// Movement Direction
        local moveDir = humanoid.MoveDirection
        
        --// Vertical Movement
        local verticalSpeed = 0
        if isUp then
            verticalSpeed = Config.Fly.vSpeed
        elseif isDown then
            verticalSpeed = -Config.Fly.vSpeed
        end
        
        --// Apply Velocity
        FlyVel.Velocity = Vector3.new(
            moveDir.X * Config.Fly.speed,
            verticalSpeed,
            moveDir.Z * Config.Fly.speed
        )
    end)
    
    WirtzUI.showStatus("Fly Enabled", Color3.fromRGB(90, 255, 90))
end

--// Disable Fly
Features.DisableFly = function()
    Services.RunService:UnbindFromRenderStep("FlyLoop")
    
    if FlyGyro then FlyGyro:Destroy() end
    if FlyVel then FlyVel:Destroy() end
    
    FlyGyro = nil
    FlyVel = nil
    
    --// Hide Controls
    WirtzUI.flyControls.frame.Visible = false
    
    WirtzUI.showStatus("Fly Disabled", Color3.fromRGB(255, 90, 90))
end

--// Disable All Features
Features.DisableAll = function()
    if Config.ESP.enabled then
        Config.ESP.enabled = false
        Features.DisableESP()
    end
    
    if Config.Aimbot.enabled then
        Config.Aimbot.enabled = false
        Features.DisableAimbot()
    end
    
    if Config.Fly.enabled then
        Config.Fly.enabled = false
        Features.DisableFly()
    end
end

--// Remove Players
Services.Players.PlayerRemoving:Connect(function(player)
    local esp = WirtzUI.espFolder:FindFirstChild("ESP_" .. player.Name)
    if esp then esp:Destroy() end
end)

--// Initialize
WirtzUI = WirtzUI.create()
WirtzUI.showStatus("Wirtz Script Loaded", Color3.fromRGB(90, 255, 90))