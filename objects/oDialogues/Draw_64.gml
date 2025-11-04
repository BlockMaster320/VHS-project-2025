if (!talking) exit

var h = display_get_gui_height()
var w = display_get_gui_width()

var left = PADDING_H
var right = w - PADDING_H
var top = h - PADDING_V - TEXTBOX_HEIGHT
var bottom = h - PADDING_V

draw_set_alpha(0.9)
draw_roundrect_colour_ext(left, top, right, bottom, 30, 30, c_black, c_black, false);
draw_set_alpha(1)
draw_set_color(c_white)
//draw_text(left + PADDING_H, top + PADDING_V, string_copy(current_line.text, 0, timer/2))
draw_text_transformed(left + PADDING_H, top + PADDING_V, string_copy(current_line.text, 0, timer/2), .5, .5, 0)
draw_sprite_ext(closest_NPC.portrait, 0, right - 192, top + 1, 1, 1, 0, -1, 1);
