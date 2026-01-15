if (lifetime.value <= 0) instance_destroy()

alpha = lifetime.value / lifetime.valueDef

if (lifetime.valueDef - lifetime.value > 3)	// Freeze for a few frames for a hit effect
{
	vsp += grav * global.gameSpeed
	x += hsp * global.gameSpeed
	y += vsp * global.gameSpeed
}

lifetime.value -= global.gameSpeed