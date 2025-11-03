myWeapon = -1

function setupWeaponPickup(weaponID)
{
	myWeapon = json_parse(global.weaponDatabaseJSON[weaponID])
	sprite_index = myWeapon.sprite
}