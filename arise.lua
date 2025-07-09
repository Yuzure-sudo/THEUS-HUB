-- Los CocoFantos - Hub Premium Mobile
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local IMAGE_ID = "rbxassetid://119139554769198"

-- Banidos
local Banidos = {548245499,2318524722,3564923852}
for _, id in ipairs(Banidos) do
    if LocalPlayer.UserId == id then
        LocalPlayer:Kick("Você está banido de usar este script. wrdyz.94 no Discord para apelação.")
        return
    end
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

-- AutoFarm Boss
local botaoBoss = Instance.new("TextButton", abasFrames["AutoFarm"])
botaoBoss.Text = "AutoFarm Boss"
botaoBoss.Font = Enum.Font.GothamBold
botaoBoss.TextSize = 17
botaoBoss.Size = UDim2.new(1, -40, 0, 44)
botaoBoss.Position = UDim2.new(0, 20, 0, 10)
botaoBoss.BackgroundColor3 = Color3.fromRGB(60,40,80)
botaoBoss.TextColor3 = Color3.fromRGB(255,255,255)
botaoBoss.BackgroundTransparency = 0.09

local bossFarm = false
local bossThread = nil
botaoBoss.MouseButton1Click:Connect(function()
    bossFarm = not bossFarm
    botaoBoss.Text = bossFarm and "Parar AutoFarm Boss" or "AutoFarm Boss"
    if bossFarm then
        bossThread = task.spawn(function()
            while bossFarm do
                local boss = nil
                for _,enemy in ipairs(workspace.__Main.__Enemies.Client:GetChildren()) do
                    if enemy.Name:lower():find("boss") and enemy:FindFirstChild("HumanoidRootPart") then
                        boss = enemy break
                    end
                end
                if boss then
                    local char = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.CFrame = boss.HumanoidRootPart.CFrame * CFrame.new(5,0,0)
                        ReplicatedStorage.BridgeNet2.dataRemoteEvent:FireServer({{["Event"]="PunchAttack",["Enemy"]=boss.Name},"\4"})
                    end
                end
                task.wait(0.5)
            end
        end)
    else
        if bossThread then task.cancel(bossThread) bossThread = nil end
    end
end)

-- AutoFarm Mobs
local botaoMob = Instance.new("TextButton", abasFrames["AutoFarm"])
botaoMob.Text = "AutoFarm Mobs"
botaoMob.Font = Enum.Font.GothamBold
botaoMob.TextSize = 17
botaoMob.Size = UDim2.new(1, -40, 0, 44)
botaoMob.Position = UDim2.new(0, 20, 0, 64)
botaoMob.BackgroundColor3 = Color3.fromRGB(60,40,80)
botaoMob.TextColor3 = Color3.fromRGB(255,255,255)
botaoMob.BackgroundTransparency = 0.09

local mobFarm = false
local mobThread = nil
botaoMob.MouseButton1Click:Connect(function()
    mobFarm = not mobFarm
    botaoMob.Text = mobFarm and "Parar AutoFarm Mobs" or "AutoFarm Mobs"
    if mobFarm then
        mobThread = task.spawn(function()
            while mobFarm do
                local closest, dist = nil, math.huge
                local char = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    for _, enemy in ipairs(workspace.__Main.__Enemies.Client:GetChildren()) do
                        if enemy:IsA("Model") and enemy:FindFirstChild("HumanoidRootPart") then
                            local d = (enemy.HumanoidRootPart.Position - hrp.Position).Magnitude
                            if d < dist then closest = enemy dist = d end
                        end
                    end
                    if closest then
                        hrp.CFrame = closest.HumanoidRootPart.CFrame * CFrame.new(5,0,0)
                        ReplicatedStorage.BridgeNet2.dataRemoteEvent:FireServer({{["Event"]="PunchAttack",["Enemy"]=closest.Name},"\4"})
                    end
                end
                task.wait(0.5)
            end
        end)
    else
        if mobThread then task.cancel(mobThread) mobThread = nil end
    end
end)

-- Kill Aura
local botaoAura = Instance.new("TextButton", abasFrames["AutoFarm"])
botaoAura.Text = "Ativar Kill Aura"
botaoAura.Font = Enum.Font.GothamBold
botaoAura.TextSize = 17
botaoAura.Size = UDim2.new(1, -40, 0, 44)
botaoAura.Position = UDim2.new(0, 20, 0, 118)
botaoAura.BackgroundColor3 = Color3.fromRGB(80,40,90)
botaoAura.TextColor3 = Color3.fromRGB(255,255,255)
botaoAura.BackgroundTransparency = 0.09

local auraOn = false
local auraThread = nil
botaoAura.MouseButton1Click:Connect(function()
    auraOn = not auraOn
    botaoAura.Text = auraOn and "Parar Kill Aura" or "Ativar Kill Aura"
    if auraOn then
        auraThread = task.spawn(function()
            while auraOn do
                local char = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
                local hrp = char:FindFirstChild("HumanoidRootPart")
                for _, enemy in ipairs(workspace.__Main.__Enemies.Client:GetChildren()) do
                    if enemy:IsA("Model") and enemy:FindFirstChild("HumanoidRootPart") then
                        if (enemy.HumanoidRootPart.Position - hrp.Position).Magnitude < 15 then
                            ReplicatedStorage.BridgeNet2.dataRemoteEvent:FireServer({{["Event"]="PunchAttack",["Enemy"]=enemy.Name},"\4"})
                        end
                    end
                end
                task.wait(0.2)
            end
        end)
    else
        if auraThread then task.cancel(auraThread) auraThread = nil end
    end
end)


-- Teleporte --

local botaoTpBoss = Instance.new("TextButton", abasFrames["Teleporte"])
botaoTpBoss.Text = "Teleportar para Boss"
botaoTpBoss.Font = Enum.Font.GothamBold
botaoTpBoss.TextSize = 17
botaoTpBoss.Size = UDim2.new(1, -40, 0, 44)
botaoTpBoss.Position = UDim2.new(0, 20, 0, 10)
botaoTpBoss.BackgroundColor3 = Color3.fromRGB(40,80,80)
botaoTpBoss.TextColor3 = Color3.fromRGB(255,255,255)
botaoTpBoss.BackgroundTransparency = 0.09
botaoTpBoss.MouseButton1Click:Connect(function()
    for _,enemy in ipairs(workspace.__Main.__Enemies.Client:GetChildren()) do
        if enemy.Name:lower():find("boss") and enemy:FindFirstChild("HumanoidRootPart") then
            local char = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0,7,0) end
            break
        end
    end
end)

local botaoSafe = Instance.new("TextButton", abasFrames["Teleporte"])
botaoSafe.Text = "Teleportar para SafeZone"
botaoSafe.Font = Enum.Font.GothamBold
botaoSafe.TextSize = 17
botaoSafe.Size = UDim2.new(1, -40, 0, 44)
botaoSafe.Position = UDim2.new(0, 20, 0, 64)
botaoSafe.BackgroundColor3 = Color3.fromRGB(40,80,80)
botaoSafe.TextColor3 = Color3.fromRGB(255,255,255)
botaoSafe.BackgroundTransparency = 0.09
botaoSafe.MouseButton1Click:Connect(function()
    local safe = workspace:FindFirstChild("__SafeZone") or workspace:FindFirstChild("SafeZone")
    if safe and safe:IsA("BasePart") then
        local char = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CFrame = safe.CFrame + Vector3.new(0,5,0) end
    end
end)


-- Pets --

local botaoMelhorPet = Instance.new("TextButton", abasFrames["Pets"])
botaoMelhorPet.Text = "Equipar Melhor Pet"
botaoMelhorPet.Font = Enum.Font.GothamBold
botaoMelhorPet.TextSize = 17
botaoMelhorPet.Size = UDim2.new(1, -40, 0, 44)
botaoMelhorPet.Position = UDim2.new(0, 20, 0, 10)
botaoMelhorPet.BackgroundColor3 = Color3.fromRGB(80,60,40)
botaoMelhorPet.TextColor3 = Color3.fromRGB(255,255,255)
botaoMelhorPet.BackgroundTransparency = 0.09
botaoMelhorPet.MouseButton1Click:Connect(function()
    local petsFolder = workspace.__Main.__Pets:FindFirstChild(tostring(Players.LocalPlayer.UserId))
    if petsFolder then
        local melhor, maior = nil, -math.huge
        for _,pet in ipairs(petsFolder:GetChildren()) do
            local power = pet:FindFirstChild("Power")
            if power and tonumber(power.Value) > maior then
                melhor = pet
                maior = tonumber(power.Value)
            end
        end
        if melhor then
            ReplicatedStorage.BridgeNet2.dataRemoteEvent:FireServer({{["Event"]="EquipPet",["Pet"]=melhor.Name},"\4"})
        end
    end
end)



-- Eventos --

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
                -- Exemplo: Teleporta para o primeiro dungeon encontrado
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


-- Configuracoes --

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
            VirtualUser:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
            task.wait(1)
            VirtualUser:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
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
end)

-- Esp --

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
