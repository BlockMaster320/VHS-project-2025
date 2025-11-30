enum PROJECTILE_AUTHORITY
{
	self,		// Damages all characters other then himself
	monster
}

enum PROJECTILE_EFFECT
{
	nothing
}

enum PROJECTILE_TYPE
{
	ranged, melee
}

function WeaponsInit()
{
	enum WEAPON
	{
		// Default
		fists,
		
		// Player focused (droppable?)
		defaultGun, garbage, sword,
		
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
			sprite = sPlaceholderProjectile
			projectileType = PROJECTILE_TYPE.ranged
			
			// Behaviour
			update = genericBulletUpdate
			draw = genericProjectileDraw
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
		attackSpeed = 1			// shots/damage amount per second
		spread = 0				// weapon accuracy in degrees
		projectileAmount = 1	// number of projectile to be shot in the shoot frame
		
		// Weapon projectile/hurtbox
		projectile = new Projectile()
		with (projectile)
		{
			// Modifiable attributes
			damage = 1
			projectileSpeed = 3
			targetKnockback = 5
			effects = []
			lifetime = 5
	
			// Generic attributes
			sprite = sMeleeHitbox
			projectileType = PROJECTILE_TYPE.melee
			
			// Behaviour
			update = genericMeleeHitUpdate
			draw = genericProjectileDraw
		}
	
		// Weapon actions
		primaryAction = meleeWeaponShoot
		secondaryAction = nothingFunction
	
		// Weapon functions
		update = genericWeaponUpdate
		draw = nothingFunction
	}
		
	// -----------------------------------------------------------------------------
	
	with (weaponDatabase[WEAPON.sword])
	{
		// Generic attributes
		sprite = sSword
		name = "Sword"
		description = "Slashes things"
	
		// Modifiable attributes
		projectile = noone
		attackSpeed = 2			// shots/damage amount per second
		spread = 0				// weapon accuracy in degrees
		projectileAmount = 1	// number of projectile to be shot in the shoot frame
		
		// Weapon projectile/hurtbox
		projectile = new Projectile()
		with (projectile)
		{
			// Modifiable attributes
			damage = 20
			projectileSpeed = 3
			targetKnockback = 10
			effects = []
			scale = 4
	
			// Generic attributes
			sprite = sMeleeHitbox
			lifetime = 5
			projectileType = PROJECTILE_TYPE.melee
			
			// Behaviour
			update = genericMeleeHitUpdate
			draw = genericProjectileDraw
		}
	
		// Weapon actions
		primaryAction = meleeWeaponShoot
		secondaryAction = function() { show_debug_message("Secondary function is undefined!") }
	
		// Weapon functions
		update = genericWeaponUpdate
		draw = genericWeaponDraw
	}
		
	// -----------------------------------------------------------------------------

	with (weaponDatabase[WEAPON.ghosterGun])
	{
		// Generic attributes
		sprite = sPlaceholderGun
	
		// Modifiable attributes
		attackSpeed = 1			// shots/damage amount per second
		spread = 30				// weapon accuracy in degrees
		
		// Non-modifiable attributes
		magazineSize = 6
		reloadTime = 2
		
		// Update some scene attributes
		remainingDurability = durability
		magazineAmmo = magazineSize	// Remaining bullets before reloading
	
		// Weapon projectile/hurtbox
		projectile = new Projectile()
		with (projectile)
		{
			// Modifiable attributes
			damage = 10
			projectileSpeed = 1
			targetKnockback = 2
			effects = []
	
			// Generic attributes
			sprite = sPlaceholderProjectile
			projectileType = PROJECTILE_TYPE.ranged
			
			// Behaviour
			update = genericBulletUpdate
			draw = genericProjectileDraw
		}
	
		// Weapon actions
		primaryAction = rangedWeaponShoot
		secondaryAction = function() { show_debug_message("Secondary function is undefined!") }
	
		// Weapon functions
		update = genericWeaponUpdate
		draw = genericWeaponDraw
	}
	
	// -----------------------------------------------------------------------------
	
	with (weaponDatabase[WEAPON.garbage])
	{
		// Generic attributes
		sprite = sTrashBag
		name = "Garbage"
		description = "This weapon is garbage"
		durability = 1
	
		// Modifiable attributes
		projectile = noone
		attackSpeed = 1			// shots/damage amount per second
		spread = 30				// weapon accuracy in degrees
		projectileAmount = 1	// number of projectile to be shot in the shoot frame
		
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
			targetKnockback = 15
			effects = []
	
			// Generic attributes
			sprite = sTrashBag
			projectileType = PROJECTILE_TYPE.ranged
			
			// Behaviour
			update = rotatingProjectileUpdate
			draw = genericProjectileDraw
		}

		// Weapon actions
		primaryAction = rangedWeaponShoot
		secondaryAction = function() { show_debug_message("Secondary function is undefined!") }
	
		// Weapon functions
		update = genericWeaponUpdate
		draw = genericWeaponDraw;
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