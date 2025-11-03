function GetHit(character, projectile)
{
	character.hp -= projectile.damage * projectile.damageMultiplier
	character.effects = array_union(character.effects, projectile.effects)
}