enum CHARACTER_CLASS
{
	player,
	NPC,
	enemy,
}

enum CHARACTER_TYPE
{
	player,
	ghoster,
	mechanic,
	shopkeeper,
}

enum CharacterState {
	Idle,
	Run,
	Harm,
	Dead
}

function CharacterController(_object, _characterType) constructor {
	
	object		  = _object
	characterType = _characterType;
	characterClass = noone;
	name = "";
	portrait = sNPCPortrait;
	hp = 5;
	harmed_duration = 0;
	dir = 1;
	
	characterState = CharacterState.Idle;
	
	// animation control
	characterAnimation = noone;
	anim = noone;
	sprite_index = sCharacters;
	sprite_frame = 0;
	image_speed = 0.1;
	
	// Set the character variables
	switch(characterType) {
		
		case CHARACTER_TYPE.player: {
			characterClass = CHARACTER_CLASS.player;
			name = "Player";
			portrait = sNPCPortrait;
			
			sprite_index = sCharacters;
			characterAnimation = new CharacterAnimation(GetAnimationFrameRange);
			anim = characterAnimation.getAnimation;
		} break;
		
		case CHARACTER_TYPE.mechanic: {
			characterClass = CHARACTER_CLASS.NPC;
			name = "Mechanic";
			portrait = sNPCPortrait;
			
			sprite_index = sNPC;
			characterAnimation = new CharacterAnimation(GetAnimationFrameRange);
			anim = characterAnimation.getAnimation;
		} break;
		
		case CHARACTER_TYPE.ghoster: {
			characterClass = CHARACTER_CLASS.enemy;
			name = "Ghoster";
			portrait = sNPCPortrait;
			
			sprite_index = sEnemy;
			characterAnimation = new CharacterAnimation(GetAnimationFrameRange);
			anim = characterAnimation.getAnimation;
		} break;
	}
		
	
	setState = function(_characterState) {
		show_debug_message("set to: " + string(_characterState))
		characterState = _characterState
	}
	
	step = function() {
		/*x = object.x
		y = object.y*/
		
		if (keyboard_check_pressed(ord("H"))) {
			hp--;
			harmed_duration = image_speed * 30
			characterState = CharacterState.Harm
		}
		if (hp <= 0) {
			characterState = CharacterState.Dead
		}
	
		if (harmed_duration > 0) {
			harmed_duration -= image_speed;
		}
		
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
		
		var range = anim(characterState).range;
		var start = range[0];
		var ended = range[1];
		
		sprite_frame += image_speed;
		
		if (sprite_frame >= ended + 1) sprite_frame = start; // loop back
		if (sprite_frame < start) sprite_frame = start;
		
		//image_index = floor(image_fake_index)
	
	}
	
	draw = function() {
		
		dir = (oController.aimDir > 90 and oController.aimDir < 270) ? 1 : -1
		var color = characterState == CharacterState.Harm ? c_red : c_white;
		
		switch(characterType) {
			case CHARACTER_TYPE.player: {
				draw_sprite_ext(sprite_index, sprite_frame, roundPixelPos(object.x), roundPixelPos(object.y), dir, 1, 0, color, 1)
			} break;
		
			default: {
				draw_sprite_ext(sprite_index, sprite_frame, roundPixelPos(object.x), roundPixelPos(object.y), 1, 1, 0, color, 1)
			} break;
		}

	}
}