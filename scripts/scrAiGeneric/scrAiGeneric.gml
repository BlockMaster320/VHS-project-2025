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
	activeCoordination = false
	hidingCoordination = false
}

function coordinationUpdate()
{
	if (callHideCooldown.value <= 0)
	{
		show_debug_message("Hide boys!")
		with (oEnemy)
		{
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
		show_debug_message("Show em!")
		with (oEnemy)
		{
			walkSpd = repositionWalkSpd
			reachedPathEnd = true
			wantsToHide = 0
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
	
	optimalRange = new Range(80, 180)
	
	wantsToHide = 0
	wantsToHideMult = 1
	
	// Become idle after not seeing the player for a while
	patience = 1
	patienceDec = 1/7
	
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
	if (patience <= 0 and !seesPlayer)
	{
		patience = 1
		walkSpd = idleWalkSpd
		state = AI_STATE.idle
	}
}

function repositionAiUpdate()
{
	// Run away if player is too close for too long
	if (playerDist < optimalRange.min_ - reachTargetMargin)
		wantsToHide += -.0002 * wantsToHide * (playerDist - optimalRange.min_) * global.gameSpeed
	else wantsToHide -= .01 * global.gameSpeed
						
	wantsToHide = max(wantsToHide, 0)
						
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
		else repositionSuddenStopDelay.value -= global.gameSpeed
	}
						
	// Reposition
	if (updateRate.value <= 0)
	{
		var dir1 = playerDir + 180 + 120
		var dir2 = playerDir + 180 - 120
							
		var foundPath = FindValidPathTargetReposition(optimalRange, true, new Range(dir1, dir2))
		if (!foundPath) patience -= patienceDec * global.gameSpeed
		else patience = 1
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
	inactiveThreshold = new Range(0, 30)
	
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
	
	if (myWeapon.projectile.projectileType == PROJECTILE_TYPE.melee)
		aimingAtPlayer = false
}

function shootAiTransition()
{	
	if (wantsToHide >= 1)
	{
		aimingAtPlayer = true
		walkSpd = panickedWalkSpd
		state = AI_STATE.reposition
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
		state = AI_STATE.reposition
		followingPath = false
		reachedPathEnd = true
	}
}

#endregion

#region Hide

function hideAiInit()
{
	panickedWalkSpd = 2
	giveUpHidingTimer = new Range(120, 400)
}

function hideAiTransition()
{
	if ((!seesPlayer and reachedPathEnd) or giveUpHidingTimer.value <= 0)
	{
		giveUpHidingTimer.rndmize()
		state = AI_STATE.reload
		myWeapon.reloading = true
		walkSpd = shootingWalkSpd
	}
	else giveUpHidingTimer.value -= global.gameSpeed
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
		
		state = AI_STATE.reposition
		updateRate.value = 0
		inactiveTime = 0
	}
}

function restAiUpdate()
{
	restTime.value -= global.gameSpeed
}

#endregion