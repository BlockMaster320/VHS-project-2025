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
	followingPath = true
	reachedPathEnd = false
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
		followingPath = true
		return true
	}
	
	show_debug_message("Failed to find path!")
	return false
}

function LineOfSightPoint(posX, posY)
{
	return !collision_line(x, y, posX, posY, oRoomManager.tileMapWall, false, true)
}

function LineOfSightObject(object, angleDiff = 6, originX = x, originY = y)
{
	//var objDist = point_distance(originX, originY, object.x, object.y)
	var objDir = point_direction(originX, originY, object.x, object.y)
	var xx1 = originX + lengthdir_x(30, objDir - angleDiff)
	var yy1 = originY + lengthdir_y(30, objDir - angleDiff)
	var xx2 = originX + lengthdir_x(30, objDir + angleDiff)
	var yy2 = originY + lengthdir_y(30, objDir + angleDiff)
	return LineOfSightPoint(object.x, object.y) and LineOfSightPoint(xx1, yy1) and LineOfSightPoint(xx2, yy2)
}

function PathfindingStep()
{
	//if (mouse_check_button_pressed(mb_left))
	//{
	//	pathTargetX = mouse_x
	//	pathTargetY = mouse_y
	//	FindNewPath()
	//}
	if (currentFrame % pathUpdateModulo == 0)
	{
		FindNewPath()
	}

	var targetPointDist = point_distance(x, y, targetPointX, targetPointY)

	if (targetPointDist < reachTargetMargin)
	{
		if (followingPath and myPathPoint < path_get_number(myPath)-1)
		{
			myPathPoint++
			targetPointX = path_get_point_x(myPath, myPathPoint)
			targetPointY = path_get_point_y(myPath, myPathPoint)
			targetPointDist = point_distance(x, y, targetPointX, targetPointY)
		}
		else reachedPathEnd = true
	}

	if (followingPath and targetPointDist >= reachTargetMargin)
	{
		reachedPathEnd = false
		
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
			
		var col = reachedPathEnd ? c_green : c_white
		draw_set_color(col)
		draw_circle(targetPointX, targetPointY, 3, false)
		draw_set_color(c_white)

	}
}