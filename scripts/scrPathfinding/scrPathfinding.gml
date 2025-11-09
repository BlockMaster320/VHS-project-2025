function PathfindingInit()
{
	myPath = path_add()
	myPathPoint = 0	// Index of the target point on my path
	pathTargetX = x
	pathTargetY = y
	targetPointX = x
	targetPointY = y
	currentFrame = 0
	pathUpdateModulo = 50
	#macro reachTargetMargin TILE_SIZE * .7
}

// Pathfinding

function FindNewPath()
{
	var pathFound = mp_grid_path(oRoomManager.pathfindingGrid, myPath, x, y, pathTargetX, pathTargetY, true)
	if (pathFound)
	{
		myPathPoint = 0
		targetPointX = path_get_point_x(myPath, myPathPoint)
		targetPointY = path_get_point_y(myPath, myPathPoint)
	}
	else show_debug_message("Failed to find path!")
}

function LineOfSight(posX, posY)
{
	return !collision_line(x, y, posX, posY, oRoomManager.tileMapWall, false, true)
}

function PathfindingStep()
{
	if (mouse_check_button_pressed(mb_left))
	{
		pathTargetX = mouse_x
		pathTargetY = mouse_y
		FindNewPath()
	}
	else if (currentFrame % pathUpdateModulo == 0)
	{
		FindNewPath()
	}

	var targetPointDist = point_distance(x, y, targetPointX, targetPointY)

	if (targetPointDist < reachTargetMargin)
	{
		if (myPathPoint < path_get_number(myPath)-1)
		{
			myPathPoint++
			targetPointX = path_get_point_x(myPath, myPathPoint)
			targetPointY = path_get_point_y(myPath, myPathPoint)
			targetPointDist = point_distance(x, y, targetPointX, targetPointY)
		}
	}

	if (targetPointDist > reachTargetMargin)
	{
		//var targetVectorX = targetPointX - x
		//var targetVectorY = targetPointY - y
		var targetPointDir = point_direction(x, y, targetPointX, targetPointY)
		var spd = min(walkSpd, targetPointDist) * global.gameSpeed
	
		whsp = lengthdir_x(spd, targetPointDir)
		wvsp = lengthdir_y(spd, targetPointDir)
	}

	currentFrame++
}

function PathfindingDraw()
{
	if (PATH_DEBUG)
	{	
		if (path_exists(myPath))
			draw_path(myPath, 0, 0, true)
	}

	draw_circle(targetPointX, targetPointY, 3, false)

	var col = LineOfSight(oPlayer.x, oPlayer.y) ? c_green : c_red
	draw_set_color(col)
	draw_line(x, y, oPlayer.x, oPlayer.y)
	draw_set_color(c_white)
}