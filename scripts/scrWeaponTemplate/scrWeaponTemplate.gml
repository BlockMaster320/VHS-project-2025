function Weapon() constructor
{
	// Modifiable attributes
	type = noone;
	projectile = noone
	attackSpeed = 2		// shots/damage amount per second
	spread = 0			// weapon accuracy in degrees
	projectileAmount = 1
	
	reloadTime = .5		// in seconds
	magazineSize = -1	// number of bullets before reloading, -1 for infinite size
	durabilityMult = 2	// Multiplier of how fast durability decreases
	shootOnHold = true		// Wether to keep shooting when the player holds down fire
	oneTimeUse = false

	// Generic attributes
	sprite = sGhosterGun
	name = "Generic weapon"
	description = "This weapon is a weapon"
	drawOffsetX = 6
	drawOffsetY = 3
	drawAngle = 0;
	
	shootSound = [sndShoot]
	reloadSound = [sndReload]
	shootSoundInstance = -1
	shootPitchMax = 1.5;
	shootPitchMin = 0.7;
	
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
	shootAnim = WEAPON_ANIM_TYPE.recoil;
	shootAnimState = 0;
	shootAnimRot = 0;
	
	remainingDurability = 1
	magazineAmmo = magazineSize	// Remaining bullets before reloading
	reloadProgress = 0
	playerInventorySlot = -1
	primaryActionCooldown = 0
	secondaryActionCooldown = 0
	// Info flash
	flashFrameCounter = 0
	flashFrequency = 0	// Flash the weapon amount/s when something is happening to it
	flashFacLoc = shader_get_uniform(shFlash, "flashFac")
	roundFac = false
	flashFac = 0
	
	// Gun sprite animation (used just for fan at the moment)
	frame = 0;
	animationSpeed = 20 / 60;	// fps / 60
	
	// Weapon actions
	primaryAction = rangedWeaponShoot
	secondaryAction = nothingFunction
	
	// Weapon functions
	create = nothingFunction
	update = genericWeaponUpdate	// Runs every frame
	draw = genericWeaponDraw		// Runs when weapon is held
	destroy = nothingFunction
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
	xScaleMult = 1
	yScaleMult = 1
	projectileChild = noone
	
	// Generic attributes
	sprite = sEnemyProjectile
	projectileAuthority = PROJECTILE_AUTHORITY.self
	projType = PROJECTILE_TYPE.ranged
	ownerID = -1
	rotateInDirection = true;
	rotationOffset = 0;
	dirOffset = 0;
	
	// Scene attributes
	lifetime = (5 * 60) / global.gameSpeed
	existanceTime = 0;
	frame = 0;
	animationSpeed = 20 / 60;	// fps / 60
	srcWeapon = noone
	dir = 0
	drawRot = 0
	color = c_white
	hitboxActive = true
	objDealNoDamage = false	// When true, the projectile object itself doesn't deal damage
	skipFirstFrameDraw = false	// Collisions aren't detected on the first frame of create,
								//  so it sometimes makes sense to hide the projectile
	
	// Behaviour
	update = function(){show_debug_message("Unset projectile update!")}
	draw = function(){show_debug_message("Unset projectile draw!")}
	destroy = genericProjectileDestroy
}


// Effects ------------------------------------------------
function Effect() constructor
{
	durationDef = 10
	duration = durationDef
	effectType = -1
	applyDurDef = .5	// In seconds
	applyCounter = 0
	
	source = noone
	allowDuplicateApplication = false
	
	applyEffect = function(character){}
}







