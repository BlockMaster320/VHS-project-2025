if (oController.pause) {
	if (global.inputState != INPUT_STATE.menu) {
		global.gameSpeed = 0
		lowerState = global.inputState
		global.inputState = INPUT_STATE.menu
		ElementController().setGroupVisibility(UIGroups.PAUSE, ElementState.ACTIVE)
		//toggleMenu()
	} else {
		global.gameSpeed = oController.defaultGameSpeed
		global.inputState = lowerState
		lowerState = INPUT_STATE.playing
		ElementController().setGroupVisibility(UIGroups.PAUSE, ElementState.HIDDEN)
	}
}
