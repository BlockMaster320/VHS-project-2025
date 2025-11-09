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

// Character code
event_inherited()
