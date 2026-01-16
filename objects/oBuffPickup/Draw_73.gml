if (point_distance(x,y,oPlayer.x,oPlayer.y) > cameraW) return

var alpha = 1
if (!instanceInRange(oPlayer, PICKUP_DISTANCE))
	alpha = 0.7

// Show buff description
	
if (global.SHOW_HITBOXES)
{
	draw_set_color(c_red)
	draw_set_alpha(.8)
	draw_circle(x, y, PICKUP_DISTANCE, true)
	draw_set_alpha(1)
	draw_set_color(c_white)
}

draw_set_alpha(alpha)

draw_set_color(c_black)
draw_rectangle(left, top, right, bott, false)

var yy = top + margin - textLineOff/2

draw_set_halign(fa_center)
//draw_set_valign(fa_middle)

if (myBuff.descriptionBuff != "")
{
	draw_set_color(c_green)
	draw_text_transformed(roundPixelPos(centerX), roundPixelPos(yy), myBuff.descriptionBuff, scale, scale, 0)
	yy += (lineH + textLineOff) * (string_count("\n", myBuff.descriptionBuff)+1)
	
}
if (myBuff.descriptionDebuff != "")
{
	draw_set_color(c_red)
	draw_text_transformed(roundPixelPos(centerX), roundPixelPos(yy), myBuff.descriptionDebuff, scale, scale, 0)
	yy += (lineH + textLineOff) * (string_count("\n", myBuff.descriptionDebuff)+1)
}
if (myBuff.descriptionNeutralEffect != "")
{
	draw_set_color(c_yellow)
	draw_text_transformed(roundPixelPos(centerX), roundPixelPos(yy), myBuff.descriptionNeutralEffect, scale, scale, 0)
}

draw_set_halign(fa_left)
//draw_set_valign(fa_top)

draw_set_color(c_white)
draw_set_alpha(1.)