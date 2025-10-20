/// @function   Button(string:name, real:x, real:y)
function Button(_name, _group, _text, _x, _y, _onClick, _buttonSprites, _anchor = Anchor.Center) : GUIElement() constructor {

    // passed-in vars
    x           = _x;
    y           = _y;
    name        = _name;
	group		= _group;
	text		= _text;
	anchor		= _anchor;
	onClick		= _onClick;
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
		
			var btn_w = tw + padding * 2;
			var btn_h = th + padding * 2;
		
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
			draw_text(pos.x + width / 2, pos.y + height / 2, text);
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