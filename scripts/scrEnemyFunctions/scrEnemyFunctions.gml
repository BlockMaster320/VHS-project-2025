function FindValidPathTarget(distRange, dirRange = new Range(0, 360), maxAttempts = 15, collMargin = 13)
{
	repeat (maxAttempts)	// Give up after a while, just to be safe
	{
		distRange.rndmize()
		dirRange.rndmize()
		pathTargetX = x + lengthdir_x(distRange.value, dirRange.value)
		pathTargetY = y + lengthdir_y(distRange.value, dirRange.value)
		if (instance_exists(oRoomManager))
		{
			pathTargetX = clamp(pathTargetX, oRoomManager.playerRoomXpx, oRoomManager.playerRoomXpx + ROOM_SIZE_PX)
			pathTargetY = clamp(pathTargetY, oRoomManager.playerRoomYpx, oRoomManager.playerRoomYpx + ROOM_SIZE_PX)
		}
		else
		{
			var searchRange = 150
			pathTargetX = clamp(pathTargetX, pathTargetX-searchRange, pathTargetX + searchRange)
			pathTargetY = clamp(pathTargetY, pathTargetY-searchRange, pathTargetY + searchRange)
		}
								
		if (!collisionMargin(pathTargetX, pathTargetY, collMargin) and findNewPath())
			return true
	}
	
	//show_debug_message($"Failed to find valid path after {maxAttempts} attempts")
	
	return false
}

function FindValidPathTargetReposition(distRange, shouldSeePlayer = true, dirRange = new Range(0, 360), maxAttempts = 20, collMargin = 13)
{
	var nearestTargetX = 0, nearestTargetY = 0, shortestPathDist = infinity
	var foundPath = false
	
	repeat (maxAttempts)	// Give up after a while, just to be safe
	{
		distRange.rndmize()
		dirRange.rndmize()
		pathTargetX = oPlayer.x + lengthdir_x(distRange.value, dirRange.value)
		pathTargetY = oPlayer.y + lengthdir_y(distRange.value, dirRange.value)
		
		if (instance_exists(oRoomManager))
		{
			pathTargetX = clamp(pathTargetX, oRoomManager.playerRoomXpx, oRoomManager.playerRoomXpx + ROOM_SIZE_PX)
			pathTargetY = clamp(pathTargetY, oRoomManager.playerRoomYpx, oRoomManager.playerRoomYpx + ROOM_SIZE_PX)
		}
		else
		{
			var searchRange = 150
			pathTargetX = clamp(pathTargetX, pathTargetX-searchRange, pathTargetX + searchRange)
			pathTargetY = clamp(pathTargetY, pathTargetY-searchRange, pathTargetY + searchRange)
		}

		var willSeePlayer = !collision_line(pathTargetX, pathTargetY, oPlayer.x, oPlayer.y, global.tilemapCollision, false, false)
		//var playerSight = LineOfSightObject(oPlayer, , pathTargetX, pathTargetY)

		if (!collisionMargin(pathTargetX, pathTargetY, collMargin) and
			((willSeePlayer and shouldSeePlayer) or (!willSeePlayer and !shouldSeePlayer)) and
			findNewPath())
		{
			var pathLen = path_get_length(myPath)
			if (pathLen < shortestPathDist)
			{
				shortestPathDist = pathLen
				nearestTargetX = pathTargetX
				nearestTargetY = pathTargetY
			}
			
			foundPath = true
			break
		}
	}
	
	if (foundPath)
	{
		pathTargetX = nearestTargetX
		pathTargetY = nearestTargetY
		findNewPath()
		return true
	}
	
	//show_debug_message($"Failed to find valid path after {maxAttempts} attempts")
	return false
}