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
	mechanic, shopkeeper, 
	passenger1, passenger2, passenger3,
	enemyStartID /*dummy const*/, targetDummy, ghoster, dropper, enemyEndID /*dummy const*/
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
	
	// Overly complicated knockback calculation
	//	to avoid overstacking on knockback when hit
	//  by multiple projectiles
	var knockbackDir = proj.dir
	if (proj.projectileType == PROJECTILE_TYPE.explosion)
		knockbackDir = point_direction(proj.x, proj.y, character.x, character.y)
	var mhsp = lengthdir_x(proj.targetKnockback, knockbackDir)
	var mvsp = lengthdir_y(proj.targetKnockback, knockbackDir)
	var velocity = sqrt(sqr(character.mhsp + mhsp) + sqr(character.mvsp + mvsp))
	if (velocity > proj.targetKnockback)
	{
		character.mhsp = max(abs(character.mhsp), abs(mhsp)) * sign(character.mhsp + mhsp)
		character.mvsp = max(abs(character.mvsp), abs(mvsp)) * sign(character.mvsp + mvsp)
	}
	else
	{
		character.mhsp += mhsp
		character.mvsp += mvsp 
	}
	
	
	if (character.characterType == CHARACTER_TYPE.ghoster)
	{
		character.wantsToHide += damageDealt * .02
	}
	
	// Iterate through applied effects
	// TODO..
	
	
	// Feedback
	if (damageDealt > 0)
	{
		var damageNumber = instance_create_layer(character.x, character.y, "Instances", oDamageNumber)
		damageNumber.Init(damageDealt)
	}
	
	character.hitFlash()
	if (charIsPlayer)
		oCamera.currentShakeAmount += damageDealt * .7
	
	
	// Kill
	if (character.hp <= 0)
	{
		if (room != rmLobby and room != rmDebug and character.characterClass == CHARACTER_CLASS.enemy)
		{
			oRoomManager.currentRoom.KillEnemy(character);
		}
		else if (charIsPlayer) game_restart()	// TEMP
		else
		{
			character.onDeathEvent()
		}
	}
}
