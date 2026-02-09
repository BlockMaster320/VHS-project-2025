enum RoomCategory {
	ENTRANCE,
	EXIT,
	CIRCUITS,
	SHOP,
	ENEMIES
}

enum ScannedObjectType {
	INTERACTABLE,
	NPC
}

// Contains IDs of tiles in the position of the tile in all the tileset layers
function Tile(_tileWall, _tileDec1, _tileDec2, _tileDec3) constructor {
	tileWall = _tileWall;
	tileDec1 = _tileDec1;
	tileDec2 = _tileDec2;
	tileDec3 = _tileDec3;
}

function ScannedObject(_instanceID, _x, _y, _objectType) constructor {
	objectType = _objectType;
	instanceID = _instanceID;
	roomX = _x;
	roomY = _y;
}

function RoomType(_tiles, _scannedObjects, _category = noone) constructor {
	tiles = _tiles;
	scannedObjects = _scannedObjects;
	category = _category;
}

// Represents a specific room in the floor
function Room(_x, _y, _depth, _typeIndex = noone) constructor {
	// Set room attributes
	roomX = _x; roomY = _y;
	roomTypeIndex = _typeIndex;
	if (roomTypeIndex = noone) roomTypeIndex = irandom_range(4, ROOM_COUNT - 1);
	//if (roomTypeIndex = noone) roomTypeIndex = irandom_range(0, 2);
	roomDepth = _depth;
	nextRooms = ds_list_create();
	
	discovered = false;
	cleared = false;
	enemies = ds_list_create();
	doors = ds_list_create();
	entrySides = [false, false, false, false];	// right, left, bottom, top
	
	ds_map_add(oRoomManager.rooms, string([roomX, roomY]), self);
	
	// Find out if the room is the most distant room in any of the directions
	if (oRoomManager.mostDistantRooms[0] == noone || oRoomManager.mostDistantRooms[0].roomX < roomX) oRoomManager.mostDistantRooms[0] = self;
	if (oRoomManager.mostDistantRooms[1] == noone || oRoomManager.mostDistantRooms[1].roomX > roomX) oRoomManager.mostDistantRooms[1] = self;
	if (oRoomManager.mostDistantRooms[2] == noone || oRoomManager.mostDistantRooms[2].roomY > roomY) oRoomManager.mostDistantRooms[2] = self;
	if (oRoomManager.mostDistantRooms[3] == noone || oRoomManager.mostDistantRooms[3].roomY < roomY) oRoomManager.mostDistantRooms[3] = self;

	// Generates the room (sets the tiles and creates adjacent rooms)
	Generate = function() {
		var _roomX = floor(FLOOR_CENTER_X / TILE_SIZE - ROOM_SIZE / 2) + roomX * ROOM_SIZE;	// room position in tiles
		var _roomY = floor(FLOOR_CENTER_Y / TILE_SIZE - ROOM_SIZE / 2) + roomY * ROOM_SIZE;
		var _roomType = oRoomManager.roomTypes[roomTypeIndex];
		
		// Set the room's tiles
		for (var _y = 0; _y < ROOM_SIZE; _y++) {
			for (var _x = 0; _x < ROOM_SIZE; _x++) {
				var _tile = _roomType.tiles[_y * ROOM_SIZE + _x];	// retreive the tile struct at the position
				
				tilemap_set(oRoomManager.tileMapWall, _tile.tileWall, _roomX + _x, _roomY + _y);
				tilemap_set(oRoomManager.tileMapDec1, _tile.tileDec1, _roomX + _x, _roomY + _y);
				tilemap_set(oRoomManager.tileMapDec2, _tile.tileDec2, _roomX + _x, _roomY + _y);
				tilemap_set(oRoomManager.tileMapDec3, _tile.tileDec3, _roomX + _x, _roomY + _y);
			}
		}
		
	    // Spawn the room's scanned objects
		for (var _i = 0; _i < ds_list_size(_roomType.scannedObjects); _i++) {
			var _scannedObject = _roomType.scannedObjects[| _i];
			var _x = _roomX * TILE_SIZE + _scannedObject.roomX - TILE_SIZE;	// that "- TILE_SIZE" is a magic offset which corrects the position
			var _y = _roomY * TILE_SIZE + _scannedObject.roomY - TILE_SIZE;
			var _instance = instance_create_layer(_x, _y, "Instances", _scannedObject.instanceID.object_index);
			
			if (_scannedObject.objectType = ScannedObjectType.NPC) {	// setup the NPC
				with (_instance)
					characterCreate(_scannedObject.instanceID.characterType);
			}
		}
		
		// Spawn weapon and buff pickups
		if (roomTypeIndex == RoomCategory.SHOP)
		{
			var xOff = 7 * TILE_SIZE
			var yOff = 1 * TILE_SIZE
			var xx = _roomX * TILE_SIZE + ROOM_SIZE_PX/2
			var yy = _roomY * TILE_SIZE + ROOM_SIZE_PX/2 + yOff
			var _pedestalOffset = 12;
			
			var _ped1 = instance_create_layer(xx, yy + _pedestalOffset, "Instances", oPedestal);
			var _ped2 = instance_create_layer(xx - xOff, yy + _pedestalOffset, "Instances", oPedestal);
			var _ped3 = instance_create_layer(xx + xOff, yy + _pedestalOffset, "Instances", oPedestal);
			
			var buff1 = instance_create_layer(xx, yy, "Instances", oBuffPickup)
			var buff1ID = buff1.setupBuffPickupRarity(RARITY.common)
			buff1.image_index = 0;
			buff1.depth -= 20;
			
			var buff2 = instance_create_layer(xx - xOff, yy, "Instances", oBuffPickup)
			var buff2ID = buff2.setupBuffPickupRarity(RARITY.common, [buff1ID])
			buff2.image_index = 1;
			buff2.depth -= 20;
			
			var buff3 = instance_create_layer(xx + xOff, yy, "Instances", oBuffPickup)
			buff3.setupBuffPickupRarity(RARITY.common, [buff1ID, buff2ID])
			buff3.image_index = 2;
			buff3.depth -= 20;
			
			// Delete other choices on pickup
			buff1.connectedInstances = [buff2, buff3]
			buff2.connectedInstances = [buff1, buff3]
			buff3.connectedInstances = [buff1, buff2]
		}
		
		// Generate adjacent rooms
		//if (roomDepth >= MAX_DEPTH) return;
		
		for (var _dir = 0; _dir < 4; _dir++) {
			if (random(1) > 1 - roomDepth * GENERATION_FALLOFF)
				continue;
				
			var _roomTypeIndex = noone;
			if (oRoomManager.shopsGenerated < MAX_SHOPS &&
				roomDepth >= 1 && roomTypeIndex != RoomCategory.SHOP &&
				random(1) <= SHOP_SPAWN_CHANCE)
			{
				_roomTypeIndex = RoomCategory.SHOP;	// (try to) generate a shop room
			}
			GenerateAdjacentRoom(_dir, roomDepth + 1, _roomTypeIndex);
		}
	}
	
	// Generates a new room in the given direction
	GenerateAdjacentRoom = function(_dir, _depth, _roomTypeIndex) {	// _roomX/Y = position of the current room; _dir: 0=right, 1=left, 2=up, 3=down
		var _roomX = floor(FLOOR_CENTER_X / TILE_SIZE - ROOM_SIZE / 2) + roomX * ROOM_SIZE;	// room position in tiles
		var _roomY = floor(FLOOR_CENTER_Y / TILE_SIZE - ROOM_SIZE / 2) + roomY * ROOM_SIZE;
		
		var _isGenerated = false;
		switch(_dir) {
			case 0: {
				var _roomIsRight = ds_map_exists(oRoomManager.rooms, string([roomX + 1, roomY]));
				if (!_roomIsRight) {
					var _room = new Room(roomX + 1, roomY, _depth, _roomTypeIndex);
					ds_list_add(nextRooms, _room);
					entrySides[0] = true;
					_room.entrySides[1] = true;
					_room.Generate();
					_isGenerated = true;
			
					tilemap_set(oRoomManager.tileMapWall, 0, _roomX + ROOM_SIZE - 1, _roomY + (ROOM_SIZE div 2) - 1);	// unset wall tiles
					tilemap_set(oRoomManager.tileMapWall, 0, _roomX + ROOM_SIZE - 1, _roomY + (ROOM_SIZE div 2));
					tilemap_set(oRoomManager.tileMapWall, 0, _roomX + ROOM_SIZE,     _roomY + (ROOM_SIZE div 2) - 1);
					tilemap_set(oRoomManager.tileMapWall, 0, _roomX + ROOM_SIZE,     _roomY + (ROOM_SIZE div 2));
			
					tilemap_set(oRoomManager.tileMapDec1, 1, _roomX + ROOM_SIZE - 1, _roomY + (ROOM_SIZE div 2) - 1);	// set floor tiles
					tilemap_set(oRoomManager.tileMapDec1, 1, _roomX + ROOM_SIZE - 1, _roomY + (ROOM_SIZE div 2));
					tilemap_set(oRoomManager.tileMapDec1, 1, _roomX + ROOM_SIZE,     _roomY + (ROOM_SIZE div 2) - 1);
					tilemap_set(oRoomManager.tileMapDec1, 1, _roomX + ROOM_SIZE,     _roomY + (ROOM_SIZE div 2));
			
					tilemap_set(oRoomManager.tileMapWall, 40, _roomX + ROOM_SIZE - 1, _roomY + (ROOM_SIZE div 2) - 3);	// set wall tiles around the doors
					tilemap_set(oRoomManager.tileMapWall, 65, _roomX + ROOM_SIZE - 1, _roomY + (ROOM_SIZE div 2) - 2);
					tilemap_set(oRoomManager.tileMapWall, 34, _roomX + ROOM_SIZE - 1, _roomY + (ROOM_SIZE div 2) + 1);
					tilemap_set(oRoomManager.tileMapWall, 38, _roomX + ROOM_SIZE,     _roomY + (ROOM_SIZE div 2) - 3);
					tilemap_set(oRoomManager.tileMapWall, 57, _roomX + ROOM_SIZE,     _roomY + (ROOM_SIZE div 2) - 2);
					tilemap_set(oRoomManager.tileMapWall, 36, _roomX + ROOM_SIZE,     _roomY + (ROOM_SIZE div 2) + 1);
			
					var _doorX = (_roomX + ROOM_SIZE) * TILE_SIZE - sprite_get_width(sDoorSide) * 0.5;
					var _doorY = (_roomY + (ROOM_SIZE div 2)) * TILE_SIZE - sprite_get_height(sDoorSide) * 0.6;
					var _door = instance_create_layer(_doorX, _doorY, "Instances", oDoor);
					ds_list_add(doors, _door);
					ds_list_add(_room.doors, _door);
				}
				
			} break;
			
			case 1: {
				var _roomIsLeft = ds_map_exists(oRoomManager.rooms, string([roomX - 1, roomY]));
				if (!_roomIsLeft) {
					var _room = new Room(roomX - 1, roomY, _depth, _roomTypeIndex);
					ds_list_add(nextRooms, _room);
					entrySides[1] = true;
					_room.entrySides[0] = true;
					_room.Generate();
					_isGenerated = true;
			
					tilemap_set(oRoomManager.tileMapWall, 0, _roomX,     _roomY + (ROOM_SIZE div 2) - 1);	// unset wall tiles
					tilemap_set(oRoomManager.tileMapWall, 0, _roomX,     _roomY + (ROOM_SIZE div 2));
					tilemap_set(oRoomManager.tileMapWall, 0, _roomX - 1, _roomY + (ROOM_SIZE div 2) - 1);
					tilemap_set(oRoomManager.tileMapWall, 0, _roomX - 1, _roomY + (ROOM_SIZE div 2));
			
					tilemap_set(oRoomManager.tileMapDec1, 1, _roomX,	 _roomY + (ROOM_SIZE div 2) - 1);	// set floor tiles
					tilemap_set(oRoomManager.tileMapDec1, 1, _roomX,	 _roomY + (ROOM_SIZE div 2));
					tilemap_set(oRoomManager.tileMapDec1, 1, _roomX - 1, _roomY + (ROOM_SIZE div 2) - 1);
					tilemap_set(oRoomManager.tileMapDec1, 1, _roomX - 1, _roomY + (ROOM_SIZE div 2));
			
					tilemap_set(oRoomManager.tileMapWall, 40, _roomX - 1, _roomY + (ROOM_SIZE div 2) - 3);	// set wall tiles around the doors
					tilemap_set(oRoomManager.tileMapWall, 57, _roomX,	  _roomY + (ROOM_SIZE div 2) - 2);
					tilemap_set(oRoomManager.tileMapWall, 36, _roomX,	  _roomY + (ROOM_SIZE div 2) + 1);
					tilemap_set(oRoomManager.tileMapWall, 38, _roomX,     _roomY + (ROOM_SIZE div 2) - 3);
					tilemap_set(oRoomManager.tileMapWall, 65, _roomX - 1, _roomY + (ROOM_SIZE div 2) - 2);
					tilemap_set(oRoomManager.tileMapWall, 34, _roomX - 1, _roomY + (ROOM_SIZE div 2) + 1);
			
					var _doorX = _roomX * TILE_SIZE - sprite_get_width(sDoorSide) * 0.5;
					var _doorY = (_roomY + (ROOM_SIZE div 2)) * TILE_SIZE - sprite_get_height(sDoorSide) * 0.6;
					var _door = instance_create_layer(_doorX, _doorY, "Instances", oDoor);
					ds_list_add(doors, _door);
					ds_list_add(_room.doors, _door);
				}
			} break;
			
			case 2: {
				var _roomIsUp = ds_map_exists(oRoomManager.rooms, string([roomX, roomY - 1]));
				if (!_roomIsUp) {
					var _room = new Room(roomX, roomY - 1, _depth, _roomTypeIndex);
					ds_list_add(nextRooms, _room);
					entrySides[3] = true;
					_room.entrySides[2] = true;
					_room.Generate();
					_isGenerated = true;
			
					tilemap_set(oRoomManager.tileMapWall, 0, _roomX + (ROOM_SIZE div 2) - 1, _roomY - 1);	// unset wall tiles
					tilemap_set(oRoomManager.tileMapWall, 0, _roomX + (ROOM_SIZE div 2) - 1, _roomY);
					tilemap_set(oRoomManager.tileMapWall, 0, _roomX + (ROOM_SIZE div 2) - 1, _roomY + 1);
					tilemap_set(oRoomManager.tileMapWall, 0, _roomX + (ROOM_SIZE div 2),	 _roomY - 1);
					tilemap_set(oRoomManager.tileMapWall, 0, _roomX + (ROOM_SIZE div 2),     _roomY);
					tilemap_set(oRoomManager.tileMapWall, 0, _roomX + (ROOM_SIZE div 2),     _roomY + 1);
			
					tilemap_set(oRoomManager.tileMapDec1, 1, _roomX + (ROOM_SIZE div 2),     _roomY - 1);	// set floor tiles
					tilemap_set(oRoomManager.tileMapDec1, 1, _roomX + (ROOM_SIZE div 2),     _roomY);
					tilemap_set(oRoomManager.tileMapDec1, 1, _roomX + (ROOM_SIZE div 2) - 1, _roomY - 1);
					tilemap_set(oRoomManager.tileMapDec1, 1, _roomX + (ROOM_SIZE div 2) - 1, _roomY);
			
					tilemap_set(oRoomManager.tileMapWall, 36, _roomX + (ROOM_SIZE div 2) - 2, _roomY - 1);	// set wall tiles around the doors
					tilemap_set(oRoomManager.tileMapWall, 38, _roomX + (ROOM_SIZE div 2) - 2, _roomY);
					tilemap_set(oRoomManager.tileMapWall, 57, _roomX + (ROOM_SIZE div 2) - 2, _roomY + 1);
					tilemap_set(oRoomManager.tileMapWall, 34, _roomX + (ROOM_SIZE div 2) + 1, _roomY - 1);
					tilemap_set(oRoomManager.tileMapWall, 40, _roomX + (ROOM_SIZE div 2) + 1, _roomY);
					tilemap_set(oRoomManager.tileMapWall, 65, _roomX + (ROOM_SIZE div 2) + 1, _roomY + 1);
			
					var _doorX = (_roomX + (ROOM_SIZE div 2)) * TILE_SIZE - sprite_get_width(sDoorFront) * 0.5;
					var _doorY = (_roomY + 1) * TILE_SIZE - sprite_get_height(sDoorFront) * 0.4;
					var _door = instance_create_layer(_doorX, _doorY, "Instances", oDoor);
					_door.sprite_index = sDoorFront;
					ds_list_add(doors, _door);
					ds_list_add(_room.doors, _door);
				}
			} break;
			
			case 3: {
				var _roomIsDown = ds_map_exists(oRoomManager.rooms, string([roomX, roomY + 1]));
				if (!_roomIsDown) {
					var _room = new Room(roomX, roomY + 1, _depth, _roomTypeIndex);
					ds_list_add(nextRooms, _room);
					entrySides[2] = true;
					_room.entrySides[3] = true;
					_room.Generate();
					_isGenerated = true;
			
					tilemap_set(oRoomManager.tileMapWall, 0, _roomX + (ROOM_SIZE div 2) - 1, _roomY + ROOM_SIZE - 1);	// unset wall tiles
					tilemap_set(oRoomManager.tileMapWall, 0, _roomX + (ROOM_SIZE div 2) - 1, _roomY + ROOM_SIZE);
					tilemap_set(oRoomManager.tileMapWall, 0, _roomX + (ROOM_SIZE div 2) - 1, _roomY + ROOM_SIZE + 1);
					tilemap_set(oRoomManager.tileMapWall, 0, _roomX + (ROOM_SIZE div 2),	 _roomY + ROOM_SIZE - 1);
					tilemap_set(oRoomManager.tileMapWall, 0, _roomX + (ROOM_SIZE div 2),     _roomY + ROOM_SIZE);
					tilemap_set(oRoomManager.tileMapWall, 0, _roomX + (ROOM_SIZE div 2),     _roomY + ROOM_SIZE + 1);
			
					tilemap_set(oRoomManager.tileMapDec1, 1, _roomX + (ROOM_SIZE div 2),     _roomY + ROOM_SIZE - 1);	// set floor tiles
					tilemap_set(oRoomManager.tileMapDec1, 1, _roomX + (ROOM_SIZE div 2),     _roomY + ROOM_SIZE);
					tilemap_set(oRoomManager.tileMapDec1, 1, _roomX + (ROOM_SIZE div 2) - 1, _roomY + ROOM_SIZE - 1);
					tilemap_set(oRoomManager.tileMapDec1, 1, _roomX + (ROOM_SIZE div 2) - 1, _roomY + ROOM_SIZE);
			
					tilemap_set(oRoomManager.tileMapWall, 36, _roomX + (ROOM_SIZE div 2) - 2, _roomY + ROOM_SIZE - 1);	// set wall tiles around the doors
					tilemap_set(oRoomManager.tileMapWall, 38, _roomX + (ROOM_SIZE div 2) - 2, _roomY + ROOM_SIZE);
					tilemap_set(oRoomManager.tileMapWall, 57, _roomX + (ROOM_SIZE div 2) - 2, _roomY + ROOM_SIZE + 1);
					tilemap_set(oRoomManager.tileMapWall, 34, _roomX + (ROOM_SIZE div 2) + 1, _roomY + ROOM_SIZE - 1);
					tilemap_set(oRoomManager.tileMapWall, 40, _roomX + (ROOM_SIZE div 2) + 1, _roomY + ROOM_SIZE);
					tilemap_set(oRoomManager.tileMapWall, 65, _roomX + (ROOM_SIZE div 2) + 1, _roomY + ROOM_SIZE + 1);
			
					var _doorX = (_roomX + (ROOM_SIZE div 2)) * TILE_SIZE - sprite_get_width(sDoorFront) * 0.5;
					var _doorY = (_roomY + ROOM_SIZE + 1) * TILE_SIZE - sprite_get_height(sDoorFront) * 0.4;
					var _door = instance_create_layer(_doorX, _doorY, "Instances", oDoor);
					_door.sprite_index = sDoorFront;
					ds_list_add(doors, _door);
					ds_list_add(_room.doors, _door);
				}
			} break;
			
		}
		
		if (_isGenerated) {
			if (_roomTypeIndex = RoomCategory.SHOP)
				oRoomManager.shopsGenerated++;
		}
	}
	
	// Renders the room (and its adjacent room) on the minimap
	RenderMinimap = function(_surf) {
		//if (!discovered) return;
		
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
		
		if (roomTypeIndex == RoomCategory.ENTRANCE)
			//draw_circle_color(_x, _y, 10, c_green, c_green, false);
			draw_sprite_ext(sMinimapIcons, 0, _x, _y, 2, 2, 0, c_white, 1);
		if (roomTypeIndex == RoomCategory.EXIT)
			//draw_circle_color(_x, _y, 10, c_blue, c_blue, false);
			draw_sprite_ext(sMinimapIcons, 3, _x, _y, 2, 2, 0, c_white, 1);
		if (roomTypeIndex == RoomCategory.CIRCUITS)
			//draw_circle_color(_x, _y, 10, c_orange, c_orange, false);
			draw_sprite_ext(sMinimapIcons, 2, _x, _y, 2, 2, 0, c_white, 1);
		if (roomTypeIndex == RoomCategory.SHOP)
			//draw_circle_color(_x, _y, 10, c_fuchsia, c_fuchsia, false);
			draw_sprite_ext(sMinimapIcons, 1, _x, _y, 2, 2, 0, c_white, 1);

		draw_circle_color(MINIMAP_SURF_W * 0.5,  MINIMAP_SURF_H * 0.5, 5, c_red, c_red, false);
		
		for (var _i = 0; _i < ds_list_size(nextRooms); _i++) {
			nextRooms[| _i].RenderMinimap(_surf);
		}
	}
	
	// Locks the room and spawns enemies
	LockRoom = function() {
		
		oPlayer.walkSpd = oPlayer.walkSpdDef
		oPlayer.showStats = false
		
		// Start door closing animation
		for (var _i = 0; _i < ds_list_size(doors); _i++) {
			doors[| _i].isOpen = false;
		}
		
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
		
		// Spawn enemies --------------------------------------
		var mapWidth  = tilemap_get_width(global.tilemapCollision);
		var mapHeight = tilemap_get_height(global.tilemapCollision);
		
		// Progressively spawn more enemies
		var spawnEnemyCount = 2
		spawnEnemyCount += min(oController.roomsCleared * .5, 2)
		spawnEnemyCount += min(oController.roomsCleared * .25, 6)
		spawnEnemyCount += oController.buffsObtained * 1.5
		spawnEnemyCount = round(spawnEnemyCount)
		
		audio_resume_sound(oController.actionMusic)
		audio_sound_gain(oController.actionMusic, actionMusicFightGain, 3000)
		
		while (spawnEnemyCount > 0) {
			var _enemyX = (_roomX + random_range(1, ROOM_SIZE - 1)) * TILE_SIZE;
			var _enemyY = (_roomY + random_range(1, ROOM_SIZE - 1)) * TILE_SIZE;
			
			// Tilemap collision
			var collidingTile = collision_rectangle(_enemyX - TILE_SIZE/2, _enemyY - TILE_SIZE/2, _enemyX + TILE_SIZE/2, _enemyY + TILE_SIZE/2, global.tilemapCollision, false, true)
			var colliding = collidingTile != noone
			
			// Non-tilemap collision
			var nearestCollider = instance_nearest(_enemyX, _enemyY, oCollider)
			if (instance_exists(nearestCollider))
				colliding |= point_distance(_enemyX, _enemyY, nearestCollider.x, nearestCollider.y) < TILE_SIZE
			
			if (!colliding)
			{
				var _enemy = instance_create_layer(_enemyX, _enemyY, "Instances", oEnemy);
				var enemyType = chooseEnemyType()
				with(_enemy) { characterCreate(enemyType); }
				
				ds_list_add(enemies, _enemy);
				spawnEnemyCount--
			}
		}
		
		// Spawn weapons
		var spawnGuns = 5
		
		while (spawnGuns > 0) {
			var _gunX = (_roomX + random_range(1, ROOM_SIZE - 1)) * TILE_SIZE;
			var _gunY = (_roomY + random_range(1, ROOM_SIZE - 1)) * TILE_SIZE;
			
			//var tileX = clamp(floor(_enemyX / TILE_SIZE), 0, mapWidth - 1);
			//var tileY = clamp(floor(_enemyY / TILE_SIZE), 0, mapHeight - 1);
			//var tileId = tilemap_get_at_pixel(global.tilemapCollision, _enemyX, _enemyY)
			var colliding = collision_rectangle(_gunX - TILE_SIZE/2, _gunY - TILE_SIZE/2, _gunX + TILE_SIZE/2, _gunY + TILE_SIZE/2, global.tilemapCollision, false, true)
			
			if (!colliding) //_enemy.controller.setState(CharacterState.Dead)
			{
				var _gun = instance_create_layer(_gunX, _gunY, "Instances", oWeaponPickup);
				var weaponType = choose(WEAPON.rat, WEAPON.crowbar)
				_gun.setupWeaponPickup(weaponType);
				
				spawnGuns--;
			}
		}
		
		// Generate pathfinding grid for enemy AI
		with (oRoomManager)
		{
			for (var _y = 0; _y < ROOM_SIZE; _y++) {
				for (var _x = 0; _x < ROOM_SIZE; _x++) {
					var _tile = roomTypes[other.roomTypeIndex].tiles[_y * ROOM_SIZE + _x];	// retreive the tile struct at the position
					wallGrid[# _x, _y] = (_tile.tileWall == 0) ? 0 : 1;
				}
			}
			
			var _scannedObjects = roomTypes[other.roomTypeIndex].scannedObjects
			for (var _i = 0; _i < ds_list_size(_scannedObjects); _i++) {
				var _x = _scannedObjects[| _i].roomX div TILE_SIZE - 1;
				var _y = _scannedObjects[| _i].roomY div TILE_SIZE - 1;
				wallGrid[# _x, _y] = 1;
			}
			
			pathfindingGrid = mp_grid_create(_roomX * TILE_SIZE, _roomY * TILE_SIZE, ROOM_SIZE, ROOM_SIZE, TILE_SIZE, TILE_SIZE)
			ds_grid_to_mp_grid(wallGrid, pathfindingGrid)
		}
	}
	
	// Kills and removes specified enemy object from the room
	KillEnemy = function(_enemyID) {
		var _index = ds_list_find_index(oRoomManager.currentRoom.enemies, _enemyID);
		if (_index != -1) {
			ds_list_delete(oRoomManager.currentRoom.enemies, _index);
			_enemyID.onDeathEvent()
			CheckCleared();
		}
	}
	
	RemoveProjectiles = function(_objectId = oProjectile) {
		instance_destroy(_objectId)
	}
	
	// Checks whether the room is cleared (no enemies) and if it is, opens the entries
	CheckCleared = function() {
		if (cleared || !ds_list_empty(enemies)) return;
		
		oPlayer.walkSpd = oPlayer.walkSpdSprint
		oPlayer.showStats = true
		audio_sound_gain(oController.actionMusic, actionMusicRestGain, 3000)
		
		oController.roomsCleared++
		
		// Start door opening animation
		for (var _i = 0; _i < ds_list_size(doors); _i++) {
			doors[| _i].isOpen = true;
		}
			
		//show_debug_message("clear");
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
			tilemap_set(oRoomManager.tileMapWall, 0, _roomX + (ROOM_SIZE div 2),	 _roomY + ROOM_SIZE - 1);
			tilemap_set(oRoomManager.tileMapWall, 0, _roomX + (ROOM_SIZE div 2) - 1, _roomY + ROOM_SIZE - 1);
		}
		if (entrySides[3]) {
			tilemap_set(oRoomManager.tileMapWall, 0, _roomX + (ROOM_SIZE div 2),	 _roomY);
			tilemap_set(oRoomManager.tileMapWall, 0, _roomX + (ROOM_SIZE div 2) - 1, _roomY);
		}
			
		cleared = true;
	}
}


// Scans and saves all room types (their tiles and objects)
function ScanRooms() {
	// Scan room tiles
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
	            _tiles[_y * ROOM_SIZE + _x] = new Tile(_dataWall, _dataDec1, _dataDec2, _dataDec3);
	        }
	    }
	
		var _scannedObjects = ds_list_create();
	    roomTypes[_room] = new RoomType(_tiles, _scannedObjects, noone);
	    _roomY += ROOM_SIZE + ROOM_OFFSET;
	}

	// Scan room interactables
	with (oObject) {
		_roomX = x mod ((ROOM_SIZE + ROOM_OFFSET) * TILE_SIZE);
		_roomY = y mod ((ROOM_SIZE + ROOM_OFFSET) * TILE_SIZE);
		var _scannedObject = new ScannedObject(id, _roomX, _roomY, ScannedObjectType.INTERACTABLE);
		var roomTypeIndex = y div ((ROOM_SIZE + ROOM_OFFSET) * TILE_SIZE);
		ds_list_add(oRoomManager.roomTypes[roomTypeIndex].scannedObjects, _scannedObject);
	}
	
	// Scan NPCs
	with (oNPC) {
		_roomX = x mod ((ROOM_SIZE + ROOM_OFFSET) * TILE_SIZE);
		_roomY = y mod ((ROOM_SIZE + ROOM_OFFSET) * TILE_SIZE);
		var _scannedObject = new ScannedObject(id, _roomX, _roomY, ScannedObjectType.NPC);
		var roomTypeIndex = y div ((ROOM_SIZE + ROOM_OFFSET) * TILE_SIZE);
		ds_list_add(oRoomManager.roomTypes[roomTypeIndex].scannedObjects, _scannedObject);
	}
}