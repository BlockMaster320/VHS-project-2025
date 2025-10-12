if (keyboard_check_pressed(ord("R"))) game_restart();

// Update player position
playerTileX = (oPlayer.x - FLOOR_CENTER_X) div TILE_SIZE + ROOM_SIZE * 0.5;
playerTileY = (oPlayer.y - FLOOR_CENTER_Y) div TILE_SIZE + ROOM_SIZE * 0.5;
playerRoomXPrev = playerRoomX;
playerRoomYPrev = playerRoomY;
playerRoomX = floor(playerTileX / ROOM_SIZE);
playerRoomY = floor(playerTileY / ROOM_SIZE);

// Lock the current room if player stepped into uncleared room
if (playerRoomX != playerRoomXPrev || playerRoomY != playerRoomYPrev)
    currentRoom = rooms[? string([playerRoomX, playerRoomY])];
if (!currentRoom.discovered) {    // make the room close after the player steps deeper into the room so the door won't make him stuck
    if (playerTileX > (playerRoomX * ROOM_SIZE + 1) &&
        playerTileX < ((playerRoomX + 1) * ROOM_SIZE - 2) &&
        playerTileY > (playerRoomY * ROOM_SIZE + 1) &&
        playerTileY < ((playerRoomY + 1) * ROOM_SIZE - 1))
    {
        currentRoom.LockRoom();
        currentRoom.discovered = true;
    }
}



// Check whether player has cleared the room
currentRoom.CheckCleared();

if (keyboard_check_pressed(ord("C")))    // clear all enemies
    with (oEnemy) oRoomManager.currentRoom.KillEnemy(id);

/*
show_debug_message("playerRoomX: " + string(playerRoomX));
show_debug_message("playerRoomY: " + string(playerRoomY));*/