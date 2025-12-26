function Range(minimum, maximum) constructor
{
	min_ = minimum
	max_ = maximum
	
	value = random_range(min_, max_)
	
	function rndmize() { value = random_range(min_, max_) }
	function rndmizeInt() { value = irandom_range(min_, max_) }
}

function iRange(minimum, maximum) constructor
{
	min_ = minimum
	max_ = maximum
	
	value = irandom_range(min_, max_)
	
	function rndmize() { value = irandom_range(min_, max_) }
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
	target = BUFF_TARGET.weapon
	
	buffRandomize = function(){ show_debug_message("Buff initiazation and randomization is undefined!") }
	buffApply = function(){ show_debug_message("Buff function is undefined!") }
}

function GetBuffIndex(rarity)
{
	var start_ = 0
	if (rarity != 0) start_ = oController.buffRarityIndexes[rarity-1] + 1
	var end_ = oController.buffRarityIndexes[rarity] - 1
	return irandom_range(start_, end_)
}

function EvaluateWeaponBuffs()
{
	with (oPlayer)
	{
		for (var slot = 0; slot < inventorySize; slot++)
		{
			// Reset weapon stats to default
			var myWeaponID = weaponInventory[slot].index
			weaponInventory[slot] = acquireWeapon(myWeaponID, id, weaponInventory[slot].active)
			
			// Apply buffs
			for (var j = 0; j < array_length(weaponBuffs); j++)
			{
				weaponBuffs[j].buffApply(weaponInventory[slot])
			}
		}
	}
}

function EvaluatePlayerBuffs()
{
	with (oPlayer)
	{	
		// Reset to default stats
		InitPlayerStats()
		
		// Apply buffs
		for (var j = 0; j < array_length(playerBuffs); j++)
		{
			playerBuffs[j].buffApply(-1)
		}
		
		walkSpdDef = min(walkSpdDef, TILE_SIZE)
		walkSpdSprint = min(walkSpdSprint, TILE_SIZE)
		walkSpd = walkSpdDef
	}
}