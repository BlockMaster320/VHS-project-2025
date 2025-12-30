// AI --------------------------------------------------------

function dropperAiInit()
{
	genericAiInit()
	
	var projType = myWeapon.projectile.projectileType
	
	// Coordination
	coordinationInit()
			
	// Idle state
	idleAiInit()
			
	// Reposition
	repositionAiInit()
	
	if (projType == PROJECTILE_TYPE.melee)
	{
		optimalRange = new Range(20, 60)
		wantsToHideMult = 0
		repositionSuddenStopDelay = new Range(5, 15)
	}
	else if (projType == PROJECTILE_TYPE.ranged)
		optimalRange = new Range(80, 180)
			
	// Shoot
	shootAiInit()
	
	if (projType == PROJECTILE_TYPE.melee)
	{
		inactiveThreshold = new Range(40, 40)		
		shootingWalkSpd = 0
	}
			
	// Hide
	hideAiInit()
	
	// Rest
	restAiInit()
}

function dropperAiUpdate()
{	
	genericAiUpdate()
				
	// State machine -----------------------------------------
				
	// State changes
	if (!activeCoordination)
	{
		switch (state)
		{
			case AI_STATE.idle:
				idleAiTransition()
				break
						
			case AI_STATE.reposition:
				repositionAiTransition()
				break
						
			case AI_STATE.shoot:
				shootAiTransition()
				if (shootingDuration >= 2)
				{
					walkSpd = 0
					myWeapon.holdingTrigger = false
					state = AI_STATE.rest
				}
				break
						
			case AI_STATE.reload:
				reloadAiTransition()
				break
						
			case AI_STATE.hide:
				hideAiTransition()
				break
				
			case AI_STATE.rest:
				restAiTransition()
				break
		}
	}
				
	coordinationUpdate()
				
	// State behaviour
	switch (state)
	{
		case AI_STATE.idle:
			idleAiUpdate()
			break
						
		case AI_STATE.reposition:
			repositionAiUpdate()				
			break
						
		case AI_STATE.shoot:
			shootAiUpdate()
			break
						
		case AI_STATE.hide:
			hideAiUpdate()
			break
			
		case AI_STATE.rest:
			restAiUpdate()
			break
	}
}

function dropperAiDraw()
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
		//draw_text(x, yy + offset * 1, $"Danger: {wantsToHide}")
		draw_text(x, yy + offset * 1, $"Path end: {reachedPathEnd}")
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

// Drop weapon on death -------------------------------------

function dropperOnDeath()
{
	dropWeapon(myWeapon.index)
	
	instance_destroy()
}
