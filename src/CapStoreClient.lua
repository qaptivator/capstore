--[[
	CapStore Client-side module
--]]

local ReplicaController = require(script.Parent.Parent.replicaservice)
local Promise = require(script.Parent.Parent.promise)
local Signal = require(script.Parent.Parent.signal)

local CapStoreClient = {}

CapStoreClient.ReplicaCreated = Signal.new()
CapStoreClient.ReplicaController = ReplicaController

function CapStoreClient.Initialize(replica_name: string)
	replica_name = replica_name or "ProfilesReplica"

	ReplicaController.ReplicaOfClassCreated(replica_name, function(replica)
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
