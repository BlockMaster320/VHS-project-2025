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
		draw_sprite_ext(drawnSprite, sprite_frame, roundPixelPos(x), roundPixelPos(y), dir, 1, 0, c_white, alpha)
	shader_reset()
	
	flashFac = lerp(flashFac, 1, flashFacMixFac)
	hitFlashCooldown.value -= global.gameSpeed
}
else draw_sprite_ext(drawnSprite, sprite_frame, roundPixelPos(x), roundPixelPos(y), dir, 1, 0, c_white, alpha)

if (inRange && global.inputState != INPUT_STATE.cutscene)
	draw_text(x - (string_width("[E]") / 2), y - sprite_yoffset - 10, "[E]")
else if (characterType == oController.questNPC)
{
	var questAlpha = sin((current_time*2*pi)/2000)*.25+.75
	var yOff = sin((current_time*2*pi)/1500) * 1.5
	draw_set_alpha(questAlpha)
	draw_sprite(sQuest, 0, roundPixelPos(x) , roundPixelPos(y - sprite_yoffset - 7 + yOff))
	draw_set_alpha(1)
}
		
// DRAW EVENT OF THE SPECIFIC CHARACTER --------------------
if (is_callable(drawEvent)) {
	drawEvent();
} else {
	warning("drawEvent is not callable for NPC: " + string(name) );
}


if (global.SHOW_HITBOXES)
{
	drawHitbox(x, y, sprite_index, image_xscale, image_yscale)
}