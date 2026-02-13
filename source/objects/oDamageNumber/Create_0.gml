amount = 0
lifetime = 0
scale = 0
color = 0
alpha = 1

function Init(amount_, color_ = c_red)
{
	amount = amount_
	color = color_
	
	vsp = -5 / (.003 * amount + 1)
	hsp = random_range(-2, 2)
	
	grav = .3 / (.003 * amount + 1)
	lifetime = new Cooldown(.01 * amount + 20)
	scale = .02 * amount + .6
	
	y -= 16
}