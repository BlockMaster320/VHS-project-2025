if (oController.pause) {
	global.gameSpeed = 0
	global.inputState = INPUT_STATE.menu
	ElementController().setGroupVisibility(UIGroups.PAUSE, ElementState.ACTIVE)
}
