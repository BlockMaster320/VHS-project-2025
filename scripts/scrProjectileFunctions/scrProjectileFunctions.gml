// Projectile update ------------------------------------

function projWallCollision()
{
	var minWallThickness = 1.3 * TILE_SIZE
	if (place_meeting(x, y, global.tilemapCollision))
		if (place_meeting(x + lengthdir_x(minWallThickness, dir), y + lengthdir_y(minWallThickness, dir), global.tilemapCollision))
		{
			//var wallhit = choose(sndWallHit_001, sndWallHit_002, sndWallHit_003, sndWallHit_004, sndWallHit_005)
			var pitch = random_range(.9, 1.1)
			audio_play_sound(sndWallHit, 0, false, .2, 0, pitch)
			
			return true
		}
			
	return false
}

/// Detects all of the colliding enemies
///@return true/false wether the bullet hit something
function projectileHitDetectionArea(includeWalls=false)
{
	var hit = false
	var collidingList = ds_list_create()
	instance_place_list(x, y, oCharacterParent, collidingList, false)
	for (var i = 0; i < ds_list_size(collidingList); i++)
	{
		var colliding = collidingList[| i]
		if (instance_exists(colliding) and
			projectileAuthority == PROJECTILE_AUTHORITY.self and
			colliding != ownerID and
			colliding.characterClass != CHARACTER_CLASS.NPC)
		{
			if (projType == PROJECTILE_TYPE.melee and !LineOfSightPoint(colliding.x, colliding.y))
				continue
				
			GetHit(colliding, id)
			hit = true
		}
	}
	ds_list_destroy(collidingList)
	
	if (lifetime <= 0)
		hit = true
		
	if (includeWalls and projWallCollision())
		hit = true
	
	return hit
}

/// Detects one of the colliding enemies - faster variant of projectileHitDetectArea (no list allocation)
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
			//if !(!is_undefined(oRoomManager.tileMapWall) and projType == PROJECTILE_TYPE.melee and !LineOfSightPoint(colliding.x, colliding.y))
			GetHit(colliding, id)
			return true
		}
	}
	
	if (lifetime <= 0) return true
	if (projWallCollision()) return true
	
	return false
}

function genericProjectileDestroy()
{
	// Particles
	if (projType == PROJECTILE_TYPE.ranged)
	{
		//part_type_direction(oController.bulletImpact, dir-15, dir+15, 0, 0)
		//part_particles_create(oController.bulletImpactSys, x, y, oController.bulletImpact, 5)
		var spread = 30
		part_type_direction(oController.bulletImpact, dir+180-spread , dir+180+spread , 0, 0)
		part_type_speed(oController.bulletImpact,projectileSpeed*.8,projectileSpeed*1.2,-(projectileSpeed*.04),0)
		part_particles_create(oController.bulletImpactSys, x, y, oController.bulletImpact, 4)
	}
	
	instance_destroy()
}

function genericBulletLifespan()
{
	lifetime -= global.gameSpeed
	existanceTime += global.gameSpeed;
	x += lengthdir_x(projectileSpeed * global.gameSpeed, dir + dirOffset)
	y += lengthdir_y(projectileSpeed * global.gameSpeed, dir + dirOffset)
	
	image_angle = dir
	
	if (rotateInDirection) drawRot = dir;
}

function genericBulletUpdate()
{
	if (projectileHitDetection())
	{
		destroy()
		return
	}
	genericBulletLifespan()
}

function genericMeleeHitUpdate()
{
	if (hitboxActive)
	{
		var hit = projectileHitDetectionArea()
		if (hit) hitboxActive = false
	}
	if (lifetime <= 0)
	{
		destroy()
		return
	}
	lifetime -= global.gameSpeed
	
	if (instance_exists(ownerID))	// Actually important in the case
	{								//  when owner dies in the same frame
		x = ownerID.x
		y = ownerID.y
	}
	
}

// Fan

function fanProjUpdate()
{	
	if (lifetime <= 0)
	{
		destroy()
		return;
	}
	lifetime = 0
	
	projectileHitDetectionArea()
		
	//if (instance_exists(ownerID))	// Actually important in the case
	//{								//  when owner dies in the same frame
	//	x = ownerID.x
	//	y = ownerID.y
	//}
}

// The projectile that spawns the explosionš
function explosiveUpdate()
{
	if (projectileHitDetection())
	{
		destroy()
		return;
	}
	genericBulletLifespan()
}

function explosionUpdate()
{
	if (lifetime <= 0)
	{
		destroy()
		return
	}
	projectileHitDetectionArea()
	lifetime = 0
}

function explosiveDestroy()
{
	var explosion = instance_create_layer(x, y, "Instances", oProjectile, projectileChild)
	explosion.sprite_index = sExplosion
	explosion.image_xscale = explosion.scale * explosion.xScaleMult
	explosion.image_yscale = explosion.scale * explosion.yScaleMult
	oCamera.currentShakeAmount += 25
	
	part_type_direction(oController.explosionDust, dir-15, dir+15, 0, 0)
	part_particles_create(oController.explosionDustSys, x, y, oController.explosionDust, 30)
	part_type_direction(oController.explosionDust, dir-100, dir+100, 0, 0)
	part_particles_create(oController.explosionDustSys, x, y, oController.explosionDust, 20)
	part_type_direction(oController.explosionDust, 0, 360, 0, 0)
	part_particles_create(oController.explosionDustSys, x, y, oController.explosionDust, 10)
	
	var pitch = random_range(0.7, 1.5)
	audio_play_sound(sndGarbageExplosion, 0, false, 1, 0, pitch)
	
	instance_destroy()
}

// Garbage

function garbageUpdate()
{
	explosiveUpdate()
}

// Paper Plane
function paperPlaneUpdate()
{
	dir += cos(existanceTime * 0.2) * 2;
	genericBulletUpdate()
}

// Projectile draw ----------------------------------------

function genericProjectileDraw()
{	
	var _flip = (drawRot > 90 && drawRot <= 270) ? -1 : 1;
	//var _scaleX = (projType == PROJECTILE_TYPE.ranged) ? scale : 1;	// projectile scaling needs a rework
	var _scaleX = scale;	// projectile scaling needs a rework
	var _scaleY = scale;

	draw_sprite_ext (
		sprite, frame, roundPixelPos(x), roundPixelPos(y),
		_scaleX, _scaleY * _flip,
		drawRot + rotationOffset, color, 1
	)
	frame = min(frame + animationSpeed, sprite_get_number(sprite) - 1);
	//draw_self()
}

function genericProjectileRotatingDraw()
{
	genericProjectileDraw()
	drawRot += 5 * global.gameSpeed
}

function fanProjDraw()
{
	genericProjectileDraw()
}