enum CHARACTER_CLASS
{
	player,
	NPC,
	enemy,
}

enum CHARACTER_TYPE
{
	player,
	mechanic,
	shopkeeper,
	passenger1,
	ghoster,
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
		character.wantsToHide += damageDealt * .03
	}
	
	if (character.hp <= 0) {
		if (character.characterClass == CHARACTER_CLASS.enemy) {
			oRoomManager.currentRoom.KillEnemy(character);
		}
		else
			instance_destroy(character)
	}
}