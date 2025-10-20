function Canvas(_name, _group, _x, _y, _width, _height, _sprite = undefined, _anchor = Anchor.Center) : GUIElement() constructor {

    // passed-in vars
    x           = _x;
    y           = _y;
    name        = _name;
	group		= _group;
	anchor		= _anchor;
	sprite		= _sprite;
	width		= _width;
	height		= _height;
	
    /// @function   click()
    static click = function() {
        set_focus();
	}

    /// @function   draw()
    static draw = function() {
		var old_color = draw_get_color();
		
		// get text size
		var pos = position()
		
        if (!is_undefined(sprite)) {
		   // --- Choose sprite based on clickState ---
			draw_sprite_stretched(sprite, 0, pos.x, pos.y, width, height);
        } else {
            draw_set_color(c_white);
			draw_rectangle(pos.x, pos.y, pos.x + width, pos.y + height, false);
			draw_set_color(c_black);
        }
		
		draw_set_color(old_color);
    }
}