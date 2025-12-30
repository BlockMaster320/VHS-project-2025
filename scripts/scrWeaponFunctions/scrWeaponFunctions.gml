function nothingFunction() {}

/// @param {enum/struct} weapon can be either an index from WEAPON enum or a specific Weapon struct
function acquireWeapon(weapon, owner, active_ = true)
{
	var newWeapon;
	if (is_struct(weapon)) newWeapon = weapon
	else newWeapon = json_parse(global.weaponDatabaseJSON[weapon])
	newWeapon.active = active_
	newWeapon.projectile.ownerID = owner
	return newWeapon
}

// Spawns a weapon pickup at the position and depth of the calling instance
function dropWeapon(weaponID)
{
	var weaponPickup = instance_create_depth(x, y, depth, oWeaponPickup)
	with (weaponPickup) setupWeaponPickup(weaponID)
}

// Converts 0-360 degree spread to 1-0 accuracy 
function spreadToAccuracy(spread)
{
	var spreadClamped = clamp(abs(spread), 0, 360)
	return 1 - (spreadClamped / 360)
}
// Converts 0-1 accuracy to 360-0 degree spread
function accuracyToSpread(accuracy)
{
	var accuracyClamped = clamp(accuracy, 0, 1)
	return (1 - accuracyClamped) * 360
}

// Weapon actions ------------------------------------

///@return instance of spawned bullet
function spawnBullet()
{
	var bullet = instance_create_layer(xPos, yPos, "Instances", oProjectile, projectile)
	bullet.x = xPos
	bullet.y = yPos
	bullet.dir = aimDirection
	bullet.dir += random_range(-spread/2, spread/2)
	
	return bullet
}

function rangedWeaponShoot()
{
	repeat (projectileAmount)
	{
		var bullet = spawnBullet()
		bullet.sprite_index = projectile.sprite
	}
}

function meleeWeaponShoot()
{
	repeat (projectileAmount) // Just in case of a projectileAmount upgrade
	{
		var bullet = spawnBullet()
		bullet.x = bullet.ownerID.x
		bullet.y = bullet.ownerID.y
		bullet.image_angle = bullet.dir
		bullet.drawRot = bullet.dir
		bullet.sprite_index = sMeleeHitbox
		bullet.image_xscale = projectile.scale
		bullet.image_yscale = projectile.scale
	}
}

// Weapon update ------------------------------------

function weaponUpdatePosition()	// Called by every weapon
{
	if (projectile.ownerID.object_index == oPlayer)
	{
		aimDirection = point_direction(xPos, yPos, mouse_x, mouse_y)
		drawDirection = oController.aimDir
	}
	else drawDirection = aimDirection
	
	flip = (abs(drawDirection % 360) > 90 && abs(drawDirection % 360) < 270) ? -1 : 1;
	if (flip < 0) drawDirection += 180;

	xPos = projectile.ownerID.x + (drawOffsetX * flip)
	yPos = projectile.ownerID.y + drawOffsetY
}

function genericWeaponUpdate()
{
	weaponUpdatePosition() // All weapons should call this
	
	primaryActionCooldown = max(primaryActionCooldown - global.gameSpeed, -1)
	
	var ownerIsPlayer = projectile.ownerID.object_index == oPlayer
	
	if (ownerIsPlayer)
	{
		if (oController.primaryButtonPress or (shootOnHold and oController.primaryButton))
			holdingTrigger = true
	}
	
	// Weapon durability
	if (ownerIsPlayer) {	// player holds the gun
		// Get rid of weapon after running out of durability
		if (remainingDurability <= 0) {
			with (oPlayer) {
				if (other.oneTimeUse)
				{
					tempWeaponSlot = acquireWeapon(WEAPON.fists, id, false)
					weaponInventory[activeInventorySlot].active = true
				}
				else weaponInventory[activeInventorySlot] = acquireWeapon(WEAPON.fists, id);
			}
		}
	}
		
	// Reloading
	if (reloading and magazineAmmo != magazineSize)
	{
		if (reloadProgress > reloadTime * 60)
		{
			reloadProgress = 0
			reloading = false
			magazineAmmo = magazineSize
		}
		reloadProgress += global.gameSpeed
	}
	else reloadProgress = 0
	
	// Shooting
	if (active and holdingTrigger and primaryActionCooldown <= 0 and (magazineAmmo > 0 or magazineAmmo == -1))
	{
		while (primaryActionCooldown <= 0)	// "while" instead of "if" for very high attack speeds
		{
			primaryActionCooldown += 60 / attackSpeed
			primaryAction()
			remainingDurability--
			if (magazineAmmo > 0) magazineAmmo--
			
			if (ownerIsPlayer)	// Screenshake
			{
				var shakeMult = 8
				if (!shootOnHold)
					shakeMult *= 1.8
				oCamera.currentShakeAmount += (1 / (attackSpeed + 1)) * shakeMult
			}
		}
	}
	
	holdingTrigger = false
}


// Weapon draw ----------------------------------------

function genericWeaponDraw()
{	
	draw_sprite_ext(sprite, 0, roundPixelPos(xPos), roundPixelPos(yPos), flip, 1, drawDirection, c_white, 1)
	
	if (index != WEAPON.fists)	// draw a hand holding the gun
		draw_sprite_ext(sHands, 7, roundPixelPos(xPos) - 2 * flip, roundPixelPos(yPos) - 4, flip, 1, 0, c_white, 1)
}