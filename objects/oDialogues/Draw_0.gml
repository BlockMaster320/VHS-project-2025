if (!talking) exit

safeDraw(function() {
	surface_set_target(oController.guiSurf)

	// Screen properties
	var h = cameraH
	var w = cameraW

	// Frame properties
	var left = PADDING_H
	var right = w - PADDING_H
	var top = h - PADDING_V - TEXTBOX_HEIGHT
	var bottom = h - PADDING_V
	
	// Text box properties
	var textboxLeft = left + PADDING_H
	var textboxRight = right - PADDING_H
	var textboxTop = top + PADDING_V
	var textboxBottom = bottom - PADDING_V
	
	var textboxWidth = textboxRight - textboxLeft
	var textboxHeight = textboxBottom - textboxTop
	
	// Text properties
	var text = string_copy(current_line.text, 0, timer/2)
	var textWidth = string_width(text)
	var textHeight = string_height(text)

	draw_set_alpha(0.9)
	draw_roundrect_colour_ext(left, top, right, bottom, 30, 30, c_black, c_black, false);
	draw_set_alpha(1)
	draw_set_color(c_white)
	
	draw_text_ext(left + PADDING_H, top + PADDING_V, text, textHeight, textboxWidth)
	
	draw_sprite_ext(closest_NPC.portrait, 0, right - 64, top + 1, 1, 1, 0, -1, 1);

	surface_reset_target()
})
