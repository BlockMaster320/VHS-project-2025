// Spawn enemy spawning buttons

for (var i = CHARACTER_TYPE.enemyStartID+1; i < CHARACTER_TYPE.enemyEndID; i++)
{
	var xx = x + (i-CHARACTER_TYPE.enemyStartID-1)*90
	var button = instance_create_layer(xx, y, "Instances", oCustomInteractable)
	with (button)
	{
		spawnXmin = other.x
		spawnXmax = other.x + 500
		spawnYmin = other.y + 20
		spawnYmax = other.y + 170
		enemyType = i
		
		// Cruel hack to get the enemy name
		var enemyTemp = instance_create_layer(0, 0, "Instances", oEnemy)
		with (enemyTemp) characterCreate(other.enemyType)
		label = string(enemyTemp.name)
		instance_destroy(enemyTemp)
		
		// Set interact behaviour
		interactFunc = function()
		{
			var spawnX = random_range(spawnXmin, spawnXmax)
			var spawnY = random_range(spawnYmin, spawnYmax)
			var enemy = instance_create_layer(spawnX, spawnY, "Instances", oEnemy)
			with (enemy)
			{
				characterCreate(other.enemyType)
				while (place_meeting(x, y, global.tilemapCollision))
				{
					x = random_range(other.spawnXmin, other.spawnXmax)
					y = random_range(other.spawnYmin, other.spawnYmax)
				}
			}
		}
	}
}

instance_destroy()