/// Tilemap and object collision
function evaluateCollision(hsp, vsp)
{
	// Horizontal
	var _xx = x;
	if (place_meeting(x + hsp * global.gameSpeed, y, global.tilemapCollision))	// tile collision
	{
		var hspMinSign = min(abs(hsp), abs(sign(hsp))) * sign(hsp)
		while (!place_meeting(x + hspMinSign, y, global.tilemapCollision)) {
			x += hspMinSign
		}
		x = round(x)
		hsp = 0;
	}
	if (place_meeting(x + hsp * global.gameSpeed, y, oCollider))				// object collision
	{
		var hspMinSign = min(abs(hsp), abs(sign(hsp))) * sign(hsp)
		while (!place_meeting(x + hspMinSign, y, oCollider)) {
			x += hspMinSign
		}
		x = round(x)
		hsp = 0;
	}
	var hspClamped = abs(min(hsp * global.gameSpeed, TILE_SIZE)) * sign(hsp) // Simpler than improving collision code lmao
	x += hspClamped


	// Vertical
	if (place_meeting(x, y + vsp * global.gameSpeed, global.tilemapCollision))	// tile collision
	{
		var vspMinSign = min(abs(vsp), abs(sign(vsp))) * sign(vsp)
		while (!place_meeting(x, y + vspMinSign, global.tilemapCollision)) y += vspMinSign
		y = round(y)
		vsp = 0;
	}
	if (place_meeting(x, y + vsp * global.gameSpeed, oCollider))				// object collision
	{
		var vspMinSign = min(abs(vsp), abs(sign(vsp))) * sign(vsp)
		while (!place_meeting(x, y + vspMinSign,oCollider)) y += vspMinSign
		y = round(y)
		vsp = 0;
	}
	var vspClamped = abs(min(vsp * global.gameSpeed, TILE_SIZE)) * sign(vsp)
	y += vspClamped
}