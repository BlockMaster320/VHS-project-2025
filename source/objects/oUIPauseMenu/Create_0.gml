var screen = new ScreenDefaults()
lowerState = INPUT_STATE.playing
setVisibility = function(uiElement, _bool) {
	uiElement.setVisibility(
		_bool ? elementState.ACTIVE :  ElementState.HIDDEN
	)
}

controls_text = new Text(
	"controls_text",
	UIGroups.PAUSE,
	"Movement – WASD\n" + 
	"Shoot – L mouse\n" + 
	"Reload – R\n" +
	"Interact – E\n" +
	"Inventory slot – space / mouse scroll / number\n",
	0, 0
)
controls_text.setVisibility(ElementState.HIDDEN)

resume_button = new Button(
	"resume_game_button",
	UIGroups.PAUSE,
	0, 0,
	"Resume", 
	function() {
		ElementController().setGroupVisibility(UIGroups.PAUSE, ElementState.HIDDEN)
		global.gameSpeed = oController.defaultGameSpeed
		global.inputState = lowerState
		lowerState = INPUT_STATE.playing
	},
); 
resume_button.padding = {x: 16, y:8}

restart_button = new Button(
	"restart_game_button",
	UIGroups.PAUSE,
	0, 0,
	"Restart", 
	function()
	{
		oController.gameReset()
	}
); 
restart_button.padding = {x: 16, y:8}

// Debug button
//debug_room_button = new Button(
//	"debug_room_game_button",
//	UIGroups.PAUSE,
//	0, 0,
//	"Debug Room", 
//	function() {
//		ElementController().setGroupVisibility(UIGroups.PAUSE, ElementState.HIDDEN)
//		global.gameSpeed = oController.defaultGameSpeed
//		lowerState = INPUT_STATE.playing
//		if (room != rmDebug) oController.prevRoom = room
//		RoomTransition(rmDebug)
//	},
//); 
//debug_room_button.padding = {x: 16, y:8}
// -----------

exit_button = new Button(
	"exit_game_button",
	UIGroups.PAUSE,
	0, 0,
	"Exit Game", 
	game_end,
); 
exit_button.padding = {x: 16, y:8}


controls_button = new Button(
	"controls_button",
	UIGroups.PAUSE,
	0, 0,
	"Controls", 
	function() {
		dynamic_column_controls.setVisibility(ElementState.ACTIVE)
		dynamic_column.setVisibility(ElementState.HIDDEN)
		dyn_column_canvas.setVisibility(ElementState.HIDDEN)
		dyn_column_controls_canvas.setVisibility(ElementState.ACTIVE)
	},
); 
controls_button.padding = {x: 16, y:8}

controls_back_button = new Button(
	"controls_back_button",
	UIGroups.PAUSE,
	0, 0,
	"Back", 
	function() {
		dynamic_column_controls.setVisibility(ElementState.HIDDEN)
		dynamic_column.setVisibility(ElementState.ACTIVE)
		dyn_column_canvas.setVisibility(ElementState.ACTIVE)
		dyn_column_controls_canvas.setVisibility(ElementState.HIDDEN)
	},
); 
controls_back_button.padding = {x: 16, y:8}
controls_back_button.setVisibility(ElementState.HIDDEN)


dyn_column_canvas = new Canvas(
	"pause_canvas",
	UIGroups.PAUSE,
	screen.middle.x, 
	screen.middle.y,
	0, 0,
	sCanvas,
);


dyn_column_controls_canvas = new Canvas(
	"pause_canvas",
	UIGroups.PAUSE,
	screen.middle.x, 
	screen.middle.y,
	0, 0,
	sCanvas,
);


mainMenuElements = [resume_button, controls_button, restart_button, exit_button]
controlsMenuElements = [controls_text, controls_back_button]

dynamic_column = new DynamicColumn(
	"dynamic_column",
	UIGroups.PAUSE,
	screen.middle.x,
	screen.middle.y,
	0,
	mainMenuElements,
	Anchor.Center,
	Anchor.Top,
	function(width, height) {
		var padding = 8 * 2
		dyn_column_canvas.height = height + padding
		dyn_column_canvas.width = width + padding
	}
);

dynamic_column_controls = new DynamicColumn(
	"dynamic_column_controls",
	UIGroups.PAUSE,
	screen.middle.x,
	screen.middle.y,
	0,
	controlsMenuElements,
	Anchor.Center,
	Anchor.Top,
	function(width, height) {
		var padding = 8 * 2
		dyn_column_controls_canvas.height = height + padding
		dyn_column_controls_canvas.width = width + padding
	}
);

ElementController().setGroupVisibility(UIGroups.PAUSE, ElementState.HIDDEN)