if (!activated){
	var NPCInRange = noone
	with(oPlayer){
		NPCInRange = instanceInRange(oNPC, INTERACTION_DISTANCE * 2)
	}
	if (NPCInRange != noone){
		bossRoomSequence.start()
		activated = true
	}
}
