//var dt = delta_time / 1000000 * 60

#region Walking

var walkDir = point_direction(0, 0, oController.right - oController.left, oController.down - oController.up)
whsp = lengthdir_x(walkSpd * global.gameSpeed, walkDir) * sign(oController.right + oController.left)
wvsp = lengthdir_y(walkSpd * global.gameSpeed, walkDir) * sign(oController.down + oController.up)

#endregion


#region Evaluate collisions and position

// Evaluate momentum
hsp = whsp
vsp = wvsp

if (y < 120) room_goto(rmGame)

/// Tilemap collisions

// Horizontal
if (place_meeting(x + hsp, y, global.tilemapCollision))
{
	while (!place_meeting(x + sign(hsp), y, global.tilemapCollision)) x += sign(hsp)
	x = round(x)
	hsp = 0;
}
x += hsp


// Vertical
if (place_meeting(x, y + vsp, global.tilemapCollision))
{
	while (!place_meeting(x, y + sign(vsp), global.tilemapCollision)) y += sign(vsp)
	y = round(y)
	vsp = 0;
}
y += vsp

#endregion


#region Weapon Inventory

// Swap active inventory slot
if (oController.swapSlot or oController.scrollSlot != 0)
{
	weaponInventory[activeInventorySlot].active = false
	activeInventorySlot = !activeInventorySlot
	weaponInventory[activeInventorySlot].active = true
}

if (oController.interact)
{
	// Weapon pickup
	var weaponPickup = instance_place(x, y, oWeaponPickup)
	if (weaponPickup and weaponPickup.myWeapon != -1)
	{
		weaponInventory[activeInventorySlot] = acquireWeapon(weaponPickup.myWeapon, id)
		EvaluateBuffEffects(activeInventorySlot)
		instance_destroy(weaponPickup)
	}
	
	// Buff pickup
	var buffPickup = instance_place(x, y, oBuffPickup)
	if (buffPickup and buffPickup.myBuff != -1)
	{
		array_push(buffsInventory[activeInventorySlot], buffPickup.myBuff)
		EvaluateBuffEffects(activeInventorySlot)
		instance_destroy(buffPickup)
	}
}

// Update weapons
for (var i = 0; i < INVENTORY_SIZE; i++)
	weaponInventory[i].update()

#endregion


// Debug
if (keyboard_check(ord("R"))) game_restart()

playerController.step()
