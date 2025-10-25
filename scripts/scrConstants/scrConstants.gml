function Constants()
{
	enum INPUT_STATE
	{
		playing,
		menu,
		dialogue,
		dialogueMenu
	}
	
	// Map generation settings
	#macro TILE_SIZE 16		// size of 1 tile in pixels
	#macro ROOM_SIZE 16		// size of each room in tiles
	#macro ROOM_SCAN_X 1	// where to start scanning the rooms
	#macro ROOM_SCAN_Y 1
	#macro ROOM_OFFSET 1	// offset between the rooms for the scanning
	#macro ROOM_COUNT 3		// number of rooms to scan
	#macro GENERATION_FALLOFF 0.4
	//#macro ROOM_SPACING 3

	// Minimap rendering settings
	#macro MINIMAP_ROOM_SIZE 35
	#macro MINIMAP_BRIDGE_SIZE 15
	#macro MINIMAP_ROOM_SPACING 6
	#macro MINIMAP_SURF_W 300
	#macro MINIMAP_SURF_H 200
	
	#macro FLOOR_CENTER_X room_width / 2
	#macro FLOOR_CENTER_Y room_height / 2
	
	// Debug levels
	#macro SHOW_STACKTRACE false
}