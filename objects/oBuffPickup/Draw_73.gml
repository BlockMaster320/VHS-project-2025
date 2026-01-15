// Show buff description

var alpha = 1

if (!instanceInRange(oPlayer, PICKUP_DISTANCE)) // Suboptimal performance but shouldn't be a problem
	alpha = 0.7
	
if (global.SHOW_HITBOXES)
{
	draw_set_color(c_red)
	draw_set_alpha(.8)
	draw_circle(x, y, PICKUP_DISTANCE, true)
	draw_set_alpha(1)
	draw_set_color(c_white)
}

//var scale = .5
var scale = round(.5 * oController.upscaleMult) / oController.upscaleMult
//var rowAmount = (myBuff.descriptionBuff != "default") + (myBuff.descriptionDebuff != "default") + (myBuff.descriptionNeutralEffect != "default")

var rowAmount = 3
var margin = 4
var yOff = -20
var w = 150 * scale
var h = 9 * rowAmount * scale + margin*2

var left = x - w/2
var right = x + w/2
var top = y + yOff - h
var bott = y + yOff
var centerX = x

draw_set_alpha(alpha)

draw_set_color(c_black)
draw_rectangle(left, top, right, bott, false)

var textLineOff = 15 * scale
var yy = top + margin

centerX = roundPixelPos(centerX)
yy = roundPixelPos(yy)

draw_set_halign(fa_center)

if (myBuff.descriptionBuff != "default")
{
	draw_set_color(c_green)
	draw_text_transformed(centerX, yy, myBuff.descriptionBuff, scale, scale, 0)
	yy += textLineOff
}
if (myBuff.descriptionDebuff != "default")
{
	draw_set_color(c_red)
	draw_text_transformed(centerX, yy, myBuff.descriptionDebuff, scale, scale, 0)
	yy += textLineOff
}
if (myBuff.descriptionNeutralEffect != "default")
{
	draw_set_color(c_yellow)
	draw_text_transformed(centerX, yy, myBuff.descriptionNeutralEffect, scale, scale, 0)
}

draw_set_halign(fa_left)

draw_set_color(c_white)
draw_set_alpha(1.)