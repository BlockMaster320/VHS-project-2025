// Inherit the parent event
event_inherited();

// Floor completed -> continue to the next floor
if (place_meeting(x, y, oPlayer) && oPlayer.y < y + 25 && global.inputState != INPUT_STATE.cutscene) {
	oController.currentFloor++;
	if (oController.currentFloor == FLOORS) {
		RoomTransition(rmBossFight)
	}
	else
		RoomTransition(rmGame)
}

if (global.powerOn)
{
	var playerDist = point_distance(x, y, oPlayer.x, oPlayer.y)
	var maxDist = 600
	var volume = 1 - power(playerDist / maxDist, 2)
	volume = clamp(volume, 0, 1)
	audio_sound_gain(sound, volume, 0)
	//show_debug_message(volume)
}
else audio_sound_gain(sound, 0, 0)