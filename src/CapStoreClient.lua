--[[
	CapStore Client-side module
--]]

local ReplicaController = require(script.Parent.Parent.replicaservice)
local Promise = require(script.Parent.Parent.promise)
local Signal = require(script.Parent.Parent.signal)

local CapStoreClient = {}

CapStoreClient.ReplicaCreated = Signal.new()
CapStoreClient.ReplicaController = ReplicaController

function CapStoreClient.Initialize(replicaName: string)
	local replicaName = replicaName or "ProfilesReplica"

	ReplicaController.ReplicaOfClassCreated(replicaName, function(replica)
		CapStoreClient.Replica = replica
		CapStoreClient.ReplicaCreated:Fire(replica)
	end)

	ReplicaController.RequestData()
end

function CapStoreClient.GetReplica()
	return Promise.new(function(resolve)
		if CapStoreClient.Replica then
			resolve(CapStoreClient.Replica)
		else
			CapStoreClient.ReplicaCreated:Wait()
			resolve(CapStoreClient.Replica)
		end
	end)
end

return CapStoreClient
