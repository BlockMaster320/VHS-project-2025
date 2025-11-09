//draw_sprite(sprite_index, 0, x, y)

//draw_sprite(sCursor, 0, mouse_x, mouse_y)
event_inherited();

if (SHOW_PATH_GRID)
{
	draw_set_alpha(.5)
	mp_grid_draw(oRoomManager.pathfindingGrid)
	draw_set_alpha(1)
}

// Draw current weapon
weaponInventory[activeInventorySlot].draw()
