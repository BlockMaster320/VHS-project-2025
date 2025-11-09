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
	}
}

// Returns draw event of the specified character.
function getCharacterDrawEvent(_characterType) {
	switch (_characterType) {
		case CHARACTER_TYPE.player: {
			return function() {
				//show_debug_message("player draw");
				dir = (oController.aimDir > 90 and oController.aimDir < 270) ? 1 : -1
			};
		}
		
		case CHARACTER_TYPE.mechanic: {
			return function() {
				//show_debug_message("mechanic draw");
			};
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
			characterAnimation = new CharacterAnimation(GetAnimationFramesDefault);
			anim = characterAnimation.getAnimation;
			
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
			dir = -1;
			
			stepEvent = getCharacterStepEvent(CHARACTER_TYPE.mechanic);
			drawEvent = getCharacterDrawEvent(CHARACTER_TYPE.mechanic);
		} break;
		
		// Enemies ---------------------------------------------------------------
		
		case CHARACTER_TYPE.ghoster: {
			// Character attributes
			characterClass = CHARACTER_CLASS.enemy;
			characterType = CHARACTER_TYPE.ghoster;
			
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
			
			// AI states
			enum GHOSTER_STATE
			{
				idle, fleeing, repositioning, shooting
			}
			
			
			// Behaviour
			stepEvent = function()
			{
				PathfindingStep()
				
				if (LineOfSight(oPlayer.x, oPlayer.y))
					lookDirTarget = point_direction(x, y, oPlayer.x, oPlayer.y)
				else if (whsp != 0 or wvsp != 0)
					lookDirTarget = point_direction(x, y, x + whsp, y + wvsp)
					
				lookDir = lerpDirection(lookDir, lookDirTarget, .2)
				myWeapon.aimDirection = lookDir
				
				myWeapon.update()
			}
			
			drawEvent = function()
			{
				PathfindingDraw()
				myWeapon.draw()
				
				var offset = 5
				var yy = y + 8
				var halign = draw_get_halign()
				
				draw_set_halign(fa_center)
				draw_text(x, yy + offset * 1, myWeapon.magazineAmmo)
				draw_set_halign(halign)
			}
			
		} break;
		
		// --------------------------------------------------------------------------------
		
		default:
			show_message("Attempting to create undefined character type!")
			break
	}
}