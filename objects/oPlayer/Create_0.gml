// Get generic attributes
event_inherited()
characterCreate(CHARACTER_TYPE.player);

// Player attributes ------------------------

walkSpd = 2
hp = 10

// Inventory --------------------------

#macro INVENTORY_SIZE 2
activeInventorySlot = 0

// Weapons
weaponInventory = array_create(INVENTORY_SIZE, noone)
//weaponInventory[0] = acquireWeapon(1, id) // Fists
weaponInventory[0] = acquireWeapon(0, id) // For testing
weaponInventory[1] = acquireWeapon(1, id, false) // Fists

// Buffs
buffsInventory = array_create(INVENTORY_SIZE)
for (var i = 0; i < array_length(buffsInventory); i++)
	buffsInventory[i] = array_create(0)

// Misc ---------------------------------

window_set_cursor(cr_cross)
//window_set_cursor(cr_none)
//cursor_sprite = sCursor
//display_set_timing_method(tm_sleep)		// Turn off vsync
