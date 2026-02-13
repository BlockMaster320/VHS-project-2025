 /// @param {string} _name - The button name
/// @param {any} _group - UI group
/// @param {real} [_x=0] - The X position
/// @param {real} [_y=0] - The Y position
/// @param {string} [_text="Button"] - The button text
/// @param {function} [_onClick=function() {}] - Callback when clicked
/// @param {struct.ButtonSprites} [_buttonSprites=ButtonSprites()] - Sprite set for button states
/// @param {Constant.Anchor} [_anchor=Anchor.Center] - Anchor position
function Button(_name, _group, _x = 0, _y = 0, _text = "Button", _onClick = function() {}, _buttonSprites = ButtonSprites(), _anchor = Anchor.Center) : GUIInteractable() constructor {

    // passed-in vars
	name        = _name;
	group		= _group;
    x           = _x;
    y           = _y;
	text		= _text;
	anchor		= _anchor;
	onClick		= _onClick;
	width		= 0;
	height		= 0;
	buttonSprites  = _buttonSprites;
	
    /// @function   click()
    static click = function() {
        set_focus();
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
		
		    var tw = string_width(text);
		    var th = string_height(text);
		
			var btn_w = tw + padding.x * 2;
			var btn_h = th + padding.y * 2;
		
			width = max(btn_w, width);
			height = max(btn_h, height)
		
			var pos = position()
		
			// --- Choose sprite based on clickState ---
			var _sprite = undefined;
			switch (clickState) {
			    case ClickState.DEFAULT:
			        _sprite = buttonSprites.defaultSprite;
			        break;
			    case ClickState.HOVERED:
			        _sprite = buttonSprites.hovered;
			        break;
			    case ClickState.PRESSED:
			        _sprite = buttonSprites.clickedSprite;
			        break;
			}
	
			draw_sprite_stretched(_sprite, 0, pos.x, pos.y, width, height);
			
			draw_set_color(menuTextCol)
			draw_text(pos.x + width / 2, pos.y + height / 2, text);
			draw_set_color(c_white)
		})
    }
}

function ButtonSprites(_default = sButtonDefault, _hovered = sButtonHovered, _clicked = sButtonClicked) {
    return {
        defaultSprite: _default,
        hovered: _hovered,
        clickedSprite: _clicked
    };
}