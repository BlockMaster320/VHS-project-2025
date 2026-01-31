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
	sprite = sBuff
	descriptionBuff = ""	// Don't change the default unless you have a good reason to
	descriptionDebuff = ""
	descriptionNeutralEffect = ""
	rarity = RARITY.common
	target = BUFF_TARGET.weapon
	
	//buffRandomize = function(){ show_debug_message("Buff initiazation and randomization is undefined!") }
	weaponBuffApply = function(weapon){  }
	projectileBuffApply = function(projectile){  }
	characterBuffApply = function(character){  }
}

function GetBuffIndex(rarity)
{
	var start_ = 0
	if (rarity != 0) start_ = oController.buffRarityIndexes[rarity-1] + 1
	var end_ = oController.buffRarityIndexes[rarity] - 1
	return irandom_range(start_, end_)
}

function applyWeaponBuff(weapon, buff)
{
	buff.weaponBuffApply(weapon)
				
	var proj = weapon.projectile
	while (proj != noone)
	{
		buff.projectileBuffApply(proj)
		proj = proj.projectileChild
	}
}

function EvaluateWeaponBuffs()
{
	with (oPlayer)
	{
		for (var slot = 0; slot < inventorySize; slot++)
		{
			// Reset weapon stats to default
			var myWeaponID = weaponInventory[slot].index
			var durability = weaponInventory[slot].remainingDurability
			weaponInventory[slot].destroy()
			weaponInventory[slot] = acquireWeapon(myWeaponID, id, weaponInventory[slot].active, durability)
			weaponInventory[slot].playerInventorySlot = slot
			
			// Apply buffs
			repeat (buffApplyAmount)
				for (var j = 0; j < array_length(buffs); j++)
				{
					applyWeaponBuff(weaponInventory[slot], buffs[j])
				}
		}
	}
}

function EvaluateOneTimeUseBuffs()
{
	with (oPlayer)
	{
		// Reset weapon stats to default
		var myWeaponID = tempWeaponSlot.index
		tempWeaponSlot.destroy()
		tempWeaponSlot = acquireWeapon(myWeaponID, id, myWeaponID != WEAPON.fists)
			
		// Apply buffs
		repeat (buffApplyAmount)
			for (var j = 0; j < array_length(buffs); j++)
			{
				applyWeaponBuff(tempWeaponSlot, buffs[j])
			}
	}
}

function EvaluatePlayerBuffs()
{
	with (oPlayer)
	{
		var prevHP = hp
		
		// Reset to default stats
		InitPlayerStats()
		
		hp = prevHP
		
		// Apply buffs
		for (var j = 0; j < array_length(buffs); j++)
		{
			var applyAmount = buffApplyAmount
			if (buffs[j].buffType == BUFF.doubleBuff) applyAmount = 1
			repeat (applyAmount)
				buffs[j].characterBuffApply(id)
		}
			
		if (inventorySize < 1)
			weaponInventory[0] = acquireWeapon(WEAPON.fists, id, true)
			
		walkSpdDef = min(walkSpdDef, TILE_SIZE)
		walkSpdSprint = min(walkSpdSprint, TILE_SIZE)
		if (room != rmDebug)
			walkSpd = walkSpdSprint
	}
}