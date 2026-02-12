
if (room != rmBossFight)
{
// Inherit the parent event
event_inherited();

	imageIndex = (hasInteracted) ? imageIndex + 0.2 : 0;
	if (imageIndex > sprite_get_number(sPower) - 1)
		imageIndex = 1;
}	
	
	
draw_sprite(sPower, imageIndex, x, y);