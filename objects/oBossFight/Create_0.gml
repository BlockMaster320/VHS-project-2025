oPlayer.x = 775;
oPlayer.y = 850;

activated = false

cleanerEnemy = noone

bossRoomSequence = new TweenSequence([
	//new TweenDialogue(CHARACTER_TYPE.playerCleaner),
	new TweenAction(function() {
		instance_deactivate_object(oNPC)
		cleanerEnemy = instance_create_layer(768, 192, "Instances", oEnemy)
		with(cleanerEnemy) { characterCreate(CHARACTER_TYPE.cleanerEnemy); }
		
		var wallGrid = getWallGrid(["TilesWall"])
		oController.pfGrid = (!is_undefined(wallGrid)) 
			? getPathfindingGrid(wallGrid)
			: undefined
	})
])
