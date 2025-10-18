if (!talking) exit

var h = display_get_gui_height()
var w = display_get_gui_width()

draw_set_alpha(0.75)
draw_roundrect_colour_ext(50, h-210, w-50, h-30, 30, 30, c_silver, c_silver, false);
draw_set_alpha(1)
draw_set_color(c_black)
draw_text(100, h-180, current_line.text)
