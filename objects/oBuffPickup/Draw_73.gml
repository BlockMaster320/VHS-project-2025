// Show buff description

var alpha = 1

if (!place_meeting(x, y, oPlayer)) // Suboptimal performance but shouldn't be a problem
	alpha = .3
	

var yOff = -20
var w = 120
var h = 70
var margin = 4

var left = x - w/2
var right = x + w/2
var top = y + yOff - h
var bott = y + yOff

draw_set_alpha(alpha)

draw_set_color(c_black)
draw_rectangle(left, top, right, bott, false)

draw_set_color(c_white)
draw_text(left + margin, top + margin, myBuff.descriptionBuff)
draw_text(left + margin, top + margin + 20, myBuff.descriptionDebuff)

draw_set_alpha(1.)