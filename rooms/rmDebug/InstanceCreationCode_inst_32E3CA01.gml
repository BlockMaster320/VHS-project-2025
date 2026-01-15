image_alpha = 0
weapons = []

function spawnWeapons()
{
	for (var i = 0; i < WEAPON_AMOUNT; i++)
	{
		var rowAmount = 6
		var xx = x + 30 * (i mod rowAmount)
		var yy = y + 40 * (i div rowAmount)
		var weapon = instance_create_layer(xx, yy, "Instances", oWeaponPickup)
		weapon.setupWeaponPickup(i)
		if (instance_exists(weapon))
			array_push(weapons, weapon)
	}
}

spawnWeapons()

function destroyWeapons()
{
	for (var i = 0; i < array_length(weapons); i++)
	{
		if (instance_exists(weapons[i]))
		{
			instance_destroy(weapons[i])
		}
	}
}

stepFunc = function()
{
	for (var i = 0; i < array_length(weapons); i++)
	{
		if (!instance_exists(weapons[i]))
		{
			destroyWeapons()
			weapons = []
			spawnWeapons()
			break
		}
	}
}