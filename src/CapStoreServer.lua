--[[
	CapStore Server-side module
--]]

local ProfileService = require(script.Parent.Parent.profileservice)
local ReplicaService = require(script.Parent.Parent.replicaservice)
local Promise = require(script.Parent.Parent.promise)
local Signal = require(script.Parent.Parent.signal)

local Players = game:GetService("Players")

local Profiles = nil
local ProfileStore = nil
local Replicas = nil
local ReplicaClassToken = nil

local CapStoreServer = {}

CapStoreServer.Initialized = Signal.new()

local function OnPlayerAdded(player)
	local profile = ProfileStore:LoadProfileAsync("Player_" .. player.UserId)

	if profile ~= nil then
		profile:AddUserId(player.UserId)
		profile:Reconcile()

		profile:ListenToRelease(function()
			Replicas[player]:Destroy()
			Replicas[player] = nil

			Profiles[player] = nil
			player:Kick()
		end)

		if not player:IsDescendantOf(Players) then
			profile:Release()
		else
			Profiles[player] = profile

			local replica = ReplicaService.NewReplica({
				ClassToken = ReplicaClassToken,
				Data = profile.Data,
				Replication = player,
			})

			Replicas[player] = replica
		end
	else
		player:Kick("Unable to load your data. Please rejoin.")
	end
end

local function OnPlayerRemoved(player)
	local profile = Profiles[player]

	if profile ~= nil then
		profile:Release()
	end
end

function CapStoreServer.Initialize(profile_template: { any }, store_name: string, replica_name: string)
	store_name = store_name or "PlayerProfiles"
	replica_name = replica_name or "ProfilesReplica"

	ProfileStore = ProfileService.GetProfileStore(store_name, profile_template)
	ReplicaClassToken = ReplicaService.NewClassToken(replica_name)

	for _, player in Players:GetPlayers() do
		task.spawn(OnPlayerAdded, player)
	end

	Players.PlayerAdded:Connect(OnPlayerAdded)
	Players.PlayerRemoving:Connect(OnPlayerRemoved)

	game:BindToClose(function()
		for _, player in Players:GetPlayers() do
			task.spawn(OnPlayerRemoved, player)
		end
	end)

	CapStoreServer.Initialized:Fire()
end

function CapStoreServer.GetReplica(player: Player)
	return Promise.new(function(resolve)
		if not Replicas then
			CapStoreServer.Initialized:Wait()
		end

		if player ~= nil then
			assert(Replicas[player], string.format("Replica does not exist for %s", tostring(player.UserId)))

			resolve(Replicas[player])
		else
			resolve(Replicas)
		end
	end)
end

function CapStoreServer.GetProfile(player: Player)
	return Promise.new(function(resolve)
		if Profiles == {} then
			CapStoreServer.Initialized:Wait()
		end

		if player ~= nil then
			assert(Profiles[player], string.format("Profile does not exist for %s", tostring(player.UserId)))

			resolve(Profiles[player])
		else
			resolve(Profiles)
		end
	end)
end

CapStoreServer.ProfileService = ProfileService
CapStoreServer.ReplicaService = ReplicaService
CapStoreServer.ProfileStore = ProfileStore

return CapStoreServer
