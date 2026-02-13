/**
 * Applies an anchor offset to a position based on the specified anchor type.
 *
 * @param {Constant} anchor - Anchor position.
 * @param {real} _x - The base x position.
 * @param {real} _y - The base y position.
 * @param {real} width - The width of the object.
 * @param {real} height - The height of the object.
 * @returns {struct} {x: real, y: real} - The adjusted position.
 */
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

/// @desc Enum representing anchor positions for UI elements
/// @enum Anchor
/// @value Left
/// @value Right
/// @value Top
/// @value Bottom
/// @value Center
enum Anchor {
    Top,
    Bottom,
    Left,
    Right,
    Center
}