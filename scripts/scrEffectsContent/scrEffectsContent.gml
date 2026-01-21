enum EFFECT
{
	fanAreaDmg, burn,
	
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
				attackSpeed = source.srcWeapon.attackSpeed
				damage = source.damage
				damageMultiplier = source.damageMultiplier
				projectileAmount = source.srcWeapon.projectileAmount
				
				durationDef = 1 / attackSpeed
				duration = durationDef
				applyDurDef = durationDef - .01

				
				applyEffect = function(character)
				{
					duration -= 1/60 * global.gameSpeed
					if (applyCounter <= .00001)
					{
						DealDamage(character, damage*damageMultiplier*projectileAmount)
						applyCounter = applyDurDef
					}
					else applyCounter -= 1/60 * global.gameSpeed
				}
				
				break
				
			case EFFECT.burn:
				
				if (source == noone)
				{
					show_debug_message("EffectCreate -> burn effect: source of the effect (projectile) is undefined!")
					break
				}

				// The projectile will likely be destroyed, save important variables
				var stackAmount = 0
				for (var i = 0; i < array_length(source.effects); i++)
					if (source.effects[i] == EFFECT.burn) stackAmount++
					
				applyDurDef = .5 / stackAmount
				durationDef = 6
				duration = durationDef
				
				applyEffect = function(character)
				{
					duration -= 1/60 * global.gameSpeed
					if (applyCounter <= .00001)
					{
						DealDamage(character, 5, .3)
						applyCounter = applyDurDef
					}
					else applyCounter -= 1/60 * global.gameSpeed
				}
				
				break
		}
	}
	
	return newEffect
}