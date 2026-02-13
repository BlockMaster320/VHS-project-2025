if (cleanerEnemy != noone){
	surface_set_target(oController.guiSurf)

	var margin = 2 * TILE_SIZE
	var rightX = cameraW - margin
	
	var w = cameraW - 2*margin
	var h = 13
	
	var x1 = margin
	var y1 = margin/2
	var x2 = x1 + w
	var y2 = y1 + h

	var healthFac = cleanerEnemy.hp / cleanerEnemy.maxHp

	draw_set_alpha(1)
	draw_set_color(c_black)
	draw_roundrect(x1, y1, x2, y2, false)
	draw_set_color(c_maroon)
	draw_roundrect(x1, y1, lerp(x1, x2, healthFac), y2, false)
	draw_set_color(c_white)
	draw_roundrect(x1, y1, x2, y2, true)
	draw_set_color(c_white)

	surface_reset_target()
}
