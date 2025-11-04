/// @function getDrawGuiController()
/// @desc Access global instance of DrawGuiController or creates it if not initialized yet.
function getDrawGuiController() {
    if (!variable_global_exists("__DrawGuiController") || is_undefined(global.__DrawGuiController)) {
        global.__DrawGuiController = new DrawGuiController();
    }
    return global.__DrawGuiController;
}

/// @struct	DrawGuiController
/// @desc Controller for drawables - structs which defines drawGui() methods and are intended to visualize output in GUI.
function DrawGuiController() constructor {
	// Array of callables (or scripts/functions)
	darawables = ds_list_create();

	/// @function	add()
	/// @desc Add a callable (function reference or struct with update method)
	/// @param {struct} callable - Callable struct which should expose drawGui() method.
	add = function (callable) {
		ds_list_add(darawables, callable); 
	};

	/// @function	remove()
	/// @desc Remove a callable if it exists
	/// @param {struct} callable - Callable struct which should expose drawGui() method.
	remove = function (callable) {
		var idx = ds_list_find_index(darawables, callable);
		if (idx != -1) ds_list_delete(darawables, idx);
	};

	/// @function	drawGui()
	/// @desc Draws for each registered drawable one by one. Function drawGui() is checked on each structure before calling.
	drawGui = function () {
		 for (var i = 0; i < ds_list_size(darawables); i++) {
	        var fn = darawables[| i];
	        if (is_struct(fn) && variable_struct_exists(fn, "drawGui")) {
	            fn.drawGui();
	        } else {
				if (SHOW_DEBUG) show_debug_message("No callable animation draw GUI method indicated in DrawGuiController")
			}
	    }
	}
	
	/// @function   destroy()
	/// @desc Destroys registered drawable structures and ds list afterward. Erases itself from global space.
    static destroy = function() {

        // free all elements from memory
        for(var i = ds_list_size(darawables)-1; i>=0; i--)
            darawables[| i].destroy();
        ds_list_destroy(darawables);

        // remove global reference
        delete global.__DrawGuiController;
        global.__DrawGuiController = undefined;
    }
}
