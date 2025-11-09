// Returns step event of the specified character.
function getCharacterStepEvent(_characterType){
	switch (_characterType) {
		case CHARACTER_TYPE.player: {
			return function() {
				show_debug_message("player step");
			};
		}
		
		case CHARACTER_TYPE.mechanic: {
			return function() {
				show_debug_message("mechanic step");
			};
		}
		
		case CHARACTER_TYPE.ghoster: {
			return function() {
				show_debug_message("ghoster step");
			};
		}
	}
}

// Returns draw event of the specified character.
function getCharacterDrawEvent(_characterType) {
	switch (_characterType) {
		case CHARACTER_TYPE.player: {
			return function() {
				show_debug_message("player draw");
			};
		}
		
		case CHARACTER_TYPE.mechanic: {
			return function() {
				show_debug_message("mechanic draw");
			};
		}
		
		case CHARACTER_TYPE.ghoster: {
			return function() {
				show_debug_message("ghoster draw");
			};
		}
	}
}


function characterCreate(_characterType) {
	switch(_characterType) {
		case CHARACTER_TYPE.player: {		
			characterClass = CHARACTER_CLASS.player;
			characterType = CHARACTER_TYPE.player;
			name = "Player";
			portrait = sNPCPortrait;
			
			sprite_index = sCharacters;
			characterAnimation = new CharacterAnimation(GetAnimationFrameRange);
			anim = characterAnimation.getAnimation;
			
			stepEvent = getCharacterStepEvent(CHARACTER_TYPE.player);
			drawEvent = getCharacterDrawEvent(CHARACTER_TYPE.player);
		} break;
		
		case CHARACTER_TYPE.mechanic: {
			characterClass = CHARACTER_CLASS.NPC;
			characterType = CHARACTER_TYPE.mechanic;
			name = "Mechanic";
			portrait = sNPCPortrait;
			
			sprite_index = sNPC;
			characterAnimation = new CharacterAnimation(GetAnimationFrameRange);
			anim = characterAnimation.getAnimation;
			
			stepEvent = getCharacterStepEvent(CHARACTER_TYPE.mechanic);
			drawEvent = getCharacterDrawEvent(CHARACTER_TYPE.mechanic);
		} break;
		
		case CHARACTER_TYPE.ghoster: {
			characterClass = CHARACTER_CLASS.enemy;
			characterType = CHARACTER_TYPE.ghoster;
			name = "Ghoster";
			portrait = sNPCPortrait;
			
			sprite_index = sEnemy;
			characterAnimation = new CharacterAnimation(GetAnimationFrameRange);
			anim = characterAnimation.getAnimation;
			
			stepEvent = getCharacterStepEvent(CHARACTER_TYPE.ghoster);
			drawEvent = getCharacterDrawEvent(CHARACTER_TYPE.ghoster);
		} break;
		
		default:
			show_debug_message("Attempting to create undefined character type!")
			break
	}
}