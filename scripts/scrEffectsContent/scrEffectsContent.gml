enum EFFECT
{
	fanAreaDmg,
	
	length
}

function createEffect(effectType_, source_=noone)
{
	var newEffect = new Effect()
	
	with (newEffect)
	{
		effectType = effectType_
		source = source_
		
		switch (effectType)
		{
			case EFFECT.fanAreaDmg:
				
				if (source == noone)
				{
					show_debug_message("EffectCreate -> fanAreaDmg effect: source of the effect (projectile) is undefined!")
					break
				}
				
				// The projectile will likely be destroyed, save important variables
				attackSpeed = source.attackSpeed
				damage = source.damage
				damageMultiplier = source.damageMultiplier
				
				applyDurDef = 1 / attackSpeed
				durationDef = applyDurDef
				duration = durationDef
				
				applyEffect = function(character)
				{
					duration -= 1/60 * global.gameSpeed
					if (applyCounter <= .0001)
					{
						DealDamage(character, damage*damageMultiplier)
						applyCounter = applyDurDef
					}
					else applyCounter -= 1/60 * global.gameSpeed
				}
				
				break
		}
	}
	
	return newEffect
}