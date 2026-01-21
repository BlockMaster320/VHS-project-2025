draw_set_font(fntGeneric)
draw_set_halign(fa_center)
draw_set_valign(fa_middle)
var scale = 6
draw_set_alpha(.5)
draw_text_transformed(room_width/2, room_height/2, "Click to start", scale, scale, 0)
draw_set_halign(fa_left)
draw_set_valign(fa_top)
draw_set_alpha(1)