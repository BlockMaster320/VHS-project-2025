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
	30,
	[resume_button, exit_button],
	Anchor.Center,
	Anchor.Top,
	function(width, height) {
		var padding = 30 * 2
		my_canvas.height = height + padding
		my_canvas.width = width + padding
	}
);

ElementController().setGroupVisibility(UIGroups.PAUSE, ElementState.HIDDEN)