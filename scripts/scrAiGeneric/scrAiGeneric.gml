enum AI_STATE
{
	idle, hide, reposition, shoot, reload
}

#region Generic

function genericAiInit()
{
	stateStrings = ["idle", "hide", "reposition", "shoot", "reload"]
	state = AI_STATE.idle
	
	lookAtPlayerTimer = new Range(40, 180)
	
	seesPlayer = LineOfSightPoint(oPlayer.x, oPlayer.y)
	seesPlayerWell = LineOfSightObject(oPlayer)
	playerDir = point_direction(x, y, oPlayer.x, oPlayer.y)
	playerDist = point_distance(x, y, oPlayer.x, oPlayer.y)
}

///@desc calculate look direction and positional relationship to player
function genericAiUpdate()
{
	// Look direction
	if (LineOfSightPoint(oPlayer.x, oPlayer.y))
	{
		lookDirTarget = point_direction(x, y, oPlayer.x, oPlayer.y)
		lookAtPlayerTimer.rndmize()
	}
	else if (lookAtPlayerTimer.value <= 0 and (whsp != 0 or wvsp != 0))
		lookDirTarget = point_direction(x, y, x + whsp, y + wvsp)
					
	if (lookAtPlayerTimer.value > 0) lookAtPlayerTimer.value--
	lookDir = lerpDirection(lookDir, lookDirTarget, .2)
	if (is_struct(myWeapon))
		myWeapon.aimDirection = lookDir
	
	// Relation to player
	seesPlayer = LineOfSightPoint(oPlayer.x, oPlayer.y)
	seesPlayerWell = LineOfSightObject(oPlayer)
	playerDir = point_direction(x, y, oPlayer.x, oPlayer.y)
	playerDist = point_distance(x, y, oPlayer.x, oPlayer.y)
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
	else if (!activeCoordination) callHideCooldown.value--
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
	if (callRepositionCooldown.value >= 0 and hidingCoordination) callRepositionCooldown.value--
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
	if (reachedPathEnd) moveCooldown.value--
}

#endregion

#region Reposition

function repositionAiInit()
{
	updateRate = new Range(50, 100)
	updateRate.value = 0
	optimalRange = new Range(80, 180)
	wantsToHide = 0
	patience = 1
	repositionWalkSpd = 1
	inactiveTime = 0
	inactiveThreshold = new Range(0, 30)
	repositionSuddenStopDelay = new Range(10, 50)
}

function repositionAiTransition()
{
	if (reachedPathEnd and inactiveTime > inactiveThreshold.value)
	{
		if (seesPlayerWell)
		{	
			walkSpd = shootingWalkSpd
			inactiveTime = 0
			inactiveThreshold.rndmize()
			state = AI_STATE.shoot
		}
		else
		{
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
		wantsToHide += -.0002 * (playerDist - optimalRange.min_)
	else wantsToHide -= .01
						
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
		}
		else repositionSuddenStopDelay.value--
	}
						
	// Reposition
	if (reachedPathEnd) inactiveTime++
	if (updateRate.value <= 0)
	{
		var dir1 = playerDir + 180 + 120
		var dir2 = playerDir + 180 - 120
							
		var foundPath = FindValidPathTargetReposition(optimalRange, true, new Range(dir1, dir2))
		inactiveTime = 0
		if (!foundPath) patience -= 1/7
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
	noTargetDuration = 0
}

function shootAiTransition()
{	
	if (wantsToHide >= 1)
	{
		walkSpd = panickedWalkSpd
		state = AI_STATE.reposition
		reachedPathEnd = true
		wantsToHide = 0
	}
	if (myWeapon.magazineAmmo <= 0)
	{
		walkSpd = panickedWalkSpd
		myWeapon.holdingTrigger = false
		state = AI_STATE.hide
	}
	else if (noTargetDuration > noTargetDurationMax.value)
	{
		walkSpd = repositionWalkSpd
		myWeapon.holdingTrigger = false
		state = AI_STATE.reposition
	}
}

function shootAiUpdate()
{
	// Run away if player is too close for too long
	if (playerDist < optimalRange.min_ - reachTargetMargin)
		wantsToHide += -.0002 * (playerDist - optimalRange.min_)
	else wantsToHide -= .01
						
	wantsToHide = max(wantsToHide, 0)
						
	myWeapon.holdingTrigger = true
						
	if (shootMoveCooldown.value <= 0 and reachedPathEnd and myWeapon.primaryActionCooldown > 10)	// Find new position
	{
		FindValidPathTarget(new Range(5, 30))
		shootMoveCooldown.rndmize()
	}
	else if (myWeapon.primaryActionCooldown < 10)
		followingPath = false
	if (reachedPathEnd) shootMoveCooldown.value--
						
	if (!seesPlayerWell) noTargetDuration++
	else noTargetDuration = 0
}

#endregion

#region Reload

function reloadAiTransition()
{
	if (myWeapon.magazineAmmo == myWeapon.magazineSize)
	{
		walkSpd = repositionWalkSpd
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
	else giveUpHidingTimer.value--
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