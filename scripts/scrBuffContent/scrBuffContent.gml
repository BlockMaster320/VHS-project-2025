enum RARITY
{
	common, rare, length
}

function BuffsInit()
{
	#macro BUFF_AMOUNT 2
	
	global.buffDatabase = array_create(BUFF_AMOUNT, new Weapon())
	
	global.buffDatabase = array_create(BUFF_AMOUNT)
	for (var i = 0; i < BUFF_AMOUNT; i++)
		global.buffDatabase[i] = new Buff()
		
	// Content --------------------------------------------------
	
	with (global.buffDatabase[0])
	{
		rarity = RARITY.common
		dmgMultRange = new Range(5, 7)
		
		buffRandomize = function()
		{
			dmgMultRange.rndmize()
			descriptionBuff = $"deal {dmgMultRange.value}% damage"
			descriptionDebuff = $"Amogus"
		}
		
		buffActivate = function(weapon)
		{
			weapon.projectile.damageMultiplier = dmgMultRange.value
			weapon.projectile.sprite = sPlaceholderGun
		}
	}
	
	with (global.buffDatabase[1])
	{
		rarity = RARITY.rare
		dmgMultRange = new Range(10, 15)
		
		buffRandomize = function()
		{
			dmgMultRange.rndmize()
			descriptionBuff = $"deal {dmgMultRange.value}% damage"
			descriptionDebuff = $"Amogus"
		}
		
		buffActivate = function(weapon)
		{
			weapon.damageMultiplier = dmgMultRange.value
		}
	}
	
	// -----------------------------------------------------------
	
	// Rarity system:
	//     common common common rare rare -> rarityIndexes[common] = 3
	//     At least one of each rarity must exist for this to work!
	array_sort(global.buffDatabase, function(a, b){ return a.rarity - b.rarity })
	rarityIndexes = []
	for (var i = 0; i < array_length(global.buffDatabase)-1; i++)
	{
		if (global.buffDatabase[i].rarity != global.buffDatabase[i+1].rarity)
			array_push(rarityIndexes, i)
	}
}