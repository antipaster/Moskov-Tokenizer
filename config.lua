Config = {}

--[[
	Odpala powiadomienia w consoli odnosnie tokenow.
	PowiadomClient powinno być wyłączone.
]]
Config.PowiadomClient = false
Config.PowiadomServer = false

--[[
	Dostosuj opóźnienie między momentem, w którym client nasłuchuje i
	kiedy serwer wysyła informacje.
	250 wydaje się być tutaj najlepsze, ale w razie potrzeby można je zmniejszyć lub zwiększyć.
]]

Config.ClientDelay = 250

--[[
	Wiadomość która dostanie gracz po zostaniu wyrzuconym serwera. 
--]]
Config.KickMessage = "TriggerServerEvent('CwelItems:addItem','Mozg')"

--[[
  Zdefiniuj niestandardową funkcję kiedy gracz dostanie kicka. 
  Jeśli Config.CustomAction ma wartość false, gracz zostanie kicknięty.
]]
Config.CustomAction = false
Config.CustomActionFunction = function(source)
	print("Customowa akcja dla: " .. source)
	DropPlayer(source, Config.KickMessage)
end
