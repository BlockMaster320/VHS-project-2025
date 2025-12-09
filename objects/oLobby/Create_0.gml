wallGrid = getWallGrid(["TilesWall"])
pfGrid = (!is_undefined(wallGrid)) 
	? getPathfindingGrid(wallGrid)
	: undefined