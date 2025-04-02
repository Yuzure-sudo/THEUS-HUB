-- Sistema de Login do THEUS HUB
local KeySystem = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local LoginWindow = KeySystem.CreateLib("THEUS HUB - LOGIN", "Midnight")

-- Interface de Login
local LoginTab = LoginWindow:NewTab("Login")
local LoginSection = LoginTab:NewSection("Autenticação")

local KeyInput
LoginSection:NewTextBox("Insira sua Key", "Key de acesso", function(text)
    KeyInput = text
end)

LoginSection:NewButton("Login", "Acessar THEUS HUB", function()
    if KeyInput == "sougostoso" then
        LoginWindow:Destroy()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Yuzure-sudo/THEUS-HUB/main/main.lua"))()
    else
        game.Players.LocalPlayer:Kick("Key Inválida!")
    end
end)

LoginSection:NewLabel("Key System by THEUS")