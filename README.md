# moskov_tokenizer
Tokenizer do serwera fivem. Zabezpiecza to przed dodawniem sobie itemow albo np pięniedzy poprzez rózne triggery przez cheaterów.

# Instalacja
* Zainstaluj  [yarn](https://github.com/citizenfx/cfx-server-data) (można go w `/resources/[system]/[builders]/yarn`)
* Zkonfiguruj `moskov_tokenizer` używając `config.lua`.
* Dodaj `ensure moskov_tokenizer` do "server.cfg".
* Restartuj serwer.

# Używanie
Token jest przechowywany w zmiennej o nazwie `securityToken` po stronie klienta w każdym zasobie. Aby pobrać token bezpieczeństwa dla danego zasobu, należy dołączyć skrypt `init.lua` do pliku `__resource.lua` lub `fxmanifest.lua` zasobu. Skrypt `init.lua` musi być dołączony zarówno jako skrypt serwera, jak i klienta:
```lua
server_script '@moskov_tokenizer/init.lua'
client_script '@moskov_tokenizer/init.lua'
```

## Client
**Po otrzymaniu tokena** Wygląda on tak:
```lua
TriggerServerEvent('moskov_ac:newEvent', securityToken)
```

Zaleca się upewnienie się, że client ma token, aby zapobiec fałszywym alarmom:
```lua
Citizen.CreateThread(function()
	while securityToken == nil do
		Citizen.Wait(150)
	end
	TriggerServerEvent('moskov_ac:newEvent', securityToken)
end)
```

## Server
Aby zabezpieczyć event serwera, należy dodać proste if.
```lua
RegisterNetEvent('moskov_ac:newEvent')
AddEventHandler('moskov_ac:newEvent', function(token)
	local _source = source
	if not exports['moskov_tokenizer']:secureServerEvent(GetCurrentResourceName(), _source, token) then
		return false
	end
end)
```
