if game:GetService("RunService"):IsServer() then
	return require(script.CapStoreServer)
else
	local CapStoreServer = script:FindFirstChild("CapStoreServer")
	if CapStoreServer then
		CapStoreServer:Destroy()
	end
	return require(script.CapStoreClient)
end
