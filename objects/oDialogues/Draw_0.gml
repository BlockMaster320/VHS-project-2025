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
	
	// NPC
	var drawNPC = !is_undefined(closest_NPC) && closest_NPC != noone
	var portraitWidth = drawNPC ? sprite_get_width(closest_NPC.portrait) : 0
	var portraitHeight = drawNPC ? sprite_get_height(closest_NPC.portrait) : 0
	
	// Adjust top if it's a multiline text with options
	if (waiting_for_answer){
		var textLines = (string_height_ext(text, textHeight, textboxWidth - portraitWidth) / textHeight) - 1
		top -= textLines * 16
	}
	
	draw_set_alpha(0.9)
	draw_roundrect_colour_ext(left, top, right, bottom, 30, 30, c_black, c_black, false);
	draw_set_alpha(1)
	draw_set_color(c_white)
	
	draw_text_ext(left + PADDING_H, top + PADDING_V, text, textHeight, textboxWidth - portraitWidth)
	
	if (drawNPC) draw_sprite_ext(closest_NPC.portrait, 0, textboxRight - portraitWidth + 5, bottom - portraitHeight, 1, 1, 0, -1, 1);
	
	if (current_dialogue.seen){
		var skipText = "skip >>"
		var skipRight = textboxRight - portraitWidth - string_width(skipText) - 7
		var skipTop =  bottom - string_height(skipText) - 2
		
		var _x = device_mouse_x_to_gui(0) * guiToCamera
		var _y = device_mouse_y_to_gui(0) * guiToCamera
		if (_x < skipRight || _x > skipRight + string_width(skipText) || _y < skipTop || _y > skipTop + string_height(skipText)){
			draw_set_alpha(0.6)
			mouseOnSkip = false
		} else {
			mouseOnSkip = true
		}
		
		draw_text(skipRight, skipTop, skipText)
	}
	
	surface_reset_target()
})
