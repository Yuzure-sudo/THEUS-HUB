local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Configurações do script
local autoFarmEnabled = true
local autoRebornEnabled = true
local activateSkillsEnabled = true

-- Função para auto-farm
function autoFarm()
    while autoFarmEnabled do
        wait(1) -- Espera 1 segundo entre as ações
        -- Lógica para coletar recursos ou derrotar inimigos
        local enemies = game.Workspace:GetChildren()
        for _, enemy in ipairs(enemies) do
            if enemy:IsA("Model") and enemy:FindFirstChild("Humanoid") then
                enemy.Humanoid:TakeDamage(100) -- Dano fixo para simplificação
                print("Derrotando inimigo: " .. enemy.Name)
            end
        end
    end
end

-- Função para auto-reborn
function autoReborn()
    while autoRebornEnabled do
        wait(10) -- Espera 10 segundos antes de renascer
        if humanoid.Health <= 0 then
            player:LoadCharacter() -- Renova o personagem
            print("Renascendo...")
        end
    end
end

-- Função para ativar habilidades
function activateSkills()
    while activateSkillsEnabled do
        wait(5) -- Espera 5 segundos entre ativações
        -- Lógica para ativar habilidades
        print("Habilidades ativadas!")
        -- Exemplo de ativação de habilidade
        -- local skill = character:FindFirstChild("SkillName")
        -- if skill then skill:Activate() end
    end
end

-- Inicia as funções
autoFarm()
autoReborn()
activateSkills()