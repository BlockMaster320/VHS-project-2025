function Range(minimum, maximum) constructor
{
	min_ = minimum
	max_ = maximum
	
	value = random_range(min_, max_)
	
	function rndmize() { value = random_range(min_, max_) }
	function rndmizeInt() { value = irandom_range(min_, max_) }
}

function Cooldown(defaultVal_) constructor
{
	valueDef = defaultVal_
	value = defaultVal_

	function reset() { value = valueDef }
}

function Buff() constructor
{
	sprite = sPlaceholderBuff
	descriptionBuff = "default"	// Don't change the default unless you have a good reason to
	descriptionDebuff = "default"
	descriptionNeutralEffect = "default"
	rarity = RARITY.common
	
	buffRandomize = function(){ show_debug_message("Buff initiazation and randomization is undefined!") }
	buffApply = function(){ show_debug_message("Buff function is undefined!") }
}

function GetBuffIndex(rarity)
{
	//var start_ = 0
	//if (rarity != 0) start_ = oController.rarityIndexes[rarity-1]
	//var end_ = oController.rarityIndexes[rarity] - 1
	//return irandom_range(start_, end_)
	
	var start_ = 0
	if (rarity != 0) start_ = oController.buffRarityIndexes[rarity-1] + 1
	var end_ = oController.buffRarityIndexes[rarity] - 1
	return irandom_range(start_, end_)
}

function EvaluateBuffEffects()
{
	with (oPlayer)
	{
		for (var slot = 0; slot < INVENTORY_SIZE; slot++)
		{
			// Reset weapon stats to default
			var myWeaponID = weaponInventory[slot].index
			weaponInventory[slot] = acquireWeapon(myWeaponID, id, weaponInventory[slot].active)
			
			// Apply buffs
			for (var j = 0; j < array_length(activeBuffs); j++)
			{
				activeBuffs[j].buffApply(weaponInventory[slot])
			}
		}
		
		// Multiple buff implementation
		//var myWeaponID = weaponInventory[slotID].index
		//weaponInventory[slotID] = acquireWeapon(myWeaponID, id)
		//for (var i = 0; i < array_length(buffsInventory[slotID]); i++)
		//{
		//	buffsInventory[slotID][i].buffApply(weaponInventory[slotID])
		//}
	}
}