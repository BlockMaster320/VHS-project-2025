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
}
InitPlayerStats()	// Do this, so we can reset player stats to default later

hp = maxHp

// Inventory --------------------------

activeInventorySlot = 0
showStats = true

// Weapons
weaponInventory = array_create(inventorySize, noone)
for (var i = 0; i < inventorySize; i++)
	weaponInventory[i] = acquireWeapon(WEAPON.fists, id, i==activeInventorySlot) // Fists
//weaponInventory[0] = acquireWeapon(WEAPON.sword, id)				// For testing
//weaponInventory[1] = acquireWeapon(WEAPON.defaultGun, id, false)	// For testing
tempWeaponSlot = acquireWeapon(WEAPON.fists, id, false) // For one time use weapons


// Buffs
buffs = []

// Misc ---------------------------------

window_set_cursor(cr_cross)
//window_set_cursor(cr_none)
//cursor_sprite = sCursor
//display_set_timing_method(tm_sleep)		// Turn off vsync
