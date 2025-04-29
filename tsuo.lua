-- Theus Aimbot v2.5 (Universal)
-- Made by: TheusHss
-- Discord: @theushss
-- Last update: 24/04/2025

local Players = game:GetService("Players") 
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local plr = Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = plr:GetMouse()

local gui = Instance.new("ScreenGui")
local main = Instance.new("Frame")
local corner = Instance.new("UICorner")
local title = Instance.new("TextLabel")

-- Config do script
local config = {
   aimbot = false,
   esp = false,
   fov = 100,
   team_check = true,
   wall_check = false,
   headshot = true,
   no_recoil = false,
   insta_kill = false,
   speed = false,
   inf_jump = false,
   god = false,
   walk_speed = 16,
   jump_power = 50,
   smoothness = 1,
   esp_box = true,
   esp_name = true,
   esp_dist = true,
   esp_hp = true,
   triggerbot = false,
   silent = false
}

-- GUI
gui.Parent = game.CoreGui
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

main.Parent = gui
main.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
main.Position = UDim2.new(0.8, 0, 0.3, 0)
main.Size = UDim2.new(0, 200, 0, 400)
main.Active = true
main.Draggable = true

corner.Parent = main
corner.CornerRadius = UDim.new(0, 10)

title.Parent = main
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 0, 0, 0)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Theus Aimbot"
title.TextColor3 = Color3.fromRGB(255, 100, 100)
title.TextSize = 20
title.Font = Enum.Font.GothamBold

-- Funções
local function add_button(name, pos)
   local btn = Instance.new("TextButton")
   btn.Parent = main
   btn.Position = UDim2.new(0.1, 0, pos, 0)
   btn.Size = UDim2.new(0.8, 0, 0, 25)
   btn.Text = name..": OFF"
   btn.TextColor3 = Color3.fromRGB(255, 255, 255)
   btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
   btn.Font = Enum.Font.GothamSemibold
   btn.TextSize = 14
   
   local c = Instance.new("UICorner")
   c.CornerRadius = UDim.new(0, 5)
   c.Parent = btn
   
   return btn
end

-- Botões
local btns = {
   aimbot = add_button("Aimbot", 0.1),
   silent = add_button("Silent Aim", 0.17), 
   esp = add_button("ESP", 0.24),
   no_recoil = add_button("No Recoil", 0.31),
   insta = add_button("Insta Kill", 0.38),
   speed = add_button("Speed", 0.45),
   god = add_button("God Mode", 0.52),
   trigger = add_button("Trigger", 0.59),
   walls = add_button("Wall Check", 0.66),
   jump = add_button("Inf Jump", 0.73)
}

-- Core
local function update_btn(btn, enabled)
   btn.Text = btn.Text:gsub(": .*", ": "..(enabled and "ON" or "OFF"))
   btn.BackgroundColor3 = enabled and Color3.fromRGB(60, 179, 113) or Color3.fromRGB(40, 40, 60)
end

local function get_closest()
   local closest = nil
   local max_dist = math.huge
   local mouse_pos = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)

   for _,p in pairs(Players:GetPlayers()) do
      if check_player(p) then
         local pos = camera:WorldToScreenPoint(p.Character.Head.Position)
         local dist = (Vector2.new(pos.X, pos.Y) - mouse_pos).Magnitude
         
         if dist < max_dist and dist <= config.fov then
            if not config.wall_check or can_see(p.Character.Head) then
               closest = p
               max_dist = dist
            end
         end
      end
   end
   return closest
end

local function check_player(p)
   return p ~= plr 
      and p.Character 
      and p.Character:FindFirstChild("Humanoid")
      and p.Character.Humanoid.Health > 0
      and not (config.team_check and p.Team == plr.Team)
end

local function can_see(part)
   local ray = Ray.new(camera.CFrame.Position, (part.Position - camera.CFrame.Position).Unit * 1000)
   local hit = workspace:FindPartOnRayWithIgnoreList(ray, {plr.Character})
   return hit == part
end

-- ESP
local function add_esp(p)
   local esp = Instance.new("BillboardGui")
   esp.Name = "ESP"
   esp.AlwaysOnTop = true
   esp.Size = UDim2.new(0, 200, 0, 50)
   esp.StudsOffset = Vector3.new(0, 3, 0)
   esp.Parent = p.Character.Head

   local frame = Instance.new("Frame")
   frame.Size = UDim2.new(1, 0, 1, 0)
   frame.BackgroundTransparency = 1
   frame.Parent = esp

   local name = Instance.new("TextLabel")
   name.Size = UDim2.new(1, 0, 0.3, 0)
   name.BackgroundTransparency = 1
   name.Text = p.Name
   name.TextColor3 = Color3.new(1,1,1)
   name.TextScaled = true
   name.Parent = frame

   local hp = Instance.new("TextLabel") 
   hp.Size = UDim2.new(1, 0, 0.3, 0)
   hp.Position = UDim2.new(0, 0, 0.3, 0)
   hp.BackgroundTransparency = 1
   hp.Text = "HP: "..p.Character.Humanoid.Health
   hp.TextColor3 = Color3.new(1,0,0)
   hp.TextScaled = true
   hp.Parent = frame

   local dist = Instance.new("TextLabel")
   dist.Size = UDim2.new(1, 0, 0.3, 0)
   dist.Position = UDim2.new(0, 0, 0.6, 0)
   dist.BackgroundTransparency = 1
   dist.TextColor3 = Color3.new(1,1,1)
   dist.TextScaled = true
   dist.Parent = frame

   RS.RenderStepped:Connect(function()
      if p.Character and p.Character:FindFirstChild("Humanoid") then
         local d = math.floor((p.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude)
         dist.Text = d.." studs"
         hp.Text = "HP: "..math.floor(p.Character.Humanoid.Health)
      end
   end)
end

-- Eventos
for name,btn in pairs(btns) do
   btn.MouseButton1Click:Connect(function()
      config[name] = not config[name]
      update_btn(btn, config[name])
   end)
end

-- No recoil
local mt = getrawmetatable(game)
setreadonly(mt, false)
local old_index = mt.__index
local old_namecall = mt.__namecall

mt.__index = newcclosure(function(self, k)
   if config.no_recoil then
      if k == "Recoil" or k == "Spread" then
         return 0
      end
   end
   return old_index(self, k)
end)

-- Silent aim
mt.__namecall = newcclosure(function(self, ...)
   local args = {...}
   local method = getnamecallmethod()
   
   if config.silent and (method == "FindPartOnRayWithIgnoreList" or method == "FindPartOnRay") then
      local target = get_closest()
      if target then
         args[1] = Ray.new(camera.CFrame.Position, (target.Character.Head.Position - camera.CFrame.Position).Unit * 1000)
      end
   end
   
   return old_namecall(self, unpack(args))
end)

-- Loop principal
RS.RenderStepped:Connect(function()
   if config.aimbot then
      local target = get_closest()
      if target then
         camera.CFrame = camera.CFrame:Lerp(
            CFrame.new(camera.CFrame.Position, target.Character.Head.Position),
            config.smoothness
         )
      end
   end
   
   if config.speed and plr.Character then
      plr.Character.Humanoid.WalkSpeed = config.walk_speed
   end
   
   if config.inf_jump then
      plr.Character.Humanoid.JumpPower = config.jump_power
   end
end)

-- God mode 
local function god()
   if plr.Character then
      local hum = plr.Character:FindFirstChild("Humanoid")
      if hum then
         hum.MaxHealth = math.huge
         hum.Health = math.huge
      end
   end
end

plr.CharacterAdded:Connect(function()
   if config.god then
      god()
   end
end)

-- Anti kick
local old_kick
old_kick = hookfunction(game.Players.LocalPlayer.Kick, function() 
   return nil
end)