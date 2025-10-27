// Projectile update ------------------------------------

function genericBulletUpdate(instanceID)
{
	//if (lifetime <= 0) array_delete(oController.projectilePool, instanceID, 1)
	if (place_meeting(x, y, global.tilemapCollision) or lifetime <= 0) instance_destroy()
	lifetime--
	x += lengthdir_x(projectile.projectileSpeed, dir)
	y += lengthdir_y(projectile.projectileSpeed, dir)
}

function genericMeleeHitUpdate()
{
}


// Projectile draw ----------------------------------------

function genericProjectileDraw()
{
	draw_sprite(projectile.sprite, 0, xPos, yPos)
}