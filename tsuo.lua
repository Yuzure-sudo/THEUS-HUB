local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wally2"))()
local MainUI = Lib:CreateWindow("THEUS PREMIUM HUB V2") 
MainUI.Background = "rbxassetid://6073763717"

local GamePlayers = game:GetService("Players")
local GameRun = game:GetService("RunService")
local InputService = game:GetService("UserInputService")
local GameCam = workspace.CurrentCamera
local MainPlayer = GamePlayers.LocalPlayer
local PlayerMouse = MainPlayer:GetMouse()

local Settings = {
    AimSettings = {
        Active = true,
        AimAt = "Head",
        Range = 500,
        PredictMovement = 0.165,
        AutoShoot = true,
        CheckTeam = false,
        WallCheck = false,
        Smooth = true,
        SmoothValue = 0.5,
        AimSuccess = 100
    },
    VisualSettings = {
        Active = true,
        ShowBox = true,
        ShowLine = true,
        ShowNames = true,
        ShowDist = true,
        ShowHP = true,
        BoxRGB = Color3.fromRGB(255,0,0),
        LineRGB = Color3.fromRGB(255,0,0),
        NameRGB = Color3.fromRGB(255,255,255),
        FillRGB = Color3.fromRGB(255,0,0),
        FillAlpha = 0.5,
        BoxAlpha = 0.3,
        TextHeight = 14,
        TextBorder = true,
        ViewRange = 2000,
        CheckTeam = false
    }
}

local FightTab = MainUI:NewTab("FIGHT")
local AimSection = FightTab:NewSection("AIM")
local WallSection = FightTab:NewSection("WALL")

AimSection:NewToggle("AIM ON/OFF", "", function(val)
    Settings.AimSettings.Active = val
end)

AimSection:NewDropdown("HIT PART", "", {"Head", "HumanoidRootPart", "Torso"}, function(val)
    Settings.AimSettings.AimAt = val
end)

AimSection:NewSlider("RANGE", "", 1000, 10, function(val)
    Settings.AimSettings.Range = val
end)

AimSection:NewSlider("PREDICT", "", 1, 0, function(val)
    Settings.AimSettings.PredictMovement = val
end)

AimSection:NewToggle("AUTO FIRE", "", function(val)
    Settings.AimSettings.AutoShoot = val
end)

AimSection:NewToggle("TEAM CHECK", "", function(val)
    Settings.AimSettings.CheckTeam = val
end)

WallSection:NewToggle("WALL ON/OFF", "", function(val)
    Settings.VisualSettings.Active = val
end)

WallSection:NewToggle("BOX", "", function(val)
    Settings.VisualSettings.ShowBox = val
end)

WallSection:NewToggle("LINE", "", function(val)
    Settings.VisualSettings.ShowLine = val
end)

WallSection:NewToggle("NAME", "", function(val)
    Settings.VisualSettings.ShowNames = val
end)

local function MakeESP()
    for _,target in pairs(GamePlayers:GetPlayers()) do
        if target ~= MainPlayer then
            local Box = Drawing.new("Square")
            local Line = Drawing.new("Line")
            local PlayerName = Drawing.new("Text")
            
            GameRun.RenderStepped:Connect(function()
                if target.Character and target.Character:FindFirstChild("Humanoid") and target.Character:FindFirstChild("HumanoidRootPart") and Settings.VisualSettings.Active then
                    local Position, OnScreen = GameCam:WorldToViewportPoint(target.Character.HumanoidRootPart.Position)
                    local Distance = (GameCam.CFrame.Position - target.Character.HumanoidRootPart.Position).Magnitude
                    
                    if OnScreen and Distance <= Settings.VisualSettings.ViewRange then
                        if Settings.VisualSettings.ShowBox then
                            Box.Visible = true
                            Box.Color = Settings.VisualSettings.BoxRGB
                            Box.Transparency = Settings.VisualSettings.BoxAlpha
                            Box.Size = Vector2.new(2000 / Distance, 2500 / Distance)
                            Box.Position = Vector2.new(Position.X - Box.Size.X / 2, Position.Y - Box.Size.Y / 2)
                            Box.Thickness = 1
                            Box.Filled = false
                        else
                            Box.Visible = false
                        end
                        
                        if Settings.VisualSettings.ShowLine then
                            Line.Visible = true
                            Line.Color = Settings.VisualSettings.LineRGB
                            Line.From = Vector2.new(GameCam.ViewportSize.X/2, GameCam.ViewportSize.Y)
                            Line.To = Vector2.new(Position.X, Position.Y)
                            Line.Thickness = 1
                        else
                            Line.Visible = false
                        end
                        
                        if Settings.VisualSettings.ShowNames then
                            PlayerName.Visible = true
                            PlayerName.Color = Settings.VisualSettings.NameRGB
                            PlayerName.Text = target.Name.." ["..math.floor(Distance).."]"
                            PlayerName.Center = true
                            PlayerName.Outline = Settings.VisualSettings.TextBorder
                            PlayerName.OutlineColor = Color3.new(0,0,0)
                            PlayerName.Position = Vector2.new(Position.X, Position.Y - Box.Size.Y / 2 - 16)
                            PlayerName.Size = Settings.VisualSettings.TextHeight
                        else
                            PlayerName.Visible = false
                        end
                    else
                        Box.Visible = false
                        Line.Visible = false
                        PlayerName.Visible = false
                    end
                else
                    Box.Visible = false
                    Line.Visible = false
                    PlayerName.Visible = false
                end
            end)
        end
    end
end

local function FindTarget()
    local Target = nil
    local MaxDist = Settings.AimSettings.Range
    for _,target in pairs(GamePlayers:GetPlayers()) do
        if target ~= MainPlayer and target.Character and target.Character:FindFirstChild(Settings.AimSettings.AimAt) and target.Character:FindFirstChild("Humanoid") and target.Character.Humanoid.Health > 0 then
            if Settings.AimSettings.CheckTeam and target.Team == MainPlayer.Team then continue end
            if Settings.AimSettings.WallCheck then
                local Ray = Ray.new(GameCam.CFrame.Position, (target.Character[Settings.AimSettings.AimAt].Position - GameCam.CFrame.Position).Unit * 2000)
                local Hit = workspace:FindPartOnRayWithIgnoreList(Ray, {MainPlayer.Character, GameCam})
                if not Hit or not Hit:IsDescendantOf(target.Character) then continue end
            end
            local Pos = GameCam:WorldToScreenPoint(target.Character[Settings.AimSettings.AimAt].Position)
            local Dist = (Vector2.new(PlayerMouse.X, PlayerMouse.Y) - Vector2.new(Pos.X, Pos.Y)).Magnitude
            if Dist < MaxDist then
                MaxDist = Dist
                Target = target
            end
        end
    end
    return Target
end

GameRun.RenderStepped:Connect(function()
    if Settings.AimSettings.Active and math.random(1,100) <= Settings.AimSettings.AimSuccess then
        local Target = FindTarget()
        if Target then
            local Pos = Target.Character[Settings.AimSettings.AimAt].Position
            local Vel = Target.Character[Settings.AimSettings.AimAt].Velocity
            local PredPos = Pos + (Vel * Settings.AimSettings.PredictMovement)
            if Settings.AimSettings.Smooth then
                GameCam.CFrame = GameCam.CFrame:Lerp(CFrame.new(GameCam.CFrame.Position, PredPos), Settings.AimSettings.SmoothValue)
            else
                GameCam.CFrame = CFrame.new(GameCam.CFrame.Position, PredPos)
            end
            if Settings.AimSettings.AutoShoot then mouse1click() end
        end
    end
end)

MakeESP()
GamePlayers.PlayerAdded:Connect(MakeESP)