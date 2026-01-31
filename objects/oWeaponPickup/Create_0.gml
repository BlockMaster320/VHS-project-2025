myWeapon = -1
remainingDurability = -1

function setupWeaponPickup(weaponID, remainingDurability_=-1)
{
	myWeapon = json_parse(global.weaponDatabaseJSON[weaponID])
	if (remainingDurability_ != -1)
		remainingDurability = remainingDurability_
	sprite_index = myWeapon.sprite
}

// Rat
animIndex = 0;