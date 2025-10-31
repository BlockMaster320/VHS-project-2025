function nothingFunction() {}

// Weapon actions ------------------------------------

function rangedWeaponShoot()
{
	var bullet = new ShotProjectile(projectile)
	bullet.xPos = xPos
	bullet.yPos = yPos
	bullet.dir = aimDirection
	bullet.dir += random_range(-spread/2, spread/2)
	
	var inst = instance_create_layer(xPos, yPos, "Instances", oProjectile, bullet)
	
	//array_push(oController.projectilePool, bullet)
}


// Weapon update ------------------------------------

function weaponUpdatePosition()	// Called by every weapon
{
	dir = oController.aimDir;
	flip = (dir > 90 && dir < 270) ? -1 : 1;
	if (flip < 0) dir += 180;
	
	xPos = oPlayer.x + (drawOffsetX * flip)
	yPos = oPlayer.y + drawOffsetY
	
	aimDirection = point_direction(xPos, yPos, mouse_x, mouse_y)
}

function genericWeaponUpdate()
{
	weaponUpdatePosition() // All weapons should call this
	
	primaryActionCooldown = max(primaryActionCooldown - 1, -1)
	
	if (active and oController.primaryButton and primaryActionCooldown <= 0)
	{
		while (primaryActionCooldown <= 0)
		{
			primaryActionCooldown += 60 / (attackSpeed * global.gameSpeed)
			primaryAction()
		}
	}
}


// Weapon draw ----------------------------------------

function genericWeaponDraw()
{	
	draw_sprite_ext(sprite, 0, xPos, yPos, flip, 1, dir, c_white, 1)
}