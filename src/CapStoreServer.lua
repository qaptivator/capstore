--[[
	CapStore Server-side module
--]]

local ProfileService = require(script.ProfileService)
local ReplicaService = require(script.ReplicaService)
local Players = game:GetService("Players")

local Profiles = {}
local ProfileStore = {}
local Replicas = {}
local ReplicaClassToken = nil

local CapStoreServer = {}

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

function CapStoreServer.Initialize(profile_template: {any}, store_name: string, replica_name: string)
	local store_name = store_name or "PlayerProfiles"
	local replica_name = replica_name or "ProfilesReplica"

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
end

function CapStoreServer.GetReplica(player: Player)
	assert(Replicas ~= {}, "CapStore hasn't loaded up yet")
	
	if player ~= nil then
		assert(Replicas[player], string.format("Replica does not exist for %s", player.UserId))

		return Replicas[player]
	else
		return Replicas
	end
end

function CapStoreServer.GetProfile(player: Player)
	assert(Profiles ~= {}, "CapStore hasn't loaded up yet")
	
	if player ~= nil then
		assert(Profiles[player], string.format("Profile does not exist for %s", player.UserId))

		return Profiles[player]
	else
		return Profiles
	end
end

CapStoreServer.ProfileService = ProfileService
CapStoreServer.ReplicaService = ReplicaService
CapStoreServer.ProfileStore = ProfileStore

return CapStoreServer
