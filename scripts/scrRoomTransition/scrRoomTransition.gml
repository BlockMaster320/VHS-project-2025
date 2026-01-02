/**
 * @function	RoomTransition()
 * @desc Function which start cutscene & animate closing cinema & transitino to another room.
 *
 * @param {Asset.GMRoom} _room - Room target to transition
 */
function RoomTransition(_room){
	nextRoom = _room
	global.inputState = INPUT_STATE.cutscene
	oCinemaBorders.cinema.Set(CinemaBordersState.WHOLE, function() {
		if (SHOW_DEBUG) show_debug_message("Moving to " + string(nextRoom))
		room_goto(nextRoom);
		oCinemaBorders.cinema.Set(CinemaBordersState.NONE).Start()
		global.inputState = INPUT_STATE.playing
	}).Start();
}
