local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local IMAGE_ID = "rbxassetid://119139554769198"

local JogadoresBanidos = {548245499,2318524722,3564923852}
local jogador = game.Players.LocalPlayer
local idUsuario = jogador.UserId
for _, idBanido in ipairs(JogadoresBanidos) do
    if idUsuario == idBanido then
        jogador:Kick("Você está banido de usar este script. wrdyz.94 no Discord para apelação.")
        break
    end
end

-- Quadrado minimizável e arrastável
local miniGui = Instance.new("ScreenGui")
miniGui.Name = "MiniLosCocoFantos"
miniGui.Parent = CoreGui
miniGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local miniFrame = Instance.new("Frame")
miniFrame.Parent = miniGui
miniFrame.Size = UDim2.new(0, 60, 0, 60)
miniFrame.Position = UDim2.new(0, 30, 0, 120)
miniFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
miniFrame.BackgroundTransparency = 0.1
miniFrame.Visible = false

local miniCorner = Instance.new("UICorner", miniFrame)
miniCorner.CornerRadius = UDim.new(0, 14)

local miniStroke = Instance.new("UIStroke", miniFrame)
miniStroke.Color = Color3.fromRGB(0, 132, 255)
miniStroke.Thickness = 1.3
miniStroke.Transparency = 0.2

local miniImg = Instance.new("ImageButton")
miniImg.Parent = miniFrame
miniImg.Size = UDim2.new(1, -12, 1, -12)
miniImg.Position = UDim2.new(0, 6, 0, 6)
miniImg.Image = IMAGE_ID
miniImg.BackgroundTransparency = 1

-- Draggable
local dragging, dragInput, dragStart, startPos
miniFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = miniFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
miniFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
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

-- Interface principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Los_CocoFantos"
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 700, 0, 420)
mainFrame.Position = UDim2.new(0.5, -350, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BackgroundTransparency = 0.13

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

local titulo = Instance.new("TextLabel")
titulo.Name = "Titulo"
titulo.Parent = mainFrame
titulo.Text = "Los CocoFantos"
titulo.Font = Enum.Font.GothamBold
titulo.TextSize = 22
titulo.TextColor3 = Color3.fromRGB(200, 220, 255)
titulo.BackgroundTransparency = 1
titulo.Size = UDim2.new(1, -100, 0, 38)
titulo.Position = UDim2.new(0, 80, 0, 20)
titulo.TextXAlignment = Enum.TextXAlignment.Left

local minimizar = Instance.new("ImageButton")
minimizar.Name = "Minimizar"
minimizar.Parent = mainFrame
minimizar.Size = UDim2.new(0, 34, 0, 34)
minimizar.Position = UDim2.new(1, -44, 0, 16)
minimizar.BackgroundTransparency = 1
minimizar.Image = IMAGE_ID
minimizar.ImageColor3 = Color3.fromRGB(180, 180, 255)

local painelAbas = Instance.new("Frame")
painelAbas.Name = "PainelAbas"
painelAbas.Parent = mainFrame
painelAbas.Size = UDim2.new(0, 130, 1, -70)
painelAbas.Position = UDim2.new(0, 0, 0, 70)
painelAbas.BackgroundTransparency = 0.22
painelAbas.BackgroundColor3 = Color3.fromRGB(25, 25, 40)

local painelCorner = Instance.new("UICorner", painelAbas)
painelCorner.CornerRadius = UDim.new(0, 12)

local listaAbas = Instance.new("UIListLayout", painelAbas)
listaAbas.SortOrder = Enum.SortOrder.LayoutOrder
listaAbas.Padding = UDim.new(0, 12)

local conteudoFrame = Instance.new("Frame")
conteudoFrame.Name = "ConteudoFrame"
conteudoFrame.Parent = mainFrame
conteudoFrame.Position = UDim2.new(0, 140, 0, 70)
conteudoFrame.Size = UDim2.new(1, -150, 1, -80)
conteudoFrame.BackgroundTransparency = 1

local function criarAba(nomeAba)
    local abaFrame = Instance.new("Frame")
    abaFrame.Name = nomeAba.."Aba"
    abaFrame.Parent = conteudoFrame
    abaFrame.Size = UDim2.new(1, 0, 1, 0)
    abaFrame.BackgroundTransparency = 1
    abaFrame.Visible = false

    local abaBotao = Instance.new("ImageButton")
    abaBotao.Name = nomeAba.."Botao"
    abaBotao.Parent = painelAbas
    abaBotao.Size = UDim2.new(1, -20, 0, 44)
    abaBotao.BackgroundTransparency = 0.1
    abaBotao.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    abaBotao.Image = IMAGE_ID

    local btnCorner = Instance.new("UICorner", abaBotao)
    btnCorner.CornerRadius = UDim.new(0, 8)

    local btnLabel = Instance.new("TextLabel")
    btnLabel.Parent = abaBotao
    btnLabel.Size = UDim2.new(1, 0, 1, 0)
    btnLabel.BackgroundTransparency = 1
    btnLabel.Text = nomeAba
    btnLabel.Font = Enum.Font.GothamBold
    btnLabel.TextSize = 16
    btnLabel.TextColor3 = Color3.fromRGB(220, 220, 255)

    abaBotao.MouseButton1Click:Connect(function()
        for _, frame in pairs(conteudoFrame:GetChildren()) do
            if frame:IsA("Frame") then
                frame.Visible = false
            end
        end
        abaFrame.Visible = true
    end)
    return abaFrame
end

local menuAba = criarAba("Menu")
menuAba.Visible = true
local autofarmAba = criarAba("AutoFarm")
local teleportAba = criarAba("Teleporte")
local petsAba = criarAba("Pets")
local eventosAba = criarAba("Eventos")
local configAba = criarAba("Configurações")
local creditosAba = criarAba("Créditos")

-- Minimizar e restaurar
minimizar.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    miniFrame.Visible = true
end)
miniImg.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    miniFrame.Visible = false
end)

-- Drag principal
local arrastando, arrastarInput, inicioArraste, posInicio
titulo.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        arrastando = true
        inicioArraste = input.Position
        posInicio = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                arrastando = false
            end
        end)
    end
end)
titulo.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        arrastarInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if arrastando and input == arrastarInput then
        local delta = input.Position - inicioArraste
        mainFrame.Position = UDim2.new(
            posInicio.X.Scale, posInicio.X.Offset + delta.X,
            posInicio.Y.Scale, posInicio.Y.Offset + delta.Y
        )
    end
end)

-- Menu principal
local saudacao = Instance.new("TextLabel")
saudacao.Parent = menuAba
saudacao.Text = "Bem-vindo ao Los CocoFantos!"
saudacao.Font = Enum.Font.GothamBold
saudacao.TextSize = 20
saudacao.TextColor3 = Color3.fromRGB(200, 220, 255)
saudacao.BackgroundTransparency = 1
saudacao.Size = UDim2.new(1, 0, 0, 40)
saudacao.Position = UDim2.new(0, 0, 0, 10)

-- Créditos
local creditos = Instance.new("TextLabel")
creditos.Parent = creditosAba
creditos.Text = "Criado exclusivamente para 3 gays."
creditos.Font = Enum.Font.GothamBold
creditos.TextSize = 18
creditos.TextColor3 = Color3.fromRGB(255, 80, 180)
creditos.BackgroundTransparency = 1
creditos.Size = UDim2.new(1, 0, 0, 40)
creditos.Position = UDim2.new(0, 0, 0, 20)

-- AutoFarm
local botaoAutoFarm = Instance.new("TextButton")
botaoAutoFarm.Parent = autofarmAba
botaoAutoFarm.Text = "Ativar AutoFarm Global"
botaoAutoFarm.Font = Enum.Font.GothamBold
botaoAutoFarm.TextSize = 18
botaoAutoFarm.TextColor3 = Color3.fromRGB(255,255,255)
botaoAutoFarm.BackgroundColor3 = Color3.fromRGB(40,40,80)
botaoAutoFarm.Size = UDim2.new(0, 260, 0, 40)
botaoAutoFarm.Position = UDim2.new(0, 30, 0, 30)
botaoAutoFarm.BackgroundTransparency = 0.1

local farmando = false
local threadFarm = nil

botaoAutoFarm.MouseButton1Click:Connect(function()
    farmando = not farmando
    botaoAutoFarm.Text = farmando and "Desativar AutoFarm Global" or "Ativar AutoFarm Global"
    if farmando then
        threadFarm = task.spawn(function()
            while farmando do
                local player = game.Players.LocalPlayer
                local char = player.Character or player.CharacterAdded:Wait()
                local humanoidRootPart = char:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    local closest, dist = nil, math.huge
                    for _, enemy in ipairs(workspace.__Main.__Enemies.Client:GetChildren()) do
                        if enemy:IsA("Model") and enemy:FindFirstChild("HumanoidRootPart") then
                            local d = (enemy.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude
                            if d < dist then
                                closest = enemy
                                dist = d
                            end
                        end
                    end
                    if closest then
                        humanoidRootPart.CFrame = closest.HumanoidRootPart.CFrame * CFrame.new(5,0,0)
                        local args = {
                            [1] = {
                                [1] = {
                                    ["Event"] = "PunchAttack",
                                    ["Enemy"] = closest.Name
                                },
                                [2] = "\4"
                            }
                        }
                        game:GetService("ReplicatedStorage"):WaitForChild("BridgeNet2"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))
                    end
                end
                task.wait(0.5)
            end
        end)
    else
        if threadFarm then
            task.cancel(threadFarm)
            threadFarm = nil
        end
    end
end)

-- Teleporte
local botaoAtualizar = Instance.new("TextButton")
botaoAtualizar.Parent = teleportAba
botaoAtualizar.Text = "Atualizar Destinos"
botaoAtualizar.Font = Enum.Font.GothamBold
botaoAtualizar.TextSize = 16
botaoAtualizar.TextColor3 = Color3.fromRGB(255,255,255)
botaoAtualizar.BackgroundColor3 = Color3.fromRGB(40,40,80)
botaoAtualizar.Size = UDim2.new(0, 180, 0, 34)
botaoAtualizar.Position = UDim2.new(0, 30, 0, 30)
botaoAtualizar.BackgroundTransparency = 0.1

local listaDestinos = Instance.new("Frame")
listaDestinos.Parent = teleportAba
listaDestinos.Position = UDim2.new(0, 30, 0, 80)
listaDestinos.Size = UDim2.new(0, 250, 0, 230)
listaDestinos.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", listaDestinos)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 8)

local function atualizarDestinos()
    for _,v in pairs(listaDestinos:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end
    local destinos = {}
    local spawnFolder = workspace:FindFirstChild("__Extra") and workspace.__Extra:FindFirstChild("__Spawns")
    if spawnFolder then
        for _, spawn in pairs(spawnFolder:GetChildren()) do
            if spawn:IsA("BasePart") then
                table.insert(destinos, spawn)
            end
        end
    end
    for _,dest in ipairs(destinos) do
        local btn = Instance.new("TextButton")
        btn.Parent = listaDestinos
        btn.Text = dest.Name
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 15
        btn.Size = UDim2.new(1,0,0,32)
        btn.BackgroundColor3 = Color3.fromRGB(30,30,80)
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.BackgroundTransparency = 0.15
        btn.MouseButton1Click:Connect(function()
            local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = dest.CFrame + Vector3.new(0,5,0)
            end
        end)
    end
end
botaoAtualizar.MouseButton1Click:Connect(atualizarDestinos)
atualizarDestinos()

-- Pets
local botaoMelhorPet = Instance.new("TextButton")
botaoMelhorPet.Parent = petsAba
botaoMelhorPet.Text = "Equipar Melhor Pet"
botaoMelhorPet.Font = Enum.Font.GothamBold
botaoMelhorPet.TextSize = 18
botaoMelhorPet.TextColor3 = Color3.fromRGB(255,255,255)
botaoMelhorPet.BackgroundColor3 = Color3.fromRGB(40,40,80)
botaoMelhorPet.Size = UDim2.new(0, 220, 0, 40)
botaoMelhorPet.Position = UDim2.new(0, 30, 0, 30)
botaoMelhorPet.BackgroundTransparency = 0.1

botaoMelhorPet.MouseButton1Click:Connect(function()
    local petsFolder = workspace.__Main.__Pets:FindFirstChild(tostring(game.Players.LocalPlayer.UserId))
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
            game:GetService("ReplicatedStorage"):WaitForChild("BridgeNet2"):WaitForChild("dataRemoteEvent"):FireServer({
                [1] = {
                    [1] = {
                        ["Event"] = "EquipPet",
                        ["Pet"] = melhor.Name
                    },
                    [2] = "\4"
                }
            })
        end
    end
end)

-- Eventos
local botaoEvento = Instance.new("TextButton")
botaoEvento.Parent = eventosAba
botaoEvento.Text = "AutoFarm Eventos (Mounts, Raid, Dungeon)"
botaoEvento.Font = Enum.Font.GothamBold
botaoEvento.TextSize = 18
botaoEvento.TextColor3 = Color3.fromRGB(255,255,255)
botaoEvento.BackgroundColor3 = Color3.fromRGB(40,40,80)
botaoEvento.Size = UDim2.new(0, 320, 0, 40)
botaoEvento.Position = UDim2.new(0, 30, 0, 30)
botaoEvento.BackgroundTransparency = 0.1

local farmandoEvento = false
local threadEvento = nil

botaoEvento.MouseButton1Click:Connect(function()
    farmandoEvento = not farmandoEvento
    botaoEvento.Text = farmandoEvento and "Parar AutoFarm Eventos" or "AutoFarm Eventos (Mounts, Raid, Dungeon)"
    if farmandoEvento then
        threadEvento = task.spawn(function()
            while farmandoEvento do
                local mounts = workspace:FindFirstChild("__Extra") and workspace.__Extra:FindFirstChild("__Appear")
                if mounts and #mounts:GetChildren() > 0 then
                    local mount = mounts:GetChildren()[1]
                    local part = mount.PrimaryPart or mount:FindFirstChild("HumanoidRootPart")
                    if part then
                        local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            hrp.CFrame = part.CFrame
                        end
                    end
                end
                task.wait(2)
            end
        end)
    else
        if threadEvento then
            task.cancel(threadEvento)
            threadEvento = nil
        end
    end
end)

-- Configurações
local botaoReset = Instance.new("TextButton")
botaoReset.Parent = configAba
botaoReset.Text = "Resetar Personagem"
botaoReset.Font = Enum.Font.GothamBold
botaoReset.TextSize = 18
botaoReset.TextColor3 = Color3.fromRGB(255,255,255)
botaoReset.BackgroundColor3 = Color3.fromRGB(40,40,80)
botaoReset.Size = UDim2.new(0, 220, 0, 40)
botaoReset.Position = UDim2.new(0, 30, 0, 30)
botaoReset.BackgroundTransparency = 0.1

botaoReset.MouseButton1Click:Connect(function()
    local char = game.Players.LocalPlayer.Character
    if char then
        char:BreakJoints()
    end
end)