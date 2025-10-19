if (!talking) exit

var h = display_get_gui_height()
var w = display_get_gui_width()

var left = 50
var right = w - 50
var top = h - 30 - 192
var bottom = h - 30

draw_set_alpha(0.75)
draw_roundrect_colour_ext(left, top, right, bottom, 30, 30, c_black, c_black, false);
draw_set_alpha(1)
draw_set_color(c_white)
draw_text(left + 50, top + 30, current_line.text)
draw_sprite(closest_NPC.portrait, 0, right - 192, bottom - 191)
