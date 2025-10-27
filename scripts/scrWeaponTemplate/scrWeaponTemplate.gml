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
	effects = []
	
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

// Scene projectiles

function ShotProjectile(srcProjectile) constructor
{	
	projectile = srcProjectile // This copies by reference! Do not change struct values
	
	// Scene attributes (set by the object spawning this projectile)
	lifetime = (2 * 60) / global.gameSpeed
	xPos = 0
	yPos = 0
	dir = 0
	color = c_white
	
	// Decide scene behaviour
	switch (projectile.type)
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











