//draw_sprite(sprite_index, 0, x, y)

//draw_sprite(sCursor, 0, mouse_x, mouse_y)
event_inherited();

if (SHOW_PATH_GRID)
{
	draw_set_alpha(.5)
	if (instance_exists(oRoomManager)) // This check has to be here
		mp_grid_draw(oRoomManager.pathfindingGrid)
	draw_set_alpha(1)
}

// Draw current weapon
var activeWeapon = -1

for (var i = 0; i < inventorySize; i++)
	if (weaponInventory[i].active)
	{
		weaponInventory[i].draw(weaponAlpha)
		activeWeapon = weaponInventory[i]
	}
if (tempWeaponSlot.active) tempWeaponSlot.draw()


//draw_text(x, y - 20, $"Health: {hp}")

// Reload / cooldown state
if (activeWeapon != -1 and
	( (activeWeapon.projectile.projectileType == PROJECTILE_TYPE.ranged and activeWeapon.reloading) or
	  (activeWeapon.projectile.projectileType == PROJECTILE_TYPE.melee and activeWeapon.primaryActionCooldown >= 0)
	))
{
	var w = .1
	var yOff = 13

	var left = x - 10
	var right = x + 10
	var top = y + yOff
	var bott = y + yOff + w

	draw_rectangle(left, top, right, bott, false)

	var reloadFac = activeWeapon.primaryActionCooldown / (60 / activeWeapon.attackSpeed)
	var sliderX = lerp(right, left, reloadFac)
	var h = 4
	
	draw_rectangle(sliderX - w/2, top - h/2, sliderX + w/2, bott + h/2, false)
}


// UI -----------------------------------

surface_set_target(oController.guiSurf)

var margin = 2 * TILE_SIZE
var size = 1.3 * TILE_SIZE

draw_set_color(c_dkgray)
draw_set_alpha(.6)

var rightX = cameraW - margin
var bottomY = cameraH - margin
var center = size/2
draw_rectangle(rightX - size*inventorySize, bottomY - size, rightX, bottomY, false)

draw_set_alpha(1)
draw_set_color(c_white)

for (var i = 0; i < inventorySize; i++)
{
	var xx = rightX - (size * (inventorySize-1 - i)) - center
	var yy = bottomY - center
	
	draw_sprite_ext(weaponInventory[i].sprite, 0, xx, yy, 1, 1, 0, c_white, 1)
	
	if (activeInventorySlot == i)
		draw_rectangle(xx - center, yy - center, xx + center, yy + center, true)
}

surface_reset_target()