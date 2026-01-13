// Get generic attributes
event_inherited()
characterCreate(CHARACTER_TYPE.player);

// Player attributes ------------------------

function InitPlayerStats()
{
	walkSpdDef = 1.7
	walkSpdSprint = 2.5	// Use when running between cleared rooms
	walkSpd = walkSpdDef
	maxHp = 150
	
	inventorySize = 2
	
	// Buff specific
	dualWield = false
	buffApplyAmount = 1
}
InitPlayerStats()	// Do this, so we can reset player stats to default later

hp = maxHp

// Inventory --------------------------

activeInventorySlot = 0
showStats = true

// Weapons
weaponInventory = array_create(inventorySize, noone)
for (var i = 0; i < inventorySize; i++)
{
	weaponInventory[i] = acquireWeapon(WEAPON.fists, id, i==activeInventorySlot) // Fists
	weaponInventory[i].playerInventorySlot = i
}
//weaponInventory[0] = acquireWeapon(WEAPON.sword, id)				// For testing
//weaponInventory[1] = acquireWeapon(WEAPON.shotgun, id, false)	// For testing
tempWeaponSlot = acquireWeapon(WEAPON.fists, id, false) // For one time use weapons

ignoreInputBuffer = new Cooldown(40)	// To prevent the player from shooting right away

// Buffs
buffs = []
