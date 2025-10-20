// UI menu
var screen = new ScreenDefaults()
var frictionSize = screen.frictionSize(0.5)


my_button = new Button(
	"start_game_button",
	UIGroups.MAIN_MENU,
	"Start Game", 
	screen.middle.x, 
	screen.middle.y, 
	function() {
		room_goto(rmGame)
		ElementController().destroyGroup(UIGroups.MAIN_MENU)
	}, 
	ButtonSprites()
); 

my_text = new Text(
	"text_wratning", 
	UIGroups.MAIN_MENU,
	"Do not press this button!", 
	screen.middle.x, 
	screen.middle.y + 70,
	Anchor.Top
); 

my_button_2 = new Button(
	"boo_button",
	UIGroups.MAIN_MENU,
	"Boo", 
	screen.middle.x, 
	screen.middle.y + 100,
	function() {
		my_button_2.setVisibility(ElementState.HIDDEN)
	}, 
	ButtonSprites()
); 


my_canvas = new Canvas(
	"menu_canvas",
	UIGroups.MAIN_MENU,
	screen.middle.x, 
	screen.middle.y,
	frictionSize.x, 
	frictionSize.y, 
	sCanvas
);