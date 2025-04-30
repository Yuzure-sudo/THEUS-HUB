local s={ts=game:GetService("TweenService"),uis=game:GetService("UserInputService"),p=game:GetService("Players"),rs=game:GetService("RunService"),ws=game:GetService("Workspace")}
local l=s.p.LocalPlayer;local c=s.ws.CurrentCamera
_G.c={a={e=false,t=true,w=true,s=0.25,p="Head",f=400,pr=true,ps=1.5},e={e=false,t=true,b=true,n=true,h=true,d=true,tr=false}}
local g=Instance.new("ScreenGui")g.Parent=game.CoreGui
local m=Instance.new("Frame")m.Size=UDim2.new(0,300,0,450)m.Position=UDim2.new(0.5,-150,0.5,-225)m.BackgroundColor3=Color3.fromRGB(15,15,15)m.Parent=g
Instance.new("UICorner",m).CornerRadius=UDim.new(0,8)
local t=Instance.new("Frame")t.Size=UDim2.new(1,0,0,40)t.BackgroundColor3=Color3.fromRGB(20,20,20)t.Parent=m
Instance.new("UICorner",t).CornerRadius=UDim.new(0,8)
local ti=Instance.new("TextLabel")ti.Text="Advanced Combat"ti.Size=UDim2.new(1,-50,1,0)ti.Position=UDim2.new(0,10,0,0)ti.BackgroundTransparency=1
ti.TextColor3=Color3.fromRGB(255,255,255)ti.TextSize=16;ti.Font=Enum.Font.GothamBold;ti.TextXAlignment=Enum.TextXAlignment.Left;ti.Parent=t
local b=Instance.new("ImageButton")b.Size=UDim2.new(0,30,0,30)b.Position=UDim2.new(1,-35,0.5,-15)b.BackgroundColor3=Color3.fromRGB(25,25,25)b.Parent=t
Instance.new("UICorner",b).CornerRadius=UDim.new(1,0)
local n=Instance.new("Frame")n.Size=UDim2.new(1,-20,1,-60)n.Position=UDim2.new(0,10,0,50)n.BackgroundTransparency=1;n.Parent=m
local function k(x,y)local f=Instance.new("TextButton")f.Size=UDim2.new(1,0,0,40)f.BackgroundColor3=Color3.fromRGB(25,25,25)f.Text=""f.Parent=n
Instance.new("UICorner",f).CornerRadius=UDim.new(0,6)
local tx=Instance.new("TextLabel")tx.Text=x;tx.Size=UDim2.new(1,-60,1,0)tx.Position=UDim2.new(0,10,0,0)tx.BackgroundTransparency=1
tx.TextColor3=Color3.fromRGB(255,255,255)tx.TextSize=14;tx.Font=Enum.Font.GothamSemibold;tx.TextXAlignment=Enum.TextXAlignment.Left;tx.Parent=f
local i=Instance.new("Frame")i.Size=UDim2.new(0,40,0,20)i.Position=UDim2.new(1,-50,0.5,-10)i.BackgroundColor3=Color3.fromRGB(30,30,30)i.Parent=f
Instance.new("UICorner",i).CornerRadius=UDim.new(1,0)
local d=Instance.new("Frame")d.Size=UDim2.new(0,16,0,16)d.Position=UDim2.new(0,2,0.5,-8)d.BackgroundColor3=Color3.fromRGB(255,50,50)d.Parent=i
Instance.new("UICorner",d).CornerRadius=UDim.new(1,0)
if y then
local sl=Instance.new("Frame")sl.Size=UDim2.new(1,0,0,40)sl.BackgroundTransparency=1;sl.Parent=n
local sv=Instance.new("TextBox")sv.Size=UDim2.new(1,0,1,0)sv.BackgroundColor3=Color3.fromRGB(25,25,25)sv.Text=tostring(y)
sv.TextColor3=Color3.fromRGB(255,255,255)sv.TextSize=14;sv.Font=Enum.Font.GothamSemibold;sv.Parent=sl
Instance.new("UICorner",sv).CornerRadius=UDim.new(0,6)
return f,d,sv
end
return f,d
end
local function v(cf)local p=Ray.new(c.CFrame.Position,(cf-c.CFrame.Position).Unit*1000)
local h,_=s.ws:FindPartOnRayWithIgnoreList(p,{l.Character})return h and true or false end
local function g(p)if not p.Character then return end;local h=p.Character:FindFirstChild("Head")
if not h then return end;local _,v=c:WorldToScreenPoint(h.Position)if not v then return end
local m=Vector2.new(s.uis:GetMouseLocation().X,s.uis:GetMouseLocation().Y)local t=Vector2.new(_.X,_.Y)return(m-t).Magnitude end
local function f()local t;local d=_G.c.a.f;for _,p in pairs(s.p:GetPlayers())do
if p~=l and p.Character and p.Character:FindFirstChild(_G.c.a.p)then
if _G.c.a.t and p.Team==l.Team then continue end
if _G.c.a.w and v(p.Character[_G.c.a.p].Position)then continue end
local m=g(p)if m and m<d then t=p;d=m end end end;return t end
local a,ai=k("Aimbot")local e,ei=k("ESP")local p,pi,ps=k("Prediction",_G.c.a.ps)
local s,si,ss=k("Smoothness",_G.c.a.s)local f,fi,fs=k("FOV",_G.c.a.f)
a.MouseButton1Click:Connect(function()_G.c.a.e=not _G.c.a.e
ai.BackgroundColor3=_G.c.a.e and Color3.fromRGB(50,255,50)or Color3.fromRGB(255,50,50)end)
e.MouseButton1Click:Connect(function()_G.c.e.e=not _G.c.e.e
ei.BackgroundColor3=_G.c.e.e and Color3.fromRGB(50,255,50)or Color3.fromRGB(255,50,50)end)
ps.FocusLost:Connect(function()_G.c.a.ps=tonumber(ps.Text)or _G.c.a.ps end)
ss.FocusLost:Connect(function()_G.c.a.s=tonumber(ss.Text)or _G.c.a.s end)
fs.FocusLost:Connect(function()_G.c.a.f=tonumber(fs.Text)or _G.c.a.f end)
local y=false;b.MouseButton1Click:Connect(function()y=not y
local t=s.ts:Create(m,TweenInfo.new(0.2),{Size=y and UDim2.new(0,300,0,40)or UDim2.new(0,300,0,450)})t:Play()
n.Visible=not y end)m.Draggable=true;m.Active=true
local function dr(p)if not p.Character or not _G.c.e.e then return end
local rt=p.Character:FindFirstChild("HumanoidRootPart")if not rt then return end
local _,v=c:WorldToScreenPoint(rt.Position)if not v then return end
if _G.c.e.t and p.Team==l.Team then return end
local h=p.Character:FindFirstChild("Humanoid")
if _G.c.e.b then local b=Drawing.new("Square")b.Visible=true;b.Color=Color3.new(1,1,1)b.Thickness=1
b.Size=Vector2.new(35,50)b.Position=Vector2.new(_.X-17.5,_.Y-25)end
if _G.c.e.n then local n=Drawing.new("Text")n.Visible=true;n.Color=Color3.new(1,1,1)n.Size=13
n.Center=true;n.Text=p.Name;n.Position=Vector2.new(_.X,_.Y-60)end
if _G.c.e.h and h then local b=Drawing.new("Square")b.Visible=true;b.Color=Color3.new(1,0,0)b.Filled=true
b.Size=Vector2.new(30,4)b.Position=Vector2.new(_.X-15,_.Y-30)
local f=Drawing.new("Square")f.Visible=true;f.Color=Color3.new(0,1,0)f.Filled=true
f.Size=Vector2.new(30*(h.Health/h.MaxHealth),4)f.Position=Vector2.new(_.X-15,_.Y-30)end
if _G.c.e.d then local d=Drawing.new("Text")d.Visible=true;d.Color=Color3.new(1,1,1)d.Size=13
d.Center=true;d.Text=math.floor((l.Character.HumanoidRootPart.Position-rt.Position).Magnitude).."m"
d.Position=Vector2.new(_.X,_.Y+30)end
if _G.c.e.tr then local t=Drawing.new("Line")t.Visible=true;t.Color=Color3.new(1,1,1)t.Thickness=1
t.From=Vector2.new(c.ViewportSize.X/2,c.ViewportSize.Y)t.To=Vector2.new(_.X,_.Y)end end
s.rs.RenderStepped:Connect(function()if _G.c.a.e then local t=f()if t then local p=t.Character[_G.c.a.p]
local pr=_G.c.a.pr and p.Velocity*Vector3.new(1,0,1)*_G.c.a.ps or Vector3.new()
local _=c:WorldToScreenPoint(p.Position+pr)local m=Vector2.new(s.uis:GetMouseLocation().X,s.uis:GetMouseLocation().Y)
local d=(Vector2.new(_.X,_.Y)-m)*_G.c.a.s;mousemoverel(d.X,d.Y)end end
for _,p in pairs(s.p:GetPlayers())do if p~=l then dr(p)end end end)
s.uis.InputBegan:Connect(function(i,g)if not g and i.KeyCode==Enum.KeyCode.RightAlt then g.Enabled=not g.Enabled end end)