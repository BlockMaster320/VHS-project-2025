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
	var newSlot = (activeInventorySlot + inventorySize + oController.swapSlot + oController.scrollSlot) mod inventorySize
	SwapSlot(newSlot)
}
	
function SwapSlot(newSlot)
{
	weaponInventory[activeInventorySlot].active = false
	activeInventorySlot = clamp(newSlot, 0, inventorySize)
	if (tempWeaponSlot.active != true and inventorySize > 0)
		weaponInventory[activeInventorySlot].active = true
}

if (oController.interact)
{
	// Weapon pickup
	var weaponPickup = instanceInRange(oWeaponPickup, PICKUP_DISTANCE)
	if (weaponPickup and weaponPickup.myWeapon != -1)
	{
		var pitch = random_range(.7, 1.6)
		audio_play_sound(sndPickup, 0, false, 1, 0, pitch)
		
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
			weaponInventory[activeInventorySlot].destroy()
			var myWeaponID = weaponInventory[activeInventorySlot].index
			if (myWeaponID != WEAPON.fists and room != rmDebug)
				dropWeapon(myWeaponID, weaponInventory[activeInventorySlot].remainingDurability)
		
			// Get new weapon
			var activateWeapon = tempWeaponSlot.index == WEAPON.fists // Don't swap to it when holding one-time use weapon
			weaponInventory[activeInventorySlot].destroy()
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
		if (buffPickup.myBuff.buffType == BUFF.doubleBuff)
			array_insert(buffs, 0, buffPickup.myBuff)
		else
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
	{
		interactable.interactFunc()
		audio_play_sound(sndClick, 0, false, 1, 0, random_range(.8, 1.2))
		interactable.hitFlash()
	}
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
	for (var i = 0; i < max(inventorySize,1); i++)
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
