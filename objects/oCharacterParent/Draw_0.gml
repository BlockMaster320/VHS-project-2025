// GENERIC DRAW EVENT (same for all characters) --------------------
// Draw health
draw_text(x, y - 20, $"Health: {hp}")

// Draw the character
dir = (oController.aimDir > 90 and oController.aimDir < 270) ? 1 : -1
var color = characterState == CharacterState.Harm ? c_red : c_white;
		
switch(characterType) {
	case CHARACTER_TYPE.player: {
		draw_sprite_ext(sprite_index, sprite_frame, roundPixelPos(x), roundPixelPos(y), dir, 1, 0, color, 1)
	} break;
		
	default: {
		draw_sprite_ext(sprite_index, sprite_frame, roundPixelPos(x), roundPixelPos(y), 1, 1, 0, color, 1)
	} break;
}
		
// DRAW EVENT OF THE SPECIFIC CHARACTER --------------------
drawEvent()