if (oController.pause) {
	global.gameSpeed = 0
	if (global.inputState == INPUT_STATE.dialogue)
		global.inputState = INPUT_STATE.pausedDialogue
	else
		global.inputState = INPUT_STATE.menu
	ElementController().setGroupVisibility(UIGroups.PAUSE, ElementState.ACTIVE)
}
