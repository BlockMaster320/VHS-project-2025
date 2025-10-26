/**
 * @function GUIElement
 * @description Base struct for all GUI elements.
 * @returns {struct.GUIElement}
 */
function GUIElement() constructor {

    // int, string, or bool based on type
	group		= undefined; // group connect same UI elements
    name		= undefined; // unique name

	elementState = ElementState.ACTIVE
	
	static controller	= ElementController()
	ds_list_add(controller.elements, self); 

    // dimensions
	x		 = 0;
	y		 = 0;
    width    = 200;
    height   = 32;
    padding  = 16;
	anchor	 = Anchor.Center

    // focus-related
    has_focus = function() {
		return controller.element_in_focus == self;
	}
    set_focus = function() {
        controller.element_in_focus = self; 
    }
    remove_focus = function() {
        controller.element_in_focus = undefined;
    }

    // interaction
    step = function() {}
    listen = function() { }

    // drawing
    draw = function() { }

    destroy = function() {
        // remove from controller's list of elements
		setVisibility(ElementState.HIDDEN)
        ds_list_delete(controller.elements,
            ds_list_find_index(controller.elements, self)
        );
    }
	
	static position = function() {
		return applyAnchor(anchor, x, y, width, height)
	}
	
	setVisibility = function(_elementState) {
		elementState = _elementState
	}
}

//enum ClickState {
//    DEFAULT,     // normal
//    HOVERED,     // mouse over
//    PRESSED,     // mouse down
//}

enum ElementState {
	ACTIVE,
	DISABLED,
	HIDDEN,
}