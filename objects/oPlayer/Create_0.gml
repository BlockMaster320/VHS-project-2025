// Player variables ----------------------------------

walkSpd = 2


// Momentum ----------------------------------

whsp = 0	// Horizontal walking speed
wvsp = 0	// Vertical walking speed

hsp = 0		// Total horizontal speed
vsp = 0		// Total horizontal speed


// Collision ----------------------------------

tilemap = layer_tilemap_get_id("TilesWall")


// Weapon inventory --------------------------

#macro INVENTORY_SIZE 3
weaponInventory = array_create(INVENTORY_SIZE, noone)
weaponInventory[0] = json_parse(global.weaponListJSON[0])
weaponInventory[0].active = true


// Misc ---------------------------------

window_set_cursor(cr_cross)
//cursor_sprite = sCursor
//game_set_speed(60, gamespeed_fps)