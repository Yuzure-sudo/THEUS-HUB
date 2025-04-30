local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Config = {
    Enabled = true,
    TargetPart = "Head",
    FOV = 500,
    Prediction = 0.165,
    AutoFire = true,
    TeamCheck = false,
    VisibilityCheck = false,
    SmoothAim = true,
    SmoothAmount = 0.5,
    HitChance = 100
}
local function GetClosestPlayer()
    local Target = nil
    local MaxDist = Config.FOV
    for _,v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild(Config.TargetPart) and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            if Config.TeamCheck and v.Team == LocalPlayer.Team then continue end
            if Config.VisibilityCheck then
                local Ray = Ray.new(Camera.CFrame.Position, (v.Character[Config.TargetPart].Position - Camera.CFrame.Position).Unit * 2000)
                local Hit = workspace:FindPartOnRayWithIgnoreList(Ray, {LocalPlayer.Character, Camera})
                if not Hit or not Hit:IsDescendantOf(v.Character) then continue end
            end
            local Pos = Camera:WorldToScreenPoint(v.Character[Config.TargetPart].Position)
            local Dist = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(Pos.X, Pos.Y)).Magnitude
            if Dist < MaxDist then
                MaxDist = Dist
                Target = v
            end
        end
    end
    return Target
end
RunService.RenderStepped:Connect(function()
    if Config.Enabled and math.random(1,100) <= Config.HitChance then
        local Target = GetClosestPlayer()
        if Target then
            local Pos = Target.Character[Config.TargetPart].Position
            local Vel = Target.Character[Config.TargetPart].Velocity
            local PredPos = Pos + (Vel * Config.Prediction)
            if Config.SmoothAim then
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, PredPos), Config.SmoothAmount)
            else
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, PredPos)
            end
            if Config.AutoFire then mouse1click() end
        end
    end
end)
UserInputService.InputBegan:Connect(function(Input)
    if Input.KeyCode == Enum.KeyCode.X then
        Config.Enabled = not Config.Enabled
    end
end)
game:GetService("StarterGui"):SetCore("SendNotification",{Title="Aimbot",Text="Loaded | Toggle: X",Duration=3})