var screen = new ScreenDefaults()

resume_button = new Button(
	"resume_game_button",
	UIGroups.PAUSE,
	"Resume", 
	screen.middle.x, 
	screen.middle.y, 
	function() {
		ElementController().setGroupVisibility(UIGroups.PAUSE, ElementState.HIDDEN)
		global.gameSpeed = 1
		global.inputState = INPUT_STATE.playing
	}, 
	ButtonSprites()
); 

exit_button = new Button(
	"exit_game_button",
	UIGroups.PAUSE,
	"Exit Game", 
	screen.middle.x, 
	screen.middle.y + 70, 
	game_end, 
	ButtonSprites()
); 

ElementController().setGroupVisibility(UIGroups.PAUSE, ElementState.HIDDEN)