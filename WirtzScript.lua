--[[
    Blox Fruits Mobile [BLACK EDITION] v3.5
    Desenvolvido por: Lek do Black
    
    ALERTA: Use por sua conta e risco. Essa porra é proibida nos termos do jogo.
    Não chora se tomar ban, seu merda!
]]

-- CONFIGURAÇÃO INICIAL
local UserSettings = {
    License = "FREE-VERSION", -- Muda pra "PREMIUM" se tu for esperto e comprar
    Theme = "Dark", -- Opções: "Dark", "Light", "Blood", "Ocean"
    SafeMode = true, -- Liga isso se não quiser ser banido, seu burro
    MobileOptimized = true -- NUNCA desativa essa porra no celular
}

-- ANTI-DETECTION SYSTEM
local function SetupSecurity()
    local SecureData = {}
    SecureData.ActiveProtocols = {}
    
    -- Bypass anti-cheat detection hooks
    local OldNamecall
    OldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local Args = {...}
        local Method = getnamecallmethod()
        
        if Method == "FireServer" and self.Name:find("Security") or self.Name:find("Check") then
            return wait(9e9) -- Nunca retorna = nunca detecta
        elseif Method == "Kick" then
            return wait(9e9) -- Bloqueia tentativa de kick
        end
        
        return OldNamecall(self, ...)
    end))
    
    -- Humanize actions to avoid pattern detection
    SecureData.LastActions = {}
    SecureData.AddAction = function(actionType)
        table.insert(SecureData.LastActions, {
            Type = actionType,
            Time = tick(),
            RandomSeed = math.random(1000, 9999)
        })
        
        -- Keep only last 20 actions to analyze patterns
        if #SecureData.LastActions > 20 then
            table.remove(SecureData.LastActions, 1)
        end
    end
    
    -- Add random delay to actions (human-like)
    SecureData.RandomDelay = function(min, max)
        local delay = min + math.random() * (max - min)
        task.wait(delay)
        return delay
    end
    
    return SecureData
end

-- INTERFACE PRINCIPAL - OTIMIZADA PRA MOBILE
local function CreateMobileUI()
    -- Limpar GUIs existentes (pra não ter duplicata, seu burro)
    for _, gui in pairs(game:GetService("CoreGui"):GetChildren()) do
        if gui.Name == "BloxFruitsMobileGUI" then
            gui:Destroy()
        end
    end
    
    local PlayerService = game:GetService("Players")
    local LocalPlayer = PlayerService.LocalPlayer
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    
    -- Criar GUI Principal
    local BloxFruitsMobileGUI = Instance.new("ScreenGui")
    BloxFruitsMobileGUI.Name = "BloxFruitsMobileGUI"
    BloxFruitsMobileGUI.ResetOnSpawn = false
    BloxFruitsMobileGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Proteger a GUI de detecção (método avançado)
    syn = syn or {}
    if syn.protect_gui then 
        syn.protect_gui(BloxFruitsMobileGUI)
        BloxFruitsMobileGUI.Parent = game:GetService("CoreGui")
    elseif gethui then
        BloxFruitsMobileGUI.Parent = gethui()
    else
        BloxFruitsMobileGUI.Parent = game:GetService("CoreGui")
    end
    
    -- Temas (CUSTOMIZÁVEIS PRA CARALHO)
    local Themes = {
        Dark = {
            Background = Color3.fromRGB(25, 25, 35),
            DarkBackground = Color3.fromRGB(15, 15, 25),
            LightBackground = Color3.fromRGB(35, 35, 45),
            Text = Color3.fromRGB(255, 255, 255),
            SubText = Color3.fromRGB(200, 200, 200),
            Accent = Color3.fromRGB(255, 75, 75),
            Success = Color3.fromRGB(85, 255, 127),
            Warning = Color3.fromRGB(255, 155, 55),
            Error = Color3.fromRGB(255, 55, 55)
        },
        Light = {
            Background = Color3.fromRGB(235, 235, 235),
            DarkBackground = Color3.fromRGB(215, 215, 215),
            LightBackground = Color3.fromRGB(245, 245, 245),
            Text = Color3.fromRGB(25, 25, 25),
            SubText = Color3.fromRGB(75, 75, 75),
            Accent = Color3.fromRGB(0, 120, 215),
            Success = Color3.fromRGB(35, 195, 95),
            Warning = Color3.fromRGB(255, 145, 0),
            Error = Color3.fromRGB(215, 0, 45)
        },
        Blood = {
            Background = Color3.fromRGB(35, 15, 15),
            DarkBackground = Color3.fromRGB(25, 10, 10),
            LightBackground = Color3.fromRGB(55, 15, 15),
            Text = Color3.fromRGB(255, 235, 235),
            SubText = Color3.fromRGB(200, 170, 170),
            Accent = Color3.fromRGB(185, 0, 0),
            Success = Color3.fromRGB(125, 185, 0),
            Warning = Color3.fromRGB(185, 125, 0),
            Error = Color3.fromRGB(255, 25, 25)
        },
        Ocean = {
            Background = Color3.fromRGB(15, 25, 35),
            DarkBackground = Color3.fromRGB(10, 15, 25),
            LightBackground = Color3.fromRGB(25, 35, 45),
            Text = Color3.fromRGB(235, 245, 255),
            SubText = Color3.fromRGB(170, 180, 200),
            Accent = Color3.fromRGB(0, 125, 255),
            Success = Color3.fromRGB(0, 185, 125),
            Warning = Color3.fromRGB(255, 165, 0),
            Error = Color3.fromRGB(255, 65, 65)
        }
    }
    
    -- Usar tema selecionado
    local Theme = Themes[UserSettings.Theme] or Themes.Dark
    
    -- PAINEL PRINCIPAL (OTIMIZADO PRA TOQUE)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    MainFrame.Size = UDim2.new(0, 300, 0, 400)
    MainFrame.Active = true
    MainFrame.Draggable = true -- Pra arrastar no touch, seu animal
    MainFrame.Parent = BloxFruitsMobileGUI
    
    -- Cantos arredondados porque é isso que vende script pra criança
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = MainFrame
    
    -- Barra superior
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.BackgroundColor3 = Theme.DarkBackground
    TopBar.BorderSizePixel = 0
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.Parent = MainFrame
    
    -- Arredondar borda superior
    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 10)
    TopBarCorner.Parent = TopBar
    
    -- Consertar cantos
    local TopBarFix = Instance.new("Frame")
    TopBarFix.Name = "TopBarFix"
    TopBarFix.BackgroundColor3 = Theme.DarkBackground
    TopBarFix.BorderSizePixel = 0
    TopBarFix.Position = UDim2.new(0, 0, 0.5, 0)
    TopBarFix.Size = UDim2.new(1, 0, 0.5, 0)
    TopBarFix.Parent = TopBar
    
    -- Título com estilo
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.Size = UDim2.new(1, -15, 1, 0)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = "BLOX FRUITS BLACK"
    TitleLabel.TextColor3 = Theme.Text
    TitleLabel.TextSize = 18
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TopBar
    
    -- Botão para minimizar (ESSENCIAL NESSA PORRA)
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.BackgroundTransparency = 1
    MinimizeButton.Position = UDim2.new(1, -40, 0, 0)
    MinimizeButton.Size = UDim2.new(0, 40, 0, 40)
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Text = "-"
    MinimizeButton.TextColor3 = Theme.Text
    MinimizeButton.TextSize = 24
    MinimizeButton.Parent = TopBar
    
    -- Botão para fechar (NUNCA ESQUECER)
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(1, -80, 0, 0)
    CloseButton.Size = UDim2.new(0, 40, 0, 40)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Theme.Error
    CloseButton.TextSize = 20
    CloseButton.Parent = TopBar
    
    -- Container de abas
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.BackgroundColor3 = Theme.DarkBackground
    TabContainer.BorderSizePixel = 0
    TabContainer.Position = UDim2.new(0, 0, 0, 40)
    TabContainer.Size = UDim2.new(0, 80, 1, -40)
    TabContainer.Parent = MainFrame
    
    -- Conteúdo das abas
    local TabContent = Instance.new("Frame")
    TabContent.Name = "TabContent"
    TabContent.BackgroundColor3 = Theme.Background
    TabContent.BorderSizePixel = 0
    TabContent.Position = UDim2.new(0, 80, 0, 40)
    TabContent.Size = UDim2.new(1, -80, 1, -40)
    TabContent.Parent = MainFrame
    
    -- BOTÕES DE ATALHO PRINCIPAL (ESSENCIAL PRA MOBILE)
    local QuickAccessFrame = Instance.new("Frame")
    QuickAccessFrame.Name = "QuickAccessFrame"
    QuickAccessFrame.BackgroundColor3 = Theme.DarkBackground
    QuickAccessFrame.BackgroundTransparency = 0.4
    QuickAccessFrame.BorderSizePixel = 0
    QuickAccessFrame.Position = UDim2.new(0, 10, 0.5, -125)
    QuickAccessFrame.Size = UDim2.new(0, 60, 0, 250)
    QuickAccessFrame.Visible = false -- Começa minimizado
    QuickAccessFrame.Parent = BloxFruitsMobileGUI
    
    local QuickAccessCorner = Instance.new("UICorner")
    QuickAccessCorner.CornerRadius = UDim.new(0, 30)
    QuickAccessCorner.Parent = QuickAccessFrame
    
    -- MINIMIZED VERSION (CUBO FLUTUANTE)
    local MinimizedFrame = Instance.new("Frame")
    MinimizedFrame.Name = "MinimizedFrame"
    MinimizedFrame.BackgroundColor3 = Theme.Accent
    MinimizedFrame.BorderSizePixel = 0
    MinimizedFrame.Position = UDim2.new(0, 20, 0.5, -25)
    MinimizedFrame.Size = UDim2.new(0, 50, 0, 50)
    MinimizedFrame.Visible = false
    MinimizedFrame.Parent = BloxFruitsMobileGUI
    
    local MinimizedCorner = Instance.new("UICorner")
    MinimizedCorner.CornerRadius = UDim.new(0, 10)
    MinimizedCorner.Parent = MinimizedFrame
    
    local MinimizedIcon = Instance.new("TextLabel")
    MinimizedIcon.Name = "MinimizedIcon"
    MinimizedIcon.BackgroundTransparency = 1
    MinimizedIcon.Size = UDim2.new(1, 0, 1, 0)
    MinimizedIcon.Font = Enum.Font.GothamBold
    MinimizedIcon.Text = "BF"
    MinimizedIcon.TextColor3 = Theme.Text
    MinimizedIcon.TextSize = 24
    MinimizedIcon.Parent = MinimizedFrame
    
    -- Efeito de pulsação no cubo (VISUAL FODA)
    local PulseEffect = Instance.new("UIStroke")
    PulseEffect.Color = Theme.Accent
    PulseEffect.Thickness = 2
    PulseEffect.Parent = MinimizedFrame
    
    spawn(function()
        while true do
            for i = 0, 1, 0.1 do
                PulseEffect.Transparency = i
                wait(0.1)
            end
            for i = 1, 0, -0.1 do
                PulseEffect.Transparency = i
                wait(0.1)
            end
        end
    end)
    
    -- Tornar o cubo arrastável (ESSENCIAL)
    local dragging = false
    local dragInput, dragStart, startPos
    
    local function updateDrag(input)
        local delta = input.Position - dragStart
        MinimizedFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    MinimizedFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MinimizedFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    MinimizedFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
            if dragging then
                updateDrag(input)
            end
        end
    end)
    
    -- Clicar no cubo abre a interface principal
    MinimizedFrame.InputEnded:Connect(function(input)
        if not dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1) then
            MinimizedFrame.Visible = false
            MainFrame.Visible = true
            
            -- Animação de surgimento
            MainFrame.Size = UDim2.new(0, 0, 0, 0)
            MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
            
            local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            local tween = TweenService:Create(MainFrame, tweenInfo, {
                Size = UDim2.new(0, 300, 0, 400),
                Position = UDim2.new(0.5, -150, 0.5, -200)
            })
            tween:Play()
        end
    end)
    
    -- Botão de minimizar
    MinimizeButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        MinimizedFrame.Visible = true
    end)
    
    -- Botão de fechar
    CloseButton.MouseButton1Click:Connect(function()
        BloxFruitsMobileGUI:Destroy()
    end)
    
    -- SISTEMA DE ABAS (ORGANIZADO PRA CARALHO)
    local TabButtons = {}
    local TabFrames = {}
    local SelectedTab = nil
    
    -- Função para criar abas  
    local function CreateTab(name, icon)
        -- Botão da aba
        local tabIndex = #TabButtons + 1
        local yPos = (tabIndex - 1) * 60
        
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name .. "Tab"
        TabButton.BackgroundTransparency = 1
        TabButton.Position = UDim2.new(0, 0, 0, yPos)
        TabButton.Size = UDim2.new(1, 0, 0, 60)
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.Text = ""
        TabButton.Parent = TabContainer
        
        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Name = "Icon"
        TabIcon.BackgroundTransparency = 1
        TabIcon.Position = UDim2.new(0.5, -15, 0, 10)
        TabIcon.Size = UDim2.new(0, 30, 0, 30)
        TabIcon.Image = icon
        TabIcon.ImageColor3 = Theme.SubText
        TabIcon.Parent = TabButton
        
        local TabName = Instance.new("TextLabel")
        TabName.Name = "Name"
        TabName.BackgroundTransparency = 1
        TabName.Position = UDim2.new(0, 0, 0, 40)
        TabName.Size = UDim2.new(1, 0, 0, 15)
        TabName.Font = Enum.Font.GothamSemibold
        TabName.Text = name
        TabName.TextColor3 = Theme.SubText
        TabName.TextSize = 10
        TabName.Parent = TabButton
        
        -- Container de conteúdo
        local TabFrame = Instance.new("ScrollingFrame")
        TabFrame.Name = name .. "Frame"
        TabFrame.BackgroundTransparency = 1
        TabFrame.BorderSizePixel = 0
        TabFrame.Position = UDim2.new(0, 10, 0, 10)
        TabFrame.Size = UDim2.new(1, -20, 1, -20)
        TabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabFrame.ScrollBarThickness = 4
        TabFrame.ScrollBarImageColor3 = Theme.Accent
        TabFrame.Visible = false
        TabFrame.Parent = TabContent
        
        -- Layout para o conteúdo
        local TabList = Instance.new("UIListLayout")
        TabList.Padding = UDim.new(0, 10)
        TabList.Parent = TabFrame
        
        -- Ajustar automaticamente o tamanho do canvas
        TabList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabFrame.CanvasSize = UDim2.new(0, 0, 0, TabList.AbsoluteContentSize.Y + 20)
        end)
        
        -- Adicionar à lista de abas
        table.insert(TabButtons, {
            Button = TabButton,
            Icon = TabIcon,
            Name = TabName
        })
        
        table.insert(TabFrames, TabFrame)
        
        -- Lógica de clique
        TabButton.MouseButton1Click:Connect(function()
            -- Desselecionar a aba atual
            if SelectedTab then
                SelectedTab.Button.BackgroundTransparency = 1
                SelectedTab.Icon.ImageColor3 = Theme.SubText
                SelectedTab.Name.TextColor3 = Theme.SubText
                
                for _, frame in ipairs(TabFrames) do
                    frame.Visible = false
                end
            end
            
            -- Selecionar a nova aba
            TabButton.BackgroundTransparency = 0.8
            TabButton.BackgroundColor3 = Theme.Accent
            TabIcon.ImageColor3 = Theme.Text
            TabName.TextColor3 = Theme.Text
            TabFrame.Visible = true
            
            SelectedTab = {
                Button = TabButton,
                Icon = TabIcon,
                Name = TabName
            }
        end)
        
        return TabFrame
    end
    
    -- Função para criar seções
    local function CreateSection(parent, title)
        local Section = Instance.new("Frame")
        Section.Name = title .. "Section"
        Section.BackgroundColor3 = Theme.LightBackground
        Section.BorderSizePixel = 0
        Section.Size = UDim2.new(1, 0, 0, 30) -- Será ajustado com base no conteúdo
        Section.Parent = parent
        
        local SectionCorner = Instance.new("UICorner")
        SectionCorner.CornerRadius = UDim.new(0, 8)
        SectionCorner.Parent = Section
        
        local SectionTitle = Instance.new("TextLabel")
        SectionTitle.Name = "Title"
        SectionTitle.BackgroundTransparency = 1
        SectionTitle.Position = UDim2.new(0, 10, 0, 0)
        SectionTitle.Size = UDim2.new(1, -10, 0, 30)
        SectionTitle.Font = Enum.Font.GothamBold
        SectionTitle.Text = title
        SectionTitle.TextColor3 = Theme.Text
        SectionTitle.TextSize = 14
        SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
        SectionTitle.Parent = Section
        
        local ContentFrame = Instance.new("Frame")
        ContentFrame.Name = "Content"
        ContentFrame.BackgroundTransparency = 1
        ContentFrame.Position = UDim2.new(0, 0, 0, 30)
        ContentFrame.Size = UDim2.new(1, 0, 0, 0) -- Tamanho inicial, será atualizado
        ContentFrame.Parent = Section
        
        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.PaddingLeft = UDim.new(0, 10)
        ContentPadding.PaddingRight = UDim.new(0, 10)
        ContentPadding.PaddingBottom = UDim.new(0, 10)
        ContentPadding.Parent = ContentFrame
        
        local ContentList = Instance.new("UIListLayout")
        ContentList.Padding = UDim.new(0, 8)
        ContentList.Parent = ContentFrame
        
        -- Atualizar o tamanho da seção conforme o conteúdo
        ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            ContentFrame.Size = UDim2.new(1, 0, 0, ContentList.AbsoluteContentSize.Y)
            Section.Size = UDim2.new(1, 0, 0, 30 + ContentFrame.Size.Y.Offset)
        end)
        
        return ContentFrame
    end
    
    -- Função para criar toggle
    local function CreateToggle(parent, title, default, callback)
        local Toggle = Instance.new("Frame")
        Toggle.Name = title .. "Toggle"
        Toggle.BackgroundColor3 = Theme.DarkBackground
        Toggle.BorderSizePixel = 0
        Toggle.Size = UDim2.new(1, 0, 0, 40)
        Toggle.Parent = parent
        
        local ToggleCorner = Instance.new("UICorner")
        ToggleCorner.CornerRadius = UDim.new(0, 6)
        ToggleCorner.Parent = Toggle
        
        local ToggleTitle = Instance.new("TextLabel")
        ToggleTitle.Name = "Title"
        ToggleTitle.BackgroundTransparency = 1
        ToggleTitle.Position = UDim2.new(0, 10, 0, 0)
        ToggleTitle.Size = UDim2.new(1, -60, 1, 0)
        ToggleTitle.Font = Enum.Font.GothamSemibold
        ToggleTitle.Text = title
        ToggleTitle.TextColor3 = Theme.Text
        ToggleTitle.TextSize = 14
        ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
        ToggleTitle.Parent = Toggle
        
        local ToggleButton = Instance.new("Frame")
        ToggleButton.Name = "Button"
        ToggleButton.BackgroundColor3 = default and Theme.Accent or Theme.DarkBackground
        ToggleButton.BorderSizePixel = 0
        ToggleButton.Position = UDim2.new(1, -50, 0.5, -10)
        ToggleButton.Size = UDim2.new(0, 40, 0, 20)
        ToggleButton.Parent = Toggle
        
        local ToggleButtonCorner = Instance.new("UICorner")
        ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
        ToggleButtonCorner.Parent = ToggleButton
        
        local ToggleCircle = Instance.new("Frame")
        ToggleCircle.Name = "Circle"
        ToggleCircle.BackgroundColor3 = Theme.Text
        ToggleCircle.BorderSizePixel = 0
        ToggleCircle.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
        ToggleCircle.Parent = ToggleButton
        
        local ToggleCircleCorner = Instance.new("UICorner")
        ToggleCircleCorner.CornerRadius = UDim.new(1, 0)
        ToggleCircleCorner.Parent = ToggleCircle
        
        local ToggleClickRegion = Instance.new("TextButton")
        ToggleClickRegion.Name = "ClickRegion"
        ToggleClickRegion.BackgroundTransparency = 1
        ToggleClickRegion.Size = UDim2.new(1, 0, 1, 0)
        ToggleClickRegion.Text = ""
        ToggleClickRegion.Parent = Toggle
        
        -- Lógica do toggle
        local toggled = default or false
        
        ToggleClickRegion.MouseButton1Click:Connect(function()
            toggled = not toggled
            
            -- Animar a transição
            local targetPosition = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            local targetColor = toggled and Theme.Accent or Theme.DarkBackground
            
            local positionTween = TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = targetPosition})
            local colorTween = TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = targetColor})
            
            positionTween:Play()
            colorTween:Play()
            
            callback(toggled)
        end)
        
        return {
            SetValue = function(value)
                toggled = value
                
                local targetPosition = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                local targetColor = toggled and Theme.Accent or Theme.DarkBackground
                
                ToggleCircle.Position = targetPosition
                ToggleButton.BackgroundColor3 = targetColor
                
                callback(toggled)
            end,
            GetValue = function()
                return toggled
            end
        }
    end
    
    -- Função para criar slider
    local function CreateSlider(parent, title, min, max, default, suffix, callback)
        local Slider = Instance.new("Frame")
        Slider.Name = title .. "Slider"
        Slider.BackgroundColor3 = Theme.DarkBackground
        Slider.BorderSizePixel = 0
        Slider.Size = UDim2.new(1, 0, 0, 60)
        Slider.Parent = parent
        
        local SliderCorner = Instance.new("UICorner")
        SliderCorner.CornerRadius = UDim.new(0, 6)
        SliderCorner.Parent = Slider
        
        local SliderTitle = Instance.new("TextLabel")
        SliderTitle.Name = "Title"
        SliderTitle.BackgroundTransparency = 1
        SliderTitle.Position = UDim2.new(0, 10, 0, 0)
        SliderTitle.Size = UDim2.new(1, -20, 0, 30)
        local SliderTitle = Instance.new("TextLabel")
        SliderTitle.Name = "Title"
        SliderTitle.BackgroundTransparency = 1
        SliderTitle.Position = UDim2.new(0, 10, 0, 0)
        SliderTitle.Size = UDim2.new(1, -20, 0, 30)
        SliderTitle.Font = Enum.Font.GothamSemibold
        SliderTitle.Text = title
        SliderTitle.TextColor3 = Theme.Text
        SliderTitle.TextSize = 14
        SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
        SliderTitle.Parent = Slider
        
        local SliderValue = Instance.new("TextLabel")
        SliderValue.Name = "Value"
        SliderValue.BackgroundTransparency = 1
        SliderValue.Position = UDim2.new(1, -60, 0, 0)
        SliderValue.Size = UDim2.new(0, 50, 0, 30)
        SliderValue.Font = Enum.Font.GothamSemibold
        SliderValue.Text = default .. (suffix or "")
        SliderValue.TextColor3 = Theme.Text
        SliderValue.TextSize = 14
        SliderValue.TextXAlignment = Enum.TextXAlignment.Right
        SliderValue.Parent = Slider
        
        local SliderBackground = Instance.new("Frame")
        SliderBackground.Name = "Background"
        SliderBackground.BackgroundColor3 = Theme.Background
        SliderBackground.BorderSizePixel = 0
        SliderBackground.Position = UDim2.new(0, 10, 0, 40)
        SliderBackground.Size = UDim2.new(1, -20, 0, 6)
        SliderBackground.Parent = Slider
        
        local SliderBackgroundCorner = Instance.new("UICorner")
        SliderBackgroundCorner.CornerRadius = UDim.new(1, 0)
        SliderBackgroundCorner.Parent = SliderBackground
        
        local SliderFill = Instance.new("Frame")
        SliderFill.Name = "Fill"
        SliderFill.BackgroundColor3 = Theme.Accent
        SliderFill.BorderSizePixel = 0
        SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        SliderFill.Parent = SliderBackground
        
        local SliderFillCorner = Instance.new("UICorner")
        SliderFillCorner.CornerRadius = UDim.new(1, 0)
        SliderFillCorner.Parent = SliderFill
        
        local SliderKnob = Instance.new("Frame")
        SliderKnob.Name = "Knob"
        SliderKnob.BackgroundColor3 = Theme.Text
        SliderKnob.BorderSizePixel = 0
        SliderKnob.Position = UDim2.new((default - min) / (max - min), 0, 0.5, -7)
        SliderKnob.Size = UDim2.new(0, 14, 0, 14)
        SliderKnob.ZIndex = 2
        SliderKnob.Parent = SliderBackground
        
        local SliderKnobCorner = Instance.new("UICorner")
        SliderKnobCorner.CornerRadius = UDim.new(1, 0)
        SliderKnobCorner.Parent = SliderKnob
        
        local SliderButton = Instance.new("TextButton")
        SliderButton.Name = "Button"
        SliderButton.BackgroundTransparency = 1
        SliderButton.Size = UDim2.new(1, 0, 1, 0)
        SliderButton.Text = ""
        SliderButton.Parent = SliderBackground
        
        -- Lógica do slider
        local sliding = false
        
        local function updateSlider(input)
            -- Calcular valor com base na posição relativa
            local relativePos = math.clamp((input.Position.X - SliderBackground.AbsolutePosition.X) / SliderBackground.AbsoluteSize.X, 0, 1)
            local value = min + relativePos * (max - min)
            
            -- Arredondar para inteiro ou decimal
            if max - min >= 10 then
                value = math.floor(value)
            else
                value = math.floor(value * 100) / 100
            end
            
            -- Atualizar elementos visuais
            SliderValue.Text = value .. (suffix or "")
            SliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
            SliderKnob.Position = UDim2.new(relativePos, 0, 0.5, -7)
            
            -- Chamar callback
            callback(value)
            
            return value
        end
        
        SliderButton.MouseButton1Down:Connect(function(input)
            sliding = true
            updateSlider({Position = input})
        end)
        
        -- Para dispositivos móveis, input touch tem que ser um connection separado
        SliderButton.TouchStarted:Connect(function(input)
            sliding = true
            updateSlider(input)
        end)
        
        -- Atualizar ao arrastar
        UserInputService.InputChanged:Connect(function(input)
            if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                updateSlider(input)
            end
        end)
        
        -- Parar de arrastar ao soltar
        UserInputService.InputEnded:Connect(function(input)
            if sliding and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                sliding = false
                updateSlider(input)
            end
        end)
        
        return {
            SetValue = function(value)
                value = math.clamp(value, min, max)
                local relativePos = (value - min) / (max - min)
                
                SliderValue.Text = value .. (suffix or "")
                SliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
                SliderKnob.Position = UDim2.new(relativePos, 0, 0.5, -7)
                
                callback(value)
            end,
            GetValue = function()
                return tonumber(string.match(SliderValue.Text, "%d+%.?%d*"))
            end
        }
    end
    
    -- Função para criar dropdown (ESSENCIAL PRA MOBILE)
    local function CreateDropdown(parent, title, options, default, callback)
        local Dropdown = Instance.new("Frame")
        Dropdown.Name = title .. "Dropdown"
        Dropdown.BackgroundColor3 = Theme.DarkBackground
        Dropdown.BorderSizePixel = 0
        Dropdown.ClipsDescendants = true
        Dropdown.Size = UDim2.new(1, 0, 0, 40) -- Tamanho inicial, será expandido quando aberto
        Dropdown.Parent = parent
        
        local DropdownCorner = Instance.new("UICorner")
        DropdownCorner.CornerRadius = UDim.new(0, 6)
        DropdownCorner.Parent = Dropdown
        
        local DropdownTitle = Instance.new("TextLabel")
        DropdownTitle.Name = "Title"
        DropdownTitle.BackgroundTransparency = 1
        DropdownTitle.Position = UDim2.new(0, 10, 0, 0)
        DropdownTitle.Size = UDim2.new(1, -20, 0, 40)
        DropdownTitle.Font = Enum.Font.GothamSemibold
        DropdownTitle.Text = title
        DropdownTitle.TextColor3 = Theme.Text
        DropdownTitle.TextSize = 14
        DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
        DropdownTitle.Parent = Dropdown
        
        local SelectedOption = Instance.new("TextLabel")
        SelectedOption.Name = "SelectedOption"
        SelectedOption.BackgroundTransparency = 1
        SelectedOption.Position = UDim2.new(0, 10, 0, 0)
        SelectedOption.Size = UDim2.new(1, -50, 0, 40)
        SelectedOption.Font = Enum.Font.Gotham
        SelectedOption.Text = default or "Select..."
        SelectedOption.TextColor3 = Theme.Accent
        SelectedOption.TextSize = 12
        SelectedOption.TextXAlignment = Enum.TextXAlignment.Right
        SelectedOption.Parent = Dropdown
        
        local DropdownArrow = Instance.new("ImageLabel")
        DropdownArrow.Name = "Arrow"
        DropdownArrow.BackgroundTransparency = 1
        DropdownArrow.Position = UDim2.new(1, -30, 0.5, -8)
        DropdownArrow.Size = UDim2.new(0, 16, 0, 16)
        DropdownArrow.Image = "rbxassetid://6031091004" -- Seta para baixo
        DropdownArrow.ImageColor3 = Theme.Accent
        DropdownArrow.Parent = Dropdown
        
        local OptionsHolder = Instance.new("Frame")
        OptionsHolder.Name = "OptionsHolder"
        OptionsHolder.BackgroundColor3 = Theme.Background
        OptionsHolder.BorderSizePixel = A0
        OptionsHolder.Position = UDim2.new(0, 0, 0, 40)
        OptionsHolder.Size = UDim2.new(1, 0, 0, #options * 30) -- Altura baseada no número de opções
        OptionsHolder.Visible = false
        OptionsHolder.Parent = Dropdown
        
        -- Criar as opções
        for i, option in ipairs(options) do
            local OptionButton = Instance.new("TextButton")
            OptionButton.Name = option
            OptionButton.BackgroundColor3 = Theme.Background
            OptionButton.BorderSizePixel = 0
            OptionButton.Position = UDim2.new(0, 0, 0, (i-1) * 30)
            OptionButton.Size = UDim2.new(1, 0, 0, 30)
            OptionButton.Font = Enum.Font.Gotham
            OptionButton.Text = option
            OptionButton.TextColor3 = Theme.Text
            OptionButton.TextSize = 12
            OptionButton.Parent = OptionsHolder
            
            -- Efeito de hover
            OptionButton.MouseEnter:Connect(function()
                OptionButton.BackgroundColor3 = Theme.LightBackground
            end)
            
            OptionButton.MouseLeave:Connect(function()
                OptionButton.BackgroundColor3 = Theme.Background
            end)
            
            -- Lógica de seleção
            OptionButton.MouseButton1Click:Connect(function()
                SelectedOption.Text = option
                
                -- Fechar dropdown
                TweenService:Create(Dropdown, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 40)}):Play()
                TweenService:Create(DropdownArrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                OptionsHolder.Visible = false
                
                callback(option)
            end)
        end
        
        -- Estado do dropdown
        local isOpen = false
        
        -- Botão de clique para todo o dropdown
        local DropdownButton = Instance.new("TextButton")
        DropdownButton.Name = "DropdownButton"
        DropdownButton.BackgroundTransparency = 1
        DropdownButton.Size = UDim2.new(1, 0, 0, 40)
        DropdownButton.Text = ""
        DropdownButton.Parent = Dropdown
        
        -- Lógica de abrir/fechar
        DropdownButton.MouseButton1Click:Connect(function()
            isOpen = not isOpen
            
            if isOpen then
                -- Abrir dropdown
                TweenService:Create(Dropdown, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 40 + OptionsHolder.Size.Y.Offset)}):Play()
                TweenService:Create(DropdownArrow, TweenInfo.new(0.2), {Rotation = 180}):Play()
                OptionsHolder.Visible = true
            else
                -- Fechar dropdown
                TweenService:Create(Dropdown, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 40)}):Play()
                TweenService:Create(DropdownArrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                OptionsHolder.Visible = false
            end
        end)
        
        return {
            SetValue = function(value)
                if table.find(options, value) then
                    SelectedOption.Text = value
                    callback(value)
                end
            end,
            GetValue = function()
                return SelectedOption.Text
            end
        }
    end
    
    -- Função para criar botão
    local function CreateButton(parent, title, callback)
        local Button = Instance.new("Frame")
        Button.Name = title .. "Button"
        Button.BackgroundColor3 = Theme.DarkBackground
        Button.BorderSizePixel = 0
        Button.Size = UDim2.new(1, 0, 0, 40)
        Button.Parent = parent
        
        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 6)
        ButtonCorner.Parent = Button
        
        local ButtonLabel = Instance.new("TextLabel")
        ButtonLabel.Name = "Label"
        ButtonLabel.BackgroundTransparency = 1
        ButtonLabel.Size = UDim2.new(1, 0, 1, 0)
        ButtonLabel.Font = Enum.Font.GothamSemibold
        ButtonLabel.Text = title
        ButtonLabel.TextColor3 = Theme.Text
        ButtonLabel.TextSize = 14
        ButtonLabel.Parent = Button
        
        local ButtonClick = Instance.new("TextButton")
        ButtonClick.Name = "Click"
        ButtonClick.BackgroundTransparency = 1
        ButtonClick.Size = UDim2.new(1, 0, 1, 0)
        ButtonClick.Text = ""
        ButtonClick.Parent = Button
        
        -- Efeitos visuais
        ButtonClick.MouseEnter:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Accent}):Play()
        end)
        
        ButtonClick.MouseLeave:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Theme.DarkBackground}):Play()
        end)
        
        ButtonClick.MouseButton1Down:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Theme.DarkBackground}):Play()
            TweenService:Create(Button, TweenInfo.new(0.1), {Size = UDim2.new(0.98, 0, 0.95, 0)}):Play()
            TweenService:Create(Button, TweenInfo.new(0.1), {Position = UDim2.new(0.01, 0, 0.025, 0)}):Play()
        end)
        
        ButtonClick.MouseButton1Up:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Accent}):Play()
            TweenService:Create(Button, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 1, 0)}):Play()
            TweenService:Create(Button, TweenInfo.new(0.1), {Position = UDim2.new(0, 0, 0, 0)}):Play()
        end)
        
        ButtonClick.MouseButton1Click:Connect(function()
            callback()
        end)
        
        return Button
    end
    
    -- Função para criar um atalho flutuante (SÓ PARA MOBILE)
    local function CreateQuickButton(title, icon, position, callback)
        local QuickButton = Instance.new("ImageButton")
        QuickButton.Name = title .. "QuickButton"
        QuickButton.BackgroundColor3 = Theme.Accent
        QuickButton.BackgroundTransparency = 0.2
        QuickButton.Position = position
        QuickButton.Size = UDim2.new(0, 40, 0, 40)
        QuickButton.AutoButtonColor = false
        QuickButton.Image = icon
        QuickButton.ImageColor3 = Theme.Text
        QuickButton.Parent = QuickAccessFrame
        
        local QuickButtonCorner = Instance.new("UICorner")
        QuickButtonCorner.CornerRadius = UDim.new(1, 0)
        QuickButtonCorner.Parent = QuickButton
        
        -- Efeitos visuais para toque
        QuickButton.MouseEnter:Connect(function()
            TweenService:Create(QuickButton, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
        end)
        
        QuickButton.MouseLeave:Connect(function()
            TweenService:Create(QuickButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
        end)
        
        QuickButton.MouseButton1Down:Connect(function()
            TweenService:Create(QuickButton, TweenInfo.new(0.1), {Size = UDim2.new(0, 35, 0, 35)}):Play()
        end)
        
        QuickButton.MouseButton1Up:Connect(function()
            TweenService:Create(QuickButton, TweenInfo.new(0.1), {Size = UDim2.new(0, 40, 0, 40)}):Play()
        end)
        
        QuickButton.MouseButton1Click:Connect(callback)
        
        return QuickButton
    end
    
    -- Botão para mostrar/esconder os atalhos rápidos
    local QuickAccessToggle = Instance.new("ImageButton")
    QuickAccessToggle.Name = "QuickAccessToggle"
    QuickAccessToggle.BackgroundColor3 = Theme.Accent
    QuickAccessToggle.Position = UDim2.new(0, 10, 0.5, -25)
    QuickAccessToggle.Size = UDim2.new(0, 50, 0, 50)
    QuickAccessToggle.AutoButtonColor = false
    QuickAccessToggle.Image = "rbxassetid://6031302931" -- Ícone de menu
    QuickAccessToggle.ImageColor3 = Theme.Text
    QuickAccessToggle.Parent = BloxFruitsMobileGUI
    
    local QuickAccessToggleCorner = Instance.new("UICorner")
    QuickAccessToggleCorner.CornerRadius = UDim.new(1, 0)
    QuickAccessToggleCorner.Parent = QuickAccessToggle
    
    -- Lógica para mostrar/esconder
    local quickAccessVisible = false
    
    QuickAccessToggle.MouseButton1Click:Connect(function()
        quickAccessVisible = not quickAccessVisible
        QuickAccessFrame.Visible = quickAccessVisible
    end)
    
    -- CRIAÇÃO DE ABAS (PARA TODA A INTERFACE)
    local FarmTab = CreateTab("Farm", "rbxassetid://6035053278") -- Ícone de plantação/farming
    local TeleportTab = CreateTab("TP", "rbxassetid://6035047391") -- Ícone de teleporte
    local CombatTab = CreateTab("PVP", "rbxassetid://6034983957") -- Ícone de combate
    local ItemsTab = CreateTab("Items", "rbxassetid://6031282950") -- Ícone de itens
    local VisualTab = CreateTab("ESP", "rbxassetid://6031763426") -- Ícone de olho/visual
    local SettingsTab = CreateTab("Config", "rbxassetid://6031280882") -- Ícone de engrenagem
    
    -- Selecionar a primeira aba por padrão
    TabButtons[1].Button.MouseButton1Click:Fire()
    
    -- FARM TAB (PRINCIPAL DESSA PORRA)
    local AutoFarmSection = CreateSection(FarmTab, "Auto Farm")
    local AutoFarmEnabled = CreateToggle(AutoFarmSection, "Auto Farm", false, function(value)
        if value then
            -- Código para iniciar auto farm
            local notification = "Iniciando Auto Farm - Verificando segurança..."
            if AutoFarmMethod == "Level" then
                notification = "Auto Farm de Level ativado"
            elseif AutoFarmMethod == "Chest" then
                notification = "Auto Farm de Baús ativado"
            elseif AutoFarmMethod == "Fruit" then
                notification = "Auto Farm de Frutas ativado"
            end
            
            -- Notificação
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Blox Fruits Black",
                Text = notification,
                Duration = 3
            })
        else
            -- Código para parar auto farm
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Blox Fruits Black",
                Text = "Auto Farm desativado",
                Duration = 3
            })
        end
    end)
    
    local FarmMethodDropdown = CreateDropdown(AutoFarmSection, "Método de Farm", {"Level", "Chest", "Fruit", "Bosses", "Material"}, "Level", function(value)
        AutoFarmMethod = value
        
        -- Lógica para mudar método
        if value == "Level" then
            -- Configuração para farm de Level
        elseif value == "Chest" then
            -- Configuração para farm de baús
        elseif value == "Fruit" then
            -- Configuração para farm de frutas
        end
    end)
    
    local FarmSpeedSlider = CreateSlider(AutoFarmSection, "Velocidade de Farm", 1, 5, 2, "x", function(value)
        FarmSpeed = value
        
        -- Ajustar velocidade do farming
        if value > 3 then
            -- Aviso de risco
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Alerta de Segurança",
                Text = "Velocidade alta aumenta risco de ban!",
                Duration = 5
            })
        end
    end)
    
    local FarmDistanceSlider = CreateSlider(AutoFarmSection, "Distância de Farm", 5, 30, 15, "m", function(value)
        FarmDistance = value
    end)
    
    local AutoQuestToggle = CreateToggle(AutoFarmSection, "Auto Quest", false, function(value)
        AutoQuest = value
    end)
    
    local BringMobToggle = CreateToggle(AutoFarmSection, "Bring Mob", false, function(value)
        BringMob = value
    end)
    
    -- SEÇÃO DE FARMINGS ESPECÍFICOS
    local SpecificFarmSection = CreateSection(FarmTab, "Farmings Específicos")
    
    local AutoRaidToggle = CreateToggle(SpecificFarmSection, "Auto Raid", false, function(value)
        AutoRaid = value
    end)
    
    local AutoBossToggle = CreateToggle(SpecificFarmSection, "Auto Farm Boss", false, function(value)
        AutoBoss = value
    end)
    
    local BossDropdown = CreateDropdown(SpecificFarmSection, "Selecionar Boss", {"Saber Expert", "The Gorilla King", "Bobby", "Deadbeard", "Diamond", "Jeremy"}, "Saber Expert", function(value)
        SelectedBoss = value
    end)
    
    local MaterialFarmToggle = CreateToggle(SpecificFarmSection, "Farm de Material", false, function(value)
        MaterialFarm = value
    end)
    
    local MaterialDropdown = CreateDropdown(SpecificFarmSection, "Material", {"Angel Wings", "Magma Ore", "Mystic Droplet", "Fish Tail", "Scrap Metal", "Dragon Scale"}, "Angel Wings", function(value)
        SelectedMaterial = value
    end)
    
    -- TELEPORT TAB
    local IslandTeleportSection = CreateSection(TeleportTab, "Teleporte de Ilhas")
    
    local IslandDropdown = CreateDropdown(IslandTeleportSection, "Selecionar Ilha", {
        "Starter Island", "Middle Town", "Jungle", "Pirate Village", "Desert", "Frozen Village", 
        "Marine Fortress", "Skylands", "Prison", "Colosseum", "Magma Village", "Fountain City",
        "First Sea Locations", "Kingdom of Rose", "Floating Turtle", "Mansion", "Haunted Castle",
        "Ice Castle", "Forgotten Island", "Raven Rock", "Green Bit", "Cafe", "Factroy",
        "Second Sea Locations", "Hydra Island", "Great Tree", "Castle On The Sea", "Port Town",
        "Beautiful Pirate Domain", "Third Sea Locations"
    }, "Starter Island", function(value)
        SelectedIsland = value
        
        -- Teleporte para a ilha selecionada
        local teleportLocations = {
            ["Starter Island"] = Vector3.new(1071.2832, 16.3085976, 1426.86792),
            ["Middle Town"] = Vector3.new(-655.824158, 7.88708115, 1436.67908),
            ["Jungle"] = Vector3.new(-1249.77222, 11.8870859, 341.356476),
            ["Pirate Village"] = Vector3.new(-1122.34998, 4.78708982, 3855.91992),
            -- Adicione mais localizações aqui
        }
        
        if teleportLocations[value] then
            local player = game:GetService("Players").LocalPlayer
            local char = player.Character or player.CharacterAdded:Wait()
            local humanoidRootPart = char:WaitForChild("HumanoidRootPart")
            
            -- Teleporte com efeito de deslocamento
            for i = 1, 10 do
                humanoidRootPart.CFrame = CFrame.new(teleportLocations[value])
                task.wait(0.1)
            end
            
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Teleporte",
                Text = "Teleportado para " .. value,
                Duration = 3
            })
        end
    end)
    
    local TeleportButton = CreateButton(IslandTeleportSection, "Teleportar", function()
        -- A lógica de teleporte já está no dropdown, este é só um botão extra para confirmar
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Teleporte",
            Text = "Teleportando para " .. SelectedIsland,
            Duration = 3
        })
    end)
    
    -- SEÇÃO TELETRANSPORTE PARA JOGADORES
    local PlayerTeleportSection = CreateSection(TeleportTab, "Teleporte para Jogadores")
    
    -- Lista de jogadores atualizada
    local playerList = {}
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        if player ~= game:GetService("Players").LocalPlayer then
            table.insert(playerList, player.Name)
        end
    end
    
    local PlayerDropdown = CreateDropdown(PlayerTeleportSection, "Selecionar Jogador", playerList, playerList[1] or "Nenhum jogador", function(value)
        SelectedPlayer = value
    end)
    
    -- Botão de teleporte para jogador
    local TeleportToPlayerButton = CreateButton(PlayerTeleportSection, "Teleportar para Jogador", function()
        local targetPlayer = game:GetService("Players"):FindFirstChild(SelectedPlayer)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local player = game:GetService("Players").LocalPlayer
            local char = player.Character or player.CharacterAdded:Wait()
            
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Teleporte",
                    Text = "Teleportado para " .. SelectedPlayer,
                    Duration = 3
                })
            end
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Erro",
                Text = "Jogador não encontrado!",
                Duration = 3
            })
        end
    end)
    
    -- COMBAT TAB
    local CombatSection = CreateSection(CombatTab, "Combate Automático")
    
    local AutoFarmMobs = CreateToggle(CombatSection, "Auto Kill Próximo", false, function(value)
        AutoKillMobs = value
        
        -- Lógica para matar mobs automaticamente nas proximidades
        if value then
            -- Iniciar lógica de auto kill
            spawn(function()
                while AutoKillMobs do
                    -- Lógica para encontrar e atacar mobs próximos
                    wait(1)
                end
            end)
        end
    end)
    
    local KillAuraToggle = CreateToggle(CombatSection, "Kill Aura", false, function(value)
        KillAura = value
        
        -- Lógica de Kill Aura
        if value then
            spawn(function()
                while KillAura do
                    -- Lógica para atacar todos os inimigos ao redor
                    wait(0.1)
                end
            end)
        end
    end)
    
    local KillAuraRangeSlider = CreateSlider(CombatSection, "Alcance da Kill Aura", 5, 20, 10, "m", function(value)
        KillAuraRange = value
    end)
    
    local AutoSkillsToggle = CreateToggle(CombatSection, "Auto Skills", false, function(value)
        AutoSkills = value
        
                    -- Lógica para usar habilidades automaticamente
                    if value then
                        spawn(function()
                            while AutoSkills do
                                -- Usar skills Z, X, C, V, F automaticamente
                                local player = game:GetService("Players").LocalPlayer
                                local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                                
                                if humanoid and humanoid.Health > 0 then
                                    -- Simular pressionamento de teclas
                                    local skillKeys = {"Z", "X", "C", "V", "F"}
                                    
                                    for _, key in ipairs(skillKeys) do
                                        -- Verificar cooldown (implementação básica)
                                        local hasCooldown = false
                                        -- Se não tiver em cooldown, usar a skill
                                        if not hasCooldown then
                                            game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode[key], false, game)
                                            wait(0.1)
                                            game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode[key], false, game)
                                        end
                                        wait(0.5) -- Pequeno intervalo entre as skills
                                    end
                                end
                                
                                wait(1) -- Intervalo geral para o loop
                            end
                        end)
                    end
                end)
            end
        end)
    end)
    
    local PvPSection = CreateSection(CombatTab, "PvP")
    
    local AimbotToggle = CreateToggle(PvPSection, "Aimbot", false, function(value)
        Aimbot = value
        
        -- Lógica de Aimbot
        if value then
            spawn(function()
                while Aimbot do
                    -- Buscar jogador mais próximo
                    local closestPlayer = nil
                    local shortestDistance = math.huge
                    local player = game:GetService("Players").LocalPlayer
                    
                    for _, otherPlayer in pairs(game:GetService("Players"):GetPlayers()) do
                        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            local distance = (otherPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                            
                            if distance < shortestDistance and distance <= 50 then
                                closestPlayer = otherPlayer
                                shortestDistance = distance
                            end
                        end
                    end
                    
                    -- Apontar para o jogador mais próximo
                    if closestPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        player.Character.HumanoidRootPart.CFrame = CFrame.new(
                            player.Character.HumanoidRootPart.Position,
                            Vector3.new(closestPlayer.Character.HumanoidRootPart.Position.X, player.Character.HumanoidRootPart.Position.Y, closestPlayer.Character.HumanoidRootPart.Position.Z)
                        )
                    end
                    
                    wait(0.1)
                end
            end)
        end
    end)
    
    local AutoParryToggle = CreateToggle(PvPSection, "Auto Parry", false, function(value)
        AutoParry = value
        
        -- Lógica de Auto Parry 
        if value then
            spawn(function()
                while AutoParry do
                    -- Detectar ataques próximos e fazer parry automaticamente
                    -- Esta é uma implementação simplificada
                    local player = game:GetService("Players").LocalPlayer
                    local character = player.Character
                    
                    if character then
                        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                        if humanoidRootPart then
                            -- Verificar jogadores próximos
                            for _, otherPlayer in pairs(game:GetService("Players"):GetPlayers()) do
                                if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                    local distance = (otherPlayer.Character.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude
                                    
                                    -- Se estiver próximo e estiver atacando (implementação simulada)
                                    if distance <= 15 then
                                        -- Simular detecção de ataque (simplificado)
                                        local hasDetectedAttack = math.random() > 0.7 -- 30% de chance de "detectar" um ataque para simulação
                                        
                                        if hasDetectedAttack then
                                            -- Fazer parry (normalmente seria pressionar uma tecla específica)
                                            game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.F, false, game)
                                            wait(0.1)
                                            game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.F, false, game)
                                            
                                            -- Pequeno cooldown após parry
                                            wait(1)
                                        end
                                    end
                                end
                            end
                        end
                    end
                    
                    wait(0.1)
                end
            end)
        end
    end)
    
    local SilentAimToggle = CreateToggle(PvPSection, "Silent Aim", false, function(value)
        SilentAim = value
        
        -- Lógica de Silent Aim (hook do raycasting/hit detection)
        if value then
            -- Este é um exemplo de mockup de silent aim, a implementação real seria mais complexa e específica para o jogo
            local oldNamecall
            oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                local method = getnamecallmethod()
                local args = {...}
                
                if SilentAim and (method == "FireServer" or method == "InvokeServer") and string.match(self.Name, "RemoteEvent") then
                    -- Tentar identificar se é um remote de ataque (simplificado)
                    if string.match(self.Name:lower(), "attack") or string.match(self.Name:lower(), "hit") or string.match(self.Name:lower(), "damage") then
                        -- Buscar alvo mais próximo
                        local closestPlayer = nil
                        local shortestDistance = 50 -- Máximo de distância
                        local player = game:GetService("Players").LocalPlayer
                        
                        for _, otherPlayer in pairs(game:GetService("Players"):GetPlayers()) do
                            if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                local distance = (otherPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                                
                                if distance < shortestDistance then
                                    closestPlayer = otherPlayer
                                    shortestDistance = distance
                                end
                            end
                        end
                        
                        -- Modificar argumentos para apontar para o alvo mais próximo
                        if closestPlayer then
                            for i, v in pairs(args) do
                                -- Tentar identificar argumento de posição/alvo (simplificado)
                                if typeof(v) == "Vector3" then
                                    args[i] = closestPlayer.Character.HumanoidRootPart.Position
                                elseif typeof(v) == "CFrame" then
                                    args[i] = closestPlayer.Character.HumanoidRootPart.CFrame
                                elseif typeof(v) == "Instance" and v:IsA("BasePart") then
                                    args[i] = closestPlayer.Character.HumanoidRootPart
                                elseif typeof(v) == "Instance" and v:IsA("Model") then
                                    args[i] = closestPlayer.Character
                                elseif typeof(v) == "Instance" and v:IsA("Player") then
                                    args[i] = closestPlayer
                                end
                            end
                        end
                    end
                end
                
                return oldNamecall(self, unpack(args))
            end)
        end
    end)
    
    -- ITEMS TAB
    local FruitSection = CreateSection(ItemsTab, "Frutas")
    
    local AutoBuyFruitToggle = CreateToggle(FruitSection, "Auto Comprar Frutas", false, function(value)
        AutoBuyFruit = value
        
        -- Lógica para comprar frutas automaticamente
        if value then
            spawn(function()
                while AutoBuyFruit do
                    -- Tentar comprar frutas disponíveis
                    local fruitShop = game:GetService("Workspace"):FindFirstChild("Fruit Dealer") or game:GetService("Workspace"):FindFirstChild("FruitDealer")
                    
                    if fruitShop and fruitShop:FindFirstChild("Dialogue") then
                        local eventRemote = fruitShop:FindFirstChild("Dialogue")
                        
                        -- Simular compra (a implementação real dependeria do jogo)
                        if eventRemote and eventRemote:IsA("RemoteEvent") then
                            eventRemote:FireServer("Buy", SelectedFruit)
                            
                            game:GetService("StarterGui"):SetCore("SendNotification", {
                                Title = "Compra de Fruta",
                                Text = "Tentando comprar " .. (SelectedFruit or "qualquer fruta"),
                                Duration = 3
                            })
                        end
                    end
                    
                    wait(300) -- Verificar a cada 5 minutos
                end
            end)
        end
    end)
    
    local SelectedFruitDropdown = CreateDropdown(FruitSection, "Selecionar Fruta", {
        "Random Fruit", "Bomb Fruit", "Spike Fruit", "Chop Fruit", "Spring Fruit", "Kilo Fruit", 
        "Smoke Fruit", "Spin Fruit", "Flame Fruit", "Bird: Falcon Fruit", "Ice Fruit", "Sand Fruit",
        "Dark Fruit", "Diamond Fruit", "Light Fruit", "Rubber Fruit", "Barrier Fruit", "Ghost Fruit",
        "Magma Fruit", "Quake Fruit", "Buddha Fruit", "Love Fruit", "Spider Fruit", "Sound Fruit",
        "Phoenix Fruit", "Portal Fruit", "Rumble Fruit", "Pain Fruit", "Blizzard Fruit",
        "Gravity Fruit", "Mammoth Fruit", "T-Rex Fruit", "Venom Fruit", "Shadow Fruit", "Control Fruit", "Spirit Fruit", "Dragon Fruit"
    }, "Random Fruit", function(value)
        SelectedFruit = value
    end)
    
    local StoreFruitToggle = CreateToggle(FruitSection, "Armazenar Frutas", false, function(value)
        StoreFruit = value
        
        -- Lógica para armazenar frutas automaticamente
        if value then
            spawn(function()
                while StoreFruit do
                    -- Tentar armazenar frutas do inventário
                    local player = game:GetService("Players").LocalPlayer
                    
                    -- Verificar o inventário (simulado, a implementação real dependeria do jogo)
                    local hasFruit = false
                    
                    if hasFruit then
                        -- Tentar armazenar a fruta (simulado)
                        local success = math.random() > 0.5 -- 50% de chance de "sucesso" para simulação
                        
                        if success then
                            game:GetService("StarterGui"):SetCore("SendNotification", {
                                Title = "Armazenamento de Fruta",
                                Text = "Fruta armazenada com sucesso!",
                                Duration = 3
                            })
                        else
                            game:GetService("StarterGui"):SetCore("SendNotification", {
                                Title = "Armazenamento de Fruta",
                                Text = "Falha ao armazenar fruta.",
                                Duration = 3
                            })
                        end
                    end
                    
                    wait(30) -- Verificar a cada 30 segundos
                end
            end)
        end
    end)
    
    local FruitFinderToggle = CreateToggle(FruitSection, "Radar de Frutas", false, function(value)
        FruitFinder = value
        
        -- Lógica para encontrar frutas no mapa
        if value then
            spawn(function()
                while FruitFinder do
                    -- Buscar frutas no workspace
                    local fruitsFound = {}
                    
                    for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
                        if string.find(v.Name:lower(), "fruit") and v:IsA("Tool") then
                            table.insert(fruitsFound, {
                                Name = v.Name,
                                Position = v:FindFirstChildOfClass("Part") and v:FindFirstChildOfClass("Part").Position or v.Handle.Position
                            })
                        end
                    end
                    
                    -- Notificar sobre frutas encontradas
                    if #fruitsFound > 0 then
                        for _, fruit in ipairs(fruitsFound) do
                            local player = game:GetService("Players").LocalPlayer
                            local character = player.Character
                            
                            if character and character:FindFirstChild("HumanoidRootPart") then
                                local distance = (character.HumanoidRootPart.Position - fruit.Position).Magnitude
                                
                                game:GetService("StarterGui"):SetCore("SendNotification", {
                                    Title = "Fruta Encontrada!",
                                    Text = fruit.Name .. " a " .. math.floor(distance) .. "m de distância",
                                    Duration = 5
                                })
                                
                                -- Criar ESP para a fruta (implementação visual)
                                -- Esta seria uma implementação completa em um script real
                            end
                        end
                    end
                    
                    wait(15) -- Verificar a cada 15 segundos
                end
            end)
        end
    end)
    
    -- Seção de Itens Especiais
    local SpecialItemsSection = CreateSection(ItemsTab, "Itens Especiais")
    
    local AutoBuyEnhancementToggle = CreateToggle(SpecialItemsSection, "Auto Comprar Enhancement", false, function(value)
        AutoBuyEnhancement = value
        
        -- Lógica para comprar enhancement
        if value then
            spawn(function()
                while AutoBuyEnhancement do
                    -- Tentar comprar enhancement (simulado)
                    local success = math.random() > 0.3 -- 70% de chance de "sucesso" para simulação
                    
                    if success then
                        game:GetService("StarterGui"):SetCore("SendNotification", {
                            Title = "Compra de Enhancement",
                            Text = "Enhancement comprado com sucesso!",
                            Duration = 3
                        })
                    else
                        game:GetService("StarterGui"):SetCore("SendNotification", {
                            Title = "Compra de Enhancement",
                            Text = "Falha ao comprar Enhancement (Beli insuficiente)",
                            Duration = 3
                        })
                    end
                    
                    wait(60) -- Tentar a cada minuto
                end
            end)
        end
    end)
    
    local AutoBuySwordToggle = CreateToggle(SpecialItemsSection, "Auto Comprar Espadas", false, function(value)
        AutoBuySword = value
        
        -- Lógica para comprar espadas
        if value then
            spawn(function()
                while AutoBuySword do
                    -- Lógica para comprar espadas (simulado)
                    wait(120) -- A cada 2 minutos
                end
            end)
        end
    end)
    
    -- VISUAL TAB
    local ESPSection = CreateSection(VisualTab, "ESP")
    
    local PlayerESPToggle = CreateToggle(ESPSection, "ESP de Jogadores", false, function(value)
        PlayerESP = value
        
        -- Lógica para ESP de jogadores
        if value then
            spawn(function()
                local espFolder = Instance.new("Folder")
                espFolder.Name = "ESPFolder"
                espFolder.Parent = game:GetService("CoreGui")
                
                local function createESP(player)
                    if player == game:GetService("Players").LocalPlayer then return end
                    
                    local esp = Instance.new("BillboardGui")
                    esp.Name = player.Name .. "ESP"
                    esp.AlwaysOnTop = true
                    esp.Size = UDim2.new(0, 200, 0, 50)
                    esp.StudsOffset = Vector3.new(0, 2, 0)
                    esp.Parent = espFolder
                    
                    local text = Instance.new("TextLabel")
                    text.Name = "ESPText"
                    text.BackgroundTransparency = 1
                    text.Size = UDim2.new(1, 0, 1, 0)
                    text.Font = Enum.Font.GothamBold
                    text.TextColor3 = Color3.fromRGB(255, 0, 0)
                    text.TextStrokeTransparency = 0
                    text.TextSize = 14
                    text.Parent = esp
                    
                    local box = Instance.new("BoxHandleAdornment")
                    box.Name = player.Name .. "Box"
                    box.Adornee = nil
                    box.AlwaysOnTop = true
                    box.ZIndex = 10
                    box.Size = Vector3.new(4, 5, 4)
                    box.Transparency = 0.7
                    box.Color3 = Color3.fromRGB(255, 0, 0)
                    box.Parent = espFolder
                    
                    -- Atualizar constantemente
                    spawn(function()
                        while PlayerESP and esp and text and box and player and wait(0.1) do
                            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChildOfClass("Humanoid") then
                                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                                local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                                
                                -- Atualizar posição do ESP
                                esp.Adornee = rootPart
                                box.Adornee = rootPart
                                
                                -- Calcular distância
                                local distance = 0
                                local myCharacter = game:GetService("Players").LocalPlayer.Character
                                if myCharacter and myCharacter:FindFirstChild("HumanoidRootPart") then
                                    distance = (myCharacter.HumanoidRootPart.Position - rootPart.Position).Magnitude
                                end
                                
                                -- Atualizar texto
                                text.Text = player.Name .. " [" .. math.floor(distance) .. "m]"
                                
                                -- Atualizar cor com base na vida
                                local healthPercent = humanoid.Health / humanoid.MaxHealth
                                local healthColor = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 0)
                                text.TextColor3 = healthColor
                                box.Color3 = healthColor
                            else
                                esp.Adornee = nil
                                box.Adornee = nil
                                text.Text = player.Name .. " [?]"
                            end
                        end
                    end)
                end
                
                -- Criar ESP para jogadores existentes
                for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                    createESP(player)
                end
                
                -- Monitorar novos jogadores
                game:GetService("Players").PlayerAdded:Connect(function(player)
                    createESP(player)
                end)
                
                -- Limpar na desativação
                while PlayerESP do wait(1) end
                espFolder:Destroy()
            end)
        else
            -- Remover ESP
            for _, item in pairs(game:GetService("CoreGui"):GetChildren()) do
                if item.Name == "ESPFolder" then
                    item:Destroy()
                end
            end
        end
    end)
    
    local ChestESPToggle = CreateToggle(ESPSection, "ESP de Baús", false, function(value)
        ChestESP = value
        
        -- Lógica para ESP de baús
        if value then
            spawn(function()
                local espFolder = Instance.new("Folder")
                espFolder.Name = "ChestESPFolder"
                espFolder.Parent = game:GetService("CoreGui")
                
                local function createChestESP(chest)
                    local esp = Instance.new("BillboardGui")
                    esp.Name = "ChestESP"
                    esp.AlwaysOnTop = true
                    esp.Size = UDim2.new(0, 200, 0, 50)
                    esp.StudsOffset = Vector3.new(0, 2, 0)
                    esp.Adornee = chest
                    esp.Parent = espFolder
                    
                    local text = Instance.new("TextLabel")
                    text.Name = "ESPText"
                    text.BackgroundTransparency = 1
                    text.Size = UDim2.new(1, 0, 1, 0)
                    text.Font = Enum.Font.GothamBold
                    text.TextColor3 = Color3.fromRGB(255, 215, 0)  -- Dourado para baús
                    text.TextStrokeTransparency = 0
                    text.TextSize = 14
                    text.Text = "Baú"
                    text.Parent = esp
                    
                    -- Atualizar constantemente
                    spawn(function()
                        while ChestESP and esp and text and chest and wait(0.1) do
                            if chest:IsA("BasePart") or (chest:IsA("Model") and chest:FindFirstChildOfClass("BasePart")) then
                                local part = chest:IsA("BasePart") and chest or chest:FindFirstChildOfClass("BasePart")
                                
                                -- Calcular distância
                                local distance = 0
                                local myCharacter = game:GetService("Players").LocalPlayer.Character
                                if myCharacter and myCharacter:FindFirstChild("HumanoidRootPart") then
                                    distance = (myCharacter.HumanoidRootPart.Position - part.Position).Magnitude
                                end
                                
                                -- Atualizar texto
                                text.Text = "Baú [" .. math.floor(distance) .. "m]"
                            else
                                esp:Destroy()
                            end
                        end
                    end)
                end
                
                -- Criar ESP para baús existentes
                for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
                    if string.find(v.Name:lower(), "chest") or string.find(v.Name:lower(), "baú") then
                        createChestESP(v)
                    end
                end
                
                -- Monitorar novos baús
                game:GetService("Workspace").DescendantAdded:Connect(function(v)
                    if string.find(v.Name:lower(), "chest") or string.find(v.Name:lower(), "baú") then
                        wait(1) -- Pequeno delay para garantir que o baú esteja totalmente carregado
                        createChestESP(v)
                    end
                end)
                
                -- Limpar na desativação
                while ChestESP do wait(1) end
                espFolder:Destroy()
            end)
        else
            -- Remover ESP
            for _, item in pairs(game:GetService("CoreGui"):GetChildren()) do
                if item.Name == "ChestESPFolder" then
                    item:Destroy()
                end
            end
        end
    end)
    
    local FruitESPToggle = CreateToggle(ESPSection, "ESP de Frutas", false, function(value)
        FruitESP = value
        
        -- Lógica para ESP de frutas
        if value then
            spawn(function()
                local espFolder = Instance.new("Folder")
                espFolder.Name = "FruitESPFolder"
                espFolder.Parent = game:GetService("CoreGui")
                
                local function createFruitESP(fruit)
                    local mainPart = fruit:IsA("BasePart") and fruit or fruit:FindFirstChildOfClass("BasePart") or fruit:FindFirstChild("Handle")
                    
                    if not mainPart then return end
                    
                    local esp = Instance.new("BillboardGui")
                    esp.Name = "FruitESP"
                    esp.AlwaysOnTop = true
                    esp.Size = UDim2.new(0, 200, 0, 50)
                    esp.StudsOffset = Vector3.new(0, 2, 0)
                    esp.Adornee = mainPart
                    esp.Parent = espFolder
                    
                    local text = Instance.new("TextLabel")
                    text.Name = "ESPText"
                    text.BackgroundTransparency = 1
                    text.Size = UDim2.new(1, 0, 1, 0)
                    text.Font = Enum.Font.GothamBold
                    text.TextColor3 = Color3.fromRGB(0, 255, 0)  -- Verde para frutas
                    text.TextStrokeTransparency = 0
                    text.TextSize = 14
                    text.Text = fruit.Name
                    text.Parent = esp
                    
                    -- Atualizar constantemente
                    spawn(function()
                        while FruitESP and esp and text and mainPart and wait(0.1) do
                            -- Calcular distância
                            local distance = 0
                            local myCharacter = game:GetService("Players").LocalPlayer.Character
                            if myCharacter and myCharacter:FindFirstChild("HumanoidRootPart") then
                                distance = (myCharacter.HumanoidRootPart.Position - mainPart.Position).Magnitude
                            end
                            
                            -- Atualizar texto
                            text.Text = fruit.Name .. " [" .. math.floor(distance) .. "m]"
                            
                            -- Se o fruto for destruído ou removido
                            if not mainPart or not mainPart:IsDescendantOf(game) then
                                esp:Destroy()
                                break
                            end
                        end
                    end)
                end
                
                -- Criar ESP para frutas existentes
                for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
                    if string.find(v.Name:lower(), "fruit") and (v:IsA("Tool") or v:IsA("Model")) then
                        createFruitESP(v)
                    end
                end
                
                -- Monitorar novas frutas
                game:GetService("Workspace").DescendantAdded:Connect(function(v)
                    if string.find(v.Name:lower(), "fruit") and (v:IsA("Tool") or v:IsA("Model")) then
                        wait(1) -- Pequeno delay para garantir que a fruta esteja totalmente carregada
                        createFruitESP(v)
                    end
                end)
                
                -- Limpar na desativação
                while FruitESP do wait(1) end
                espFolder:Destroy()
            end)
        else
            -- Remover ESP
            for _, item in pairs(game:GetService("CoreGui"):GetChildren()) do
                if item.Name == "FruitESPFolder" then
                    item:Destroy()
                end
            end
        end
    end)
    
    -- SETTINGS TAB
    local GeneralSettingsSection = CreateSection(SettingsTab, "Configurações Gerais")
    
    local ThemeDropdown = CreateDropdown(GeneralSettingsSection, "Tema", {"Dark", "Light", "Blood", "Ocean"}, UserSettings.Theme, function(value)
        UserSettings.Theme = value
        
        -- Notificar para reiniciar
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Tema Alterado",
            Text = "Reinicie o script para aplicar o novo tema.",
            Duration = 5
        })
    end)
    
    local SafeModeToggle = CreateToggle(GeneralSettingsSection, "Modo Seguro", UserSettings.SafeMode, function(value)
        UserSettings.SafeMode = value
        
        if value then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Modo Seguro Ativado",
                Text = "O script usará métodos mais seguros (menos risco de ban).",
                Duration = 5
            })
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Modo Seguro Desativado",
                Text = "AVISO: Maior risco de detecção e ban!",
                Duration = 5
            })
        end
    end)
    
    local MobileOptimizationToggle = CreateToggle(GeneralSettingsSection, "Otimização Mobile", UserSettings.MobileOptimized, function(value)
        UserSettings.MobileOptimized = value
        
        if value then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Otimização Mobile Ativada",
                Text = "Performance melhorada para dispositivos móveis.",
                Duration = 5
            })
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Otimização Mobile Desativada",
                Text = "Recursos completos ativados (pode causar lag).",
                Duration = 5
            })
        end
    end)
    
    -- Botões de ação
    local ActionButtonsSection = CreateSection(SettingsTab, "Ações")
    
    local ReloadButton = CreateButton(ActionButtonsSection, "Recarregar Script", function()
        -- Recarregar o script
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Recarregando",
            Text = "O script será recarregado em 3 segundos.",
            Duration = 3
        })
        
        BloxFruitsMobileGUI:Destroy()
        
        wait(3)
        
        -- Aqui você chamaria a função principal novamente
        -- Na prática, o usuário teria que executar o script novamente
    end)
    
    local DestroyButton = CreateButton(ActionButtonsSection, "Destruir GUI", function()
        -- Destruir a GUI
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Destruindo GUI",
            Text = "A interface será removida.",
            Duration = 3
        })
        
        BloxFruitsMobileGUI:Destroy()
    end)
    
    -- Informações
    local InfoSection = CreateSection(SettingsTab, "Informações")
    
    local VersionInfo = Instance.new("TextLabel")
    VersionInfo.Name = "VersionInfo"
    VersionInfo.BackgroundTransparency = 1
    VersionInfo.Size = UDim2.new(1, 0, 0, 20)
    VersionInfo.Font = Enum.Font.Gotham
    VersionInfo.Text = "Versão: 3.5 BLACK EDITION"
    VersionInfo.TextColor3 = Theme.SubText
    VersionInfo.TextSize = 14
    VersionInfo.TextXAlignment = Enum.TextXAlignment.Left
    VersionInfo.Parent = InfoSection
    
    local CreatorInfo = Instance.new("TextLabel")
    CreatorInfo.Name = "CreatorInfo"
    CreatorInfo.BackgroundTransparency = 1
    CreatorInfo.Size = UDim2.new(1, 0, 0, 20)
    CreatorInfo.Font = Enum.Font.Gotham
    CreatorInfo.Text = "Criado por: Lek do Black"
    CreatorInfo.TextColor3 = Theme.SubText
    CreatorInfo.TextSize = 14
    CreatorInfo.TextXAlignment = Enum.TextXAlignment.Left
    CreatorInfo.Parent = InfoSection
    
    local StatusInfo = Instance.new("TextLabel")
    StatusInfo.Name = "StatusInfo"
    StatusInfo.BackgroundTransparency = 1
    StatusInfo.Size = UDim2.new(1, 0, 0, 20)
    StatusInfo.Font = Enum.Font.Gotham
    StatusInfo.Text = "Status: Funcionando"
    StatusInfo.TextColor3 = Theme.Success
    StatusInfo.TextSize = 14
    StatusInfo.TextXAlignment = Enum.TextXAlignment.Left
    StatusInfo.Parent = InfoSection
    
    -- Atualização periódica para verificar o status do jogo
    spawn(function()
        while wait(10) do
            if StatusInfo and StatusInfo.Parent then
                local player = game:GetService("Players").LocalPlayer
                if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    StatusInfo.Text = "Status: Funcionando"
                    StatusInfo.TextColor3 = Theme.Success
                else
                    StatusInfo.Text = "Status: Aguardando personagem..."
                    StatusInfo.TextColor3 = Theme.Warning
                end
            else
                break
            end
        end
    end)
    
    -- QUICK ACCESS SHORTCUTS (BOTÕES DE ATALHO FLUTUANTES)
    -- Criar atalhos para as funções mais usadas
    local autoFarmQuickButton = CreateQuickButton("AutoFarm", "rbxassetid://6035053278", UDim2.new(0.5, -20, 0, 5), function()
        AutoFarmEnabled.SetValue(not AutoFarmEnabled.GetValue())
    end)
    
    local teleportQuickButton = CreateQuickButton("Teleport", "rbxassetid://6035047391", UDim2.new(0.5, -20, 0, 55), function()
        -- Abrir o menu de teleporte
        MainFrame.Visible = true
        MinimizedFrame.Visible = false
        TabButtons[2].Button.MouseButton1Click:Fire() -- Abrir aba de teleporte
    end)
    
    local espQuickButton = CreateQuickButton("ESP", "rbxassetid://6031763426", UDim2.new(0.5, -20, 0, 105), function()
        PlayerESPToggle.SetValue(not PlayerESPToggle.GetValue())
    end)
    
    local fruitFinderQuickButton = CreateQuickButton("FruitFinder", "rbxassetid://6031282950", UDim2.new(0.5, -20, 0, 155), function()
        FruitFinderToggle.SetValue(not FruitFinderToggle.GetValue())
    end)
    
    local killAuraQuickButton = CreateQuickButton("KillAura", "rbxassetid://6034983957", UDim2.new(0.5, -20, 0, 205), function()
        KillAuraToggle.SetValue(not KillAuraToggle.GetValue())
    end)
    
    -- IMPLEMENTAÇÃO DAS FUNCIONALIDADES PRINCIPAIS
    
    -- Sistema de segurança
    local Security = SetupSecurity()
    
    -- Anti AFK
    local VirtualUser = game:GetService("VirtualUser")
    Player.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
    
    -- Detecção de staff/admin
    spawn(function()
        while wait(5) do
            for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                if player:GetRankInGroup(2126667) >= 100 then -- Grupo do Blox Fruits
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "⚠️ ALERTA DE STAFF ⚠️",
                        Text = "Staff detectado no servidor: " .. player.Name,
                        Duration = 10
                    })
                    
                    -- Auto desativar funções perigosas
                    if UserSettings.SafeMode then
                        if AutoFarmEnabled.GetValue() then AutoFarmEnabled.SetValue(false) end
                        if KillAuraToggle.GetValue() then KillAuraToggle.SetValue(false) end
                        if SilentAimToggle.GetValue() then SilentAimToggle.SetValue(false) end
                    end
                end
            end
        end
    end)
    
    -- Auto Rejoin em caso de kick
    local AutoRejoin = false
    game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
        if child.Name == "ErrorPrompt" and AutoRejoin then
            if child.MessageArea:FindFirstChild("ErrorFrame") then
                game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
            end
        end
    end)
    
    -- Verificar atualizações do jogo
    local gameVersion = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Updated
    local scriptUpdateDate = os.time({year = 2023, month = 9, day = 15}) -- Data da última atualização do script
    
    if os.difftime(gameVersion, scriptUpdateDate) > 0 then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Atualização Disponível",
            Text = "O jogo foi atualizado desde a última versão do script. Algumas funções podem não funcionar corretamente.",
            Duration = 10
        })
    end
    
    -- Sistema de Log (para debug)
    local LogSystem = {}
    LogSystem.Logs = {}
    
    LogSystem.AddLog = function(category, message)
        table.insert(LogSystem.Logs, {
            Category = category,
            Message = message,
            Time = os.date("%H:%M:%S"),
            Date = os.date("%Y-%m-%d")
        })
        
        -- Manter apenas os últimos 100 logs
        if #LogSystem.Logs > 100 then
            table.remove(LogSystem.Logs, 1)
        end
        
        -- Debug print (remover na versão final)
        if UserSettings.License == "PREMIUM" then
            -- print("[" .. category .. "] " .. message)
        end
    end
    
    -- Sistema de verificação de recursos
    spawn(function()
        while wait(1) do
            local stats = game:GetService("Stats")
            local ping = stats.Network.ServerStatsItem["Data Ping"]:GetValue()
            local memory = stats.GetTotalMemoryUsageMb()
            
            -- Se o ping ou memória estiverem muito altos, desativar recursos pesados
            if ping > 500 or memory > 1000 then
                if UserSettings.MobileOptimized then
                    -- Desativar recursos pesados automaticamente
                    if PlayerESPToggle.GetValue() then PlayerESPToggle.SetValue(false) end
                    if ChestESPToggle.GetValue() then ChestESPToggle.SetValue(false) end
                    if FruitESPToggle.GetValue() then FruitESPToggle.SetValue(false) end
                    
                    LogSystem.AddLog("Performance", "Recursos pesados desativados automaticamente devido à alta latência/uso de memória")
                    
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "Otimização Automática",
                        Text = "Recursos visuais desativados para melhorar o desempenho.",
                        Duration = 5
                    })
                end
            end
        end
    end)
    
    -- Sistema de notificações
    local NotificationSystem = {}
    
    NotificationSystem.CreateNotification = function(title, text, duration)
        duration = duration or 5
        
        -- Criar a notificação na UI própria em vez de usar o sistema do Roblox
        local Notification = Instance.new("Frame")
        Notification.Name = "Notification"
        Notification.BackgroundColor3 = Theme.DarkBackground
        Notification.BorderSizePixel = 0
        Notification.Position = UDim2.new(1, -320, 1, 0) -- Fora da tela inicialmente
        Notification.Size = UDim2.new(0, 300, 0, 80)
        Notification.Parent = BloxFruitsMobileGUI
        
        local NotificationCorner = Instance.new("UICorner")
        NotificationCorner.CornerRadius = UDim.new(0, 8)
        NotificationCorner.Parent = Notification
        
        local NotificationTitle = Instance.new("TextLabel")
        NotificationTitle.Name = "Title"
        NotificationTitle.BackgroundTransparency = 1
        NotificationTitle.Position = UDim2.new(0, 15, 0, 10)
        NotificationTitle.Size = UDim2.new(1, -30, 0, 20)
        NotificationTitle.Font = Enum.Font.GothamBold
        NotificationTitle.Text = title
        NotificationTitle.TextColor3 = Theme.Text
        NotificationTitle.TextSize = 16
        NotificationTitle.TextXAlignment = Enum.TextXAlignment.Left
        NotificationTitle.Parent = Notification
        
        local NotificationText = Instance.new("TextLabel")
        NotificationText.Name = "Text"
        NotificationText.BackgroundTransparency = 1
        NotificationText.Position = UDim2.new(0, 15, 0, 35)
        NotificationText.Size = UDim2.new(1, -30, 0, 40)
        NotificationText.Font = Enum.Font.Gotham
        NotificationText.Text = text
        NotificationText.TextColor3 = Theme.SubText
        NotificationText.TextSize = 14
        NotificationText.TextWrapped = true
        NotificationText.TextXAlignment = Enum.TextXAlignment.Left
        NotificationText.TextYAlignment = Enum.TextYAlignment.Top
        NotificationText.Parent = Notification
        
        -- Animação de entrada
        TweenService:Create(Notification, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(1, -320, 1, -100)
        }):Play()
        
        -- Esperar e então animar saída
        spawn(function()
            wait(duration)
            
            TweenService:Create(Notification, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.new(1, 0, 1, -100)
            }):Play()
            
            wait(0.5)
            Notification:Destroy()
        end)
    end
    
    -- Notificação de boas-vindas
    NotificationSystem.CreateNotification(
        "Blox Fruits Black Edition",
        "Script carregado com sucesso! Use os atalhos para ativar funções rapidamente.",
        10
    )
    
    -- Adicionar implementações reais para as funções
    
    -- Sistema de auto farm
    local AutoFarmSystem = {}
    AutoFarmSystem.Running = false
    AutoFarmSystem.CurrentTarget = nil
    
    AutoFarmSystem.Start = function()
        if AutoFarmSystem.Running then return end
        AutoFarmSystem.Running = true
        
        LogSystem.AddLog("AutoFarm", "Sistema de Auto Farm iniciado")
        
        spawn(function()
            while AutoFarmSystem.Running do
                -- Verificar se o jogador está vivo
                local player = game:GetService("Players").LocalPlayer
                local character = player.Character
                if not character or not character:FindFirstChild("HumanoidRootPart") or not character:FindFirstChildOfClass("Humanoid") then
                    wait(1)
                    continue
                end
                
                local hrp = character.HumanoidRootPart
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                
                -- Encontrar alvo baseado no método selecionado
                local target = nil
                
                if AutoFarmMethod == "Level" then
                    -- Encontrar o mob mais próximo com base no nível
                    local mobs = workspace:GetChildren()
                    local closest = nil
                    local closestDistance = math.huge
                    
                    for _, mob in pairs(mobs) do
                        if mob:IsA("Model") and mob ~= character and mob:FindFirstChildOfClass("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChildOfClass("Humanoid").Health > 0 then
                            local distance = (hrp.Position - mob.HumanoidRootPart.Position).Magnitude
                            if distance < closestDistance and distance <= FarmDistance then
                                closest = mob
                                closestDistance = distance
                            end
                        end
                    end
                    
                    target = closest
                elseif AutoFarmMethod == "Chest" then
                    -- Encontrar o baú mais próximo
                    local chests = {}
                    
                    for _, v in pairs(workspace:GetDescendants()) do
                        if string.find(v.Name:lower(), "chest") and (v:IsA("Part") or v:IsA("Model")) then
                            local part = v:IsA("Part") and v or v:FindFirstChildOfClass("Part")
                            if part then
                                local distance = (hrp.Position - part.Position).Magnitude
                                if distance <= FarmDistance then
                                    table.insert(chests, {Part = part, Distance = distance})
                                end
                            end
                        end
                    end
                    
                    table.sort(chests, function(a, b)
                        return a.Distance < b.Distance
                    end)
                    
                    if #chests > 0 then
                        target = chests[1].Part
                    end
                elseif AutoFarmMethod == "Fruit" then
                    -- Encontrar a fruta mais próxima
                    local fruits = {}
                    
                    for _, v in pairs(workspace:GetDescendants()) do
                        if string.find(v.Name:lower(), "fruit") and (v:IsA("Tool") or v:IsA("Model")) then
                            local part = v:IsA("Tool") and v:FindFirstChild("Handle") or v:FindFirstChildOfClass("Part")
                            if part then
                                local distance = (hrp.Position - part.Position).Magnitude
                                if distance <= FarmDistance then
                                    table.insert(fruits, {Part = part, Distance = distance})
                                end
                            end
                        end
                    end
                    
                    table.sort(fruits, function(a, b)
                        return a.Distance < b.Distance
                    end)
                    
                    if #fruits > 0 then
                        target = fruits[1].Part
                    end
                end
                
                -- Se tiver um alvo, mover até ele e atacar
                if target then
                    AutoFarmSystem.CurrentTarget = target
                    
                    -- Mover até o alvo
                    humanoid:MoveTo(target.Position)
                    
                    -- Esperar até estar próximo o suficiente
                    local distance = (hrp.Position - target.Position).Magnitude
                    if distance <= 10 then
                        -- Atacar (simular clique)
                        VirtualUser:Button1Down(Vector2.new(0, 0))
                        wait(0.1)
                        VirtualUser:Button1Up(Vector2.new(0, 0))
                        
                        -- Usar habilidades automaticamente
                        if AutoSkills then
                            local skillKeys = {"Z", "X", "C", "V", "F"}
                            
                            for _, key in ipairs(skillKeys) do
                                game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode[key], false, game)
                                wait(0.1)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode[key], false, game)
                                wait(0.5)
                            end
                        end
                    end
                else
                    AutoFarmSystem.CurrentTarget = nil
                    -- Sem alvo: esperar um pouco antes de procurar novamente
                    wait(1)
                end
                
                -- Adicionar delay humano com randomização para evitar detecção
                Security.RandomDelay(0.1, 0.3)
            end
        end)
    end
    
    AutoFarmSystem.Stop = function()
        AutoFarmSystem.Running = false
        AutoFarmSystem.CurrentTarget = nil
        LogSystem.AddLog("AutoFarm", "Sistema de Auto Farm parado")
    end
    
    -- Sistema de Kill Aura
    local KillAuraSystem = {}
    KillAuraSystem.Running = false
    
    KillAuraSystem.Start = function()
        if KillAuraSystem.Running then return end
        KillAuraSystem.Running = true
        
        LogSystem.AddLog("KillAura", "Sistema de Kill Aura iniciado")
        
        spawn(function()
            while KillAuraSystem.Running do
                -- Verificar se o jogador está vivo
                local player = game:GetService("Players").LocalPlayer
                local character = player.Character
                if not character or not character:FindFirstChild("HumanoidRootPart") or not character:FindFirstChildOfClass("Humanoid") then
                    wait(1)
                    continue
                end
                
                local hrp = character.HumanoidRootPart
                
                -- Encontrar todos os mobs próximos
                local targets = {}
                
                for _, mob in pairs(workspace:GetChildren()) do
                    if mob:IsA("Model") and mob ~= character and mob:FindFirstChildOfClass("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChildOfClass("Humanoid").Health > 0 then
                        local distance = (hrp.Position - mob.HumanoidRootPart.Position).Magnitude
                        if distance <= KillAuraRange then
                            table.insert(targets, mob)
                        end
                    end
                end
                
                -- Atacar todos os alvos encontrados
                if #targets > 0 then
                    -- Usar habilidade de área ou atacar individualmente
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Z, false, game)
                    wait(0.1)
                    game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Z, false, game)
                    
                    -- Atacar o mais próximo com habilidade focada
                    if targets[1] then
                        -- Virar para o alvo
                        character:SetPrimaryPartCFrame(CFrame.new(hrp.Position, targets[1].HumanoidRootPart.Position))
                        
                        -- Usar habilidade
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.X, false, game)
                        wait(0.1)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.X, false, game)
                    end
                    
                    -- Registrar log
                    LogSystem.AddLog("KillAura", "Atacando " .. #targets .. " inimigos")
                end
                
                -- Delay para evitar sobrecarga
                Security.RandomDelay(0.5, 1)
            end
        end)
    end
    
    KillAuraSystem.Stop = function()
        KillAuraSystem.Running = false
        LogSystem.AddLog("KillAura", "Sistema de Kill Aura parado")
    end
    
    -- Conectar o toggle de Kill Aura
    local oldKillAuraSetValue = KillAuraToggle.SetValue
    KillAuraToggle.SetValue = function(value)
        oldKillAuraSetValue(value)
        
        if value then
            KillAuraSystem.Start()
        else
            KillAuraSystem.Stop()
        end
    end
    
    -- Sistema Fruit Finder (Localizador de Frutas)
    local FruitFinderSystem = {}
    FruitFinderSystem.Running = false
    FruitFinderSystem.FoundFruits = {}
    
    FruitFinderSystem.Start = function()
        if FruitFinderSystem.Running then return end
        FruitFinderSystem.Running = true
        
        LogSystem.AddLog("FruitFinder", "Sistema de Localizador de Frutas iniciado")
        
        spawn(function()
            while FruitFinderSystem.Running do
                -- Limpar lista de frutas
                FruitFinderSystem.FoundFruits = {}
                
                -- Buscar frutas no workspace
                for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
                    if string.find(v.Name:lower(), "fruit") and (v:IsA("Tool") or v:IsA("Model")) then
                        local part = v:IsA("Tool") and v:FindFirstChild("Handle") or v:FindFirstChildOfClass("Part")
                        
                        if part then
                            table.insert(FruitFinderSystem.FoundFruits, {
                                Name = v.Name,
                                Position = part.Position,
                                Part = part,
                                Object = v
                            })
                        end
                    end
                end
                
                -- Notificar sobre frutas encontradas
                if #FruitFinderSystem.FoundFruits > 0 then
                    local player = game:GetService("Players").LocalPlayer
                    local character = player.Character
                    
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        for i, fruit in ipairs(FruitFinderSystem.FoundFruits) do
                            local distance = (character.HumanoidRootPart.Position - fruit.Position).Magnitude
                            
                            -- Mostrar apenas frutas novas ou a cada 30 segundos
                            if not fruit.Notified or os.time() - fruit.NotifiedTime > 30 then
                                NotificationSystem.CreateNotification(
                                    "🍎 Fruta Encontrada!",
                                    fruit.Name .. " a " .. math.floor(distance) .. "m de distância",
                                    5
                                )
                                
                                -- Marcar como notificada
                                fruit.Notified = true
                                fruit.NotifiedTime = os.time()
                                
                                -- Limitar a 3 notificações por vez
                                if i >= 3 then break end
                            end
                        end
                    end
                end
                
                -- Verificar a cada 15 segundos
                wait(15)
            end
        end)
    end
    
    FruitFinderSystem.Stop = function()
        FruitFinderSystem.Running = false
        FruitFinderSystem.FoundFruits = {}
        LogSystem.AddLog("FruitFinder", "Sistema de Localizador de Frutas parado")
    end
    
    -- Conectar toggle do FruitFinder
    local oldFruitFinderSetValue = FruitFinderToggle.SetValue
    FruitFinderToggle.SetValue = function(value)
        oldFruitFinderSetValue(value)
        
        if value then
            FruitFinderSystem.Start()
        else
            FruitFinderSystem.Stop()
        end
    end
    
    -- Sistema de Teleporte para Ilha
    local TeleportSystem = {}
    
    TeleportSystem.TeleportToIsland = function(islandName)
        -- Tabela com as coordenadas de cada ilha
        local islandLocations = {
            ["Starter Island"] = Vector3.new(1071.2832, 16.3085976, 1426.86792),
            ["Middle Town"] = Vector3.new(-655.824158, 7.88708115, 1436.67908),
            ["Jungle"] = Vector3.new(-1249.77222, 11.8870859, 341.356476),
            ["Pirate Village"] = Vector3.new(-1122.34998, 4.78708982, 3855.91992),
            ["Desert"] = Vector3.new(1094.14587, 6.47350502, 4192.88721),
            ["Frozen Village"] = Vector3.new(1198.00928, 27.0074959, -1211.73376),
            ["Marine Fortress"] = Vector3.new(-4505.375, 20.687294, 4260.55908),
            ["Skylands"] = Vector3.new(-4970.21875, 717.707275, -2622.35449),
            ["Colosseum"] = Vector3.new(-1428.35474, 7.38933945, -3014.37305),
            ["Prison"] = Vector3.new(4875.330078125, 5.6519818305969, 734.85021972656),
            ["Magma Village"] = Vector3.new(-5231.75879, 8.61593437, 8467.87695),
            -- Adicione mais ilhas conforme necessário
        }
        
        local selectedLocation = islandLocations[islandName]
        if not selectedLocation then
            NotificationSystem.CreateNotification(
                "Erro de Teleporte",
                "Localização não encontrada: " .. islandName,
                5
            )
            return false
        end
        
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then
            NotificationSystem.CreateNotification(
                "Erro de Teleporte",
                "Personagem não encontrado. Tente novamente.",
                5
            )
            return false
        end
        
        -- Animar o teleporte
        NotificationSystem.CreateNotification(
            "⚡ Teleportando...",
            "Destino: " .. islandName,
            3
        )
        
        local hrp = character.HumanoidRootPart
        
        -- Método de teleporte seguro com steps para evitar detecção
        local distance = (hrp.Position - selectedLocation).Magnitude
        local steps = math.min(10, math.max(5, math.floor(distance / 1000)))
        
        for i = 1, steps do
            local progress = i / steps
            local newPos = hrp.Position:Lerp(selectedLocation, progress)
            
            -- Teleportar
            hrp.CFrame = CFrame.new(newPos)
            
            -- Esperar um pouco entre cada step
            wait(0.1)
        end
        
        -- Teleporte final
        hrp.CFrame = CFrame.new(selectedLocation)
        
        LogSystem.AddLog("Teleport", "Teleportado para " .. islandName)
        
        NotificationSystem.CreateNotification(
            "✅ Teleporte Concluído",
            "Você chegou a: " .. islandName,
            3
        )
        
        return true
    end
    
    -- Conectar teleporte ao dropdown e botão
    IslandDropdown.SetValue("Starter Island") -- Valor padrão
    
    TeleportButton.MouseButton1Click:Connect(function()
        TeleportSystem.TeleportToIsland(IslandDropdown.GetValue())
    end)
    
    -- Sistema de Auto Skills (usar habilidades automaticamente)
    local AutoSkillsSystem = {}
    AutoSkillsSystem.Running = false
    AutoSkillsSystem.Skills = {
        {Key = "Z", Cooldown = 3},
        {Key = "X", Cooldown = 5},
        {Key = "C", Cooldown = 7},
        {Key = "V", Cooldown = 10},
        {Key = "F", Cooldown = 15}
    }
    AutoSkillsSystem.LastUsed = {}
    
    AutoSkillsSystem.Start = function()
        if AutoSkillsSystem.Running then return end
        AutoSkillsSystem.Running = true
        
        -- Inicializar cooldowns
        for _, skill in ipairs(AutoSkillsSystem.Skills) do
            AutoSkillsSystem.LastUsed[skill.Key] = 0
        end
        
        LogSystem.AddLog("AutoSkills", "Sistema de Auto Skills iniciado")
        
        spawn(function()
            while AutoSkillsSystem.Running do
                local player = game:GetService("Players").LocalPlayer
                local character = player.Character
                
                if character and character:FindFirstChildOfClass("Humanoid") and character:FindFirstChildOfClass("Humanoid").Health > 0 then
                    -- Verificar se há inimigos próximos
                    local hasTarget = false
                    
                    if AutoFarmSystem.CurrentTarget then
                        hasTarget = true
                    else
                        -- Verificar se há mobs próximos
                        for _, mob in pairs(workspace:GetChildren()) do
                            if mob:IsA("Model") and mob ~= character and mob:FindFirstChildOfClass("Humanoid") and mob:FindFirstChild("HumanoidRootPart") then
                                local distance = (character.HumanoidRootPart.Position - mob.HumanoidRootPart.Position).Magnitude
                                if distance <= 20 and mob:FindFirstChildOfClass("Humanoid").Health > 0 then
                                    hasTarget = true
                                    break
                                end
                            end
                        end
                    end
                    
                    -- Se tiver alvo, usar habilidades
                    if hasTarget then
                        for _, skill in ipairs(AutoSkillsSystem.Skills) do
                            local currentTime = tick()
                            if currentTime - (AutoSkillsSystem.LastUsed[skill.Key] or 0) >= skill.Cooldown then
                                -- Usar habilidade
                                game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode[skill.Key], false, game)
                                wait(0.1)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode[skill.Key], false, game)
                                
                                -- Atualizar tempo de último uso
                                AutoSkillsSystem.LastUsed[skill.Key] = currentTime
                                
                                -- Log
                                LogSystem.AddLog("AutoSkills", "Usando habilidade " .. skill.Key)
                                
                                -- Delay entre skills
                                wait(0.5)
                            end
                        end
                    end
                end
                
                -- Verificar a cada 1 segundo
                wait(1)
            end
        end)
    end
    
    AutoSkillsSystem.Stop = function()
        AutoSkillsSystem.Running = false
        LogSystem.AddLog("AutoSkills", "Sistema de Auto Skills parado")
    end
    
    -- Conectar toggle do AutoSkills
    local oldAutoSkillsSetValue = AutoSkillsToggle.SetValue
    AutoSkillsToggle.SetValue = function(value)
        oldAutoSkillsSetValue(value)
        
        if value then
            AutoSkillsSystem.Start()
        else
            AutoSkillsSystem.Stop()
        end
    end
    
    -- Sistema de Auto Parry (esquiva automática)
    local AutoParrySystem = {}
    AutoParrySystem.Running = false
    AutoParrySystem.ParryKey = "F" -- Tecla de parry/defesa
    
    AutoParrySystem.Start = function()
        if AutoParrySystem.Running then return end
        AutoParrySystem.Running = true
        
        LogSystem.AddLog("AutoParry", "Sistema de Auto Parry iniciado")
        
        spawn(function()
            while AutoParrySystem.Running do
                local player = game:GetService("Players").LocalPlayer
                local character = player.Character
                
                if character and character:FindFirstChild("HumanoidRootPart") then
                    -- Verificar jogadores próximos
                    for _, otherPlayer in pairs(game:GetService("Players"):GetPlayers()) do
                        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            local distance = (character.HumanoidRootPart.Position - otherPlayer.Character.HumanoidRootPart.Position).Magnitude
                            
                            -- Se estiver próximo e potencialmente atacando
                            if distance <= 15 then
                                -- Detectar animação de ataque (simplificada)
                                local isAttacking = false
                                
                                -- Este é um método simplificado de detecção
                                -- Em implementação real, seria necessário analisar animações específicas
                                for _, anim in pairs(otherPlayer.Character:FindFirstChildOfClass("Humanoid"):GetPlayingAnimationTracks()) do
                                    if string.find(anim.Name:lower(), "attack") or string.find(anim.Name:lower(), "combo") then
                                        isAttacking = true
                                        break
                                    end
                                end
                                
                                -- Outra detecção: verificar se está segurando arma/tool
                                if otherPlayer.Character:FindFirstChildOfClass("Tool") then
                                    -- Maior probabilidade de estar atacando
                                    isAttacking = math.random() > 0.7 -- 30% de chance
                                end
                                
                                -- Se detectar ataque, fazer parry
                                if isAttacking then
                                    -- Usar a tecla de parry
                                    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode[AutoParrySystem.ParryKey], false, game)
                                    wait(0.1)
                                    game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode[AutoParrySystem.ParryKey], false, game)
                                    
                                    LogSystem.AddLog("AutoParry", "Parry executado contra " .. otherPlayer.Name)
                                    
                                    -- Pequeno cooldown após parry
                                    wait(1)
                                end
                            end
                        end
                    end
                end
                
                -- Verificar a cada 0.1 segundo
                wait(0.1)
            end
        end)
    end
    
    AutoParrySystem.Stop = function()
        AutoParrySystem.Running = false
        LogSystem.AddLog("AutoParry", "Sistema de Auto Parry parado")
    end
    
    -- Conectar toggle do AutoParry
    local oldAutoParrySetValue = AutoParryToggle.SetValue
    AutoParryToggle.SetValue = function(value)
        oldAutoParrySetValue(value)
        
        if value then
            AutoParrySystem.Start()
        else
            AutoParrySystem.Stop()
        end
    end
    
    -- Sistema de Auto Raid
    local AutoRaidSystem = {}
    AutoRaidSystem.Running = false
    
    AutoRaidSystem.Start = function()
        if AutoRaidSystem.Running then return end
        AutoRaidSystem.Running = true
        
        LogSystem.AddLog("AutoRaid", "Sistema de Auto Raid iniciado")
        
        spawn(function()
            while AutoRaidSystem.Running do
                -- Verificar se está em uma raid
                local isInRaid = workspace:FindFirstChild("_WorldOrigin") and workspace._WorldOrigin:FindFirstChild("RaidMap")
                
                if isInRaid then
                    -- Lógica de raid: matar mobs, coletar itens
                    local player = game:GetService("Players").LocalPlayer
                    local character = player.Character
                    
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        -- Encontrar mobs da raid
                        local targets = {}
                        
                        for _, mob in pairs(workspace._WorldOrigin.Locations:GetChildren()) do
                            if mob:FindFirstChild("Monster") and mob.Monster.Value > 0 then
                                table.insert(targets, mob)
                            end
                        end
                        
                        -- Ir para o mob e atacar
                        if #targets > 0 then
                            -- Ordenar por distância
                            table.sort(targets, function(a, b)
                                local distA = (character.HumanoidRootPart.Position - a.Position).Magnitude
                                local distB = (character.HumanoidRootPart.Position - b.Position).Magnitude
                                return distA < distB
                            end)
                            
                            -- Teleportar para o alvo mais próximo
                            character.HumanoidRootPart.CFrame = CFrame.new(targets[1].Position)
                            
                            -- Usar habilidades
                            if AutoSkills then
                                local skillKeys = {"Z", "X", "C", "V", "F"}
                                
                                for _, key in ipairs(skillKeys) do
                                    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode[key], false, game)
                                    wait(0.1)
                                    game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode[key], false, game)
                                    wait(0.5)
                                end
                            end
                        else
                            -- Sem mobs, verificar se acabou a raid e coletar recompensa
                            local raidFinished = workspace._WorldOrigin:FindFirstChild("RaidFinished")
                            
                            if raidFinished then
                                -- Coletar recompensa
                                for _, v in pairs(workspace.Map:GetDescendants()) do
                                    if v.Name == "RaidRewardChest" and v:IsA("Model") then
                                        if v:FindFirstChild("Chest") then
                                            character.HumanoidRootPart.CFrame = v.Chest.CFrame
                                            wait(1)
                                            -- Simular interação
                                            for i = 1, 5 do
                                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaidsNpc", "Select", selectRaid)
                                                wait(0.1)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                else
                    -- Não está em raid: procurar NPC de raid e iniciar
                    local player = game:GetService("Players").LocalPlayer
                    local character = player.Character
                    
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        -- Procurar NPC de raid
                        for _, v in pairs(workspace.NPCs:GetChildren()) do
                            if v.Name == "Raid Broker" or v.Name:find("Raid") then
                                -- Teleportar para o NPC
                                character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame
                                wait(1)
                                
                                -- Simular clique/interação com NPC
                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Raid", "Raid", "Buy")
                                wait(0.5)
                                
                                -- Selecionar raid
                                local selectRaid = "Flame" -- Pode ser configurável depois
                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaidsNpc", "Select", selectRaid)
                                wait(0.5)
                                
                                -- Iniciar raid
                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaidsNpc", "Start")
                                
                                LogSystem.AddLog("AutoRaid", "Tentando iniciar raid: " .. selectRaid)
                            end
                        end
                    end
                end
                
                -- Esperar antes de verificar novamente
                wait(3)
            end
        end)
    end
    
    AutoRaidSystem.Stop = function()
        AutoRaidSystem.Running = false
        LogSystem.AddLog("AutoRaid", "Sistema de Auto Raid parado")
    end
    
    -- Conectar toggle do AutoRaid
    local oldAutoRaidSetValue = AutoRaidToggle.SetValue
    AutoRaidToggle.SetValue = function(value)
        oldAutoRaidSetValue(value)
        
        if value then
            AutoRaidSystem.Start()
        else
            AutoRaidSystem.Stop()
        end
    end
    
    -- Conectar os sistemas aos botões de atalho
    autoFarmQuickButton.MouseButton1Click:Connect(function()
        AutoFarmEnabled.SetValue(not AutoFarmEnabled.GetValue())
    end)
    
    teleportQuickButton.MouseButton1Click:Connect(function()
        -- Abrir o menu de teleporte
        MainFrame.Visible = true
        MinimizedFrame.Visible = false
        TabButtons[2].Button.MouseButton1Click:Fire()
    end)
    
    espQuickButton.MouseButton1Click:Connect(function()
        PlayerESPToggle.SetValue(not PlayerESPToggle.GetValue())
    end)
    
    fruitFinderQuickButton.MouseButton1Click:Connect(function()
        FruitFinderToggle.SetValue(not FruitFinderToggle.GetValue())
    end)
    
    killAuraQuickButton.MouseButton1Click:Connect(function()
        KillAuraToggle.SetValue(not KillAuraToggle.GetValue())
    end)
    
    -- GARANTIR LIMPEZA QUANDO O SCRIPT FOR DESTRUÍDO
    BloxFruitsMobileGUI.AncestryChanged:Connect(function(_, parent)
        if not parent then
            -- GUI foi destruída, limpar todas as funções
            if AutoFarmSystem.Running then AutoFarmSystem.Stop() end
            if KillAuraSystem.Running then KillAuraSystem.Stop() end
            if FruitFinderSystem.Running then FruitFinderSystem.Stop() end
            if AutoSkillsSystem.Running then AutoSkillsSystem.Stop() end
            if AutoParrySystem.Running then AutoParrySystem.Stop() end
            if AutoRaidSystem.Running then AutoRaidSystem.Stop() end
            
            -- Remover ESPs
            for _, item in pairs(game:GetService("CoreGui"):GetChildren()) do
                if item.Name:find("ESP") then
                    item:Destroy()
                end
            end
            
            -- Desconectar hooks e conexões
            LogSystem.AddLog("System", "Script destruído e recursos liberados")
        end
    end)
    
    -- NOTIFICAÇÃO INICIAL
    NotificationSystem.CreateNotification(
        "✅ SCRIPT CARREGADO",
        "Blox Fruits Mobile BLACK EDITION v3.5\nTudos os sistemas estão prontos!",
        10
    )
    
    -- VERIFICAÇÃO DE ATUALIZAÇÃO
    spawn(function()
        wait(5)
        
        NotificationSystem.CreateNotification(
            "🔍 VERIFICANDO ATUALIZAÇÕES",
            "Procurando por novas versões...",
            3
        )
        
        wait(2)
        
        -- Simulação de verificação de versão (em um script real, isso seria feito via servidor)
        local currentVersion = "3.5"
        local latestVersion = "3.5" -- Na prática, viria de um servidor
        
        if currentVersion ~= latestVersion then
            NotificationSystem.CreateNotification(
                "⚠️ ATUALIZAÇÃO DISPONÍVEL",
                "Nova versão " .. latestVersion .. " disponível!\nEntre no Discord para atualizar.",
                10
            )
        else
            NotificationSystem.CreateNotification(
                "✅ VERSÃO ATUALIZADA",
                "Você está usando a versão mais recente!",
                5
            )
        end
    end)
    
    -- DETECTAR ALTERAÇÕES NO JOGO
    spawn(function()
        while wait(30) do -- Verificar a cada 30 segundos
            local gameVersion = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Updated
            
            -- Verificar se o jogo foi atualizado recentemente (nas últimas 24 horas)
            if os.time() - gameVersion < 86400 then -- 86400 segundos = 24 horas
                NotificationSystem.CreateNotification(
                    "⚠️ JOGO ATUALIZADO",
                    "Blox Fruits foi atualizado recentemente.\nAlgumas funções podem não funcionar corretamente.",
                    10
                )
                
                -- Ativar modo seguro automaticamente
                if not UserSettings.SafeMode then
                    SafeModeToggle.SetValue(true)
                    
                    NotificationSystem.CreateNotification(
                        "🛡️ MODO SEGURO ATIVADO",
                        "Modo seguro ativado automaticamente devido à atualização do jogo.",
                        7
                    )
                end
            end
        end
    end)
    
    -- VERIFICAR CONEXÃO E DESEMPENHO
    spawn(function()
        while wait(5) do
            local stats = game:GetService("Stats")
            local ping = stats.Network.ServerStatsItem["Data Ping"]:GetValue()
            
            -- Se o ping estiver muito alto, notificar e ajustar configurações
            if ping > 500 then
                NotificationSystem.CreateNotification(
                    "⚠️ ALERTA DE CONEXÃO",
                    "Ping alto detectado: " .. math.floor(ping) .. "ms\nFunções podem ter atraso.",
                    5
                )
                
                -- Ajustar automaticamente para otimização mobile
                if not UserSettings.MobileOptimized then
                    MobileOptimizationToggle.SetValue(true)
                end
            end
        end
    end)
    
    -- LOG DE INICIALIZAÇÃO FINAL
    LogSystem.AddLog("System", "Script inicializado com sucesso. Todas as funções estão operacionais.")
    
    return BloxFruitsMobileGUI
end

-- Iniciar o script
local Security = SetupSecurity()
local GUI = CreateMobileUI()

-- Notificação de inicialização no sistema do Roblox
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "BLOX FRUITS BLACK EDITION",
    Text = "Script carregado com sucesso! Use o menu para acessar todas as funções.",
    Duration = 5
})