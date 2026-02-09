// AI --------------------------------------------------------

function cleanerAiInit()
{
	genericAiInit()
	
	// Coordination
	coordinationInit()
			
	// Idle state
	idleAiInit()
			
	// Reposition
	repositionAiInit()
	optimalRange = new Range(20, 60)
	wantsToHideMult = 0
	repositionSuddenStopDelay = new Range(5, 15)
			
	// Shoot
	shootAiInit()
	inactiveThreshold = new Range(60, 60)	// Weapon windup	
	shootingWalkSpd = 0
			
	// Hide
	hideAiInit()
	
	// Rest
	restAiInit()
	
	cloneCD = new Cooldown(5*60)
	prevState = noone
}

function cleanerAiUpdate()
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
				cleanerAiTryCloning()
				break
				
			case AI_STATE.clone:
				cloneCD.reset()
				state = prevState
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
				cleanerAiTryCloning()
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
			
		case AI_STATE.clone:
				var clone = instance_create_layer(x, y, "Instances", oEnemy)
				with(clone){ 
					characterCreate(CHARACTER_TYPE.cleanerClone)
					maxHp = other.hp / 3
					hp = maxHp
				}
			}
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
	if (state != AI_STATE.idle && cloneCD.value > 0){
		cloneCD.value -= 1
	}
}

function cleanerAiDraw()
{
	draw_text(x, y - 20, $"Health: {hp}")
	if (global.AI_DEBUG)
	{
		genericAiDebugDraw()
				
		debugAiLineDraw()
	}
}


// cleaner ai ---------------------------------------------------------------------- 

function cleanerAiTryCloning()
{
	if (cloneCD.value <= 0){
		prevState = state
		state = AI_STATE.clone
	}
}

function cleanerAiCloneUpdate()
