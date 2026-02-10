draw_self()

if (containsWeapon)
{
	var alpha = max(0, (sin(current_time*.001 + randomOffset)-.7) * .4)
	gpu_set_blendmode(bm_add)
	draw_set_alpha(alpha)
	draw_circle_color(x, y, 15, c_yellow, c_black, false)
	draw_set_alpha(1)
	gpu_set_blendmode(bm_normal)
}