/**
 * @function GUIElement
 * @description Base struct for all GUI elements.
 * @returns {struct.GUIElement}
 */
function GUIElement() constructor {

    // int, string, or bool based on type
	group		= undefined; // group connect same UI elements
    name		= undefined; // unique name

	static elementState = ElementState.ACTIVE
	
	static controller	= ElementController()
	ds_list_add(controller.elements, self); 

    // dimensions
	x		 = 0;
	y		 = 0;
    static width    = 200;
    static height   = 32;
    static padding  = {x: 16, y: 16};
	static anchor	 = Anchor.Center

    // focus-related
    static has_focus = function() {
		return controller.element_in_focus == self;
	}
    static set_focus = function() {
        controller.element_in_focus = self; 
    }
    static remove_focus = function() {
        controller.element_in_focus = undefined;
    }

    // interaction
    step = function() {}
    static listen = function() { }

    // drawing
    static draw = function() { }

    static destroy = function() {
        // remove from controller's list of elements
		setVisibility(ElementState.HIDDEN)
        ds_list_delete(controller.elements,
            ds_list_find_index(controller.elements, self)
        );
    }
	
	static position = function() {
		return applyAnchor(anchor, x, y, width, height)
	}
	
	static setVisibility = function(_elementState) {
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