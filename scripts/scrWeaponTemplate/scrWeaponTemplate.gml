function Weapon() constructor
{
	// Modifiable attributes
	projectile = noone
	attackSpeed = 2		// shots/damage amount per second
	spread = 0			// weapon accuracy in degrees
	projectileAmount = 1
	
	reloadTime = .5		// in seconds
	magazineSize = -1	// number of bullets before reloading, -1 for infinite size
	durability = infinity	// usually the number of primary action calls before breaking
	shootOnHold = true		// Wether to keep shooting when the player holds down fire
	oneTimeUse = false

	// Generic attributes
	sprite = sPlaceholderGun
	name = "Generic weapon"
	description = "This weapon is a weapon"
	drawOffsetX = 6
	drawOffsetY = 3
	
	// Scene attributes
	index = 0	// Index in the global weapon database
	active = true
	aimDirection = 0	// Update aim direction from the point of the gun
	drawDirection = 0	// Flips horizontaly (unlike aimDirection)
	xPos = 0
	yPos = 0
	flip = false
	reloading = false
	holdingTrigger = false	// Wether the weapon owner is trying to shoot
							// Resets at the end of every frame
	remainingDurability = durability
	magazineAmmo = magazineSize	// Remaining bullets before reloading
	reloadProgress = 0
	primaryActionCooldown = 0
	secondaryActionCooldown = 0
	
	// Weapon actions
	primaryAction = rangedWeaponShoot
	secondaryAction = nothingFunction
	
	// Weapon functions
	update = genericWeaponUpdate	// Runs every frame
	draw = genericWeaponDraw		// Runs when weapon is held
}

// Projectiles -------------------------------------------

// Projectile type reference
function Projectile() constructor
{	
	// Modifiable attributes
	damage = 10
	damageMultiplier = 1
	projectileSpeed = 4
	targetKnockback = 5
	effects = []
	scale = 1
	
	// Generic attributes
	sprite = sPlaceholderProjectile
	projectileAuthority = PROJECTILE_AUTHORITY.self
	projectileType = PROJECTILE_TYPE.ranged
	ownerID = -1
	
	// Scene attributes
	lifetime = (5 * 60) / global.gameSpeed
	xPos = 0
	yPos = 0
	dir = 0
	drawRot = 0
	color = c_white
	hitboxActive = true
	
	// Behaviour
	update = function(){show_debug_message("Unset projectile update!")}
	draw = function(){show_debug_message("Unset projectile draw!")}
	destroy = genericProjectileDestroy
}










