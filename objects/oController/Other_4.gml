// Procedural pathfinding
wallGrid = undefined
pfGrid = undefined

if (!instance_exists(oRoomManager))
	global.tilemapCollision = layer_tilemap_get_id("TilesWall")

if (room == rmDebug or room == rmLobby)
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

if (audio_is_playing(lobbyMusic) and room != rmDebug and room != rmLobby) audio_sound_gain(lobbyMusic, 0, 2000)

switch (room)
{
	case rmLobby:
		audio_sound_gain(subwayAmbiance, 0, 0)
		audio_resume_sound(subwayAmbiance)
		audio_sound_gain(subwayAmbiance, 1, 4000)
		
		//if (audio_is_playing(lobbyMusic)) audio_stop_sound(lobbyMusic)
		
		if (introCutscene)
		{
			oPlayer.x = 320
			oPlayer.y = 490
		}
		introCutscene = false
		
		currentFloor = 0
		
		break		
		
	case rmGame:
	
		audio_resume_sound(actionMusic)
		audio_sound_gain(actionMusic, actionMusicRestGain, 2000)
	
		break
		
	case rmBossFight:
	
		audio_sound_gain(actionMusic, 0, 2000)
		currentFloor = 3
		
		break
}