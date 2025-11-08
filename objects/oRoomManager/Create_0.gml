// Minimap
minimapSurf = surface_create(MINIMAP_SURF_W, MINIMAP_SURF_H);

// Get the tilemap
var _layerWall = layer_get_id("TilesWall");	// wall collision tiles
var _layerDec1 = layer_get_id("TilesDec1"); // floor tiles (behind wall tiles)
var _layerDec2 = layer_get_id("TilesDec2");	// other decoration tiles
var _layerDec3 = layer_get_id("TilesDec3");	// shadow tiles
tileMapWall = layer_tilemap_get_id(_layerWall);
tileMapDec1 = layer_tilemap_get_id(_layerDec1);
tileMapDec2 = layer_tilemap_get_id(_layerDec2);
tileMapDec3 = layer_tilemap_get_id(_layerDec3);

roomTypes = array_create(ROOM_COUNT);

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

// Scan and save all the room types
var _roomX = ROOM_SCAN_X;
var _roomY = ROOM_SCAN_Y;
for (var _room = 0; _room < ROOM_COUNT; _room++) {
	
    var _tiles = array_create(ROOM_SIZE * ROOM_SIZE);
    for (var _y = 0; _y < ROOM_SIZE; _y++) {
        for (var _x = 0; _x < ROOM_SIZE; _x++) {

            var _dataWall = tilemap_get(tileMapWall, _roomX + _x, _roomY + _y);
            var _dataDec1 = tilemap_get(tileMapDec1, _roomX + _x, _roomY + _y);
            var _dataDec2 = tilemap_get(tileMapDec2, _roomX + _x, _roomY + _y);
            var _dataDec3 = tilemap_get(tileMapDec3, _roomX + _x, _roomY + _y);
            _tiles[_y * ROOM_SIZE + _x] = new tile(_dataWall, _dataDec1, _dataDec2, _dataDec3);
        }
    }

    roomTypes[_room] = _tiles;
    _roomY += ROOM_SIZE + ROOM_OFFSET;
}


// Generate the floor
rooms = ds_map_create();
var _room = new Room(0, 0, 1, 0);
_room.discovered = true;
_room.cleared = true;
currentRoom = _room;
_room.Generate();