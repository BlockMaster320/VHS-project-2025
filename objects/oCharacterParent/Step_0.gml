#region Calculate knockback

mhsp *= frictionMult
mvsp *= frictionMult

if (abs(mhsp) < .001) mhsp = 0
if (abs(mvsp) < .001) mvsp = 0

#endregion



#region Evaluate collisions and position

// Evaluate momentum
hsp = whsp + mhsp
vsp = wvsp + mvsp

if (y < 120) room_goto(rmGame)

/// Tilemap collisions

// Horizontal
if (place_meeting(x + hsp, y, global.tilemapCollision))
{
	while (!place_meeting(x + sign(hsp), y, global.tilemapCollision)) x += sign(hsp)
	x = round(x)
	hsp = 0;
}
x += hsp


// Vertical
if (place_meeting(x, y + vsp, global.tilemapCollision))
{
	while (!place_meeting(x, y + sign(vsp), global.tilemapCollision)) y += sign(vsp)
	y = round(y)
	vsp = 0;
}
y += vsp

#endregion


/// Reset walking momentum
// This is useful for pathfinding
whsp = 0
wvsp = 0