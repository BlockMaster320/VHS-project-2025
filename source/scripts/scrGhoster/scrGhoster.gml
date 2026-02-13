// AI --------------------------------------------------------

function ghosterAiInit()
{
	genericAiInit()
	
	// Coordination
	coordinationInit()
			
	// Idle state
	idleAiInit()
			
	// Reposition
	repositionAiInit()
			
	// Shoot
	shootAiInit()
			
	// Hide
	hideAiInit()
}

function ghosterAiUpdate()
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
				break
						
						
			case AI_STATE.reload:
				reloadAiTransition()
				break
						
			case AI_STATE.hide:
				hideAiTransition()
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
						
	}
}

function ghosterAiDraw()
{
	if (global.AI_DEBUG)
	{
		genericAiDebugDraw()
				
		debugAiLineDraw()
	}
}