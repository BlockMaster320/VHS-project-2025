function ScreenDefaults() constructor {
	size = {x: display_get_gui_width(), y: display_get_gui_height()}
	
	middle = {x: size.x / 2, y: size.y / 2}
	
	frictionSize = function(percent) {
		return {x: size.x * percent, y: size.y * percent}
	}
}
