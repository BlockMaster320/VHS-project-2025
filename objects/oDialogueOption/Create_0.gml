text = ""
active = false
selected = false
idx = 0

left = 2 * PADDING_H
right = 0
top = 0
bottom = 0

isClicked = function (_x, _y)
{
	return _x >= left && _x <= right && _y >= top && _y <= bottom
}
