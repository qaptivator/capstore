# CapStore

Roblox Library to easily setup simple data storing.
This library uses ProfileService along with ReplicaService.
Made by captivater.

## File Structure

CapStoreServer --> ServerStorage\
CapStoreClient --> StarterPlayerSripts

## Usage

1. Put the modules in needed folders as described in file structure
2. Initialize the Server-side of CapStore using CapStoreServer.Initialize()
3. Initialize the Client-side of CapStore using CapStoreClient.Initialize()

## Important note
! If you modify Profile or Replica directly, it will not Replicate to client !\
! To replicate the data, you should use built-in Replica mutators such as Replica:SetValue() !\
! To get player's data, you can use built-in Replica listeners such as Replica:ListenToChange() !\
! If you wanna get the profile directly, create your own modules or events to handle that !

Every mutator and listener is arleady documented at the ReplicaService API
(https://madstudioroblox.github.io/ReplicaService/api/)

# API

### Functions [CapStoreServer]:

CapStoreServer.Initialize(profile_template, store_name, replica_name) --> nil

Initializes the CapStore on the Server-side.

profile_template   [table] -- Profiles will default to given table (hard-copy) when no data was saved previously
store_name   nil or [string] -- DataStore name, by default set to "PlayerProfiles"
Replica_name   nil or [string] -- Replicas name, by default set to "ProfilesReplica"

CapStoreServer.GetReplica(player) --> [any]

Gets Replica of provided player
You can modify the data using built-in mutators of ReplicaService

player   [Player] -- Player to change data in
OR
player   nil -- Get every Replica in current server

CapStoreServer.GetProfile(player) --> [any]

Gets Profile of provided player

player   [Player] -- Player to change data in
OR
player   nil -- Get every Profile in current server

### Members [CapStoreServer]:

CapStoreServer.ProfileService   [ProfileService] -- ProfileService module
CapStoreServer.ProfileStore   [ProfileStore] -- ProfileStore from ProfileService
CapStoreServer.ReplicaService   [ReplicaService] -- ReplicaService module

### Functions [CapStoreClient]:

CapStoreServer.Initialize(replica_name) --> nil

Initializes the CapStore on the Client-side.

replica_name   nil or [string] -- Replicas name, by default set to "ProfilesReplica"

CapStoreServer.GetReplica() --> [any]

Gets Replica of client
You can listen for the data changes using built-in listeners of Replica

player   [Player] -- Player to change data in
OR
player   nil -- Get every Replica in current server

### Members [CapStoreClient]:

CapStoreServer.ReplicaController   [ReplicaController] -- ReplicaController module
CapStoreServer.ReplicaCreated   [RBXScriptSignal] -- Event what gets fired when Replica got sucesfully created

Thanks for using this library!
