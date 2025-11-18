// GENERIC DRAW EVENT (same for all characters) --------------------
// Draw health
//draw_text(x, y - 20, $"Health: {hp}")

// Set draw depth
if (y != yprevious) depth = -y


// Draw the character
var color = characterState == CharacterState.Harm ? c_red : c_white;
draw_sprite_ext(sprite_index, sprite_frame, roundPixelPos(x), roundPixelPos(y), dir, 1, 0, color, 1)
		
// DRAW EVENT OF THE SPECIFIC CHARACTER --------------------
drawEvent()


if (SHOW_HITBOXES)
{
	drawHitbox(x, y, sprite_index, image_xscale, image_yscale)
}