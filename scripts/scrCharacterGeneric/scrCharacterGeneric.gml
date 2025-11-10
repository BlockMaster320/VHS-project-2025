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

function GetHit(character, projectileInstance)
{
	var projectileData = projectileInstance.projectile
	
	character.hp -= projectileData.damage * projectileData.damageMultiplier
	character.effects = array_union(character.effects, projectileData.effects)
	
	character.mhsp += lengthdir_x(projectileData.targetKnockback, projectileInstance.dir)
	character.mvsp += lengthdir_y(projectileData.targetKnockback, projectileInstance.dir)
	
	if (character.hp <= 0) instance_destroy(character)
}