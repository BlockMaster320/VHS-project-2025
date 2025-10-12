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
		attackSpeed = 2		// shots/damage amount per second
	
		// Weapon projectile/hurtbox
		projectile = new Projectile()
		with (projectile)
		{
			// Modifiable attributes
			damage = 10
			projectileSpeed = 4
			targetKnockback = 5
			effect = PROJECTILE_EFFECT.nothing
	
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
}