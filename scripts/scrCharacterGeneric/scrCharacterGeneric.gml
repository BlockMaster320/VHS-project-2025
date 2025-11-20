enum CHARACTER_CLASS
{
	player,
	NPC,
	enemy,
}

enum CHARACTER_TYPE
{
	player,
	student,
	mechanic, shopkeeper, passenger1,
	targetDummy, ghoster,
}

enum CharacterState {
	Idle,
	Run,
	Harm,
	Dead
}

function GetHit(character, proj)
{
	var damageDealt = proj.damage * proj.damageMultiplier
	
	character.hp -= damageDealt
	character.effects = array_union(character.effects, proj.effects)
	
	character.mhsp += lengthdir_x(proj.targetKnockback, proj.dir)
	character.mvsp += lengthdir_y(proj.targetKnockback, proj.dir)
	
	if (character.characterType == CHARACTER_TYPE.ghoster)
	{
		character.wantsToHide += damageDealt * .02
	}
	
	
	// Kill
	if (character.hp <= 0)
	{
		if (room != rmLobby and character.characterClass == CHARACTER_CLASS.enemy)
		{
			oRoomManager.currentRoom.KillEnemy(character);
		}
		else if (character.object_index == oPlayer) game_restart()	// TEMP
		else
		{
			instance_destroy(character)
		}
	}
}