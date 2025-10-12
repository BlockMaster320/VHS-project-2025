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
	projectileSpeed = 4
	targetKnockback = 5
	effect = PROJECTILE_EFFECT.nothing
	
	// Generic attributes
	type = PROJECTILE_TYPE.ranged
	sprite = sPlaceholderProjectile
	
	// Scene attributes
	xPos = 0
	yPos = 0
}

function Weapon() constructor
{
	// Modifiable attributes
	projectile = noone
	attackSpeed = 2		// shots/damage amount per second
	
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
	update = genericWeaponUpdate
	draw = genericWeaponDraw
}

function genericWeaponUpdate()
{
	xPos = oPlayer.x
	yPos = oPlayer.y
}

function genericWeaponDraw()
{
	if (active)
	{
		draw_sprite(sprite, 0, xPos, yPos)
	}
}


function rangedWeaponShoot()
{
	show_debug_message("Boom!")
}












