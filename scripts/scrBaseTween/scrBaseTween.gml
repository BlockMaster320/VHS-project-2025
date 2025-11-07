/// @struct BaseTween
/// @desc Base struct which defines basic interface for all tweeens.
/// @param {real} [_gameSpeed] [global.gameSpeed] - Base game speed of the game - can be made independend on the game speed if changed.
function BaseTween(_gameSpeed = global.gameSpeed) constructor {
	
	static name			= "BaseTween"
	
	static progress	= Progress.NOT_STARTED

	static gameSpeed	= _gameSpeed
	
	static controller	= getTweenController()
 
	/// @function	step()
	/// @desc Step function called in each step if registered.
	static step = function() {}
	
	/// @function	destroy()
	/// @desc Destroy methods which removes itself from controller (unregister).
	static destroy = function() {
		controller.remove(self)
	}
	
	/// @funtion	onComplete()
	/// @desc Callback when animation have ended.
	static onComplete = function() {}
	
	/// @function	stop()
	/// @desc Stop method which sets animation as finished.
	static stop = function() {
		progress = Progress.FINISHED
		
		if (SHOW_DEBUG) show_debug_message(name + " is being stopped...")
	}
	
	/// @function	start()
	/// @desc Start method which register itself and sets animation in progress.
	static start = function() {
		controller.add(self)
		progress = Progress.IN_PROGRESS
		return self
	}
	
	/// @function	hmsToSteps()
	/// @desc Helper method which transforms ms to steps.
	static msToSteps = function (ms) {
		return ceil((ms / 1000) * 60 / gameSpeed);
	}
	
	enum Progress {
		NOT_STARTED,
		IN_PROGRESS,
		FINISHED,
	}
}