function nothingFunction() {}

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
		var bullet = new ShotProjectile(projectile)
		bullet.xPos = xPos
		bullet.yPos = yPos
		bullet.dir = aimDirection
		bullet.dir += random_range(-spread/2, spread/2)
	
		var inst = instance_create_layer(xPos, yPos, "Instances", oProjectile, bullet)
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
}