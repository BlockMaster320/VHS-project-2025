/// @function with_draw_state(lambda)
/// @param lambda A callable function that does drawing
function safeDraw(lambda){
    // store current global draw state
    var old_halign	= draw_get_halign();
    var old_valign	= draw_get_valign();
    var old_color	= draw_get_color();
	var old_font	= draw_get_font();

    // execute the passed lambda
    if (is_callable(lambda)) {
        lambda();
    } else {
		show_debug_message("⚠️ safeDraw() can't call uncallable lambda")
	}

    // restore old state
    draw_set_halign(old_halign);
    draw_set_valign(old_valign);
    draw_set_color(old_color);
	draw_set_font(old_font);
}
