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
					show_debug_message("EffectCreate -> fanAreaDmg effect: source of the effect (weapon) is undefined!")
					break
				}
				
				applyDurDef = .3
				durationDef = .3
				duration = durationDef
				
				applyEffect = function(character)
				{
					duration -= 1/60 * global.gameSpeed * source.attackSpeed
					if (applyCounter <= .0001)
					{
						DealDamage(character, source.damage*source.damageMultiplier)
						applyCounter = applyDurDef
					}
					else applyCounter -= 1/60 * global.gameSpeed * source.attackSpeed
				}
				
				break
		}
	}
	
	return newEffect
}