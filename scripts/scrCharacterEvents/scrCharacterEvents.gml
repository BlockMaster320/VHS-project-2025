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
					case CharacterState.Dead:
						break;
				}
			};
		}
		
		case CHARACTER_TYPE.mechanic: {
			return function() {
				//show_debug_message("mechanic step");
			};
		}

		default: { 
			return DO NOTHING
		}
	}
}

// Returns draw event of the specified character.
function getCharacterDrawEvent(_characterType) {
	switch (_characterType) {
		case CHARACTER_TYPE.player: {
			return function() {
				
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
				
					draw_sprite_ext(sHands, spriteFrameHands, roundPixelPos(x), roundPixelPos(y), dir, 1, 0, c_white, handsAlpha)
				}
			};
		}
		
		case CHARACTER_TYPE.mechanic: {
			return function() {
				//show_debug_message("mechanic draw");
			};
		}
		
		default: {
			return DO NOTHING
		}
	}
}


function characterCreate(_characterType) {
	
	switch(_characterType) {
		
		// Player -----------------------------------------------------------
		
		case CHARACTER_TYPE.player: {		
			characterClass = CHARACTER_CLASS.player;
			characterType = CHARACTER_TYPE.player;
			name = "Player";
			portrait = sNPCPortrait;
			
			drawnSprite = sCharacters;
			imageOffset = 0;
			characterAnimation = new CharacterAnimation(GetAnimationFramesPlayer);
			anim = characterAnimation.getAnimation;
			handsAnimation = new CharacterAnimation(GetAnimationFramesHands);
			animHands = handsAnimation.getAnimation;
			spriteFrameHands = 0;
			imageSpeedHands = 0;
			
			stepEvent = getCharacterStepEvent(CHARACTER_TYPE.player);
			drawEvent = getCharacterDrawEvent(CHARACTER_TYPE.player);
			onDeathEvent = function() {
				
				oController.roomsCleared = 0
				oController.buffsObtained = 0
				
				debug("player has died")
				if (instance_exists(oRoomManager)) {
					oRoomManager.killAllEnemies()
					oRoomManager.killAllEnemyProjectiles()
				} else if (instance_exists(oBossFight)) {
					oBossFight.removeClones()
					oBossFight.deactivateCleaner()
				}
				DeathScene(self)
			}
			
		} break;
		
		
		case CHARACTER_TYPE.dummyPlayer: {		
			characterClass = CHARACTER_CLASS.NPC;
			characterType = CHARACTER_TYPE.dummyPlayer;
			name = "Dummy Player";
			portrait = sNPCPortrait;
			
			drawnSprite = sCharacters;
			imageOffset = 0;
			characterAnimation = new CharacterAnimation(GetAnimationFramesPlayer);
			anim = characterAnimation.getAnimation;
			handsAnimation = new CharacterAnimation(GetAnimationFramesHands);
			animHands = handsAnimation.getAnimation;
			spriteFrameHands = 0;
			imageSpeedHands = 0;
			
			stepEvent = DO NOTHING;
			drawEvent = DO NOTHING;
		} break;
		
		// NPCs -----------------------------------------------------------
		
		case CHARACTER_TYPE.mechanic: {
			characterClass = CHARACTER_CLASS.NPC;
			characterType = CHARACTER_TYPE.mechanic;
			name = "Mechanic";
			portrait = sMechanicPortrait;
			
			drawnSprite = sCharacters;
			imageOffset = 66;
			characterAnimation = new CharacterAnimation(GetAnimationFramesMechanic);
			anim = characterAnimation.getAnimation;
			
			stepEvent = getCharacterStepEvent(CHARACTER_TYPE.mechanic);
			drawEvent = getCharacterDrawEvent(CHARACTER_TYPE.mechanic);
		} break;
		
		case CHARACTER_TYPE.shopkeeper: {
			characterClass = CHARACTER_CLASS.NPC;
			characterType = CHARACTER_TYPE.shopkeeper;
			name = "Shopkeeper";
			portrait = sShopkeeperPortrait;
			
			drawnSprite = sShopkeeper;
			imageOffset = 0;
			characterAnimation = new CharacterAnimation(GetAnimationFramesDefault);
			anim = characterAnimation.getAnimation;
			
			stepEvent = getCharacterStepEvent(CHARACTER_TYPE.shopkeeper);
			drawEvent = getCharacterDrawEvent(CHARACTER_TYPE.shopkeeper);
		} break;
		
		case CHARACTER_TYPE.passenger1: {
			controller = new PassengerController(
				id, 
				11,
				"Passanger 1"
			)
		} break;
		case CHARACTER_TYPE.passenger2: {
			controller = new PassengerController(
				id, 
				22,
				"Passanger 2"
			)
		} break;
		case CHARACTER_TYPE.passenger3: {
			controller = new PassengerController(
				id, 
				44,
				"Passanger 3"
			)
		} break;
		
		case CHARACTER_TYPE.playerCleaner: {
			controller = new PlayerCleanerController(id)
		} break;
		
		case CHARACTER_TYPE.student: {
			characterClass = CHARACTER_CLASS.NPC;
			characterType = CHARACTER_TYPE.student;
			name = "Mechanic";
			portrait = sStudentPortrait;
			
			drawnSprite = sCharacters;
			imageOffset = 55;
			characterAnimation = new CharacterAnimation(GetAnimationFramesCompanion);
			anim = characterAnimation.getAnimation;
			dir = -1;
			
			exiting = false
			
			FollowPathInit()
			
			stepEvent = function()
			{
				if (!reachedPathEnd) followPathStep()
				if (exiting and alpha <= .001) instance_destroy()
			}
			
			drawEvent = function()
			{
				followPathDraw()
				if (exiting and reachedPathEnd) alpha = lerp(alpha, 0, .1)
			}
			
		} break;
		
		// Enemies ---------------------------------------------------------------
		
		case CHARACTER_TYPE.targetDummy: {
			// Character attributes
			characterClass = CHARACTER_CLASS.enemy;
			characterType = CHARACTER_TYPE.targetDummy;
			walkSpd = .5
			
			// Dialogues
			name = "Target dummy";
			portrait = sNPCPortrait;
			
			// Animation
			drawnSprite = sEnemy;
			imageOffset = 110;
			characterAnimation = new CharacterAnimation(GetAnimationFramesEnemy);
			anim = characterAnimation.getAnimation;
			
			// Weapon
			lookDir = 0
			lookDirTarget = 0
			myWeapon = acquireWeapon(WEAPON.ghosterGun, id)
			
			// Behaviour
			stepEvent = function()
			{
				myWeapon.update()
			}
			drawEvent = function()
			{
				draw_text(x, y - 20, $"HP: {hp}")
				myWeapon.draw()
			}
			break
		}
		
		/*
		case CHARACTER_TYPE.ghoster: {
			// Character attributes
			characterClass = CHARACTER_CLASS.enemy;
			characterType = CHARACTER_TYPE.ghoster;
			walkSpd = .5
			
			// Dialogues
			name = "Ghoster";
			portrait = sNPCPortrait;
			
			// Animation
			drawnSprite = sCharacters;
			imageOffset = 99;
			characterAnimation = new CharacterAnimation(GetAnimationFramesEnemy);
			anim = characterAnimation.getAnimation(imageOffset);
			
			// Pathfinding
			pathfindingInit()
			
			// Weapon
			lookDir = 0
			lookDirTarget = 0
			myWeapon = acquireWeapon(WEAPON.ghosterGun, id)
			
			// AI
			ghosterAiInit()
			
			// Behaviour
			stepEvent = function()
			{
				pathfindingStep()
				ghosterAiUpdate()
				myWeapon.update()
			}
			
			drawEvent = function()
			{
				pathfindingDraw()
				myWeapon.draw()
				ghosterAiDraw()	// AI visualization
			}
			
		} break;
		*/
		
		case CHARACTER_TYPE.ghoster: {
			// Character attributes
			characterClass = CHARACTER_CLASS.enemy;
			characterType = CHARACTER_TYPE.ghoster;
			walkSpd = .5
			
			hp = 150
			
			// Dialogues
			name = "Ghoster";
			portrait = sNPCPortrait;
			
			// Animation
			drawnSprite = sCharacters
			imageOffset = 122;
			characterAnimation = new CharacterAnimation(GetAnimationFramesEnemy);
			anim = characterAnimation.getAnimation;
			
			// Pathfinding
			pathfindingInit()
			
			// Weapon
			lookDir = 0
			lookDirTarget = 0
			var weaponID = choose(WEAPON.ghosterGun, WEAPON.ghosterShotgun)
			myWeapon = acquireWeapon(weaponID, id)
			switch (weaponID)
			{
				case WEAPON.ghosterGun:
					myWeapon.attackSpeed += oController.currentFloor * 1
					myWeapon.magazineSize += oController.currentFloor * 6
					break
				case WEAPON.ghosterShotgun:
					myWeapon.attackSpeed += oController.currentFloor * .3
					myWeapon.projectileAmount += oController.currentFloor * 2
					break
			}
			
			// AI
			ghosterAiInit()
			
			// Behaviour
			stepEvent = function()
			{
				pathfindingStep()
				ghosterAiUpdate()
				myWeapon.update()
			}
			
			drawEvent = function()
			{
				pathfindingDraw()
				myWeapon.draw()
				ghosterAiDraw()	// AI visualization
			}
		} break;
		
		case CHARACTER_TYPE.fanner: {
			
			// Character attributes
			characterClass = CHARACTER_CLASS.enemy;
			characterType = CHARACTER_TYPE.fanner;
			walkSpd = .5
			
			hp = 200
			
			// Dialogues
			name = "Fanner";
			portrait = sNPCPortrait;
			
			// Animation
			drawnSprite = sCharacters
			imageOffset = 77;
			characterAnimation = new CharacterAnimation(GetAnimationFramesEnemy);
			anim = characterAnimation.getAnimation;
			
			// Pathfinding
			pathfindingInit()
			
			// Weapon
			lookDir = 0
			lookDirTarget = 0
			myWeapon = acquireWeapon(WEAPON.enemyFan, id)
			myWeapon.magazineSize += oController.currentFloor * 200
			
			// AI
			slasherAiInit()
			optimalRange = new Range(1*TILE_SIZE, 6*TILE_SIZE)
			restTime = new Cooldown(120)
			
			// Behaviour
			stepEvent = function()
			{
				pathfindingStep()
				slasherAiUpdate()
				myWeapon.update()
			}
			
			drawEvent = function()
			{
				pathfindingDraw()
				myWeapon.draw()
				slasherAiDraw()	// AI visualization
			}
		} break;
		
		
		// Dropper - can carry any gun and drops it on death
		case CHARACTER_TYPE.dropper: {
			// Character attributes
			characterClass = CHARACTER_CLASS.enemy;
			characterType = CHARACTER_TYPE.dropper;
			walkSpd = .5
			
			// Dialogues
			name = "Dropper";
			portrait = sNPCPortrait;
			
			// Animation
			drawnSprite = sCharacters;
			imageOffset = 77;
			characterAnimation = new CharacterAnimation(GetAnimationFramesEnemy);
			anim = characterAnimation.getAnimation;
			
			// Pathfinding
			pathfindingInit()
			
			// Weapon
			lookDir = 0
			lookDirTarget = 0
			var weaponID = choose(WEAPON.pigeon, WEAPON.fan, WEAPON.paperPlane, WEAPON.ticketMachine, WEAPON.crowbar, WEAPON.groanTube)
			myWeapon = acquireWeapon(weaponID, id)
			myWeapon.projectile.damage *= .5
			myWeapon.projectile.projectileSpeed *= .5
			
			// AI
			dropperAiInit()
			
			// Behaviour
			stepEvent = function()
			{
				pathfindingStep()
				dropperAiUpdate()
				myWeapon.update()
			}
			
			drawEvent = function()
			{
				pathfindingDraw()
				myWeapon.draw()
				dropperAiDraw()	// AI visualization
			}
			
			onDeathEvent = dropperOnDeath
			
		} break;
		
		// Melee slasher - enemy with a sword
		case CHARACTER_TYPE.meleeSlasher: {
			// Character attributes
			characterClass = CHARACTER_CLASS.enemy;
			characterType = CHARACTER_TYPE.meleeSlasher;
			walkSpd = .5
			
			hp = 250
			
			// Dialogues
			name = "Melee slasher";
			portrait = sNPCPortrait;
			
			// Animation
			drawnSprite = sCharacters;
			imageOffset = 88;
			characterAnimation = new CharacterAnimation(GetAnimationFramesEnemy);
			anim = characterAnimation.getAnimation;
			
			// Pathfinding
			pathfindingInit()
			
			// Weapon
			lookDir = 0
			lookDirTarget = 0
			myWeapon = acquireWeapon(WEAPON.enemyCrowbar, id)
			myWeapon.projectile.damage += oController.currentFloor * 10
			
			// AI
			slasherAiInit()
			
			// Behaviour
			stepEvent = function()
			{
				pathfindingStep()
				slasherAiUpdate()
				myWeapon.update()
			}
			
			drawEvent = function()
			{
				pathfindingDraw()
				myWeapon.draw()
				slasherAiDraw()	// AI visualization
			}
			
		} break;
		
		case CHARACTER_TYPE.cleanerEnemy: {
			// Character attributes
			characterClass = CHARACTER_CLASS.enemy;
			characterType = CHARACTER_TYPE.cleanerEnemy;
			walkSpd = .5
			maxHp = 1500
			hp = maxHp
			recDmgMult = .3
			
			// Dialogues
			name = "Cleaner enemy";
			portrait = sCleanerPortrait;
			
			// Animation
			drawnSprite = sCharacters;
			imageOffset = 44;
			characterAnimation = new CharacterAnimation(GetAnimationFramesCleaner2);
			anim = characterAnimation.getAnimation;
			
			// Pathfinding
			pathfindingInit()
			
			// Weapon
			lookDir = 0
			lookDirTarget = 0
			myWeapon = acquireWeapon(WEAPON.crowbar, id)
			
			// AI
			cleanerAiInit()
			
			// Behaviour
			stepEvent = function()
			{
				pathfindingStep()
				cleanerAiUpdate()
				myWeapon.update()
				if (recDmgMult < 1) recDmgMult += 1/60 / 30
				else if (recDmgMult < 2) recDmgMult += 1/60 / 100
				show_debug_message(recDmgMult)
			}
			
			drawEvent = function()
			{
				pathfindingDraw()
				myWeapon.draw()
				cleanerAiDraw()	// AI visualization
			}
			
			onDeathEvent = function()
			{
				oBossFight.removeClones()
				oBossFight.cleanerEnemy = noone
				instance_destroy()
			}
			
		} break;
		
		case CHARACTER_TYPE.cleanerClone: {
			// Character attributes
			characterClass = CHARACTER_CLASS.enemy;
			characterType = CHARACTER_TYPE.cleanerClone;
			walkSpd = .5
			
			maxHp = 80
			hp = maxHp
			
			// Dialogues
			name = "Cleaner clone";
			portrait = sNPCPortrait;
			
			// Animation
			drawnSprite = sCharacters;
			imageOffset = 44;
			characterAnimation = new CharacterAnimation(GetAnimationFramesCleaner2);
			anim = characterAnimation.getAnimation;
			
			// Pathfinding
			pathfindingInit()
			
			// Weapon
			lookDir = 0
			lookDirTarget = 0
			var weaponID = choose(WEAPON.pigeon, WEAPON.fan, WEAPON.paperPlane, WEAPON.ticketMachine, WEAPON.crowbar, WEAPON.groanTube)
			myWeapon = acquireWeapon(weaponID, id)
			myWeapon.projectile.projectileSpeed *= .4
			myWeapon.projectile.damage *= .4
			myWeapon.spread = 45
			
			// AI
			dropperAiInit()
			//coordinationParticipant = false
			
			cloneFadeInCD = new Range(30, 100)
			cloneFadeInCD.rndmize()
			
			// Behaviour
			stepEvent = function()
			{
				if (cloneFadeInCD.value > 0)
				{
					cloneFadeInCD.value--
					return;
				}
				
				pathfindingStep()
				dropperAiUpdate()
				myWeapon.update()
			}
			
			drawEvent = function()
			{
				pathfindingDraw()
				
				if (cloneFadeInCD.value > 0)
				{
					draw_set_alpha(cloneFadeInCD.value / cloneFadeInCD.max_)
					draw_sprite(sCleanerCloneParticle, 0, x, y)
					draw_set_alpha(1)
				}
				
				myWeapon.draw()
				dropperAiDraw()	// AI visualization
			}
			
		} break;
		
		// --------------------------------------------------------------------------------
		
		default:
			show_message("Attempting to create undefined character type!")
			break
	}
	
	if (characterClass == CHARACTER_CLASS.enemy)
		sprite_index = sEnemy
	else sprite_index = sCharacters
}
