enum PROJECTILE_TYPE
{
	melee, ranged, special
}

enum PROJECTILE_AUTHORITY
{
	self,		// Damages all characters other then himself
	monster
}

enum PROJECTILE_EFFECT
{
	nothing
}

function WeaponsInit()
{
	enum WEAPON
	{
		// Player focused
		defaultGun, fists,
		
		// Monsters focused
		ghosterGun,
		
		// --------------
		length
	}
	
	#macro WEAPON_AMOUNT WEAPON.length

	
	var weaponDatabase = array_create(WEAPON_AMOUNT)
	for (var i = 0; i < WEAPON_AMOUNT; i++)
		weaponDatabase[i] = new Weapon()
		
	// -----------------------------------------------------------------------------

	with (weaponDatabase[WEAPON.defaultGun])
	{
		// Generic attributes
		sprite = sPlaceholderGun
		name = "Some generic weapon"
		description = "This weapon is a weapon"
	
		// Modifiable attributes
		projectile = noone
		attackSpeed = 3			// shots/damage amount per second
		spread = 30				// weapon accuracy in degrees
		projectileAmount = 5	// number of projectile to be shot in the shoot frame
		
		// Non-modifiable attributes
		magazineSize = -1
		reloadTime = 0
		
		// Update some scene attributes
		remainingDurability = durability
		magazineAmmo = magazineSize	// Remaining bullets before reloading
	
		// Weapon projectile/hurtbox
		projectile = new Projectile()
		with (projectile)
		{
			// Modifiable attributes
			damage = 10
			projectileSpeed = 3
			targetKnockback = 5
			effects = []
	
			// Generic attributes
			type = PROJECTILE_TYPE.ranged
			sprite = sPlaceholderProjectile
		}
	
		// Weapon actions
		primaryAction = rangedWeaponShoot
		secondaryAction = function() { show_debug_message("Secondary function is undefined!") }
	
		// Weapon functions
		update = genericWeaponUpdate
		draw = genericWeaponDraw
	}
		
	// -----------------------------------------------------------------------------
	
	with (weaponDatabase[WEAPON.fists]) // Empty weapon slot
	{
		// Generic attributes
		sprite = sFists
		name = "Probably fists"
		description = "We will see"
	
		// Modifiable attributes
		projectile = noone
		attackSpeed = 0			// shots/damage amount per second
		spread = 0				// weapon accuracy in degrees
		projectileAmount = 0	// number of projectile to be shot in the shoot frame
		
		// Weapon projectile/hurtbox
		projectile = new Projectile()
		with (projectile)
		{
			// Modifiable attributes
			damage = 0
			projectileSpeed = 3
			targetKnockback = 5
			effects = []
	
			// Generic attributes
			type = PROJECTILE_TYPE.melee
			sprite = sPlaceholderProjectile
		}
	
		// Weapon actions
		primaryAction = nothingFunction
		secondaryAction = nothingFunction
	
		// Weapon functions
		update = nothingFunction
		draw = nothingFunction
	}
	
		
	// -----------------------------------------------------------------------------

	with (weaponDatabase[WEAPON.ghosterGun])
	{
		// Generic attributes
		sprite = sPlaceholderGun
	
		// Modifiable attributes
		attackSpeed = 3			// shots/damage amount per second
		spread = 30				// weapon accuracy in degrees
		
		// Non-modifiable attributes
		magazineSize = 10
		reloadTime = 3
		
		// Update some scene attributes
		remainingDurability = durability
		magazineAmmo = magazineSize	// Remaining bullets before reloading
	
		// Weapon projectile/hurtbox
		projectile = new Projectile()
		with (projectile)
		{
			// Modifiable attributes
			damage = 10
			projectileSpeed = 3
			targetKnockback = .5
			effects = []
	
			// Generic attributes
			type = PROJECTILE_TYPE.ranged
			sprite = sPlaceholderProjectile
		}
	
		// Weapon actions
		primaryAction = rangedWeaponShoot
		secondaryAction = function() { show_debug_message("Secondary function is undefined!") }
	
		// Weapon functions
		update = genericWeaponUpdate
		draw = genericWeaponDraw
	}
	
	// ----------------------------------------------------------
	
	// Compile into JSON for easy copying
	global.weaponDatabaseJSON = array_create(WEAPON_AMOUNT)
	for (var i = 0; i < WEAPON_AMOUNT; i++)
	{
		weaponDatabase[i].index = i
		global.weaponDatabaseJSON[i] = json_stringify(weaponDatabase[i], false)
	}
}