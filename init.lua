if IsDuplicityVersion() then
	AddEventHandler('moskov_tokenizer:serverReady', function()
		exports['moskov_tokenizer']:setupServerResource(GetCurrentResourceName())
	end)
else
	securityToken = nil
	AddEventHandler('moskov_tokenizer:clientReady', function()
		securityToken = exports['moskov_tokenizer']:setupClientResource(GetCurrentResourceName())
	end)
end
