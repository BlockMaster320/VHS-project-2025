// Push away near enemies
var collidingEnemy = instance_place(x, y, oEnemy)
if (collidingEnemy)
{
	var pushForce = .2
	var dir = point_direction(x, y, collidingEnemy.x, collidingEnemy.y) + 180
	mhsp += lengthdir_x(pushForce, dir)
	mvsp += lengthdir_y(pushForce, dir)
}

// Character code
event_inherited()
