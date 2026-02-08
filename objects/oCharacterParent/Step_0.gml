// Check if the character is set up correctly.
if (characterType == noone) {
	show_message("Character is not set up correctly: " + object_get_name(object_index));
}

if (characterType != CHARACTER_TYPE.player and global.gameSpeed < .0001)
	return;

#region Momentum friction

mhsp *= 1 - (1 - frictionMult) * global.gameSpeed
mvsp *= 1 - (1 - frictionMult) * global.gameSpeed

if (abs(mhsp) < .001) mhsp = 0
if (abs(mvsp) < .001) mvsp = 0

#endregion

#region AOE collision	(not implemented)

//var aoeList = ds_list_create()
//var colliding = instance_place_list(x, y, oAreaEffect, aoeList, false)
//if (colliding)
//{
//	for (var i = 0; i < ds_list_size(aoeList); i++)
//	{
//		aoeList[| i].effect()
//	}
//}

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
var animationFrames = anim(characterState, imageOffset);

var start = animationFrames.range[0];
var ended = animationFrames.range[1];

sprite_frame += image_speed;

if (sprite_frame >= ended + 1) sprite_frame = start; // loop back
if (sprite_frame < start) sprite_frame = start;

image_speed = animationFrames.speeds[max(0, floor(sprite_frame) - start)];
		
//image_index = floor(image_fake_index)
	
// STEP EVENT OF THE SPECIFIC CHARACTER --------------------
if (is_callable(stepEvent)) {
	stepEvent(); 
} else {
	warning("stepEvent is not callable for NPC: " + string(name) );
}

#endregion

#region Apply effects

for (var i = array_length(effects)-1; i >= 0; i--)
{
	effects[i].applyEffect(id)

	if (effects[i].duration <= .00001)
		array_delete(effects, i, 1)
}

#endregion

#region Evaluate collisions and position

// Evaluate momentum
hsp = whsp + mhsp
vsp = wvsp + mvsp

// Collision
evaluateCollision(hsp, vsp);

// Walk particles
if ((x != xprevious or y != yprevious) and walkDustTimeCounter <= 0)
{
	var moveDir = point_direction(x, y, xprevious, yprevious)
	var spread = 70
	part_type_direction(oController.walkDust, moveDir-spread, moveDir+spread, random_range(-2, 2), 0)
	part_particles_create(oController.walkDustSys, random_range(x-4,x+4), random_range(bbox_bottom-4, bbox_bottom+4), oController.walkDust, 4)
	walkDustTimeCounter = 1 / oController.walkDustSpawnFreq
	
	var sound = choose(sndFootstep1, sndFootstep2, sndFootstep3, sndFootstep4, sndFootstep5, sndFootstep6)
	var gain = .3
	if (object_index != oPlayer)
	{
		gain *= .4
		
		var playerDist = point_distance(x, y, oPlayer.x, oPlayer.y)
		var maxDist = 300
		var volume = 1 - power(playerDist / maxDist, 2)
		volume = clamp(volume, 0, 1)
		gain *= volume
	}
	var pitch = random_range(.7, 1.7)
	audio_play_sound(sound, 0, false, gain, 0, pitch)
	//show_debug_message(gain)
}

if (x != xprevious or y != yprevious) {
	walkDustTimeCounter -= 1/60 * global.gameSpeed
}
else walkDustTimeCounter = 0

#endregion


/// Reset walking momentum
// This is useful for pathfinding
whsp = 0
wvsp = 0