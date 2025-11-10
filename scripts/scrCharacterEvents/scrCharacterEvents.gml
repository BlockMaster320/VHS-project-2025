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
		
		case CHARACTER_TYPE.ghoster: {
			return function() {
				//show_debug_message("ghoster step");
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
				dir = (oController.aimDir > 90 and oController.aimDir < 270) ? -1 : 1
				
				// Draw player's hands
				var animationFrames = animHands(characterState);
				var start = animationFrames.range[0];
				var ended = animationFrames.range[1];

				spriteFrameHands += imageSpeedHands;

				if (spriteFrameHands >= ended + 1) spriteFrameHands = start; // loop back
				if (spriteFrameHands < start) spriteFrameHands = start;

				imageSpeedHands = animationFrames.speeds[floor(spriteFrameHands) - start];
				draw_sprite_ext(sHands, spriteFrameHands, roundPixelPos(x), roundPixelPos(y), dir, 1, 0, c_white, 1)
			};
		}
		
		case CHARACTER_TYPE.mechanic: {
			return function() {
				//show_debug_message("mechanic draw");
			};
		}
		
		case CHARACTER_TYPE.ghoster: {
			return function() {
				//show_debug_message("ghoster draw");
			};
		}
	}
}


function characterCreate(_characterType) {
	switch(_characterType) {
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
		
		case CHARACTER_TYPE.ghoster: {
			characterClass = CHARACTER_CLASS.enemy;
			characterType = CHARACTER_TYPE.ghoster;
			name = "Ghoster";
			portrait = sNPCPortrait;
			
			sprite_index = sEnemy;
			characterAnimation = new CharacterAnimation(GetAnimationFramesDefault);
			anim = characterAnimation.getAnimation;
			
			stepEvent = getCharacterStepEvent(CHARACTER_TYPE.ghoster);
			drawEvent = getCharacterDrawEvent(CHARACTER_TYPE.ghoster);
		} break;
		
		default:
			show_message("Attempting to create undefined character type!")
			break
	}
}