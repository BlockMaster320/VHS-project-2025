/// @param {string} _name - Textfield identifier
/// @param {any} _group - UI group
/// @param {real} _x - X position
/// @param {real} _y - Y position
/// @param {string} [_placeholderText=""] - Default text to display
function TextField(_name, _group, _x, _y, _placeholderText = "") : GUIInteractable() constructor {

    // passed-in vars
    name    = _name;
	group	= _group;
    x       = _x;
    y       = _y;
	placeholderText = _placeholderText;
	text	= _placeholderText;
	
	// default vars
	cursor_visible = true;			// Is the cursor currently visible
	cursor_timer = 0;				// Timer for blinking
	cursor_blink_speed = 24; 

    /// @function   set(string:str)
    set = function(str) {
        // value hasn't changed; quit
        if (text == str) return;

        text = str;
    }

    /// @function   click()
    click = function() {
        set_focus();
		keyboard_string = text
		if (text == placeholderText)
			keyboard_string = "";    
    }
	

    /// @function   listen()
    listen = function() {
        set(keyboard_string);   
        if (keyboard_check_pressed(vk_enter)) remove_focus();
    }
	
		
	static remove_focus = function() {
		if (text = "") text = placeholderText;
    }

    /// @function   draw()
    static draw = function() {
		pos = position()
		updateCursor()
		safeDraw(function () {
	        draw_set_alpha(has_focus() ? 1 : 0.5);

	        // bounding box
	        draw_rectangle(pos.x, pos.y, pos.x + width, pos.y + height, true);

		    // draw input text
		    draw_text(pos.x + padding, pos.y + (height * 0.5), text);

	        if (has_focus() && cursor_visible) {
	            var text_width = string_width(text); // width of current text
	            draw_line(
	                pos.x + padding + text_width,	// cursor X
	                pos.y + 2,						// top Y of cursor
	                pos.x + padding + text_width,	// same X
	                pos.y + height - 2              // bottom Y
	            );
	        }
		
		    draw_set_alpha(1);
		})
    }
	
	updateCursor = function() {
		if (has_focus()) {
	        cursor_timer += 1;
	        if (cursor_timer >= cursor_blink_speed) {
	            cursor_timer = 0;
	            cursor_visible = !cursor_visible;
	        }
	    } else {
	        cursor_visible = false;
	        cursor_timer = 0;
	    }
	}
}
