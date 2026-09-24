AddEventHandler('esx:getShtozaredObjtozect', function(cb)
	cb(ESX)
end)

function getSharedObject()
	return ESX
end