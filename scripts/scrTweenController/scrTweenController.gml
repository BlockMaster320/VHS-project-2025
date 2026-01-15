/// @function getTweenController()
/// @desc Access global instance of TweenController or creates it if not initialized yet.
function getTweenController() {
    if (!variable_global_exists("__TweenController") || is_undefined(global.__TweenController)) {
        global.__TweenController = new TweenController();
    }
    return global.__TweenController;
}

/// @struct	TweenController
/// @desc Struct for storing and managing lifecycle of all tween animations.
function TweenController() constructor {
	tasks = ds_list_create();

	/// @function	add(callable)
	/// @desc Add a callable (function reference or struct with step() method)
	/// @param {struct.BaseTween|function} callable - Function or struct to be removed.
	add = function (callable) {
		ds_list_add(tasks, callable); 
	};

	/// @funciton	remove()
	/// @desc Remove a callable if it exists.
	/// @param {function|struct.BaseTween} callable - Function or struct. If struct is passed, it should have defined step() method.
	remove = function (callable) {
		var idx = ds_list_find_index(tasks, callable);
		if (idx != -1) ds_list_delete(tasks, idx);
	};

	/// @function	step()
	/// @desc Call all stored callables. If function, it is directly invoked. In case of struct, it is checked if has method step() and then this method is invoked.
	step = function () {
	    for (var i = 0; i < ds_list_size(tasks); i++) {
	        var fn = tasks[| i];
	        if (is_callable(fn)) {
	            fn();
	        } else if (is_struct(fn) && variable_struct_exists(fn, "step")) {
	            fn.step();
	        } else {
				if (SHOW_DEBUG) show_debug_message("No callable animation indicated in TweenController")
			}
	    }
	};
	
	/// @function   destroy()
	/// @desc Destroy method triggers clearing it's list of tasks (firstly one by one, then whole list is destroyed) and clearing itself from global space.
    static destroy = function() {

        // free all elements from memory
        for(var i = ds_list_size(tasks)-1; i>=0; i--)
            tasks[| i].destroy();
        ds_list_destroy(tasks);

        // remove global reference
        delete global.__TweenController;
        global.__TweenController = undefined;
    }
}


/**
 * @struct	TweenSequence
 * @descr Creates tween sequence which stores array of tweens. When started, it run throught all tweens one by one and executes them.
 * @param {Array.BaseTween|Id.DsList} _tweens - Array or ds_list of tweens
 */
function TweenSequence(_tweens) : BaseTween() constructor {
    tweens		= _tweens;
    index		= 0;
    finished	= false;
    controller	= getTweenController();

	/// @function	ContinueWith(_tween, _onComplete = function() {})
	/// @desc Builder helper function which adds tween animation at the end of the current array of tweens. Returns the same object - could be chained after each other.
	/// @param {struct.BaseTween} _tween - Tween to add to chain.
	/// @return {struct.TweenSequence}
	ContinueWith = function(_tween) {
		appendToList(tweens, _tween)
		return self
	}
	
	/// @function	step()
	/// @desc Step method which checks state of current executed tween and performs sequential executing of tweens. 
    static step = function() {
        if (finished) { 
			stop()
			return
		}

		inListSize(tweens, function(size) {
			finished = index >= size
		})

		if (finished) {
	        finished = true
	        stop()
			destroy()
			onComplete()
	        return
	    }
			
		accessListItem(tweens, index, function(element){
			// Start current tween if not started yet
	        if (element.progress == Progress.NOT_STARTED) {
				element.start()
			}
			
			if (element.progress == Progress.FINISHED) {
				index += 1;
			}
		})  
	}
	
	/// @function	start()
	static start = function() {
		controller.add(self)	
	}

	/// @function	destroy()
	/// @desc Destroy methods which removes itself from controller and clears ds list if provided.
    static destroy = function() {
		controller.remove(self)
		iterateList(tweens, function (element) {element.destroy()})
		if (!is_array(tweens) && ds_exists(tweens, ds_type_list)) {
			ds_list_destroy(tweens)
		}
    }
}