image_alpha = 0
buffs = []

function spawnBuffs()
{
	for (var i = 0; i < BUFF.length; i++)
	{
		var rowAmount = 2
		var xx = x + 70 * (i mod rowAmount)
		var yy = y + 60 * (i div rowAmount)
		var buff = instance_create_layer(xx, yy, "Instances", oBuffPickup)
		buff.setupBuffPickupID(i)
		if (instance_exists(buff))
			array_push(buffs, buff)
	}
}

spawnBuffs()

function destroyBuffs()
{
	for (var i = 0; i < array_length(buffs); i++)
	{
		if (instance_exists(buffs[i]))
		{
			instance_destroy(buffs[i])
		}
	}
}

stepFunc = function()
{
	for (var i = 0; i < array_length(buffs); i++)
	{
		if (!instance_exists(buffs[i]))
		{
			destroyBuffs()
			buffs = []
			spawnBuffs()
			break
		}
	}
}