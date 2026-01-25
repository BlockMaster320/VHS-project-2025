draw_self()

var alpha = .4
if (instanceInRange(oPlayer, PICKUP_DISTANCE))	// Make text brighter when in range
	if (instance_nearest(oPlayer.x, oPlayer.y, oWeaponPickup) == id)	// Only affect the nearest pickup
		alpha = 1

draw_set_alpha(alpha)
draw_text(x - (string_width("[E]") / 2), y - sprite_yoffset - 15, "[E]")
draw_set_alpha(1)

if (global.SHOW_HITBOXES)
{
	draw_set_color(c_red)
	draw_set_alpha(.8)
	draw_circle(x, y, PICKUP_DISTANCE, true)
	draw_set_alpha(1)
	draw_set_color(c_white)
}