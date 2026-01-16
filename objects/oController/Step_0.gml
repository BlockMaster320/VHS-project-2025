if (instance_exists(oRoomManager))
	pfGrid = oRoomManager.pathfindingGrid
	
for (var i = array_length(alarms)-1; i >= 0; i--)
{
	alarms[i].update()
	if (alarms[i].time <= 0)
	{
		alarms[i].func()
		array_delete(alarms, i, 1)
	}
}
	
// Change refresh rate based on the active display
//if (gameFPS != display_get_frequency())
//{
//	gameFPS = display_get_frequency()
//	game_set_speed(gameFPS, gamespeed_fps)	// Experimental
//	var prevGameSpeed = defaultGameSpeed
//	defaultGameSpeed = 60 / gameFPS
//	global.gameSpeed *= prevGameSpeed / defaultGameSpeed
//}

//show_debug_message($"{game_get_speed(gamespeed_fps)} FPS")