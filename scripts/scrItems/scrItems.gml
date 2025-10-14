enum PROJECTILE_TYPE
{
	melee,
	ranged,
	special
}

enum PROJECTILE_EFFECT
{
	nothing
}

function Projectile() constructor
{	
	// Modifiable attributes
	damage = 10
	damageMultiplier = 1
	projectileSpeed = 4
	targetKnockback = 5
	effect = PROJECTILE_EFFECT.nothing
	
	// Generic attributes
	type = PROJECTILE_TYPE.ranged
	sprite = sPlaceholderProjectile
}

function Weapon() constructor
{
	// Modifiable attributes
	projectile = noone
	attackSpeed = 2		// shots/damage amount per second
	spread = 0			// weapon accuracy in degrees
	
	// Generic attributes
	sprite = sPlaceholderGun
	name = "Generic weapon"
	description = "This weapon is a weapon"
	
	// Scene attributes
	active = false
	xPos = 0
	yPos = 0
	primaryActionCooldown = 0
	secondaryActionCooldown = 0
	
	// Weapon actions
	primaryAction = rangedWeaponShoot
	secondaryAction = noone
	
	// Weapon functions
	update = genericWeaponUpdate	// Runs every frame
	draw = genericWeaponDraw		// Runs when weapon is held
}

function genericWeaponUpdate()
{
	xPos = oPlayer.x
	yPos = oPlayer.y
	
	primaryActionCooldown = max(primaryActionCooldown - 1, -1)
	
	if (oPlayer.primaryButton and primaryActionCooldown <= 0)
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

function genericWeaponDraw()
{
	draw_sprite(sprite, 0, xPos, yPos)
}

// Shooting behaviour

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

// Scene projectiles

function ShotProjectile(projectileData) constructor
{	
	// Modifiable attributes
	damage = projectileData.damage
	damageMultiplier = projectileData.damageMultiplier
	projectileSpeed = projectileData.projectileSpeed
	targetKnockback = projectileData.targetKnockback
	effect = projectileData.effect
	
	// Generic attributes
	type = projectileData.type
	sprite = projectileData.sprite
	
	// Scene attributes (set by the object spawning this projectile)
	lifetime = (2 * 60) / global.gameSpeed
	xPos = 0
	yPos = 0
	dir = 0
	color = c_white
	
	// Decide scene behaviour
	switch (type)
	{
		case PROJECTILE_TYPE.melee:
			update = genericMeleeHitUpdate
			break
		
		case PROJECTILE_TYPE.ranged:
			update = genericBulletUpdate
			break
			
		default:
			update = noone
			show_message("Projectile update is not defined!")
			break
	}
	draw = genericProjectileDraw
}

function genericProjectileDraw()
{
	draw_sprite(sprite, 0, xPos, yPos)
}

function genericBulletUpdate(instanceID)
{
	//if (lifetime <= 0) array_delete(oController.projectilePool, instanceID, 1)
	if (lifetime <= 0) instance_destroy()
	lifetime--
	x += lengthdir_x(projectileSpeed, dir)
	y += lengthdir_y(projectileSpeed, dir)
}

function genericMeleeHitUpdate()
{
}








