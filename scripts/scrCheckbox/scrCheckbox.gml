/// @struct		Checkbox
/// @param {string} _name - The button name
/// @param {any} _group - UI group
/// @param {real} [_x=0] - The X position
/// @param {real} [_y=0] - The Y position
/// @param {function} [_onClick=function(checked) {}] - Callback invoked after toggling 
/// @param {Constant.Anchor} [_anchor=Anchor.Center] - Anchor position
function Checkbox(_name, _group, _x = 0, _y = 0, _onClick = function() {}, _anchor = Anchor.Center) : GUIInteractable() constructor {

    // passed-in vars
	name        = _name;
	group		= _group;
    x           = _x;
    y           = _y;
	anchor		= _anchor;
	onClick		= _onClick;
	
	size		= 16
	height		= size
	width		= size
	checked		= false;
	
    /// @function   click()
    static click = function() {
        set_focus();
		checked = !checked
        if (is_callable(onClick)) {
            onClick();
        }
	}

    /// @function   draw()
    static draw = function() {
		safeDraw(function() {
			// get text size
	        draw_set_halign(fa_center);
	        draw_set_valign(fa_middle);
		
			var pos = position()
			show_debug_message(string(pos))
			draw_point(pos.x, pos.y)

		    draw_rectangle(pos.x - (size / 2), pos.y - (size / 2), pos.x + (size / 2), pos.y + (size / 2), true); // box
		
			if (checked) {
				draw_line(pos.x - size/3, pos.y - size/3, pos.x + size/3, pos.y + size/3);
				draw_line(pos.x + size/3, pos.y - size/3, pos.x - size/3, pos.y + size/3);
			}
		})
    }
	
}
