// UI menu
var screen = new ScreenDefaults()

start_button = new Button(
	"start_game_button",
	UIGroups.MAIN_MENU,
	"Start Game", 
	0, 0,
	function() {
		room_goto(rmGame)
		ElementController().destroyGroup(UIGroups.MAIN_MENU)
	},
); 

boo_button = new Button(
	"boo_button",
	UIGroups.MAIN_MENU,
	"Boo", 
	0, 0,
	function() {
		//boo_button.setVisibility(ElementState.HIDDEN)
		// or 
		boo_button.destroy()
	},
); 

exit_button = new Button(
	"exit_button",
	UIGroups.MAIN_MENU,
	"Exit",
	0, 0,
	game_end,
); 

my_canvas = new Canvas(
	"menu_canvas",
	UIGroups.MAIN_MENU,
	screen.middle.x, 
	screen.middle.y,
	0, 0,
	sCanvas,
);

dynamic_column = new DynamicColumn(
	"dynamic_column",
	UIGroups.MAIN_MENU,
	screen.middle.x,
	screen.middle.y,
	30,
	[start_button, exit_button, boo_button],
	Anchor.Center,
	Anchor.Top,
	function(width, height) {
		var padding = 30 * 2
		my_canvas.height = height + padding
		my_canvas.width = width + padding
	}
);