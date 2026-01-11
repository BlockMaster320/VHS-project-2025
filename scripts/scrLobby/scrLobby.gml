function getLobby() {
    if (!variable_global_exists("__lobby") || is_undefined(global.__lobby)) {
		if (room != rmLobby) error("Tried to create lobby structure outside of lobby room instanced.")
        global.__lobby = new Lobby()
    }
    return global.__lobby;
}

function Lobby() constructor {
	wallGrid = getWallGrid(["TilesWall"])
	pfGrid = (!is_undefined(wallGrid)) 
		? getPathfindingGrid(wallGrid)
		: undefined

	if (is_undefined(pfGrid)) 
		info("pfGrid for lobby is undefined!")
	else 
		debug("pfGrid for lobby has been defined")
	

	positions = {
		info_sign: {x: 256, y: 260},
		lobby_exit: {x: 580, y: 280},
		terminal: {x: 170, y: 400},
		platform_left: {x: 64, y: 160},
		platform_right: {x: 500, y: 160},
		dungeon_entry: {x: 408, y:130}
	}
}