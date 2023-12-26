# CapStore

Roblox Library to easily setup simple data storing.
This library uses ProfileService along with ReplicaService.
Made by captivater.

<p align="center">
  <a href="https://wally.run/package/qaptivator/capstore?version=0.1.7">
    <img alt="Wally" src="https://img.shields.io/badge/Wally-0.1.7-AD4646" />
  </a>
  <a href="https://www.roblox.com/library/13779687697/CapStore">
    <img alt="Roblox" src="https://img.shields.io/badge/Roblox-CapStore-blue" />
  </a>
</p>

# Installation

Wally:

```toml
capstore = "qaptivator/capstore@0.1.7"
```

Roblox studio model:
https://www.roblox.com/library/13779687697/CapStore

# Usage

1. Install the module
2. Require the module on server and client side
3. Initialize both sides of CapStore using CapStore.Initialize()

**WARNING: The default ProfileStore name had been changed, so the data saved on versions before and on 0.1.7 would remain on the old ProfileStore**

# Profiles and Replicas

Profile is the object which holds the player data. It will be saved to DataStores when player leaves the game.
Replicas are objects, which replicate the profile from server to client side using events.
Profiles should be used only for reading, because writing something to it will not replicate to the client,
which will cause issues. Writing to replicas can be done using built-in mutators of ReplicaService.

In this module, you cannot get the player profile from client side,
only using listeners and on initalization of the replica.
But you can make is yourself using RemoteFunctions and some server code.
Listening to the changes can be done using built-in listeners of ReplicaService.
You can also get the initialized data from the replica.
Replicas can be used for something like currency counters, because they only need to update on initalization and data changes.

Every mutator and listener is arleady documented and explained at the [ReplicaService API](https://madstudioroblox.github.io/ReplicaService/api/)

# API

## Server-side

### CapStore.Initialize(profileTemplate)

Initializes the CapStore on the server-side. You should provide a template which
new profiles will default to when no data was saved previously.
You should call this function before everything you do in CapStore server-side.
Returns nothing.

### CapStore.GetReplica(player)

Gets replica of provided player. Returns a promise. You can also use UserId instead of Player instance.
You can modify and sync the player data using built-in replica mutators of ReplicaService.
You can skip the `player` parameter and it will return the replica of every player in server.

### CapStore.GetProfile(player)

Gets profile of provided player. Returns a promise. You can also use UserId instead of Player instance.
It's not recommended to change the data directly in Profile.
If you do so, it will not replicate to the player.
You can skip the `player` parameter and it will return the profile of every player in server.

### CapStore.Initialized

Signal which fires when the server-side CapStore was finished initializing.

## Client-side

### CapStore.Initialize()

Initializes the CapStore on the client-side.
You should call this function before everything you do in CapStore Client-side.
Returns nothing.

### CapStore.GetReplica()

Gets the replica of the current player (client). Returns a promise.
You can listen for the data changes using built-in listeners of ReplicaService.

### CapStore.ReplicaCreated

Signal which fires when the client-side CapStore had received the created replica for profile synchronization.
