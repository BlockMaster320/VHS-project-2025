enum PROJECTILE_AUTHORITY
{
	self,		// Damages all characters other then himself
	monster
}

enum PROJECTILE_TYPE
{
	ranged, melee, explosion
}

enum WEAPON_ANIM_TYPE
{
	recoil, swing
}

#macro durabilityInSeconds 10	// By default, the weapon is durable of this
								//	amount of seconds of non-stop shooting
								
#macro enemyProjectileCol #D8362B
#macro playerProjectileCol #FFD665

function WeaponsInit()
{
	enum WEAPON
	{
		// Default
		fists,
		
		// Player focused (droppable?)
		pigeon, fan, paperPlane, ticketMachine,
		crowbar, groanTube,
		rat,
		
		// Monsters focused
		ghosterGun, ghosterShotgun, enemyFan, enemyCrowbar,
		
		// --------------
		length
	}
	
	#macro WEAPON_AMOUNT WEAPON.length

	
	var weaponDatabase = array_create(WEAPON_AMOUNT)
	for (var i = 0; i < WEAPON_AMOUNT; i++)
		weaponDatabase[i] = new Weapon()
		
	// -----------------------------------------------------------------------------

	with (weaponDatabase[WEAPON.pigeon])
	{
		// Generic attributes
		type = WEAPON.pigeon;
		sprite = sPigeon
		name = "Pigeon"
		description = "PPPeeewww"
	
		// Modifiable attributes
		attackSpeed = 2			// shots/damage amount per second
		spread = 25				// weapon accuracy in degrees
		projectileAmount = 3	// number of projectile to be shot in the shoot frame
		drawAngle = 90;
		
		magazineSize = 4
		reloadTime = 1
		
		// Update some scene attributes
		magazineAmmo = magazineSize	// Remaining bullets before reloading
	
		// Weapon projectile/hurtbox
		projectile = new Projectile()
		with (projectile)
		{
			// Modifiable attributes
			damage = 15
			projectileSpeed = 4
			targetKnockback = 5
			effects = []
	
			// Generic attributes
			sprite = sPigeonBullet
			//color = playerProjectileCol
			projType = PROJECTILE_TYPE.ranged
			
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
	
	with (weaponDatabase[WEAPON.fan])
	{
		// Generic attributes
		type = WEAPON.fan;
		sprite = sFan
		name = "Fan"
		description = "Wheeeeeeeeee"
		shootSound = [sndFanClick]
	
		// Modifiable attributes
		projectile = noone
		attackSpeed = 4			// shots/damage amount per second
		spread = 5				// weapon accuracy in degrees
		projectileAmount = 1	// number of projectile to be shot in the shoot frame
		magazineSize = 120 * global.gameSpeed
		reloadTime = 1
		
		// Scene attributes
		holdingTriggerPrev = false
		loopingFanSound = -1
		
		// Weapon projectile/hurtbox
		projectile = new Projectile()
		with (projectile)
		{
			// Modifiable attributes
			damage = 10
			projectileSpeed = 3
			targetKnockback = 4.5
			effects = [ EFFECT.fanAreaDmg ]
			scale = 1
			xScaleMult = 4
	
			// Generic attributes
			sprite = sFanAir
			lifetime = 30
			projType = PROJECTILE_TYPE.melee
			objDealNoDamage = true
			
			// Scene attributes
			skipFirstFrameDraw = true
			
			// Behaviour
			update = fanProjUpdate
			draw = fanProjDraw
		}
		
		// Weapon actions
		primaryAction = meleeWeaponShoot
		secondaryAction = function() { show_debug_message("Secondary function is undefined!") }
	
		// Weapon functions
		update = fanUpdate
		draw = genericWeaponDraw
		destroy = fanDestroy
	}
		
	// -----------------------------------------------------------------------------

	with (weaponDatabase[WEAPON.paperPlane])
	{
		// Generic attributes
		type = WEAPON.paperPlane;
		sprite = sPaperPlane
		name = "Paper Plane"
		description = "Pew"
		shootAnim = WEAPON_ANIM_TYPE.swing
	
		// Modifiable attributes
		projectile = noone
		attackSpeed = 3			// shots/damage amount per second
		spread = 1				// weapon accuracy in degrees
		projectileAmount = 1	// number of projectile to be shot in the shoot frame
		magazineSize = 1
		reloadTime = 1
		durabilityMult = 3
		
		// Weapon projectile/hurtbox
		projectile = new Projectile()
		with (projectile)
		{
			// Modifiable attributes
			damage = 50
			projectileSpeed = 5
			targetKnockback = 5
			effects = [ ]
			scale = 1
			rotationOffset = -10;
			dirOffset = -5;
	
			// Generic attributes
			sprite = sPaperPlane
			//color = #FFD665
			projType = PROJECTILE_TYPE.ranged
			
			// Behaviour
			update = paperPlaneUpdate
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

	with (weaponDatabase[WEAPON.ticketMachine])
	{
		// Generic attributes
		type = WEAPON.ticketMachine;
		sprite = sTicketMachine
		name = "Ticket Machine"
		description = "PewPewPewPew"
	
		// Modifiable attributes
		projectile = noone
		attackSpeed = 7			// shots/damage amount per second
		spread = 20				// weapon accuracy in degrees
		projectileAmount = 1	// number of projectile to be shot in the shoot frame
		magazineSize = 30
		reloadTime = 3
		durabilityMult = .7
		
		// Weapon projectile/hurtbox
		projectile = new Projectile()
		with (projectile)
		{
			// Modifiable attributes
			damage = 15
			projectileSpeed = 3.5
			targetKnockback = 1
			effects = [ ]
			scale = 1
	
			// Generic attributes
			sprite = sTicketMahineBullet
			//color = #FFD665
			projType = PROJECTILE_TYPE.ranged
			
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
		type = WEAPON.fists;
		sprite = sFist
		name = "Fists"
		description = "Dont' talk about it..."
	
		// Modifiable attributes
		projectile = noone
		attackSpeed = 1			// shots/damage amount per second
		spread = 4				// weapon accuracy in degrees
		projectileAmount = 1	// number of projectile to be shot in the shoot frame
		durabilityMult = 0
		shootOnHold = false
		
		// Weapon projectile/hurtbox
		projectile = new Projectile()
		with (projectile)
		{
			// Modifiable attributes
			damage = 35
			projectileSpeed = 3
			targetKnockback = 5
			effects = []
			lifetime = 20
			scale = .7
	
			// Generic attributes
			sprite = sMeleeSlash
			projType = PROJECTILE_TYPE.melee
			
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
	
	with (weaponDatabase[WEAPON.groanTube])
	{
		// Generic attributes
		type = WEAPON.groanTube;
		sprite = sGroanTube
		name = "Groan Tube"
		description = "Groans"
		shootAnim = WEAPON_ANIM_TYPE.swing
	
		// Modifiable attributes
		projectile = noone
		attackSpeed = .8		// shots/damage amount per second
		spread = 60				// weapon accuracy in degrees
		projectileAmount = 1	// number of projectile to be shot in the shoot frame
		shootOnHold = false
		
		shootPitchMax = 1.2;
		shootPitchMin = 0.9;
		
		// Weapon projectile/hurtbox
		projectile = new Projectile()
		with (projectile)
		{
			// Modifiable attributes
			damage = 45
			projectileSpeed = 3
			targetKnockback = 10
			effects = []
			scale = 1.2
	
			// Generic attributes
			sprite = sMeleeSlash
			lifetime = 20
			projType = PROJECTILE_TYPE.melee
			
			// Behaviour
			update = genericMeleeHitUpdate
			draw = genericProjectileDraw
		}
	
		// Weapon actions
		primaryAction = groanTubeWeaponShoot
		secondaryAction = function() { show_debug_message("Secondary function is undefined!") }
	
		// Weapon functions
		update = genericWeaponUpdate
		draw = genericWeaponDraw
	}
	
	// -----------------------------------------------------------------------------
	
	with (weaponDatabase[WEAPON.crowbar])
	{
		// Generic attributes
		type = WEAPON.crowbar;
		sprite = sCrowBar
		name = "Crowbar"
		description = "HL3 tomorrow!!!"
		shootAnim = WEAPON_ANIM_TYPE.swing
	
		// Modifiable attributes
		projectile = noone
		attackSpeed = 1.8			// shots/damage amount per second
		spread = 10				// weapon accuracy in degrees
		projectileAmount = 1	// number of projectile to be shot in the shoot frame
		shootOnHold = false
		
		shootSound = [ sndCrowbarHit ]
		
		// Weapon projectile/hurtbox
		projectile = new Projectile()
		with (projectile)
		{
			// Modifiable attributes
			damage = 40
			projectileSpeed = 3
			targetKnockback = 10
			effects = []
			scale = 1.2
	
			// Generic attributes
			sprite = sMeleeSlash
			lifetime = 20
			projType = PROJECTILE_TYPE.melee
			
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
		type = WEAPON.ghosterGun;
		sprite = sGhosterGun
	
		// Modifiable attributes
		attackSpeed = 1			// shots/damage amount per second
		spread = 30				// weapon accuracy in degrees
		
		// Non-modifiable attributes
		magazineSize = 8
		reloadTime = 4
		
		// Update some scene attributes
		magazineAmmo = magazineSize	// Remaining bullets before reloading
	
		// Weapon projectile/hurtbox
		projectile = new Projectile()
		with (projectile)
		{
			// Modifiable attributes
			damage = 20
			projectileSpeed = 1
			targetKnockback = 2
			effects = []
	
			// Generic attributes
			sprite = sEnemyProjectile
			color = enemyProjectileCol
			projType = PROJECTILE_TYPE.ranged
			rotateInDirection = false;
			
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

	with (weaponDatabase[WEAPON.ghosterShotgun])
	{
		// Generic attributes
		type = WEAPON.ghosterGun;
		sprite = sGhosterShotgun
	
		// Modifiable attributes
		attackSpeed = .7		// shots/damage amount per second
		spread = 50				// weapon accuracy in degrees
		projectileAmount = 3
		
		// Non-modifiable attributes
		magazineSize = 3
		reloadTime = 2
		
		// Update some scene attributes
		magazineAmmo = magazineSize	// Remaining bullets before reloading
	
		// Weapon projectile/hurtbox
		projectile = new Projectile()
		with (projectile)
		{
			// Modifiable attributes
			damage = 20
			projectileSpeed = 1
			targetKnockback = 2
			effects = []
	
			// Generic attributes
			sprite = sEnemyProjectile
			color = enemyProjectileCol
			projType = PROJECTILE_TYPE.ranged
			rotateInDirection = false;
			
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

	with (weaponDatabase[WEAPON.enemyFan])
	{
		// Generic attributes
		type = WEAPON.fan;
		sprite = sFan
		name = "Fan"
		description = "Wheeeeeeeeee"
		shootSound = [sndFanClick]
	
		// Modifiable attributes
		projectile = noone
		attackSpeed = 2			// shots/damage amount per second
		spread = 5				// weapon accuracy in degrees
		projectileAmount = 1	// number of projectile to be shot in the shoot frame
		magazineSize = 120 * global.gameSpeed
		reloadTime = 2
		
		// Scene attributes
		holdingTriggerPrev = false
		loopingFanSound = -1
		
		// Weapon projectile/hurtbox
		projectile = new Projectile()
		with (projectile)
		{
			// Modifiable attributes
			damage = 5
			projectileSpeed = 3
			targetKnockback = 4.5
			effects = [ EFFECT.fanAreaDmg ]
			scale = 1
			xScaleMult = 4
	
			// Generic attributes
			sprite = sFanAir
			lifetime = 30
			projType = PROJECTILE_TYPE.melee
			objDealNoDamage = true
			
			// Scene attributes
			skipFirstFrameDraw = true
			
			// Behaviour
			update = fanProjUpdate
			draw = fanProjDraw
		}
		
		// Weapon actions
		primaryAction = meleeWeaponShoot
		secondaryAction = function() { show_debug_message("Secondary function is undefined!") }
	
		// Weapon functions
		update = fanUpdate
		draw = genericWeaponDraw
		destroy = fanDestroy
	}
	
	// -----------------------------------------------------------------------------

	with (weaponDatabase[WEAPON.enemyCrowbar])
	{
		// Generic attributes
		type = WEAPON.crowbar;
		sprite = sCrowBar
		name = "Crowbar"
		description = "HL3 tomorrow!!!"
		shootAnim = WEAPON_ANIM_TYPE.swing
	
		// Modifiable attributes
		projectile = noone
		attackSpeed = 1.8		// shots/damage amount per second
		spread = 10				// weapon accuracy in degrees
		projectileAmount = 1	// number of projectile to be shot in the shoot frame
		shootOnHold = false
		
		// Weapon projectile/hurtbox
		projectile = new Projectile()
		with (projectile)
		{
			// Modifiable attributes
			damage = 30
			projectileSpeed = 3
			targetKnockback = 10
			effects = []
			scale = 1.2
	
			// Generic attributes
			sprite = sMeleeSlash
			lifetime = 10
			projType = PROJECTILE_TYPE.melee
			
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
	
	with (weaponDatabase[WEAPON.rat])
	{
		// Generic attributes
		type = WEAPON.rat;
		sprite = sRat
		name = "Rat"
		description = "This weapon is sqeaky"
		durabilityMult = 1
		shootSound = [sndGarbageThrow]
	
		// Modifiable attributes
		projectile = noone
		attackSpeed = 1			// shots/damage amount per second
		spread = 8				// weapon accuracy in degrees
		projectileAmount = 1	// number of projectile to be shot in the shoot frame
		oneTimeUse = true
		
		// Non-modifiable attributes
		magazineSize = -1
		reloadTime = 0
		
		// Update some scene attributes
		magazineAmmo = magazineSize	// Remaining bullets before reloading
	
		// Weapon projectile/hurtbox
		projectile = new Projectile()
		with (projectile)
		{
			// Modifiable attributes
			damage = 0
			projectileSpeed = 3
			targetKnockback = 3
			effects = []
			rotateInDirection = false;
			
			projectileChild = new Projectile()
			with (projectileChild)
			{
				damage = 50
				projectileSpeed = 0
				targetKnockback = 20
				effects = []
				scale = 4
				lifetime = 1
				
				sprite = sExplosion
				projType = PROJECTILE_TYPE.explosion
				
				update = explosionUpdate
				draw = genericProjectileDraw
			}
	
			// Generic attributes
			sprite = sRat
			projType = PROJECTILE_TYPE.ranged
			
			// Behaviour
			update = garbageUpdate
			draw = genericProjectileRotatingDraw
			destroy = explosiveDestroy
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