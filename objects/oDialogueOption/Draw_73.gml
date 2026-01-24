if (!active) exit


surface_set_target(oController.guiSurf)


right = left + string_width(text) + 2 * PADDING_OPTION
top = cameraH - PADDING_V - TEXTBOX_HEIGHT/2 + idx*(string_height("L") + idx*PADDING_OPTION)
bottom = top + string_height("L")

if (selected)
{
	draw_set_alpha(1)
	draw_roundrect_colour_ext(left, top, right, bottom, 10, 10, c_white, c_white, true);
	draw_text(left + PADDING_OPTION, top, text)
} else {
	draw_set_alpha(0.6)
	draw_text(left, top, text)
}
draw_set_alpha(1)


surface_reset_target()