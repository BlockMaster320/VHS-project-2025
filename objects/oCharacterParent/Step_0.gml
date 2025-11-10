// Check if the character is set up correctly.
if (characterType == noone) {
	show_message("Character is not set up correctly: " + object_get_name(object_index));
}

#region Calculate knockback

mhsp *= frictionMult
mvsp *= frictionMult

if (abs(mhsp) < .001) mhsp = 0
if (abs(mvsp) < .001) mvsp = 0

#endregion

#region Choose step event from database
/// GENERIC STEP EVENT (same for all characters)
// DEBUG
if (keyboard_check_pressed(ord("H"))) {
	hp--;
	harmed_duration = image_speed * 30
	characterState = CharacterState.Harm
}
		
// Character death
if (hp <= 0) {
	characterState = CharacterState.Dead
}
	
if (harmed_duration > 0) {
	harmed_duration -= image_speed;
}

// Animation
var animationFrames = anim(characterState);
var start = animationFrames.range[0];
var ended = animationFrames.range[1];

sprite_frame += image_speed;

if (sprite_frame >= ended + 1) sprite_frame = start; // loop back
if (sprite_frame < start) sprite_frame = start;

image_speed = animationFrames.speeds[max(0, floor(sprite_frame) - start)];
		
//image_index = floor(image_fake_index)
	
// STEP EVENT OF THE SPECIFIC CHARACTER --------------------
stepEvent();

#endregion

#region Evaluate collisions and position

// Evaluate momentum
hsp = whsp + mhsp
vsp = wvsp + mvsp

if (room = rmLobby)
	if (y < 120) room_goto(	rmGame)

/// Tilemap collisions

// Horizontal
var _xx = x;
if (place_meeting(x + hsp, y, global.tilemapCollision))
{
	while (!place_meeting(x + sign(hsp), y, global.tilemapCollision)) {
		x += sign(hsp)
	}
	x = round(x)
	hsp = 0;
}
x += hsp
if (x < 500 && room = rmGame) {
	show_debug_message("haahhahah")
}


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