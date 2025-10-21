function GUIElement() constructor {

    // int, string, or bool based on type
	static group		= undefined; // group connect same UI elements
    static name			= undefined; // unique name
	
	static clickState	= ClickState.DEFAULT
	static elementState = ElementState.ACTIVE
	
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
    step = function() {
		var mx = device_mouse_x_to_gui(0);
		var my = device_mouse_y_to_gui(0);
		var pos = position()
		
		var is_hover = (mx > pos.x && mx < pos.x + width && my > pos.y && my < pos.y + height);


        switch (clickState) {
            case ClickState.DEFAULT:
                if (is_hover) clickState = ClickState.HOVERED;
                break;

            case ClickState.HOVERED:
                if (!is_hover) clickState = ClickState.DEFAULT;
                else if (oController.menuInteractionPress) clickState = ClickState.PRESSED;
                break;

            case ClickState.PRESSED:
                if (!oController.menuInteraction) {
                    // Mouse released → clicked up
                    if (is_hover) click();
                    clickState = is_hover ? ClickState.HOVERED : ClickState.DEFAULT;
                }
                break;
        }

        // if the element has focus, listen for input
        if (has_focus()) listen();
    }
    static click = function() { set_focus(); }
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

enum ClickState {
    DEFAULT,     // normal
    HOVERED,     // mouse over
    PRESSED,     // mouse down
}

enum ElementState {
	ACTIVE,
	DISABLED,
	HIDDEN,
}