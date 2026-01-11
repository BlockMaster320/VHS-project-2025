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
	blast, precision, rapidFire, cloner, meleeKnockback, sonicSpeed,
	inventorySizeIncrease,
	commonIndex,	// Dummy buff for rarity indexing

	// Rare
	dualWield,
	rareIndex,	// Dummy buff for rarity indexing
	
	// --------------
	length
}

function toPercent(val)
{
	return round(val*100)
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
					descriptionBuff = $"{round(dmgMultRange.value*100)}% damage"
					descriptionDebuff = $"{round(attackSpdMultRange.value*100)}% attack speed"
				}
				
				weaponBuffApply = function(weapon)
				{
					weapon.attackSpeed *= attackSpdMultRange.value
				}
		
				projectileBuffApply = function(proj)
				{
					proj.damageMultiplier *= dmgMultRange.value
				}
			
				break
				
				
			case BUFF.precision:
			
				rarity = RARITY.common
							
				newStats = [ new Range(.1, .15),		// - spread %
							 new Range(.7, .8) ]	// - attack speed %
		
				buffRandomize = function()
				{		
					descriptionBuff = $"{round(newStats[0].value*100)}% spread"
					descriptionDebuff = $"{round(newStats[1].value*100)}% attack speed"
				}
		
				weaponBuffApply = function(weapon)
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
		
				weaponBuffApply = function(weapon)
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
		
				weaponBuffApply = function(weapon)
				{
					weapon.projectileAmount *= projAmountMultRange.value
					weapon.spread += spreadMultRange.value
				}
				
				break
				
				
			case BUFF.meleeKnockback:
			
				rarity = RARITY.common
				
				// + melee knockback (flat)
				// negative ranged knockback
				
				buffRandomize = function()
				{		
					descriptionNeutralEffect = $"Big melee knockback"
				}
		
				projectileBuffApply = function(proj)
				{	
					if (proj.projectileType == PROJECTILE_TYPE.melee)
						proj.targetKnockback += 40
				}
				
				break
				
				
			case BUFF.sonicSpeed:	// + speed (flat)
		
				rarity = RARITY.common
							
				target = BUFF_TARGET.player
		
				buffRandomize = function()
				{
					descriptionNeutralEffect = $"Load of\nmovement speed"
				}
		
				characterBuffApply = function(character)
				{
					character.walkSpdDef += 1.5
					character.walkSpdSprint += 1.5
				}
			
				break
				
				
			case BUFF.inventorySizeIncrease:	// + inventory slot
		
				rarity = RARITY.common
							
				target = BUFF_TARGET.player
		
				buffRandomize = function()
				{
					descriptionNeutralEffect = $"+1 inventory slot"
				}
		
				characterBuffApply = function(player)
				{
					with (player)
					{
						inventorySize++
						if (array_length(weaponInventory) < inventorySize)
							weaponInventory[inventorySize-1] = acquireWeapon(WEAPON.fists, id)
					}
				}
			
				break
			
	
			// RARE ---------------------------------------------------------------
	
			case BUFF.dualWield:

				rarity = RARITY.rare
				dmgMultRange = new Range(10, 15)
		
				buffRandomize = function()
				{
					dmgMultRange.rndmize()
					descriptionNeutralEffect = $"DUAL WIELD"
				}
		
				characterBuffApply = function(player)
				{
					player.dualWield = true
				}
				
				break
				
			
			default:
				show_debug_message("Unable to create a buff. Unknown buff type!")
				with (other) instance_destroy()
				break
		}
	}
	
	return newBuff
}