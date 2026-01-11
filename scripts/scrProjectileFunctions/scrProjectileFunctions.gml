// Projectile update ------------------------------------

/// Detects all of the colliding enemies
///@return true/false wether the bullet hit something
function projectileHitDetectionArea()
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
	if (place_meeting(x, y, oCharacterParent))
	{
		var colliding = instance_nearest(x, y, oCharacterParent)
		if (projectileAuthority == PROJECTILE_AUTHORITY.self and
			colliding != ownerID and
			colliding.characterClass != CHARACTER_CLASS.NPC)
		{
			//if !(!is_undefined(oRoomManager.tileMapWall) and projectileType == PROJECTILE_TYPE.melee and !LineOfSightPoint(colliding.x, colliding.y))
			GetHit(colliding, id)
			return true
		}
	}
	
	if (place_meeting(x, y, global.tilemapCollision) or lifetime <= 0)
		return true
	
	return false
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
	if (projectileHitDetection()) destroy()
	genericBulletLifespan()
}

function genericMeleeHitUpdate()
{
	if (hitboxActive)
	{
		var hit = projectileHitDetectionArea()
		if (hit) hitboxActive = false
	}
	if (lifetime <= 0) destroy()
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
	if (projectileHitDetection())
		destroy()
	genericBulletLifespan()
}

function explosionUpdate()
{
	if (lifetime <= 0) destroy()
	projectileHitDetectionArea()
	lifetime--
}

function explosiveDestroy()
{
	var explosion = instance_create_layer(x, y, "Instances", oProjectile, projectileChild)
	explosion.sprite_index = sExplosion
	explosion.image_xscale = explosion.scale
	explosion.image_yscale = explosion.scale
	oCamera.currentShakeAmount += 25.
	instance_destroy()
}

// ---------------------------------------------

function trashUpdate()
{
	explosiveUpdate()
}


// Projectile draw ----------------------------------------

function genericProjectileDraw()
{	
	draw_sprite_ext(sprite, 0, roundPixelPos(x), roundPixelPos(y), scale, scale, drawRot, c_white, 1)
	//draw_self()
}

function genericProjectileRotatingDraw()
{
	draw_sprite_ext(sprite, 0, roundPixelPos(x), roundPixelPos(y), scale, scale, drawRot, c_white, 1)
	drawRot += 5
}