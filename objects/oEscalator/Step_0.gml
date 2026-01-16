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