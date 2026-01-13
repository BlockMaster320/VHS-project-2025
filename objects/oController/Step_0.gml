if (instance_exists(oRoomManager))
	pfGrid = oRoomManager.pathfindingGrid
	
//if (gameFPS != display_get_frequency())
//{
//	gameFPS = display_get_frequency()
//	game_set_speed(gameFPS, gamespeed_fps)	// Experimental
//	var prevGameSpeed = defaultGameSpeed
//	defaultGameSpeed = 60 / gameFPS
//	global.gameSpeed *= prevGameSpeed / defaultGameSpeed
//}

show_debug_message($"{game_get_speed(gamespeed_fps)} FPS")