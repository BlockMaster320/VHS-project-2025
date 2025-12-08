// Projectile update ------------------------------------

///@return true/false wether the bullet hit something
function projectileHitDetection()
{	
	var hit = false
	var collidingList = ds_list_create()
	instance_place_list(x, y, oCharacterParent, collidingList, false)
	for (var i = 0; i < ds_list_size(collidingList); i++)
	{
		var colliding = collidingList[| i]
		if (projectileAuthority == PROJECTILE_AUTHORITY.self and
			colliding != ownerID and
			colliding.characterClass != CHARACTER_CLASS.NPC)
		{
			GetHit(colliding, id)
			hit = true
		}
	}
	
	if (place_meeting(x, y, global.tilemapCollision) or lifetime <= 0)
		hit = true
	
	return hit
}

function genericBulletUpdate()
{
	if (projectileHitDetection()) instance_destroy()
	lifetime -= global.gameSpeed
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
	lifetime -= global.gameSpeed
	
	if (instance_exists(ownerID))	// Actually important in the case
	{								//  when owner dies in the same frame
		x = ownerID.x
		y = ownerID.y
	}
	
}

function rotatingProjectileUpdate()
{
	genericBulletUpdate()
	drawRot += 5
}


// Projectile draw ----------------------------------------

function genericProjectileDraw()
{	
	draw_sprite_ext(sprite, 0, x, y, scale, scale, drawRot, c_white, 1)
	//draw_self()
}