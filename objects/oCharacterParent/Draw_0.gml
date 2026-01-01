// GENERIC DRAW EVENT (same for all characters) --------------------
// Draw health
//draw_text(x, y - 20, $"Health: {hp}")

// Set draw depth
if (y != yprevious) depth = -y


// Draw the character
//var color = characterState == CharacterState.Harm ? c_red : c_white;
if (hitFlashCooldown.value > 0)
{
	shader_set(shHitFlash)
		shader_set_uniform_f(flashFacLoc, flashFac)
		draw_sprite_ext(sprite_index, sprite_frame, roundPixelPos(x), roundPixelPos(y), dir, 1, 0, c_white, 1)
	shader_reset()
	
	flashFac = lerp(flashFac, 1, flashFacMixFac)
	hitFlashCooldown.value -= global.gameSpeed
}
else draw_sprite_ext(sprite_index, sprite_frame, roundPixelPos(x), roundPixelPos(y), dir, 1, 0, c_white, 1)

if (inRange){
	draw_text(x - (string_width("[E]") / 2), y - sprite_yoffset - 15, "[E]")
}
		
// DRAW EVENT OF THE SPECIFIC CHARACTER --------------------
drawEvent()


if (SHOW_HITBOXES)
{
	drawHitbox(x, y, sprite_index, image_xscale, image_yscale)
}