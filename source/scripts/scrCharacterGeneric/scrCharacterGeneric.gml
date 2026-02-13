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
	enemyStartID /*dummy const*/, targetDummy, ghoster, meleeSlasher, fanner, dropper, enemyEndID /*dummy const*/,
	playerCleaner, cleanerEnemy, cleanerClone,
	
	escalatorDialogue,
}

enum CharacterState {
	Idle,
	Run,
	Harm,
	Dead
}

function CalculateKnockback(character, proj)
{
	// Overly complicated knockback calculation
	//	to avoid overstacking on knockback when hit
	//  by multiple projectiles
	var knockbackDir = proj.dir
	if (proj.projType == PROJECTILE_TYPE.explosion)
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
}

function HitFeedback(character, damageDealt)
{
	var charIsPlayer = character.object_index == oPlayer
	
	if (damageDealt > 0)
	{
		var damageNumber = instance_create_layer(character.x, character.y, "Instances", oDamageNumber)
		damageNumber.Init(damageDealt)
	}
	
	character.hitFlash()
	if (charIsPlayer)
		oCamera.currentShakeAmount += damageDealt * .7
}

function DealDamage(character, damageDealt, hitSoundGain=1)
{
	if (!instance_exists(character)) return
	var charIsPlayer = character.object_index == oPlayer
	var oldHp = character.hp
	
	character.hp -= damageDealt
	if (damageDealt > 0)
	{
		var hitSound = choose(sndHit_001, sndHit_002, sndHit_003, sndHit_004, sndHit_005)
		var gain = hitSoundGain*.8
		if (!charIsPlayer) gain *= .6
		var pitch = random_range(.7, 1.6)
		audio_play_sound(hitSound, 0, false, gain, 0, pitch)
		
		HitFeedback(character, damageDealt)
	}
	
	if (character.hp <= 0)
	{
		character.hp = 0
		if (room != rmLobby and room != rmDebug and room != rmBossFight and character.characterClass == CHARACTER_CLASS.enemy)
		{
			oRoomManager.currentRoom.KillEnemy(character);
		}
		else
		{
			if ((room != rmDebug or !charIsPlayer) and oldHp > 0)
				character.onDeathEvent()
		}
	}
}

function GetHit(character, proj)
{
	var charIsPlayer = character.object_index == oPlayer
	var oldHp = character.hp
	
	// Stat changes
	
	var damageDealt = proj.damage * proj.damageMultiplier * character.recDmgMult
	if (proj.objDealNoDamage) damageDealt = 0
	
	CalculateKnockback(character, proj)
	
	if (character.characterType == CHARACTER_TYPE.ghoster or character.characterType == CHARACTER_TYPE.cleanerEnemy)
		character.wantsToHide += damageDealt * .02
	
	// Add projectile effects
	//character.effects = array_union(character.effects, proj.effects)
	for (var i = 0; i < array_length(proj.effects); i++)
	{
		var newEffect = createEffect(proj.effects[i], proj)
		if (!newEffect.allowDuplicateApplication)
		{
			var alreadyApplied = false
			for (var j = 0; j < array_length(character.effects); j++)
				if (character.effects[j].effectType == newEffect.effectType)
				{
					character.effects[j].duration = character.effects[j].durationDef
					alreadyApplied = true
					break
				}
			
			if (!alreadyApplied) array_push(character.effects, newEffect)
		}
		else array_push(character.effects, newEffect)
	}
	
	// Deal damage and possibly kill
	DealDamage(character, damageDealt)
}
