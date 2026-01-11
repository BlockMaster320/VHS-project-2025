// Show buff description

var alpha = 1

if (!instanceInRange(oPlayer, PICKUP_DISTANCE)) // Suboptimal performance but shouldn't be a problem
	alpha = .3
	
if (SHOW_HITBOXES)
{
	draw_set_color(c_red)
	draw_set_alpha(.8)
	draw_circle(x, y, PICKUP_DISTANCE, true)
	draw_set_alpha(1)
	draw_set_color(c_white)
}

var yOff = -20
var w = 100
var h = 40
var margin = 4

var left = x - w/2
var right = x + w/2
var top = y + yOff - h
var bott = y + yOff

draw_set_alpha(alpha)

draw_set_color(c_black)
draw_rectangle(left, top, right, bott, false)

var scale = .75
var textLineOff = 15 * scale
var yy = top + margin

if (myBuff.descriptionBuff != "default")
{
	draw_set_color(c_green)
	draw_text_transformed(left + margin, yy, myBuff.descriptionBuff, scale, scale, 0)
	yy += textLineOff
}
if (myBuff.descriptionDebuff != "default")
{
	draw_set_color(c_red)
	draw_text_transformed(left + margin, yy, myBuff.descriptionDebuff, scale, scale, 0)
	yy += textLineOff
}
if (myBuff.descriptionNeutralEffect != "default")
{
	draw_set_color(c_yellow)
	draw_text_transformed(left + margin, yy, myBuff.descriptionNeutralEffect, scale, scale, 0)
}

draw_set_color(c_white)
draw_set_alpha(1.)