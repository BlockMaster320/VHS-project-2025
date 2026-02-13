// AI --------------------------------------------------------

function cleanerAiInit()
{
	genericAiInit()
	
	// Coordination
	coordinationInit()
	coordinationParticipant = false
			
	// Idle state
	idleAiInit()
			
	// Reposition
	repositionAiInit()
	optimalRange = new Range(40, 250)
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
	
	cloneCD = new Range(5*60, 12*60)
	cloneCD.value = 0
	cloneWindup = new Cooldown(2.3*60)	// The windup time is tied with the sound effect, do not change this without considering
	cloningWindupSound = audio_play_sound(sndCloningWindup, 0, false)
	audio_stop_sound(cloningWindupSound)
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
				//repositionAiTransition()
				if (reachedPathEnd)
				{
					if !(seesPlayerWell and playerDist > optimalRange.min_ and playerDist < optimalRange.max_)
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
				cleanerAiTryCloning()
				break
				
			case AI_STATE.clone:
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
	
	if (instance_number(oEnemy)-1 < 4 and cloneCD.value > 30)
	{
		cloneCD.value = 30
	}
				
				
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
			cleanerAiCloneUpdate()
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
	//draw_text(x, y - 20, $"Health: {hp}")
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
		cloneWindup.reset()
		cloningWindupSound = audio_play_sound(sndCloningWindup, 0, false)
		flashFrequency = 8
	}
}

function cleanerAiCloneUpdate()
{
	// Stop moving
	pathTargetX = x
	pathTargetY = y
	reachedPathEnd = true
	
	// Flash + pause
	if (cloneWindup.value > 0)
	{
		cloneWindup.value--
		return;
	}
	
	cloneCD.rndmize()
	flashFrequency = 0
	//audio_sound_gain(cloningWindupSound, 0, 1000)	
	
	var pitch = random_range(.8, 1.2)
	audio_play_sound(sndCloningAbility, 0, false, 1, 0, pitch)
	part_particles_create(oController.cloneExplosionSys, x, y, oController.cloneExplosion, 4)
	
	var cloneCount = random_range(0,2)
	if (instance_number(oEnemy)-1 < 1)
	{
		cloneCount = 4
		cloneCD.value *= .2
	}
	else if (instance_number(oEnemy)-1 < 6)
	{
		cloneCount = random_range(1,3)
		cloneCD.value *= .5
	}
	for (var i = 0; i < cloneCount; ++i) {
		var clone = instance_create_layer(x, y, "Instances", oEnemy)
		with(clone){ 
			characterCreate(CHARACTER_TYPE.cleanerClone)
		}
		ds_list_add(oBossFight.clones, clone)
	}
	
	
	// When there is too many clones, just kill some of them to keep cloning
	var maxCloneCount = 9
	while (instance_number(oEnemy)-1 > maxCloneCount)	// Let's just assume there aren't enemies other than the boss
	{
		var randomInstance = instance_find(oEnemy, irandom(instance_number(oEnemy)-1-1));
		if (randomInstance.characterType == CHARACTER_TYPE.cleanerClone)
		{
			part_type_direction(oController.bulletImpact, 0, 360, 0, 0)
			part_particles_create(oController.bulletImpactSys, randomInstance.x, randomInstance.y, oController.bulletImpact, 5)
			instance_destroy(randomInstance)
		}
	}
	
	state = prevState
}
