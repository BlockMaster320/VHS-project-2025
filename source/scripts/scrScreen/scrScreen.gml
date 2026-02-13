function ScreenDefaults() constructor {
	size = {x: cameraW, y: cameraH}
	
	middle = {x: size.x / 2, y: size.y / 2}
	
	frictionSize = function(percent) {
		return {x: size.x * percent, y: size.y * percent}
	}
}
