function FollowPathInit()
{
	// Modifiable parameters
	myPath = path_add()
	myPathPoint = 0	// Index of the target point on my path
	followingPath = true
	
	// Internal
	reachedPathEnd = false
	targetPointX = x
	targetPointY = y
	#macro reachTargetMargin TILE_SIZE * .7
}

function followPathStep()
{
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
		var spd = min(walkSpd, targetPointDist)
	
		whsp = lengthdir_x(spd, targetPointDir)
		wvsp = lengthdir_y(spd, targetPointDir)
	}
}

function followPathDraw()
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