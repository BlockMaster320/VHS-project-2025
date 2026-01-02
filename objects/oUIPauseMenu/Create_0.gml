var screen = new ScreenDefaults()

resume_button = new Button(
	"resume_game_button",
	UIGroups.PAUSE,
	0, 0,
	"Resume", 
	function() {
		ElementController().setGroupVisibility(UIGroups.PAUSE, ElementState.HIDDEN)
		global.gameSpeed = 1
		if (global.inputState == INPUT_STATE.pausedDialogue)
			global.inputState = INPUT_STATE.dialogue
		else
			global.inputState = INPUT_STATE.playing
	},
); 
resume_button.padding = {x: 16, y:8}

restart_button = new Button(
	"restart_game_button",
	UIGroups.PAUSE,
	0, 0,
	"Restart", 
	game_restart
); 
restart_button.padding = {x: 16, y:8}

exit_button = new Button(
	"exit_game_button",
	UIGroups.PAUSE,
	0, 0,
	"Exit Game", 
	game_end,
); 
exit_button.padding = {x: 16, y:8}

my_canvas = new Canvas(
	"pause_canvas",
	UIGroups.PAUSE,
	screen.middle.x, 
	screen.middle.y,
	0, 0,
	sCanvas,
);

dynamic_column = new DynamicColumn(
	"dynamic_column",
	UIGroups.PAUSE,
	screen.middle.x,
	screen.middle.y,
	0,
	[resume_button, restart_button, exit_button],
	Anchor.Center,
	Anchor.Top,
	function(width, height) {
		var padding = 8 * 2
		my_canvas.height = height + padding
		my_canvas.width = width + padding
	}
);

ElementController().setGroupVisibility(UIGroups.PAUSE, ElementState.HIDDEN)