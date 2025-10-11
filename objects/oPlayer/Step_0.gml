// Get input variables

Input()

var dt = delta_time / 1000000 * 60;

#region Walking

var walkDir = point_direction(0, 0, right - left, down - up)
whsp = lengthdir_x(walkSpd, walkDir) * sign(right + left)
wvsp = lengthdir_y(walkSpd, walkDir) * sign(down + up)

#endregion


#region Evaluate collisions and position

// Evaluate momentum
hsp = whsp
vsp = wvsp

/// Tilemap collisions

// Horizontal
if (place_meeting(x + hsp, y, tilemap))
{
	while (!place_meeting(x + sign(hsp), y, tilemap)) x += sign(hsp)
	x = round(x)
	hsp = 0;
}
x += hsp


// Vertical
if (place_meeting(x, y + vsp, tilemap))
{
	while (!place_meeting(x, y + sign(vsp), tilemap)) y += sign(vsp)
	y = round(y)
	vsp = 0;
}
y += vsp

#endregion


// Debug
if (escapeButton) game_end()
if (keyboard_check(ord("R"))) game_restart()