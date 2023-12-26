--[[
	CapStore Client-side module
--]]

local ReplicaController = require(script.Parent.Parent.replicaservice)
local Promise = require(script.Parent.Parent.promise)
local Signal = require(script.Parent.Parent.signal)

local Replica = nil

-- constants
local ProfileReplicaName = "CapStoreProfileReplica"
--local LeaderstatsReplicaName = "CapStoreLeaderstatsReplica"

local CapStoreClient = {}

CapStoreClient.ReplicaCreated = Signal.new()

function CapStoreClient.Initialize()
	ReplicaController.ReplicaOfClassCreated(ProfileReplicaName, function(replica)
		Replica = replica
		CapStoreClient.ReplicaCreated:Fire(replica)
	end)

	ReplicaController.RequestData()
end

function CapStoreClient.GetReplica()
	return Promise.new(function(resolve)
		if not Replica then
			CapStoreClient.ReplicaCreated:Wait()
		end
		resolve(Replica)
	end)
end

return CapStoreClient
