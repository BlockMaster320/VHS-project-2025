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