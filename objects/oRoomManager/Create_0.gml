// Minimap
minimapSurf = surface_create(MINIMAP_SURF_W, MINIMAP_SURF_H);

// Get the tilemap
var _layerWall = layer_get_id("TilesWall");	// wall collision tiles
var _layerDec1 = layer_get_id("TilesDec1"); // floor tiles (behind wall tiles)
var _layerDec2 = layer_get_id("TilesDec2");	// main decoration tiles
var _layerDec3 = layer_get_id("TilesDec3");	// shadow tiles
tileMapWall = layer_tilemap_get_id(_layerWall);
tileMapDec1 = layer_tilemap_get_id(_layerDec1);
tileMapDec2 = layer_tilemap_get_id(_layerDec2);
tileMapDec3 = layer_tilemap_get_id(_layerDec3);

// Rooms
roomTypes = array_create(ROOM_COUNT);
areRoomsScanned = false; 
rooms = ds_map_create();
currentRoom = noone;

// Grid for enemy AI
wallGrid = ds_grid_create(ROOM_SIZE, ROOM_SIZE);
pathfindingGrid = mp_grid_create(0, 0, ROOM_SIZE, ROOM_SIZE, TILE_SIZE, TILE_SIZE)

// Randomize the game seed
randomize();

// Player progression
oPlayer.x = FLOOR_CENTER_X;
oPlayer.y = FLOOR_CENTER_Y;
currentRoom = noone;
playerTileX = 0;
playerTileY = 0;
playerRoomX = 0;
playerRoomY = 0;
playerRoomXPrev = 0;
playerRoomYPrev = 0;

playerRoomXpx = 0
playerRoomYpx = 0
roomSizePx = ROOM_SIZE * TILE_SIZE
