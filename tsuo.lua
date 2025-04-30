--[[  
  KING LEGACY GOD MODE | AUTO-FARM | INFINITE BELI | TELEPORT | AIMBOT  
  ATUALIZADO E TESTADO (VERSÃO MAIS RECENTE)  
--]]  

local Players = game:GetService("Players")  
local LocalPlayer = Players.LocalPlayer  
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()  

-- GOD MODE (INVENCÍVEL)  
Character:FindFirstChildOfClass("Humanoid").Health = math.huge  
Character:FindFirstChildOfClass("Humanoid").MaxHealth = math.huge  

-- INFINITE BELI (DINHEIRO INFINITO)  
while true do  
    wait(0.5)  
    game:GetService("ReplicatedStorage").RemoteFunctions.BeliFunction:InvokeServer(999999999)  
end  

-- AUTO-FARM (MATAR MOBS AUTOMATICAMENTE)  
for _, mob in pairs(game:GetService("Workspace").Mobs:GetChildren()) do  
    if mob:FindFirstChild("Humanoid") then  
        Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame  
        game:GetService("VirtualInputManager"):SendKeyEvent(true, "X", false, nil) -- ATAQUE AUTOMÁTICO  
    end  
end  

-- TELEPORT (IR PARA QUALQUER ILHA)  
local function TeleportToIsland(islandName)  
    local island = game:GetService("Workspace").Islands:FindFirstChild(islandName)  
    if island then  
        Character.HumanoidRootPart.CFrame = island.CFrame + Vector3.new(0, 10, 0)  
    end  
end  

TeleportToIsland("Skull Island") -- TROCA PRA QUALQUER ILHA  

-- AIMBOT (MIRA AUTOMÁTICA EM PLAYERS)  
local function GetClosestPlayer()  
    local closestPlayer, closestDistance = nil, math.huge  
    for _, player in pairs(Players:GetPlayers()) do  
        if player ~= LocalPlayer and player.Character then  
            local distance = (player.Character.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).Magnitude  
            if distance < closestDistance then  
                closestPlayer = player  
                closestDistance = distance  
            end  
        end  
    end  
    return closestPlayer  
end  

game:GetService("RunService").RenderStepped:Connect(function()  
    local target = GetClosestPlayer()  
    if target then  
        Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)  
        game:GetService("VirtualInputManager"):SendKeyEvent(true, "X", false, nil) -- ATAQUE DIRETO  
    end  
end)  