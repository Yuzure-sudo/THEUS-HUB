-- Los CocoFantos - Hub Mobile Premium (Bloco 1)
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local IMAGE_ID = "rbxassetid://119139554769198"

local Banidos = {548245499,2318524722,3564923852}
for _, id in ipairs(Banidos) do
    if LocalPlayer.UserId == id then
        LocalPlayer:Kick("Você está banido de usar este script. wrdyz.94 no Discord para apelação.")
        return
    end
end

-- Notificação simples
local function Notificar(texto, tempo)
    local sg = Instance.new("ScreenGui", CoreGui)
    sg.Name = "NotifLosCoco"
    local frame = Instance.new("Frame", sg)
    frame.AnchorPoint = Vector2.new(0.5,1)
    frame.Position = UDim2.new(0.5,0,0.93,0)
    frame.Size = UDim2.new(0,340,0,38)
    frame.BackgroundColor3 = Color3.fromRGB(30,30,40)
    frame.BackgroundTransparency = 0.09
    frame.ZIndex = 9999
    local txt = Instance.new("TextLabel", frame)
    txt.Size = UDim2.new(1,0,1,0)
    txt.BackgroundTransparency = 1
    txt.Text = texto
    txt.Font = Enum.Font.GothamBold
    txt.TextSize = 17
    txt.TextColor3 = Color3.fromRGB(255,255,255)
    txt.ZIndex = 9999
    local corner = Instance.new("UICorner", frame)
    TweenService:Create(frame, TweenInfo.new(0.25), {BackgroundTransparency=0.12}):Play()
    task.wait(tempo or 2)
    TweenService:Create(frame, TweenInfo.new(0.25), {BackgroundTransparency=1, TextTransparency=1}):Play()
    task.wait(0.3)
    sg:Destroy()
end

-- Quadrado minimizável mobile
local miniGui = Instance.new("ScreenGui", CoreGui)
miniGui.Name = "MiniLosCocoFantos"
miniGui.ResetOnSpawn = false
miniGui.IgnoreGuiInset = true

local miniFrame = Instance.new("Frame", miniGui)
miniFrame.Size = UDim2.new(0, 76, 0, 76)
miniFrame.Position = UDim2.new(0, 20, 0, 120)
miniFrame.BackgroundColor3 = Color3.fromRGB(25,25,40)
miniFrame.BackgroundTransparency = 0.08
miniFrame.Visible = false

local miniCorner = Instance.new("UICorner", miniFrame)
miniCorner.CornerRadius = UDim.new(0, 22)

local miniImg = Instance.new("ImageButton", miniFrame)
miniImg.Size = UDim2.new(1, -16, 1, -16)
miniImg.Position = UDim2.new(0, 8, 0, 8)
miniImg.Image = IMAGE_ID
miniImg.BackgroundTransparency = 1

local dragging, dragInput, dragStart, startPos
miniFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = miniFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
miniFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        miniFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- Interface principal mobile, responsiva
local screenGui = Instance.new("ScreenGui", CoreGui)
screenGui.Name = "Los_CocoFantos"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 610)
mainFrame.Position = UDim2.new(0, 20, 0, 40)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
mainFrame.BackgroundTransparency = 0.04
mainFrame.Visible = true

local mainCorner = Instance.new("UICorner", mainFrame)
mainCorner.CornerRadius = UDim.new(0, 28)

local logo = Instance.new("ImageLabel", mainFrame)
logo.BackgroundTransparency = 1
logo.Position = UDim2.new(0, 18, 0, 18)
logo.Size = UDim2.new(0, 52, 0, 52)
logo.Image = IMAGE_ID

local titulo = Instance.new("TextLabel", mainFrame)
titulo.Text = "Los CocoFantos"
titulo.Font = Enum.Font.GothamBlack
titulo.TextSize = 24
titulo.TextColor3 = Color3.fromRGB(255,255,255)
titulo.BackgroundTransparency = 1
titulo.Size = UDim2.new(1, -80, 0, 44)
titulo.Position = UDim2.new(0, 78, 0, 22)
titulo.TextXAlignment = Enum.TextXAlignment.Left

local minimizar = Instance.new("ImageButton", mainFrame)
minimizar.Size = UDim2.new(0, 38, 0, 38)
minimizar.Position = UDim2.new(1, -48, 0, 18)
minimizar.BackgroundTransparency = 1
minimizar.Image = IMAGE_ID
minimizar.ImageColor3 = Color3.fromRGB(180, 180, 255)

minimizar.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    miniFrame.Visible = true
end)
miniImg.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    miniFrame.Visible = false
end)

-- Abas grandes, mobile
local abas = {"Menu","AutoFarm","Teleporte","Pets","Eventos","Configurações","Créditos"}
local abasFrames = {}
local abasBotoes = {}
local abasBar = Instance.new("Frame", mainFrame)
abasBar.Position = UDim2.new(0,0,0,80)
abasBar.Size = UDim2.new(1,0,0,54)
abasBar.BackgroundTransparency = 1
local abasLayout = Instance.new("UIListLayout", abasBar)
abasLayout.FillDirection = Enum.FillDirection.Horizontal
abasLayout.SortOrder = Enum.SortOrder.LayoutOrder
abasLayout.Padding = UDim.new(0, 8)
local conteudoFrame = Instance.new("Frame", mainFrame)
conteudoFrame.Position = UDim2.new(0, 0, 0, 140)
conteudoFrame.Size = UDim2.new(1, 0, 1, -140)
conteudoFrame.BackgroundTransparency = 1

for i, nome in ipairs(abas) do
    local botao = Instance.new("TextButton", abasBar)
    botao.Text = nome
    botao.Font = Enum.Font.GothamBold
    botao.TextSize = 18
    botao.Size = UDim2.new(0, 110, 1, 0)
    botao.BackgroundColor3 = Color3.fromRGB(35,35,65)
    botao.TextColor3 = Color3.fromRGB(220,220,255)
    botao.AutoButtonColor = true
    botao.BackgroundTransparency = 0.15
    local corner = Instance.new("UICorner", botao)
    corner.CornerRadius = UDim.new(0, 12)
    abasBotoes[nome] = botao

    local frame = Instance.new("Frame", conteudoFrame)
    frame.Name = nome.."Aba"
    frame.Size = UDim2.new(1,0,1,0)
    frame.BackgroundTransparency = 1
    frame.Visible = (i==1)
    abasFrames[nome] = frame

    botao.MouseButton1Click:Connect(function()
        for _, f in pairs(abasFrames) do f.Visible = false end
        frame.Visible = true
    end)
end

-- AutoFarm
local autoFarmAtivo = false
local safeMode = true
local autoFarmThread = nil

local autoFarmBotao = Instance.new("TextButton", abasFrames["AutoFarm"])
autoFarmBotao.Text = "Ativar AutoFarm"
autoFarmBotao.Font = Enum.Font.GothamBold
autoFarmBotao.TextSize = 17
autoFarmBotao.Size = UDim2.new(1, -40, 0, 44)
autoFarmBotao.Position = UDim2.new(0, 20, 0, 10)
autoFarmBotao.BackgroundColor3 = Color3.fromRGB(100,100,60)
autoFarmBotao.TextColor3 = Color3.fromRGB(255,255,255)
autoFarmBotao.BackgroundTransparency = 0.09

local modoBotao = Instance.new("TextButton", abasFrames["AutoFarm"])
modoBotao.Text = "Modo: Safe"
modoBotao.Font = Enum.Font.Gotham
modoBotao.TextSize = 15
modoBotao.Size = UDim2.new(1, -40, 0, 38)
modoBotao.Position = UDim2.new(0, 20, 0, 64)
modoBotao.BackgroundColor3 = Color3.fromRGB(60,100,100)
modoBotao.TextColor3 = Color3.fromRGB(255,255,255)
modoBotao.BackgroundTransparency = 0.1

modoBotao.MouseButton1Click:Connect(function()
    safeMode = not safeMode
    modoBotao.Text = safeMode and "Modo: Safe" or "Modo: Kamikaze"
    Notificar("Modo de farm: " .. (safeMode and "Safe" or "Kamikaze"), 2)
end)

autoFarmBotao.MouseButton1Click:Connect(function()
    autoFarmAtivo = not autoFarmAtivo
    autoFarmBotao.Text = autoFarmAtivo and "Parar AutoFarm" or "Ativar AutoFarm"
    if autoFarmAtivo then
        autoFarmThread = task.spawn(function()
            while autoFarmAtivo do
                local inimigos = workspace:FindFirstChild("__Main") and workspace.__Main:FindFirstChild("__Enemies") and workspace.__Main.__Enemies:FindFirstChild("Client")
                if inimigos then
                    for _, inimigo in ipairs(inimigos:GetChildren()) do
                        if inimigo:IsA("Model") and inimigo:FindFirstChild("HumanoidRootPart") then
                            if safeMode and string.find(inimigo.Name:lower(), "boss") then
                                continue
                            end
                            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                hrp.CFrame = inimigo.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
                                break
                            end
                        end
                    end
                end
                task.wait(1)
            end
        end)
    else
        if autoFarmThread then
            task.cancel(autoFarmThread)
            autoFarmThread = nil
        end
    end
end)

-- Menu
local saudacao = Instance.new("TextLabel", abasFrames["Menu"])
saudacao.Text = "Bem-vindo ao Los CocoFantos!\nScript mobile-friendly, ultra premium."
saudacao.Font = Enum.Font.GothamBlack
saudacao.TextSize = 22
saudacao.TextColor3 = Color3.fromRGB(200, 220, 255)
saudacao.BackgroundTransparency = 1
saudacao.Size = UDim2.new(1, 0, 0, 60)
saudacao.Position = UDim2.new(0, 0, 0, 10)

-- Créditos
local creditos = Instance.new("TextLabel", abasFrames["Créditos"])
creditos.Text = "Criado exclusivamente para 3 gays.\nScript mobile-friendly, by wrdyz.94"
creditos.Font = Enum.Font.GothamBold
creditos.TextSize = 18
creditos.TextColor3 = Color3.fromRGB(255, 80, 180)
creditos.BackgroundTransparency = 1
creditos.Size = UDim2.new(1, 0, 0, 60)
creditos.Position = UDim2.new(0, 0, 0, 20)

-- Auto Dungeon
local botaoDungeon = Instance.new("TextButton", abasFrames["Eventos"])
botaoDungeon.Text = "Auto Dungeon"
botaoDungeon.Font = Enum.Font.GothamBold
botaoDungeon.TextSize = 17
botaoDungeon.Size = UDim2.new(1, -40, 0, 44)
botaoDungeon.Position = UDim2.new(0, 20, 0, 10)
botaoDungeon.BackgroundColor3 = Color3.fromRGB(80,80,40)
botaoDungeon.TextColor3 = Color3.fromRGB(255,255,255)
botaoDungeon.BackgroundTransparency = 0.09
local autoDungeon = false
local dungeonThread = nil
botaoDungeon.MouseButton1Click:Connect(function()
    autoDungeon = not autoDungeon
    botaoDungeon.Text = autoDungeon and "Parar Auto Dungeon" or "Auto Dungeon"
    if autoDungeon then
        dungeonThread = task.spawn(function()
            while autoDungeon do
                local dungeons = workspace:FindFirstChild("__Dungeons")
                if dungeons and #dungeons:GetChildren() > 0 then
                    local dung = dungeons:GetChildren()[1]
                    if dung:IsA("BasePart") then
                        local char = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        if hrp then hrp.CFrame = dung.CFrame + Vector3.new(0,5,0) end
                    end
                end
                task.wait(2)
            end
        end)
    else
        if dungeonThread then task.cancel(dungeonThread) dungeonThread = nil end
    end
end)

-- Auto Mount
local botaoMount = Instance.new("TextButton", abasFrames["Eventos"])
botaoMount.Text = "Auto Mount"
botaoMount.Font = Enum.Font.GothamBold
botaoMount.TextSize = 17
botaoMount.Size = UDim2.new(1, -40, 0, 44)
botaoMount.Position = UDim2.new(0, 20, 0, 64)
botaoMount.BackgroundColor3 = Color3.fromRGB(80,60,120)
botaoMount.TextColor3 = Color3.fromRGB(255,255,255)
botaoMount.BackgroundTransparency = 0.09
local autoMount = false
local mountThread = nil
botaoMount.MouseButton1Click:Connect(function()
    autoMount = not autoMount
    botaoMount.Text = autoMount and "Parar Auto Mount" or "Auto Mount"
    if autoMount then
        mountThread = task.spawn(function()
            while autoMount do
                local mounts = workspace:FindFirstChild("__Extra") and workspace.__Extra:FindFirstChild("__Appear")
                if mounts and #mounts:GetChildren() > 0 then
                    local mount = mounts:GetChildren()[1]
                    local part = mount.PrimaryPart or mount:FindFirstChild("HumanoidRootPart")
                    if part then
                        local char = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        if hrp then hrp.CFrame = part.CFrame end
                    end
                end
                task.wait(2)
            end
        end)
    else
        if mountThread then task.cancel(mountThread) mountThread = nil end
    end
end)

-- Auto Claim Diário
local botaoDaily = Instance.new("TextButton", abasFrames["Eventos"])
botaoDaily.Text = "Auto Claim Diário"
botaoDaily.Font = Enum.Font.GothamBold
botaoDaily.TextSize = 17
botaoDaily.Size = UDim2.new(1, -40, 0, 44)
botaoDaily.Position = UDim2.new(0, 20, 0, 118)
botaoDaily.BackgroundColor3 = Color3.fromRGB(60,120,60)
botaoDaily.TextColor3 = Color3.fromRGB(255,255,255)
botaoDaily.BackgroundTransparency = 0.09
botaoDaily.MouseButton1Click:Connect(function()
    ReplicatedStorage.BridgeNet2.dataRemoteEvent:FireServer({{["Event"]="ClaimDaily"},"\4"})
    Notificar("Daily Claim enviado!",2)
end)

-- Anti-AFK
local antiAfk = Instance.new("TextButton", abasFrames["Configurações"])
antiAfk.Text = "Ativar Anti-AFK"
antiAfk.Font = Enum.Font.GothamBold
antiAfk.TextSize = 17
antiAfk.Size = UDim2.new(1, -40, 0, 44)
antiAfk.Position = UDim2.new(0, 20, 0, 10)
antiAfk.BackgroundColor3 = Color3.fromRGB(80,80,80)
antiAfk.TextColor3 = Color3.fromRGB(255,255,255)
antiAfk.BackgroundTransparency = 0.09
local antiAfkOn = false
local afkConn = nil
antiAfk.MouseButton1Click:Connect(function()
    antiAfkOn = not antiAfkOn
    antiAfk.Text = antiAfkOn and "Parar Anti-AFK" or "Ativar Anti-AFK"
    if antiAfkOn then
        afkConn = LocalPlayer.Idled:Connect(function()
            game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
            task.wait(1)
            game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        end)
    else
        if afkConn then afkConn:Disconnect() afkConn = nil end
    end
end)

-- Hitbox Expander
local botaoHitbox = Instance.new("TextButton", abasFrames["Configurações"])
botaoHitbox.Text = "Expandir Hitbox Inimigos"
botaoHitbox.Font = Enum.Font.GothamBold
botaoHitbox.TextSize = 17
botaoHitbox.Size = UDim2.new(1, -40, 0, 44)
botaoHitbox.Position = UDim2.new(0, 20, 0, 64)
botaoHitbox.BackgroundColor3 = Color3.fromRGB(120,80,80)
botaoHitbox.TextColor3 = Color3.fromRGB(255,255,255)
botaoHitbox.BackgroundTransparency = 0.09
botaoHitbox.MouseButton1Click:Connect(function()
    for _,enemy in ipairs(workspace.__Main.__Enemies.Client:GetChildren()) do
        if enemy:IsA("Model") and enemy:FindFirstChild("Hitbox") then
            enemy.Hitbox.Size = Vector3.new(35,35,35)
        end
    end
    Notificar("Hitbox expandido!",2)
end)

-- ESP Inimigos
local botaoEsp = Instance.new("TextButton", abasFrames["Configurações"])
botaoEsp.Text = "Ativar ESP Inimigos"
botaoEsp.Font = Enum.Font.GothamBold
botaoEsp.TextSize = 17
botaoEsp.Size = UDim2.new(1, -40, 0, 44)
botaoEsp.Position = UDim2.new(0, 20, 0, 118)
botaoEsp.BackgroundColor3 = Color3.fromRGB(60,120,120)
botaoEsp.TextColor3 = Color3.fromRGB(255,255,255)
botaoEsp.BackgroundTransparency = 0.09
local espOn = false
local espThread = nil
botaoEsp.MouseButton1Click:Connect(function()
    espOn = not espOn
    botaoEsp.Text = espOn and "Parar ESP Inimigos" or "Ativar ESP Inimigos"
    if espOn then
        espThread = task.spawn(function()
            while espOn do
                for _,enemy in ipairs(workspace.__Main.__Enemies.Client:GetChildren()) do
                    if enemy:IsA("Model") and enemy:FindFirstChild("HumanoidRootPart") then
                        if not enemy:FindFirstChild("ESPBox") then
                            local box = Instance.new("BoxHandleAdornment")
                            box.Name = "ESPBox"
                            box.Adornee = enemy.HumanoidRootPart
                            box.Size = Vector3.new(5,7,5)
                            box.Color3 = Color3.fromRGB(255,0,0)
                            box.AlwaysOnTop = true
                            box.ZIndex = 10
                            box.Transparency = 0.5
                            box.Parent = enemy
                        end
                    end
                end
                task.wait(2)
            end
        end)
    else
        for _,enemy in ipairs(workspace.__Main.__Enemies.Client:GetChildren()) do
            if enemy:FindFirstChild("ESPBox") then enemy.ESPBox:Destroy() end
        end
        if espThread then task.cancel(espThread) espThread = nil end
    end
end)

-- WalkSpeed e JumpPower
local botaoSpeed = Instance.new("TextButton", abasFrames["Configurações"])
botaoSpeed.Text = "WalkSpeed + JumpPower"
botaoSpeed.Font = Enum.Font.GothamBold
botaoSpeed.TextSize = 17
botaoSpeed.Size = UDim2.new(1, -40, 0, 44)
botaoSpeed.Position = UDim2.new(0, 20, 0, 172)
botaoSpeed.BackgroundColor3 = Color3.fromRGB(80,100,80)
botaoSpeed.TextColor3 = Color3.fromRGB(255,255,255)
botaoSpeed.BackgroundTransparency = 0.09
botaoSpeed.MouseButton1Click:Connect(function()
    local char = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = 60
        hum.JumpPower = 100
        Notificar("WalkSpeed e JumpPower aumentados!",2)
    end
end)

-- Resetar personagem
local botaoReset = Instance.new("TextButton", abasFrames["Configurações"])
botaoReset.Text = "Resetar Personagem"
botaoReset.Font = Enum.Font.GothamBold
botaoReset.TextSize = 17
botaoReset.Size = UDim2.new(1, -40, 0, 44)
botaoReset.Position = UDim2.new(0, 20, 0, 226)
botaoReset.BackgroundColor3 = Color3.fromRGB(80,80,80)
botaoReset.TextColor3 = Color3.fromRGB(255,255,255)
botaoReset.BackgroundTransparency = 0.09
botaoReset.MouseButton1Click:Connect(function()
    local char = Players.LocalPlayer.Character
    if char then
        char:BreakJoints()
        Notificar("Personagem resetado!",2)
    end
end)
