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

// Weapon actions ------------------------------------

function rangedWeaponShoot()
{
	repeat (projectileAmount)
	{
		var bullet = instance_create_layer(xPos, yPos, "Instances", oProjectile, projectile)
		bullet.x = xPos
		bullet.y = yPos
		bullet.dir = aimDirection
		bullet.dir += random_range(-spread/2, spread/2)
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
	
	primaryActionCooldown = max(primaryActionCooldown - 1, -1)
	
	if (projectile.ownerID.object_index == oPlayer and oController.primaryButton)
		holdingTrigger = true
	
	if (projectile.ownerID.object_index == oPlayer) {	// player holds the gun
		// Get rid of weapon after running out of durability
		if (remainingDurability <= 0) {
			with (oPlayer) {
				weaponInventory[activeInventorySlot] = acquireWeapon(WEAPON.fists, id);
			}
		}
	}
		
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
	
	if (active and holdingTrigger and primaryActionCooldown <= 0 and (magazineAmmo > 0 or magazineAmmo == -1))
	{
		while (primaryActionCooldown <= 0)
		{
			primaryActionCooldown += 60 / (attackSpeed * global.gameSpeed)
			primaryAction()
			remainingDurability--
			if (magazineAmmo > 0) magazineAmmo--
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