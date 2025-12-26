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
for (var i = 0; i < inventorySize; i++)
	if (weaponInventory[i].active) weaponInventory[i].draw()
if (tempWeaponSlot.active) tempWeaponSlot.draw()


//draw_text(x, y - 20, $"Health: {hp}")