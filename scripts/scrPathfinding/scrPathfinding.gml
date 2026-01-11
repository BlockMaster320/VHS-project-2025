function pathfindingInit()
{
	FollowPathInit()
	
	pathTargetX = x
	pathTargetY = y
	currentFrame = 0
	pathUpdateModulo = 60
	updateModuloOffset = global.enemyMaxIndex++
}

// Pathfinding

function findNewPath()
{
	var pathFound = mp_grid_path(oController.pfGrid, myPath, x, y, pathTargetX, pathTargetY, true)
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
	return !collision_line(x, y, posX, posY, global.tilemapCollision, false, true)
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

function pathfindingStep()
{
	//if (mouse_check_button_pressed(mb_left))
	//{
	//	pathTargetX = mouse_x
	//	pathTargetY = mouse_y
	//	findNewPath()
	//}
	if ((currentFrame + updateModuloOffset) % pathUpdateModulo == 0)
	{
		findNewPath()
	}

	followPathStep()

	currentFrame++
}

function pathfindingDraw()
{
	followPathDraw()
}