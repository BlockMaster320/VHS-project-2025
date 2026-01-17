enum AI_STATE
{
	idle, hide, reposition, shoot, reload, rest
}

#region Generic

function genericAiInit()
{
	stateStrings = ["idle", "hide", "reposition", "shoot", "reload", "rest"]
	state = AI_STATE.idle
	
	lookAtPlayerTimer = new Range(40, 180)
	
	aimingAtPlayer = true	// Wether the AI is trying to aim at the player
	
	seesPlayer = LineOfSightPoint(oPlayer.x, oPlayer.y)
	seesPlayerWell = LineOfSightObject(oPlayer)
	playerDir = point_direction(x, y, oPlayer.x, oPlayer.y)
	playerDist = point_distance(x, y, oPlayer.x, oPlayer.y)
	walkDir = point_direction(x, y, x + whsp, y + wvsp)
}

///@desc calculate look direction and positional relationship to player
function genericAiUpdate()
{
	// Relation to player
	seesPlayer = LineOfSightPoint(oPlayer.x, oPlayer.y)
	seesPlayerWell = LineOfSightObject(oPlayer)
	playerDir = point_direction(x, y, oPlayer.x, oPlayer.y)
	playerDist = point_distance(x, y, oPlayer.x, oPlayer.y)
	walkDir = point_direction(x, y, x + whsp, y + wvsp)

	// Look direction
	if (seesPlayer and aimingAtPlayer)
	{
		lookDirTarget = playerDir
		lookAtPlayerTimer.rndmize()
	}
	else if (lookAtPlayerTimer.value <= 0 and (whsp != 0 or wvsp != 0))
		lookDirTarget = walkDir
		
	var lookLerpFac = .15
					
	if (lookAtPlayerTimer.value > 0) lookAtPlayerTimer.value -= global.gameSpeed
	lookDir = lerpDirection(lookDir, lookDirTarget, lookLerpFac)
	if (is_struct(myWeapon))
		myWeapon.aimDirection = lookDir
}

#endregion

#region Coordination

function coordinationInit()
{
	coordinationParticipant = true
	activeCoordination = false
	hidingCoordination = false
}

function coordinationUpdate()
{
	if (callHideCooldown.value <= 0)
	{
		show_debug_message("Hide coordination!")
		with (oEnemy)
		{
			if (!coordinationParticipant) continue
			callRepositionCooldown.rndmize()
			callHideCooldown.rndmize()
			walkSpd = panickedWalkSpd
			reachedPathEnd = true
			wantsToHide = 0
			state = AI_STATE.hide
			activeCoordination = true
			hidingCoordination = true
		}
	}
	else if (!activeCoordination) callHideCooldown.value -= global.gameSpeed
	if (callRepositionCooldown.value <= 0 and hidingCoordination)
	{
		show_debug_message("Reposition coordination!")
		with (oEnemy)
		{
			if (!coordinationParticipant) continue
			walkSpd = repositionWalkSpd
			reachedPathEnd = true
			wantsToHide = 0
			aimingAtPlayer = true
			patienceToShoot.reset()
			state = AI_STATE.reposition
			activeCoordination = false
			hidingCoordination = false
		}
	}
	if (callRepositionCooldown.value >= 0 and hidingCoordination) callRepositionCooldown.value -= global.gameSpeed
}

#endregion

// States ----------------------------------------------------------------

#region Idle

function idleAiInit()
{
	moveCooldown = new Range(50, 300)
	idleWalkSpd = .5
}

function idleAiTransition()
{
	if (seesPlayer)
	{
		aimingAtPlayer = true
		state = AI_STATE.reposition
		walkSpd = repositionWalkSpd
	}
}

function idleAiUpdate()
{
	if (moveCooldown.value <= 0)	// Find new position
	{
		FindValidPathTarget(new Range(20, 120))
		moveCooldown.rndmize()
	}
	if (reachedPathEnd) moveCooldown.value -= global.gameSpeed
}

#endregion

#region Reposition

function repositionAiInit()
{
	repositionWalkSpd = 1
	
	optimalRange = new Range(80, 140)
	
	wantsToHide = 0
	wantsToHideMult = 1
	
	// Become idle after not seeing the player for a while
	patienceToIdle = 1
	patienceToIdleDec = 1/7
	
	// If I can't reach the optimal range and I see the player, just start shooting now
	patienceToShoot = new Cooldown(120)
	
	// Accidentaly arrived at a good position, wait few frames
	//	before swapping state to avoid getting stuck near wall edges
	repositionSuddenStopDelay = new Range(10, 50)
	
	updateRate = new Range(50, 80)
	updateRate.value = 0
}

function repositionAiTransition()
{
	if (reachedPathEnd)
	{
		if (seesPlayerWell and playerDist > optimalRange.min_ and playerDist < optimalRange.max_)
		{	
			walkSpd = shootingWalkSpd
			shootAiSetupState()
			state = AI_STATE.shoot
		}
		else
		{
			reachedPathEnd = false
			updateRate.value = 0
		}
	}
	if (wantsToHide >= 1)
	{
		walkSpd = panickedWalkSpd
		state = AI_STATE.hide
		reachedPathEnd = true
		wantsToHide = 0
	}
	if (patienceToIdle <= 0 and !seesPlayer)
	{
		patienceToIdle = 1
		walkSpd = idleWalkSpd
		state = AI_STATE.idle
	}
	
	if (patienceToShoot.value <= 0)
	{
		walkSpd = shootingWalkSpd
		shootAiSetupState()
		state = AI_STATE.shoot
	}
}

function repositionAiUpdate()
{
	// Run away if player is too close for too long
	//if (playerDist < optimalRange.min_ - reachTargetMargin)
	//	wantsToHide += -.0002 * wantsToHide * (playerDist - optimalRange.min_) * global.gameSpeed
	//else wantsToHide -= .01 * global.gameSpeed
						
	wantsToHide = max(wantsToHide, 0)
	
	if (seesPlayerWell and myWeapon.projectile.projType == PROJECTILE_TYPE.ranged) patienceToShoot.value -= global.gameSpeed
	else patienceToShoot.reset()
						
	// Determine when to reposition
	if (reachedPathEnd)
	{
		if (playerDist < optimalRange.min_) updateRate.value *= .5
		if (!seesPlayerWell) updateRate.value *= .5
		if (playerDist > optimalRange.max_) updateRate.value *= .8
	}
						
	if (//angle_difference(playerDir, point_direction(x, y, targetPointX, targetPointY)) < 75 and	
		playerDist > optimalRange.min_ and playerDist < optimalRange.max_ and seesPlayerWell)
	{
		if (repositionSuddenStopDelay.value <= 0)
		{
			pathTargetX = x
			pathTargetY = y
			followingPath = false
			repositionSuddenStopDelay.rndmize()
			reachedPathEnd = true
		}
		else
		{
			repositionSuddenStopDelay.value -= global.gameSpeed
		}
	}
						
	// Reposition
	if (updateRate.value <= 0)
	{
		var dir1 = playerDir + 180 + 120
		var dir2 = playerDir + 180 - 120
							
		var foundPath = FindValidPathTargetReposition(optimalRange, true, new Range(dir1, dir2))
		if (!foundPath) patienceToIdle -= patienceToIdleDec * global.gameSpeed
		else patienceToIdle = 1
		updateRate.rndmize()
	}
}

#endregion

#region Shoot

function shootAiInit()
{
	shootingWalkSpd = .3
	shootMoveCooldown = new Range(0, 20)
	noTargetDurationMax = new Range(30, 180)
	
	inactiveTime = 0
	inactiveThreshold = new Range(30, 30)	// Wait a bit before shooting
	
	noTargetDuration = 0
	shootingDuration = 0
}

function shootAiSetupState()
{
	inactiveThreshold.rndmize()
	inactiveTime = 0
	shootingDuration = 0
	
	noTargetDurationMax.rndmize()
	noTargetDuration = 0
	
	lookDir = lookDirTarget
	myWeapon.aimDirection = lookDir
	
	if (myWeapon.projectile.projType == PROJECTILE_TYPE.melee)
		aimingAtPlayer = false
}

function shootAiTransition()
{	
	if (wantsToHide >= 1)
	{
		aimingAtPlayer = true
		walkSpd = panickedWalkSpd
		state = AI_STATE.reposition
		patienceToShoot.reset()
		reachedPathEnd = true
		wantsToHide = 0
	}
	if (myWeapon.magazineAmmo <= 0 and myWeapon.magazineSize != -1)
	{
		aimingAtPlayer = true
		walkSpd = panickedWalkSpd
		myWeapon.holdingTrigger = false
		state = AI_STATE.hide
	}
	else if (noTargetDuration > noTargetDurationMax.value)
	{
		aimingAtPlayer = true
		walkSpd = repositionWalkSpd
		myWeapon.holdingTrigger = false
		patienceToShoot.reset()
		state = AI_STATE.reposition
	}
}

function shootAiUpdate()
{	
	// Run away if player is too close for too long
	if (playerDist < optimalRange.min_ - reachTargetMargin)
		wantsToHide += -.0002 * wantsToHideMult * (playerDist - optimalRange.min_) * global.gameSpeed
	else wantsToHide -= .01 * global.gameSpeed
						
	wantsToHide = max(wantsToHide, 0)
	
	if (inactiveTime < inactiveThreshold.value)
	{
		inactiveTime += global.gameSpeed
		//if (myWeapon.projectile.projType == PROJECTILE_TYPE.melee)
		//{
		myWeapon.flashFrequency = 10	// "I will shoot!" telegraphing
		myWeapon.roundFac = true
		//}
		return
	}
						
	myWeapon.holdingTrigger = true
	shootingDuration += global.gameSpeed
						
	if (shootMoveCooldown.value <= 0 and reachedPathEnd and myWeapon.primaryActionCooldown > 10)	// Find new position
	{
		FindValidPathTarget(new Range(5, 30))
		shootMoveCooldown.rndmize()
	}
	else if (myWeapon.primaryActionCooldown < 10)
		followingPath = false
	if (reachedPathEnd) shootMoveCooldown.value -= global.gameSpeed
						
	if (!seesPlayerWell) noTargetDuration += global.gameSpeed
	else noTargetDuration = 0
}

#endregion

#region Reload

function reloadAiTransition()
{
	if (myWeapon.magazineAmmo == myWeapon.magazineSize)
	{
		walkSpd = repositionWalkSpd
		myWeapon.reloading = false
		aimingAtPlayer = true
		patienceToShoot.reset()
		state = AI_STATE.reposition
		followingPath = false
		reachedPathEnd = true
	}
}

#endregion

#region Hide

function hideAiInit()
{
	panickedWalkSpd = 1.3
	giveUpHidingTimer = new Range(120, 180)
	isSafe = new Range(20, 30)	// I don't see the player, I might be already safe
}

function hideAiTransition()
{
	if ((!seesPlayer and reachedPathEnd) or giveUpHidingTimer.value <= 0 or isSafe.value <= 0)
	{
		giveUpHidingTimer.rndmize()
		isSafe.rndmize()
		state = AI_STATE.reload
		myWeapon.reloading = true
		walkSpd = shootingWalkSpd
		
		if (myWeapon.magazineSize != -1)
		{
			var gain = .3
			var reloadSound = audio_play_sound(sndReload, 0, false, gain)
			audio_sound_gain(reloadSound, 0, myWeapon.reloadTime * 1000 + 200)
		}
	}
	else giveUpHidingTimer.value -= global.gameSpeed
	
	if (!seesPlayer) isSafe.value -= global.gameSpeed
	else isSafe.rndmize()
}

function hideAiUpdate()
{
	if (seesPlayer and reachedPathEnd)
	{
		var dir1 = playerDir + 180 + 90
		var dir2 = playerDir + 180 - 90
							
		var foundPath = FindValidPathTargetReposition(new Range(playerDist, 999), false, new Range(dir1, dir2))
		if (!foundPath)
		{
			FindValidPathTarget(new Range(playerDist, playerDist + 100), new Range(dir1, dir2))
		}
	}
}

#endregion

#region Rest

function restAiInit()
{
	restTime = new Cooldown(120)
}

function restAiTransition()
{
	if (restTime.value <= 0)
	{
		restTime.reset()
		walkSpd = repositionWalkSpd
		myWeapon.holdingTrigger = false
		aimingAtPlayer = true
		patienceToShoot.reset()
		
		state = AI_STATE.reposition
		updateRate.value = 0
		inactiveTime = 0
	}
}

function restAiUpdate()
{
	restTime.value -= global.gameSpeed
	
	if (myWeapon.projectile.projType == PROJECTILE_TYPE.melee and
		myWeapon.shootOnHold)
		myWeapon.holdingTrigger = true
}

#endregion

// Draw util -----------------------------------
function genericAiDebugDraw()
{
	var offset = 4
	var yy = y + 8
	var halign = draw_get_halign()
	var scale = .5
				
	draw_set_halign(fa_center)
	draw_text_transformed(x, yy + offset * 0, $"{stateStrings[state]}", scale, scale, 0)
	//draw_text(x, yy + offset * 1, $"Scared: {wantsToHide}")
	//draw_text(x, yy + offset * 2, $"PlayerDist: {point_distance(x, y, oPlayer.x, oPlayer.y)}")
	//draw_text(x, yy + offset * 1, $"Danger: {wantsToHide}")
	//draw_text_transformed(x, yy + offset * 1, $"Path end: {reachedPathEnd}", scale, scale, 0)
	draw_text_transformed(x, yy + offset * 1, $"Patience: {patienceToShoot.value}", scale, scale, 0)
	//draw_text(x, yy + offset * 2, $"Sees player well: {LineOfSightObject(oPlayer)}")
	//draw_text(x, yy + offset * 5, $"Ammo: {myWeapon.magazineAmmo}")
	draw_set_halign(halign)
}

function debugAiLineDraw()
{
	var objDir = point_direction(x, y, oPlayer.x, oPlayer.y)
	var xx1 = x + lengthdir_x(30, objDir - 5)
	var yy1 = y + lengthdir_y(30, objDir - 5)
	var xx2 = x + lengthdir_x(30, objDir + 5)
	var yy2 = y + lengthdir_y(30, objDir + 5)
	draw_line(x, y, xx1, yy1)
	draw_line(x, y, xx2, yy2)
					
	draw_set_color(c_blue)
	draw_line(x, y, x+lengthdir_x(50, lookDir), y+lengthdir_y(50, lookDir))
		
	var col = LineOfSightPoint(oPlayer.x, oPlayer.y) ? c_green : c_red
	draw_set_color(col)
	draw_line(x, y, oPlayer.x, oPlayer.y)
	draw_set_color(c_white)
}