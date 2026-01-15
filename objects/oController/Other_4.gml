global.tilemapCollision = layer_tilemap_get_id("TilesWall")

// Procedural pathfinding
wallGrid = undefined
pfGrid = undefined
if (instance_exists(oRoomManager))
	pfGrid = oRoomManager.pathfindingGrid
else if (room = rmDebug)
{
	wallGrid = getWallGrid(["TilesWall"])
	pfGrid = (!is_undefined(wallGrid)) 
		? getPathfindingGrid(wallGrid)
		: undefined
}