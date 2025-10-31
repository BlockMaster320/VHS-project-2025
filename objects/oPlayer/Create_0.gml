// Player variables ----------------------------------

walkSpd = 2


// Momentum ----------------------------------

whsp = 0	// Horizontal walking speed
wvsp = 0	// Vertical walking speed

hsp = 0		// Total horizontal speed
vsp = 0		// Total horizontal speed

// Weapon inventory --------------------------

#macro INVENTORY_SIZE 2
weaponInventory = array_create(INVENTORY_SIZE, noone)
weaponInventory[0] = json_parse(global.weaponListJSON[0])
weaponInventory[1] = json_parse(global.weaponListJSON[1]) // Fists
activeWeaponSlot = 0
weaponInventory[activeWeaponSlot].active = true

// Misc ---------------------------------

window_set_cursor(cr_cross)
//cursor_sprite = sCursor
//game_set_speed(60, gamespeed_fps)

// Player draw logic
playerController = new CharacterController(self, new CharacterAnimation(PlayerAnimation))