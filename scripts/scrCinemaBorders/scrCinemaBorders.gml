/// @struct	CinemaBorders
/// @desc Helper struct which wraps current state of cut scene borders. Provide helper functions for hide and show animations.
/// @param {real} [_hiddenHeight] [0] - Hidden height of borders
/// @param {real} [_visibleHeight] [100] - Visible height of borders
/// @param {real} [_duration] [1500] - Duration of animation for hiding/showing borders
/// @param {real} [_currentHeight] [undefined] - If undefined, _hiddenHeight is provided.
function CinemaBorders(_hiddenHeight=0, _visibleHeight=100, _duration=1500, _currentHeight=undefined) constructor {
	hiddenHeight	= 0		// px
	visibleHeight	= 100	// px
	duration		= 1500	// ms
	
	currentHeight	= is_undefined(_currentHeight) ? hiddenHeight : _currentHeight
	
	controller		= getDrawGuiController()
	controller.add(self)
	
	/// @function	destroy()
	/// @desc Function removes itself from draw gui controller and is no longer active in draw gui steps.
	destroy = function() {
		controller.remove(self)	
	}
	
	/// @function	Show()
	/// @desc Function which returns tween for show animatino of cut scene borders.
	/// @params {function|Constants.Ease} _onComplete - Callback which is triggered when showing ends.
	/// @returns {struct.TweenProperty}
    Show = function(_onComplete = function() {}) {
		return new TweenProperty(
			visibleHeight,
            function() { return currentHeight; },
            function(v) { currentHeight = v; },
            duration, 
            global.Ease.EaseOutQuad,
			_onComplete
        )
    }

	/// @function	Hide()
	/// @desc Function which returns tween for hide animatino of cut scene borders.
	/// @params {function} _onComplete - Callback which is triggered when hidding ends.
	/// @returns {struct.TweenProperty}
    Hide = function(_onComplete = function() {}) {
		//currentHeight = hiddenHeight
		return new TweenProperty(
			hiddenHeight,
            function() { return currentHeight; },
            function(v) { currentHeight = v; },
            duration,
            global.Ease.EaseInQuad,
			_onComplete
        )
    }

	/// @Function	drawGui()
	/// @desc Based on currentHeight draws in GUI top and bottom borders.
	drawGui = function () {
		if (SHOW_DEBUG) show_debug_message("Draw with current height " + string(currentHeight))

		if (currentHeight <= 0) return;
		safeDraw(function() {
			draw_set_color(c_black);
	        draw_rectangle(0, 0, display_get_gui_width(), currentHeight, false); // Top
	        draw_rectangle(
	            0,
	            display_get_gui_height() - currentHeight,
	            display_get_gui_width(),
	            display_get_gui_height(),
	            false
	        );
		})
	}
	
	enum CinemaBordersState {
		HIDDEN = 1,
		VISIBLE = 2,
	}
}