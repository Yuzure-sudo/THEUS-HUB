local function LoadTheusHub()
    if game.PlaceId == 4520749081 then -- King Legacy
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Yuzure-sudo/THEUS-HUB/main/source.lua"))()
    else
        game.Players.LocalPlayer:Kick("THEUS HUB: Jogo não suportado!")
    end
end

return LoadTheusHub()