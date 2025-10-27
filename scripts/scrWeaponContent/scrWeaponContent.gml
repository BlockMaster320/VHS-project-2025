function WeaponsInit()
{
	#macro WEAPON_AMOUNT 1
	global.weaponList = array_create(WEAPON_AMOUNT, new Weapon())

	with (global.weaponList[0])
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
		secondaryAction = noone
	
		// Weapon functions
		update = genericWeaponUpdate
		draw = genericWeaponDraw
	}
	
	global.weaponListJSON = array_create(WEAPON_AMOUNT)
	for (var i = 0; i < WEAPON_AMOUNT; i++)
		global.weaponListJSON[i] = json_stringify(global.weaponList[i], false)
	
	// show_debug_message(json_stringify(global.weaponList, true))
	//show_debug_message(global.weaponListJSON[0])
}