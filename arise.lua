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

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Três_Moskitero"
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
titulo.Text = "Três Moskitero"
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

local minimizado = false
minimizar.MouseButton1Click:Connect(function()
    minimizado = not minimizado
    TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
        Size = minimizado and UDim2.new(0, 120, 0, 54) or UDim2.new(0, 700, 0, 420)
    }):Play()
end)

-- Menu principal
local saudacao = Instance.new("TextLabel")
saudacao.Parent = menuAba
saudacao.Text = "Bem-vindo ao Três Moskitero!"
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

-- Botão para ativar/desativar AutoFarm Global
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


