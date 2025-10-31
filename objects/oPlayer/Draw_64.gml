var margin = 50
var size = 80

draw_set_color(c_dkgray)
draw_set_alpha(.6)

var rightX = guiW - margin
var bottomY = guiH - margin
var center = size/2
draw_rectangle(rightX - size*INVENTORY_SIZE, bottomY - size, rightX, bottomY, false)

draw_set_alpha(1)
draw_set_color(c_white)

for (var i = 0; i < INVENTORY_SIZE; i++)
{
	var xx = rightX - (size * (INVENTORY_SIZE-1 - i)) - center
	var yy = bottomY - center
	
	draw_sprite_ext(weaponInventory[i].sprite, 0, xx, yy, windowToGui, windowToGui, 0, c_white, 1)
	
	if (activeWeaponSlot == i)
		draw_rectangle(xx - center, yy - center, xx + center, yy + center, true)
}