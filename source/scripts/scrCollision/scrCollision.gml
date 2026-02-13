/// Tilemap and object collision
function evaluateCollision(hsp, vsp)
{
	// Horizontal
	var _xx = x;
	if (place_meeting(x + hsp * global.gameSpeed, y, global.tilemapCollision))	// tile collision
	{
		while (!place_meeting(x + sign(hsp), y, global.tilemapCollision)) {
			x += sign(hsp)
		}
		x = round(x)
		hsp = 0;
	}
	if (place_meeting(x + hsp * global.gameSpeed, y, oCollider))				// object collision
	{
		while (!place_meeting(x + sign(hsp), y, oCollider)) {
			x += sign(hsp)
		}
		x = round(x)
		hsp = 0;
	}
	var hspClamped = abs(min(hsp * global.gameSpeed, TILE_SIZE)) * sign(hsp) // Simpler than improving collision code lmao
	x += hspClamped


	// Vertical
	if (place_meeting(x, y + vsp * global.gameSpeed, global.tilemapCollision))	// tile collision
	{
		while (!place_meeting(x, y + sign(vsp), global.tilemapCollision)) y += sign(vsp)
		y = round(y)
		vsp = 0;
	}
	if (place_meeting(x, y + vsp * global.gameSpeed, oCollider))				// object collision
	{
		while (!place_meeting(x, y + sign(vsp),oCollider)) y += sign(vsp)
		y = round(y)
		vsp = 0;
	}
	var vspClamped = abs(min(vsp * global.gameSpeed, TILE_SIZE)) * sign(vsp)
	y += vspClamped
}