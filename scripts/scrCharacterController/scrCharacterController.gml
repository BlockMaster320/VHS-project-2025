function CharacterController(_object, _characterAnimation) constructor {
	
	object					= _object
	characterAnimation		= _characterAnimation
	x = 0;
    y = 0;
	hp = 5;
	harmed_duration = 0;
	dir = 1;
	
	characterState = characterAnimation.startCharacterState//CharacterState.Idle;
	// animation control
 
	sprite_index = sCharacters;
	sprite_frame = 0;
	image_speed = 0.1;
	
	sprite = sCharacters;
	anim = characterAnimation.getAnimation
    //anim = [];
	//anim[CharacterState.Idle] = [0, 0];     // single frame
    //anim[CharacterState.Run]  = [0, 3];     // frames 1–4
    //anim[CharacterState.Harm] = [4, 4];     // frame 5
    //anim[CharacterState.Dead] = [5, 5];     // frame 6
	
	setState = function(_characterState) {
		show_debug_message("set to: " + string(_characterState))
		characterState = _characterState
	}
	
	step = function() {
		x = object.x
		y = object.y
		
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
		//var current_dir = sign(oController.left - oController.right);
		//dir = (current_dir == 0) ? dir : current_dir;
		dir = (oController.aimDir > 90 and oController.aimDir < 270) ? 1 : -1
		var color = characterState == CharacterState.Harm ? c_red : c_white;
		
		draw_sprite_ext(sprite_index, sprite_frame, roundPixelPos(x), roundPixelPos(y), dir, 1, 0, color, 1)
	}
}

enum CharacterState {
	Idle,
	Run,
	Harm,
	Dead
}