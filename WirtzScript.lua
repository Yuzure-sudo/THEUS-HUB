-- // Wirtz Script | Powered by Rayfield
-- // Made with love by @wirtz.dev

-- // Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- // Check if Rayfield exists
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

-- // Anti-detection measures
for i,v in next, getconnections(game:GetService("Players").LocalPlayer.Idled) do
    v:Disable()
end

-- // Configuration
local Config = {
    ESP = {
        Enabled = false,
        TeamCheck = true,
        ShowBox = true,
        ShowInfo = true,
        MaxDistance = 2000,
        BoxColor = Color3.fromRGB(255, 0, 0),
        BoxThickness = 1,
        TextColor = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        TextOutline = true
    },
    Aimbot = {
        Enabled = false,
        TeamCheck = true,
        TargetPart = "Head",
        Sensitivity = 1,
        FOV = 100,
        ShowFOV = true,
        FOVColor = Color3.fromRGB(255, 255, 255),
        Prediction = true,
        AutoShoot = false
    },
    Fly = {
        Enabled = false,
        Speed = 80,
        VerticalSpeed = 70
    }
}

-- // Utilities
local Utilities = {}

-- Check if player exists and is valid
function Utilities:ValidatePlayer(player)
    return player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") 
           and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0
end

-- Calculate distance between two points
function Utilities:CalculateDistance(point1, point2)
    return (point1 - point2).Magnitude
end

-- Check if a player is behind a wall
function Utilities:IsVisible(targetPos)
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
    
    local direction = targetPos - Camera.CFrame.Position
    local result = workspace:Raycast(Camera.CFrame.Position, direction.Unit * math.min(direction.Magnitude, 1000), rayParams)
    
    return result == nil
end

-- // ESP System
local ESPManager = {
    Objects = {},
    DrawingObjects = {},
    Enabled = false
}

-- Create ESP for a player
function ESPManager:CreateESP(player)
    if player == LocalPlayer then return end
    
    -- Create ESP Objects
    local objects = {}
    
    -- Try to use Drawing API (more efficient if available)
    local success, error = pcall(function()
        if Drawing then
            -- Box
            local box = Drawing.new("Square")
            box.Visible = false
            box.Color = Config.ESP.BoxColor
            box.Thickness = Config.ESP.BoxThickness
            box.Transparency = 1
            box.Filled = false
            
            -- Name text
            local name = Drawing.new("Text")
            name.Visible = false
            name.Center = true
            name.Outline = Config.ESP.TextOutline
            name.Font = 2
            name.Size = Config.ESP.TextSize
            name.Color = Config.ESP.TextColor
            name.Text = player.Name
            
            -- Health text
            local health = Drawing.new("Text")
            health.Visible = false
            health.Center = true
            health.Outline = Config.ESP.TextOutline
            health.Font = 2
            health.Size = Config.ESP.TextSize
            health.Color = Config.ESP.TextColor
            health.Text = "100 HP"
            
            -- Distance text
            local distance = Drawing.new("Text")
            distance.Visible = false
            distance.Center = true
            distance.Outline = Config.ESP.TextOutline
            distance.Font = 2
            distance.Size = Config.ESP.TextSize
            distance.Color = Config.ESP.TextColor
            distance.Text = "0m"
            
            self.DrawingObjects[player.Name] = {
                Box = box,
                Name = name,
                Health = health,
                Distance = distance
            }
            
            return true -- Drawing API available
        end
        return false -- Drawing API not available
    end)
    
    -- Fallback to BillboardGui if Drawing API is not available
    if not success or not error then
        -- ESP container
        local esp = Instance.new("BillboardGui")
        esp.Name = "ESP"
        esp.AlwaysOnTop = true
        esp.Size = UDim2.new(4, 0, 5.5, 0)
        esp.StudsOffset = Vector3.new(0, 0.5, 0)
        esp.Adornee = player.Character.HumanoidRootPart
        
        -- Frame for ESP
        local frame = Instance.new("Frame")
        frame.BackgroundColor3 = Config.ESP.BoxColor
        frame.BackgroundTransparency = 0.5
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BorderSizePixel = 0
        frame.Parent = esp
        
        -- Player name
        local name = Instance.new("TextLabel")
        name.Size = UDim2.new(1, 0, 0.25, 0)
        name.Position = UDim2.new(0, 0, -0.25, 0)
        name.BackgroundTransparency = 1
        name.Text = player.Name
        name.TextColor3 = Config.ESP.TextColor
        name.TextSize = Config.ESP.TextSize
        name.Font = Enum.Font.SourceSansBold
        name.Parent = esp
        
        -- Health text
        local health = Instance.new("TextLabel")
        health.Size = UDim2.new(1, 0, 0.2, 0)
        health.Position = UDim2.new(0, 0, 1, 0)
        health.BackgroundTransparency = 1
        health.Text = "100 HP"
        health.TextColor3 = Color3.fromRGB(0, 255, 0)
        health.TextSize = Config.ESP.TextSize
        health.Font = Enum.Font.SourceSansBold
        health.Parent = esp
        
        -- Distance text
        local distance = Instance.new("TextLabel")
        distance.Size = UDim2.new(1, 0, 0.2, 0)
        distance.Position = UDim2.new(0, 0, 1.2, 0)
        distance.BackgroundTransparency = 1
        distance.Text = "0m"
        distance.TextColor3 = Config.ESP.TextColor
        distance.TextSize = Config.ESP.TextSize
        distance.Font = Enum.Font.SourceSansBold
        distance.Parent = esp
        
        objects.ESP = esp
        objects.Frame = frame
        objects.Name = name
        objects.Health = health
        objects.Distance = distance
        
        esp.Parent = game.CoreGui
    end
    
    self.Objects[player.Name] = objects
end

-- Update ESP visuals
function ESPManager:UpdateESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            -- Check if ESP objects exist
            local objects = self.Objects[player.Name]
            local drawingObjects = self.DrawingObjects[player.Name]
            
            if (objects or drawingObjects) and Utilities:ValidatePlayer(player) then
                -- Team check
                if Config.ESP.TeamCheck and player.Team == LocalPlayer.Team then
                    self:HideESP(player.Name)
                    continue
                end
                
                -- Check if ESP should be visible
                local character = player.Character
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                local hrp = character.HumanoidRootPart
                
                -- Calculate distance
                local distance = Utilities:CalculateDistance(Camera.CFrame.Position, hrp.Position)
                
                -- Distance check
                if distance > Config.ESP.MaxDistance then
                    self:HideESP(player.Name)
                    continue
                end
                
                -- Update Drawing API objects
                if drawingObjects then
                    local vector, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                    
                    if onScreen then
                        -- Calculate box size based on distance
                        local size = 5000 / distance
                        local boxSize = Vector2.new(size, size * 1.5)
                        local boxPosition = Vector2.new(vector.X - size / 2, vector.Y - size / 2)
                        
                        -- Update box
                        drawingObjects.Box.Size = boxSize
                        drawingObjects.Box.Position = boxPosition
                        drawingObjects.Box.Visible = Config.ESP.ShowBox and self.Enabled
                        
                        -- Update name
                        drawingObjects.Name.Position = Vector2.new(vector.X, boxPosition.Y - 16)
                        drawingObjects.Name.Visible = Config.ESP.ShowInfo and self.Enabled
                        
                        -- Update health
                        drawingObjects.Health.Text = math.floor(humanoid.Health) .. " HP"
                        drawingObjects.Health.Position = Vector2.new(vector.X, boxPosition.Y + boxSize.Y + 2)
                        drawingObjects.Health.Color = Color3.fromRGB(
                            255 * (1 - humanoid.Health / humanoid.MaxHealth),
                            255 * (humanoid.Health / humanoid.MaxHealth),
                            0
                        )
                        drawingObjects.Health.Visible = Config.ESP.ShowInfo and self.Enabled
                        
                        -- Update distance
                        drawingObjects.Distance.Text = math.floor(distance) .. "m"
                        drawingObjects.Distance.Position = Vector2.new(vector.X, boxPosition.Y + boxSize.Y + 18)
                        drawingObjects.Distance.Visible = Config.ESP.ShowInfo and self.Enabled
                    else
                        -- Hide ESP if off screen
                        drawingObjects.Box.Visible = false
                        drawingObjects.Name.Visible = false
                        drawingObjects.Health.Visible = false
                        drawingObjects.Distance.Visible = false
                    end
                elseif objects then
                    -- Update instance-based ESP
                    objects.ESP.Adornee = hrp
                    objects.ESP.Enabled = self.Enabled
                    
                    -- Update health
                    objects.Health.Text = math.floor(humanoid.Health) .. " HP"
                    objects.Health.TextColor3 = Color3.fromRGB(
                        255 * (1 - humanoid.Health / humanoid.MaxHealth),
                        255 * (humanoid.Health / humanoid.MaxHealth),
                        0
                    )
                    
                    -- Update distance
                    objects.Distance.Text = math.floor(distance) .. "m"
                    
                    -- Update visibility
                    objects.Frame.Visible = Config.ESP.ShowBox
                    objects.Name.Visible = Config.ESP.ShowInfo
                    objects.Health.Visible = Config.ESP.ShowInfo
                    objects.Distance.Visible = Config.ESP.ShowInfo
                end
            else
                -- Player is invalid, hide ESP
                self:HideESP(player.Name)
            end
        end
    end
end

-- Hide ESP for a player
function ESPManager:HideESP(playerName)
    local objects = self.Objects[playerName]
    local drawingObjects = self.DrawingObjects[playerName]
    
    if objects and objects.ESP then
        objects.ESP.Enabled = false
    end
    
    if drawingObjects then
        drawingObjects.Box.Visible = false
        drawingObjects.Name.Visible = false
        drawingObjects.Health.Visible = false
        drawingObjects.Distance.Visible = false
    end
end

-- Clean up ESP objects for a player
function ESPManager:RemoveESP(player)
    local objects = self.Objects[player.Name]
    local drawingObjects = self.DrawingObjects[player.Name]
    
    if objects then
        for _, object in pairs(objects) do
            if typeof(object) == "Instance" then
                object:Destroy()
            end
        end
        self.Objects[player.Name] = nil
    end
    
    if drawingObjects then
        for _, object in pairs(drawingObjects) do
            pcall(function() object:Remove() end)
        end
        self.DrawingObjects[player.Name] = nil
    end
end

-- Enable ESP
function ESPManager:Enable()
    self.Enabled = true
    
    -- Create ESP for existing players
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and not self.Objects[player.Name] and not self.DrawingObjects[player.Name] then
            self:CreateESP(player)
        end
    end
    
    -- Update ESP
    if not self.RenderConnection then
        self.RenderConnection = RunService.RenderStepped:Connect(function()
            self:UpdateESP()
        end)
    end
end

-- Disable ESP
function ESPManager:Disable()
    self.Enabled = false
    
    -- Hide all ESP objects
    for playerName, _ in pairs(self.Objects) do
        self:HideESP(playerName)
    end
    
    for playerName, _ in pairs(self.DrawingObjects) do
        self:HideESP(playerName)
    end
    
    -- Disconnect render connection
    if self.RenderConnection then
        self.RenderConnection:Disconnect()
        self.RenderConnection = nil
    end
end

-- Clean up all ESP objects
function ESPManager:CleanUp()
    for playerName, _ in pairs(self.Objects) do
        local player = Players:FindFirstChild(playerName)
        if player then
            self:RemoveESP(player)
        end
    end
    
    for playerName, _ in pairs(self.DrawingObjects) do
        local player = Players:FindFirstChild(playerName)
        if player then
            self:RemoveESP(player)
        end
    end
    
    -- Disconnect render connection
    if self.RenderConnection then
        self.RenderConnection:Disconnect()
        self.RenderConnection = nil
    end
end

-- // Aimbot System
local AimbotManager = {
    Enabled = false,
    Aiming = false,
    Target = nil,
    FOVCircle = nil
}

-- Create FOV circle
function AimbotManager:CreateFOVCircle()
    pcall(function()
        if Drawing then
            self.FOVCircle = Drawing.new("Circle")
            self.FOVCircle.Visible = Config.Aimbot.ShowFOV and self.Enabled
            self.FOVCircle.Color = Config.Aimbot.FOVColor
            self.FOVCircle.Thickness = 1
            self.FOVCircle.NumSides = 60
            self.FOVCircle.Radius = Config.Aimbot.FOV
            self.FOVCircle.Filled = false
            self.FOVCircle.Transparency = 1
        end
    end)
end

-- Update FOV circle
function AimbotManager:UpdateFOVCircle()
    if self.FOVCircle then
        self.FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        self.FOVCircle.Radius = Config.Aimbot.FOV
        self.FOVCircle.Visible = Config.Aimbot.ShowFOV and self.Enabled
    end
end

-- Get closest player for aimbot
function AimbotManager:GetClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = Config.Aimbot.FOV
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            -- Team check
            if Config.Aimbot.TeamCheck and player.Team == LocalPlayer.Team then
                continue
            end
            
            if Utilities:ValidatePlayer(player) then
                local character = player.Character
                local targetPart = character:FindFirstChild(Config.Aimbot.TargetPart)
                
                if targetPart then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                    
                    if onScreen then
                        local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)).Magnitude
                        
                        if distance < shortestDistance then
                            -- Visibility check (optional)
                            if Utilities:IsVisible(targetPart.Position) then
                                closestPlayer = player
                                shortestDistance = distance
                            end
                        end
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

-- Predict target position
function AimbotManager:PredictTargetPosition(target)
    if not Utilities:ValidatePlayer(target) then return nil end
    
    local targetPart = target.Character:FindFirstChild(Config.Aimbot.TargetPart)
    if not targetPart then return nil end
    
    -- Simple prediction based on humanoid velocity
    if Config.Aimbot.Prediction then
        local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.MoveDirection.Magnitude > 0 then
            return targetPart.Position + (humanoid.MoveDirection * 0.2)
        end
    end
    
    return targetPart.Position
end

-- Aim at target
function AimbotManager:AimAtTarget(target)
    if not target or not Utilities:ValidatePlayer(target) then return end
    
    local predictedPosition = self:PredictTargetPosition(target)
    if not predictedPosition then return end
    
    -- Calculate aim direction
    local cameraPosition = Camera.CFrame.Position
    local aimDirection = (predictedPosition - cameraPosition).Unit
    
    -- Create new camera CFrame
    local newCameraCFrame = CFrame.new(cameraPosition, cameraPosition + aimDirection)
    
    -- Smooth aim using sensitivity
    Camera.CFrame = Camera.CFrame:Lerp(newCameraCFrame, Config.Aimbot.Sensitivity)
    
    -- Auto shoot logic (if enabled)
    if Config.Aimbot.AutoShoot then
        -- This uses built-in mouse functions, might need adaptation for specific games
        -- Most executor-level trigger bots work better than this though
        pcall(function() 
            mouse1press()
            task.wait(0.1)
            mouse1release()
        end)
    end
end

-- Enable aimbot
function AimbotManager:Enable()
    self.Enabled = true
    
    -- Create FOV circle if needed
    if not self.FOVCircle then
        self:CreateFOVCircle()
    end
    
    -- Toggle aiming based on input
    if not self.InputBeganConnection then
        self.InputBeganConnection = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.Touch then
                self.Aiming = true
            end
        end)
    end
    
    if not self.InputEndedConnection then
        self.InputEndedConnection = UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.Touch then
                self.Aiming = false
            end
        end)
    end
    
    -- Update aimbot
    if not self.RenderConnection then
        self.RenderConnection = RunService.RenderStepped:Connect(function()
            self:UpdateFOVCircle()
            
            if self.Enabled and self.Aiming then
                self.Target = self:GetClosestPlayer()
                if self.Target then
                    self:AimAtTarget(self.Target)
                end
            end
        end)
    end
end

-- Disable aimbot
function AimbotManager:Disable()
    self.Enabled = false
    self.Aiming = false
    self.Target = nil
    
    -- Hide FOV circle
    if self.FOVCircle then
        self.FOVCircle.Visible = false
    end
    
    -- Disconnect events
    if self.InputBeganConnection then
        self.InputBeganConnection:Disconnect()
        self.InputBeganConnection = nil
    end
    
    if self.InputEndedConnection then
        self.InputEndedConnection:Disconnect()
        self.InputEndedConnection = nil
    end
    
    if self.RenderConnection then
        self.RenderConnection:Disconnect()
        self.RenderConnection = nil
    end
end

-- Clean up aimbot resources
function AimbotManager:CleanUp()
    self:Disable()
    
    if self.FOVCircle then
        pcall(function() self.FOVCircle:Remove() end)
        self.FOVCircle = nil
    end
end

-- // Fly System
local FlyManager = {
    Enabled = false,
    Gyro = nil,
    Velocity = nil,
    FlyControls = nil
}

-- Create fly controls (mobile-friendly)
function FlyManager:CreateFlyControls()
    if self.FlyControls then return end
    
    -- Create container
    self.FlyControls = Instance.new("ScreenGui")
    self.FlyControls.Name = "FlyControls"
    self.FlyControls.Enabled = false
    self.FlyControls.ResetOnSpawn = false
    
    -- Up button
    local upButton = Instance.new("TextButton")
    upButton.Name = "UpButton"
    upButton.Size = UDim2.new(0, 100, 0, 100)
    upButton.Position = UDim2.new(0, 10, 0.5, -110)
    upButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    upButton.BorderSizePixel = 0
    upButton.Text = "↑"
    upButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    upButton.TextSize = 30
    upButton.Font = Enum.Font.GothamBold
    upButton.Parent = self.FlyControls
    
    -- Corner for up button
    local upCorner = Instance.new("UICorner")
    upCorner.CornerRadius = UDim.new(0, 10)
    upCorner.Parent = upButton
    
    -- Down button
    local downButton = Instance.new("TextButton")
    downButton.Name = "DownButton"
    downButton.Size = UDim2.new(0, 100, 0, 100)
    downButton.Position = UDim2.new(0, 10, 0.5, 10)
    downButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    downButton.BorderSizePixel = 0
    downButton.Text = "↓"
    downButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    downButton.TextSize = 30
    downButton.Font = Enum.Font.GothamBold
    downButton.Parent = self.FlyControls
    
    -- Corner for down button
    local downCorner = Instance.new("UICorner")
    downCorner.CornerRadius = UDim.new(0, 10)
    downCorner.Parent = downButton
    
    -- Button states
    self.UpPressed = false
    self.DownPressed = false
    
    -- Connect button events
    upButton.MouseButton1Down:Connect(function()
        self.UpPressed = true
    end)
    
    upButton.MouseButton1Up:Connect(function()
        self.UpPressed = false
    end)
    
    downButton.MouseButton1Down:Connect(function()
        self.DownPressed = true
    end)
    
    downButton.MouseButton1Up:Connect(function()
        self.DownPressed = false
    end)
    
    -- Parent to GUI
    pcall(function()
        self.FlyControls.Parent = game.CoreGui
    end)
    
    if not self.FlyControls.Parent then
        self.FlyControls.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
end

-- Enable fly
function FlyManager:Enable()
    self.Enabled = true
    
    -- Create controls if needed
    self:CreateFlyControls()
    
    -- Show controls
    if self.FlyControls then
        self.FlyControls.Enabled = true
    end
    
    -- Apply fly
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    
    -- Create gyro for orientation
    self.Gyro = Instance.new("BodyGyro")
    self.Gyro.D = 0
    self.Gyro.P = 9e4
    self.Gyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    self.Gyro.Parent = hrp
    
    -- Create velocity for movement
    self.Velocity = Instance.new("BodyVelocity")
    self.Velocity.Velocity = Vector3.new(0, 0.1, 0)
    self.Velocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    self.Velocity.Parent = hrp
    
    -- Update fly loop
    if not self.UpdateConnection then
        self.UpdateConnection = RunService.RenderStepped:Connect(function()
            if not self.Enabled then return end
            
            local character = LocalPlayer.Character
            if not character or not character:FindFirstChild("HumanoidRootPart") then
                self:Disable()
                return
            end
            
            local hrp = character:FindFirstChild("HumanoidRootPart")
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            
            -- Update gyro direction
            self.Gyro.CFrame = CFrame.new(hrp.Position, hrp.Position + Camera.CFrame.LookVector)
            
            -- Calculate vertical speed
            local verticalSpeed = 0
            if self.UpPressed then
                verticalSpeed = Config.Fly.VerticalSpeed
            elseif self.DownPressed then
                verticalSpeed = -Config.Fly.VerticalSpeed
            end
            
            -- Update velocity
            self.Velocity.Velocity = Vector3.new(
                humanoid.MoveDirection.X * Config.Fly.Speed,
                verticalSpeed,
                humanoid.MoveDirection.Z * Config.Fly.Speed
            )
        end)
    end
end

-- Disable fly
function FlyManager:Disable()
    self.Enabled = false
    
    -- Hide controls
    if self.FlyControls then
        self.FlyControls.Enabled = false
    end
    
    -- Clean up physics objects
    if self.Gyro then
        self.Gyro:Destroy()
        self.Gyro = nil
    end
    
    if self.Velocity then
        self.Velocity:Destroy()
        self.Velocity = nil
    end
    
    -- Disconnect update loop
    if self.UpdateConnection then
        self.UpdateConnection:Disconnect()
        self.UpdateConnection = nil
    end
end

-- Clean up fly resources
function FlyManager:CleanUp()
    self:Disable()
    
    if self.FlyControls then
        self.FlyControls:Destroy()
        self.FlyControls = nil
    end
end

-- // Create Rayfield Interface
local Window = Rayfield:CreateWindow({
    Name = "Wirtz Script",
    LoadingTitle = "Wirtz Script",
    LoadingSubtitle = "by @wirtz.dev",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "WirtzConfigs",
        FileName = "WirtzScriptConfig"
    },
    KeySystem = false -- Set to true if you want to use a key system
})

-- // ESP Tab
local ESPTab = Window:CreateTab("ESP", 9734460825) -- Using an ID for ESP icon

-- ESP Toggle
ESPTab:CreateToggle({
    Name = "ESP Master",
    CurrentValue = false,
    Flag = "ESP_Enabled",
    Callback = function(Value)
        Config.ESP.Enabled = Value
        
        if Value then
            ESPManager:Enable()
        else
            ESPManager:Disable()
        end
    end
})

-- ESP Team Check
ESPTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = true,
    Flag = "ESP_TeamCheck",
    Callback = function(Value)
        Config.ESP.TeamCheck = Value
    end
})

-- ESP Show Box
ESPTab:CreateToggle({
    Name = "Show Boxes",
    CurrentValue = true,
    Flag = "ESP_ShowBox",
    Callback = function(Value)
        Config.ESP.ShowBox = Value
    end
})

-- ESP Show Info
ESPTab:CreateToggle({
    Name = "Show Info (Health, Distance)",
    CurrentValue = true,
    Flag = "ESP_ShowInfo",
    Callback = function(Value)
        Config.ESP.ShowInfo = Value
    end
})

-- ESP Distance
ESPTab:CreateSlider({
    Name = "Max Distance",
    Range = {100, 5000},
    Increment = 100,
    CurrentValue = 2000,
    Flag = "ESP_MaxDistance",
    Callback = function(Value)
        Config.ESP.MaxDistance = Value
    end
})

-- ESP Color Picker
ESPTab:CreateColorPicker({
    Name = "Box Color",
    Color = Color3.fromRGB(255, 0, 0),
    Flag = "ESP_BoxColor",
    Callback = function(Value)
        Config.ESP.BoxColor = Value
    end
})

-- // Aimbot Tab
local AimbotTab = Window:CreateTab("Aimbot", 9766671152) -- Using an ID for aimbot icon

-- Aimbot Toggle
AimbotTab:CreateToggle({
    Name = "Aimbot Master",
    CurrentValue = false,
    Flag = "Aimbot_Enabled",
    Callback = function(Value)
        Config.Aimbot.Enabled = Value
        
        if Value then
            AimbotManager:Enable()
        else
            AimbotManager:Disable()
        end
    end
})

-- Aimbot Team Check
AimbotTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = true,
    Flag = "Aimbot_TeamCheck",
    Callback = function(Value)
        Config.Aimbot.TeamCheck = Value
    end
})

-- Aimbot Prediction
AimbotTab:CreateToggle({
    Name = "Prediction",
    CurrentValue = true,
    Flag = "Aimbot_Prediction",
    Callback = function(Value)
        Config.Aimbot.Prediction = Value
    end
})

-- Aimbot Auto Shoot
AimbotTab:CreateToggle({
    Name = "Auto Shoot",
    CurrentValue = false,
    Flag = "Aimbot_AutoShoot",
    Callback = function(Value)
        Config.Aimbot.AutoShoot = Value
    end
})

-- Aimbot FOV Toggle
AimbotTab:CreateToggle({
    Name = "Show FOV Circle",
    CurrentValue = true,
    Flag = "Aimbot_ShowFOV",
    Callback = function(Value)
        Config.Aimbot.ShowFOV = Value
        if AimbotManager.FOVCircle then
            AimbotManager.FOVCircle.Visible = Value and AimbotManager.Enabled
        end
    end
})

-- Aimbot Target Part Dropdown
AimbotTab:CreateDropdown({
    Name = "Target Part",
    Options = {"Head", "HumanoidRootPart", "Torso", "LowerTorso", "UpperTorso"},
    CurrentOption = "Head",
    Flag = "Aimbot_TargetPart",
    Callback = function(Option)
        Config.Aimbot.TargetPart = Option
    end
})

-- Aimbot FOV Size
AimbotTab:CreateSlider({
    Name = "FOV Size",
    Range = {10, 500},
    Increment = 10,
    CurrentValue = 100,
    Flag = "Aimbot_FOV",
    Callback = function(Value)
        Config.Aimbot.FOV = Value
    end
})

-- Aimbot Smoothness
AimbotTab:CreateSlider({
    Name = "Aim Smoothness",
    Range = {0.1, 1},
    Increment = 0.1,
    CurrentValue = 0.8,
    Flag = "Aimbot_Sensitivity",
    Callback = function(Value)
        Config.Aimbot.Sensitivity = Value
    end
})

-- Aimbot FOV Color
AimbotTab:CreateColorPicker({
    Name = "FOV Circle Color",
    Color = Color3.fromRGB(255, 255, 255),
    Flag = "Aimbot_FOVColor",
    Callback = function(Value)
        Config.Aimbot.FOVColor = Value
        if AimbotManager.FOVCircle then
            AimbotManager.FOVCircle.Color = Value
        end
    end
})

-- // Fly Tab
local FlyTab = Window:CreateTab("Fly", 9768530392) -- Using an ID for fly icon

-- Fly Toggle
FlyTab:CreateToggle({
    Name = "Fly Master",
    CurrentValue = false,
    Flag = "Fly_Enabled",
    Callback = function(Value)
        Config.Fly.Enabled = Value
        
        if Value then
            FlyManager:Enable()
        else
            FlyManager:Disable()
        end
    end
})

-- Fly Speed
FlyTab:CreateSlider({
    Name = "Fly Speed",
    Range = {10, 200},
    Increment = 5,
    CurrentValue = 80,
    Flag = "Fly_Speed",
    Callback = function(Value)
        Config.Fly.Speed = Value
    end
})

-- Vertical Speed
FlyTab:CreateSlider({
    Name = "Vertical Speed",
    Range = {10, 200},
    Increment = 5,
    CurrentValue = 70,
    Flag = "Fly_VerticalSpeed",
    Callback = function(Value)
        Config.Fly.VerticalSpeed = Value
    end
})

-- Fly Controls Info
FlyTab:CreateSection("Mobile Controls")

FlyTab:CreateParagraph({
    Title = "Mobile Controls",
    Content = "When Fly is enabled, control buttons will appear on the left side of your screen. Use these to move up and down. Use your movement keys/stick to move horizontally."
})

-- // Settings Tab
local SettingsTab = Window:CreateTab("Settings", 9753762469) -- Using an ID for settings icon

-- Settings Section
SettingsTab:CreateSection("Script Settings")

-- Keybind to toggle UI
SettingsTab:CreateKeybind({
    Name = "Toggle UI",
    CurrentKeybind = "RightControl",
    HoldToInteract = false,
    Flag = "UI_Toggle",
    Callback = function()
        -- Toggle UI visibility
        Rayfield:ToggleWindow()
    end
})

-- Unload Script Button
SettingsTab:CreateButton({
    Name = "Unload Script",
    Callback = function()
        -- Clean up all managers
        ESPManager:CleanUp()
        AimbotManager:CleanUp()
        FlyManager:CleanUp()
        
        -- Remove player connections
        for _, connection in pairs({
            PlayerAddedConnection,
            PlayerRemovedConnection
        }) do
            if connection then
                connection:Disconnect()
            end
        end
        
        -- Destroy Rayfield UI
        Rayfield:Destroy()
    end
})

-- Credits Section
SettingsTab:CreateSection("Credits")

SettingsTab:CreateParagraph({
    Title = "Wirtz Script",
    Content = "Developed by @wirtz.dev\nVersion 3.0.1"
})

-- // Player Connections
-- Track new players for ESP
local PlayerAddedConnection = Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer and ESPManager.Enabled then
        ESPManager:CreateESP(player)
    end
end)

-- Clean up ESP when players leave
local PlayerRemovedConnection = Players.PlayerRemoving:Connect(function(player)
    ESPManager:RemoveESP(player)
end)

-- // Notification
Rayfield:Notify({
    Title = "Wirtz Script Loaded",
    Content = "Script successfully loaded! Press RightControl to toggle UI.",
    Duration = 5,
    Image = 9734460825,
    Actions = {
        Ignore = {
            Name = "OK",
            Callback = function() end
        }
    }
})

-- // Character Added Connection (for Fly fix)
LocalPlayer.CharacterAdded:Connect(function(character)
    -- If fly was enabled, re-enable it
    if FlyManager.Enabled then
        task.wait(1) -- Wait for character to fully load
        FlyManager:Disable()
        FlyManager:Enable()
    end
end)
