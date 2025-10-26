/// @param {string} _name - Canvas identifier
/// @param {any} _group - UI group
/// @param {real} _x - X position
/// @param {real} _y - Y position
/// @param {real} _width - Canvas width
/// @param {real} _height - Canvas height
/// @param {Asset.GMSprite} [_sprite=sCanvas] - Background sprite for the canvas
/// @param {Constant.Anchor} [_anchor=Anchor.Center] - Anchor alignment
function Canvas(_name, _group, _x, _y, _width, _height, _sprite = sCanvas, _anchor = Anchor.Center) : GUIElement() constructor {

    // passed-in vars
    x           = _x;
    y           = _y;
    name        = _name;
	group		= _group;
	anchor		= _anchor;
	sprite		= _sprite;
	width		= _width;
	height		= _height;


    /// @function   draw()
    draw = function() {
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