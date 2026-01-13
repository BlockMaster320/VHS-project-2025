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
	blast, precision, rapidFire, cloner, meleeKnockback, noKnockback, sonicSpeed, aderral,
	inventorySizeIncrease, fatBullets, hotReload,
	commonIndex,	// Dummy buff for rarity indexing

	// Rare
	dualWield, doubleBuff,
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
							 new Range(1.5, 2) ]	// - accuracy
		
				buffRandomize = function()
				{		
					descriptionBuff = $"{round(newStats[0].value*100)}% attack speed"
					descriptionDebuff = $"{toPercent(1/newStats[1].value)}% accuracy"
				}
		
				weaponBuffApply = function(weapon)
				{
					weapon.attackSpeed *= newStats[0].value
					weapon.spread *= newStats[1].value
				}
			
				break
				
	
			case BUFF.cloner:

				rarity = RARITY.common
				projAmountMultRange = new Range(2, 4)
				spreadMultRange = new Range(2, 3)
		
				buffRandomize = function()
				{
					projAmountMultRange.rndmizeInt()
					spreadMultRange.rndmize()
					descriptionBuff = $"{projAmountMultRange.value}x projectile amount"
					descriptionDebuff = $"{toPercent(1/spreadMultRange.value)}% accuracy"
				}
		
				weaponBuffApply = function(weapon)
				{
					weapon.projectileAmount *= projAmountMultRange.value
					weapon.spread *= spreadMultRange.value
				}
				
				break
				
				
			case BUFF.meleeKnockback:
			
				rarity = RARITY.common
				
				// + melee knockback (flat)
				// negative ranged knockback ??
				
				buffRandomize = function()
				{		
					descriptionNeutralEffect = $"Big melee knockback"
				}
		
				projectileBuffApply = function(proj)
				{	
					if (proj.projType == PROJECTILE_TYPE.melee)
						proj.targetKnockback += 40
				}
				
				break
				
				
			case BUFF.noKnockback:
			
				rarity = RARITY.common
				
				// no knockback
				
				buffRandomize = function()
				{		
					descriptionNeutralEffect = $"No knockback"
				}
		
				projectileBuffApply = function(proj)
				{	
					proj.targetKnockback = 0
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
				
				
			case BUFF.aderral:
		
				rarity = RARITY.common
							
				newStats = [ new Range(30, 30),		// + flat damage
							 new Range(1.2, 1.2) ]	// + game speed
		
				buffRandomize = function()
				{
					descriptionBuff = $"+{newStats[0].value} flat damage"
					descriptionDebuff = $"{toPercent(newStats[1].value)}% game speed"
				}
				
				projectileBuffApply = function(proj)
				{
					proj.damage += newStats[0].value
				}
		
				characterBuffApply = function(character)
				{
					global.gameSpeed *= newStats[1].value
					with (character)
					{
						walkSpdDef *= 1/other.newStats[1].value
						walkSpdSprint *= 1/other.newStats[1].value
					}
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
				
				
			case BUFF.fatBullets:
			
				rarity = RARITY.common
				
				newStats = [ new Range(1.4, 1.6),	// + projectile scale
							 new Range(.6, .7) ]	// - bullet speed
				
				
				buffRandomize = function()
				{		
					descriptionBuff = $"{toPercent(newStats[0].value)}% projectile scale"
					descriptionDebuff = $"{toPercent(newStats[1].value)}% projectile speed"
				}
		
				projectileBuffApply = function(proj)
				{	
					proj.scale *= newStats[0].value
					proj.projectileSpeed *= newStats[1].value
				}
				
				break
				
				
			case BUFF.hotReload:
			
				rarity = RARITY.common
				
				newStats = [ new Range(.2, .3),		// - reload time
							 new Range(1.3, 1.4) ]	// + spread
				
				
				buffRandomize = function()
				{		
					descriptionBuff = $"{toPercent(newStats[0].value)}% reload time"
					descriptionDebuff = $"{toPercent(1/newStats[1].value)}% accuracy"
				}
				
				weaponBuffApply = function(weapon)
				{
					weapon.reloadTime *= newStats[0].value
					weapon.spread *= newStats[1].value
				}
				
				break
			
	
			// RARE ---------------------------------------------------------------
	
			case BUFF.dualWield:

				rarity = RARITY.rare
		
				buffRandomize = function()
				{
					descriptionNeutralEffect = $"DUAL WIELD"
				}
		
				characterBuffApply = function(player)
				{
					player.dualWield = true
				}
				
				break
				
				
			case BUFF.doubleBuff:

				rarity = RARITY.rare
		
				buffRandomize = function()
				{
					descriptionNeutralEffect = $"DOUBLE ALL EFFECTS"
				}
		
				characterBuffApply = function(player)
				{
					player.buffApplyAmount++	// Do not multiply this, this is already exponential!
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