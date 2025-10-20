if (keyboard_check_pressed(ord("P"))) {
	global.gameSpeed = 0
	global.inputState = INPUT_STATE.menu
	ElementController().setGroupVisibility(UIGroups.PAUSE, ElementState.ACTIVE)
}
