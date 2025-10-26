function ElementController() {
    if (!variable_global_exists("__ElementController") || is_undefined(global.__ElementController)) {
        global.__ElementController = new GUIElementController();
    }
    return global.__ElementController;
}

function GUIElementController() constructor {
    // list of all GUI elements
    elements            = ds_list_create();

    // the GUI element struct in focus currently
    element_in_focus    = undefined;    

    // prevents click-throughs on overlapping elements
    can_click           = true;         

    /// @function   step()
    static step = function() {
        if (oController.gui_pressed && element_in_focus != undefined) {
			element_in_focus.remove_focus()
			element_in_focus = undefined;
		}
        can_click = true;

        // call `step` function in all elements
        var count = ds_list_size(elements);
        for(var i = 0; i < count; i++) {
			var elem = elements[| i];
			if (is_undefined(elem) || elem.elementState == ElementState.HIDDEN) continue;
			
	        try {
	            elem.step();
	        } catch (e) {
	            showErrorMessage(elem, e, "step()")
	        }
		}
    }
	
	static gui_surface = undefined;

    /// @function   draw()
    static draw = function() {
		safeDraw(function() {
		    draw_set_halign(fa_left);
		    draw_set_valign(fa_middle);
		    draw_set_color(c_white);

		    // call `draw` function on all elements in reverse-creation order - impact overdraw
		    for(var i = ds_list_size(elements)-1; i>=0; i--) {
				var elem = elements[| i]
				if (elem.elementState == ElementState.HIDDEN) continue
				try {	
					elem.draw();
				} catch (e) {
					showErrorMessage(elem, e, "draw()")
				}
			}
		})
    }


    /// @function   destroy()
    static destroy = function() {

        // free all elements from memory
        for(var i = ds_list_size(elements)-1; i>=0; i--)
            elements[| i].destroy();
        ds_list_destroy(elements);

        // remove global reference
        delete global.__ElementController;
        global.__ElementController = undefined;

    }

    /// @function   destroy()
    static destroyGroup = function(group) {

        // free all elements from memory
        for(var i = ds_list_size(elements)-1; i>=0; i--) {
	        var elem = elements[| i];
	        // only destroy if it belongs to the group
			show_debug_message(elem.group)
			show_debug_message(group)
	        if (elem.group == group) {
	            elem.destroy();
			}
        }
    }
	
	static setGroupVisibility = function(group, elementState) {
        for(var i = ds_list_size(elements)-1; i>=0; i--) {
	        var elem = elements[| i];
	        if (elem.group == group) {
	            elem.elementState = elementState
			}
        }
    }
	
	showErrorMessage = function(element, exception, method_name) {
		var elem_name = (variable_instance_exists(element, "name") && !is_undefined(element.name)) ? element.name : "<unnamed>";
		var location = "Script: " + (variable_struct_exists(exception, "script")
			? string(exception.script)
			: "<unknown>");
		location += " on line " +( variable_struct_exists(exception, "line")
			? string(exception.line)	
			: "<unknown>"); 
		var reason = "Reason: " + (variable_struct_exists(exception, "message")
			? string(exception.message)
			: "<unknown>");
		var detail = "Details: " + (SHOW_STACKTRACE
			? string(exception.message)
			: "<disabled>");
		
	    show_debug_message("⚠️Error in element: " + string(elem_name) + "." + method_name);
		show_debug_message("		↳ " + location)
		show_debug_message("		↳ " + reason)
		show_debug_message("		↳ " + detail);
	}
}