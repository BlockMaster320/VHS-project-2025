/// @function   Button(string:name, real:x, real:y)
function GUIInteractable() : GUIElement() constructor {

    // passed-in vars
	onClick		= function () {};

	// defaults
	clickState	= ClickState.DEFAULT
	
    /// @function   click()
    click = function() {
        set_focus();
        if (is_callable(onClick)) {
            onClick();
        }
	}
	
	step = function() {
		var mx = oController.gui_x
		var my = oController.gui_y
		var pos = position()
		
		var is_hover = (mx > pos.x && mx < pos.x + width && my > pos.y && my < pos.y + height);

        switch (clickState) {
            case ClickState.DEFAULT:
                if (is_hover) clickState = ClickState.HOVERED;
                break;

            case ClickState.HOVERED:
                if (!is_hover) clickState = ClickState.DEFAULT;
                else if (oController.gui_pressed) clickState = ClickState.PRESSED;
                break;

            case ClickState.PRESSED:
                if (!oController.gui_pressed) {
                    // Mouse released → clicked up
                    if (is_hover) click();
                    clickState = is_hover ? ClickState.HOVERED : ClickState.DEFAULT;
                }
                break;
        }

        // if the element has focus, listen for input
        if (has_focus()) listen();	
	}
}


enum ClickState {
    DEFAULT,     // normal
    HOVERED,     // mouse over
    PRESSED,     // mouse down
}
