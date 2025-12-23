enum RARITY
{
	common, rare, length
}

function BuffsInit()
{
	enum BUFF
	{
		// Common
		blast, cloner,
		
		// Rare
		testRare,
		
		// --------------
		length
	}
	
	#macro BUFF_AMOUNT BUFF.length
	
	global.buffDatabase = array_create(BUFF_AMOUNT)
	for (var i = 0; i < BUFF_AMOUNT; i++)
		global.buffDatabase[i] = new Buff()
		
	// Content --------------------------------------------------
	
	// COMMON
	
	with (global.buffDatabase[BUFF.blast])
	{
		rarity = RARITY.common
		dmgMultRange = new Range(3, 5)
		attackSpdMultRange = new Range(.3, .6)
		
		buffRandomize = function()
		{
			dmgMultRange.rndmize()
			attackSpdMultRange.rndmize()
			descriptionBuff = $"{dmgMultRange.value}% damage"
			descriptionDebuff = $"{attackSpdMultRange.value}% attack speed"
		}
		
		buffApply = function(weapon)
		{
			weapon.projectile.damageMultiplier = dmgMultRange.value
			weapon.attackSpeed *= attackSpdMultRange.value
		}
	}
	
	with (global.buffDatabase[BUFF.cloner])
	{
		rarity = RARITY.common
		projAmountMultRange = new Range(2, 4)
		spreadMultRange = new Range(40, 60)
		
		buffRandomize = function()
		{
			projAmountMultRange.rndmize()
			spreadMultRange.rndmize()
			descriptionBuff = $"{projAmountMultRange.value}x projectile amount"
			descriptionDebuff = $"{spreadMultRange.value}% spread"
		}
		
		buffApply = function(weapon)
		{
			weapon.projectileAmount *= projAmountMultRange.value
			weapon.spread += spreadMultRange.value
		}
	}
	
	// RARE
	
	with (global.buffDatabase[BUFF.testRare])
	{
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
	}
	
	// -----------------------------------------------------------
	
	// Rarity system:
	//     common common common rare rare -> rarityIndexes[common] = 3
	//     At least one of each rarity must exist for this to work!
	
	global.buffDatabaseSorted = []
	array_copy(global.buffDatabaseSorted, 0, global.buffDatabase, 0, array_length(global.buffDatabase))
	array_sort(global.buffDatabaseSorted, function(a, b){ return a.rarity - b.rarity })
	rarityIndexes = []
	for (var i = 0; i < array_length(global.buffDatabaseSorted)-1; i++)
	{
		if (global.buffDatabaseSorted[i].rarity != global.buffDatabaseSorted[i+1].rarity)
			array_push(rarityIndexes, i)
	}
}