# CapStore

Roblox Library to easily setup simple data storing.\
This library uses ProfileService along with ReplicaService.
Made by captivater.

Roblox model: https://www.roblox.com/library/13625347510/CapStore

## File Structure

Put the model named `ServerStorage` into ServerStorage and then ungroup it.\
Put the model named `ReplicatedStorage` into ReplicatedStorage and then ungroup it.\
Then you can require the `CapStoreServer` and `CapStoreClient` from there.

## Usage

1. Get the Roblox model and insert it into your game
2. Put the models in needed directories as described in file structure
3. Require the modules
4. Initialize the Server-side of CapStore using CapStoreServer.Initialize()
5. Initialize the Client-side of CapStore using CapStoreClient.Initialize()

## Important note
- If you modify Profile or Replica directly, it will not Replicate to client
- To replicate the data, you should use built-in Replica mutators such as Replica:SetValue()
- To get player's data, you can use built-in Replica listeners such as Replica:ListenToChange()
- If you wanna get the profile directly, create your own modules or events to handle that

Every mutator and listener is arleady documented at the ReplicaService API
(https://madstudioroblox.github.io/ReplicaService/api/)

# API

## CapStoreServer Functions

### CapStoreServer.Initialize(profile_template, store_name, replica_name) 
Parameters:
- profile_template -- Profiles will default to given table (hard-copy) when no data was saved previously
- store_name -- DataStore name, by default set to "PlayerProfiles"
- replica_name -- Replicas name, by default set to "ProfilesReplica"

Initializes the CapStore on the Server-side.
You should call this function before everything you do in CapStore Server-side.
Returns nothing.

### CapStoreServer.GetReplica(player) 
Parameters:
- player -- Player to get Replica from

Gets Replica of provided player.
You can modify the data using built-in mutators of ReplicaService.
You can skip the `player` parameter and it will return Replica of every player in the current server.

### CapStoreServer.GetProfile(player) 
Parameters:
- player -- Player to get Replica from

Gets Profile of provided player.
It's not recommended to change the data directly in Profile.
If you do so, it will not replicate to the player.
You can skip the `player` parameter and it will return Profile of every player in the current server.

## CapStoreServer Members

### CapStoreServer.ProfileService
The ProfileService module what CapStore's Server-side module uses.

### CapStoreServer.ProfileStore
The ProfileStore what CapStore's Server-side module uses.

### CapStoreServer.ReplicaService
The ReplicaService module what CapStore's Server-side module uses.

## CapStoreClient Functions

### CapStoreClient.Initialize(replica_name) 
Parameters:
- replica_name -- Replicas name, by default set to "ProfilesReplica", it should be the same as `replica_name` you defined at the `CapStoreServer.Initialize()`

Initializes the CapStore on the Client-side.
You should call this function before everything you do in CapStore Client-side.
Returns nothing.

### CapStoreServer.GetReplica() 

Gets Replica of client.
You can listen for the data changes using built-in listeners of Replica.

## CapStoreClient Members

### CapStoreServer.ReplicaController
The ReplicaController module what CapStore's Server-side module uses.

### CapStoreServer.ReplicaCreated
Event what gets fired when Replica got successfully created.
It indicates that the Replica became available to use. 
