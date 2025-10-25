/// @param {string} _name - Textfield identifier
/// @param {any} _group - UI group
/// @param {real} _x - X position
/// @param {real} _y - Y position
/// @param {string} [_defaultText=""] - Default text to display
function TextField(_name, _group, _x, _y, _defaultText = "") : GUIInteractable() constructor {

    // passed-in vars
    name    = _name;
	group	= _group;
    x       = _x;
    y       = _y;
	text	= _defaultText

    /// @function   set(string:str)
    set = function(str) {
        // value hasn't changed; quit
        if (text == str) return;

        text = str;
    }

    /// @function   click()
    click = function() {
        set_focus();
        keyboard_string = text;    
    }

    /// @function   listen()
    listen = function() {
        set(keyboard_string);   
        if (keyboard_check_pressed(vk_enter)) remove_focus();
    }

    /// @function   draw()
    draw = function() {
		pos = position()
		safeDraw(function () {
	        draw_set_alpha(has_focus() ? 1 : 0.5);

	        // bounding box
	        draw_rectangle(pos.x, pos.y, pos.x + width, pos.y + height, true);

		    // draw input text
		    draw_text(pos.x + padding, pos.y + (height * 0.5), text);

		    draw_set_alpha(1);
		})
    }
}
