enum RARITY
{
	common, rare, length
}

enum BUFF_TARGET
{
	weapon, player
}

enum BUFF
{
	// Common
	blast, precision, rapidFire, cloner, tacticalKnockback, sonicSpeed,
	commonIndex,	// Dummy buff for rarity indexing

	// Rare
	testRare,
	rareIndex,	// Dummy buff for rarity indexing
	
	// --------------
	length
}

function BuffCreate(buffType_)
{
	// Content --------------------------------------------------
	
	
	var newBuff = new Buff()
	
	with (newBuff)
	{
		buffType = buffType_
		
		switch (buffType)
		{
			// COMMON ----------------------------------------------------
			
			case BUFF.blast:
			
				rarity = RARITY.common
				dmgMultRange = new Range(1.5, 2.5)
				attackSpdMultRange = new Range(.4, .6)
		
				buffRandomize = function()
				{
					dmgMultRange.rndmize()
					attackSpdMultRange.rndmize()
					descriptionBuff = $"{dmgMultRange.value*100}% damage"
					descriptionDebuff = $"{attackSpdMultRange.value*100}% attack speed"
				}
		
				buffApply = function(weapon)
				{
					weapon.projectile.damageMultiplier = dmgMultRange.value
					weapon.attackSpeed *= attackSpdMultRange.value
				}
			
				break
				
				
			case BUFF.precision:
			
				rarity = RARITY.common
							
				newStats = [ new Range(.25, .4),		// - spread %
							 new Range(.7, .8) ]	// - attack speed %
		
				buffRandomize = function()
				{		
					descriptionBuff = $"{round(newStats[0].value*100)}% spread"
					descriptionDebuff = $"{round(newStats[1].value*100)}% attack speed"
				}
		
				buffApply = function(weapon)
				{
					weapon.spread *= newStats[0].value
					weapon.attackSpeed *= newStats[1].value
				}
			
				break
				
				
			case BUFF.rapidFire:
			
				rarity = RARITY.common
							
				newStats = [ new Range(1.5, 2.5),		// + attack speed %
							 new Range(40, 60) ]	// - accuracy
		
				buffRandomize = function()
				{		
					descriptionBuff = $"{round(newStats[0].value*100)}% attack speed"
					descriptionDebuff = $"{round(spreadToAccuracy(newStats[1].value)*100)}% accuracy"
				}
		
				buffApply = function(weapon)
				{
					weapon.attackSpeed *= newStats[0].value
					weapon.spread += newStats[1].value
				}
			
				break
				
	
			case BUFF.cloner:

				rarity = RARITY.common
				projAmountMultRange = new Range(2, 4)
				spreadMultRange = new Range(40, 60)
		
				buffRandomize = function()
				{
					projAmountMultRange.rndmizeInt()
					spreadMultRange.rndmize()
					descriptionBuff = $"{projAmountMultRange.value}x projectile amount"
					descriptionDebuff = $"{round(spreadToAccuracy(spreadMultRange.value)*100)}% accuracy"
				}
		
				buffApply = function(weapon)
				{
					weapon.projectileAmount *= projAmountMultRange.value
					weapon.spread += spreadMultRange.value
				}
				
				break
				
				
			case BUFF.tacticalKnockback:
			
				rarity = RARITY.common
				
				// + melee knockback (flat)
				// 0 ranged knockback
				
				buffRandomize = function()
				{		
					descriptionNeutralEffect = $"+ melee knockback\n0 ranged knockback"
				}
		
				buffApply = function(weapon)
				{
					if (weapon.projectile.projectileType == PROJECTILE_TYPE.ranged)
						weapon.projectile.targetKnockback = 0
					else
						weapon.projectile.targetKnockback += 40
				}
				
				break
				
				
			case BUFF.sonicSpeed:	// + speed (flat)
		
				rarity = RARITY.common
							
				target = BUFF_TARGET.player
		
				buffRandomize = function()
				{
					descriptionNeutralEffect = $"Load of movement speed"
				}
		
				buffApply = function(weapon)
				{
					oPlayer.walkSpdDef += 2
					oPlayer.walkSpdSprint += 2
				}
			
				break
			
	
			// RARE ---------------------------------------------------------------
	
			case BUFF.testRare:

				rarity = RARITY.rare
				dmgMultRange = new Range(10, 15)
		
				buffRandomize = function()
				{
					dmgMultRange.rndmize()
					descriptionBuff = $"deal {dmgMultRange.value}% damage"
					descriptionDebuff = $"Amogus"
				}
		
				buffApply = function(weapon)
				{
					weapon.projectile.damageMultiplier = dmgMultRange.value
				}
				
				break
				
			
			default:
				show_debug_message("Unable to create a buff. Unknown buff type!")
				break
		}
	}
	
	return newBuff
}