/**
 * @function	RoomTransition()
 * @desc Function which start cutscene & animate closing cinema & transitino to another room.
 *
 * @param {Asset.GMRoom} _room - Room target to transition
 */
function RoomTransition(_room){
	debug("Calling RoomTransition(" + string(_room) + ") ...")
	nextRoom = _room
	global.inputState = INPUT_STATE.cutscene
	
	if (getCinemaBorders().currentHeight == CinemaBordersState.WHOLE) {
		debug("Moving to " + string(nextRoom))
		oController.prevRoom = room
		room_goto(nextRoom);
		debug("Starting opening borders...")
		getCinemaBorders().Set(CinemaBordersState.NONE).Start()
		global.inputState = INPUT_STATE.playing
		return	
	}
	
	debug("Starting closing borders...")
	getCinemaBorders().Set(CinemaBordersState.WHOLE, function() {
		debug("Moving to " + string(nextRoom))
		oController.prevRoom = room
		room_goto(nextRoom);
		debug("Starting opening borders...")
		getCinemaBorders().Set(CinemaBordersState.NONE).Start()
		global.inputState = INPUT_STATE.playing
	}).Start();
}
