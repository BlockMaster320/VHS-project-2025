// Push away near enemies
if (place_meeting(x, y, oEnemy))
{
	var collidingEnemy = instance_place(x, y, oEnemy)

	var pushForce = .2
	var dir = point_direction(x, y, collidingEnemy.x, collidingEnemy.y) + 180
	mhsp += lengthdir_x(pushForce, dir)
	mvsp += lengthdir_y(pushForce, dir)
}


// Character code
event_inherited()

// Enemy animation
if (x != xprevious or y != yprevious) {
	characterState = CharacterState.Run;
}
else
	characterState = CharacterState.Idle;