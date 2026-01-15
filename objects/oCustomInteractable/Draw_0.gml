if (hitFlashCooldown.value > 0)
{
	shader_set(shHitFlash)
		shader_set_uniform_f(flashFacLoc, flashFac)
		draw_self()
	shader_reset()
	
	flashFac = lerp(flashFac, 1, flashFacMixFac)
	hitFlashCooldown.value -= global.gameSpeed
}
else draw_self()

if (global.SHOW_HITBOXES)
{
	draw_set_color(c_red)
	draw_set_alpha(.8)
	draw_circle(x, y, PICKUP_DISTANCE, true)
	draw_set_alpha(1)
	draw_set_color(c_white)
}