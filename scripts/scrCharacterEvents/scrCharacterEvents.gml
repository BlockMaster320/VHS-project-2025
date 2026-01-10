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
				
					draw_sprite_ext(sHands, spriteFrameHands, roundPixelPos(x), roundPixelPos(y), dir, 1, 0, c_white, 1)
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
			
			sprite_index = sCharacters;
			characterAnimation = new CharacterAnimation(GetAnimationFramesPlayer);
			anim = characterAnimation.getAnimation;
			handsAnimation = new CharacterAnimation(GetAnimationFramesHands);
			animHands = handsAnimation.getAnimation;
			spriteFrameHands = 0;
			imageSpeedHands = 0;
			
			stepEvent = getCharacterStepEvent(CHARACTER_TYPE.player);
			drawEvent = getCharacterDrawEvent(CHARACTER_TYPE.player);
			onDeathEvent = function() {
				debug("player has died")
				DeathScene(self)
			}
			
		} break;
		
		
		case CHARACTER_TYPE.dummyPlayer: {		
			characterClass = CHARACTER_CLASS.NPC;
			characterType = CHARACTER_TYPE.dummyPlayer;
			name = "Dummy Player";
			portrait = sNPCPortrait;
			
			sprite_index = sCharacters;
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
			
			sprite_index = sCharacters;
			characterAnimation = new CharacterAnimation(GetAnimationFramesMechanic);
			anim = characterAnimation.getAnimation;
			
			stepEvent = getCharacterStepEvent(CHARACTER_TYPE.mechanic);
			drawEvent = getCharacterDrawEvent(CHARACTER_TYPE.mechanic);
		} break;
		
		case CHARACTER_TYPE.shopkeeper: {
			characterClass = CHARACTER_CLASS.NPC;
			characterType = CHARACTER_TYPE.mechanic;
			name = "Shopkeeper";
			portrait = sNPCPortrait;
			
			sprite_index = sShopkeeper;
			characterAnimation = new CharacterAnimation(GetAnimationFramesDefault);
			anim = characterAnimation.getAnimation;
			
			stepEvent = getCharacterStepEvent(CHARACTER_TYPE.shopkeeper);
			drawEvent = getCharacterDrawEvent(CHARACTER_TYPE.shopkeeper);
		} break;
		
		case CHARACTER_TYPE.passenger1: {
			controller = new Passenger1Controller(
				id, 
				"Passanger 1"
			)
		} break;
		case CHARACTER_TYPE.passenger2: {
			controller = new Passenger1Controller(
				id, 
				"Passanger 2"
			)
		} break;
		case CHARACTER_TYPE.passenger3: {
			controller = new Passenger1Controller(
				id, 
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
			portrait = sNPCPortrait;
			
			sprite_index = sCharacters;
			characterAnimation = new CharacterAnimation(GetAnimationFramesMechanic);
			anim = characterAnimation.getAnimation;
			dir = -1;
			
			stepEvent = getCharacterStepEvent(CHARACTER_TYPE.mechanic);
			drawEvent = getCharacterDrawEvent(CHARACTER_TYPE.mechanic);
		} break;
		
		// Enemies ---------------------------------------------------------------
		
		case CHARACTER_TYPE.targetDummy:
			// Character attributes
			characterClass = CHARACTER_CLASS.enemy;
			characterType = CHARACTER_TYPE.targetDummy;
			walkSpd = .5
			
			// Dialogues
			name = "Ghoster";
			portrait = sNPCPortrait;
			
			// Animation
			sprite_index = sEnemy;
			characterAnimation = new CharacterAnimation(GetAnimationFramesDefault);
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
			sprite_index = sCharacters;
			characterAnimation = new CharacterAnimation(GetAnimationFramesMechanic);
			anim = characterAnimation.getAnimation;
			
			// Pathfinding
			pathfindingInit()
			
			// Weapon
			lookDir = 0
			lookDirTarget = 0
			var weaponID = choose(WEAPON.sword, WEAPON.defaultGun, WEAPON.garbage)
			myWeapon = acquireWeapon(weaponID, id)
			
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
		
		// --------------------------------------------------------------------------------
		
		default:
			show_message("Attempting to create undefined character type!")
			break
	}
}
