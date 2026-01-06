enum CHARACTER_CLASS
{
	player,
	NPC,
	enemy,
}

enum CHARACTER_TYPE
{
	player, dummyPlayer,
	student,
	mechanic, shopkeeper, 
	passenger1, passenger2, passenger3,
	targetDummy, ghoster, dropper,
	playerCleaner
}

enum CharacterState {
	Idle,
	Run,
	Harm,
	Dead
}

function GetHit(character, proj)
{
	var charIsPlayer = character.object_index == oPlayer
	
	// Stat changes
	
	var damageDealt = proj.damage * proj.damageMultiplier
	
	character.hp -= damageDealt
	character.effects = array_union(character.effects, proj.effects)
	
	character.mhsp += lengthdir_x(proj.targetKnockback, proj.dir)
	character.mvsp += lengthdir_y(proj.targetKnockback, proj.dir)
	
	if (character.characterType == CHARACTER_TYPE.ghoster)
	{
		character.wantsToHide += damageDealt * .02
	}
	
	// Iterate through applied effects
	// TODO..
	
	
	// Feedback
	var damageNumber = instance_create_layer(character.x, character.y, "Instances", oDamageNumber)
	damageNumber.Init(damageDealt)
	
	character.hitFlash()
	if (charIsPlayer)
		oCamera.currentShakeAmount += damageDealt * .7
	
	
	// Kill
	if (character.hp <= 0)
	{
		if (room != rmLobby and character.characterClass == CHARACTER_CLASS.enemy)
		{
			oRoomManager.currentRoom.KillEnemy(character);
		}
		//else if (character.object_index == oPlayer) game_restart()	// TEMP
		else
		{
			character.onDeathEvent()
		}
	}
}
