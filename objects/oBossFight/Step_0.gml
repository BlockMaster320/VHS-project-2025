if (!talked){
	var NPCInRange = noone
	with(oPlayer){
		NPCInRange = instanceInRange(oNPC, INTERACTION_DISTANCE * 2)
		
		if (NPCInRange != noone){
			other.talked = true
			oDialogues.startDialogue(CHARACTER_TYPE.playerCleaner, function(){})
		}
	}
}
