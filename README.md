📄 Fake Plate Flipper (Fake Plate Flipper)

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

⚙️ Configuration

``
Config = {}
-- Key to toggle the plate flipper
Config.FlipKey = 'INSERT'
-- Cooldown (seconds) between flips
Config.SwitchCooldown = 50
-- Installation time (ms)
Config.InstallDuration = 5000
-- Restrict installation to specific jobs
Config.UseJobCheck = true
-- Allowed jobs
Config.JobsAllowed = {
    'tuner'
}
``
