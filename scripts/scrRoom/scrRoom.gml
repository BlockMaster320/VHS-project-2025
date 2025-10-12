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
				var _data = oRoomManager.roomTypes[roomType][_y * ROOM_SIZE + _x];
				tilemap_set(oRoomManager.mapId, _data, _roomX + _x, _roomY + _y);
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
			
			tilemap_set(oRoomManager.mapId, 0, _roomX + ROOM_SIZE - 1, _roomY + (ROOM_SIZE div 2) - 1);
			tilemap_set(oRoomManager.mapId, 0, _roomX + ROOM_SIZE - 1, _roomY + (ROOM_SIZE div 2));
			tilemap_set(oRoomManager.mapId, 0, _roomX + ROOM_SIZE,     _roomY + (ROOM_SIZE div 2) - 1);
			tilemap_set(oRoomManager.mapId, 0, _roomX + ROOM_SIZE,     _roomY + (ROOM_SIZE div 2));
		}
		
		var _roomIsLeft = ds_map_exists(oRoomManager.rooms, string([roomX - 1, roomY]));
		if (!_roomIsLeft && random(1) < roomDepth) {
			var _room = new Room(roomX - 1, roomY, roomDepth * GENERATION_FALLOFF);
			ds_list_add(nextRooms, _room);
			entrySides[1] = true;
			_room.entrySides[0] = true;
			_room.Generate();
			
			tilemap_set(oRoomManager.mapId, 0, _roomX,     _roomY + (ROOM_SIZE div 2) - 1);
			tilemap_set(oRoomManager.mapId, 0, _roomX,     _roomY + (ROOM_SIZE div 2));
			tilemap_set(oRoomManager.mapId, 0, _roomX - 1, _roomY + (ROOM_SIZE div 2) - 1);
			tilemap_set(oRoomManager.mapId, 0, _roomX - 1, _roomY + (ROOM_SIZE div 2));
		}
		
		var _roomIsDown = ds_map_exists(oRoomManager.rooms, string([roomX, roomY + 1]));
		if (!_roomIsDown && random(1) < roomDepth) {
			var _room = new Room(roomX, roomY + 1, roomDepth * GENERATION_FALLOFF);
			ds_list_add(nextRooms, _room);
			entrySides[2] = true;
			_room.entrySides[3] = true;
			_room.Generate();
			
			tilemap_set(oRoomManager.mapId, 0, _roomX + (ROOM_SIZE div 2),     _roomY + ROOM_SIZE - 1);
			tilemap_set(oRoomManager.mapId, 0, _roomX + (ROOM_SIZE div 2),     _roomY + ROOM_SIZE);
			tilemap_set(oRoomManager.mapId, 0, _roomX + (ROOM_SIZE div 2) - 1, _roomY + ROOM_SIZE - 1);
			tilemap_set(oRoomManager.mapId, 0, _roomX + (ROOM_SIZE div 2) - 1, _roomY + ROOM_SIZE);
		}
		
		var _roomIsUp = ds_map_exists(oRoomManager.rooms, string([roomX, roomY - 1]));
		if (!_roomIsUp && random(1) < roomDepth) {
			var _room = new Room(roomX, roomY - 1, roomDepth * GENERATION_FALLOFF);
			ds_list_add(nextRooms, _room);
			entrySides[3] = true;
			_room.entrySides[2] = true;
			_room.Generate();
			
			tilemap_set(oRoomManager.mapId, 0, _roomX + (ROOM_SIZE div 2),     _roomY - 1);
			tilemap_set(oRoomManager.mapId, 0, _roomX + (ROOM_SIZE div 2),     _roomY);
			tilemap_set(oRoomManager.mapId, 0, _roomX + (ROOM_SIZE div 2) - 1, _roomY - 1);
			tilemap_set(oRoomManager.mapId, 0, _roomX + (ROOM_SIZE div 2) - 1, _roomY);
		}
	}
	
	// Renders the room (and its adjacent room) on the minimap
	RenderMinimap = function(_surf) {
		var _playerMinimapX = (oPlayer.x - FLOOR_CENTER_X) * (MINIMAP_ROOM_SIZE / (ROOM_SIZE * TILE_SIZE));
		var _playerMinimapY = (oPlayer.y - FLOOR_CENTER_Y) * (MINIMAP_ROOM_SIZE / (ROOM_SIZE * TILE_SIZE));
		var _centerX = MINIMAP_SURF_W * 0.5 - _playerMinimapX;
		var _centerY = MINIMAP_SURF_H * 0.5 - _playerMinimapY;
		var _x = _centerX + roomX * (MINIMAP_ROOM_SIZE + MINIMAP_ROOM_SPACING);
		var _y = _centerY + roomY * (MINIMAP_ROOM_SIZE + MINIMAP_ROOM_SPACING);
		draw_rectangle_color(_x - MINIMAP_ROOM_SIZE * 0.5, _y - MINIMAP_ROOM_SIZE * 0.5,
							 _x + MINIMAP_ROOM_SIZE * 0.5, _y + MINIMAP_ROOM_SIZE * 0.5,
							 c_dkgray, c_dkgray, c_dkgray, c_dkgray, false);

		draw_circle_color(_centerX + _playerMinimapX, _centerY + _playerMinimapY, 5, c_red, c_red, false);
		
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
			tilemap_set(oRoomManager.mapId, 5, _roomX + ROOM_SIZE - 1, _roomY + (ROOM_SIZE div 2) - 1);
			tilemap_set(oRoomManager.mapId, 5, _roomX + ROOM_SIZE - 1, _roomY + (ROOM_SIZE div 2));
		}
		if (entrySides[1]) {
			tilemap_set(oRoomManager.mapId, 5, _roomX, _roomY + (ROOM_SIZE div 2) - 1);
			tilemap_set(oRoomManager.mapId, 5, _roomX, _roomY + (ROOM_SIZE div 2));
		}
		if (entrySides[2]) {
			tilemap_set(oRoomManager.mapId, 5, _roomX + (ROOM_SIZE div 2),	   _roomY + ROOM_SIZE - 1);
			tilemap_set(oRoomManager.mapId, 5, _roomX + (ROOM_SIZE div 2) - 1, _roomY + ROOM_SIZE - 1);
		}
		if (entrySides[3]) {
			tilemap_set(oRoomManager.mapId, 5, _roomX + (ROOM_SIZE div 2),	   _roomY);
			tilemap_set(oRoomManager.mapId, 5, _roomX + (ROOM_SIZE div 2) - 1, _roomY);
		}
		
		// Spawn enemies
		repeat(5) {
			var _enemyX = (_roomX + random_range(1, ROOM_SIZE - 1)) * TILE_SIZE;
			var _enemyY = (_roomY + random_range(1, ROOM_SIZE - 1)) * TILE_SIZE;
			show_debug_message("pX: " + string(oPlayer.x));
			show_debug_message("eX: " + string(_enemyX));
			var _enemy = instance_create_layer(_enemyX, _enemyY, "Instances", oEnemy);
			ds_list_add(enemies, _enemy);
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
				tilemap_set(oRoomManager.mapId, 0, _roomX + ROOM_SIZE - 1, _roomY + (ROOM_SIZE div 2) - 1);
				tilemap_set(oRoomManager.mapId, 0, _roomX + ROOM_SIZE - 1, _roomY + (ROOM_SIZE div 2));
			}
			if (entrySides[1]) {
				tilemap_set(oRoomManager.mapId, 0, _roomX, _roomY + (ROOM_SIZE div 2) - 1);
				tilemap_set(oRoomManager.mapId, 0, _roomX, _roomY + (ROOM_SIZE div 2));
			}
			if (entrySides[2]) {
				tilemap_set(oRoomManager.mapId, 0, _roomX + (ROOM_SIZE div 2),	   _roomY + ROOM_SIZE - 1);
				tilemap_set(oRoomManager.mapId, 0, _roomX + (ROOM_SIZE div 2) - 1, _roomY + ROOM_SIZE - 1);
			}
			if (entrySides[3]) {
				tilemap_set(oRoomManager.mapId, 0, _roomX + (ROOM_SIZE div 2),	   _roomY);
				tilemap_set(oRoomManager.mapId, 0, _roomX + (ROOM_SIZE div 2) - 1, _roomY);
			}
			
			cleared = true;
		}
	}
}