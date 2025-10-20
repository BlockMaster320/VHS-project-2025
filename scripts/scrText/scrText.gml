function Text(_name, _group, _text, _x, _y, _anchor = Anchor.Center) : GUIElement() constructor {

    // passed-in vars
    x           = _x;
    y           = _y;
    name        = _name;
	group		= _group;
	text		= _text;
	anchor		= _anchor;
	
    /// @function   click()
    static click = function() {
        set_focus();
	}

    /// @function   draw()
    static draw = function() {
		safeDraw(function() {
			setAnchorToAlign(anchor)
			var old_color = draw_get_color();
	        draw_text(x, y, text);
			draw_set_color(old_color);
		})
    }
}