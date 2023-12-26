--[[
	CapStore Server-side module
--]]

local ProfileService = require(script.Parent.Parent.profileservice)
local ReplicaService = require(script.Parent.Parent.replicaservice)
local Promise = require(script.Parent.Parent.promise)
local Signal = require(script.Parent.Parent.signal)

local Players = game:GetService("Players")

local Profiles, ProfileReplicas, ProfileStore = {}, {}, nil

-- constants
local ProfileStoreName = "CapStoreProfiles"
local ProfileReplicaToken = ReplicaService.NewClassToken("CapStoreProfileReplica")

local CapStoreServer = {}

CapStoreServer.Initialized = Signal.new()

local function OnPlayerAdded(player)
	local profile = ProfileStore:LoadProfileAsync("Player_" .. player.UserId)

	if profile ~= nil then
		profile:AddUserId(player.UserId)
		profile:Reconcile()

		profile:ListenToRelease(function()
			ProfileReplicas[player]:Destroy()
			ProfileReplicas[player] = nil

			Profiles[player] = nil
			player:Kick()
		end)

		if not player:IsDescendantOf(Players) then
			profile:Release()
		else
			Profiles[player] = profile

			local replica = ReplicaService.NewReplica({
				ClassToken = ProfileReplicaToken,
				Data = profile.Data,
				Replication = player,
			})

			ProfileReplicas[player] = replica
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

local function GetPlayer(player: Player | number): Player
	if typeof(player) == "number" then
		return Players:GetPlayerByUserId(player)
	else
		return player
	end
end

function CapStoreServer.Initialize(profileTemplate: { any })
	ProfileStore = ProfileService.GetProfileStore(ProfileStoreName, profileTemplate)

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

function CapStoreServer.GetProfile(player: Player | number)
	local _player = GetPlayer(player)
	return Promise.new(function(resolve)
		if not Profiles then
			CapStoreServer.Initialized:Wait()
		end

		if _player ~= nil then
			assert(Profiles[_player], string.format("Profile does not exist for %s", tostring(_player.UserId)))

			resolve(Profiles[_player])
		else
			resolve(Profiles)
		end
	end):catch(warn)
end

function CapStoreServer.GetReplica(player: Player | number)
	local _player: Player = GetPlayer(player)
	return Promise.new(function(resolve)
		if not ProfileReplicas then
			CapStoreServer.Initialized:Wait()
		end

		if _player ~= nil then
			assert(ProfileReplicas[_player], string.format("Replica does not exist for %s", tostring(_player.UserId)))

			resolve(ProfileReplicas[_player])
		else
			resolve(ProfileReplicas)
		end
	end):catch(warn)
end

return CapStoreServer
