// Returns step event of the specified character.
function getCharacterStepEvent(_characterType){
	switch (_characterType) {
		
		case CHARACTER_TYPE.player: {
			return function() {
				switch (characterState) {
					case CharacterState.Harm:
						if (harmed_duration <= 0) characterState = CharacterState.Idle
				
				    case CharacterState.Idle:
				        // idle logic
				        if (oController.down || oController.up || oController.right || oController.left) {
							characterState = CharacterState.Run;
						}
				        break;

				    case CharacterState.Run:
				        if !(oController.down || oController.up || oController.right || oController.left) {
							characterState = CharacterState.Idle
						}
				        break;
				}
			};
		}
		
		case CHARACTER_TYPE.mechanic: {
			return function() {
				//show_debug_message("mechanic step");
			};
		}
		
		default: { return function() {}; }
	}
}

// Returns draw event of the specified character.
function getCharacterDrawEvent(_characterType) {
	switch (_characterType) {
		case CHARACTER_TYPE.player: {
			return function() {
				//show_debug_message("player draw");
				dir = (oController.aimDir > 90 and oController.aimDir < 270) ? -1 : 1
				
				// Draw player's hands
				var _weapon = weaponInventory[activeInventorySlot];
				if (_weapon.index = WEAPON.fists) {	// draw bare hands
					var animationFrames = animHands(characterState);
					var start = animationFrames.range[0];
					var ended = animationFrames.range[1];

					spriteFrameHands += imageSpeedHands;

					if (spriteFrameHands >= ended + 1) spriteFrameHands = start; // loop back
					if (spriteFrameHands < start) spriteFrameHands = start;

					imageSpeedHands = animationFrames.speeds[floor(spriteFrameHands) - start];
				
					draw_sprite_ext(sHands, spriteFrameHands, roundPixelPos(x), roundPixelPos(y), dir, 1, 0, c_white, 1)
				}
			};
		}
		
		case CHARACTER_TYPE.mechanic: {
			return function() {
				//show_debug_message("mechanic draw");
			};
		}
		
		default: { return function() {}; }
	}
}


function characterCreate(_characterType) {
	switch(_characterType) {
		
		// Player -----------------------------------------------------------
		
		case CHARACTER_TYPE.player: {		
			characterClass = CHARACTER_CLASS.player;
			characterType = CHARACTER_TYPE.player;
			characterType = CHARACTER_TYPE.player;
			name = "Player";
			portrait = sNPCPortrait;
			
			sprite_index = sPlayer;
			characterAnimation = new CharacterAnimation(GetAnimationFramesPlayer);
			anim = characterAnimation.getAnimation;
			handsAnimation = new CharacterAnimation(GetAnimationFramesHands);
			animHands = handsAnimation.getAnimation;
			spriteFrameHands = 0;
			imageSpeedHands = 0;
			
			stepEvent = getCharacterStepEvent(CHARACTER_TYPE.player);
			drawEvent = getCharacterDrawEvent(CHARACTER_TYPE.player);
			
		} break;
		
		// NPCs -----------------------------------------------------------
		
		case CHARACTER_TYPE.mechanic: {
			characterClass = CHARACTER_CLASS.NPC;
			characterType = CHARACTER_TYPE.mechanic;
			name = "Mechanic";
			portrait = sNPCPortrait;
			
			sprite_index = sMechanic;
			characterAnimation = new CharacterAnimation(GetAnimationFramesDefault);
			anim = characterAnimation.getAnimation;
			
			stepEvent = getCharacterStepEvent(CHARACTER_TYPE.mechanic);
			drawEvent = getCharacterDrawEvent(CHARACTER_TYPE.mechanic);
		} break;
		
		case CHARACTER_TYPE.passenger1: {
			characterClass = CHARACTER_CLASS.NPC;
			characterType = CHARACTER_TYPE.passenger1;
			name = "Passanger";
			portrait = sNPCPortrait;
			
			sprite_index = sPassanger1;
			characterAnimation = new CharacterAnimation(GetAnimationFramesDefault);
			anim = characterAnimation.getAnimation;
			
			stepEvent = getCharacterStepEvent(CHARACTER_TYPE.passenger1);
			drawEvent = getCharacterDrawEvent(CHARACTER_TYPE.passenger1);
		} break;
		
		// Enemies ---------------------------------------------------------------
		
		case CHARACTER_TYPE.ghoster: {
			// Character attributes
			characterClass = CHARACTER_CLASS.enemy;
			characterType = CHARACTER_TYPE.ghoster;
			walkSpd = .5
			
			// Dialogues
			name = "Ghoster";
			portrait = sNPCPortrait;
			
			// Animation
			sprite_index = sEnemy;
			characterAnimation = new CharacterAnimation(GetAnimationFramesDefault);
			anim = characterAnimation.getAnimation;
			
			// Pathfinding
			PathfindingInit()
			
			// Weapon
			lookDir = 0
			lookDirTarget = 0
			myWeapon = acquireWeapon(WEAPON.ghosterGun, id)
			
			// AI states --------------------------------------
			enum GHOSTER_STATE
			{
				idle, hide, reposition, shoot, reload
			}
			stateStrings = ["idle", "hide", "reposition", "shoot", "reload"]
			state = GHOSTER_STATE.idle
			lookAtPlayerTimer = new Range(40, 180)
			
			// Idle state
			moveCooldown = new Range(50, 400)
			idleWalkSpd = .5
			
			// Reposition
			updateRate = new Range(50, 100)
			updateRate.value = 0
			optimalRange = new Range(80, 180)
			wantsToHide = 0
			patience = 1
			repositionWalkSpd = 1
			inactiveTime = 0
			inactiveThreshold = new Range(0, 50)
			
			// Shoot
			shootingWalkSpd = .3
			shootMoveCooldown = new Range(0, 20)
			noTargetDuration = 0
			noTargetDurationMax = new Range(30, 180)
			
			// Hide
			panickedWalkSpd = 2
			
			// Behaviour
			stepEvent = function()
			{
				PathfindingStep()
				
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
						if (myWeapon.magazineAmmo <= 0)
						{
							walkSpd = repositionWalkSpd
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
						}
						break
						
					case GHOSTER_STATE.hide:
						if (!seesPlayer and reachedPathEnd)
						{
							state = GHOSTER_STATE.reload
							myWeapon.reloading = true
							walkSpd = repositionWalkSpd
						}
						break
				}
				
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
							if (playerDist < optimalRange.min_) updateRate.value *= 1. - (wantsToHide*.7) - .3
							if (!seesPlayerWell) updateRate.value *= .5
							if (playerDist > optimalRange.max_) updateRate.value *= .8
						}
						
						if (angle_difference(playerDir, point_direction(x, y, targetPointX, targetPointY)) < 75 and	
							playerDist > optimalRange.min_ and playerDist < optimalRange.max_ and
							seesPlayerWell)
						{
							pathTargetX = x
							pathTargetY = y
							FindNewPath()
						}
						
						// Reposition
						if (reachedPathEnd) inactiveTime++
						if (updateRate.value <= 0)
						{
							var foundPath = FindValidPathTargetReposition(optimalRange)
							inactiveTime = 0
							if (!foundPath) patience -= 1/7
							else patience = 1
							updateRate.rndmize()
						}
							
						break
						
					case GHOSTER_STATE.shoot:
						myWeapon.holdingTrigger = true
						
						if (shootMoveCooldown.value <= 0 and reachedPathEnd)	// Find new position
						{
							FindValidPathTarget(new Range(5, 30))
							shootMoveCooldown.rndmize()
						}
						if (reachedPathEnd) shootMoveCooldown.value--
						
						if (!seesPlayerWell) noTargetDuration++
						else noTargetDuration = 0
						break
						
					case GHOSTER_STATE.hide:
						if (seesPlayer and reachedPathEnd)
						{
							var foundPath = FindValidPathTargetReposition(new Range(30, 999), false)
							if (!foundPath)
							{
								FindValidPathTarget(new Range(20, 80))
							}
						}
						
						break
						
				}
				
				// -------------------
				
				myWeapon.update()
			}
			
			drawEvent = function()
			{
				PathfindingDraw()
				myWeapon.draw()
				
				if (AI_DEBUG)
				{
					var offset = 8
					var yy = y + 8
					var halign = draw_get_halign()
				
					draw_set_halign(fa_center)
					draw_text(x, yy + offset * 0, $"{stateStrings[state]}")
					draw_text(x, yy + offset * 1, $"Scared: {wantsToHide}")
					draw_text(x, yy + offset * 2, $"PlayerDist: {point_distance(x, y, oPlayer.x, oPlayer.y)}")
					draw_text(x, yy + offset * 3, $"Patience: {patience}")
					draw_text(x, yy + offset * 4, $"Inactive: {inactiveTime}")
					draw_text(x, yy + offset * 5, $"Ammo: {myWeapon.magazineAmmo}")
					draw_set_halign(halign)
				
					var objDir = point_direction(x, y, oPlayer.x, oPlayer.y)
					var xx1 = x + lengthdir_x(30, objDir - 5)
					var yy1 = y + lengthdir_y(30, objDir - 5)
					var xx2 = x + lengthdir_x(30, objDir + 5)
					var yy2 = y + lengthdir_y(30, objDir + 5)
					draw_line(x, y, xx1, yy1)
					draw_line(x, y, xx2, yy2)
				}
			}
			
		} break;
		
		// --------------------------------------------------------------------------------
		
		default:
			show_message("Attempting to create undefined character type!")
			break
	}
}