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
	blast, precision, rapidFire, cloner, sonicSpeed, aderral,
	inventorySizeIncrease, fatBullets, hotReload, burn,
	commonIndex,	// Dummy buff for rarity indexing

	// Rare
	dualWield, doubleBuff,
	rareIndex,	// Dummy buff for rarity indexing
	
	// --------------
	length,
	
	meleeKnockback, noKnockback	// Unused for now
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
				dmgMultRange = new Range(2, 2)
				attackSpdMultRange = new Range(.7, .8)
		
				dmgMultRange.rndmize()
				attackSpdMultRange.rndmize()
				descriptionBuff = $"{round(dmgMultRange.value*100)}% damage"
				descriptionDebuff = $"-1 inventory slot\n{round(attackSpdMultRange.value*100)}% attack speed"
				
				weaponBuffApply = function(weapon)
				{
					weapon.attackSpeed *= attackSpdMultRange.value
				}
		
				projectileBuffApply = function(proj)
				{
					proj.damageMultiplier *= dmgMultRange.value
				}
				
				characterBuffApply = function(player)
				{
					var prevSize = player.inventorySize
					if (prevSize > 0)
					{
						player.inventorySize--
						if (player.activeInventorySlot == prevSize-1)
							player.SwapSlot(player.inventorySize-1)
					}
				}
				
				break
				
				
			case BUFF.precision:
			
				rarity = RARITY.common
							
				newStats = [ new Range(.1, .15),	// - spread %
							 new Range(.7, .8) ]	// - attack speed %
		
				descriptionBuff = $"{toPercent(1/newStats[0].value)}% accuracy"
				descriptionDebuff = $"{toPercent(newStats[1].value)}% bullet size"
		
				weaponBuffApply = function(weapon)
				{
					weapon.spread *= newStats[0].value
				}
				
				projectileBuffApply = function(proj)
				{
					if (proj.projType == PROJECTILE_TYPE.ranged)
						proj.scale *= newStats[1].value
				}
			
				break
				
				
			case BUFF.rapidFire:
			
				rarity = RARITY.common
							
				newStats = [ new Range(2.5, 3),		// + attack speed %
							 new Range(2.5, 3.) ]	// - accuracy
		
				descriptionBuff = $"{round(newStats[0].value*100)}% attack speed"
				descriptionDebuff = $"{toPercent(1/newStats[1].value)}% accuracy"
		
				weaponBuffApply = function(weapon)
				{
					weapon.attackSpeed *= newStats[0].value
					weapon.spread *= newStats[1].value
				}
			
				break
				
	
			case BUFF.cloner:
				
				rarity = RARITY.common
				
				newStats = [ new iRange(2, 2), 		// + projectile amount
							 new Range(1.5, 2.),	// - more spread
							 new Range(.7, .7) ]	// - less % dmg
												
				descriptionBuff = $"{newStats[0].value}x projectile amount"
				descriptionDebuff = $"{toPercent(newStats[2].value)}% damage\n{toPercent(1/newStats[1].value)}% accuracy"
				
				weaponBuffApply = function(weapon)
				{
					weapon.projectileAmount *= newStats[0].value
					weapon.spread *= newStats[1].value
				}
				
				projectileBuffApply = function(proj)
				{
					proj.damageMultiplier *= newStats[2].value
				}
				
				break
				
				
			case BUFF.meleeKnockback:
			
				rarity = RARITY.common
				
				// + melee knockback (flat)
				// negative ranged knockback ??
				
				descriptionNeutralEffect = $"Big melee knockback"
		
				projectileBuffApply = function(proj)
				{	
					if (proj.projType == PROJECTILE_TYPE.melee)
						proj.targetKnockback += 40
				}
				
				break
				
				
			case BUFF.noKnockback:
			
				rarity = RARITY.common
				
				// no knockback
				
				descriptionNeutralEffect = $"No knockback"
		
				projectileBuffApply = function(proj)
				{	
					proj.targetKnockback = 0
				}
				
				break
				
				
			case BUFF.sonicSpeed:	// + speed (flat)
		
				rarity = RARITY.common
							
				target = BUFF_TARGET.player
		
				descriptionNeutralEffect = $"Load of\nmovement speed"
		
				characterBuffApply = function(character)
				{
					character.walkSpdDef += 1.5
					character.walkSpdSprint += 1.5
				}
			
				break
				
				
			case BUFF.aderral:
		
				rarity = RARITY.common
							
				newStats = [ new Range(30, 30),		// + flat damage
							 new Range(1.4, 1.4) ]	// + game speed
		
				descriptionBuff = $"+{newStats[0].value} damage flat"
				descriptionDebuff = $"{toPercent(newStats[1].value)}% game speed"	
				
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
		
				descriptionNeutralEffect = $"+1 inventory slot"
		
				characterBuffApply = function(player)
				{
					with (player)
					{
						inventorySize++
						if (array_length(weaponInventory) < inventorySize)
						{
							weaponInventory[inventorySize-1] = acquireWeapon(WEAPON.fists, id, false)
						}
						if (inventorySize == 1) weaponInventory[activeInventorySlot].active = true
					}
				}
			
				break
				
				
			case BUFF.fatBullets:
			
				rarity = RARITY.common
				
				newStats = [ new Range(1.4, 1.6),	// + projectile scale
							 new Range(.6, .7) ]	// - bullet speed
				
				descriptionBuff = $"{toPercent(newStats[0].value)}% projectile scale"
				descriptionDebuff = $"{toPercent(newStats[1].value)}% projectile speed"
		
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
				
				descriptionBuff = $"{toPercent(newStats[0].value)}% reload time"
				descriptionDebuff = $"{toPercent(1/newStats[1].value)}% accuracy"
				
				weaponBuffApply = function(weapon)
				{
					weapon.reloadTime *= newStats[0].value
					weapon.spread *= newStats[1].value
				}
				
				break
				
				
			case BUFF.burn:
			
				rarity = RARITY.common
				
				newStats = [ new Range(.7,.8) ]		// + burn
							 						// - % damage
				
				descriptionBuff = $"Projectile burn"
				descriptionDebuff = $"{toPercent(newStats[0].value)}% damage"
				
				projectileBuffApply = function(proj)
				{
					array_push(proj.effects, EFFECT.burn)
					proj.damageMultiplier *= newStats[0].value
				}
				
				break
			
	
			// RARE ---------------------------------------------------------------
	
			case BUFF.dualWield:

				rarity = RARITY.rare
		
				descriptionNeutralEffect = $"DUAL WIELD"
		
				characterBuffApply = function(player)
				{
					player.dualWield = true
				}
				
				break
				
				
			case BUFF.doubleBuff:

				rarity = RARITY.rare
		
				descriptionNeutralEffect = $"DOUBLE ALL EFFECTS"
		
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