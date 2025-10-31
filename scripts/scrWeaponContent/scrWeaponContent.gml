enum PROJECTILE_TYPE
{
	melee, ranged, special
}

enum PROJECTILE_EFFECT
{
	nothing
}

function WeaponsInit()
{
	#macro WEAPON_AMOUNT 2
	
	var weaponList = array_create(WEAPON_AMOUNT, new Weapon())
	
	weaponList = array_create(WEAPON_AMOUNT)
	for (var i = 0; i < WEAPON_AMOUNT; i++)
		weaponList[i] = new Weapon()
		
	// -----------------------------------------------------------------------------

	with (weaponList[0])
	{
		// Generic attributes
		sprite = sPlaceholderGun
		name = "Some generic weapon"
		description = "This weapon is a weapon"
	
		// Modifiable attributes
		projectile = noone
		attackSpeed = 3			// shots/damage amount per second
		spread = 30				// weapon accuracy in degrees
		projectileAmount = 1	// number of projectile to be shot in the shoot frame
	
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
		secondaryAction = show_debug_message("Secondary function is undefined!")
	
		// Weapon functions
		update = genericWeaponUpdate
		draw = genericWeaponDraw
	}
		
	// -----------------------------------------------------------------------------
	
	with (weaponList[1]) // Empty weapon slot (fist?)
	{
		// Generic attributes
		sprite = sPlaceholderGun
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
	
	// ----------------------------------------------------------
	
	// Compile into JSON for easy copying
	global.weaponListJSON = array_create(WEAPON_AMOUNT)
	for (var i = 0; i < WEAPON_AMOUNT; i++)
	{
		weaponList[i].index = i
		global.weaponListJSON[i] = json_stringify(weaponList[i], false)
	}
}