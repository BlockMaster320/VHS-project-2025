// Contains IDs of tiles in the position of the tile in all the tileset layers
function tile(_tileWall, _tileDec1, _tileDec2, _tileDec3) constructor {
	tileWall = _tileWall;
	tileDec1 = _tileDec1;
	tileDec2 = _tileDec2;
	tileDec3 = _tileDec3;
}

// Represents a specific room in the floor
function Room(_x, _y, _depth, _type = noone) constructor {
	// Set room attributes
	roomX = _x; roomY = _y;
	roomType = _type;
	if (roomType = noone) roomType = floor(random(ROOM_COUNT));
	roomDepth = _depth;
	nextRooms = ds_list_create();
	
	discovered = false;
	cleared = false;
	enemies = ds_list_create();
	entrySides = [false, false, false, false];	// right, left, bottom, top
	
	ds_map_add(oRoomManager.rooms, string([roomX, roomY]), self);

	// Generates the room (sets the tiles and creates adjacent rooms)
	Generate = function() {
		var _roomX = floor(FLOOR_CENTER_X / TILE_SIZE - ROOM_SIZE / 2) + roomX * ROOM_SIZE;	// room position in tiles
		var _roomY = floor(FLOOR_CENTER_Y / TILE_SIZE - ROOM_SIZE / 2) + roomY * ROOM_SIZE;
		
		// Set the room's tiles
		for (var _y = 0; _y < ROOM_SIZE; _y++) {
			for (var _x = 0; _x < ROOM_SIZE; _x++) {
				var _tile = oRoomManager.roomTypes[roomType][_y * ROOM_SIZE + _x];	// retreive the tile struct at the position
				
				tilemap_set(oRoomManager.tileMapWall, _tile.tileWall, _roomX + _x, _roomY + _y);
				tilemap_set(oRoomManager.tileMapDec1, _tile.tileDec1, _roomX + _x, _roomY + _y);
				tilemap_set(oRoomManager.tileMapDec2, _tile.tileDec2, _roomX + _x, _roomY + _y);
				tilemap_set(oRoomManager.tileMapDec3, _tile.tileDec3, _roomX + _x, _roomY + _y);
			}
		}
		
		// Generate adjacent rooms
		if (roomDepth < 0.1) return;
		var _roomGenerated = false;
		
		var _roomIsRight = ds_map_exists(oRoomManager.rooms, string([roomX + 1, roomY]));
		if (!_roomIsRight && random(1) < roomDepth) {
			var _room = new Room(roomX + 1, roomY, roomDepth * GENERATION_FALLOFF);
			ds_list_add(nextRooms, _room);
			entrySides[0] = true;
			_room.entrySides[1] = true;
			_room.Generate();
			
			tilemap_set(oRoomManager.tileMapWall, 0, _roomX + ROOM_SIZE - 1, _roomY + (ROOM_SIZE div 2) - 1);	// unset wall tiles
			tilemap_set(oRoomManager.tileMapWall, 0, _roomX + ROOM_SIZE - 1, _roomY + (ROOM_SIZE div 2));
			tilemap_set(oRoomManager.tileMapWall, 0, _roomX + ROOM_SIZE,     _roomY + (ROOM_SIZE div 2) - 1);
			tilemap_set(oRoomManager.tileMapWall, 0, _roomX + ROOM_SIZE,     _roomY + (ROOM_SIZE div 2));
			
			tilemap_set(oRoomManager.tileMapDec1, 1, _roomX + ROOM_SIZE - 1, _roomY + (ROOM_SIZE div 2) - 1);	// set floor tiles
			tilemap_set(oRoomManager.tileMapDec1, 1, _roomX + ROOM_SIZE - 1, _roomY + (ROOM_SIZE div 2));
			tilemap_set(oRoomManager.tileMapDec1, 1, _roomX + ROOM_SIZE,     _roomY + (ROOM_SIZE div 2) - 1);
			tilemap_set(oRoomManager.tileMapDec1, 1, _roomX + ROOM_SIZE,     _roomY + (ROOM_SIZE div 2));
			
			tilemap_set(oRoomManager.tileMapWall, 40, _roomX + ROOM_SIZE - 1, _roomY + (ROOM_SIZE div 2) - 2);	// set wall tiles around the doors
			tilemap_set(oRoomManager.tileMapWall, 34, _roomX + ROOM_SIZE - 1, _roomY + (ROOM_SIZE div 2) + 1);
			tilemap_set(oRoomManager.tileMapWall, 38, _roomX + ROOM_SIZE,     _roomY + (ROOM_SIZE div 2) - 2);
			tilemap_set(oRoomManager.tileMapWall, 36, _roomX + ROOM_SIZE,     _roomY + (ROOM_SIZE div 2) + 1);
		}
		
		var _roomIsLeft = ds_map_exists(oRoomManager.rooms, string([roomX - 1, roomY]));
		if (!_roomIsLeft && random(1) < roomDepth) {
			var _room = new Room(roomX - 1, roomY, roomDepth * GENERATION_FALLOFF);
			ds_list_add(nextRooms, _room);
			entrySides[1] = true;
			_room.entrySides[0] = true;
			_room.Generate();
			
			tilemap_set(oRoomManager.tileMapWall, 0, _roomX,     _roomY + (ROOM_SIZE div 2) - 1);	// unset wall tiles
			tilemap_set(oRoomManager.tileMapWall, 0, _roomX,     _roomY + (ROOM_SIZE div 2));
			tilemap_set(oRoomManager.tileMapWall, 0, _roomX - 1, _roomY + (ROOM_SIZE div 2) - 1);
			tilemap_set(oRoomManager.tileMapWall, 0, _roomX - 1, _roomY + (ROOM_SIZE div 2));
			
			tilemap_set(oRoomManager.tileMapDec1, 1, _roomX,	 _roomY + (ROOM_SIZE div 2) - 1);	// set floor tiles
			tilemap_set(oRoomManager.tileMapDec1, 1, _roomX,	 _roomY + (ROOM_SIZE div 2));
			tilemap_set(oRoomManager.tileMapDec1, 1, _roomX - 1, _roomY + (ROOM_SIZE div 2) - 1);
			tilemap_set(oRoomManager.tileMapDec1, 1, _roomX - 1, _roomY + (ROOM_SIZE div 2));
			
			tilemap_set(oRoomManager.tileMapWall, 38, _roomX,	  _roomY + (ROOM_SIZE div 2) - 2);	// set wall tiles around the doors
			tilemap_set(oRoomManager.tileMapWall, 36, _roomX,	  _roomY + (ROOM_SIZE div 2) + 1);
			tilemap_set(oRoomManager.tileMapWall, 40, _roomX - 1, _roomY + (ROOM_SIZE div 2) - 2);
			tilemap_set(oRoomManager.tileMapWall, 34, _roomX - 1, _roomY + (ROOM_SIZE div 2) + 1);
		}
		
		var _roomIsDown = ds_map_exists(oRoomManager.rooms, string([roomX, roomY + 1]));
		if (!_roomIsDown && random(1) < roomDepth) {
			var _room = new Room(roomX, roomY + 1, roomDepth * GENERATION_FALLOFF);
			ds_list_add(nextRooms, _room);
			entrySides[2] = true;
			_room.entrySides[3] = true;
			_room.Generate();
			
			tilemap_set(oRoomManager.tileMapWall, 0, _roomX + (ROOM_SIZE div 2),     _roomY + ROOM_SIZE - 1);	// unset wall tiles
			tilemap_set(oRoomManager.tileMapWall, 0, _roomX + (ROOM_SIZE div 2),     _roomY + ROOM_SIZE);
			tilemap_set(oRoomManager.tileMapWall, 0, _roomX + (ROOM_SIZE div 2) - 1, _roomY + ROOM_SIZE - 1);
			tilemap_set(oRoomManager.tileMapWall, 0, _roomX + (ROOM_SIZE div 2) - 1, _roomY + ROOM_SIZE);
			
			tilemap_set(oRoomManager.tileMapDec1, 1, _roomX + (ROOM_SIZE div 2),     _roomY + ROOM_SIZE - 1);	// set floor tiles
			tilemap_set(oRoomManager.tileMapDec1, 1, _roomX + (ROOM_SIZE div 2),     _roomY + ROOM_SIZE);
			tilemap_set(oRoomManager.tileMapDec1, 1, _roomX + (ROOM_SIZE div 2) - 1, _roomY + ROOM_SIZE - 1);
			tilemap_set(oRoomManager.tileMapDec1, 1, _roomX + (ROOM_SIZE div 2) - 1, _roomY + ROOM_SIZE);
		}
		
		var _roomIsUp = ds_map_exists(oRoomManager.rooms, string([roomX, roomY - 1]));
		if (!_roomIsUp && random(1) < roomDepth) {
			var _room = new Room(roomX, roomY - 1, roomDepth * GENERATION_FALLOFF);
			ds_list_add(nextRooms, _room);
			entrySides[3] = true;
			_room.entrySides[2] = true;
			_room.Generate();
			
			tilemap_set(oRoomManager.tileMapWall, 0, _roomX + (ROOM_SIZE div 2),     _roomY - 1);	// unset wall tiles
			tilemap_set(oRoomManager.tileMapWall, 0, _roomX + (ROOM_SIZE div 2),     _roomY);
			tilemap_set(oRoomManager.tileMapWall, 0, _roomX + (ROOM_SIZE div 2) - 1, _roomY - 1);
			tilemap_set(oRoomManager.tileMapWall, 0, _roomX + (ROOM_SIZE div 2) - 1, _roomY);
			
			tilemap_set(oRoomManager.tileMapDec1, 1, _roomX + (ROOM_SIZE div 2) - 1, _roomY - 1);	// set floor tiles
			tilemap_set(oRoomManager.tileMapDec1, 1, _roomX + (ROOM_SIZE div 2) - 1, _roomY);
			tilemap_set(oRoomManager.tileMapDec1, 1, _roomX + (ROOM_SIZE div 2),     _roomY - 1);
			tilemap_set(oRoomManager.tileMapDec1, 1, _roomX + (ROOM_SIZE div 2),     _roomY);
		}
	}
	
	// Renders the room (and its adjacent room) on the minimap
	RenderMinimap = function(_surf) {
		if (!discovered) return;
		
		var _playerMinimapX = (oPlayer.x - FLOOR_CENTER_X) * ((MINIMAP_ROOM_SIZE + MINIMAP_ROOM_SPACING) / (ROOM_SIZE * TILE_SIZE));
		var _playerMinimapY = (oPlayer.y - FLOOR_CENTER_Y) * ((MINIMAP_ROOM_SIZE + MINIMAP_ROOM_SPACING) / (ROOM_SIZE * TILE_SIZE));
		var _centerX = MINIMAP_SURF_W * 0.5 - _playerMinimapX;
		var _centerY = MINIMAP_SURF_H * 0.5 - _playerMinimapY;
		var _x = _centerX + roomX * (MINIMAP_ROOM_SIZE + MINIMAP_ROOM_SPACING);
		var _y = _centerY + roomY * (MINIMAP_ROOM_SIZE + MINIMAP_ROOM_SPACING);
		
		draw_rectangle_color(_x - MINIMAP_ROOM_SIZE * 0.5, _y - MINIMAP_ROOM_SIZE * 0.5,
							 _x + MINIMAP_ROOM_SIZE * 0.5, _y + MINIMAP_ROOM_SIZE * 0.5,
							 c_dkgray, c_dkgray, c_dkgray, c_dkgray, false);
		
		// Draw bridges between the rooms
		if (entrySides[0]) {
			draw_rectangle_color(_x,
								 _y - MINIMAP_BRIDGE_SIZE * 0.5,
								 _x + (MINIMAP_ROOM_SIZE * 0.5 + MINIMAP_ROOM_SPACING),
								 _y + MINIMAP_BRIDGE_SIZE * 0.5,
								 c_dkgray, c_dkgray, c_dkgray, c_dkgray, false);
		}
		if (entrySides[1]) {
			draw_rectangle_color(_x,
								 _y - MINIMAP_BRIDGE_SIZE * 0.5,
								 _x - (MINIMAP_ROOM_SIZE * 0.5 + MINIMAP_ROOM_SPACING),
								 _y + MINIMAP_BRIDGE_SIZE * 0.5,
								 c_dkgray, c_dkgray, c_dkgray, c_dkgray, false);
		}
		if (entrySides[2]) {
			draw_rectangle_color(_x - MINIMAP_BRIDGE_SIZE * 0.5, _y,
								 _x + MINIMAP_BRIDGE_SIZE * 0.5, _y + (MINIMAP_ROOM_SIZE * 0.5 + MINIMAP_ROOM_SPACING),
								 c_dkgray, c_dkgray, c_dkgray, c_dkgray, false);
		}
		if (entrySides[3]) {
			draw_rectangle_color(_x - MINIMAP_BRIDGE_SIZE * 0.5, _y,
								 _x + MINIMAP_BRIDGE_SIZE * 0.5, _y - (MINIMAP_ROOM_SIZE * 0.5 + MINIMAP_ROOM_SPACING),
								 c_dkgray, c_dkgray, c_dkgray, c_dkgray, false);
		}

		draw_circle_color(MINIMAP_SURF_W * 0.5,  MINIMAP_SURF_H * 0.5, 5, c_red, c_red, false);
		
		for (var _i = 0; _i < ds_list_size(nextRooms); _i++) {
			nextRooms[| _i].RenderMinimap(_surf);
		}
	}
	
	// Locks the room and spawns enemies
	LockRoom = function() {
		// Lock all entries to the room
		var _roomX = floor(FLOOR_CENTER_X / TILE_SIZE - ROOM_SIZE / 2) + roomX * ROOM_SIZE;	// room position in tiles
		var _roomY = floor(FLOOR_CENTER_Y / TILE_SIZE - ROOM_SIZE / 2) + roomY * ROOM_SIZE;
		
		if (entrySides[0]) {
			tilemap_set(oRoomManager.tileMapWall, 5, _roomX + ROOM_SIZE - 1, _roomY + (ROOM_SIZE div 2) - 1);
			tilemap_set(oRoomManager.tileMapWall, 5, _roomX + ROOM_SIZE - 1, _roomY + (ROOM_SIZE div 2));
		}
		if (entrySides[1]) {
			tilemap_set(oRoomManager.tileMapWall, 5, _roomX, _roomY + (ROOM_SIZE div 2) - 1);
			tilemap_set(oRoomManager.tileMapWall, 5, _roomX, _roomY + (ROOM_SIZE div 2));
		}
		if (entrySides[2]) {
			tilemap_set(oRoomManager.tileMapWall, 5, _roomX + (ROOM_SIZE div 2),	   _roomY + ROOM_SIZE - 1);
			tilemap_set(oRoomManager.tileMapWall, 5, _roomX + (ROOM_SIZE div 2) - 1, _roomY + ROOM_SIZE - 1);
		}
		if (entrySides[3]) {
			tilemap_set(oRoomManager.tileMapWall, 5, _roomX + (ROOM_SIZE div 2),	   _roomY);
			tilemap_set(oRoomManager.tileMapWall, 5, _roomX + (ROOM_SIZE div 2) - 1, _roomY);
		}
		
		// Spawn enemies
		
		var enemiesSpawned = 0
		
		while (enemiesSpawned < 1) {
			var _enemyX = (_roomX + random_range(1, ROOM_SIZE - 1)) * TILE_SIZE;
			var _enemyY = (_roomY + random_range(1, ROOM_SIZE - 1)) * TILE_SIZE;
			
			var mapWidth  = tilemap_get_width(global.tilemapCollision);
			var mapHeight = tilemap_get_height(global.tilemapCollision);
			//var tileX = clamp(floor(_enemyX / TILE_SIZE), 0, mapWidth - 1);
			//var tileY = clamp(floor(_enemyY / TILE_SIZE), 0, mapHeight - 1);
			var tileId = tilemap_get_at_pixel(global.tilemapCollision, _enemyX, _enemyY)
			
			if (tileId == 0) //_enemy.controller.setState(CharacterState.Dead)
			{
				var _enemy = instance_create_layer(_enemyX, _enemyY, "Instances", oEnemy);
				with(_enemy) { characterCreate(CHARACTER_TYPE.ghoster); }
				
				ds_list_add(enemies, _enemy);
				enemiesSpawned++
			}
		}
		
		// Generate pathfinding grid for enemy AI
		with (oRoomManager)
		{
			for (var _y = 0; _y < ROOM_SIZE; _y++) {
				for (var _x = 0; _x < ROOM_SIZE; _x++) {
					var _tile = roomTypes[other.roomType][_y * ROOM_SIZE + _x];	// retreive the tile struct at the position
					wallGrid[# _x, _y] = (_tile.tileWall == 0) ? 0 : 1;
				}
			}
			pathfindingGrid = mp_grid_create(_roomX * TILE_SIZE, _roomY * TILE_SIZE, ROOM_SIZE, ROOM_SIZE, TILE_SIZE, TILE_SIZE)
			ds_grid_to_mp_grid(wallGrid, pathfindingGrid)
		}
	}
	
	// Kills and removes specified enemy object from the room
	KillEnemy = function(_enemyID) {
		for (var _i = 0; _i < ds_list_size(enemies); _i++) {
			if (enemies[| _i] == _enemyID) {
				instance_destroy(_enemyID);
				ds_list_delete(enemies, _i);
				return;
			}
		}
	}
	
	// Checks whether the room is cleared (no enemies) and if it is, opens the entries
	CheckCleared = function() {
		if (ds_list_empty(enemies)) {
			// Open all entries to the room
			var _roomX = floor(FLOOR_CENTER_X / TILE_SIZE - ROOM_SIZE / 2) + roomX * ROOM_SIZE;	// room position in tiles
			var _roomY = floor(FLOOR_CENTER_Y / TILE_SIZE - ROOM_SIZE / 2) + roomY * ROOM_SIZE;
		
			if (entrySides[0]) {
				tilemap_set(oRoomManager.tileMapWall, 0, _roomX + ROOM_SIZE - 1, _roomY + (ROOM_SIZE div 2) - 1);
				tilemap_set(oRoomManager.tileMapWall, 0, _roomX + ROOM_SIZE - 1, _roomY + (ROOM_SIZE div 2));
			}
			if (entrySides[1]) {
				tilemap_set(oRoomManager.tileMapWall, 0, _roomX, _roomY + (ROOM_SIZE div 2) - 1);
				tilemap_set(oRoomManager.tileMapWall, 0, _roomX, _roomY + (ROOM_SIZE div 2));
			}
			if (entrySides[2]) {
				tilemap_set(oRoomManager.tileMapWall, 0, _roomX + (ROOM_SIZE div 2),	   _roomY + ROOM_SIZE - 1);
				tilemap_set(oRoomManager.tileMapWall, 0, _roomX + (ROOM_SIZE div 2) - 1, _roomY + ROOM_SIZE - 1);
			}
			if (entrySides[3]) {
				tilemap_set(oRoomManager.tileMapWall, 0, _roomX + (ROOM_SIZE div 2),	   _roomY);
				tilemap_set(oRoomManager.tileMapWall, 0, _roomX + (ROOM_SIZE div 2) - 1, _roomY);
			}
			
			cleared = true;
		}
	}
}