// Get input variables
Input(global.inputState)

//var dt = delta_time / 1000000 * 60

#region Walking

var walkDir = point_direction(0, 0, right - left, down - up)
whsp = lengthdir_x(walkSpd * global.gameSpeed, walkDir) * sign(right + left)
wvsp = lengthdir_y(walkSpd * global.gameSpeed, walkDir) * sign(down + up)

#endregion


#region Evaluate collisions and position

// Evaluate momentum
hsp = whsp
vsp = wvsp

/// Tilemap collisions

// Horizontal
var _playerW = sprite_get_width(sPlayer);
var _playerH = sprite_get_height(sPlayer);
if (place_meeting(x + hsp, y, tilemap))
{
	var tile = tilemap_get_at_pixel(tilemap, x + hsp + (_playerW / 2) * sign(hsp), y);
	var tileId = tile_get_index(tile);
	
	if (tileId < 50)  {
		while (!place_meeting(x + sign(hsp), y, tilemap)) x += sign(hsp)
		x = round(x)
		hsp = 0;
	}
}
x += hsp


// Vertical
if (place_meeting(x, y + vsp, tilemap))
{
	var tile = tilemap_get_at_pixel(tilemap, x, y + vsp + (_playerH / 2) * sign(vsp));
	var tileId = tile_get_index(tile);
	
	if (tileId < 50)  {
		while (!place_meeting(x, y + sign(vsp), tilemap)) y += sign(vsp)
		y = round(y)
		vsp = 0;
	}
}
y += vsp

#endregion


#region Weapon Inventory

for (var i = 0; i < INVENTORY_SIZE; i++)
	weaponInventory[0].update()

#endregion


// Debug
if (escapeButton) game_end()
if (keyboard_check(ord("R"))) game_restart()