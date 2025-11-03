// Projectile update ------------------------------------

function bulletHitDetection()
{
	if (place_meeting(x, y, global.tilemapCollision) or lifetime <= 0) instance_destroy()
	
	var character = instance_place(x, y, oCharacterParent)
	if (character != noone)
	{
		if (projectile.projectileAuthority == PROJECTILE_AUTHORITY.self and
			character != projectile.ownerID)
		{
			character.GetHit(projectile)
			instance_destroy()
		}
	}
}

function genericBulletUpdate()
{
	bulletHitDetection()
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