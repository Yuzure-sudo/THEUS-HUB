-- Script Principal
local ServicoJogadores = game:GetService("Players")
local ServicoEntrada = game:GetService("UserInputService")
local ServicoExecucao = game:GetService("RunService")
local Câmera = workspace.CurrentCamera
local JogadorAtual = ServicoJogadores.LocalPlayer
local Mouse = JogadorAtual:GetMouse()

-- Círculo de FOV (Campo de Visão)
local CírculoFOV = Drawing.new("Circle")
CírculoFOV.Thickness = 2
CírculoFOV.NumSides = 100
CírculoFOV.Radius = _G.Settings.Aimbot.FOV
CírculoFOV.Filled = false
CírculoFOV.Visible = _G.Settings.Aimbot.ShowFOV
CírculoFOV.ZIndex = 999
CírculoFOV.Transparency = 1
CírculoFOV.Color = Color3.fromRGB(255, 255, 255)

-- Função para Encontrar o Jogador Mais Próximo
local function EncontrarJogadorProximo()
    local DistanciaLimite = _G.Settings.Aimbot.FOV
    local AlvoEscolhido = nil
    
    for _, jogador in pairs(ServicoJogadores:GetPlayers()) do
        if jogador ~= JogadorAtual then
            if not _G.Settings.Aimbot.TeamCheck or jogador.Team ~= JogadorAtual.Team then
                if jogador.Character and jogador.Character:FindFirstChild("Humanoid") and jogador.Character:FindFirstChild("HumanoidRootPart") and jogador.Character.Humanoid.Health > 0 then
                    local PosicaoNaTela, EstaNaTela = Câmera:WorldToScreenPoint(jogador.Character[_G.Settings.Aimbot.TargetPart].Position)
                    local Distancia = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(PosicaoNaTela.X, PosicaoNaTela.Y)).Magnitude
                    
                    if Distancia < DistanciaLimite and EstaNaTela then
                        DistanciaLimite = Distancia
                        AlvoEscolhido = jogador
                    end
                end
            end
        end
    end
    return AlvoEscolhido
end

-- Criação de ESP para Jogador
local function IniciarESP(jogador)
    local Retangulo = Drawing.new("Square")
    Retangulo.Visible = false
    Retangulo.Color = Color3.fromRGB(255, 0, 0)
    Retangulo.Thickness = 1
    Retangulo.Transparency = 1
    Retangulo.Filled = false
    
    local NomeExibido = Drawing.new("Text")
    NomeExibido.Visible = false
    NomeExibido.Color = Color3.fromRGB(255, 255, 255)
    NomeExibido.Size = 14
    NomeExibido.Center = true
    NomeExibido.Outline = true
    
    ESPContainer[jogador] = {
        Retangulo = Retangulo,
        NomeExibido = NomeExibido
    }
end

-- Atualização do ESP
local function AtualizarESPs()
    for jogador, elementos in pairs(ESPContainer) do
        if jogador.Character and jogador.Character:FindFirstChild("HumanoidRootPart") and jogador ~= JogadorAtual then
            if not _G.Settings.ESP.TeamCheck or jogador.Team ~= JogadorAtual.Team then
                local PartePrincipal = jogador.Character.HumanoidRootPart
                local PontoTela, Visível = Câmera:WorldToScreenPoint(PartePrincipal.Position)
                
                if Visível and _G.Settings.ESP.Enabled then
                    local Cabeça = jogador.Character:FindFirstChild("Head")
                    local HRP = jogador.Character.HumanoidRootPart
                    
                    local TopoTela = Câmera:WorldToScreenPoint(Cabeça.Position + Vector3.new(0, 1, 0))
                    local BaseTela = Câmera:WorldToScreenPoint(HRP.Position - Vector3.new(0, 3, 0))
                    
                    local DimensaoRetangulo = Vector2.new((TopoTela - BaseTela).Y / 2, (TopoTela - BaseTela).Y)
                    
                    elementos.Retangulo.Size = DimensaoRetangulo
                    elementos.Retangulo.Position = Vector2.new(PontoTela.X - DimensaoRetangulo.X / 2, PontoTela.Y - DimensaoRetangulo.Y / 2)
                    elementos.Retangulo.Visible = true
                    
                    elementos.NomeExibido.Position = Vector2.new(PontoTela.X, PontoTela.Y - DimensaoRetangulo.Y / 2 - 15)
                    elementos.NomeExibido.Text = jogador.Name
                    elementos.NomeExibido.Visible = true
                else
                    elementos.Retangulo.Visible = false
                    elementos.NomeExibido.Visible = false
                end
            else
                elementos.Retangulo.Visible = false
                elementos.NomeExibido.Visible = false
            end
        else
            elementos.Retangulo.Visible = false
            elementos.NomeExibido.Visible = false
        end
    end
end

-- Aimbot
local function AtivarAimbot()
    if _G.Settings.Aimbot.Enabled then
        local Alvo = EncontrarJogadorProximo()
        if Alvo and Alvo.Character then
            local PosicaoAlvo = Alvo.Character[_G.Settings.Aimbot.TargetPart].Position
            local NivelSuavidade = _G.Settings.Aimbot.Smoothness
            
            local CameraPos = Câmera.CFrame.Position
            local DestinoCFrame = CFrame.new(CameraPos, PosicaoAlvo)
            
            Câmera.CFrame = Câmera.CFrame:Lerp(DestinoCFrame, NivelSuavidade)
        end
    end
end

-- Remover Recuo
if _G.Settings.Aimbot.NoRecoil then
    local mt = getrawmetatable(game)
    local metodoOriginal = mt.__index
    setreadonly(mt, false)
    
    mt.__index = newcclosure(function(self, k)
        if k == "Recoil" or k == "CurrentRecoil" then
            return 0
        end
        return metodoOriginal(self, k)
    end)
end

-- Habilitar Tiro Rápido
if _G.Settings.Aimbot.RapidFire then
    local mt = getrawmetatable(game)
    local metodoOriginal = mt.__index
    setreadonly(mt, false)
    
    mt.__index = newcclosure(function(self, k)
        if k == "FireRate" then
            return 0.01
        end
        return metodoOriginal(self, k)
    end)
end

-- Conectar Eventos
ServicoJogadores.PlayerAdded:Connect(function(jogador)
    IniciarESP(jogador)
end)

ServicoJogadores.PlayerRemoving:Connect(function(jogador)
    if ESPContainer[jogador] then
        for _, elemento in pairs(ESPContainer[jogador]) do
            elemento:Remove()
        end
        ESPContainer[jogador] = nil
    end
end)

ServicoExecucao.RenderStepped:Connect(function()
    CírculoFOV.Position = Vector2.new(Mouse.X, Mouse.Y)
    CírculoFOV.Radius = _G.Settings.Aimbot.FOV
    CírculoFOV.Visible = _G.Settings.Aimbot.ShowFOV
    
    AtualizarESPs()
    AtivarAimbot()
end)

-- Inicializar ESPs para Jogadores Atuais
for _, jogador in pairs(ServicoJogadores:GetPlayers()) do
    if jogador ~= JogadorAtual then
        IniciarESP(jogador)
    end
end

-- Funcionalidade da Interface de Usuário
MinimizeBtn.MouseButton1Click:Connect(function()
    Container.Visible = not Container.Visible
end)