// Projectile update ------------------------------------

/// Detects all of the colliding enemies
///@return true/false wether the bullet hit something
function projectileHitDetectionArea()
{
	var hit = false
	var collidingList = ds_list_create()
	instance_place_list(x, y, oEnemy, collidingList, false)
	for (var i = 0; i < ds_list_size(collidingList); i++)
	{
		var colliding = collidingList[| i]
		if (projectileAuthority == PROJECTILE_AUTHORITY.self and
			colliding != ownerID and
			colliding.characterClass != CHARACTER_CLASS.NPC)
		{
			//if !(!is_undefined(oRoomManager.tileMapWall) and projectileType == PROJECTILE_TYPE.melee and !LineOfSightPoint(colliding.x, colliding.y))
			GetHit(colliding, id)
			hit = true
		}
	}
	ds_list_destroy(collidingList)
	
	if (place_meeting(x, y, global.tilemapCollision) or lifetime <= 0)
		hit = true
	
	return hit
}

/// Detects one of the colliding enemies - faster variant of projectileHitDetectArea
///@return true/false wether the bullet hit something
function projectileHitDetection()
{
	var hit = false
	var colliding = instance_place(x, y, oCharacterParent)
	if (colliding != noone)
	{
		if (projectileAuthority == PROJECTILE_AUTHORITY.self and
			colliding != ownerID and
			colliding.characterClass != CHARACTER_CLASS.NPC)
		{
			//if !(!is_undefined(oRoomManager.tileMapWall) and projectileType == PROJECTILE_TYPE.melee and !LineOfSightPoint(colliding.x, colliding.y))
			GetHit(colliding, id)
			hit = true
		}
	}
	
	if (place_meeting(x, y, global.tilemapCollision) or lifetime <= 0)
		hit = true
	
	return hit
}

function genericProjectileDestroy()
{
	instance_destroy()
}

function genericBulletLifespan()
{
	lifetime -= global.gameSpeed
	x += lengthdir_x(projectileSpeed * global.gameSpeed, dir)
	y += lengthdir_y(projectileSpeed * global.gameSpeed, dir)
}

function genericBulletUpdate()
{
	if (projectileHitDetection()) genericProjectileDestroy()
	genericBulletLifespan()
}

function genericMeleeHitUpdate()
{
	if (hitboxActive)
	{
		var hit = projectileHitDetectionArea()
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

// The projectile that spawns the explosionš
function explosiveUpdate()
{
	genericBulletLifespan()
}

function explosionUpdate()
{
	if (lifetime <= 0) projectileHitDetectionArea()
	lifetime--
}

// ---------------------------------------------

function trashUpdate()
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