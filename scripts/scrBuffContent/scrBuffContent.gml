enum RARITY
{
	common, rare, length
}

enum BUFF
{
	// Common
	blast, cloner,
	commonIndex,	// Dummy buff for rarity indexing

	// Rare
	testRare,
	rareIndex,	// Dummy buff for rarity indexing
	
	// --------------
	length
}

function BuffCreate(buffType_)
{
	//#macro BUFF_AMOUNT BUFF.length
	
	//global.buffDatabase = array_create(BUFF_AMOUNT)
	//for (var i = 0; i < BUFF_AMOUNT; i++)
	//	global.buffDatabase[i] = new Buff()
		
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
				dmgMultRange = new Range(3, 5)
				attackSpdMultRange = new Range(.3, .6)
		
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
	
	// -----------------------------------------------------------
	
	// Rarity system:
	//     common common common rare rare -> rarityIndexes[common] = 3
	//     At least one of each rarity must exist for this to work!
	
	//global.buffDatabaseSorted = []
	//array_copy(global.buffDatabaseSorted, 0, global.buffDatabase, 0, array_length(global.buffDatabase))
	//array_sort(global.buffDatabaseSorted, function(a, b){ return a.rarity - b.rarity })
	//rarityIndexes = []
	//for (var i = 0; i < array_length(global.buffDatabaseSorted)-1; i++)
	//{
	//	if (global.buffDatabaseSorted[i].rarity != global.buffDatabaseSorted[i+1].rarity)
	//		array_push(rarityIndexes, i)
	//}
}