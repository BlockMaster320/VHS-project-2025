myWeapon = -1

function setupWeaponPickup(weaponID)
{
	myWeapon = json_parse(global.weaponListJSON[weaponID])
	sprite_index = myWeapon.sprite
}