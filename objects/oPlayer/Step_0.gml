//var dt = delta_time / 1000000 * 60

#region Walking

var walkDir = point_direction(0, 0, oController.right - oController.left, oController.down - oController.up)
whsp = lengthdir_x(walkSpd, walkDir) * sign(oController.right + oController.left)
wvsp = lengthdir_y(walkSpd, walkDir) * sign(oController.down + oController.up)

#endregion


// Evaluate generic character movement
event_inherited()

#region Weapon interaction

// Swap active inventory slot
if (oController.swapSlot or oController.scrollSlot != 0)
{
	weaponInventory[activeInventorySlot].active = false
	activeInventorySlot = (activeInventorySlot + inventorySize + oController.swapSlot + oController.scrollSlot) mod inventorySize
	if (tempWeaponSlot.active != true)
		weaponInventory[activeInventorySlot].active = true
}

if (oController.interact)
{
	// Weapon pickup
	var weaponPickup = instanceInRange(oWeaponPickup, PICKUP_DISTANCE)
	if (weaponPickup and weaponPickup.myWeapon != -1)
	{
		if (weaponPickup.myWeapon.oneTimeUse)	// One time use weapons
		{
			// Deactivate current slot
			weaponInventory[activeInventorySlot].active = false
			
			// Use the temporary slot
			tempWeaponSlot = acquireWeapon(weaponPickup.myWeapon, id)
			EvaluateOneTimeUseBuffs()
			instance_destroy(weaponPickup)
		}
		else									// Inventory slot weapons
		{
			// Drop current weapon
			var myWeaponID = weaponInventory[activeInventorySlot].index
			if (myWeaponID != WEAPON.fists and room != rmDebug)
				dropWeapon(myWeaponID, weaponInventory[activeInventorySlot].remainingDurability)
		
			// Get new weapon
			var activateWeapon = tempWeaponSlot.index == WEAPON.fists // Don't swap to it when holding one-time use weapon
			weaponInventory[activeInventorySlot] = acquireWeapon(weaponPickup.myWeapon, id, activateWeapon, weaponPickup.remainingDurability)
			weaponInventory[activeInventorySlot].playerInventorySlot = activeInventorySlot
			EvaluateWeaponBuffs()
			instance_destroy(weaponPickup)
		}
	}
	
	// Buff pickup
	var buffPickup = instanceInRange(oBuffPickup, PICKUP_DISTANCE)
	if (buffPickup and buffPickup.myBuff != -1)
	{
		//array_push(buffsInventory[activeInventorySlot], buffPickup.myBuff)
		array_push(buffs, buffPickup.myBuff)
		EvaluatePlayerBuffs()	// Order here might matter!
		EvaluateWeaponBuffs()
		EvaluateOneTimeUseBuffs()
		instance_destroy(buffPickup)
	}
}


// Custom interactable interact
var interactable = instanceInRange(oCustomInteractable, PICKUP_DISTANCE)
if (interactable)
{
	interactable.alpha = 1
	if (oController.interact)
		interactable.interactFunc()
}
	
// -----------------------

// Update weapons
if (dualWield)
{
	for (var i = 0; i < inventorySize; i++)
		weaponInventory[i].active = true
}
if (global.gameSpeed > .0001)
{
	for (var i = 0; i < inventorySize; i++)
		weaponInventory[i].update()
	tempWeaponSlot.update()
}

#endregion

// Debug
if (keyboard_check_pressed(ord("K"))) {
	hp = 0
	onDeathEvent()
}
if (keyboard_check(ord("T"))) game_restart()
