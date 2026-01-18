global.tilemapCollision = layer_tilemap_get_id("TilesWall")

// Procedural pathfinding
wallGrid = undefined
pfGrid = undefined
if (instance_exists(oRoomManager))
	pfGrid = oRoomManager.pathfindingGrid
else if (room = rmDebug)
{
	wallGrid = getWallGrid(["TilesWall"])
	pfGrid = (!is_undefined(wallGrid)) 
		? getPathfindingGrid(wallGrid)
		: undefined
}

// Boss fight setup
if (currentFloor = FLOORS) {
	oPlayer.x = 775;
	oPlayer.y = 850;
}

if (room == rmLobby)
{
	audio_sound_gain(subwayAmbiance, 0, 0)
	audio_resume_sound(subwayAmbiance)
	audio_sound_gain(subwayAmbiance, 1, 4000)
}