// AI --------------------------------------------------------

function ghosterAiInit()
{
	// AI states
	enum GHOSTER_STATE
	{
		idle, hide, reposition, shoot, reload
	}
	stateStrings = ["idle", "hide", "reposition", "shoot", "reload"]
	state = GHOSTER_STATE.idle
	
	lookAtPlayerTimer = new Range(40, 180)
	
	// Coordination
	activeCoordination = false
	hidingCoordination = false
			
	// Idle state
	moveCooldown = new Range(50, 300)
	idleWalkSpd = .5
			
	// Reposition
	updateRate = new Range(50, 100)
	updateRate.value = 0
	optimalRange = new Range(80, 180)
	wantsToHide = 0
	patience = 1
	repositionWalkSpd = 1
	inactiveTime = 0
	inactiveThreshold = new Range(0, 30)
	repositionSuddenStopDelay = new Range(10, 50)
			
	// Shoot
	shootingWalkSpd = .3
	shootMoveCooldown = new Range(0, 20)
	noTargetDuration = 0
	noTargetDurationMax = new Range(30, 180)
			
	// Hide
	panickedWalkSpd = 2
	giveUpHidingTimer = new Range(120, 400)
}

function ghosterAiUpdate()
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
	myWeapon.aimDirection = lookDir
				
	// State machine
				
	var seesPlayer = LineOfSightPoint(oPlayer.x, oPlayer.y)
	var seesPlayerWell = LineOfSightObject(oPlayer)
	var playerDir = point_direction(x, y, oPlayer.x, oPlayer.y)
	var playerDist = point_distance(x, y, oPlayer.x, oPlayer.y)
				
	// State changes
	if (!activeCoordination)
	{
		switch (state)
		{
			case GHOSTER_STATE.idle:
				if (seesPlayer)
				{
					state = GHOSTER_STATE.reposition
					walkSpd = repositionWalkSpd
				}
				break
						
			case GHOSTER_STATE.reposition:
				if (reachedPathEnd and inactiveTime > inactiveThreshold.value)
				{
					if (seesPlayerWell)
					{	
						walkSpd = shootingWalkSpd
						inactiveTime = 0
						inactiveThreshold.rndmize()
						state = GHOSTER_STATE.shoot
					}
					else
					{
						updateRate.value = 0
					}
				}
				if (wantsToHide >= 1)
				{
					walkSpd = panickedWalkSpd
					state = GHOSTER_STATE.hide
					reachedPathEnd = true
					wantsToHide = 0
				}
				if (patience <= 0 and !seesPlayer)
				{
					patience = 1
					walkSpd = idleWalkSpd
					state = GHOSTER_STATE.idle
				}
				break
						
			case GHOSTER_STATE.shoot:
				if (wantsToHide >= 1)
				{
					walkSpd = panickedWalkSpd
					state = GHOSTER_STATE.reposition
					reachedPathEnd = true
					wantsToHide = 0
				}
				if (myWeapon.magazineAmmo <= 0)
				{
					walkSpd = panickedWalkSpd
					myWeapon.holdingTrigger = false
					state = GHOSTER_STATE.hide
				}
				else if (noTargetDuration > noTargetDurationMax.value)
				{
					walkSpd = repositionWalkSpd
					myWeapon.holdingTrigger = false
					state = GHOSTER_STATE.reposition
				}
				break
						
						
			case GHOSTER_STATE.reload:
				if (myWeapon.magazineAmmo == myWeapon.magazineSize)
				{
					walkSpd = repositionWalkSpd
					state = GHOSTER_STATE.reposition
					followingPath = false
					reachedPathEnd = true
				}
				break
						
			case GHOSTER_STATE.hide:
				if ((!seesPlayer and reachedPathEnd) or giveUpHidingTimer.value <= 0)
				{
					giveUpHidingTimer.rndmize()
					state = GHOSTER_STATE.reload
					myWeapon.reloading = true
					walkSpd = shootingWalkSpd
				}
				else giveUpHidingTimer.value--
				break
		}
	}
				
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
			state = GHOSTER_STATE.hide
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
			state = GHOSTER_STATE.reposition
			activeCoordination = false
			hidingCoordination = false
		}
	}
	if (callRepositionCooldown.value >= 0 and hidingCoordination) callRepositionCooldown.value--
				
	// State behaviour
	switch (state)
	{
		case GHOSTER_STATE.idle:
			if (moveCooldown.value <= 0)	// Find new position
			{
				FindValidPathTarget(new Range(20, 120))
				moveCooldown.rndmize()
			}
			if (reachedPathEnd) moveCooldown.value--
			break
						
		case GHOSTER_STATE.reposition:
					
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
							
			break
						
		case GHOSTER_STATE.shoot:
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
						
			break
						
		case GHOSTER_STATE.hide:
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
						
			break
						
	}
}

function ghosterAiDraw()
{
	if (AI_DEBUG)
	{
		var offset = 8
		var yy = y + 8
		var halign = draw_get_halign()
				
		draw_set_halign(fa_center)
		draw_text(x, yy + offset * 0, $"{stateStrings[state]}")
		//draw_text(x, yy + offset * 1, $"Scared: {wantsToHide}")
		//draw_text(x, yy + offset * 2, $"PlayerDist: {point_distance(x, y, oPlayer.x, oPlayer.y)}")
		//draw_text(x, yy + offset * 3, $"Patience: {patience}")
		//draw_text(x, yy + offset * 1, $"Stop delay: {repositionSuddenStopDelay.value}")
		draw_text(x, yy + offset * 1, $"Danger: {wantsToHide}")
		//draw_text(x, yy + offset * 2, $"Sees player well: {LineOfSightObject(oPlayer)}")
		//draw_text(x, yy + offset * 5, $"Ammo: {myWeapon.magazineAmmo}")
		draw_set_halign(halign)
				
		var objDir = point_direction(x, y, oPlayer.x, oPlayer.y)
		var xx1 = x + lengthdir_x(30, objDir - 5)
		var yy1 = y + lengthdir_y(30, objDir - 5)
		var xx2 = x + lengthdir_x(30, objDir + 5)
		var yy2 = y + lengthdir_y(30, objDir + 5)
		//draw_line(x, y, xx1, yy1)
		//draw_line(x, y, xx2, yy2)
					
					
		var col = LineOfSightPoint(oPlayer.x, oPlayer.y) ? c_green : c_red
		draw_set_color(col)
		//draw_line(x, y, oPlayer.x, oPlayer.y)
		draw_set_color(c_white)
	}
}