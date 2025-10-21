function applyAnchor(anchor, _x, _y, width, height) {
    var pos = { x: _x, y: _y };

    switch(anchor) {
        case Anchor.Top:
            pos.x = _x + middleOf(width)
            pos.y = _y
            break;
        case Anchor.Bottom:
            pos.x = _x + middleOf(width)
            pos.y = _y - height
            break;
        case Anchor.Left:
            pos.x = _x
            pos.y = _y + middleOf(height)
            break;
        case Anchor.Right:
            pos.x = _x - width
            pos.y = _y + middleOf(height)
            break;
        case Anchor.Center:
            pos.x = _x + middleOf(width)
            pos.y = _y + middleOf(height)
            break;
    }

    return pos; // struct {x, y}
}

function setAnchorToAlign(anchor) {
	var _vAlign = fa_middle
	var _hAlign = fa_center
	
	switch(anchor) {
        case Anchor.Top:
			_vAlign = fa_top
            break;
        case Anchor.Bottom:
			_vAlign = fa_bottom
            break;
        case Anchor.Left:
			_hAlign = fa_left
            break;
        case Anchor.Right:
			_hAlign = fa_right
            break;
    }
	draw_set_halign(_hAlign);
	draw_set_valign(_vAlign);
}


function middleOf(_dimension) {
	return - (_dimension / 2)
}

enum Anchor {
    Top,
    Bottom,
    Left,
    Right,
    Center
}