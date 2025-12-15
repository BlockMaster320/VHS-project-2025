//var dt = delta_time / 1000000 * 60

#region Walking

var walkDir = point_direction(0, 0, oController.right - oController.left, oController.down - oController.up)
whsp = lengthdir_x(walkSpd, walkDir) * sign(oController.right + oController.left)
wvsp = lengthdir_y(walkSpd, walkDir) * sign(oController.down + oController.up)

#endregion


// Evaluate generic character movement
event_inherited()


#region Weapon Inventory

// Swap active inventory slot
if (oController.swapSlot or oController.scrollSlot != 0)
{
	weaponInventory[activeInventorySlot].active = false
	activeInventorySlot = !activeInventorySlot
	if (tempWeaponSlot.active != true)
		weaponInventory[activeInventorySlot].active = true
}

if (oController.interact)
{
	// Weapon pickup
	var weaponPickup = instance_place(x, y, oWeaponPickup)
	if (weaponPickup and weaponPickup.myWeapon != -1)
	{
		if (weaponPickup.myWeapon.oneTimeUse)
		{
			// Deactivate current slot
			weaponInventory[activeInventorySlot].active = false
			
			// Use the temporary slot
			tempWeaponSlot = acquireWeapon(weaponPickup.myWeapon, id)
			EvaluateBuffEffects()
			instance_destroy(weaponPickup)
		}
		else
		{
			// Drop current weapon
			var myWeaponID = weaponInventory[activeInventorySlot].index
			if (myWeaponID != WEAPON.fists)
				dropWeapon(myWeaponID)
		
			// Get new weapon
			weaponInventory[activeInventorySlot] = acquireWeapon(weaponPickup.myWeapon, id)
			EvaluateBuffEffects()
			instance_destroy(weaponPickup)
		}
	}
	
	// Buff pickup
	var buffPickup = instance_place(x, y, oBuffPickup)
	if (buffPickup and buffPickup.myBuff != -1)
	{
		//array_push(buffsInventory[activeInventorySlot], buffPickup.myBuff)
		array_push(activeBuffs, buffPickup.myBuff)
		EvaluateBuffEffects()
		instance_destroy(buffPickup)
	}
}

// Update weapons
if (global.gameSpeed > .0001)
{
	for (var i = 0; i < INVENTORY_SIZE; i++)
		weaponInventory[i].update()
	tempWeaponSlot.update()
}

#endregion

// Debug
if (keyboard_check(ord("R"))) game_restart()
