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
#macro MINIMAP_ROOM_SIZE 70
#macro MINIMAP_ROOM_SPACING 6
#macro MINIMAP_SURF_W 300
#macro MINIMAP_SURF_H 200

minimapSurf = surface_create(MINIMAP_SURF_W, MINIMAP_SURF_H);

// Get the tilemap
var _layerId = layer_get_id("TilesWall");
mapId = layer_tilemap_get_id(_layerId);
roomTypes = array_create(ROOM_COUNT);

// Randomize the game seed
randomize();

// Player progression
#macro FLOOR_CENTER_X room_width / 2
#macro FLOOR_CENTER_Y room_height / 2
oPlayer.x = FLOOR_CENTER_X;
oPlayer.y = FLOOR_CENTER_Y;
currentRoom = noone;
playerTileX = 0;
playerTileY = 0;
playerRoomX = 0;
playerRoomY = 0;
playerRoomXPrev = 0;
playerRoomYPrev = 0;

// Scan and save all the room types
var _roomX = ROOM_SCAN_X;
var _roomY = ROOM_SCAN_Y;
for (var _room = 0; _room < ROOM_COUNT; _room++) {
	var _tiles = array_create(ROOM_SIZE * ROOM_SIZE);
	for (var _y = 0; _y < ROOM_SIZE; _y++) {
		for (var _x = 0; _x < ROOM_SIZE; _x++) {
			
			var _data = tilemap_get(mapId, _roomX + _x, _roomY + _y);
			_tiles[_y * ROOM_SIZE + _x] = _data;
		}
	}
	
	roomTypes[_room] = _tiles;
	_roomY += ROOM_SIZE + ROOM_OFFSET;
}


// Generate the floor
rooms = ds_map_create();
var _room = new Room(0, 0, 1, 0);
_room.cleared = true;
currentRoom = _room;
_room.Generate();
