switch (state){
	case BOSSFIGHT_STATE.entered:
		var NPCInRange = noone
		with(oPlayer){
			NPCInRange = instanceInRange(oNPC, INTERACTION_DISTANCE * 2)
		}
		if (NPCInRange != noone){
			state = BOSSFIGHT_STATE.startedTalking
			oDialogues.startDialogue(CHARACTER_TYPE.playerCleaner)
			
			revealSound = audio_play_sound(sndBigReveal, 0, false)
			oPlayer.showStats = false
		}
		break
		
	case BOSSFIGHT_STATE.startedTalking:
		if (global.inputState != INPUT_STATE.dialogue){
			state = BOSSFIGHT_STATE.fighting
			
			if (audio_is_playing(revealSound))
				audio_sound_gain(revealSound, 0, 1500)
			
			if (!audio_is_playing(oController.actionMusic)) oController.actionMusic = audio_play_sound(sndActionMusic, 0, true)
			audio_sound_gain(oController.actionMusic, actionMusicFightGain, 2000)
			
			instance_destroy(oNPC)
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
			audio_sound_gain(oController.actionMusic, 0, 2000)
			
			endgameScene.start()
		}
		
		break
		
	case BOSSFIGHT_STATE.defeated:
		break
	
}
