/// @struct	CinemaBorders
/// @desc Helper struct which wraps current state of cut scene borders. Provide helper functions for hide and show animations.
/// @param {real} [_duration] [1500] - Duration of animation for hiding/showing borders
/// @param {real} [_currentHeightState] [CinemaBordersState.NONE] - If undefined, _hiddenHeight is provided.
function CinemaBorders(_duration=1500, _currentHeightState=CinemaBordersState.NONE) constructor {
	static name			= "CinemaBorders"
	if (SHOW_DEBUG) show_debug_message(name + " is being created.")

	duration		= _duration			// ms
	
	currentHeight	= _currentHeightState
	target			= _currentHeightState
	tween			= undefined
	
	controller		= getDrawGuiController()
	controller.add(self)
	
	/// @function	destroy()
	/// @desc Function removes itself from draw gui controller and is no longer active in draw gui steps.
	destroy = function() {
		controller.remove(self)	
	}
	
	/// @function	Set()
	/// @desc Method which sets target animation and on complete callback when finished.
	/// @param {CinemaBordersState} _target - Target state of cienma for animation.
	/// @param {function} _onComplete - Callback which is triggered when showing ends.
	/// @return {struct.CinemaBorders}
	Set = function(_target, _onComplete = function() {}) {
		if (target == _target) return self
		target = _target
		tween = new TweenProperty(
			target,
            function() { return currentHeight; },
            function(v) { currentHeight = v; },
            duration, 
            (target == CinemaBordersState.NONE) ? global.Ease.EaseInQuad : global.Ease.EaseOutQuad,
			_onComplete
        )
		return self
	}
	
	/// @function	Start()
	/// @desc Start method which tries to run current tween if defined and not started.
	Start = function() {
		if (tween.progress == Progress.NOT_STARTED && !is_undefined(tween)) tween.start()
	}

	/// @Function	drawGui()
	/// @desc Based on currentHeight draws in GUI top and bottom borders.
	drawGui = function () {
		if (SHOW_DEBUG) show_debug_message("Draw with current height " + string(currentHeight))

		if (currentHeight <= 0) return;
		safeDraw(function() {
			draw_set_color(c_black);
	        draw_rectangle(0, 0, cameraW, currentHeight, false); // Top
	        draw_rectangle(
	            0,
	            cameraH - currentHeight,
	            cameraW,
	            cameraH,
	            false
	        );
		})
	}
	
	State = function() {
		return is_undefined(tween) ? Progress.FINISHED : tween.progress
	}
	
	enum CinemaBordersState {
		NONE = 0,
		CINEMA = 40,
		WHOLE = 150
	}
}