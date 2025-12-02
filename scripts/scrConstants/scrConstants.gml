function Constants()
{
	enum INPUT_STATE
	{
		playing,
		menu,
		dialogue,
		cutscene,
	}
	
	// Map generation settings
	#macro TILE_SIZE 16		// size of 1 tile in pixels
	#macro ROOM_SIZE 30		// size of each room in tiles
	#macro ROOM_SCAN_X 1	// where to start scanning the rooms
	#macro ROOM_SCAN_Y 1
	#macro ROOM_OFFSET 1	// offset between the rooms for the scanning
	#macro ROOM_COUNT 5		// number of rooms to scan
	#macro GENERATION_FALLOFF 0.4
	#macro MAX_DEPTH 3
	#macro SHOP_SPAWN_CHANCE 0.5
	#macro MAX_SHOPS 3
	//#macro ROOM_SPACING 3

	// Minimap rendering settings
	#macro MINIMAP_ROOM_SIZE 35
	#macro MINIMAP_BRIDGE_SIZE 15
	#macro MINIMAP_ROOM_SPACING 6
	#macro MINIMAP_SURF_W 300
	#macro MINIMAP_SURF_H 200
	
	#macro FLOOR_CENTER_X room_width / 2
	#macro FLOOR_CENTER_Y room_height / 2
	
	// GUI
	#macro cameraW 480
	#macro cameraH 270
	
	#macro guiW display_get_gui_width()
	#macro guiH display_get_gui_height()
	#macro windowToGui guiW / cameraW
	#macro guiToCamera cameraW / guiW
	
	// Pathfinding
	global.enemyMaxIndex = 0
	#macro ENEMY_COLLISION_MARGIN 12
	
	// Debug levels
	#macro SHOW_STACKTRACE false
	#macro SHOW_DEBUG false
	// Hitboxes
	#macro SHOW_HITBOXES false
	// Debug pathfinding
	#macro SHOW_PATH_GRID false
	#macro PATH_DEBUG false
	// AI
	#macro AI_DEBUG true
	
	global.Ease = {

	    // --- Linear ---
	    Linear: function(t) { return t; },

	    // --- Quadratic ---
	    EaseInQuad: function(t) { return t * t; },
	    EaseOutQuad: function(t) { return t * (2 - t); },
	    EaseInOutQuad: function(t) { return (t < 0.5) ? 2 * t * t : -1 + (4 - 2 * t) * t; },

	    // --- Cubic ---
	    EaseInCubic: function(t) { return t * t * t; },
	    EaseOutCubic: function(t) { t -= 1; return t * t * t + 1; },
	    EaseInOutCubic: function(t) { return (t < 0.5) ? 4 * t * t * t : (t - 1) * (2 * t - 2) * (2 * t - 2) + 1; },

	    // --- Quartic ---
	    EaseInQuart: function(t) { return t * t * t * t; },
	    EaseOutQuart: function(t) { t -= 1; return 1 - t * t * t * t; },
	    EaseInOutQuart: function(t) { return (t < 0.5) ? 8 * t * t * t * t : 1 - 8 * pow(t - 1, 4); },

	    // --- Quintic ---
	    EaseInQuint: function(t) { return t * t * t * t * t; },
	    EaseOutQuint: function(t) { t -= 1; return 1 + t * t * t * t * t; },
	    EaseInOutQuint: function(t) { return (t < 0.5) ? 16 * pow(t, 5) : 1 + 16 * pow(t - 1, 5); },

	    // --- Sinusoidal ---
	    EaseInSine: function(t) { return 1 - cos(t * pi / 2); },
	    EaseOutSine: function(t) { return sin(t * pi / 2); },
	    EaseInOutSine: function(t) { return -0.5 * (cos(pi * t) - 1); },

	    // --- Exponential ---
	    EaseInExpo: function(t) { return (t == 0) ? 0 : pow(2, 10 * (t - 1)); },
	    EaseOutExpo: function(t) { return (t == 1) ? 1 : 1 - pow(2, -10 * t); },
	    EaseInOutExpo: function(t) {
	        if (t == 0) return 0;
	        if (t == 1) return 1;
	        t *= 2;
	        if (t < 1) return 0.5 * pow(2, 10 * (t - 1));
	        return 0.5 * (2 - pow(2, -10 * (t - 1)));
	    },

	    // --- Circular ---
	    EaseInCirc: function(t) { return 1 - sqrt(1 - t * t); },
	    EaseOutCirc: function(t) { t -= 1; return sqrt(1 - t * t); },
	    EaseInOutCirc: function(t) {
	        t *= 2;
	        if (t < 1) return -0.5 * (sqrt(1 - t * t) - 1);
	        t -= 2;
	        return 0.5 * (sqrt(1 - t * t) + 1);
	    }
	};
}