function nothingFunction() {}

/// @param {enum/struct} weapon can be either an index from WEAPON enum or a specific Weapon struct
function acquireWeapon(weapon, owner, active_ = true, remDurability_=-1)
{
	var newWeapon;
	if (is_struct(weapon)) newWeapon = weapon
	else newWeapon = json_parse(global.weaponDatabaseJSON[weapon])
	
	// Init some weapon and projectile attributes
	with (newWeapon)
	{
		active = active_
		
		magazineAmmo = magazineSize
	}
	var proj = newWeapon.projectile
	
	while (proj != noone)
	{
		proj.ownerID = owner
		proj.srcWeapon = newWeapon
		
		if (proj.sprite == sPlayerProjectile and proj.ownerID.object_index != oPlayer)
		{
			proj.sprite = sEnemyProjectile
			proj.color = enemyProjectileCol
		}
		
		proj = proj.projectileChild
	}
	
	if (remDurability_ != -1) newWeapon.remainingDurability = remDurability_
	return newWeapon
}

// Spawns a weapon pickup at the position and depth of the calling instance
function dropWeapon(weaponID, remainingDurability_=1)
{
	var weaponPickup = instance_create_depth(x, y, depth, oWeaponPickup)
	with (weaponPickup) setupWeaponPickup(weaponID, remainingDurability_)
}

// Converts 0-360 degree spread to 1-0 accuracy 
function spreadToAccuracy(spread)
{
	var spreadClamped = clamp(abs(spread), 0, 360)
	return 1 - (spreadClamped / 360)
}
// Converts 0-1 accuracy to 360-0 degree spread
function accuracyToSpread(accuracy)
{
	var accuracyClamped = clamp(accuracy, 0, 1)
	return (1 - accuracyClamped) * 360
}

// Weapon actions ------------------------------------

///@return instance of spawned bullet
function spawnBullet()
{
	projectile.color = (projectile.ownerID.object_index == oPlayer) ? c_white : enemyProjectileCol;
	var bullet = instance_create_layer(xPos, yPos, "Instances", oProjectile, projectile)
	bullet.x = xPos
	bullet.y = yPos
	bullet.dir = aimDirection
	bullet.dir += random_range(-spread/2, spread/2)
	bullet.image_xscale = projectile.scale * projectile.xScaleMult
	bullet.image_yscale = projectile.scale * projectile.yScaleMult
	
	return bullet
}

function rangedWeaponShoot()
{
	repeat (projectileAmount)
	{
		var bullet = spawnBullet()
		bullet.sprite_index = projectile.sprite
	}
}

function meleeWeaponShoot()
{
	repeat (projectileAmount) // Just in case of a projectileAmount upgrade
	{
		var bullet = spawnBullet()
		//bullet.x = bullet.ownerID.x
		//bullet.y = bullet.ownerID.y
		bullet.image_angle = bullet.dir
		bullet.drawRot = bullet.dir
		bullet.sprite_index = sMeleeHitbox
	}
}

// Weapon update ------------------------------------

function weaponUpdatePosition()	// Called by every weapon
{
	var ownerIsPlayer = projectile.ownerID.object_index == oPlayer
	
	if (ownerIsPlayer)
		drawDirection = oController.aimDir
	else drawDirection = aimDirection
	
	flip = (abs(drawDirection % 360) > 90 && abs(drawDirection % 360) < 270) ? -1 : 1;
	if (flip < 0) drawDirection += 180;
	
	
	// Weapon shoot animation
	if (shootAnim == WEAPON_ANIM_TYPE.recoil) {
		if (shootAnimState == 1) {
			shootAnimRot = 30;
			shootAnimState = 2;
		}
		else if (shootAnimState == 2) {
			shootAnimRot = max(0, shootAnimRot - 3);
			if (shootAnimRot == 0) shootAnimState = 0;
		}
	}
	else if (shootAnim == WEAPON_ANIM_TYPE.swing) {
		
		if (shootAnimState == 1) {
			shootAnimRot -= 15;
			if (shootAnimRot <= -50) shootAnimState = 2;
		}
		else if (shootAnimState == 2) {
			shootAnimRot += 3;
			if (shootAnimRot >= 0) {
				shootAnimState = 0;
				shootAnimRot = 0;
			}
		}
	}
	drawDirection += shootAnimRot * flip;
	
	
	xPos = projectile.ownerID.x + (drawOffsetX * flip)
	yPos = projectile.ownerID.y + drawOffsetY
	
	if (ownerIsPlayer)
		aimDirection = point_direction(xPos, yPos, device_mouse_x(0), device_mouse_y(0))
	
}

function weaponPlayerUpdateLogic()
{
	// Get rid of weapon after running out of durability
	if (remainingDurability <= 0) {
		with (oPlayer)
		{
			if (other.oneTimeUse)
			{
				tempWeaponSlot.destroy()
				tempWeaponSlot = acquireWeapon(WEAPON.fists, id, false)
				weaponInventory[activeInventorySlot].active = true
			}
			else
			{
				audio_play_sound(sndWeaponBreak, 0, false)
				weaponInventory[other.playerInventorySlot].destroy()
				weaponInventory[other.playerInventorySlot] = acquireWeapon(WEAPON.fists, id);
			}
			
			ignoreInputBuffer.reset()
			EvaluateWeaponBuffs()
		}
	}
	
	// Detect weapon shooting input
	if (oController.primaryButtonPress or (shootOnHold and oController.primaryButton))
		if (oPlayer.ignoreInputBuffer.value <= 0)
			holdingTrigger = true
			
	if (oPlayer.ignoreInputBuffer.value > 0)
		oPlayer.ignoreInputBuffer.value--
		
	// Reloading
	if ( !reloading and	active and
	   ( (oController.reload and magazineAmmo != magazineSize) or magazineAmmo == 0))
	{
		reloading = true
		holdingTrigger = false
		magazineAmmo = 0
		
		var _reloadSound = reloadSound[irandom(array_length(reloadSound) - 1)]
		var reloadSoundInstance = audio_play_sound(_reloadSound, 0, false, 1)
		audio_sound_gain(reloadSoundInstance, 0, reloadTime * 1000 + 200)
	}
}

function weaponReloading()
{
	if (magazineAmmo == 0 and !reloading)	// For enemies running to hide before reloading
	{
		flashFrequency = 1
		roundFac = false
	}
	else if (reloading and magazineAmmo != magazineSize)
	{
		if (reloadProgress > reloadTime * 60) // Reload finished
		{
			reloadProgress = 0
			reloading = false
			magazineAmmo = magazineSize
			flashFrameCounter = 0
			
			if (index == WEAPON.fan or index == WEAPON.enemyFan)
				audio_stop_sound(loopingFanSound)
		}
		reloadProgress += global.gameSpeed
		flashFrequency = 3
		roundFac = true
	}
	else reloadProgress = 0
}

function weaponPostDraw()
{
	flashFrameCounter++
	flashFrequency = 0
}

// Generic shooting function - should probably be used by all weapons
function genericWeaponShoot()
{
	primaryAction()
	var gain = 1
	var pitch = random_range(shootPitchMin, shootPitchMax)
	if (projectile.ownerID != oPlayer) gain = .3
	var _shootSound = shootSound[irandom(array_length(shootSound) - 1)]
	audio_play_sound(_shootSound, 0, false, 1 ,0 , pitch)
	shootAnimState = 1;
}

// Calculate durability, reduce ammo from magazine
function evaluateWeaponShoot()
{
	genericWeaponShoot()
	
	var effectiveAttackSpeed = clamp(attackSpeed, .7, 5)	// To punish high attack speed with more durability damage
	if (oneTimeUse) remainingDurability = 0
	else remainingDurability -= durabilityMult / (effectiveAttackSpeed * durabilityInSeconds)
	if (magazineAmmo > 0) magazineAmmo = max(magazineAmmo - 1, 0)
}

function genericWeaponUpdate()
{	
	weaponUpdatePosition() // All weapons should call this
	
	primaryActionCooldown = max(primaryActionCooldown - global.gameSpeed, -1)
	
	var ownerIsPlayer = projectile.ownerID.object_index == oPlayer
	
	if (ownerIsPlayer)
		weaponPlayerUpdateLogic()
		
	weaponReloading()
	
	// Shooting
	if (active and holdingTrigger and primaryActionCooldown <= 0 and (magazineAmmo > 0 or magazineAmmo == -1))
	{
		while (primaryActionCooldown <= 0)	// "while" instead of "if" for very high attack speeds
		{
			if (oPlayer.dualWield and random(1) < .8) break	// Spread out different weapons
			primaryActionCooldown += 60 / attackSpeed
			evaluateWeaponShoot()
			
			if (ownerIsPlayer)	// Screenshake
			{
				var shakeMult = 8
				if (!shootOnHold)
					shakeMult *= 1.8
				oCamera.currentShakeAmount += (1 / (attackSpeed + 1)) * shakeMult
			}
			
			if (magazineAmmo <= 0) break
		}
	}
	
	holdingTrigger = false
}

// Fan

function fanDestroy()
{
	audio_stop_sound(loopingFanSound)
}

function fanUpdate()
{
	weaponUpdatePosition() // All weapons should call this
	
	var ownerIsPlayer = projectile.ownerID.object_index == oPlayer
	
	if (ownerIsPlayer)
		weaponPlayerUpdateLogic()
		
	weaponReloading()
	
	//var soundGain = 1
	//if (projectile.ownerID != oPlayer) soundGain = .4
	
	if (active and holdingTrigger and (magazineAmmo > 0 or magazineAmmo == -1))
	{
		primaryAction()
		if (holdingTriggerPrev == false or !audio_is_playing(loopingFanSound))
		{
			shootSoundInstance = audio_play_sound(shootSound[0], 0, false)
			
			if (audio_is_playing(loopingFanSound)) audio_stop_sound(loopingFanSound)
			loopingFanSound = audio_play_sound(sndFanBlast, 0, true, 0)
			audio_sound_gain(loopingFanSound, 1, 700)
			//audio_stop_sound(loopingFanSound)
		}
	
		remainingDurability -= durabilityMult / (oController.gameFPS * durabilityInSeconds)
		if (magazineAmmo > 0) magazineAmmo = max(magazineAmmo - global.gameSpeed, 0)
		
		frame = min(frame + animationSpeed, sprite_get_number(projectile.sprite) - 1);
		if (frame == sprite_get_number(projectile.sprite) - 1) frame = 0;
		projectile.frame = frame;
		
	}
	else if (audio_exists(loopingFanSound))
	{
		if (audio_sound_get_gain(loopingFanSound) == 1)
			audio_sound_gain(loopingFanSound, 0, 500)
		
		if (audio_exists(shootSoundInstance) and audio_is_playing(shootSoundInstance))
			audio_sound_gain(shootSoundInstance, 0, 100)
		
		if (audio_is_playing(loopingFanSound))
		{
			var pitch = audio_sound_get_pitch(loopingFanSound)-.05
			pitch = max(pitch, .005)
			audio_sound_pitch(loopingFanSound, pitch)
		}
		
		if (audio_sound_get_gain(loopingFanSound) == 0)
			audio_stop_sound(loopingFanSound)
	}
	
	
	holdingTriggerPrev = holdingTrigger
	holdingTrigger = false
}


// Weapon draw ----------------------------------------

function genericWeaponDraw(_alpha = 1, posOff=0)
{
	var xx = xPos + lengthdir_x(posOff, drawDirection-30)
	var yy = yPos + lengthdir_y(posOff, drawDirection-30)
	
	shader_set(shFlash)
		flashFac = ((flashFrameCounter/global.gameSpeed) mod (60 / flashFrequency)) / (60 / flashFrequency)
		if (roundFac) flashFac = round(flashFac)
		else flashFac = sin(flashFac * 2 * pi) * .5 + .5
		if (flashFrequency <= .0001) flashFac = 0
		shader_set_uniform_f(flashFacLoc, flashFac)
		draw_sprite_ext(sprite, 0, roundPixelPos(xx), roundPixelPos(yy), flip, 1, drawDirection + drawAngle * flip, c_white, _alpha)	
	shader_reset()
	
	if (index != WEAPON.fists)	// draw a hand holding the gun
		draw_sprite_ext(sHands, 7, roundPixelPos(xPos) - 2 * flip, roundPixelPos(yPos) - 4, flip, 1, 0, c_white, _alpha)
		
	weaponPostDraw()
}

//function drawReloadState(weapon)
//{
//	if (weapon != -1)
//	{
//		drawReloadState(weapon, x, y, .5)
//	}
//}

function drawReloadState(weapon, xx=x, yy=y, magazineStateAlpha=0)
{
	if (weapon == -1) return
	
	var w = .1
	var yOff = 13

	var left = xx - 10
	var right = xx + 10
	var top = yy + yOff
	var bott = yy + yOff + w

	var reloadFac = 0
	
	if ((weapon.magazineSize != -1) and weapon.reloading) or
		(weapon.magazineSize == -1 and weapon.primaryActionCooldown > 0)
	{
		reloadFac = weapon.primaryActionCooldown / (60 / weapon.attackSpeed)
		if (weapon.magazineSize != -1)
			reloadFac = 1 - (weapon.reloadProgress / (weapon.reloadTime * 60))
	}
	else if (magazineStateAlpha != 0 and weapon.magazineSize != -1)
	{
		reloadFac = weapon.magazineAmmo / weapon.magazineSize
		reloadFac = 1 - reloadFac
		
		draw_set_alpha(magazineStateAlpha)
	}
	else return;
	
	// Horizontal bar
	draw_rectangle(left, top, right, bott, false)
	
	// Vertical progress bar
	var h = 4
	var sliderX = lerp(right, left, reloadFac)
	draw_rectangle(sliderX - w/2, top - h/2, sliderX + w/2, bott + h/2, false)
	
	draw_set_alpha(1)
}

// Groan tube
function groanTubeWeaponShoot()
{
	var gain = 1
	var pitch = random_range(shootPitchMin, shootPitchMax)
	if (projectile.ownerID != oPlayer) gain = .3
	var _shootSound = shootSound[irandom(array_length(shootSound) - 1)]
	audio_play_sound(_shootSound, 0, false, 1 ,0 , pitch)
	var _groanSound = choose(sndGroanTube1, sndGroanTube2);
	audio_play_sound(_groanSound, 0, false, 1 ,0 , 1.)
	shootAnimState = 1;
	
	meleeWeaponShoot()
}