📄 Fake Plate (Fake Plate Flipper) - Bar Store Release

A FiveM script that allows players to install and toggle a plate flipper on vehicles. Once installed, players can switch between real and fake plates using a keybind.

Supports ESX, QBCore, and ox_inventory.

✨ Features
Install a plate flipper on vehicles
Toggle between real & fake plates
Job-based installation (optional)
Cooldown system to prevent spam
Uses ox_inventory item
Compatible with ESX & QBCore

📦 Requirements
ox_inventory
es_extended or qb-core


📦 Requirements Items 
For Ox Invetory 

`` 
`	["fakeplate"] = {
		label = "Fake Plate",
		weight = 150.0,
		stack = false,
		close = true,
		description = "With this fake plate, you won't be wanted.",
		image = "fakeplate.png",
	},
``

For QBCore Invnetory

``
['fakeplate'] 					 = {['name'] = 'fakeplate', 		  	  		['label'] = 'Fake Plate',		 		['weight'] = 250, 		['type'] = 'item', 		['image'] = 'fakeplate.png', 			['unique'] = true, 		['useable'] = true, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'With this fake plate, you won\'t be wanted.'},
``

📁 Installation

Add the fakeplate item to your inventory system (ox or QBCore).

Place the script in your server resources folder.

Add ensure fakeplateflipper to your server.cfg.

Configure the script to your liking in config.lua.

📝 Notes

Players must have the fakeplate item to install the flipper.

The script stores both real and fake plates and switches between them seamlessly.

Works on any vehicle the player owns or is inside (depending on your framework setup).
