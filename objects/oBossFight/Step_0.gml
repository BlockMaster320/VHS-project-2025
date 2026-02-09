switch (state){
	case BOSSFIGHT_STATE.entered:
		var NPCInRange = noone
		with(oPlayer){
			NPCInRange = instanceInRange(oNPC, INTERACTION_DISTANCE * 2)
		}
		if (NPCInRange != noone){
			state = BOSSFIGHT_STATE.startedTalking
			oDialogues.startDialogue(CHARACTER_TYPE.playerCleaner)
		}
		break
		
	case BOSSFIGHT_STATE.startedTalking:
		if (global.inputState != INPUT_STATE.dialogue){
			state = BOSSFIGHT_STATE.fighting
			
			instance_deactivate_object(oNPC)
			cleanerEnemy = instance_create_layer(768, 192, "Instances", oEnemy)
			with(cleanerEnemy) { characterCreate(CHARACTER_TYPE.cleanerEnemy); }
		
			var wallGrid = getWallGrid(["TilesWall"])
			oController.pfGrid = (!is_undefined(wallGrid)) 
				? getPathfindingGrid(wallGrid)
				: undefined
		}
		break
		
	case BOSSFIGHT_STATE.fighting:
		if (cleanerEnemy == noone){
			state = BOSSFIGHT_STATE.defeated
			instance_activate_object(oNPC)
			oDialogues.startDialogue(CHARACTER_TYPE.playerCleaner)
		}
		break
		
	case BOSSFIGHT_STATE.defeated:
		if (global.inputState != INPUT_STATE.dialogue){
			RoomTransition(rmLobby)
		}
		break
	
}
