oPlayer.x = 775;
oPlayer.y = 850;

activated = false

cleanerEnemy = noone
clones = ds_list_create()

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

removeClones = function(){
	with (oEnemy) {
		var _index = ds_list_find_index(oBossFight.clones, id);
		if (_index != -1) {
			ds_list_delete(oBossFight.clones, _index)
			id.onDeathEvent()
		}
	}
}

deactivateCleaner = function(){
	if (cleanerEnemy != noone){
		instance_deactivate_object(oEnemy)
	}
}
