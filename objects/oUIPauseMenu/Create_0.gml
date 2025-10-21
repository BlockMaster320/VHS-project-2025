var screen = new ScreenDefaults()

resume_button = new Button(
	"resume_game_button",
	UIGroups.PAUSE,
	"Resume", 
	0, 0,
	function() {
		ElementController().setGroupVisibility(UIGroups.PAUSE, ElementState.HIDDEN)
		global.gameSpeed = 1
		global.inputState = INPUT_STATE.playing
	},
); 

exit_button = new Button(
	"exit_game_button",
	UIGroups.PAUSE,
	"Exit Game", 
	0, 0,
	game_end,
); 

Column(
	screen.middle.x,
	screen.middle.y,
	40,
	[resume_button, exit_button]
)

ElementController().setGroupVisibility(UIGroups.PAUSE, ElementState.HIDDEN)