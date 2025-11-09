event_inherited()

draw_set_alpha(.5)
mp_grid_draw(oRoomManager.pathfindingGrid)
draw_set_alpha(1)

if (path_exists(myPath))
	draw_path(myPath, 0, 0, true)
	
draw_circle(targetPointX, targetPointY, 3, false)

controller.draw()