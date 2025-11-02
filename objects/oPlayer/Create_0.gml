// Player variables ----------------------------------

walkSpd = 2


// Momentum ----------------------------------

whsp = 0	// Horizontal walking speed
wvsp = 0	// Vertical walking speed

hsp = 0		// Total horizontal speed
vsp = 0		// Total horizontal speed


// Inventory --------------------------

#macro INVENTORY_SIZE 2
activeInventorySlot = 0

// Weapons
weaponInventory = array_create(INVENTORY_SIZE, noone)
weaponInventory[0] = json_parse(global.weaponDatabaseJSON[1]) // Fists
weaponInventory[1] = json_parse(global.weaponDatabaseJSON[1]) // Fists
weaponInventory[1].active = false

// Buffs
buffsInventory = array_create(INVENTORY_SIZE)
for (var i = 0; i < array_length(buffsInventory); i++)
	buffsInventory[i] = array_create(0)

// Misc ---------------------------------

window_set_cursor(cr_cross)
//cursor_sprite = sCursor
//game_set_speed(60, gamespeed_fps)


// Player draw logic
playerController = new CharacterController(self, new CharacterAnimation(PlayerAnimation))