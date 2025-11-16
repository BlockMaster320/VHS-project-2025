// Projectile update ------------------------------------

///@return true/false wether the bullet hit something
function projectileHitDetection()
{
	if (place_meeting(x, y, global.tilemapCollision) or lifetime <= 0)
		return true
	
	var character = instance_place(x, y, oCharacterParent)
	if (character != noone)
	{
		if (projectileAuthority == PROJECTILE_AUTHORITY.self and
			character != ownerID and
			character.characterClass != CHARACTER_CLASS.NPC)
		{
			GetHit(character, id)
			return true
		}
	}
	
	return false
}

function genericBulletUpdate()
{
	if (projectileHitDetection()) instance_destroy()
	lifetime--
	x += lengthdir_x(projectileSpeed * global.gameSpeed, dir)
	y += lengthdir_y(projectileSpeed * global.gameSpeed, dir)
}

function genericMeleeHitUpdate()
{
	if (hitboxActive)
	{
		var hit = projectileHitDetection()
		if (hit) hitboxActive = false
	}
	if (lifetime <= 0) instance_destroy()
	lifetime--
	x = oPlayer.x
	y = oPlayer.y
	
}

function rotatingProjectileUpdate()
{
	genericBulletUpdate()
	drawRot += 5
}


// Projectile draw ----------------------------------------

function genericProjectileDraw()
{	
	//draw_sprite_ext(sprite, 0, x, y, scale, scale, drawRot, c_white, 1)
	draw_self()
}