if (keyboard_check_pressed(ord("K")))
	room_goto(rmGame)

if (instance_exists(oRoomManager))
	pfGrid = oRoomManager.pathfindingGrid

// Custom alarm system (currently unused, but should work?)
for (var i = array_length(alarms)-1; i >= 0; i--)
{
	alarms[i].update()
	if (alarms[i].time <= 0)
	{
		alarms[i].func()
		array_delete(alarms, i, 1)
	}
}

// Fullscreen switching
if (fullscreenButton) window_set_fullscreen(!window_get_fullscreen())

// Soundtrack
if (room == rmGame and !audio_is_playing(actionMusic))	// Prevent an unknown bug that stops the soundtrack from playing
	audio_sound_gain(actionMusic, actionMusicRestGain, 2000)
	
// Fullscreen cloning particles
if ((room == rmGame or room == rmBossFight or room == rmDebug) and currentFloor >= 1 and cloneDustSpawnCooldown.value <= 0)
{
	cloneDustSpawnCooldown.reset()
	
	var screenMargin = 30
	var xx = random_range(oCamera.x - screenMargin, oCamera.x + cameraW + screenMargin)
	var yy = random_range(oCamera.y - screenMargin, oCamera.y + cameraH + screenMargin)
	part_type_direction(cloneDust, 0, 360, random_range(-5, 5), random_range(-1, 1))
	part_particles_create(cloneDustSys, xx, yy, cloneDust, 1)
}
else cloneDustSpawnCooldown.value--

if (room == rmLobby)
{
	if (!audio_is_playing(sndGameOver) and !audio_is_playing(lobbyMusic))
	{
		lobbyMusic = audio_play_sound(sndLobbyMusic, 0, true, 0)
		audio_sound_gain(lobbyMusic, 1, 4000)
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