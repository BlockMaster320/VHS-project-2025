enum RARITY
{
	common, rare, length
}

function BuffsInit()
{
	#macro BUFF_AMOUNT 2
	
	var buffList = array_create(BUFF_AMOUNT, new Weapon())
	
	buffList = array_create(BUFF_AMOUNT)
	for (var i = 0; i < BUFF_AMOUNT; i++)
		buffList[i] = new Buff()
		
	// Content --------------------------------------------------
	
	with (buffList[0])
	{
		dmgMultRange = new Range(5, 7)
		
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
	
	// common common common rare rare -> rarityIndexes[common] = 3
	// At least one of each rarity must exist!!!
	array_sort(buffList, function(a, b){ return a.rarity - b.rarity })
	rarityIndexes = []
	for (var i = 0; i < array_length(buffList)-1; i++)
	{
		if (buffList[i].rarity != buffList[i+1].rarity)
			array_push(rarityIndexes, i)
	}
		
	// Compile into JSON for easy copying
	global.buffsJSON = array_create(WEAPON_AMOUNT)
	for (var i = 0; i < WEAPON_AMOUNT; i++)
	{
		buffList[i].index = i
		global.buffsJSON[i] = json_stringify(buffList[i], false)
	}
}