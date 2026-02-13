// Minimap
minimapSurf = surface_create(MINIMAP_SURF_W, MINIMAP_SURF_H);
statsAlpha = 1;

// Get the tilemap
var _layerWall = layer_get_id("TilesWall");	// wall collision tiles
var _layerDec1 = layer_get_id("TilesDec1"); // floor tiles (behind wall tiles)
var _layerDec2 = layer_get_id("TilesDec2");	// main decoration tiles
var _layerDec3 = layer_get_id("TilesDec3");	// shadow tiles

if (oController.currentFloor == 1) { // change tileset layers for second floor
	layer_set_visible(_layerWall, false);
	layer_set_visible(_layerDec1, false);
	
	_layerWall = layer_get_id("TilesWallToxic");	// wall collision tiles
	_layerDec1 = layer_get_id("TilesDec1Toxic"); // floor tiles (behind wall tiles)
	
	layer_set_visible(_layerWall, true);
	layer_set_visible(_layerDec1, true);
}

tileMapWall = layer_tilemap_get_id(_layerWall);
tileMapDec1 = layer_tilemap_get_id(_layerDec1);
tileMapDec2 = layer_tilemap_get_id(_layerDec2);
tileMapDec3 = layer_tilemap_get_id(_layerDec3);

// Rooms
roomTypes = array_create(ROOM_COUNT);
areRoomsScanned = false; 
rooms = ds_map_create();
currentRoom = noone;
mostDistantRooms = [noone, noone, noone, noone];
shopsGenerated = 0;

// Grid for enemy AI
wallGrid = ds_grid_create(ROOM_SIZE, ROOM_SIZE);
pathfindingGrid = mp_grid_create(0, 0, ROOM_SIZE, ROOM_SIZE, TILE_SIZE, TILE_SIZE)

global.tilemapCollision = tileMapWall
oController.pfGrid = pathfindingGrid

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

// Helpers
killAllEnemies = function() {
	with (oEnemy) oRoomManager.currentRoom.KillEnemy(id);
}

killAllEnemyProjectiles = function() {
	oRoomManager.currentRoom.RemoveProjectiles();
}