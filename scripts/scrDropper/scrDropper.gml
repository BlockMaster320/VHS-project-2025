// AI --------------------------------------------------------

function dropperAiInit()
{
	genericAiInit()
	
	var projType = myWeapon.projectile.projType
	
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
		inactiveThreshold = new Range(100, 100)	// Windup frames	
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
	if (global.AI_DEBUG)
	{
		genericAiDebugDraw()
				
		debugAiLineDraw()
	}
}

// Drop weapon on death -------------------------------------

function dropperOnDeath()
{
	dropWeapon(myWeapon.index)
	
	instance_destroy()
}
