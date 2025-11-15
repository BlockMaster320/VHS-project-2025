// Projectile update ------------------------------------

function bulletHitDetection()
{
	if (place_meeting(x, y, global.tilemapCollision) or lifetime <= 0) instance_destroy()
	
	var character = instance_place(x, y, oCharacterParent)
	if (character != noone)
	{
		if (projectileAuthority == PROJECTILE_AUTHORITY.self and
			character != ownerID and
			character.characterClass != CHARACTER_CLASS.NPC)
		{
			GetHit(character, id)
			instance_destroy()
		}
	}
}

function genericBulletUpdate()
{
	bulletHitDetection()
	lifetime--
	x += lengthdir_x(projectileSpeed * global.gameSpeed, dir)
	y += lengthdir_y(projectileSpeed * global.gameSpeed, dir)
}

function genericMeleeHitUpdate()
{
}

function rotatingProjectileUpdate()
{
	genericBulletUpdate()
	rot += 5
}


// Projectile draw ----------------------------------------

function genericProjectileDraw()
{	
	draw_sprite_ext(sprite, 0, x, y, 1, 1, rot, c_white, 1)
}