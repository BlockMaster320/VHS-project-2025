/// @param {string} _name - Text element identifier
/// @param {any} _group - UI group
/// @param {string} [_text=""] - The text to display
/// @param {real} [_x=0] - X position
/// @param {real} [_y=0] - Y position
/// @param {Constant.Anchor} [_anchor=Anchor.Center] - The anchor position (default: Anchor.Center)
function Text(_name, _group, _text = "", _x = 0, _y = 0, _anchor = Anchor.Center) : GUIElement() constructor {

    // passed-in vars
    x           = _x;
    y           = _y;
    name        = _name;
	group		= _group;
	text		= _text;
	anchor		= _anchor;
	
    /// @function   click()
    click = function() {
        set_focus();
	}

    /// @function   draw()
    draw = function() {
		safeDraw(function() {
			setAnchorToAlign(anchor)
			var old_color = draw_get_color();
	        draw_text(x, y, text);
			draw_set_color(old_color);
		})
    }
}