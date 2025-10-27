// Weapon actions ------------------------------------

function rangedWeaponShoot()
{
	var bullet = new ShotProjectile(projectile)
	bullet.xPos = xPos
	bullet.yPos = yPos
	bullet.dir = point_direction(xPos, yPos, mouse_x, mouse_y)
	bullet.dir += random_range(-spread/2, spread/2)
	
	var inst = instance_create_layer(xPos, yPos, "Instances", oProjectile, bullet)
	
	//array_push(oController.projectilePool, bullet)
}


// Weapon update ------------------------------------

function genericWeaponUpdate()
{
	xPos = oPlayer.x
	yPos = oPlayer.y
	
	primaryActionCooldown = max(primaryActionCooldown - 1, -1)
	
	if (oController.primaryButton and primaryActionCooldown <= 0)
	{
		var i = 0
		while (primaryActionCooldown <= 0)
		{
			i++
			primaryActionCooldown += 60 / (attackSpeed * global.gameSpeed)
			primaryAction()
		}
		//show_debug_message(i)
		
			
		//repeat (1 / primaryActionCooldown) primaryAction()
	}
}


// Weapon draw ----------------------------------------

function genericWeaponDraw()
{
	var dir = oController.aimDir;
    var flip = (dir > 90 && dir < 270) ? -0.7 : 0.7;
	if (flip < 0) dir += 180;
	
	draw_sprite_ext(sprite, 0, xPos, yPos, flip, 1, dir, c_white, 1)
}