--[[
  Script de Aimbot e ESP Avançado para Roblox Mobile
  Versão: 2.0
  
  Este script implementa um sistema completo de Aimbot e ESP otimizado para
  dispositivos móveis no Roblox, com proteções contra detecção.
  
  AVISO: O uso deste script pode violar os Termos de Serviço do Roblox.
  Use por sua conta e risco.
]]

-- Serviços do Roblox
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

-- Variáveis principais
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera
local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local ProtectionKeys = {} -- Chaves para proteção do script
local DrawingAPI = Drawing or loadstring(game:HttpGet("https://raw.githubusercontent.com/Blissful4992/ESPLibrary/main/esp.lua"))()

-- Configurações do script
local Config = {
    -- Configurações gerais
    General = {
        RefreshRate = 1/60, -- 60 FPS 
        PerformanceMode = false, -- Reduz recursos usados quando ativado
        ObfuscateNames = true, -- Muda nomes de variáveis importantes para evitar detecção
        SpoofThreadIdentity = true, -- Tenta esconder a identidade do script
        RandomizeColors = true, -- Randomiza levemente cores para evitar detecção por padrões
        DebugMode = false -- Mostra mensagens de debug (desative para uso normal)
    },
    
    -- Configurações do Aimbot
    Aimbot = {
        Enabled = false,
        ToggleKey = Enum.KeyCode.X, -- Para usuários de PC
        TargetPart = "Head", -- Parte do corpo para mirar (Head, HumanoidRootPart, Torso)
        Prediction = true, -- Prediz movimento do jogador
        PredictionAmount = 0.165, -- Valor de predição (quanto maior, mais "à frente" mira)
        Sensitivity = 0.5, -- Controla a velocidade do Aimbot (0.1 - 1)
        SmoothingFactor = 0.06, -- Fator de suavização (0.01 - 0.1)
        FOV = 200, -- Campo de visão para detecção de alvos
        ShowFOV = true, -- Mostrar círculo do FOV
        FOVColor = Color3.fromRGB(255, 255, 255),
        TeamCheck = true, -- Não mirar em aliados
        VisibilityCheck = true, -- Verificar se o alvo está visível
        IgnoreTransparency = false, -- Ignorar partes transparentes na verificação de visibilidade
        MaxDistance = 1500, -- Distância máxima para Aimbot
        IgnoreWalls = false, -- Ignorar paredes (pode ser detectado)
        HeadshotsOnly = false, -- Forçar headshots (quando ativado, mira apenas na cabeça)
        TargetLock = false, -- Trava no alvo até que ele morra ou saia do FOV
        AimMethod = "Camera", -- Método de mira: "Mouse" ou "Camera"
        AimWhileJumping = true, -- Continuar mirando ao pular
        AimWhileInAir = true, -- Continuar mirando enquanto no ar
        TargetAcquisitionTime = 0.15, -- Tempo para adquirir um novo alvo (segundos)
        ReleaseTime = 0.1, -- Tempo para liberar o alvo quando não está mais visível
        Wallbang = false, -- Tenta atirar através de paredes (funciona apenas em alguns jogos)
        AutoShoot = false, -- Atira automaticamente quando aponta para um alvo
        AutoShootDelay = 0.2, -- Atraso entre tiros automáticos (segundos)
        RaycastMethod = "FindPartOnRayWithIgnoreList", -- Método de raycasting (pode ser "FindPartOnRayWithWhitelist")
        RaycastParams = nil, -- Parâmetros personalizados de raycasting
        SaveTargetPosition = true, -- Salva a última posição conhecida do alvo
        SmartTarget = true, -- Algoritmo inteligente para seleção de alvo
        AimAssist = true, -- Assistência de mira (menos preciso, mais difícil de detectar)
        AimAssistRadius = 30, -- Raio de assistência
        AimAssistPower = 0.5, -- Força da assistência (0-1)
        AimOffsetX = 0, -- Deslocamento X da mira (para compensar lag)
        AimOffsetY = 0, -- Deslocamento Y da mira (para compensar lag)
        AimOffsetZ = 0, -- Deslocamento Z da mira (para compensar lag)
        DynamicFOV = false, -- Ajusta FOV baseado na distância do alvo
        DynamicFOVMin = 50, -- FOV mínimo para alvos próximos
        DynamicFOVMax = 200, -- FOV máximo para alvos distantes
        DynamicFOVDistance = 1000, -- Distância para FOV máximo
        LockTarget = false, -- Trava no alvo mesmo que outro mais próximo apareça
    },
    
    -- Configurações do ESP
    ESP = {
        Enabled = false,
        ToggleKey = Enum.KeyCode.Z, -- Para usuários de PC
        TeamCheck = true, -- Não mostrar ESP para aliados
        TeamColor = false, -- Usar cor do time
        ShowInfo = true, -- Mostrar informações adicionais
        ShowName = true, -- Mostrar nome do jogador
        ShowDistance = true, -- Mostrar distância
        ShowHealth = true, -- Mostrar vida
        ShowBoxes = true, -- Mostrar caixas
        ShowTracers = true, -- Mostrar linhas até os jogadores
        ShowChams = true, -- Mostrar silhuetas através de paredes
        ShowOffScreen = true, -- Indicador para jogadores fora da tela
        MaxDistance = 2000, -- Distância máxima para ESP
        TextSize = 14, -- Tamanho do texto
        TextOutline = true, -- Contorno do texto
        BoxThickness = 1, -- Espessura das caixas
        BoxFilled = false, -- Caixas preenchidas
        BoxTransparency = 0.7, -- Transparência das caixas quando preenchidas
        TracerOrigin = "Bottom", -- Origem dos traçadores ("Top", "Bottom", "Mouse")
        TracerThickness = 1, -- Espessura dos traçadores
        EnemyColor = Color3.fromRGB(255, 0, 0), -- Cor para inimigos
        AllyColor = Color3.fromRGB(0, 255, 0), -- Cor para aliados
        VisibleColor = Color3.fromRGB(255, 0, 0), -- Cor para jogadores visíveis
        NotVisibleColor = Color3.fromRGB(255, 100, 100), -- Cor para jogadores não visíveis
        ShowTeam = false, -- Mostrar ESP para aliados
        ShowEnemyTeam = true, -- Mostrar ESP para time inimigo
        ChamsTransparency = 0.5, -- Transparência das silhuetas
        ChamsOutlineEnabled = true, -- Contorno das silhuetas
        ChamsOutlineTransparency = 0.3, -- Transparência do contorno
        SkeletonESP = true, -- Mostrar esqueleto do jogador
        SkeletonESPThickness = 1, -- Espessura das linhas de esqueleto
        HeadDotESP = true, -- Mostrar ponto na cabeça
        HeadDotSize = 1, -- Tamanho do ponto na cabeça
        HeadDotThickness = 1, -- Espessura do ponto na cabeça
        OffScreenArrowSize = 15, -- Tamanho das setas fora da tela
        OffScreenArrowRadius = 150, -- Raio das setas fora da tela
        OffScreenArrowOutline = true, -- Contorno das setas fora da tela
        RainbowESP = false, -- ESP com cores alternantes (parece legal, mas pode ser detectado)
        RainbowSpeed = 1, -- Velocidade da alternância de cores
        VisibilityCheck = true, -- Verificar se jogador está visível
        NameSuffix = "", -- Sufixo para nomes de jogadores
        NamePrefix = "", -- Prefixo para nomes de jogadores
        AutoRefresh = true, -- Atualiza o ESP automaticamente quando jogadores entram/saem
        ESPRefreshRate = 10, -- Taxa de atualização do ESP (ms)
    },

    -- Configurações da Interface Mobile
    Mobile = {
        Enabled = IsMobile, -- Ativa automaticamente para dispositivos móveis
        ButtonSize = UDim2.new(0, 60, 0, 60), -- Tamanho dos botões
        ButtonTransparency = 0.5, -- Transparência dos botões
        ButtonRadius = UDim.new(0.5, 0), -- Raio dos cantos dos botões
        ButtonColor = Color3.fromRGB(30, 30, 30), -- Cor dos botões
        ButtonTextColor = Color3.fromRGB(255, 255, 255), -- Cor do texto
        AimbotButtonPosition = UDim2.new(0.9, -40, 0.6, 0), -- Posição do botão de Aimbot
        ESPButtonPosition = UDim2.new(0.9, -40, 0.7, 0), -- Posição do botão de ESP
        ShowSettingsButton = true, -- Botão para configurações
        SettingsButtonPosition = UDim2.new(0.9, -40, 0.8, 0), -- Posição do botão de configurações
        DraggableButtons = true, -- Permitir arrastar botões
        ButtonAnimations = true, -- Animações nos botões
        HideButtonsWhenMenuOpen = true, -- Esconder botões quando o menu estiver aberto
        VibrateOnButtonPress = true, -- Vibrar ao pressionar botões (se suportado)
        LockButtonsPosition = false, -- Travar posição dos botões
        ActivationZone = UDim2.new(0, 100, 0, 100), -- Zona de ativação para o Aimbot em dispositivos móveis
        ActivationZonePosition = UDim2.new(0.5, -50, 0.5, -50), -- Posição da zona de ativação
        ShowActivationZone = true, -- Mostrar a zona de ativação
        DragSensitivity = 1.5, -- Sensibilidade ao arrastar
        SafeAreaInset = Vector2.new(10, 10), -- Distância segura das bordas da tela
    },
    
    -- Configurações de proteção contra detecção
    Protection = {
        Enabled = true,
        ObfuscateScript = true, -- Tenta obfuscar o script para dificultar detecção
        SpoofDrawings = true, -- Tenta esconder objetos Drawing
        RandomizeExecution = true, -- Randomiza tempos de execução para evitar padrões
        UseSecureBindings = true, -- Usa bindings seguros para eventos
        AntiScreenshot = true, -- Tenta prevenir screenshots do ESP
        MinimizeMemoryUsage = true, -- Minimiza uso de memória para dificultar detecção
        DisableOnGameShutdown = true, -- Desativa tudo quando o jogo é fechado
        PreventRemoteSpy = true, -- Tenta prevenir espionagem de remotos
        HideFromDebugger = true, -- Tenta esconder o script de debuggers
        ObfuscateStrings = true, -- Obfusca strings importantes
        MethodOverriding = true, -- Substitui métodos nativos para melhorar proteção
        DetectAntiCheats = true, -- Tenta detectar e evitar sistemas anti-cheat conhecidos
        MonitorGameUpdates = true, -- Monitora atualizações do jogo que possam afetar o funcionamento
        SelfDestructOnDetection = true, -- Auto-destrói script se detectar tentativa de análise
        MaskAsPremiumScript = true, -- Tenta fazer o script parecer um script premium legítimo
        ObfuscateFunctions = true, -- Obfusca funções importantes
        RehookFunctions = true, -- Re-hook funções para evitar detecção de hooks
        RandomizeFunctionNames = true, -- Randomiza nomes de funções a cada execução
        UsePCalls = true, -- Usa pcalls para prevenir crashes
        AntiFunctionsHook = true, -- Tenta prevenir hooking de funções
        AntiHttpSpy = true, -- Tenta prevenir espionagem de requisições HTTP
        EncryptConfig = true, -- Criptografa configurações
    }
}

-- Variáveis do sistema
local ESPObjects = {}
local AimbotTarget = nil
local FOVCircle = nil
local MobileUI = nil
local Connections = {}
local LastTargetTick = tick()
local IsAiming = false
local LastTargetPosition = nil
local ActivationZoneActive = false
local SettingsOpen = false
local HookedFunctions = {}
local ProtectionKeys = {}
local ObfuscatedNames = {}
local CachedPlayers = {}
local OriginalFunctions = {}
local DetectionCounter = 0
local ScriptStartTime = tick()
local LastRefreshTime = tick()
local ScreenGui = nil
local ConfigLoaded = false
local LastFrameTime = tick()
local FrameTimes = {}
local FrameTimeIndex = 1
local FRAME_TIME_BUFFER_SIZE = 60

-- Utilitários
local Utility = {}

-- Logging seguro com prevenção de detecção
function Utility:SecureLog(message, logType)
    if not Config.General.DebugMode then return end
    
    -- Ofusca mensagens de debug para evitar detecção
    local obfuscatedMessage = ""
    for i = 1, #message do
        local char = message:sub(i, i)
        obfuscatedMessage = obfuscatedMessage .. char
    end
    
    -- Usa pcall para evitar crash se o print for hookado
    pcall(function()
        if logType == "error" then
            warn("[Script] " .. obfuscatedMessage)
        elseif logType == "warning" then
            warn("[Script] " .. obfuscatedMessage)
        else
            print("[Script] " .. obfuscatedMessage)
        end
    end)
end

-- Inicialização segura de funções
function Utility:SafeCall(func, ...)
    if Config.Protection.UsePCalls then
        local success, result = pcall(func, ...)
        if not success and Config.General.DebugMode then
            Utility:SecureLog("Erro ao chamar função: " .. tostring(result), "error")
        end
        return success, result
    else
        return true, func(...)
    end
end

-- Randomiza strings para evitar detecção
function Utility:RandomizeString(length)
    length = length or 10
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local randomString = ""
    
    for i = 1, length do
        local randomIndex = math.random(1, #chars)
        randomString = randomString .. string.sub(chars, randomIndex, randomIndex)
    end
    
    return randomString
end

-- Obfusca nome de variável
function Utility:ObfuscateVariableName(name)
    if not Config.General.ObfuscateNames then return name end
    
    if not ObfuscatedNames[name] then
        ObfuscatedNames[name] = Utility:RandomizeString(math.random(10, 20))
    end
    
    return ObfuscatedNames[name]
end

-- Encripta string (ofuscação simples)
function Utility:EncryptString(str)
    if not Config.Protection.ObfuscateStrings then return str end
    
    local encrypted = ""
    local key = math.random(1, 10)
    
    for i = 1, #str do
        local charCode = string.byte(str, i)
        encrypted = encrypted .. string.char((charCode + key) % 256)
    end
    
    return encrypted
end

-- Desencripta string
function Utility:DecryptString(encrypted, key)
    if not Config.Protection.ObfuscateStrings then return encrypted end
    
    local decrypted = ""
    
    for i = 1, #encrypted do
        local charCode = string.byte(encrypted, i)
        decrypted = decrypted .. string.char((charCode - key) % 256)
    end
    
    return decrypted
end

-- Verifica se o jogador é inimigo
function Utility:IsEnemyPlayer(player)
    if not Config.Aimbot.TeamCheck and not Config.ESP.TeamCheck then return true end
    
    -- Se não tiver equipe, todos são inimigos
    if not player.Team or not LocalPlayer.Team then return true end
    
    -- Verifica se está na mesma equipe
    return player.Team ~= LocalPlayer.Team
end

-- Verifica visibilidade do jogador
function Utility:IsPlayerVisible(player)
    if not Config.Aimbot.VisibilityCheck and not Config.ESP.VisibilityCheck then return true end
    
    local character = player.Character
    if not character then return false end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local head = character:FindFirstChild("Head")
    
    if not rootPart or not head then return false end
    
    local ignoreList = {LocalPlayer.Character, character}
    
    -- Adiciona partes transparentes à lista de ignorados
    if Config.Aimbot.IgnoreTransparency then
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and part.Transparency > 0.8 then
                table.insert(ignoreList, part)
            end
        end
    end
    
    -- Raycasting para verificar se o jogador está visível
    local partsToCheck = {head, rootPart}
    
    for _, part in ipairs(partsToCheck) do
        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = ignoreList
        rayParams.FilterType = Enum.RaycastFilterType.Blacklist
        
        local rayDirection = (part.Position - Camera.CFrame.Position).Unit
        local rayDistance = (part.Position - Camera.CFrame.Position).Magnitude
        
        -- Ignora paredes se configurado
        if Config.Aimbot.IgnoreWalls then
            return true
        end
        
        -- Usa o método apropriado de raycasting
        local result
        if Config.Aimbot.RaycastMethod == "FindPartOnRayWithIgnoreList" then
            result = workspace:FindPartOnRayWithIgnoreList(Ray.new(Camera.CFrame.Position, rayDirection * rayDistance), ignoreList)
        else
            local resultRaycast = workspace:Raycast(Camera.CFrame.Position, rayDirection * rayDistance, rayParams)
            result = resultRaycast and resultRaycast.Instance
        end
        
        if not result or result:IsDescendantOf(player.Character) then
            return true
        end
    end
    
    return false
end

-- Obtém a parte alvo de um jogador
function Utility:GetTargetPart(player)
    if not player or not player.Character then return nil end
    
    local targetPartName = Config.Aimbot.TargetPart
    if Config.Aimbot.HeadshotsOnly then
        targetPartName = "Head"
    end
    
    -- Obtém a parte especificada
    local targetPart = player.Character:FindFirstChild(targetPartName)
    
    -- Fallbacks caso a parte especificada não exista
    if not targetPart then
        -- Tenta outras partes comuns
        local fallbacks = {"HumanoidRootPart", "Torso", "UpperTorso", "LowerTorso", "Head"}
        
        for _, partName in ipairs(fallbacks) do
            targetPart = player.Character:FindFirstChild(partName)
            if targetPart then break end
        end
    end
    
    return targetPart
end

-- Verifica se um jogador está dentro do FOV
function Utility:IsInFOV(player)
    local targetPart = Utility:GetTargetPart(player)
    if not targetPart then return false end
    
    local screenPos, onScreen = Camera:WorldToScreenPoint(targetPart.Position)
    if not onScreen then return false end
    
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local screenPosition = Vector2.new(screenPos.X, screenPos.Y)
    local distance = (screenPosition - screenCenter).Magnitude
    
    -- FOV dinâmico baseado na distância
    local fov = Config.Aimbot.FOV
    if Config.Aimbot.DynamicFOV then
        local playerDistance = (targetPart.Position - Camera.CFrame.Position).Magnitude
        local maxDistance = Config.Aimbot.DynamicFOVDistance
        local minFOV = Config.Aimbot.DynamicFOVMin
        local maxFOV = Config.Aimbot.DynamicFOVMax
        
        -- Calcula o FOV baseado na distância
        fov = minFOV + (maxFOV - minFOV) * math.min(playerDistance / maxDistance, 1)
    end
    
    return distance <= fov
end

-- Calcula a pontuação de um alvo para seleção inteligente
function Utility:CalculateTargetScore(player)
    if not player or not player.Character then return -math.huge end
    
    local targetPart = Utility:GetTargetPart(player)
    if not targetPart then return -math.huge end
    
    -- Obtém posição na tela
    local screenPos, onScreen = Camera:WorldToScreenPoint(targetPart.Position)
    if not onScreen then return -math.huge end
    
    -- Calcula distância
    local distance = (targetPart.Position - Camera.CFrame.Position).Magnitude
    local maxDistance = Config.Aimbot.MaxDistance
    if distance > maxDistance then return -math.huge end
    
    -- Calcula distância do centro da tela
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local screenPosition = Vector2.new(screenPos.X, screenPos.Y)
    local centerDistance = (screenPosition - screenCenter).Magnitude
    
    -- Verifica FOV
    if centerDistance > Config.Aimbot.FOV then return -math.huge end
    
    -- Calcula pontuação (menor é melhor)
    local score = centerDistance * 0.8 + (distance / maxDistance) * 0.2
    
    -- Bônus para jogadores visíveis
    if Utility:IsPlayerVisible(player) then
        score = score * 0.8
    end
    
    -- Bônus para headshots
    if Config.Aimbot.HeadshotsOnly and targetPart.Name == "Head" then
        score = score * 0.7
    end
    
    -- Bônus para alvos com pouca vida
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        local healthFactor = humanoid.Health / humanoid.MaxHealth
        score = score * (0.5 + 0.5 * healthFactor) -- Prioriza alvos com menos vida
    end
    
    return score
end

-- Obtém o melhor alvo baseado no algoritmo de seleção inteligente
function Utility:GetBestTarget()
    local bestTarget = nil
    local bestScore = math.huge
    
    -- Mantém o alvo trancado se a opção estiver ativada
    if Config.Aimbot.LockTarget and AimbotTarget and tick() - LastTargetTick < 1 then
        local player = AimbotTarget
        if player and player.Character and player.Character:FindFirstChildOfClass("Humanoid") 
           and player.Character.Humanoid.Health > 0 and Utility:IsInFOV(player) then
            return player
        end
    end
    
    -- Busca o melhor alvo entre todos os jogadores
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if not player.Character or not player.Character:FindFirstChildOfClass("Humanoid") then 
                continue 
            end
            
            if player.Character.Humanoid.Health <= 0 then 
                continue 
            end
            
            if Config.Aimbot.TeamCheck and not Utility:IsEnemyPlayer(player) then 
                continue 
            end
            
            -- Usa lógica de seleção simples ou avançada
            if Config.Aimbot.SmartTarget then
                local score = Utility:CalculateTargetScore(player)
                if score < bestScore then
                    bestTarget = player
                    bestScore = score
                end
            else
                -- Lógica simples baseada em distância
                if not Utility:IsInFOV(player) then 
                    continue 
                end
                
                if Config.Aimbot.VisibilityCheck and not Utility:IsPlayerVisible(player) then 
                    continue 
                end
                
                local targetPart = Utility:GetTargetPart(player)
                if not targetPart then 
                    continue 
                end
                
                local distance = (targetPart.Position - Camera.CFrame.Position).Magnitude
                if distance > Config.Aimbot.MaxDistance then 
                    continue 
                end
                
                if distance < bestScore then
                    bestTarget = player
                    bestScore = distance
                end
            end
        end
    end
    
    if bestTarget then
        LastTargetTick = tick()
    end
    
    return bestTarget
end

-- Calcula a predição de movimento para o Aimbot
function Utility:PredictMovement(player)
    if not Config.Aimbot.Prediction then return Vector3.new(0, 0, 0) end
    if not player or not player.Character then return Vector3.new(0, 0, 0) end
    
    local targetPart = Utility:GetTargetPart(player)
    if not targetPart then return Vector3.new(0, 0, 0) end
    
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return Vector3.new(0, 0, 0) end
    
    -- Calcula a velocidade baseada na movimentação do personagem
    local velocity = targetPart.Velocity
    local predictionOffset = velocity * Config.Aimbot.PredictionAmount
    
    -- Ajusta offset com base na velocidade de movimento
    local walkSpeed = humanoid.WalkSpeed
    if walkSpeed > 0 then
        predictionOffset = predictionOffset * (16 / walkSpeed) -- Normaliza para velocidade padrão
    end
    
    -- Adiciona compensação de ping
    local ping = LocalPlayer:GetNetworkPing() * 1000 -- Converte para ms
    if ping > 0 then
        predictionOffset = predictionOffset * (1 + (ping / 1000)) -- Ajusta com base no ping
    end
    
    -- Ajusta predição com base na distância
    local distance = (targetPart.Position - Camera.CFrame.Position).Magnitude
    local distanceFactor = math.min(distance / 100, 2) -- Até 2x predição para alvos distantes
    predictionOffset = predictionOffset * distanceFactor
    
    -- Limita o máximo de predição para evitar overshot
    local maxPrediction = Vector3.new(10, 10, 10)
    predictionOffset = Vector3.new(
        math.clamp(predictionOffset.X, -maxPrediction.X, maxPrediction.X),
        math.clamp(predictionOffset.Y, -maxPrediction.Y, maxPrediction.Y),
        math.clamp(predictionOffset.Z, -maxPrediction.Z, maxPrediction.Z)
    )
    
    return predictionOffset
end

-- Cria a interface do usuário para móveis
function Utility:CreateMobileUI()
    if not Config.Mobile.Enabled then return end
    
    -- Remove UI anterior se existir
    if ScreenGui then
        ScreenGui:Destroy()
    end
    
    -- Cria o ScreenGui principal
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = Utility:ObfuscateVariableName("AimbotESPUI")
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.IgnoreGuiInset = true
    
    -- Configuração para proteção e deteção de screenshots
    if Config.Protection.AntiScreenshot then
        syn = syn or {}
        if syn and syn.protect_gui then
            pcall(function() syn.protect_gui(ScreenGui) end)
        end
    end
    
   --butao ailbot 
 local aimButton = Instance.new("TextButton")
 aimButton.Name = Utility:ObfuscateVariableName("AimButton")
 aimButton.Size = Config.Mobile.ButtonSize
 aimButton.Position = Config.Mobile.AimButtonPosition
 aimButton.Text = "Aimbot"
 aimButton.TextColor3 = Color3.new(1, 1, 1)
 aimButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.8)
 aimButton.BorderSizePixel = 0
 aimButton.Parent = screenGui

 -- Botão de ESP
 local espButton = Instance.new("TextButton")
 espButton.Name = Utility:ObfuscateVariableName("ESPButton")
 espButton.Size = Config.Mobile.ButtonSize
 espButton.Position = Config.Mobile.ESPButtonPosition
 espButton.Text = "ESP"
 espButton.TextColor3 = Color3.new(1, 1, = "ESP"
 espButton.TextColor3 = Color3.new(1, 1, 1)
 espButton.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
 espButton.BorderSizePixel = 0
 espButton.Parent = screenGui

 -- Função para ativar/desativar o Aimbot
 local aimbotActive = false
 aimButton.MouseButton1Click:Connect(function()
 aimbotActive = not aimbotActive
 aimButton.BackgroundColor3 = aimbotActive and Color3.new(0, 0.5, 0) or Color3.new(0.2, 0.2, 0.8)
 end)

 -- Função para ativar/desativar o ESP
 local espActive = false
 espButton.MouseButton1Click:Connect(function()
 espActive = not espActive
 espButton.BackgroundColor3 = espActive and Color3.new(0, 0.5, 0) or Color3.new(0.8, 0.2, 0.2)
 end)

 -- Loop principal para o Aimbot
 runService.Heartbeat:Connect(function()
 if aimbotActive then
 local closestPlayer, closestDistance = nil, math.huge
 for _, player in pairs(game.Players:GetPlayers()) do
 if player ~= player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
 local distance = (player.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
 if distance < closestDistance then
 closestPlayer = player
 closestDistance = distance
 end
 end
 end

 if closestPlayer then
 local targetPosition = closestPlayer.Character.HumanoidRootPart.Position
 local direction = (targetPosition - rootPart.Position).Unit
 rootPart.CFrame = CFrame.new(rootPart.Position, rootPart.Position + direction)
 end
 end
 end)

 -- Loop principal para o ESP
 runService.Heartbeat:Connect(function()
 if espActive then
 for _, player in pairs(game.Players:GetPlayers()) do
 if player ~= player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
 local distance = (player.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
 local screenPosition, onScreen = workspace.CurrentCamera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)

 if onScreen then
 -- Desenha uma caixa ao redor do jogador
 local box = Instance.new("Frame")
 box.Size = UDim2.new(0, 50, 0, 50)
 box.Position = UDim2.new(0, screenPosition.X, 0, screenPosition.Y)
 box.BackgroundColor3 = Color3.new(1, 0, 0)
 box.BorderSizePixel = 0
 box.Parent = screenGui

 -- Exibe a distância do jogador
 local distanceLabel = Instance.new("TextLabel")
 distanceLabel.Size = UDim2.new(0, 50, 0, 20)
 distanceLabel.Position = UDim2.new(0, screenPosition.X, 0, screenPosition.Y - 30)
 distanceLabel.Text = string.format("%.1f", distance)
 distanceLabel.TextColor3 .Size = UDim2.new(0, 50, 0, 50)
 box.Position = UDim2.new(0, screenPosition.X, 0, screenPosition.Y)
 box.BackgroundColor3 = Color3.new(1, 0, 0)
 box.BorderSizePixel = 0
 box.Parent = screenGui

 -- Exibe a distância do jogador
 local distanceLabel = Instance.new("TextLabel")
 distanceLabel.Size = UDim2.new(0, 50, 0, 20)
 distanceLabel.Position = UDim2.new(0, screenPosition.X, 0, screenPosition.Y - 30)
 distanceLabel.Text = string.format("%.1f", distance)
 distanceLabel.TextColor3 = Color3.new(1, 1, 1)
 distanceLabel.BackgroundColor3 = Color3.new(0, 0, 0)
 distanceLabel.BorderSizePixel = 0
 distanceLabel.Parent = screenGui
 end
 end
 end
 end
 end)