// Scan rooms a generate the first floor
if (!areRoomsScanned) {
	ScanRooms();
	areRoomsScanned = true;
	
	// Generate the floor
	var _room = new Room(0, 0, 0, RoomCategory.ENTRANCE);
	_room.discovered = true;
	_room.cleared = true;
	currentRoom = _room;
	_room.Generate();	// generate the entire floor
	
	// Generate exit room
	var _exitDir = choose(0, 1, 2, 3);
	var _mostDistantRoom = mostDistantRooms[_exitDir];
	_mostDistantRoom.GenerateAdjacentRoom(_exitDir, MAX_DEPTH, RoomCategory.EXIT);
	
	// Generate curcuits room
	var _circuitsDir = (_exitDir + 1) % 4
	_mostDistantRoom = mostDistantRooms[_circuitsDir];
	_mostDistantRoom.GenerateAdjacentRoom(_circuitsDir, MAX_DEPTH, RoomCategory.CIRCUITS);
	
}

// Update player position
playerTileX = (oPlayer.x - FLOOR_CENTER_X) div TILE_SIZE + ROOM_SIZE * 0.5;
playerTileY = (oPlayer.y - FLOOR_CENTER_Y) div TILE_SIZE + ROOM_SIZE * 0.5;

/*
show_debug_message("oPlayerX: " + string(oPlayer.x));
show_debug_message("oPlayerY: " + string(oPlayer.y));
show_debug_message("tileX: " + string(playerTileX));
show_debug_message("tileY: " + string(playerTileY));*/

playerRoomXPrev = playerRoomX;
playerRoomYPrev = playerRoomY;
playerRoomX = floor(playerTileX / ROOM_SIZE);
playerRoomY = floor(playerTileY / ROOM_SIZE);

playerRoomXpx = (floor(FLOOR_CENTER_X / TILE_SIZE - ROOM_SIZE / 2) + playerRoomX * ROOM_SIZE) * TILE_SIZE
playerRoomYpx = (floor(FLOOR_CENTER_Y / TILE_SIZE - ROOM_SIZE / 2) + playerRoomY * ROOM_SIZE) * TILE_SIZE

// Lock the current room if player stepped into uncleared room
if (playerRoomX != playerRoomXPrev || playerRoomY != playerRoomYPrev)
    currentRoom = rooms[? string([playerRoomX, playerRoomY])];
if (!currentRoom.discovered) {    // make the room close after the player steps deeper into the room so the door won't make him stuck
    if (playerTileX > (playerRoomX * ROOM_SIZE) &&
        playerTileX < ((playerRoomX + 1) * ROOM_SIZE - 2) &&
        playerTileY > (playerRoomY * ROOM_SIZE + 1) &&
        playerTileY < ((playerRoomY + 1) * ROOM_SIZE - 1))
    {
		if (currentRoom.roomTypeIndex > 3)
			currentRoom.LockRoom();
        currentRoom.discovered = true;
    }
}

if (keyboard_check_pressed(ord("C")))    // clear all enemies
    with (oEnemy) oRoomManager.currentRoom.KillEnemy(id);
   

/*
show_debug_message("playerRoomX: " + string(playerRoomX));
show_debug_message("playerRoomY: " + string(playerRoomY));*/