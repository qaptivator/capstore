# CapStore

Roblox Library to easily setup simple data storing.
This library uses ProfileService along with ReplicaService.
Made by captivater.

## Installation

For Wally: Paste this into your `wally.toml` file

```toml
capstore = "qaptivator/capstore@0.1.7"
```

You can also install the library using the model:
https://www.roblox.com/library/13779687697/CapStore

## Usage

1. Install the Wally package
2. Require the module on both sides
3. Initialize the Server-side and Client-side of CapStore using CapStore.Initialize()

## Important note

- If you modify Profile or Replica directly, it will not Replicate to client
- To replicate the data, you should use built-in Replica mutators such as Replica:SetValue()
- To get player's data, you can use built-in Replica listeners such as Replica:ListenToChange()
- If you wanna get the profile directly, create your own modules or events to handle that

Every mutator and listener is arleady documented at the ReplicaService API
(https://madstudioroblox.github.io/ReplicaService/api/)

# API

## Server-side

### CapStore.Initialize(profile_template, store_name, replica_name)

Parameters:

- profile_template - Profiles will default to given table (hard-copy) when no data was saved previously
- store_name - DataStore name, by default set to "PlayerProfiles"
- replica_name - Replicas name, by default set to "ProfilesReplica"

Initializes the CapStore on the Server-side.
You should call this function before everything you do in CapStore Server-side.
Returns nothing.

### CapStore.GetReplica(player)

Parameters:

- player - Player to get Replica from

Gets Replica of provided player.
You can modify the data using built-in mutators of ReplicaService.
You can skip the `player` parameter and it will return Replica of every player in the current server.

### CapStore.GetProfile(player)

Parameters:

- player - Player to get Replica from

Gets Profile of provided player.
It's not recommended to change the data directly in Profile.
If you do so, it will not replicate to the player.
You can skip the `player` parameter and it will return Profile of every player in the current server.

## Server-side Members

### CapStore.ProfileService

The ProfileService module what CapStore's Server-side module uses.

### CapStore.ProfileStore

The ProfileStore what CapStore's Server-side module uses.

### CapStore.ReplicaService

The ReplicaService module what CapStore's Server-side module uses.

## Client-side

### CapStore.Initialize(replica_name)

Parameters:

- replica_name - Replicas name, by default set to "ProfilesReplica", it should be the same as `replica_name` you defined at the `CapStoreServer.Initialize()`

Initializes the CapStore on the Client-side.
You should call this function before everything you do in CapStore Client-side.
Returns nothing.

### CapStore.GetReplica()

Gets Replica of client.
You can listen for the data changes using built-in listeners of Replica.

## Client-side Members

### CapStore.ReplicaController

The ReplicaController module what CapStore's Server-side module uses.

### CapStore.ReplicaCreated

Event what gets fired when Replica got successfully created.
It indicates that the Replica became available to use.
